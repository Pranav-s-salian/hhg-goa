"""Test the MCP launcher script manually"""
import sys
import os
from pathlib import Path

# Simulate what the TypeScript code does
sys.path.insert(0, str(Path(__file__).resolve().parent / "src"))
from fraudpy.tg import TG, _env

try:
    e = _env()
    graph = e.get("TG_GRAPH", "FraudGraph")
    host = e["TG_HOST"].rstrip("/")
    
    print(f"Graph: {graph}")
    print(f"Host: {host}")
    print(f"TG_SECRET present: {'TG_SECRET' in e and len(e['TG_SECRET']) > 0}")
    
    print("\nFetching token...")
    token = TG().token()
    print(f"Token length: {len(token)}")
    
    print("\nEnvironment that would be passed to MCP server:")
    env_vars = {
        "TG_HOST": host,
        "TG_GRAPHNAME": graph,
        "TG_API_TOKEN": token,
        "TG_JWT_TOKEN": token,
        "TG_RESTPP_PORT": e.get("TG_RESTPP_PORT", "443"),
        "TG_GS_PORT": e.get("TG_GS_PORT", "443"),
        "TG_SSL_VERIFY": "true"
    }
    
    for k, v in env_vars.items():
        if 'TOKEN' in k:
            print(f"  {k}: <token, length={len(v)}>")
        else:
            print(f"  {k}: {v}")
    
    print("\n✅ MCP launcher environment setup successful!")
    
except Exception as e:
    print(f"\n❌ Setup failed: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
