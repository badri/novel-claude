# Setup DevRag for Existing Project

Add DevRag vector search to an existing fiction writing project that was created before DevRag integration was available.

**Task**: Configure DevRag semantic search for existing project

## Prerequisites Check

Before running, verify:
1. You are in a fiction project directory (has `project.json`)
2. The project has the expected structure (`scenes/`, `codex/`, etc.)

## Steps to Execute

### 1. Check Current Project

Read `project.json` to get:
- Project name
- Genre
- Created date

### 2. Locate Plugin Directory

Find the plugin installation directory where templates are stored.

### 3. Create .devrag-config.json

If `.devrag-config.json` doesn't exist:
- Copy from `$PLUGIN_DIR/.devrag-config.json.template`
- Replace placeholders:
  - `{{PROJECT_NAME}}` → actual project name
  - `{{CREATED_DATE}}` → created date from project.json
  - `{{GENRE}}` → genre from project.json

If `.devrag-config.json` already exists:
- Ask user if they want to overwrite or keep existing config

### 4. Create/Update .gitignore

If `.gitignore` doesn't exist:
- Copy from `$PLUGIN_DIR/.gitignore.template`

If `.gitignore` exists:
- Check if `.devrag/` is already listed
- If not, add these lines:
  ```
  # DevRag vector database (derivative data, regenerated from markdown)
  .devrag/
  ```

### 5. Create .mcp.json

Copy from `$PLUGIN_DIR/.mcp.json.template` to enable DevRag MCP server at project scope.

This file configures the DevRag MCP server for the project. When users start Claude in this project, they'll be prompted to approve the MCP server (one-time approval).

**Important**: This file should be committed to git so all collaborators have access to semantic search.

### 6. Setup Session Interaction Logging

Create `.claude/` folder if it doesn't exist and copy hook configuration:

If `.claude/settings.json` doesn't exist:
- Copy from `$PLUGIN_DIR/.claude-settings.json.template`
- Creates hooks for SessionStart, SessionEnd, UserPromptSubmit

If `.claude/hooks/` doesn't exist:
- Create the folder
- Copy `log-interaction.sh` from `$PLUGIN_DIR/hooks-template/log-interaction.sh`
- Make it executable: `chmod +x .claude/hooks/log-interaction.sh`

If `.claude/settings.json` exists:
- Check if hooks are already configured (grep for SessionStart, SessionEnd, UserPromptSubmit)
- If hooks are missing, warn user and offer to merge
- If manual merge is needed, show the user the template location: `$PLUGIN_DIR/.claude-settings.json.template`

### 7. Initialize DevRag Index

Inform the user:
- DevRag will automatically index your markdown files when you use semantic search
- To manually trigger indexing, they can use the DevRag MCP tools directly
- Indexing happens in the background and doesn't require manual action

### 8. Output Summary

Tell the user:
- ✓ DevRag configuration created
- ✓ DevRag MCP server configured (`.mcp.json` created)
- ✓ .gitignore updated (if needed)
- ✓ Session interaction logging enabled (automatic)
- **Next steps**:
  - Exit and restart Claude in this project
  - **First time only**: You'll be prompted to approve the DevRag MCP server - click "Approve" to enable semantic search
- **How to use**: Ask Claude natural language questions about your story
  - "Where did I mention the magic system?"
  - "Which scenes feature character X?"
  - "Find all references to the ancient prophecy"
- **Performance**: DevRag uses 40x fewer tokens and is 260x faster than reading all files
- **Index location**: `.devrag/` folder (gitignored, will be regenerated)
- **What gets indexed**: All markdown in `scenes/`, `codex/`, `notes/`, `notes/session-interactions/`, `brainstorms/`, `summaries/`
- **Session logging**: Next time you run `claude`, sessions will auto-start/end and log all interactions
- **MCP configuration**: `.mcp.json` created and should be committed to git

### 9. Test Search (Optional)

Offer to test semantic search:
- "Would you like me to test the search with a query?"
- If yes, ask what to search for
- Use DevRag to perform search and show results

## Important Notes

- The `.devrag/` folder contains vector embeddings (derivative data)
- It's gitignored because it can be regenerated from markdown files
- DevRag indexes files automatically when you search
- No manual reindexing needed - it detects file changes
- Each project has its own independent `.devrag-config.json` and `.devrag/` folder
