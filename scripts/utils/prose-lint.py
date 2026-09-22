#!/usr/bin/env python3
"""Prose lint + tic audit for the house style.

Merges the tell lists from the writing root's CLAUDE.md (Craft & House Style)
and the Dec-2025 prose-tells.md. Two kinds of rule:

  RATE  - the construction is fine occasionally, slop at volume. Scored per
          10k words against a budget. The human signature is the variance,
          not the technique.
  FLAG  - should be ~zero. Every hit is listed.

Output is a triage queue, not a verdict. Candidate regexes over-match on
purpose: turning 100k words into 300 lines to eyeball is the whole win.

Run from a project root (it reads ./scenes), or pass a scenes dir / one file.

    prose-lint.py                          # corpus summary, worst scenes first
    prose-lint.py --rule simile_of_manner  # the triage queue for one tell
    prose-lint.py --scene 031              # one scene, every hit
    prose-lint.py --ngrams                 # THE TIC AUDIT: 3-5 word phrases
                                           #   repeated 10+ times across 8+ scenes
    prose-lint.py --selftest
"""

import argparse
import bisect
import json
import re
import sys
from pathlib import Path

DEFAULT_SCENES = Path("scenes")

# Annotation tags (CLAUDE.md write/edit flow). Instructions, not prose - drop
# tag AND content. <add>/<keep> wrap real prose: drop the tags, keep the words.
TAGS_DROP_CONTENT = ("brief", "cut", "change", "flow", "q")
TAGS_DROP_MARKUP = ("add", "keep")

# "the way" used as a literal path, not a simile of manner.
LITERAL_WAY = re.compile(
    r"\b(?:on|all|by|along|under|led|make[s]?|made|found|knew|know|lost)\s+the\s+way\b"
    r"|\bthe\s+way\s+(?:home|back|out|in|up|down|to|through|past|there|here)\b",
    re.I,
)

RATE_RULES = {
    # CLAUDE.md: the signature tell. Ration hard - keep ~20%.
    "simile_of_manner": (re.compile(r"\bthe way\b", re.I), 4.0),
    "simile_generic": (re.compile(r"\blike a[n]?\b|\bas if\b|\bas though\b", re.I), 6.0),
    "verbosity_padding": (
        re.compile(
            r"\b(?:began to|started to|for a moment|for a while|a little|somehow"
            r"|somewhat|rather |a kind of|a sort of|seemed to"
            r"|made (?:him|her|them)self)\b",
            re.I,
        ),
        8.0,
    ),
    # prose-tells.md 11: said is invisible.
    "adverb_speech": (
        re.compile(r"\b(?:said|asked|replied|answered|added)\s+\w+ly\b", re.I),
        2.0,
    ),
    "said_substitute": (
        re.compile(
            r"\b(?:hissed|retorted|demanded|snapped|growled|breathed|murmured"
            r"|interjected|exclaimed|countered|offered)\b",
            re.I,
        ),
        2.0,
    ),
    # NOT HERE: adjective_stacking (prose-tells.md 1). "The vast, crimson sky"
    # is two adjectives before a noun; "her stomach, heavy and tight" is a
    # trailing modifier and fine. Telling them apart needs POS tagging - every
    # regex I tried scored 100% false positives. Left to the LLM pass.
}

FLAG_RULES = {
    # prose-tells.md 12: the theme is IN the action, not announced.
    "theme_announcement": re.compile(
        r"\bin that moment\b|\b(?:he|she|they)\s+(?:realized|realised|understood)\s+that\b"
        r"|\bwhat it (?:meant|was) to be\b",
        re.I,
    ),
    # prose-tells.md 7: which memories? what past?
    "vague_interiority": re.compile(
        r"\bmemories (?:flooded|came rushing|washed)\b|\bhaunted by\b"
        r"|\ba past that\b|\bsomething (?:he|she|they) could not name\b",
        re.I,
    ),
    # CLAUDE.md: retired colour-crutch, one origin use allowed (007).
    "weak_tea": re.compile(r"colou?r of weak tea", re.I),
}

# Percentage thresholds, scored separately.
LONG_SENTENCE_WORDS = 20
LONG_SENTENCE_PCT = 25.0
EM_DASH_PARA_PCT = 10.0
WEATHER_OPENER_WORDS = 60
WEATHER = re.compile(
    r"\b(?:rain|thunder|storm|wind|sky|monsoon|drizzle|clouds?|sunlight|heat)\b", re.I
)
# CLAUDE.md: pans out to tie threads together on the way out.
BOWTIE = re.compile(
    r"^(?:far to the|somewhere|neither|both of them|elsewhere|and so)\b"
    r"|\band that\b.*\band that\b",
    re.I,
)


def clean(text):
    """Blank out non-prose, preserving line numbers. Returns list of lines."""
    lines = text.split("\n")

    # Scene layout: metadata / --- / prose / --- / Notes + commentary.
    # With two rules, only the span between them is prose. Otherwise fall
    # back to blanking from the first '## ' heading to EOF.
    rules = [i for i, l in enumerate(lines) if l.strip() == "---"]
    if len(rules) >= 2:
        a, b = rules[0], rules[1]
        lines = [l if a < i < b else "" for i, l in enumerate(lines)]
    else:
        for i, line in enumerate(lines):
            if line.startswith("## "):
                lines[i:] = [""] * (len(lines) - i)
                break

    body = "\n".join(lines)

    for tag in TAGS_DROP_CONTENT:
        # Blank the span but keep its newlines so numbering survives.
        body = re.sub(
            rf"<{tag}>.*?</{tag}>",
            lambda m: "\n" * m.group(0).count("\n"),
            body,
            flags=re.S | re.I,
        )
    for tag in TAGS_DROP_MARKUP:
        body = re.sub(rf"</?{tag}>", "", body, flags=re.I)

    out = []
    for line in body.split("\n"):
        s = line.strip()
        # Scene header, POV/Location/Time metadata, hrules.
        if s.startswith("#") or s.startswith("---") or re.match(r"^\*\*\w+\*\*:", s):
            out.append("")
            continue
        # House-style rules govern narration; dialogue is character voice.
        out.append(re.sub(r"[\"“][^\"”]*[\"”]", " ", line))
    return out


def analyse(path):
    lines = clean(path.read_text(encoding="utf-8"))
    prose = "\n".join(lines)
    words = len(prose.split())
    if not words:
        return None

    # Match over the whole text, not line by line, so a construction that
    # spans a line wrap is still caught. Map offset -> line for the queue.
    starts, pos = [], 0
    for line in lines:
        starts.append(pos)
        pos += len(line) + 1

    def locate(offset, span=0):
        """Line number, plus a context window centred on the match itself -
        these paragraphs are one long line, so line-start context misses it."""
        n = bisect.bisect_right(starts, offset) - 1
        line, col = lines[n], offset - starts[n]
        a, b = max(0, col - 48), min(len(line), col + span + 48)
        ctx = ("..." if a else "") + line[a:b].strip() + ("..." if b < len(line) else "")
        return n + 1, ctx

    # "the way home" is a path, not a simile. Skip matches inside those spans.
    literal = [m.span() for m in LITERAL_WAY.finditer(prose)]

    def is_literal(offset):
        return any(a <= offset < b for a, b in literal)

    hits = {}
    for name, (pattern, _) in RATE_RULES.items():
        found = []
        for m in pattern.finditer(prose):
            if name == "simile_of_manner" and is_literal(m.start()):
                continue
            n, ctx = locate(m.start(), len(m.group(0)))
            found.append((n, m.group(0), ctx))
        hits[name] = found
    for name, pattern in FLAG_RULES.items():
        found = []
        for m in pattern.finditer(prose):
            n, ctx = locate(m.start(), len(m.group(0)))
            found.append((n, m.group(0), ctx))
        hits[name] = found

    paras = [p for p in re.split(r"\n\s*\n", prose) if p.strip()]
    dashy = sum(1 for p in paras if p.count("—") > 1)

    sentences = [s for s in re.split(r"(?<=[.!?])\s+", prose) if s.strip()]
    longs = sum(1 for s in sentences if len(s.split()) > LONG_SENTENCE_WORDS)

    opener = " ".join(prose.split()[:WEATHER_OPENER_WORDS])
    last = paras[-1].strip() if paras else ""

    return {
        "scene": path.stem,
        "words": words,
        "hits": hits,
        "rates": {n: len(h) / words * 10000 for n, h in hits.items()},
        "long_sentence_pct": longs / len(sentences) * 100 if sentences else 0.0,
        "em_dash_para_pct": dashy / len(paras) * 100 if paras else 0.0,
        "purple_weather": bool(WEATHER.search(opener)),
        # Structure only. A word-count threshold flagged 63/72 scenes - the
        # paragraphs are simply long - which is noise, not signal.
        "bowtie": bool(BOWTIE.search(last)),
        "last_para": last[:200],
    }


def overage(r):
    """How far over budget this scene runs, summed across rate rules."""
    total = sum(max(0, r["rates"][n] - b) for n, (_, b) in RATE_RULES.items())
    total += sum(len(r["hits"][n]) * 5 for n in FLAG_RULES)
    total += max(0, r["long_sentence_pct"] - LONG_SENTENCE_PCT) / 4
    total += max(0, r["em_dash_para_pct"] - EM_DASH_PARA_PCT) / 4
    return total


def report(results):
    words = sum(r["words"] for r in results)
    print(f"\n{len(results)} scenes, {words:,} words of narration "
          f"(dialogue, notes and annotations excluded)\n")

    print(f"{'RATE RULE':<22}{'HITS':>7}{'/10k':>8}{'BUDGET':>8}{'OVER':>8}")
    print("-" * 53)
    for name, (_, budget) in RATE_RULES.items():
        n = sum(len(r["hits"][name]) for r in results)
        rate = n / words * 10000
        allowed = budget * words / 10000
        over = max(0, n - allowed)
        mark = "  <-- cut" if over else ""
        print(f"{name:<22}{n:>7}{rate:>8.1f}{budget:>8.1f}{over:>8.0f}{mark}")

    print(f"\n{'FLAG RULE':<22}{'HITS':>7}")
    print("-" * 29)
    for name in FLAG_RULES:
        print(f"{name:<22}{sum(len(r['hits'][name]) for r in results):>7}")

    lp = sum(r["long_sentence_pct"] * r["words"] for r in results) / words
    ep = sum(r["em_dash_para_pct"] * r["words"] for r in results) / words
    print(f"\n{'sentences >20 words':<22}{lp:>6.0f}%   budget {LONG_SENTENCE_PCT:.0f}%")
    print(f"{'paras >1 em-dash':<22}{ep:>6.0f}%   budget {EM_DASH_PARA_PCT:.0f}%")
    print(f"{'weather in opener':<22}{sum(1 for r in results if r['purple_weather']):>6}  scenes")
    print(f"{'bowtie candidates':<22}{sum(1 for r in results if r['bowtie']):>6}  scenes")

    ranked = sorted(results, key=overage, reverse=True)[:15]
    print(f"\nWORST 15 SCENES\n{'scene':<12}{'words':>7}{'score':>8}  top offenders")
    print("-" * 72)
    for r in ranked:
        worst = sorted(
            ((max(0, r["rates"][n] - b), n) for n, (_, b) in RATE_RULES.items()),
            reverse=True,
        )[:2]
        tags = ", ".join(n for o, n in worst if o > 0) or "-"
        print(f"{r['scene']:<12}{r['words']:>7}{overage(r):>8.0f}  {tags}")
    print("\n  --rule <name>   the triage queue for one tell")
    print("  --scene <NNN>   every hit in one scene\n")


def queue(results, rule):
    if rule not in RATE_RULES and rule not in FLAG_RULES:
        sys.exit(f"unknown rule: {rule}\n"
                 f"rate: {', '.join(RATE_RULES)}\nflag: {', '.join(FLAG_RULES)}")
    total = 0
    for r in results:
        if not r["hits"][rule]:
            continue
        print(f"\n{r['scene']}  ({len(r['hits'][rule])})")
        for n, match, ctx in r["hits"][rule]:
            print(f"  {n:>5}  [{match}]  {ctx}")
            total += 1
    budget = RATE_RULES[rule][1] if rule in RATE_RULES else 0
    words = sum(r["words"] for r in results)
    keep = budget * words / 10000
    print(f"\n{total} candidates. Budget {keep:.0f} -> cut about {max(0, total - keep):.0f}.")
    print("Keep the ones that are load-bearing and fresh. Cut the decorative ones.\n")


def detail(results, scene):
    match = [r for r in results if scene in r["scene"]]
    if not match:
        sys.exit(f"no scene matching {scene!r}")
    for r in match:
        print(f"\n{r['scene']}  -  {r['words']} words of narration")
        for name in list(RATE_RULES) + list(FLAG_RULES):
            if r["hits"][name]:
                budget = RATE_RULES[name][1] if name in RATE_RULES else 0.0
                print(f"\n  {name}  ({len(r['hits'][name])}, "
                      f"{r['rates'][name]:.1f}/10k, budget {budget:.1f})")
                for n, m, ctx in r["hits"][name]:
                    print(f"    {n:>5}  [{m}]  {ctx}")
        print(f"\n  sentences >20 words  {r['long_sentence_pct']:.0f}%")
        print(f"  paras >1 em-dash     {r['em_dash_para_pct']:.0f}%")
        if r["purple_weather"]:
            print("  ! weather in the opening 60 words")
        if r["bowtie"]:
            print(f"  ! bowtie candidate - last para:\n    {r['last_para']}")
        print()


NGRAM_SIZES = (3, 4, 5)
TOKEN = re.compile(r"[a-z']+")
# Phrases made only of these are grammar, not tics ("she did not", "it was
# the"). A phrase with one content word survives ("the one thing", "in the
# dark", "the old man") - that is where the superlative-designation tics live.
STOP = set("""a an the and or but of in on at to for with from by as it its he she they
him her his their them i you we me my your our was were is are be been being had
has have did do does not no that this these those there what which who whom out
up down into onto over all one could would should will can than then when where
so if about off back again still just very own same more most only other some
any each every both few much many such too now here how because while before
after until once through under between against during without within along
across around behind toward towards away like nothing something anything
everything""".split())


def ngram_counts(path):
    """Per-scene counts of every 3-5 word phrase in the narration."""
    prose = "\n".join(clean(path.read_text(encoding="utf-8")))
    counts = {}
    for para in re.split(r"\n\s*\n", prose):
        toks = TOKEN.findall(para.lower())
        for n in NGRAM_SIZES:
            for i in range(len(toks) - n + 1):
                g = " ".join(toks[i:i + n])
                counts[g] = counts.get(g, 0) + 1
    return counts


def ngrams(files, min_hits, min_scenes, show_all=False):
    """THE TIC AUDIT (CLAUDE.md): a phrase is invisible inside one scene and a
    tell across the book. List every 3-5 word phrase that recurs book-wide.
    The tic is the frequency, never the phrase - judgment stays with the
    author; this only finds the pattern."""
    total, spread = {}, {}
    for f in files:
        for g, c in ngram_counts(f).items():
            total[g] = total.get(g, 0) + c
            spread.setdefault(g, set()).add(f.stem)
    rows = [(g, c, len(spread[g])) for g, c in total.items()
            if c >= min_hits and len(spread[g]) >= min_scenes
            and (show_all or not all(t in STOP for t in g.split()))]
    # A 3-gram that only ever occurs inside a listed 4/5-gram is noise.
    longer = [g for g, _, _ in rows]
    rows = [r for r in rows
            if not any(r[0] != h and r[0] in h and total[h] == r[1] for h in longer)]
    rows.sort(key=lambda r: (-r[1], -r[2], r[0]))
    print(f"\n{len(rows)} phrases at {min_hits}+ hits across {min_scenes}+ scenes "
          f"({len(files)} scenes scanned)\n")
    print(f"{'HITS':>5} {'SCENES':>6}  PHRASE")
    for g, c, sc in rows:
        print(f"{c:>5} {sc:>6}  {g}")
    print("\nDefault ceiling is one per scene, doing work (a payoff, a closer, a creed).")
    print("Replacements must be plainer, never cleverer. Dialogue is exempt.")
    print("  --rule / --scene for the regex tells;  --min-hits N --min-scenes N to widen;")
    print("  --all to include phrases made only of function words.\n")


def selftest():
    import tempfile

    sample = """# Scene 999

**POV**: Test

---

He crossed the room the way a man crosses a minefield. She made herself
wait. "I walked the way you told me," she said quietly. The ancient,
weathered stone stood against the sky.

<q>is this working?</q>

<cut>He moved the way smoke moves.</cut>

He found the way home. In that moment, he realized that it was over.

## Notes

He moved the way water moves through a drain.
"""
    with tempfile.TemporaryDirectory() as d:
        p = Path(d) / "scene-999.md"
        p.write_text(sample)
        r = analyse(p)

    assert r is not None
    got = {n: len(h) for n, h in r["hits"].items()}
    # "the way a man crosses" counts; the "walked the way you told me" line is
    # inside dialogue; "found the way home" is a literal path; the <cut> and
    # <q> spans and the Notes section are all excluded.
    assert got["simile_of_manner"] == 1, got["simile_of_manner"]
    assert got["verbosity_padding"] == 1, got["verbosity_padding"]  # made herself
    assert got["adverb_speech"] == 1, got["adverb_speech"]  # said quietly
    assert got["theme_announcement"] == 2, got["theme_announcement"]
    assert got["weak_tea"] == 0
    assert "drain" not in "".join(x[2] for x in r["hits"]["simile_of_manner"])

    # Two-rule layout: commentary after the second --- is not prose.
    two = """# Scene 998

**POV**: Test

---

He moved the way smoke moves. He said it plainly.

---

**Register pass:** cut "the way water moves" and "the way a man walks".

**Notes**:
- he moved the way a cat moves
"""
    with tempfile.TemporaryDirectory() as d:
        p = Path(d) / "scene-998.md"
        p.write_text(two)
        r2 = analyse(p)
        assert len(r2["hits"]["simile_of_manner"]) == 1, r2["hits"]["simile_of_manner"]
        c = ngram_counts(p)
        assert c.get("he moved the way") == 1, c
        assert "way a cat" not in " ".join(c)
    print("selftest ok")


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("path", nargs="?", default=DEFAULT_SCENES, type=Path)
    ap.add_argument("--rule", help="list every candidate for one rule")
    ap.add_argument("--scene", help="every hit in one scene, e.g. 031")
    ap.add_argument("--ngrams", action="store_true",
                    help="the tic audit: 3-5 word phrases repeated book-wide")
    ap.add_argument("--min-hits", type=int, default=10)
    ap.add_argument("--min-scenes", type=int, default=8)
    ap.add_argument("--all", action="store_true", help="keep function-word-only phrases")
    ap.add_argument("--json", action="store_true")
    ap.add_argument("--selftest", action="store_true")
    a = ap.parse_args()

    if a.selftest:
        return selftest()

    files = sorted(a.path.glob("*.md")) if a.path.is_dir() else [a.path]
    if a.ngrams:
        return ngrams(files, a.min_hits, a.min_scenes, a.all)
    results = [r for r in (analyse(f) for f in files) if r]
    if not results:
        sys.exit(f"no prose found in {a.path}")

    if a.json:
        print(json.dumps(results, indent=2))
    elif a.rule:
        queue(results, a.rule)
    elif a.scene:
        detail(results, a.scene)
    else:
        report(results)


if __name__ == "__main__":
    main()
