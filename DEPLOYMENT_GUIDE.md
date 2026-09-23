# Deployment Guide: Frontend (Vercel) + Backend (Railway)

## Architecture

```
Frontend (Vercel)  →  Backend (Railway)  →  TigerGraph Cloud
     Next.js              Node.js + Python        (Already hosted)
                               ↓
                          Groq Cloud API
                          (AI text generation)
```

## Prerequisites

1. ✅ Groq API key - Get from https://console.groq.com/keys
2. ✅ GitHub account
3. ✅ Vercel account - Sign up at https://vercel.com
4. ✅ Railway account - Sign up at https://railway.app

---

## Part 1: Deploy Backend to Railway

Railway supports both Node.js and Python, perfect for our MCP setup!

### Step 1: Push to GitHub

```bash
git checkout -b deploy/production
git add .
git commit -m "Add Groq support and deployment config"
git push -u origin deploy/production
```

### Step 2: Create Railway Project

1. Go to https://railway.app
2. Click **New Project**
3. Select **Deploy from GitHub repo**
4. Choose your `hhg-fraud-agent` repository
5. Railway will auto-detect the project

### Step 3: Configure Backend Service

1. Railway should detect the `backend` folder
2. Set **Root Directory** to `backend`
3. Set **Build Command**: `npm install && npm run build` (or leave default)
4. Set **Start Command**: `npm start`

### Step 4: Add Environment Variables

In Railway dashboard, add these variables:

```env
# Groq API
GROQ_API_KEY=gsk_your_key_here
GROQ_MODEL=openai/gpt-oss-120b

# TigerGraph
TG_HOST=https://tg-e031b960-5007-4baf-80c5-6106d3a7660b.tg-2635877100.i.tgcloud.io
TG_SECRET=2ollgqcvigb6r5s8f1dv6koaadg7bcld
TG_GRAPH=FraudGraph
TG_RESTPP_PORT=443
TG_GS_PORT=443

# App Config
PORT=4000
DATASET_DIR=Dataset/test
STORE=tigergraph
RAG=0
LLM_TIMEOUT_S=120
```

### Step 5: Deploy Python Dependencies

Railway needs to know about the Python MCP server:

1. Create `railway.toml` in project root:

```toml
[build]
builder = "NIXPACKS"

[deploy]
startCommand = "cd backend && npm start"
```

2. The Python dependencies will be auto-detected from `py/pyproject.toml`

### Step 6: Get Your Backend URL

Once deployed, Railway gives you a URL like:
```
https://hhg-fraud-agent-production.up.railway.app
```

Copy this URL for the frontend configuration.

---

## Part 2: Deploy Frontend to Vercel

### Step 1: Update Frontend API Endpoint

Edit `frontend/lib/api.ts` to use environment variable:

```typescript
const API_BASE = process.env.NEXT_PUBLIC_API_URL || "http://localhost:4000";
```

### Step 2: Deploy to Vercel

1. Go to https://vercel.com
2. Click **Add New Project**
3. Import your GitHub repository
4. Vercel will auto-detect Next.js

### Step 3: Configure Vercel

**Framework Preset:** Next.js  
**Root Directory:** `frontend`  
**Build Command:** `npm run build` (default)  
**Output Directory:** `.next` (default)

### Step 4: Set Environment Variable

In Vercel dashboard → Settings → Environment Variables:

```
NEXT_PUBLIC_API_URL=https://your-backend.up.railway.app
```

Replace with your actual Railway backend URL.

### Step 5: Deploy!

Click **Deploy** and Vercel will build your app.

Your frontend will be live at:
```
https://hhg-fraud-agent.vercel.app
```

---

## Part 3: Connect Frontend to Backend

### Enable CORS on Backend

Make sure your backend allows requests from Vercel:

Edit `backend/src/api/server.ts`:

```typescript
await app.register(cors, {
  origin: [
    'http://localhost:3000',
    'https://hhg-fraud-agent.vercel.app', // Add your Vercel URL
    /\.vercel\.app$/ // Allow all Vercel preview URLs
  ],
  credentials: true
});
```

Redeploy backend to Railway after this change.

---

## Testing Your Deployment

1. Open your Vercel URL: `https://hhg-fraud-agent.vercel.app`
2. Check the connection status at the top
3. Pick a case and click "Investigate"
4. Verify:
   - ✅ Case loads successfully
   - ✅ AI generates text (check for "openai/gpt-oss-120b")
   - ✅ Data comes from TigerGraph

---

## Cost Breakdown

### Free Tier (Perfect for Demos)

- **Vercel:** Free for personal projects
- **Railway:** $5/month credit (enough for this app)
- **Groq:** Free tier (30 req/min)
- **TigerGraph:** Free Savanna tier
- **Total:** ~$0-5/month

### If You Need More

- Railway Pro: $20/month for more resources
- Groq Paid: $0.50 per million tokens (very cheap)
- TigerGraph: Upgrade if you need more storage

---

## Troubleshooting

### "Cannot reach the agent"
- Check Railway backend is running
- Verify `NEXT_PUBLIC_API_URL` in Vercel settings
- Check CORS configuration

### "groq 401: Unauthorized"
- Verify `GROQ_API_KEY` in Railway environment variables
- Generate a new key if needed

### TigerGraph connection fails
- Check all `TG_*` variables are set in Railway
- Verify TigerGraph workspace is running
- Test connection from Railway logs

### Python MCP server not starting
- Check Railway build logs
- Ensure `py/pyproject.toml` is committed to git
- May need to add `uv` installation to build

---

## Alternative: Deploy Everything to Railway

If you want to avoid Vercel, you can deploy both frontend and backend to Railway:

1. Create two Railway services:
   - Service 1: Backend (Node.js + Python)
   - Service 2: Frontend (Next.js static)

2. Set environment variables for both

3. Railway will give you separate URLs for each

This might be simpler for a monorepo setup!

---

## CI/CD: Automatic Deployments

Once connected:
- Push to `main` branch → Auto-deploys to production
- Pull requests → Vercel creates preview deployments
- Railway also auto-deploys on push

Set this up in GitHub:
1. Connect Vercel to your repo
2. Connect Railway to your repo
3. Both will watch for changes

---

## Security Notes

🔒 **Never commit these to git:**
- `GROQ_API_KEY`
- `TG_SECRET`
- `.env` file (already in `.gitignore`)

✅ **Use environment variables in:**
- Railway dashboard
- Vercel dashboard
- Never hardcode secrets!

---

## Next Steps

After deployment:
1. Test all fraud investigation flows
2. Monitor Railway logs for errors
3. Check Groq API usage dashboard
4. Set up custom domain (optional)
5. Add monitoring/analytics

Need help? Check the logs:
- **Vercel:** Dashboard → Deployments → Logs
- **Railway:** Dashboard → Your Service → Logs
