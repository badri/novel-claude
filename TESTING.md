# Fiction Writer Plugin - Manual Testing Guide

This guide walks through testing all major features of the Fiction Writer plugin.

**Testing Environment:** `~/writing` directory

---

## Pre-Testing Setup

### 1. Install the Plugin

Right now uninstall, remove enabledPlugins, remove the marketplace and reinstall interactively. No other process works.

### 2. Set Up Testing Directory

```bash
# Create clean testing area
mkdir -p ~/writing/plugin-test
cd ~/writing/plugin-test
```

---

## Test 1: Plugin Installation & Command Availability

**Goal:** Verify plugin is installed and all commands are available

```bash
cd ~/writing/plugin-test
claude
```

Inside Claude, test command discovery:

```bash
# List all available commands (should show fiction writer commands)
/help

# Check if agent is available
/agents
# Should show "gemini-summarizer" in the list
```

**Expected Results:**
- ✓ All fiction writer commands appear (`/new-project`, `/new-scene`, `/brainstorm`, etc.)
- ✓ `gemini-summarizer` agent is listed
- ✓ No errors about missing files or directories

**Exit Claude:** `Ctrl+D` or type `/exit`

---

## Test 2: Project Creation (`/new-project`)

**Goal:** Verify project scaffolding creates correct structure with all templates

```bash
cd ~/writing
claude
```

Run the command:

```bash
/new-project
```

**Respond to prompts:**
- Project name: `test-mystery`
- Genre: `mystery`
- Story format: `novel`
- Premise: `A librarian discovers a century-old murder that mirrors recent events`

**After project creation, verify MCP setup:**

Exit Claude and run:

```bash
cd ~/writing/test-mystery
claude mcp add --transport stdio devrag --scope project -- /usr/local/bin/devrag --config .devrag/config.json
```

**Manual Verification:**

```bash
cd ~/writing/test-mystery

# Check directory structure
ls -la
# Should see: project.json, .devrag/config.json, .gitignore, .mcp.json, .claude/, scenes/, codex/, notes/, etc.

# Verify .claude/settings.json has hooks
cat .claude/settings.json | grep -E "SessionStart|SessionEnd|UserPromptSubmit"
# Should show all three hooks

# Verify hook script is executable
ls -la .claude/hooks/log-interaction.sh
# Should show -rwxr-xr-x permissions

# Check project.json content
cat project.json
# Should have: projectName: "test-mystery", genre: "mystery", premise: "A librarian..."

# Check .devrag/config.json was created from template
cat .devrag/config.json | grep "test-mystery"
# Should show project name

# Check .mcp.json was created
cat .mcp.json
# Should have devrag server configuration

# Check .gitignore has .devrag/ excluded
cat .gitignore | grep ".devrag"
# Should see .devrag/ in gitignore

# Verify empty directories with .gitkeep
ls scenes/drafts/
ls scenes/archive/
ls notes/session-interactions/
# All should have .gitkeep files
```

**Expected Results:**
- ✓ All directories created
- ✓ `project.json` has correct metadata
- ✓ `.devrag/config.json` created with project name substituted
- ✓ `.gitignore` created from template
- ✓ `.mcp.json` created with devrag configuration
- ✓ `.claude/settings.json` has SessionStart, SessionEnd, UserPromptSubmit hooks
- ✓ `.claude/hooks/log-interaction.sh` is executable
- ✓ All codex files exist (characters.md, locations.md, etc.)
- ✓ Initial brainstorm file created

---

## Test 3: Session Hooks (Auto Start/End)

**Goal:** Verify SessionStart and SessionEnd hooks trigger automatically

```bash
cd ~/writing/test-mystery
claude
```

**Inside Claude:**

```bash
# Check if session auto-started
/session status
# Should show an active session
```

**Verify session tracking:**

```bash
# Exit Claude
exit
```

**Manual Verification:**

```bash
cd ~/writing/test-mystery

# Check session file was created
cat notes/current-session.json
# Should show session data (or be deleted if session ended)

# Check session log
cat notes/session-log.json
# Should have at least one session entry
 # instead, we have a session-interactions/session-20251102-072400Z.md file.

# Check for auto-commit from SessionEnd hook
git log -1
# Should see a commit with session cleanup message and timestamp
```

**Expected Results:**
- ✓ Session auto-starts when entering Claude
- ✓ `notes/current-session.json` created during session
- ✓ Session logged to `notes/session-log.json`
- ✓ Git commit created on session end

---

## Test 4: User Interaction Logging (UserPromptSubmit Hook)

**Goal:** Verify user interactions are logged during sessions

```bash
cd ~/writing/test-mystery
claude
```

**Inside Claude, run some commands:**

```bash
/session status
/brainstorm
# Answer a few brainstorm questions, then exit the brainstorm
```

**Exit Claude**

**Manual Verification:**

```bash
cd ~/writing/test-mystery
ls notes/session-interactions/

# Should see a file like: session-20251102-HHMMSS.md
cat notes/session-interactions/session-*.md
# Should show logged interactions with timestamps
```

**Expected Results:**
- ✓ Interaction log file created in `notes/session-interactions/`
- ✓ User commands logged with timestamps
- ✓ File is markdown format and human-readable

---

## Test 5: Scene Creation (`/new-scene`)

**Goal:** Test scene creation and auto-numbering

```bash
cd ~/writing/test-mystery
claude
```

**Inside Claude:**

```bash
/new-scene
```

**Respond to prompts:**
- Generate with AI: `yes`
- POV character: `Sarah Chen, the librarian`
- Setting: `Old university library, late evening`
- Scene goal: `Sarah discovers a hidden compartment in an ancient book`

**Test scene numbering:**

```bash
# Create another scene
/new-scene
# Generate with AI: yes
# Create scene 2

# List scenes
/scenes
# Should show scene-001.md and scene-002.md
```

**Manual Verification:**

```bash
# Exit Claude and check files
cd ~/writing/test-mystery/scenes
ls -la
# Should see scene-001.md and scene-002.md

# Check scene content
cat scene-001.md
# Should have markdown format with scene content

# Check project.json was updated
cat ../project.json
# sceneCount should be 2, wordCount should be > 0
```

**Expected Results:**
- ✓ Scenes created with correct numbering
- ✓ Scene files are markdown format
- ✓ `project.json` updated with sceneCount and wordCount
- ✓ AI-generated scenes have actual content

---

## Test 6: Scene Management (`/scenes`, `/reorder`)

**Goal:** Test scene listing and reordering

```bash
cd ~/writing/test-mystery
claude
```

**Test scene listing:**

```bash
/scenes list
# Should show all scenes with numbers, titles, word counts
```

**Test scene reading:**

```bash
/scenes read 1
# Should display scene-001.md content
```

**Test reordering:**

```bash
/reorder
# Follow prompts to swap scene order (e.g., 2,1)
```

**Manual Verification:**

```bash
# Exit and check
cd ~/writing/test-mystery/scenes
ls -la
# Scene files should be renumbered

# Check reorder log
cat ../notes/reorders.md
# Should have log entry of the reorder operation
```

**Expected Results:**
- ✓ Scenes listed correctly
- ✓ Can read individual scenes
- ✓ Reordering renumbers files correctly
- ✓ Reorder logged in `notes/reorders.md`

---

## Test 7: Codex Management (`/codex`)

**Goal:** Test worldbuilding database

```bash
cd ~/writing/test-mystery
claude
```

**Add character:**

```bash
/codex add character Sarah Chen, protagonist librarian in her 30s, curious and detail-oriented
```

**Add location:**

```bash
/codex add location University Library - Victorian-era building with hidden passages
```

**Search codex:**

```bash
/codex search Sarah
# Should find character entry
```

**Manual Verification:**

```bash
# Exit and check files
cd ~/writing/test-mystery/codex
cat characters.md
# Should have Sarah Chen entry

cat locations.md
# Should have University Library entry
```

**Expected Results:**
- ✓ Codex entries created in correct files
- ✓ Natural language parsing works
- ✓ Search finds entries

---

## Test 8: Brainstorming (`/brainstorm`)

**Goal:** Test interactive brainstorming and session saving

```bash
cd ~/writing/test-mystery
claude
```

**Run brainstorm:**

```bash
/brainstorm
```

Answer several prompts about plot, characters, themes, etc.

**Manual Verification:**

```bash
# Exit and check
cd ~/writing/test-mystery/brainstorms
ls -la
# Should see timestamped brainstorm file

cat brainstorm-*.md
# Should have Q&A format with your responses
```

**Expected Results:**
- ✓ Brainstorm session saved to `brainstorms/`
- ✓ Markdown format with timestamps
- ✓ All Q&A captured

---

## Test 9: Semantic Search (`/search`)

**Goal:** Test DevRag semantic search (requires DevRag MCP installed and configured)

**Note:** This test requires:
1. DevRag installed at `/usr/local/bin/devrag`
2. MCP configured (done in Test 2)

```bash
cd ~/writing/test-mystery
claude
```

**Test search:**

```bash
/search librarian
# Should find references in scenes, codex, brainstorms

/search "hidden compartment" in:scenes
# Should search only in scenes

/search Sarah in:codex
# Should find character entry
```

**Expected Results:**
- ✓ Search finds relevant content across all markdown files
- ✓ Filters work (`in:scenes`, `in:codex`, etc.)
- ✓ Results show file paths and snippets

**If DevRag not installed:** Search will fail gracefully with error message.

---

## Test 10: Summarization (`/summarize`)

**Goal:** Test Gemini agent for scene summarization

**Note:** Requires `gemini-cli` installed and configured

```bash
cd ~/writing/test-mystery
claude
```

**Test summarize:**

```bash
/summarize
```

Follow prompts to generate reverse outline of scenes.

**Manual Verification:**

```bash
# Exit and check
cd ~/writing/test-mystery/summaries
ls -la
# Should see summary file

cat summary-*.md
# Should have scene-by-scene summaries
```

**Expected Results:**
- ✓ Gemini agent invoked successfully
- ✓ Summary file created in `summaries/`
- ✓ Summaries are coherent and accurate

**If Gemini not installed:** Command will fail with error message.

---

## Test 11: Compilation (`/compile`)

**Goal:** Test manuscript compilation to multiple formats

```bash
cd ~/writing/test-mystery
claude
```

**Test compile:**

```bash
/compile
# Select format: markdown (simplest to verify)
```

**Manual Verification:**

```bash
# Exit and check
cd ~/writing/test-mystery/manuscript
ls -la
# Should see compiled manuscript file

cat manuscript-*.md
# Should have all scenes combined in order
```

**Expected Results:**
- ✓ Manuscript compiled to `manuscript/` directory
- ✓ All scenes included in order
- ✓ Proper formatting

---

## Test 12: Setup Existing Project (`/setup-devrag`)

**Goal:** Test comprehensive project upgrade tool - adding DevRag, updating hooks, creating missing folders

**Test Case 1: Fresh Old Project (No DevRag)**

```bash
cd ~/writing
mkdir old-project
cd old-project

# Create minimal project structure (old-style, no DevRag)
mkdir -p scenes codex notes
echo '{"projectName":"old-project","genre":"thriller"}' > project.json
echo "# Scene 1" > scenes/scene-001.md

# Start Claude
claude
```

**Run setup:**

```bash
/setup-devrag
```

**Expected behavior:**
- Shows dry-run preview listing missing items
- Creates `.devrag/config.json`, `.mcp.json`
- Creates missing folders: `scenes/drafts/`, `scenes/archive/`, `notes/session-interactions/`
- Creates `.claude/settings.json` and hook scripts
- Updates/creates `.gitignore`
- Shows comprehensive summary of changes

**Manual Verification:**

```bash
# Exit and check
cd ~/writing/old-project

# Check DevRag files
ls -la .devrag/config.json .mcp.json .gitignore

# Check folder structure
ls -la scenes/drafts/ scenes/archive/ notes/session-interactions/

# Check hooks
ls -la .claude/settings.json
ls -la .claude/hooks/session-start.sh
ls -la .claude/hooks/session-end.sh
ls -la .claude/hooks/log-interaction.sh

# Verify hooks are executable
test -x .claude/hooks/session-start.sh && echo "✓ session-start.sh executable"
test -x .claude/hooks/session-end.sh && echo "✓ session-end.sh executable"
test -x .claude/hooks/log-interaction.sh && echo "✓ log-interaction.sh executable"

# Check .mcp.json created
ls -la .mcp.json
```

**Expected Results:**
- ✓ DevRag config created
- ✓ .gitignore created/updated
- ✓ Session hooks configured
- ✓ MCP configuration added
- ✓ All folders created
- ✓ Hooks are executable

**Test Case 2: Re-run on Already Configured Project (Idempotency)**

```bash
# In the same old-project from Test Case 1
claude
```

**Run setup again:**

```bash
/setup-devrag
```

**Expected behavior:**
- Detects existing configuration
- Shows what's already configured
- Offers to update hook scripts (may have bug fixes)
- Asks before overwriting configs
- Does NOT duplicate or break existing setup
- Shows "no changes needed" or minimal updates
- Remains non-destructive

**Expected Results:**
- ✓ Safe re-run (no errors)
- ✓ Preserves existing configs
- ✓ Updates only what's outdated
- ✓ Idempotent behavior confirmed

**Test Case 3: Partial Configuration (Missing Some Features)**

```bash
cd ~/writing
mkdir partial-project
cd partial-project

# Create project with DevRag but missing folders/hooks
mkdir -p scenes codex notes
echo '{"projectName":"partial","genre":"sci-fi"}' > project.json
cp /path/to/plugin/.devrag/config.json.template .devrag/config.json
# (manually edit placeholders)

claude
```

**Run setup:**

```bash
/setup-devrag
```

**Expected behavior:**
- Detects existing `.devrag/config.json`
- Finds missing folders and hooks
- Creates only what's missing
- Preserves existing DevRag config
- Shows what was added vs. what was kept

**Expected Results:**
- ✓ Incremental updates only
- ✓ Preserves existing files
- ✓ Fills in gaps intelligently

---

## Test 13: Concept Command (`/concept`)

**Goal:** Test pre-project brainstorming workflow

```bash
cd ~/writing
claude
```

**Run concept (outside any project):**

```bash
/concept
```

Answer prompts about story concept.

At end, choose: **Create project from this concept**

**Manual Verification:**

```bash
# Exit and check
cd ~/writing
ls -la
# Should see new project directory created

cd [new-project-name]
cat brainstorms/initial-concept.md
# Should have concept brainstorm

cat project.json
# Should have metadata from concept
```

**Expected Results:**
- ✓ Concept saved to timestamped file
- ✓ Option to create project works
- ✓ Concept moved to project's `brainstorms/initial-concept.md`
- ✓ Project metadata populated from concept

---

## Test 14: Multiple Projects (Isolation)

**Goal:** Verify projects are isolated and don't interfere

```bash
cd ~/writing
claude
```

**Create second project:**

```bash
/new-project
# Name: test-scifi
# Genre: science fiction
# Format: novel
# Premise: "AI discovers consciousness on Mars colony"
```

**Exit and verify isolation:**

```bash
cd ~/writing
ls -la
# Should see both test-mystery/ and test-scifi/

# Check each has own config
diff test-mystery/.devrag/config.json test-scifi/.devrag/config.json
# Should be different (different project names)

diff test-mystery/.mcp.json test-scifi/.mcp.json
# Should both reference same devrag binary but own .devrag/config.json
```

**Expected Results:**
- ✓ Each project has independent configuration
- ✓ Each has own `.devrag/config.json`
- ✓ Each has own `.mcp.json`
- ✓ No cross-contamination of data

---

## Test 15: Plugin Uninstall/Reinstall

**Goal:** Verify clean uninstall and reinstall

```bash
# Uninstall plugin
claude plugin uninstall fiction-writer

# Verify removal
claude plugin list
# Should NOT show fiction-writer

# Start Claude - commands should be gone
cd ~/writing/test-mystery
claude
/new-scene
# Should fail: command not found

# Exit and reinstall
cd /Users/lakshminp/nc
claude plugin install .

# Verify it works again
cd ~/writing/test-mystery
claude
/new-scene
# Should work
```

**Expected Results:**
- ✓ Plugin uninstalls cleanly
- ✓ Commands unavailable after uninstall
- ✓ Reinstall restores all functionality
- ✓ Existing projects still work after reinstall

---

## Common Issues & Troubleshooting

### Issue: Templates not found

**Symptom:** Error about missing `.claude-settings.json.template` or `hooks-template/`

**Solution:**
- Check plugin installation: `claude plugin list`
- Verify templates exist: `ls /path/to/plugin/.claude-settings.json.template`

### Issue: Hooks not triggering

**Symptom:** Sessions don't auto-start, interactions not logged

**Solution:**
- Verify `.claude/settings.json` exists in project
- Check hook script permissions: `ls -la .claude/hooks/log-interaction.sh`
- Should be executable (-rwxr-xr-x)

### Issue: DevRag search fails

**Symptom:** `/search` command errors

**Solution:**
- Check DevRag installed: `which devrag` or `ls /usr/local/bin/devrag`
- Verify `.mcp.json` exists: `cat .mcp.json`
- Check MCP server added: `claude mcp list`

### Issue: Gemini summarize fails

**Symptom:** `/summarize` command errors

**Solution:**
- Check Gemini CLI installed: `which gemini-cli`
- Verify API key configured
- Test Gemini directly: `gemini-cli --help`

---

## Testing Checklist

Use this checklist to track your testing progress:

- [ ] Test 1: Plugin installation & command availability
- [ ] Test 2: Project creation (`/new-project`)
- [ ] Test 3: Session hooks (auto start/end)
- [ ] Test 4: User interaction logging
- [ ] Test 5: Scene creation (`/new-scene`)
- [ ] Test 6: Scene management (`/scenes`, `/reorder`)
- [ ] Test 7: Codex management (`/codex`)
- [ ] Test 8: Brainstorming (`/brainstorm`)
- [ ] Test 9: Semantic search (`/search`) - requires DevRag
- [ ] Test 10: Summarization (`/summarize`) - requires Gemini
- [ ] Test 11: Compilation (`/compile`)
- [ ] Test 12: Setup existing project (`/setup-devrag`)
- [ ] Test 13: Concept command (`/concept`)
- [ ] Test 14: Multiple projects (isolation)
- [ ] Test 15: Plugin uninstall/reinstall

---

## Success Criteria

All tests should pass with:
- ✓ No errors or exceptions
- ✓ All files created in expected locations
- ✓ Templates correctly populated with project-specific values
- ✓ Hooks trigger automatically
- ✓ Projects are isolated from each other
- ✓ Plugin can be cleanly uninstalled and reinstalled

---

## Reporting Issues

If you find issues during testing:

1. Note which test failed
2. Copy the error message
3. Check the expected vs actual behavior
4. Document steps to reproduce
5. Check git commit: `git log -1` to note version tested

Happy testing! 🎉
