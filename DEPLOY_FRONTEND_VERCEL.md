# Deploy Frontend to Vercel - Step by Step

## Prerequisites
✅ Your frontend code is ready
✅ You have a Vercel account (sign up at https://vercel.com)
✅ Changes are committed to git

---

## Option 1: Deploy via Vercel Dashboard (Easiest) 🎯

### Step 1: Commit Your Changes
```bash
cd c:\Users\prana\OneDrive\Desktop\goa\hhg-fraud-agent

# Check what's changed
git status

# Add all changes
git add .

# Commit
git commit -m "feat: Add Groq support and prepare for deployment"

# Push to GitHub
git push origin main
```

### Step 2: Go to Vercel Dashboard
1. Open https://vercel.com
2. Click **"Add New Project"**
3. Click **"Import Git Repository"**
4. Select your `hhg-fraud-agent` repository

### Step 3: Configure Project Settings
**Framework Preset:** Next.js (auto-detected)  
**Root Directory:** `frontend`  
**Build Command:** Leave default (`npm run build`)  
**Output Directory:** Leave default (`.next`)  
**Install Command:** Leave default (`npm install`)

### Step 4: Set Environment Variables
Click **"Environment Variables"** and add:

**Name:** `NEXT_PUBLIC_API_URL`  
**Value:** `http://localhost:4000` (temporary - we'll update after backend is deployed)

### Step 5: Deploy!
Click **"Deploy"** button

Vercel will:
- Install dependencies
- Build your Next.js app
- Deploy it

You'll get a URL like: `https://hhg-fraud-agent.vercel.app`

---

## Option 2: Deploy via Vercel CLI (Advanced) 💻

### Step 1: Install Vercel CLI
```bash
npm install -g vercel
```

### Step 2: Login to Vercel
```bash
vercel login
```

Follow the prompts to authenticate.

### Step 3: Navigate to Frontend
```bash
cd c:\Users\prana\OneDrive\Desktop\goa\hhg-fraud-agent\frontend
```

### Step 4: Deploy
```bash
vercel
```

Answer the prompts:
- **Set up and deploy?** Yes
- **Which scope?** Select your account
- **Link to existing project?** No
- **Project name?** hhg-fraud-agent (or your choice)
- **Directory?** `./` (current directory)
- **Override settings?** No

### Step 5: Set Environment Variable
```bash
vercel env add NEXT_PUBLIC_API_URL
```

When prompted, enter: `http://localhost:4000`

### Step 6: Deploy to Production
```bash
vercel --prod
```

---

## After Deployment

### Your App is Live! 🎉

You'll get a URL like:
```
https://hhg-fraud-agent-xxx.vercel.app
```

### ⚠️ Important: Update Backend URL Later

Right now, the frontend is pointing to `localhost:4000` which won't work.

**After you deploy the backend to Railway**, you need to:

1. Go to Vercel Dashboard → Your Project → Settings → Environment Variables
2. Update `NEXT_PUBLIC_API_URL` to your Railway backend URL
3. Redeploy (Vercel will auto-redeploy on env change)

---

## Testing Your Deployment

### Before Backend is Deployed:
- ✅ Frontend loads
- ❌ "Cannot reach the agent" error (expected)
- ❌ Cases won't load

### After Backend is Deployed:
- ✅ Frontend loads
- ✅ Backend connection works
- ✅ Cases load and investigate works

---

## Vercel Configuration Files (Optional)

If you want more control, create `frontend/vercel.json`:

```json
{
  "buildCommand": "npm run build",
  "outputDirectory": ".next",
  "devCommand": "npm run dev",
  "installCommand": "npm install",
  "framework": "nextjs",
  "regions": ["iad1"]
}
```

---

## Automatic Deployments

Once connected to GitHub:
- ✅ Push to `main` → Auto-deploys to production
- ✅ Pull requests → Creates preview deployments
- ✅ Every commit → Builds and tests

---

## Custom Domain (Optional)

After deployment, you can add a custom domain:

1. Go to Project Settings → Domains
2. Add your domain
3. Update DNS records as instructed
4. Vercel handles SSL automatically

---

## Troubleshooting

### Build Fails
**Check:**
- All dependencies in `package.json`
- No TypeScript errors: `npm run typecheck`
- Build works locally: `npm run build`

**View logs:**
- Vercel Dashboard → Deployments → Click deployment → View logs

### "Module not found" errors
**Fix:** Check workspace dependencies in `package.json`
```json
{
  "dependencies": {
    "@fraud/shared": "workspace:*"  // Make sure this is included
  }
}
```

### Environment variables not working
- Must start with `NEXT_PUBLIC_` for client-side access
- Redeploy after adding/changing env vars
- Check: Settings → Environment Variables

---

## Next Steps

After frontend is deployed:

1. ✅ Frontend deployed to Vercel
2. ⏭️ Deploy backend to Railway
3. ⏭️ Update `NEXT_PUBLIC_API_URL` in Vercel
4. ⏭️ Test end-to-end

See `DEPLOYMENT_GUIDE.md` for backend deployment instructions!
