# Setup DevRag for Existing Project

Add DevRag vector search to an existing fiction writing project that was created before DevRag integration was available.

**Task**: Configure DevRag semantic search for existing project

## Prerequisites Check

Before running, verify:
1. You are in a fiction project directory (has `project.json`)
2. The project has the expected structure (`scenes/`, `codex/`, etc.)
3. DevRag MCP server is configured in `~/.claude.json` (see README.md for setup)

## Steps to Execute

### 1. Check Current Project

Read `project.json` to get:
- Project name
- Genre
- Created date

### 2. Create .devrag-config.json

If `.devrag-config.json` doesn't exist:
- Copy from template at `/Users/lakshminp/nc/.devrag-config.json.template`
- Replace placeholders:
  - `{{PROJECT_NAME}}` → actual project name
  - `{{CREATED_DATE}}` → created date from project.json
  - `{{GENRE}}` → genre from project.json

If `.devrag-config.json` already exists:
- Ask user if they want to overwrite or keep existing config

### 3. Create/Update .gitignore

If `.gitignore` doesn't exist:
- Copy from `/Users/lakshminp/nc/.gitignore.template`

If `.gitignore` exists:
- Check if `.devrag/` is already listed
- If not, add these lines:
  ```
  # DevRag vector database (derivative data, regenerated from markdown)
  .devrag/
  ```

### 4. Initialize DevRag Index

Inform the user:
- DevRag will automatically index your markdown files when you use semantic search
- To manually trigger indexing, they can use the DevRag MCP tools directly
- Indexing happens in the background and doesn't require manual action

### 5. Output Summary

Tell the user:
- ✓ DevRag configuration created
- ✓ .gitignore updated (if needed)
- **How to use**: Ask Claude natural language questions about your story
  - "Where did I mention the magic system?"
  - "Which scenes feature character X?"
  - "Find all references to the ancient prophecy"
- **Performance**: DevRag uses 40x fewer tokens and is 260x faster than reading all files
- **Index location**: `.devrag/` folder (gitignored, will be regenerated)
- **What gets indexed**: All markdown in `scenes/`, `codex/`, `notes/`, `brainstorms/`, `summaries/`

### 6. Test Search (Optional)

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
