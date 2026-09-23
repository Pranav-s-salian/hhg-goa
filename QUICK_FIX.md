# Quick Fix for TigerGraph MCP Connection

## The Problem
The MCP server can't start because `uv` is trying to reinstall dependencies every time, and the `jedi` package is locked by another process (likely VS Code or DevSpace).

## The Solution

### Step 1: Close file locks
Close anything that might be using Python files:
- VS Code (or reload the window: Ctrl+Shift+P → "Developer: Reload Window")
- Any Python shells or Jupyter notebooks
- DevSpace or other dev containers

### Step 2: Sync dependencies ONCE
```bash
cd py
uv sync
```

Or run the helper script:
```bash
py\sync_deps.bat
```

### Step 3: Restart your backend server
```bash
pnpm --filter @fraud/backend dev
```

## What Changed
The code now uses Python directly from `.venv` instead of `uv run`, which avoids dependency checks on every launch. But you need to sync dependencies once first.

## Alternative: Force sync (if file locks persist)
If you keep getting file lock errors:

1. **Kill Python processes:**
   - Open Task Manager (Ctrl+Shift+Esc)
   - Find and end all `python.exe` and `pythonw.exe` processes
   
2. **Delete the problematic package:**
   ```bash
   rmdir /s /q py\.venv\Lib\site-packages\jedi
   ```
   
3. **Sync again:**
   ```bash
   cd py
   uv sync
   ```

## Verify it works
After syncing, test the MCP launcher directly:
```bash
cd py
.venv\Scripts\python.exe scripts\tg_mcp_launcher.py FraudGraph
```

Press Ctrl+C to stop it, then run your backend server normally.
