# Setup & Deployment Instructions

## 1. Supabase

Go to your Supabase project → SQL Editor → paste and run the contents of `supabase/migrations/001_initial.sql`.

Verify these tables exist: `profiles`, `modules`, `lessons`, `lesson_attachments`, `lesson_progress`, `comments`, `lesson_requests`.

## 2. Environment Variables

Copy `.env.example` to `.env.local` and fill in all values:

```
NEXT_PUBLIC_SUPABASE_URL=        # Supabase Dashboard → Settings → API
NEXT_PUBLIC_SUPABASE_ANON_KEY=   # Supabase Dashboard → Settings → API
SUPABASE_SERVICE_ROLE_KEY=       # Supabase Dashboard → Settings → API
STRIPE_SECRET_KEY=               # Stripe Dashboard → Developers → API keys
STRIPE_WEBHOOK_SECRET=           # See step 3
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=  # Stripe Dashboard → Developers → API keys
NEXT_PUBLIC_APP_URL=https://yourdomain.com
```

## 3. Stripe Webhook

In Stripe Dashboard → Developers → Webhooks → Add endpoint:
- URL: `https://yourdomain.com/api/stripe/webhook`
- Event: `checkout.session.completed`

Copy the signing secret into `STRIPE_WEBHOOK_SECRET` in your `.env.local` / server `.env`.

## 4. Make Yourself Admin

After signing up, go to Supabase → Table Editor → `profiles` → find your row → set `is_admin = true`.

## 5. Deploy to DigitalOcean

SSH into your droplet and run:

```bash
# Install dependencies
sudo apt update && sudo apt install -y docker.io docker-compose-plugin certbot

# Get SSL certificate (before starting nginx)
sudo certbot certonly --standalone -d yourdomain.com

# Clone repo and configure
git clone <your-repo-url> /app
cd /app

# Update nginx.conf — replace all instances of yourdomain.com with your actual domain
# Then create your env file
cp .env.example .env
nano .env  # fill in all values

# Start
docker compose up --build -d
```

To redeploy after changes:

```bash
cd /app
git pull
docker compose up --build -d
```

## 6. Local Development

```bash
npm install
# Make sure .env.local is filled in
npm run dev
```

Visit `http://localhost:3000`.

## 7. Updating the Course Price

The price is set in `app/api/stripe/checkout/route.ts`:

```ts
unit_amount: 9700, // $97.00 in cents
```

Update `unit_amount` and the display text in `app/(public)/pay/page.tsx` to match.
