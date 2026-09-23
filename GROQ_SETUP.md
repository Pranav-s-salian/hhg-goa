# Groq Cloud Setup Guide

## Overview
Your fraud agent now supports **Groq Cloud** for AI text generation! This means:
- ✅ No local Ollama server required
- ✅ Deploy to Vercel, Railway, Render, etc.
- ✅ Fast inference (Groq is optimized for speed)
- ✅ Free tier: 30 requests/minute with `openai/gpt-oss-120b`

## Setup Steps

### 1. Get Your Groq API Key (Free)

1. Go to https://console.groq.com/
2. Sign up or log in
3. Navigate to **API Keys** section
4. Click **Create API Key**
5. Copy your key (starts with `gsk_...`)

### 2. Update Your .env File

Open your `.env` file and add your Groq API key:

```env
# ---- LLM (Groq Cloud - recommended for deployment) ----
GROQ_API_KEY=gsk_your_key_here_xxxxxxxxxxxxxxxxxxxxx
GROQ_MODEL=openai/gpt-oss-120b
```

**That's it!** The app will automatically use Groq when `GROQ_API_KEY` is set.

### 3. Test Locally

```bash
# Start backend
pnpm dev:backend

# Start frontend (in another terminal)
pnpm dev:frontend
```

Open http://localhost:3000 and investigate a case. You should see:
- "text written by AI model openai/gpt-oss-120b" in the UI
- No Ollama server needed!

## Deployment Configuration

When deploying to cloud platforms, set these environment variables:

### Required:
```
GROQ_API_KEY=gsk_your_key_here
GROQ_MODEL=openai/gpt-oss-120b
```

### TigerGraph (already set):
```
TG_HOST=https://tg-e031b960-5007-4baf-80c5-6106d3a7660b.tg-2635877100.i.tgcloud.io
TG_SECRET=2ollgqcvigb6r5s8f1dv6koaadg7bcld
TG_GRAPH=FraudGraph
TG_RESTPP_PORT=443
TG_GS_PORT=443
```

### Other settings:
```
PORT=4000
DATASET_DIR=Dataset/test
STORE=tigergraph
RAG=0
LLM_TIMEOUT_S=120
```

## Groq Model Options

Groq offers several models. We're using `openai/gpt-oss-120b` because:
- ✅ Fast inference
- ✅ Good at structured JSON output
- ✅ Generous free tier
- ✅ Supports reasoning

### Other Groq models you can try:
```
GROQ_MODEL=llama-3.3-70b-versatile    # Very fast, good quality
GROQ_MODEL=mixtral-8x7b-32768         # Long context window
GROQ_MODEL=gemma2-9b-it               # Lightweight, fast
```

## Fallback to Ollama

If `GROQ_API_KEY` is not set, the app automatically falls back to Ollama (local):
- Requires Ollama running on http://localhost:11434
- Uses model specified in `LLM_MODEL_OLLAMA`

This is useful for:
- Local development without API costs
- Testing different models
- Working offline

## Cost & Limits

**Groq Free Tier:**
- 30 requests per minute for `openai/gpt-oss-120b`
- 6,000 tokens per minute
- Perfect for demos and small deployments

For production with higher volume, check Groq pricing at https://groq.com/pricing

## Troubleshooting

### "GROQ_API_KEY is not set"
- Make sure you added your API key to `.env`
- Restart the backend server after changing `.env`

### "groq 401: Unauthorized"
- Your API key is invalid or expired
- Generate a new key from https://console.groq.com/keys

### "groq 429: Too Many Requests"
- You hit the rate limit (30 req/min on free tier)
- Wait a minute and try again
- Or upgrade to paid tier for higher limits

### Model still shows "Ollama" in UI
- This is normal! The code internally calls it "ollama mode" for compatibility
- Check the model name in the UI: it should show "openai/gpt-oss-120b"

## What Changed

The code now has two narrator implementations:

1. **GroqNarrator** (new) - Uses Groq Cloud API
2. **OllamaNarrator** (existing) - Uses local Ollama server

The `narratorFromEnv()` function automatically picks:
- Groq if `GROQ_API_KEY` is set ✅
- Ollama if not (fallback)

No code changes needed when you add/remove the API key!
