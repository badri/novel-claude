# Setup DevRag for Existing Project

Sync an existing fiction writing project with the latest plugin features. This command:
- Adds DevRag vector search if missing
- Updates hooks and settings to latest version
- Adds missing folders/structure
- Re-indexes DevRag database
- Ensures parity with current plugin version

**Task**: Upgrade existing project to latest plugin feature set

## What This Command Does

This is a **comprehensive project upgrade tool** that brings existing projects up to date with the latest plugin version. It's safe to run multiple times (idempotent) and preserves your content and customizations.

**Use cases:**
- Add DevRag to old projects created before semantic search was available
- Update hooks to latest version (bug fixes, improvements)
- Add missing folders (drafts, archive, session-interactions)
- Sync config files with template updates
- Fix broken or missing MCP configuration
- Rebuild DevRag index after major content changes

**Safety:**
- Non-destructive: Never deletes content or overwrites user customizations without asking
- Dry-run preview: Shows what will change before making changes
- Incremental: Only updates what's missing or outdated
- Preserves: Your scenes, codex, notes, and custom settings

## Prerequisites Check

Before running, verify:
1. You are in a fiction project directory (has `project.json`)
2. The project has the expected structure (`scenes/`, `codex/`, etc.)
3. You have committed recent changes (recommended but not required)

## Steps to Execute

### 1. Check Current Project

Read `project.json` to get:
- Project name
- Genre
- Created date
- Current structure

Show user what will be updated (dry-run summary):
- Missing folders
- Missing/outdated config files
- Missing hooks
- DevRag index status

### 2. Locate Plugin Directory

Find the plugin installation directory where templates are stored.

### 3. Add Missing Folders

Check and create if missing:
- `scenes/drafts/` (with `.gitkeep`)
- `scenes/archive/` (with `.gitkeep`)
- `notes/session-interactions/` (with `.gitkeep`)
- `summaries/` (with `.gitkeep`)
- `brainstorms/` (with `.gitkeep`)
- `manuscript/` (with `.gitkeep`)
- `.devrag/` (with `.gitkeep`) - for DevRag database and config
- `.claude/` (for hooks)
- `.claude/hooks/` (for hook scripts)

### 4. Create/Update DevRag config

**Important:** DevRag requires config file to be named exactly `config.json` in `.devrag/` folder.

If `.devrag/config.json` doesn't exist:
- **Execute:** `mkdir -p .devrag`
- **Execute:** `cp $PLUGIN_DIR/config.json.template .devrag/config.json`
- **Execute:** `touch .devrag/.gitkeep`
- No placeholder replacement needed (template is ready to use)
- Configures DevRag to index all markdown files in project root (documents_dir: ".")
- Database stored in `.devrag/vectors.db` (gitignored)
- Tell user: "✓ Created .devrag/config.json"

If `.devrag/config.json` already exists:
- **Execute:** `cat .devrag/config.json` to show current version
- Check if it has correct schema (documents_dir, db_path, chunk_size, etc.)
- If it has old invalid fields (indexPaths, excludePaths, chunkSize, metadata):
  - **Warn user:** "Your config has outdated fields that DevRag doesn't support"
  - Show diff between current and new template
  - Ask user if they want to:
    - Replace with new template (recommended)
    - Keep current (may not work correctly)
- If config is already correct, tell user: "✓ .devrag/config.json already up to date"

**Migration from old location:**
If `.devrag-config.json` exists in project root (old location):
- **Warn user:** "Found old .devrag-config.json in project root. DevRag requires config.json in .devrag/ folder."
- Offer to migrate:
  - Create `.devrag/config.json` with new template
  - Delete old `.devrag-config.json`
  - Tell user: "✓ Migrated config to .devrag/config.json"

### 5. Create/Update .gitignore

If `.gitignore` doesn't exist:
- Copy from `$PLUGIN_DIR/.gitignore.template`

If `.gitignore` exists:
- Check if `.devrag/` is already listed
- If not, append these lines:
  ```
  # DevRag vector database (derivative data, regenerated from markdown)
  .devrag/
  ```
- Check for other recommended exclusions from template and add if missing

### 6. Create/Update .mcp.json

If `.mcp.json` doesn't exist:
- Copy from `$PLUGIN_DIR/.mcp.json.template` to enable DevRag MCP server at project scope
- This file configures the DevRag MCP server for the project
- When users start Claude in this project, they'll be prompted to approve the MCP server (one-time approval)
- **Important**: This file should be committed to git so all collaborators have access to semantic search

If `.mcp.json` exists:
- Verify it has the DevRag configuration
- If missing or outdated, ask user if they want to update

### 7. Setup/Update Session Hooks

**Always copy latest hook scripts** (they may have bug fixes or improvements):

1. Create `.claude/` and `.claude/hooks/` folders if missing
2. Copy (overwrite) all hook scripts from `$PLUGIN_DIR/hooks-template/`:
   - `session-start.sh` - Auto-starts session tracking
   - `session-end.sh` - Auto-ends session, logs stats, commits work
   - `log-interaction.sh` - Logs user interactions during session
3. Make all scripts executable: `chmod +x .claude/hooks/*.sh`

**Handle settings.json carefully:**

If `.claude/settings.json` doesn't exist:
- **Execute:** `cp $PLUGIN_DIR/.claude-settings.json.template .claude/settings.json`
- **Verify:** Confirm `.claude/settings.json` was created successfully
- This creates hooks configuration for SessionStart, SessionEnd, UserPromptSubmit
- Tell user: "✓ Created .claude/settings.json with session hooks"

If `.claude/settings.json` exists:
- **Execute:** Read current settings with `cat .claude/settings.json`
- Check if hooks are configured (look for SessionStart, SessionEnd, UserPromptSubmit)
- Compare with template to see if hooks are up-to-date
- If hooks missing or paths wrong:
  - Show user what's different (current vs template)
  - Offer to update automatically (merge) OR
  - Show template location for manual merge: `$PLUGIN_DIR/.claude-settings.json.template`
- Preserve any custom user settings not related to hooks
- If no changes needed, tell user: "✓ .claude/settings.json already configured"

### 8. Update/Verify project.json Structure

Check if `project.json` has all current fields:
- `projectName`, `genre`, `format`, `premise`
- `createdDate`, `lastModified`, `status`
- `sceneCount`, `wordCount`, `currentScene`
- `metadata` object with `povCharacter`, `setting`, `timeframe`

If fields are missing:
- Add them with sensible defaults
- Don't overwrite existing values
- Show user what was added

### 9. Rebuild DevRag Index

**Important**: Re-index to ensure DevRag has all current content.

Steps:
1. Check if `.devrag/` folder exists
2. If it exists and user wants fresh index:
   - Offer to delete and rebuild: `rm -rf .devrag/`
   - This forces complete re-indexing on next search
3. Inform user:
   - DevRag will automatically re-index your markdown files when you use semantic search
   - To manually trigger indexing now, use DevRag MCP tools directly
   - All content in `scenes/`, `codex/`, `notes/`, `notes/session-interactions/`, `brainstorms/`, `summaries/` will be indexed

### 10. Output Summary

Provide detailed change summary:

**Changes Made:**
- ✓ Folders added: [list any created]
- ✓ Config files updated: [list files created/modified]
- ✓ Hooks updated: [session-start.sh, session-end.sh, log-interaction.sh]
- ✓ Settings merged: [.claude/settings.json status]
- ✓ DevRag index: [rebuilt/kept/will rebuild on next search]
- ✓ project.json: [fields added if any]

**What's New:**
- DevRag semantic search (if newly added)
- Session auto-tracking (if hooks were added/updated)
- Interaction logging (if newly configured)
- Drafts/archive workflow (if folders added)

**Next Steps:**
- If MCP was newly added: Exit and restart Claude, approve DevRag MCP server (one-time)
- If hooks were updated: Restart Claude session to use new hooks
- Try semantic search: Ask natural language questions about your story
- Check `.claude/hooks/` scripts have latest bug fixes

**How to Use New Features:**
- **Semantic search**: "Where did I mention the magic system?"
- **Session tracking**: Automatic - sessions start/end automatically
- **Interaction logs**: Check `notes/session-interactions/` (searchable via DevRag)
- **Drafts**: Use `scenes/drafts/` for experimental scenes
- **Archive**: Deleted scenes preserved in `scenes/archive/`

**Performance Notes:**
- DevRag uses 40x fewer tokens and is 260x faster than reading all files
- Index location: `.devrag/` folder (gitignored, regenerated as needed)
- What gets indexed: All markdown in `scenes/`, `codex/`, `notes/`, `notes/session-interactions/`, `brainstorms/`, `summaries/`

**Files to Commit:**
- `.devrag-config.json` (if new/updated)
- `.mcp.json` (if new/updated)
- `.gitignore` (if modified)
- `.claude/settings.json` (if modified)
- Any new folders (`.gitkeep` files)

### 11. Test Search (Optional)

Offer to test semantic search:
- "Would you like me to test the DevRag search with a query?"
- If yes, ask what to search for
- Use DevRag to perform search and show results
- Verify indexing is working

## Important Notes

- The `.devrag/` folder contains vector embeddings (derivative data)
- It's gitignored because it can be regenerated from markdown files
- DevRag indexes files automatically when you search
- No manual reindexing needed - it detects file changes
- Each project has its own independent `.devrag-config.json` and `.devrag/` folder
