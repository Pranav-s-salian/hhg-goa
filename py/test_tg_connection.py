"""Test TigerGraph connection and token exchange"""
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent / "src"))

from fraudpy.tg import TG

try:
    print("Testing TigerGraph connection...")
    tg = TG()
    print(f"Host: {tg.host}")
    
    print("\nFetching JWT token from TG_SECRET...")
    token = tg.token()
    print(f"✓ Token received (length: {len(token)})")
    
    print("\nTesting GSQL endpoint...")
    result = tg.gsql("ls")
    print(f"✓ GSQL responded")
    print(f"Response preview: {result[:200] if len(result) > 200 else result}")
    
    print("\n✅ Connection successful!")
    
except Exception as e:
    print(f"\n❌ Connection failed: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
