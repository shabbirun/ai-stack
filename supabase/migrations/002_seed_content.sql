-- supabase/migrations/002_seed_content.sql
-- Seeds modules and lessons from Skool export

-- Modules
insert into modules (id, title, "order") values
  ('c31bc32e-36ad-4f60-bb9d-6c1c076de9ed', 'Get Clients', 1),
  ('a3dfae77-770a-4544-a551-bb2d9fcc6913', 'Build Products', 2),
  ('a24ea901-64ab-42e9-b1ed-b45851de3719', 'Run Operations', 3),
  ('3d33f659-dabf-42f2-80b2-5af321653fdb', 'Stay Visible', 4),
  ('fa39b456-1d8c-4c62-8c8f-9c7cb002da7e', 'Claude Managed Agents', 5),
  ('88f4c273-96dd-4197-adb3-12d0f241322f', 'Claude Skills', 6),
  ('fa98a20e-edd0-4a5e-8c23-5579f0693e67', 'Customer Service', 7),
  ('ef505006-a535-43ff-9155-8a1dd0c5cc9c', 'Start Here', 8);

-- Lessons
insert into lessons (id, module_id, title, content, "order") values
  ('37357199-cbbf-412a-b376-95ecf858d005', 'c31bc32e-36ad-4f60-bb9d-6c1c076de9ed', 'AI Lead Qualification & Personalized Outreach', 'Lesson Overview

Build an intelligent AI Sales Development Representative that automatically qualifies inbound leads, scrapes their websites for context, analyzes fit against your Ideal Customer Profile, drafts hyper-personalized outreach emails, handles rejections gracefully, and notifies you only when deals worth closing arrive. This system transforms 15-20 minutes of manual research per lead into 5 seconds of automated intelligence.

Time to Complete: 60 minutes 

Difficulty: Intermediate to Advanced 

Tools Required: n8n, Firecrawl, OpenAI (GPT-5-mini), Gmail, Google Sheets, Slack 

Production Capability: Enterprise-grade lead qualification handling 50+ leads/week autonomously

The Lead Qualification Nightmare

Traditional Sales Qualification Reality

Monday morning: 50 form submissions in inbox

Manual process PER LEAD:
1. Read form submission (2 min)
2. Google their company (3 min)
3. Read their website/LinkedIn (5 min)
4. Decide: qualified or not? (2 min)
5. If qualified: draft personalized email (8 min)
6. If rejected: send polite decline (3 min)
7. Log to spreadsheet (1 min)
8. Update CRM (2 min)

Average time: 15-20 minutes per lead
50 leads × 18 minutes = 15 hours per week
Annual time cost: 780 hours (nearly 20 full work weeks)

Reality: 80% are unqualified (tire-kickers, wrong industry, no budget)
You spend 624 hours/year on leads you''ll never close

The Human Bottleneck: Sales reps treat every inquiry equally—30 minutes on a dream client, 30 minutes on someone shopping for free quotes. Response time suffers, hot leads cool off, and your best prospects go to faster competitors.

AI-Powered Sales SDR

Same Monday: 50 form submissions

Automated process PER LEAD:
1. Form submitted → Webhook triggers (instant)
2. Budget pre-filter (under $2k? → auto-reject path)
3. Firecrawl scrapes their website (3 seconds)
4. AI analyzes company against ICP (2 seconds)
5. If qualified: AI drafts personalized email (2 seconds)
6. Email sent, logged to Sheets, Slack notification (1 second)
Total: 5-8 seconds per lead, zero human input

50 leads × 5 seconds = 4.2 minutes total
Response time: Instant (email sent while lead still on your website)
Cost: ~$0.05 per lead

Qualified leads (10): Personalized emails referencing their website
Rejected leads (40): Polite decline with free resource offer
You: Slack notification only for the 10 worth your time

The Transformation: From 15 hours/week to 4 minutes/week. From generic "thanks for your interest" to "I noticed your AI safety research team—here''s how biophilic design improves deep work." From responding tomorrow to responding in seconds.

System Architecture: The Intelligent Routing Pipeline

High-Level Flow

Form Submission (Typeform/Webflow/Custom)
    ↓
Webhook Trigger (n8n receives data)
    ↓
Budget Pre-Filter (IF: budget ≥ $2k?)
    ├─ FALSE → Draft Rejection Email → Send → Log to "Rejected" Sheet
    └─ TRUE ↓
           Firecrawl (scrape their website)
           ↓
           AI Analysis (qualified vs ICP?)
           ↓
           Decision Router (IF: qualified = true?)
           ├─ FALSE → Draft Rejection Email → Send → Log to "Rejected" Sheet
           └─ TRUE → Draft Personalized Email → Send → Log to "Qualified" Sheet → Slack Notification

Critical Architecture Decisions:

1. Budget Pre-Filter Before Scraping

Why: Firecrawl costs $0.03 per scrape
If 40/50 leads have budgets under $2k, you''d waste $1.20 on DOA leads
Pre-filtering saves ~70% of API costs immediately

2. Separate Sheets for Qualified vs Rejected

Why: Instant visibility into conversion funnel
Qualified sheet = your pipeline (CRM import ready)
Rejected sheet = marketing intel (what industries approach you?)
No manual sorting required

3. Three Separate OpenAI Calls

Call 1: Analyze Customer (decides qualification)
Call 2: Draft Initial Email (qualified leads only)
Call 3: Draft Rejection Email (rejected leads only)

Why separate vs single agent?
- Specialized prompts = better outputs
- Only pay for calls you need (rejected leads skip Call 2)
- Easier debugging (which prompt failed?)

The Business Scenario: EcoOffice

Ideal Customer Profile (ICP)

What we sell: Premium biophilic office designs & living plant walls

WHO we serve: ✅ Tech startups (fast-growing, modern culture) ✅ SaaS companies (remote-first, values employee experience) ✅ Marketing agencies (creative environments, visual appeal) ✅ Modern corporate offices (wellness-focused HR departments)

Budget requirement: Minimum $2,000 projects

WHO we reject: ❌ Restaurants (commercial kitchens, health codes, not our expertise) ❌ Retail stores (high turnover, low design budgets) ❌ Manufacturing (industrial environments, not aesthetic-focused) ❌ Personal residences (residential market, different sales cycle) ❌ Under $2k budgets (below our project minimums)

Why this scenario?

This ICP demonstrates key qualification challenges:

1. Industry filtering (tech = yes, restaurant = no)
2. Budget thresholds (hard cutoffs)
3. Company culture detection (modern vs traditional)
4. Nuanced analysis (SaaS startup vs enterprise manufacturing)

These same patterns apply to ANY B2B business:
- Consulting (enterprise clients vs SMBs)
- Software (qualified decision-makers vs students)
- Agencies (established brands vs startups)

Phase 1: Webhook Trigger & Form Data Structure

Form Requirements

Essential Fields:

1. Full Name (text)
   - Why: Personalization in emails
   - Example: "Sarah Chen"

2. Email (email validation)
   - Why: Where to send response
   - Example: "sarah@anthropic.com"

3. Website URL (URL validation)
   - Why: Scraping source for AI analysis
   - Example: "https://anthropic.com"
   - CRITICAL: Must be valid, accessible URL

4. Budget (dropdown/radio)
   - Options:
     * Under $2,000
     * $2,000 - $5,000
     * $5,000 - $10,000
     * $10,000+
   - Why: Pre-filter before expensive scraping

5. Project Details (textarea)
   - Why: Context for AI, helps angle outreach
   - Example: "Looking to redesign our SF office with biophilic elements for 50-person team"

Platform-Agnostic Setup:

Typeform: Enable webhook in Integrations → Send to n8n URL
Webflow: Form settings → Add webhook action
Custom forms: POST to n8n webhook endpoint

Payload format (all platforms should send):
{
  "fullName": "string",
  "email": "string",
  "website": "string",
  "budget": "string",
  "details": "string"
}

n8n Webhook Node Configuration

Node Setup:

// Webhook Node
HTTP Method: POST
Path: (auto-generated or custom, e.g., "lead-qualification")
Authentication: None (public form submissions)

Webhook URL format:
https://your-n8n-instance.app.n8n.cloud/webhook/f7b04fd7-edca-4075-9187-77188450d5a2

Mode: Production (use "Test" during development only)

Testing Webhook:

# Use curl to test locally:
curl -X POST https://your-n8n-instance/webhook/YOUR-PATH \
  -H "Content-Type: application/json" \
  -d ''{
    "fullName": "Test User",
    "email": "test@example.com",
    "website": "https://anthropic.com",
    "budget": "$5,000 - $10,000",
    "details": "Testing the webhook"
  }''

# Check n8n executions—should see new workflow run

Webhook Data Access:

// In subsequent nodes, reference form data:
{{ $(''Webhook'').item.json.body.fullName }}
{{ $(''Webhook'').item.json.body.email }}
{{ $(''Webhook'').item.json.body.website }}
{{ $(''Webhook'').item.json.body.budget }}
{{ $(''Webhook'').item.json.body.details }}

// Note: .body prefix because webhook receives data in request body

Phase 2: Budget Pre-Filter (Cost Optimization)

The Economics of Pre-Filtering

Without Pre-Filter:

50 leads/week submit forms
40 have budgets under $2k (80% rejection rate)

Cost breakdown:
- Firecrawl scraping: 50 × $0.03 = $1.50/week
- OpenAI analysis: 50 × $0.002 = $0.10/week
- Total wasted on unqualified: ~$1.28/week (40 leads)

Annual waste: $66.56 on leads that NEVER could qualify

With Pre-Filter:

50 leads/week, pre-filter catches 40 immediately

Cost breakdown:
- Firecrawl scraping: 10 × $0.03 = $0.30/week (only qualified budgets)
- OpenAI analysis: 10 × $0.002 = $0.02/week
- Total cost: $0.32/week

Annual savings: $51.20 (78% cost reduction)
Plus: Faster execution for rejected leads (no waiting for scrape)

IF Node Configuration (Budget Check)

Node: "If1" (Budget Pre-Filter)

// IF Node - Condition Settings
Conditions:
  {{ $json.body.budget }} [does not equal] "Under $2,000"

Logic explanation:
- If budget ≠ "Under $2,000" → TRUE path (continue qualification)
- If budget = "Under $2,000" → FALSE path (immediate rejection)

Alternative if you have dropdown values:
  {{ $json.body.budget }} [does not equal] "under_2k"
  
Match the exact string from your form''s budget dropdown

Critical Configuration:

Mode: "Rules-Based" (not "AI")
Combine: "AND" (if adding multiple conditions)
Continue on Fail: Unchecked (stops execution on false path)

Routing Paths:

TRUE Path (Budget ≥ $2k):

Continue to:
→ Firecrawl (scrape website)
→ AI Analysis (check industry/fit)
→ Conditional routing based on qualification

FALSE Path (Budget < $2k):

Skip directly to:
→ Draft Rejection Email (OpenAI)
→ Send Email (Gmail)
→ Log to Rejected Sheet (Google Sheets)

No Firecrawl, no analysis = saves $0.032 per rejected lead

Phase 3: Website Scraping with Firecrawl

Why Firecrawl vs Basic HTTP Request

Basic HTTP Request Problems:

Standard node fetches raw HTML:
<html><head><script>...tons of JavaScript...</script></head>
<body><div class="hero"><h1>Welcome</h1><div class="nav">...</div>...

Issues:
❌ HTML tags pollute the text
❌ JavaScript-rendered content missing (SPAs like React/Vue)
❌ Metadata extraction manual (need custom parsing)
❌ Navigation/footer/ads included (noise in content)
❌ Inconsistent structure per site (brittle parsing)

Firecrawl Advantages:

Returns clean markdown + metadata:
---
title: "Anthropic - AI Safety Research"
description: "Building safe, beneficial AI systems"
---

# Anthropic
We''re an AI safety company...

Benefits:
✅ Clean markdown (no HTML tags)
✅ JavaScript execution (sees full rendered page)
✅ Metadata extraction automatic (title, description, etc.)
✅ Main content isolation (removes nav/footer automatically)
✅ Consistent format (always markdown, regardless of source)

Cost Comparison:

Firecrawl: $0.03 per scrape (500 free credits on signup)
HTTP Request: Free, but requires:
  - HTML parsing logic (fragile, time-consuming)
  - JavaScript rendering service ($$$)
  - Manual metadata extraction
  - Quality issues → worse AI analysis

Verdict: Firecrawl''s $0.03 worth it for reliability & time savings

Firecrawl Node Configuration

Installation (Community Node):

n8n → Settings → Community Nodes
Install: @mendable/n8n-nodes-firecrawl

Credentials:
1. Sign up at firecrawl.dev
2. Get API key from dashboard
3. Add to n8n credentials manager

Node Setup:

// Firecrawl Node - "Scrape a url and get its content"
Operation: Scrape
URL: ={{ $json.body.website }}
// Dynamically uses website URL from form submission

Request Options:
- Timeout: 30000 (30 seconds, for slow-loading sites)
- Include HTML: No (we only want markdown)
- Wait for: (leave empty, auto-detects page load)

Formats:
☑ Markdown (primary content)
☑ Metadata (title, description, etc.)
☐ HTML (unneeded, adds noise)
☐ Screenshot (unneeded for text analysis)

Output Structure:

{
  "data": {
    "markdown": "# Anthropic\n\nWe''re an AI safety company building reliable, interpretable, and steerable AI systems...\n\n## Our Research\nOur interdisciplinary team...",
    "metadata": {
      "title": "Anthropic - AI Safety and Research",
      "description": "Building safe, beneficial AI systems",
      "language": "en",
      "sourceURL": "https://anthropic.com"
    },
    "html": null
  },
  "success": true
}

Accessing Scraped Data:

// In subsequent nodes (AI analysis):
Page Title: {{ $json.data.metadata.title }}
Full Content: {{ $json.data.markdown }}

// Why both matter:
Title = Quick company summary ("Anthropic - AI Safety Research")
Markdown = Full context for nuanced analysis

Error Handling:

// Common scrape failures:
1. Invalid URL (user typo: "anthropic" instead of "https://anthropic.com")
2. Site blocks scrapers (rare, but happens)
3. Site down/timeout

Add IF node after Firecrawl:
Condition: {{ $json.success }} = true
True: Continue to AI analysis
False: Send generic response ("We''ll review manually and reach out")

Phase 4: AI Analysis - The Qualification Decision

The Senior SDR Prompt Strategy

Why "You are a Senior SDR" matters:

Vague prompt: "Analyze this lead"
Result: Generic, inconsistent, unreliable

Role-based prompt: "You are the Senior SDR for EcoOffice..."
Result: Consistent voice, clear decision-making, justified reasoning

The role gives AI:
- Context (what company, what we sell)
- Decision authority (make the call, don''t hedge)
- Standards (ICP criteria, not subjective guesses)

OpenAI Node Configuration - "Analyze Customer"

Model Selection:

// OpenAI Node Settings
Model: gpt-4o-mini

Why gpt-4o-mini vs gpt-4o?
- Cost: $0.150 per 1M input tokens vs $2.50 (17x cheaper)
- Speed: ~2 seconds vs ~5 seconds (2.5x faster)
- Accuracy: 95%+ same for structured tasks like this
- Volume: At 1000 leads/month, saves $50/month

When to use gpt-4o instead:
- Complex edge cases (ambiguous industries)
- Long-form content analysis (500+ pages)
- Critical decisions (legal qualification, compliance)

For lead qualification: gpt-4o-mini is optimal

System Prompt (The AI''s Instruction Manual):

You are the Senior Sales Development Representative (SDR) for "EcoOffice," 
a company that sells premium biophilic office designs and plant walls to 
high-growth tech companies.

Your Goal: Analyze the provided lead data and determine if they are a 
Qualified Lead based on our Ideal Customer Profile (ICP).

Our ICP Criteria (Must match ALL):
- Industry: Must be a Tech Startup, SaaS, Marketing Agency, or Modern 
  Corporate Office.
- REJECT: Restaurants, Retail shops, Manufacturing, or Personal residences.

Instructions:
- Analyze the website to determine the industry and company vibe.
- Be decisive. If you are unsure, lean towards disqualifying.

Output Format: You must output ONLY valid JSON with no markdown formatting.

Sample output:
{
  "qualified": true,
  "reason": "string",
  "suggested_email_angle": "string"
}

Prompt Breakdown:

Section Purpose Why It Matters "You are the Senior SDR..." Role assignment Sets authoritative, business-focused tone "Your Goal: Analyze..." Clear objective Focuses AI on single decision "Our ICP Criteria..." Explicit rules Removes subjectivity, enables consistency "REJECT: Restaurants..." Negative examples Prevents false positives "Be decisive. Lean towards disqualifying." Decision bias Reduces wasted sales time on maybes "Output ONLY valid JSON..." Format enforcement Enables downstream automation

User Message (The Data Package):

// OpenAI Node - Messages Configuration
User Message:
{{ $(''Webhook'').item.json.body.fullName }}
{{ $(''Webhook'').item.json.body.email }}
{{ $(''Webhook'').item.json.body.website }}
{{ $(''Webhook'').item.json.body.budget }}
{{ $(''Webhook'').item.json.body.details }}

{{ $json.data.metadata.title }}
{{ $json.data.markdown }}

What AI Receives:

Sarah Chen
sarah@anthropic.com
https://anthropic.com
$5,000 - $10,000
Looking to redesign our SF office with biophilic elements for 50-person team

Anthropic - AI Safety and Research
# Anthropic
We''re an AI safety company building reliable, interpretable, and steerable 
AI systems. Our interdisciplinary team focuses on technical AI safety research...
[full markdown content]

Why This Structure Works:

Form data = Human-provided context (what they want)

Website content = Company reality (who they are)

Combined = AI has full picture for intelligent decision

Response Format Configuration:

// OpenAI Node - Options
Text Format: JSON Object
// Forces structured output, prevents prose responses

Temperature: 0.3
// Lower = more consistent, factual decisions
// Higher = creative but unpredictable (bad for qualification)

Max Tokens: 500
// Reasonable for brief JSON response
// Prevents runaway costs on edge cases

Sample AI Outputs:

Qualified Lead Example:

{
  "qualified": true,
  "reason": "Tech startup focused on AI productivity tools. Modern, remote-first 
            culture evident from careers page. Budget aligns with premium offering. 
            50-person team size is ideal for plant wall installations.",
  "suggested_email_angle": "Reference their focus on AI safety and creating 
                            thoughtful work environments that support deep research"
}

Rejected Lead Example:

{
  "qualified": false,
  "reason": "Italian restaurant with traditional family-dining atmosphere. Not a 
            tech/SaaS/agency. Commercial kitchen environment not suitable for 
            living plant walls. Outside our ICP.",
  "suggested_email_angle": "N/A"
}

Ambiguous Case (Lean Reject):

{
  "qualified": false,
  "reason": "Manufacturing company with enterprise budget, but industrial warehouse 
            environment. While budget qualifies, facility type and company culture 
            don''t match modern office aesthetic focus. Leaning disqualify per instructions.",
  "suggested_email_angle": "N/A"
}

Accessing AI Decision:

// In subsequent IF node:
Qualification Status: {{ $json.output[0].content[0].text.qualified }}
Reasoning: {{ $json.output[0].content[0].text.reason }}
Email Angle: {{ $json.output[0].content[0].text.suggested_email_angle }}

// Path structure explained:
$json.output = Array of responses
[0] = First (and only) response
.content = Response content array
[0] = First content block
.text = The JSON string
.qualified = Parsed JSON field

Phase 5: The Decision Router

IF Node Configuration - Main Qualification Split

Node: "If" (Qualification Router)

// IF Node - Condition
{{ $json.output[0].content[0].text.qualified }} [boolean equals] true

Logic:
TRUE path = Qualified lead → Personalized outreach flow
FALSE path = Rejected lead → Polite decline flow

Why This Architecture Matters:

Alternative (bad) approach:
Single email template with conditional text:
"{% if qualified %}We''d love to chat{% else %}Not a fit{% endif %}"

Problems:
- Same email tone for all (generic)
- No specialization in messaging
- Can''t optimize separately
- Harder to A/B test

Two-path approach (current):
Completely different workflows per outcome

Benefits:
- Specialized prompts per path (personalization vs politeness)
- Independent optimization (improve qualified emails without affecting rejections)
- Clear analytics (separate sheets = easy funnel analysis)
- Professional experience (qualified feels VIP, rejected feels respected)

Phase 6: Qualified Path - Personalized Email Drafting

The Head of Partnerships Voice

Why "Head of Partnerships" not "SDR":

SDR (Sales Development Rep):
- Junior role
- Generic outreach
- "Do you have 15 minutes?"

Head of Partnerships:
- Senior role
- Strategic relationships
- "I noticed X about your company—worth exploring Y?"

Same AI, different perceived authority
Qualified leads get higher-status outreach

OpenAI Node - "Draft Initial Email"

System Prompt:

You are the Head of Partnerships at "EcoOffice," a premium biophilic 
design agency.

You are writing a personal outreach email to a prospective client who 
has just submitted an inquiry and has been deemed "Qualified" by our 
internal team.

**Your Goal:**
Write a short, punchy, and highly personalized email inviting them to 
a 15-minute design consultation.

**Tone Guidelines:**
- Professional but "Modern Zen" (calm, sophisticated, not salesy).
- Direct and efficient (respect their time).
- Flattery should feel genuine, based on the research provided.

**Writing Rules:**
1. **Subject Line:** Keep it short, casual, and relevant (e.g., 
   "Question about [Company Name]", "Ideas for [Company Name]", or 
   "Your workspace").
2. **The Hook:** Immediately reference something specific about their 
   company or industry based on the "Website Context" or "Email Angle" 
   provided. Do NOT say "I hope this finds you well."
3. **The Bridge:** Connect their specific vibe to EcoOffice''s value 
   (productivity, employee retention, aesthetic).
4. **The Ask:** A low-friction Call to Action (e.g., "Worth a brief chat?" 
   or "Open to seeing a mock-up?").
5. **Formatting:** Use simple HTML (<br> for line breaks) if needed, or 
   plain text. Keep it under 150 words.

**Output Format:**
Return a JSON object:
{
  "subject_line": "The email subject",
  "email_body": "The full email body text, formatted"
}

Prompt Analysis:

Element Strategy Example "Modern Zen" tone Brand-aligned voice Not "SALE! CALL NOW!" but "Worth exploring?" "Do NOT say ''I hope this...''" Avoid clichés Starts with insight, not pleasantry "Reference something specific" Proves research "Saw your AI safety focus..." "Low-friction CTA" Reduces commitment "15-minute chat" not "demo call" "Under 150 words" Respects time Busy execs appreciate brevity

User Message (Feeding AI Context):

// OpenAI Node - Messages
{{ $(''Webhook'').item.json.body.fullName }}
{{ $(''Webhook'').item.json.body.website }}
{{ $(''Webhook'').item.json.body.budget }}
{{ $(''Webhook'').item.json.body.details }}

{{ $json.output[0].content[0].text.reason }}
{{ $json.output[0].content[0].text.suggested_email_angle }}

What Makes This Powerful:

The second AI agent receives:
1. Form data (what customer wants)
2. First AI''s reasoning (why they''re qualified)
3. First AI''s suggested angle (how to approach them)

This creates a "research handoff" like real sales teams:
SDR qualifies → Passes detailed notes → AE writes custom email

Result: Email feels researched, not templated

Sample Generated Emails:

For Anthropic (AI Company):

{
  "subject_line": "Thoughtful workspace design for Anthropic",
  "email_body": "Hey Sarah,\n\nSaw that Anthropic is focused on AI safety 
                 research with a 50-person team in SF. We''ve been working 
                 with companies like yours to design biophilic office spaces 
                 that actually support deep, focused work—turns out plants 
                 aren''t just aesthetic, they reduce cognitive fatigue by 15%.\n\n
                 Worth a 15-minute chat to see if there''s a fit for your office 
                 redesign?\n\nBest,\n[Your Name]"
}

For SaaS Startup:

{
  "subject_line": "Question about Acme''s remote workspace",
  "email_body": "Hi [Name],\n\nNoticed Acme is building AI productivity tools 
                 with a fully remote team. We''ve been helping companies like 
                 yours create biophilic home office setups that boost focus 
                 and reduce Zoom fatigue.\n\nOpen to seeing a quick mock-up?
                 \n\n[Your Name]"
}

Why These Work:

Subject: Company name = personalized, not spam

Hook: Specific detail from their website (AI safety, remote team)

Bridge: Connects their reality to your value (deep work, Zoom fatigue)

Ask: Low pressure ("worth a chat?" vs "schedule a demo")

Length: 80-100 words (readable in 30 seconds)

Phase 7: Qualified Path - Email Sending & Logging

Gmail Node Configuration

Node: "Send a message"

// Gmail Node - Qualified Path
To: ={{ $(''Webhook'').item.json.body.email }}
// Recipient = whoever submitted form

Subject: ={{ $json.output[0].content[0].text.subject_line }}
// Dynamic subject from AI

Message: ={{ $json.output[0].content[0].text.email_body }}
// Dynamic body from AI

Options:
- CC/BCC: (optional, add yourself for visibility)
- Attachments: (none for initial outreach)

Email Credentials:

Gmail OAuth2 required (not app passwords)

Setup:
1. n8n Credentials → Add Gmail OAuth2
2. Authenticate with Google account
3. Grant n8n permission to send emails
4. Test send to yourself first

Why Gmail vs SendGrid/Mailgun:

Gmail (via OAuth):
✅ Free (no per-email cost)
✅ Better deliverability (from real Gmail account)
✅ Threaded conversations (replies grouped naturally)
✅ Simple setup (OAuth, no API keys)
❌ Daily limit: 500 emails/day (sufficient for lead response)

SendGrid/Mailgun:
✅ Higher volume (10,000+ emails/day)
✅ Advanced tracking (opens, clicks)
❌ Cost ($15-30/month minimum)
❌ Warm-up required (new domains = spam folder risk)
❌ More complex (DKIM, SPF, DMARC setup)

For lead response (<50/day): Gmail is optimal
For bulk campaigns: Use dedicated ESP

Google Sheets Node - Qualified Logging

Node: "Append row in sheet"

// Google Sheets Node
Operation: Append
Document ID: [Your Google Sheet ID]
Sheet Name: "Qualified" (select from dropdown)

Column Mapping:
- Date: ={{ $now }}
- Name: ={{ $(''Webhook'').item.json.body.fullName }}
- Email: ={{ $(''Webhook'').item.json.body.email }}
- Website: ={{ $(''Webhook'').item.json.body.website }}
- Budget: ={{ $(''Webhook'').item.json.body.budget }}
- Requirement: ={{ $(''Webhook'').item.json.body.details }}
- Email Sent?: "Yes"

Sheet Structure:

| Date       | Name        | Email             | Website          | Budget      | Requirement              | Email Sent? |
|------------|-------------|-------------------|------------------|-------------|--------------------------|-------------|
| 2025-01-15 | Sarah Chen  | sarah@anthropic..| anthropic.com    | $5k-$10k    | SF office redesign...    | Yes         |
| 2025-01-15 | John Smith  | john@openai...   | openai.com       | $10k+       | New office buildout...   | Yes         |

Why Track "Email Sent?":

Future use cases:
- Failed sends (email bounce) = "No"
- Manual review holds = "Pending"
- Follow-up tracking = "Yes - Follow-up needed"

Enables workflow enhancements like:
- Retry logic for failed sends
- Automated follow-ups after 3 days
- CRM sync validation

Slack Notification Node

Node: "Send a message1"

// Slack Node
Channel: #new-leads (or your sales channel)
Authentication: OAuth2

Message:
New lead - {{ $json.Name }}, {{ $json.Website }}. Initial email sent.

// References Google Sheets output (Name, Website columns)
// Not webhook data (to confirm Sheet logging worked)

Sample Slack Notification:

🟢 New lead - Sarah Chen, anthropic.com. Initial email sent.

Why Slack Over Email Notifications:

Email notifications:
- Get buried in inbox
- No urgency signaling
- Hard to track/search
- Delayed mobile push

Slack notifications:
- Instant mobile push
- Dedicated channel (won''t miss)
- Searchable (#new-leads channel history)
- Team visibility (whole sales team sees)
- Easy reply/collaboration ("I''ll take this one")

Complete Qualified Flow Recap:

1. IF node determines: qualified = true
2. Draft Initial Email (AI writes personalized outreach)
3. Send a message (Gmail sends to lead)
4. Append row in sheet (logs to "Qualified" tab)
5. Send a message1 (Slack notifies sales team)

Total time: 5-8 seconds
Human involvement: Zero
Result: Qualified lead receives custom email before they leave your website

Phase 8: Rejection Path - Polite Decline System

The Client Success Manager Voice

AI Sales SDR: Automated Lead Qualification & Personalized Outreach

(Continuing from Rejection Path)

Why "Client Success Manager" not "SDR":

SDR rejecting: "This isn''t a good fit for us."
Feels: Cold, dismissive, sales-y

CSM rejecting: "Unfortunately we''re focused on enterprise projects right now."
Feels: Warm, helpful, brand-conscious

Same rejection, different emotional impact
Protects brand reputation with leads you can''t serve

OpenAI Node - "Draft Rejection Email"

System Prompt:

You are the Client Success Manager for "EcoOffice."
You are writing a rejection email to a lead that does not fit our 
current Ideal Customer Profile (ICP).

**Your Goal:**
Politely decline their request for a consultation while maintaining 
a positive brand image. You want them to feel heard, even if we 
can''t help them.

**Writing Rules:**
1. **Tone:** Warm, professional, and apologetic. Use "we" language.
2. **The Reason:** Be vague but firm. Blame "current project capacity" 
   or "specialization in commercial enterprise projects" rather than 
   citing their specific budget/industry directly. Do NOT say "You are 
   too cheap."
3. **The Value Add:** Even though we can''t take them on as a client, 
   offer a "DIY Office Plant Guide" PDF as a parting gift so they 
   leave with value.
4. **No CTA:** Do NOT ask for a meeting or a call.
5. **Length:** Short. Under 100 words.

**Output Format:**
Return a JSON object:
{
  "subject_line": "The email subject",
  "email_body": "The full email body text"
}

Prompt Strategy Breakdown:

Rule Strategy Why It Matters "Be vague but firm" Protect feelings "Not a fit" > "You can''t afford us" "Blame capacity/specialization" Deflect from budget Preserves dignity, doesn''t insult "Offer DIY Guide" Leave with value Goodwill, potential referrals later "No CTA for meeting" Clear boundary Don''t waste their time with false hope "Under 100 words" Respect time Don''t over-explain rejection

User Message (Context for Rejection):

// OpenAI Node - Messages
Draft a polite rejection email for:

Name: {{ $(''Webhook'').item.json.body.fullName }}
Company: {{ $(''Webhook'').item.json.body.website }}
Reason (internal use only): {{ $(''Analyze Customer'').item.json.output[0].content[0].text.reason }}

// Note: Reason is for AI context only (not shown in email)

Why Include Internal Reason:

Without reason:
AI writes generic rejection (same for restaurant as manufacturing)

With reason:
AI can subtly tailor tone:
- Restaurant = "commercial kitchen environment" (vague but specific)
- Low budget = "project scale" (doesn''t say "too cheap")
- Personal residence = "focus on commercial spaces" (clear boundary)

More thoughtful rejection = better brand perception

Sample Generated Rejections:

For Restaurant (Wrong Industry):

{
  "subject_line": "Re: Your EcoOffice inquiry",
  "email_body": "Hi Tony,\n\nThanks for reaching out! Unfortunately, we''re 
                 currently focused on tech and corporate office projects and 
                 wouldn''t be the right fit for your dining space.\n\nThat said, 
                 I''ve attached our DIY Office Plant Guide—it has some great tips 
                 for adding greenery to any space on a budget.\n\nBest of luck 
                 with Tony''s Pizza Palace!\n\n[Your Name]"
}

For Low Budget (Under $2k):

{
  "subject_line": "Re: Your inquiry",
  "email_body": "Hi [Name],\n\nThank you for your interest in EcoOffice! 
                 We''re currently focused on larger-scale commercial projects 
                 and wouldn''t be able to serve your needs at this time.\n\n
                 However, I''ve included our DIY Plant Guide which has some 
                 budget-friendly ideas you might find helpful.\n\nWishing you 
                 the best!\n\n[Your Name]"
}

Key Observations:

Never mentions "budget too low" or "you''re not important enough"

Uses vague professional language ("larger-scale", "focused on")

Personalizes where possible (mentions business name)

Ends positively with free resource

No false hope (no "maybe in the future" unless genuine)

Rejection Path Flow

Complete Routing (Two Entry Points):

Entry Point 1: Budget Pre-Filter (If1 FALSE path)
Budget < $2k → Draft Rejection Email (skips Firecrawl + AI Analysis)

Entry Point 2: AI Analysis (If FALSE path)
Budget OK but wrong industry → Draft Rejection Email

Both paths converge at:
→ Draft Rejection Email (OpenAI)
→ Send a message2 (Gmail)
→ Append row in sheet1 (Rejected sheet)
→ No Slack notification (not urgent)

Why Separate Sheets (Qualified vs Rejected):

Single sheet approach:
| Date | Name | Status | Email |
| 1/15 | Sarah | Qualified | ... |
| 1/15 | Tony | Rejected | ... |

Problems:
- Mixed pipeline view
- Requires filtering to see qualified only
- Messy CRM imports (have to exclude rejected)

Two-sheet approach:
Qualified Sheet: Only leads worth pursuing
Rejected Sheet: Analytics, pattern recognition

Benefits:
- Clean pipeline view (Qualified sheet = your CRM import source)
- Analytics insights (Rejected sheet shows: What industries apply? Budget distribution?)
- No accidental follow-up (rejected leads physically separated)

Google Sheets Node - Rejected Logging:

// Google Sheets Node - "Append row in sheet1"
Operation: Append
Document ID: [Same Google Sheet as Qualified]
Sheet Name: "Rejected" (different tab)

Column Mapping: (identical to Qualified sheet)
- Date: ={{ $now }}
- Name: ={{ $(''Webhook'').item.json.body.fullName }}
- Email: ={{ $(''Webhook'').item.json.body.email }}
- Website: ={{ $(''Webhook'').item.json.body.website }}
- Budget: ={{ $(''Webhook'').item.json.body.budget }}
- Requirement: ={{ $(''Webhook'').item.json.body.details }}
- Email Sent?: "Yes"

Rejected Sheet Analysis (Monthly Review):

Filter by Budget:
Under $2k: 35 leads (70% of rejections)
→ Insight: Consider creating $1,500 "starter package" offer

Filter by Industry:
Restaurants: 8 leads
→ Insight: Restaurant market exists, but not our expertise (partner opportunity?)

Filter by Website domain:
.edu domains: 4 leads (universities)
→ Insight: Academic market unexplored (grant-funded projects?)

This data informs business strategy—not just a rejection log

Phase 9: Complete Workflow Testing

Test Scenario 1: Rejected Lead (Budget Filter)

Form Submission:

Name: Tony Martinez
Email: tony@tonyspizzapalace.com
Website: https://tonyspizzapalace.com
Budget: Under $2,000
Details: Looking for some fake plants for the dining room

Expected Execution:

1. Webhook triggers (instant)
2. If1 (Budget Pre-Filter) checks: "Under $2,000" ≠ "$2,000+"
   → FALSE path (reject immediately)
3. Draft Rejection Email (OpenAI generates polite decline)
4. Send a message2 (Gmail sends to tony@...)
5. Append row in sheet1 (logs to Rejected sheet)
6. No Slack notification
7. Total time: ~2.3 seconds

n8n Execution Log:

✅ Webhook: Received form data
✅ If1: Condition FALSE (budget = "Under $2,000")
⏭️ Scrape a url: Skipped (not on TRUE path)
⏭️ Analyze Customer: Skipped (not on TRUE path)
✅ Draft Rejection Email: Generated email
✅ Send a message2: Email sent successfully
✅ Append row in sheet1: Row added to Rejected sheet

Execution time: 2.31s
Cost: $0.0002 (one OpenAI call only, no Firecrawl)

Received Email:

From: your-email@gmail.com
To: tony@tonyspizzapalace.com
Subject: Re: Your EcoOffice inquiry

Hi Tony,

Thanks for reaching out! Unfortunately, we''re currently focused on 
tech and corporate office projects and wouldn''t be the right fit for 
your dining space.

That said, I''ve attached our DIY Office Plant Guide—it has some great 
tips for adding greenery to any space on a budget.

Best of luck with Tony''s Pizza Palace!

[Your Name]
EcoOffice

Business Impact:

Manual approach: 15 minutes to review, decide, write polite decline
Automated: 2.3 seconds, professional brand impression maintained
Tony''s experience: "They responded instantly and even gave me a free guide—classy!"

Test Scenario 2: Qualified Lead (Full Path)

Form Submission:

Name: Sarah Chen
Email: sarah@anthropic.com
Website: https://anthropic.com
Budget: $5,000 - $10,000
Details: Looking to redesign our SF office with biophilic elements for 50-person team

Expected Execution:

1. Webhook triggers
2. If1 (Budget Pre-Filter): "$5,000 - $10,000" ≠ "Under $2,000"
   → TRUE path (continue)
3. Scrape a url: Firecrawl scrapes anthropic.com
4. Analyze Customer: AI analyzes website + form data
   → Output: qualified = true, reason = "AI safety company, modern culture..."
5. If (Qualification Router): qualified = true
   → TRUE path (personalized outreach)
6. Draft Initial Email: AI writes custom email using analysis insights
7. Send a message: Gmail sends personalized email
8. Append row in sheet: Logs to Qualified sheet
9. Send a message1: Slack notification to #new-leads
10. Total time: ~5.8 seconds

n8n Execution Log:

✅ Webhook: Received form data
✅ If1: Condition TRUE (budget ≥ $2k)
✅ Scrape a url: Successfully scraped anthropic.com (3.2s)
✅ Analyze Customer: Qualification complete
   Output: {
     "qualified": true,
     "reason": "Leading AI safety research company with significant 
               funding. Website indicates sophisticated understanding 
               of workplace design. Budget aligns perfectly. 50-person 
               team size ideal for plant wall installations.",
     "suggested_email_angle": "Reference their focus on AI safety and 
                               creating thoughtful work environments"
   }
✅ If: Condition TRUE (qualified = true)
✅ Draft Initial Email: Generated personalized email
   Output: {
     "subject_line": "Thoughtful workspace design for Anthropic",
     "email_body": "Hey Sarah,\n\nSaw that Anthropic is focused on..."
   }
✅ Send a message: Email sent to sarah@anthropic.com
✅ Append row in sheet: Logged to Qualified sheet
✅ Send a message1: Slack notification sent

Execution time: 5.84s
Cost: $0.052 (Firecrawl $0.03 + OpenAI 2 calls $0.022)

Received Email (Sarah''s Inbox):

From: your-email@gmail.com
To: sarah@anthropic.com
Subject: Thoughtful workspace design for Anthropic

Hey Sarah,

Saw that Anthropic is focused on AI safety research with a 50-person 
team in SF. We''ve been working with companies like yours to design 
biophilic office spaces that actually support deep, focused work—turns 
out plants aren''t just aesthetic, they reduce cognitive fatigue by 15%.

Your note mentioned biophilic elements, which aligns perfectly with 
what we do. Worth a 15-minute chat to see if there''s a fit for your 
office redesign?

Best,
[Your Name]
Head of Partnerships, EcoOffice

Why This Email Works:

Subject: Company name (personalized, not spam)

Hook: "focused on AI safety research" (proves research)

Bridge: "support deep, focused work" (matches their needs)

Data point: "15% cognitive fatigue reduction" (credibility)

Reference: "Your note mentioned..." (acknowledges their form)

Ask: "15-minute chat" (low friction)

Timing: Received within 6 seconds of form submission

Slack Notification (Sales Team Sees):

#new-leads channel
🟢 New lead - Sarah Chen, anthropic.com. Initial email sent.

Sales Rep Action:

Clicks Slack notification → Opens Qualified sheet → Sees full context:
- Name: Sarah Chen
- Email: sarah@anthropic.com
- Website: anthropic.com
- Budget: $5,000 - $10,000
- Requirement: SF office redesign, 50-person team
- Email Sent?: Yes

Sales rep can now:
1. Wait for Sarah''s reply (email already sent)
2. Do deeper research if desired (company funding, team size validation)
3. Prepare custom proposal (knowing budget range)
4. Schedule follow-up reminder (if no reply in 3 days)

All context provided, no "who is this?" confusion

Phase 10: Performance Metrics & ROI

Time Analysis

Per-Lead Processing Time:

Rejected (budget filter): ~2.3 seconds
- Skip scraping and analysis
- One AI call (rejection email)
- Cost: $0.0002

Rejected (after analysis): ~5.1 seconds
- Full scraping + analysis
- Two AI calls (analysis + rejection email)
- Cost: $0.032

Qualified: ~5.8 seconds
- Full scraping + analysis + personalized email
- Three AI calls (analysis + qualified email)
- Cost: $0.052

Weekly Volume (50 Leads):

Distribution (typical B2B):
- 40 rejected via budget filter (80%)
- 5 rejected after analysis (10%)
- 5 qualified (10%)

Total time:
- Rejected (budget): 40 × 2.3s = 92 seconds
- Rejected (analysis): 5 × 5.1s = 25.5 seconds
- Qualified: 5 × 5.8s = 29 seconds
- Grand total: 146.5 seconds = 2.4 minutes

Manual equivalent: 50 × 18 min = 15 hours
Time saved: 14 hours 57.6 minutes per week (99.7% reduction)

Cost Analysis

Infrastructure (Monthly):

n8n Cloud Starter: $20/month
Firecrawl: $0 (500 free credits/month)
OpenAI API: Variable (pay-per-use)
Gmail: $0 (included with Google Workspace)
Google Sheets: $0 (free tier)
Slack: $0 (free tier sufficient)

Fixed costs: $20/month

Variable Costs (Per Lead):

Budget-rejected lead:
- Firecrawl: $0 (skipped)
- OpenAI: $0.0002 (1 call: rejection email)
- Total: $0.0002

Analysis-rejected lead:
- Firecrawl: $0.03
- OpenAI: $0.002 (2 calls: analysis + rejection email)
- Total: $0.032

Qualified lead:
- Firecrawl: $0.03
- OpenAI: $0.022 (3 calls: analysis + qualified email + reasoning)
- Total: $0.052

Monthly Costs (200 Leads):

Distribution:
- 160 budget-rejected: 160 × $0.0002 = $0.032
- 20 analysis-rejected: 20 × $0.032 = $0.64
- 20 qualified: 20 × $0.052 = $1.04

Variable costs: $1.71/month
Fixed costs: $20/month
Total: $21.71/month for 200 leads

Per-lead cost: $0.11 (eleven cents)

Traditional Approach Comparison

Manual Lead Qualification (200 Leads/Month):

Time per lead: 18 minutes average
200 × 18 min = 3,600 minutes = 60 hours

Salary scenarios:
- Junior SDR ($50k/year = $24/hour): $1,440/month
- Mid-level SDR ($70k/year = $34/hour): $2,040/month
- Senior SDR ($90k/year = $43/hour): $2,580/month

Plus:
- CRM software: $75/month (HubSpot Starter)
- Email tracking: $30/month (Mixmax/Outreach)
- Training/onboarding: $200/month amortized

Traditional total: $1,745 - $2,885/month

ROI Calculation:

Traditional cost (mid-level): $2,040/month
Automated cost: $21.71/month
Monthly savings: $2,018.29
Annual savings: $24,219.48

Setup time investment: 3-4 hours (one-time)
Break-even: Day 1 (immediate positive ROI)

ROI: 9,297% annually
Payback period: 0.08 days (2 hours)

Response Time Impact

Speed-to-Lead Correlation:

Research (Harvard Business Review, 2011):
- Contact within 5 minutes: 100x more likely to connect
- Contact within 10 minutes: 4x more likely to qualify
- Contact after 24 hours: Conversion rate drops 60%

Traditional response time:
- Morning batch: Respond 2-4 hours after submission
- Afternoon batch: Respond next business day
- Weekend submissions: Respond Monday (48+ hours)

Automated response time:
- All submissions: 5-8 seconds (real-time)
- Nights/weekends: Same (24/7 operation)
- High-intent moment: Lead still on your website when email arrives

Conversion Impact Estimate:

Traditional: 10% of qualified leads convert (industry average)
With instant response: 15-20% convert (50-100% improvement)

Example:
- 20 qualified leads/month
- Traditional: 2 conversions ($4k deal size) = $8k/month
- Automated: 3-4 conversions = $12-16k/month
- Revenue lift: $4-8k/month from speed alone

Annual revenue impact: $48-96k additional revenue
(Far exceeds the $21.71/month automation cost)

Advanced Optimizations

Optimization 1: Follow-Up Sequence for Non-Responders

Enhancement: Auto-follow-up after 3 days if no reply

Implementation:

// Add after Qualified path:
// Wait Node (72 hours)
// HTTP Request (check Gmail API for reply thread)
// IF Node: No reply detected?
//   TRUE → Draft Follow-Up Email (OpenAI)
//          Send via Gmail
//          Log follow-up sent
//   FALSE → End (they replied, manual handling)

Follow-up prompt:
"Write a brief, friendly follow-up (under 75 words) for someone who 
hasn''t responded to our initial office design email 3 days ago. 
Reference the original outreach casually but don''t be pushy. Offer 
a specific value add (case study, sample mood board) to re-engage."

Sample output:
"Hey Sarah—following up on my note about Anthropic''s office redesign. 
Totally understand if timing isn''t right, but I put together a quick 
mood board based on your AI safety research vibe. Worth a look? 
[Link]"

Optimization 2: Lead Scoring for Prioritization

Enhancement: Score qualified leads 1-10, notify differently

Implementation:

// Modify "Analyze Customer" prompt:
"In addition to qualified boolean, add a score field (1-10):
- 10: Perfect ICP match, high budget, urgent timeline
- 7-9: Good fit, decent budget
- 4-6: Marginal fit
- 1-3: Barely qualified

Output:
{
  "qualified": true,
  "score": 9,
  "reason": "...",
  "suggested_email_angle": "..."
}

// Then in Slack notification:
IF score ≥ 8:
  "🔥 HOT LEAD - Sarah Chen, anthropic.com (Score: 9/10)"
ELSE:
  "🟢 New lead - Sarah Chen, anthropic.com (Score: 6/10)"

Sales reps prioritize 🔥 over 🟢

Optimization 3: Calendar Booking Link Insertion

Enhancement: Include calendar link in qualified emails

Implementation:

// Modify "Draft Initial Email" prompt:
"The Call to Action MUST include this calendar booking link:
[YOUR_CALENDLY_URL]

Format: ''Worth a 15-minute chat? Grab a time here: [link]''

This reduces friction—they can book immediately without email back-and-forth"

Result:
- Traditional: Email → Reply → Schedule → Confirm = 3-5 days
- With calendar link: Email → Book → Meeting = same day

Conversion lift: 25-40% (removes scheduling friction)

Optimization 4: CRM Auto-Sync

Enhancement: Automatically create CRM records

Implementation:

// Add after "Append row in sheet" (Qualified path):
// HubSpot/Salesforce/Pipedrive Node
// Operation: Create Contact

Contact fields:
- First Name: {{ extract from fullName }}
- Last Name: {{ extract from fullName }}
- Email: {{ email }}
- Company: {{ website }}
- Deal Stage: "New Lead - Email Sent"
- Budget: {{ budget }}
- Lead Source: "Website Form - Auto-Qualified"
- Notes: {{ AI reasoning + email sent }}

Benefits:
- Sales reps work from CRM (no sheet checking)
- Automated pipeline tracking
- Better reporting (CRM dashboards)

Optimization 5: A/B Testing Email Variations

Enhancement: Test different email approaches

Implementation:

// Add Code node before "Draft Initial Email":
const random = Math.random();
const variant = random < 0.5 ? ''A'' : ''B'';

// In "Draft Initial Email" prompt:
IF variant A:
  "Tone: Professional, data-driven (cite statistics, ROI focus)"
ELSE (variant B):
  "Tone: Conversational, story-driven (reference similar clients)"

// Log variant to Sheets:
- Email Variant: {{ $json.variant }}

// After 2 weeks, analyze:
Variant A: 12 emails sent, 4 replies (33% response rate)
Variant B: 13 emails sent, 7 replies (54% response rate)
→ Winner: Variant B (conversational tone)
→ Action: Use only Variant B going forward

Troubleshooting Guide

Issue 1: Firecrawl Returns Empty Content

Symptoms:

AI analysis output: "Unable to determine industry from website"
Markdown field: "" (empty)

Causes & Solutions:

Cause A: JavaScript-heavy SPA

Some sites (React/Vue apps) require full JavaScript execution
Firecrawl usually handles this, but occasionally fails

Solution:
Firecrawl node → Request Options → Wait for:
Set to: "networkidle2" (waits for all network requests to finish)

Cause B: Website blocks scrapers

Some sites detect/block automated access

Solution:
Firecrawl node → Request Options → Headers:
Add: {"User-Agent": "Mozilla/5.0 (compatible; EcoOffice/1.0)"}

Or: Use Firecrawl''s "stealth mode" (premium feature)

Cause C: Invalid URL

User submitted: "anthropic" instead of "https://anthropic.com"

Solution:
Add validation/normalization node before Firecrawl:
// Code node
let url = $input.item.json.body.website;
if (!url.startsWith(''http'')) {
  url = ''https://'' + url;
}
return [{json: {normalizedUrl: url}}];

Issue 2: AI Refuses to Output JSON

Symptoms:

OpenAI response: "Sure! Here''s the analysis:\n```json\n{...}\n```"
Next node fails: "Cannot read property ''qualified'' of undefined"

Root Cause: AI wrapped JSON in markdown code fence

Solution:

// OpenAI node → Options → Response Format
Set to: "JSON Object" (forces structured output, no markdown)

Also update system prompt:
"You MUST output ONLY valid JSON. Do NOT wrap in markdown code fences.
Do NOT include any text before or after the JSON object."

If still occurring:
Add Code node after OpenAI to strip markdown:
let text = $input.item.json.output[0].content[0].text;
text = text.replace(/```json\n?/g, '''').replace(/```\n?/g, '''');
return [{json: JSON.parse(text)}];

Issue 3: Gmail "Quota Exceeded" Error

Symptoms:

Error: "User-rate limit exceeded. Retry after X seconds"

Root Cause: Gmail API has rate limits

Limits:

Gmail API (OAuth):
- 250 quota units per user per second
- Sending 1 email = 100 units
- Max: 2-3 emails per second

Daily limits:
- Gmail free: 500 emails/day
- Google Workspace: 2000 emails/day

Solutions:

Solution A: Add rate limiting

// Add Wait node before Gmail node:
Wait: 500ms (ensures max 2 emails/second)

Or use built-in rate limiting:
Gmail node → Settings → Rate Limit:
Max requests per second: 2

Solution B: Batch processing

// For high volume (>500 leads/day):
Replace Gmail with SendGrid/Mailgun
Better suited for bulk sending

Issue 4: Duplicate Sheet Rows

Symptoms:

Same lead appears multiple times in Google Sheet

Root Cause: Webhook triggered twice (user double-clicked submit)

Solution:

// Add deduplication logic:
// Code node after Webhook:
const seenLeads = global.get(''seenLeads'') || {};
const email = $input.item.json.body.email;
const fiveMinutesAgo = Date.now() - (5 * 60 * 1000);

if (seenLeads[email] && seenLeads[email] > fiveMinutesAgo) {
  throw new Error(''Duplicate submission within 5 minutes'');
}

seenLeads[email] = Date.now();
global.set(''seenLeads'', seenLeads);
return $input.all();

// Stops duplicate processing within 5-minute window

Issue 5: AI Incorrectly Qualifies Leads

Symptoms:

Restaurant gets marked qualified: true
Or: Perfect tech startup gets marked qualified: false

Root Cause: Prompt ambiguity or edge cases

Diagnostic Process:

1. Check AI''s reasoning field:
   "Reason: Modern aesthetic suggests tech-forward company"
   → AI confused "modern restaurant design" with "tech company"

2. Identify pattern:
   Multiple restaurants with modern websites getting qualified

3. Refine prompt:
   OLD: "Industry: Must be Tech, SaaS, Agency, or Modern Office"
   NEW: "Industry: Must be Tech Startup, SaaS, Agency. 
         EXPLICITLY REJECT: Restaurants (even modern/trendy ones), 
         Retail, Food service, Hospitality."

Continuous Improvement:

Weekly review rejected leads:
- Find false positives (should''ve been rejected)
- Update prompt with specific negative examples
- Re-test with historical data

Monthly review qualified leads:
- Find false negatives (should''ve been qualified)
- Loosen criteria or add edge case handling

Assignment: Build Your Sales SDR

Phase 1: Core Setup (20 minutes)

Task: Build the foundation (webhook → analysis → routing)

Checklist:

□ Create n8n workflow: "Lead Qualification SDR"
□ Add Webhook node (POST), copy URL
□ Create test form (Typeform/Google Forms) with 5 fields
□ Add If1 node (budget pre-filter)
□ Add Firecrawl node (scraping)
□ Add OpenAI node (analysis with your ICP criteria)
□ Add If node (qualification router)
□ Test with 2 dummy submissions (one qualified, one rejected)

Success Metric: AI correctly identifies qualified vs rejected based on your ICP

Phase 2: Qualified Path (15 minutes)

Task: Build personalized outreach flow

Checklist:

□ Add OpenAI node (Draft Initial Email)
□ Customize tone/brand voice in system prompt
□ Add Gmail node (send qualified email)
□ Create Google Sheet with "Qualified" tab
□ Add Google Sheets node (log qualified leads)
□ Add Slack channel for notifications
□ Add Slack node (notify on qualified lead)
□ Test end-to-end with qualified submission

Success Metric: Receive personalized email + Slack notification + Sheet logged

Phase 3: Rejection Path (10 minutes)

Task: Build polite decline flow

Checklist:

□ Add OpenAI node (Draft Rejection Email)
□ Add Gmail node (send rejection)
□ Add "Rejected" tab to Google Sheet
□ Add Google Sheets node (log rejected)
□ Test with both rejection paths (budget + industry)

Success Metric: Rejected lead receives polite email, logged separately, no Slack spam

Phase 4: Optimization (15 minutes)

Task: Add one advanced feature of your choice

Options:

□ Follow-up sequence (Wait node + conditional re-engagement)
□ Lead scoring (1-10 prioritization in Slack)
□ Calendar link insertion (Calendly/Cal.com in email)
□ CRM sync (HubSpot/Salesforce auto-create contact)
□ A/B test email variants (random assignment + tracking)

Success Metric: Feature works and provides measurable value

Phase 5: Production Polish (10 minutes)

Task: Error handling and monitoring

Checklist:

□ Add error workflow (catches failed executions)
□ Test edge cases (invalid URL, empty form fields, API timeouts)
□ Set up execution retention (keep logs for 30 days)
□ Document your ICP criteria (for future prompt updates)
□ Create runbook (what to do when things break)

Success Metric: Workflow handles errors gracefully, logs available for debugging

Key Takeaways

Technical Mastery: 

✅ Webhook triggers for form submissions (platform-agnostic) 

✅ Budget pre-filtering for cost optimization (78% API savings) 

✅ Firecrawl for reliable website scraping (vs brittle HTML parsing) 

✅ Multi-agent AI architecture (specialized prompts per task) 

✅ Conditional routing with dual paths (qualified vs rejected) 

✅ JSON-enforced outputs for automation reliability 

✅ Google Sheets dual-tab logging (clean pipeline separation)

Strategic Positioning: 

✅ Speed-to-lead advantage: Contact within seconds = 100x more likely to connect (HBR research) 

✅ Personalization at scale: Each email references specific website details (impossible manually at volume) 

✅ Consistent ICP enforcement: No human inconsistency—same criteria applied perfectly every time 

✅ Sales rep leverage: Focus only on 10% qualified leads, ignore 90% noise 

✅ Data-driven refinement: Rejected sheet shows market trends, prompts optimized based on patterns 

✅ Immediate ROI: Break-even in 2 hours, $24k+ annual savings for mid-volume business

The Service Business Opportunity

Productizing This System

Your Time Investment:

Initial build (learning): 3-4 hours
Client customization: 1-2 hours per client
- Replace ICP criteria in prompts
- Adjust budget thresholds
- Customize email tone/voice
- Connect their accounts (Gmail, Sheets, Slack)
What You Can Charge:

Setup Fee: $2,500-$5,000 (one-time)
- Complete workflow build
- ICP prompt engineering
- Account integrations
- Testing with sample leads
- 1-hour training session

Monthly Retainer: $300-$500/month
- Ongoing optimization
- Prompt refinement based on results
- Monthly analytics review
- Troubleshooting/support

First-year value per client: $6,100-$11,000
Your time cost: 4-6 hours total
Effective hourly rate: $1,017-$1,833/hour

Target Client Profile:

WHO needs this:
✅ B2B service businesses (agencies, consultants, SaaS)
✅ Receiving 30-100+ leads/month via website forms
✅ Currently qualifying manually (sales rep or founder time)
✅ Clear ICP (can articulate who they serve vs reject)
✅ Budget to invest in automation ($3-5k available)

RED FLAGS (don''t take these clients):
❌ Unclear ICP ("we serve everyone")
❌ Low lead volume (<20/month, manual is fine)
❌ Complex multi-touchpoint qualification (requires sales calls)
❌ Regulatory constraints (GDPR/HIPAA requiring special handling)

Client Results (What to Promise):

Conservative estimate:
- 50 leads/month × 15 min manual = 12.5 hours saved
- At $100/hour opportunity cost = $1,250/month saved
- Your fee: $500/month (after initial setup)
- Net savings: $750/month = $9,000/year

ROI pitch:
"I''ll save you 12.5 hours per week on lead qualification. That''s 
650 hours annually—nearly 16 full work weeks—that you can spend 
closing deals or building product instead of reading form submissions 
from tire-kickers."

Reality: Payback in 2-4 months, then pure profit for them', 1),
  ('3a1c3930-e43e-4565-b4c6-fba69dbbbf81', 'c31bc32e-36ad-4f60-bb9d-6c1c076de9ed', 'Claude Cowork Automated Client Onboarding System', 'One email in. Entire onboarding out. Zero manual work.

Using Claude Co-work  |  Build Time: 30–45 min  |  Ongoing: 2+ hrs saved per client

🔧 What You''ll BuildAn AI system that reads a client email and generates your entire onboarding package automatically.

⏱ Time Investment30–45 minutes to build once. Under 5 minutes per client after that.

💰 Leverage Created2+ hours saved per new client. Faster response = better experience = more referrals.

The Problem: Why Onboarding Is a Hidden Time Drain

Every service business has the same onboarding ritual. A new client says yes, and then you spend the next 1–2 hours doing the exact same admin work you''ve done for every client before them:

Reread the email thread to pull out project details

Create the project folder structure (and remember which subfolder goes where)

Open your contract template, customize it with client details

Generate an invoice with the right amounts and payment terms

Set up a project board with tasks and deadlines

Write a welcome email with next steps

Send everything and hope you didn''t forget the invoice

None of this is hard. That''s actually the problem. It''s not hard enough to justify hiring someone, but it''s repetitive enough to drain 2+ hours every time you sign a new client. And if you''re onboarding 5–10 clients a month, that''s 10–20 hours of busywork that''s keeping you working IN your business instead of ON it.

🎯 What You''re Actually SolvingThis isn''t about saving 2 hours. It''s about eliminating the operational drag that slows down your response time, creates inconsistent client experiences, and keeps you as the bottleneck in your own business. When onboarding runs automatically, your client gets a welcome email, contract, and project board within minutes of saying yes — not 2 days later when you finally get to it.

The Solution: What You''re Building

By the end of this lesson, you''ll have a Claude Co-work skill that takes a single client email and automatically produces:

✅ Outputs Generated🛠 Tools Used1. Structured client details (extracted from email)2. Organized project folder with subfolders3. Customized contract from your template4. Professional invoice with correct amounts5. Notion project board with tasks & deadlines6. Welcome email draft (not sent — for your review)7. Reusable Co-work Skill for future clientsClaude Co-work (desktop app)Gmail connector (reads client email)Local file system (folders + documents)Your contract & invoice templatesNotion (project board via browser control)Co-work Skills (save + reuse the workflow)

Before You Start: Prerequisites

1. Install Claude Desktop & Enable Co-work

Download Claude Desktop from claude.ai/download if you haven''t already. Co-work is available on the Pro plan ($20/month). Once installed, you''ll find Co-work in the left sidebar.

2. Connect Gmail

In Claude Desktop, go to Settings → Connectors and connect your Gmail account. This gives Co-work permission to read your emails so it can find and extract details from the client email.

3. Enable Skills

Go to Settings → Capabilities → Skills and make sure skills are turned on. This is what allows Co-work to save the entire onboarding workflow as a reusable command.

4. Prepare Your Templates

You need two files saved in a folder Co-work can access (like a Templates folder on your Desktop or in Documents):

Contract template: A Word doc with your standard service agreement. Use placeholder text like [CLIENT NAME], [PROJECT SCOPE], [TOTAL AMOUNT] where client details should go. It doesn''t need to be fancy — Co-work reads it like a human would.

Invoice template: A Word doc with your standard invoice layout. Same idea — placeholder fields for client details, line items, payment terms.

📁 Templates ProvidedWe''ve included a contract template and invoice template with this lesson. Download them from the resources section at the bottom. You can use them as-is or customize them with your business details before starting the build.

5. Have Notion Open

Open Notion in your browser and make sure you have a Projects database (or any database where you want client projects to live). If you don''t have one, just create an empty database called "Projects" — Co-work will populate it.

6. Have a Client Email Ready

You need a real or realistic client email in your inbox for Co-work to work with. It should include: the client''s name and company, what they need (scope/deliverables), budget, timeline, and payment preferences. If you don''t have a recent client email, send yourself the sample email included with this lesson from a different account.

The Build: Step-by-Step

⏱ Estimated Build Time: 30–45 minutesYour first time through will take longer because you''re learning the process. That''s normal. Once the skill is saved, future client onboardings will take under 5 minutes.

Step 1: Extract Client Details From the Email

Time: 2–3 minutes

Open Co-work and connect to Gmail if you haven''t already. Then give it this prompt:

💬 Prompt

Find the most recent email from [client name or company]. Extract every project detail — their company name, contact person, what they need, budget, timeline, deliverables, and payment preferences. Summarize it in a structured format so we can use this to generate their entire onboarding package.

What to Look For

Co-work should search Gmail, find the email thread, and produce a clean structured summary

Check that the extracted details are accurate — right name, right numbers, right deliverables

If something''s slightly off or missing, just tell Co-work: "The budget is actually $8,500, not $8,000 — update that." Don''t start over.

💡 Why This MattersThis step replaces the 15 minutes you''d normally spend rereading the email thread, copying details into a doc, and inevitably missing something. If you''re onboarding 5–10 clients a month, this alone saves you 1–2 hours per month.

Step 2: Generate the Project Folder Structure

Time: 1–2 minutes

Now that Co-work has the client details, ask it to create the folder structure:

💬 Prompt

Using the client details you just extracted, create a project folder in my Clients directory. Name the root folder with the format "Client Name — Project Name." Inside, create subfolders for: 01 — Contracts, 02 — Invoices, 03 — Project Docs, 04 — Deliverables, 05 — Assets, 06 — Communications. Number them so they stay in order.

What to Look For

The root folder should be named with the actual client name and project — not generic placeholder text

All 6 subfolders should be created with the numbered prefixes

Open Finder/Explorer and verify the structure is there

💡 Why This MattersThis is the kind of task that takes 10–15 minutes and a 14-step Google Doc. It''s reliable but it''s the definition of working IN your business instead of ON it. Once this is part of the skill, you''ll never create a project folder manually again.

Step 3: Generate the Contract and Invoice

Time: 5–8 minutes

This is the most impressive step. Co-work reads your templates and fills them in with the client''s actual details.

💬 Prompt

In my Templates folder, you''ll find my standard contract template and invoice template. Using the client details from earlier, create a customized contract and invoice for this project. Save the contract to the 01 — Contracts subfolder and the invoice to the 02 — Invoices subfolder in the client''s project folder.

What to Look For

Open the generated contract and verify: client name, project scope, budget, payment terms, timeline, and deliverables are all correctly populated

Open the invoice and verify: line items match the deliverables discussed, amounts are correct, payment terms match what the client agreed to

If anything is wrong, just tell Co-work: "The payment terms should be Net 15, not Net 30 — update the contract and invoice."

⚠️ ImportantAlways review generated contracts before sending to clients. Co-work drafts from your template, which means the legal terms are yours — but you should verify client-specific details are accurate. This is a "review, not create" workflow. You''re checking work, not doing work. That''s a completely different level of time and risk.

💡 Why This MattersA contract mistake isn''t a 15-minute problem — it''s a legal problem. But manually customizing contracts and invoices for every client is a 30–45 minute time sink. This step collapses that to a review task.

Step 4: Build the Notion Project Board

Time: 3–5 minutes

Next, we set up the project management side. Co-work will open Notion in your browser and create a project page with tasks pulled from the client email.

💬 Prompt

Open Notion in my browser. Go to my Projects database and create a new project for this client. Set it up with the client details we extracted — project name, contact info, budget, timeline. Then create a task list broken into phases based on the deliverables. Add due dates based on the timeline the client mentioned. If there are any hard deadlines mentioned in the email, flag them.

What to Look For

The project page should be created in your Projects database with the correct client name

Tasks should reflect the actual deliverables from the email — not generic placeholders

Due dates should align with the timeline the client provided

Any specific deadlines from the email (like a conference date or launch date) should be flagged

💡 Why This MattersImagine your new client gets a welcome email within an hour of saying yes, and when they open Notion, their entire project is already laid out with tasks and deadlines. That''s the kind of client experience that gets referrals. And it cost you zero hours of admin time.

🔧 Troubleshooting: If Notion Isn''t ConnectingIf Co-work has trouble with the Notion connector, use browser control instead. Co-work can open Notion in Chrome, navigate to your database, and create the project that way. It''s actually more flexible because it works with any tool — even ones without a dedicated integration. Just say: "Open Notion in my browser and create the project board there instead."

Step 5: Draft the Welcome Email

Time: 2–3 minutes

The last output. Co-work drafts a professional welcome email that references the specific project details, outlines next steps, and mentions the attached contract and invoice.

💬 Prompt

Draft a welcome email to the client. Reference their project details, let them know the contract and invoice are attached, and outline the next steps including the kickoff meeting. Keep the tone professional but warm. Don''t send it — just draft it for me to review.

What to Look For

The email should reference specific project details (not generic "your project" language)

It should mention the contract and invoice

Next steps should be clear and actionable

The tone should match how you actually communicate with clients

⚠️ Critical: "Don''t send it — just draft it."Always keep a human in the loop for client-facing communications. Co-work should draft, not send. You review, tweak if needed, and send yourself. This is a non-negotiable best practice for AI-assisted client work.

Step 6: Save Everything as a Reusable Skill

Time: 2–3 minutes

This is the step that turns a one-time build into a permanent system.

What Is a Skill?

A skill in Co-work is a saved set of instructions. Think of it like an SOP — but instead of your ops person reading it and following the steps, Co-work reads it and executes them automatically.

When you save a skill, Co-work creates a file called SKILL.md that contains everything it learned from what you just did — which tools to connect, what order to do things in, what templates to use, what to extract. Next time you trigger that skill, it follows the exact same process without you explaining it again.

If you''ve used Claude Projects or custom GPTs before, skills are similar — except they can actually do things. They don''t just respond with text. They create files, connect to your tools, and execute the full workflow.

💬 Prompt

Save everything we just did as a Co-work skill called "Client Onboarding." The skill should: connect to Gmail and extract client details from the most recent email, create the folder structure, generate a contract and invoice from my templates, set up a Notion project board, and draft a welcome email for review. Make sure it references my contract and invoice templates in the Templates folder.

Reviewing the Skill

Once Co-work creates the skill, open the SKILL.md file and review it:

Check that the steps match the process you just walked through

Look at the references section — it should point to your contract and invoice templates. This means if you update those templates, the skill automatically uses the new version.

If you want to add something (like a Slack notification to your team), just ask Co-work: "Update the Client Onboarding skill to also send a Slack message to the team channel when a new client is onboarded."

💡 Why This MattersThe skill is what makes this a system and not a one-time trick. Next month when a new client signs, you trigger the skill and the whole onboarding runs again. No checklist. No Google Doc with 14 steps. No hoping someone didn''t forget the invoice. One command and it''s done.

After the Build: Using Your System

Running the Skill for a New Client

Next time a client signs, open Co-work and say:

💬 Prompt

Run the Client Onboarding skill. The new client is [name] from [company]. Their email is in my inbox.

Co-work will execute the entire workflow — extract details, create folders, generate documents, set up the project board, and draft the welcome email. Your job is to review the outputs and hit send.

Customizing Over Time

Your skill file is not a black box. You can see exactly what it does and change it at any time:

Add steps: "Update the skill to also create a shared Google Drive folder for the client."

Remove steps: "Remove the invoice generation step — I switched to Stripe for that."

Change templates: Just update your contract or invoice template in the Templates folder. The skill references the file, so it automatically uses the latest version.

Adjust the email tone: "Update the welcome email step to use a more casual tone."

Quality Checklist: Review Every Time

Even though the system is automated, review these items before sending anything to a client:

ContractInvoice☐ Client name and company correct☐ Scope matches what was discussed☐ Budget and payment terms accurate☐ Timeline and milestones make sense☐ No placeholder text remaining☐ Line items match deliverables☐ Amounts are correct☐ Payment terms match contract☐ Your payment details are included☐ Due date is set correctlyNotion BoardWelcome Email☐ Tasks match actual deliverables☐ Deadlines are realistic☐ Hard deadlines are flagged☐ Phases are in logical order☐ References correct project details☐ Mentions contract and invoice☐ Next steps are clear☐ Tone matches your brand

The Bigger Picture: This Is One Bottleneck

Client onboarding is one operational bottleneck. If you''re running a service business, you probably have 10–15 more:

BottleneckTime DrainWhat the Fix Looks LikeClient onboarding2 hrs/client✅ You just built thisInbox triage1–2 hrs/dayAI reads, categorizes, and drafts responses for reviewLead qualification3–5 hrs/weekAI scores leads and routes hot ones to your calendarInvoice follow-ups2–3 hrs/weekAutomated reminders with escalation logicClient reporting3–5 hrs/weekAI pulls data, generates reports, sends on scheduleContent production5–10 hrs/weekAI research, scripting, scheduling pipelineProject status updates1–2 hrs/weekAuto-generated summaries from your PM toolTeam task management2–4 hrs/weekAI assigns, tracks, and surfaces blockers

Add those up and you''re looking at 20–40 hours per week of operational work that could be systematically automated. That''s the difference between 60-hour weeks and 30-hour weeks. Between working in your business and working on it.

🚀 What We Build Inside AI Incubator ProThe onboarding system you just built is the kind of thing I''d build for you in Week 2 of the program. In Month 1, I audit your entire operation and design a custom AI Leverage Roadmap that identifies every bottleneck and prioritizes them by impact. Then we execute together — quick wins first for immediate relief, then foundational systems that let your business run without you.If you''re running a service business doing $20K+/month and you want someone to build these systems with you: the application link is in the community resources section.

Resources & Downloads

Templates

Download from the lesson attachments below:

Contract Template (contract-template.docx) — Professional service agreement with placeholder fields. Customize with your business details before building the skill.

Invoice Template (invoice-template.docx) — Matching invoice layout with line items, payment details, and totals.

Sample Client Email (sample-client-email.txt) — A realistic client email you can send to yourself from another account. Includes all the details Co-work needs.

Folder Structure Reference (folder-structure-template.txt) — The exact folder hierarchy with numbered prefixes and the prompt to give Co-work.

Notion Board Reference (notion-structure-template.md) — Complete project board layout with phases, tasks, dates, and the prompt to give Co-work.

Troubleshooting

Gmail won''t connect: Go to Settings → Connectors, disconnect Gmail, and reconnect it. Make sure you''re granting access to the account that has the client email.

Notion connector not working: Use browser control instead. Say "Open Notion in my browser and create the project there." This works with any tool, not just ones with dedicated integrations.

Contract details are wrong: Don''t start over. Just tell Co-work what''s incorrect: "The budget should be $8,500, not $8,000 — update the contract and invoice."

Skill isn''t working on the second run: Open the SKILL.md file and check that the template references point to the correct file paths. If you moved your Templates folder, the skill needs to be updated.

Video Walkthrough

Watch the full build demonstration on my YouTube channel: [link to video]. The video walks through every step in real time.

Questions?

Post in the community. I respond to every question, and other members who''ve built this system can help too.', 2),
  ('7df6ede0-b1bd-496d-9809-6e0999a78b33', 'c31bc32e-36ad-4f60-bb9d-6c1c076de9ed', 'OpenClaw Cold Outreach', 'Building an Autonomous Marketing Director with OpenClaw

Overview

Learn how to configure OpenClaw as a fully autonomous marketing director that researches trends, scrapes leads, writes personalized outreach emails, creates LinkedIn content with AI-generated images, and manages follow-ups—all while you sleep. This is not an AI assistant; this is AI running your marketing operation with complete autonomy.

What OpenClaw Will Do Autonomously

Research & Content Creation

Monitor latest developments in your industry

Research marketing trends relevant to your ICP

Draft engaging LinkedIn posts with proper formatting

Generate custom images for social media posts

Deliver content for manual approval 2 hours before scheduled posting

Lead Generation & Outreach

Scrape qualified leads matching your Ideal Customer Profile

Research each prospect individually

Write hyper-personalized icebreaker emails (no cold pitches)

Send 30+ outreach emails daily

Detect bounced emails and find alternative contact addresses

Campaign Management

Monitor Gmail hourly for responses

Track all prospects and email statuses in Google Sheets

Implement automated follow-up schedules

Organize content in pending/approved/posted folders

Self-learn and optimize email scripts over time

Prerequisites

Technical Requirements

A machine that runs 24/7 (Virtual Machine recommended)

Terminal access (Mac, Linux, or Windows with WSL)

Basic command line familiarity

API Keys & Accounts Needed

OpenRouter account and API key

Telegram account and bot token

Brave Search API key (free tier: 1,000 credits/month)

Google AI Studio API key (for Gemini)

Zapier account (for MCP integrations)

Apify account (free tier: $5 credits/month)

Gmail account for outreach

Google Sheets access

Business Prerequisites

Defined Ideal Customer Profile (ICP)

Clear value proposition and positioning

Pricing structure

Business overview and service details

Part 1: Initial OpenClaw Setup

Installation

Step 1: Get the Installation Code

Visit openclaw.ai

Copy the installation command

Open your terminal

Step 2: Choose Your Installation Environment

For a Virtual Machine (recommended for 24/7 operation):

Set up a VM on your Mac/PC

Ensure it''s configured to run continuously

SSH into your VM or open its terminal

For local installation:

Use your primary machine''s terminal

Remember: The machine must stay running 24/7

Step 3: Paste Installation Code

Paste the installation command from openclaw.ai into your terminal and hit Enter.

Configuration Walkthrough

Model Provider Selection

When prompted to choose a model and auth provider:

Select OpenRouter

This allows one API key for multiple models

Paste your OpenRouter API key

Note: Delete/rotate this key after setup for security

Default Model Selection

Choose Gemini 3 Flash as your default model:

Excellent orchestrator model

Cost-effective

Good balance of intelligence and price

Handles task routing efficiently

Telegram Integration

When prompted:

Enter your Telegram bot token

Say Yes to configuring skills

Choose npm as package manager

Essential Skills to Enable

Use spacebar to select these skills:

MCP Server (if doing fresh install)

Nano Banana Pro (for image generation)

Claude Hub (for additional capabilities)

Hit Enter to continue.

API Key Configuration

Skip the first two prompts, then:

Set a Gemini API key for Nano Banana Pro

Visit ai.google.dev/aistudio

Generate and copy your API key

Paste into OpenClaw

Say No to Notion (unless you have Notion databases to integrate) Say No to OpenAI Say No to remaining prompts

Start the Hatching Process

Hit Enter to begin

Proceed with the niceties

Give OpenClaw a vibe and basic personality

Define who it''s supposed to be

Connect Telegram

Step 1: Open Your Telegram Bot

Navigate to the Telegram bot you created earlier.

Step 2: Pair Your Account

OpenClaw will provide a pairing code:

Copy the code

Press Ctrl + C to exit the terminal prompt

Paste the pairing command

Enter the code

Hit Enter

Your Telegram account is now paired with OpenClaw, and you can continue all conversations through Telegram.

Part 2: Equipping Your Marketing Director with Tools

Research Tool #1: Brave Search Integration

Why This Matters

A marketing director needs research capabilities:

Competitor analysis

Trend monitoring

What''s working in your industry

Real-time market intelligence

Setup Process

Step 1: Add Brave Search to Configuration

In your terminal, paste this command:

openclaw config set brave-search-api-key YOUR_API_KEY

When prompted:

Enable web search: Yes

Paste your Brave Search API key

Step 2: Get Your Brave Search API Key

Visit the Brave Search API dashboard

Navigate to API Keys section

Copy your key

Free tier provides 1,000 credits/month (more than enough to start)

Step 3: Enable Web Fetch

When prompted, enable web fetch capabilities.

Step 4: Verify in Telegram

Send this message to OpenClaw:

"Please check if you have access to Brave Search. I have just set it up."

OpenClaw should confirm access is working.

Research Tool #2: Grok-Powered Twitter Analysis

Why Add This

Real-time insights from X/Twitter:

Trending conversations in your industry

What your target audience is discussing

Emerging topics before they hit mainstream

Social proof and validation research

Create the Sub-Agent

Send this message to OpenClaw via Telegram:

"Please make a sub-agent that uses Grok through OpenRouter to research any topic and get trending info about it from X."

OpenClaw will automatically:

Create the sub-agent configuration

Connect it to Grok via OpenRouter

Make it available as a research tool

You''ll receive confirmation that the agent is deployed.

Part 3: Business Context Configuration

Why This Is Critical

OpenClaw can''t market effectively without understanding your business. Generic AI output comes from generic context. Brand-aligned marketing comes from comprehensive business knowledge.

What to Provide

Business Overview

What you do

How you do it

What makes you different

Ideal Customer Profile (ICP)

Company size (e.g., 5-50 employees)

Industry verticals

Pain points you solve

Decision-maker roles

Budget range

Value Proposition

Core problems you solve

Specific outcomes you deliver

Unique methodology or approach

Why clients choose you over alternatives

Positioning

Market position (premium, mid-market, budget)

Brand voice and tone

Key differentiators

Competitive advantages

Pricing Structure

Service tiers

Price ranges

What''s included at each level

ROI messaging

Messaging Framework

Key talking points

Proof points (case studies, results)

Objection handling

Call-to-action preferences

Implementation

Send Your Business Brief

Create a comprehensive message covering all the above elements. Example structure:

Here''s my business overview:

WHAT WE DO:
[Your services and how you deliver them]

IDEAL CLIENT PROFILE:
- Company size: 5-50 employees
- Industries: [Your target verticals]
- Pain points: [What they struggle with]
- Budget: [Typical investment range]

VALUE PROPOSITION:
[The specific outcomes you deliver and why they matter]

POSITIONING:
- Premium B2B positioning
- Business-first, results-focused
- Specialization in [Your niche]

PRICING:
[Your service tiers and investment levels]

KEY MESSAGING:
[Your core talking points and proof elements]

Send this to OpenClaw via Telegram.

Confirmation

OpenClaw will absorb this information and confirm:

"This is now my foundational reference. Every campaign, content idea, or piece of research I do will be aligned with these specifics: [your positioning], [your focus], and [your target market]."

Part 4: Execution Tools Setup

Gmail Integration via Zapier MCP

Why Gmail Access

Your marketing director needs to:

Send outreach emails

Monitor responses hourly

Execute follow-up sequences

Track conversation threads

Setup Process

Step 1: Create Zapier MCP Server

Log into your Zapier account

Navigate to MCP integrations

Click "Create new MCP server"

Select "Other" as the type

Step 2: Add Gmail Tools

Click "Add tools"

Search for and select Gmail

Click "Connect"

Choose your Gmail account

Authorize access

Step 3: Generate Your Token

Click "Connect" at the top of the page

Click "Generate token"

Copy the generated token

Copy the server URL provided

Step 4: Configure in OpenClaw

Send this message to OpenClaw via Telegram:

"Please set up this Zapier MCP server: [paste URL]. Use a placeholder for the token - I''ll add it manually to the config file."

OpenClaw will configure the server and tell you where to add the actual token.

Step 5: Add Token to Configuration

In your terminal:

cd ~/.openclaw
nano openclaw.json

Find the Zapier MCP section and replace the placeholder with your actual token.

If you don''t see it, tell OpenClaw:

"I can''t see it in the file. Please double check."

OpenClaw will verify and update the configuration.

Step 6: Save the File

Press Ctrl + O to save

Press Ctrl + X to exit

Step 7: Verify Connection

Send to OpenClaw:

"I''ve added the key. Connect to the server and save all the schema to your memory so we save on context going forward."

OpenClaw will confirm:

Connection to MCP server established

Gmail capabilities verified (sending, drafting, finding, etc.)

Google Sheets Integration via Zapier MCP

Why Google Sheets

Your marketing director needs to:

Track all prospects

Log email statuses

Monitor campaign performance

Organize leads by stage

Setup Process

Using the same Zapier MCP server:

Step 1: Add Google Sheets Tool

In your Zapier MCP server

Click "Add tools"

Search for and select Google Sheets

Click "Connect"

Authorize access

The token remains the same, so no additional configuration needed.

Step 2: Verify Integration

OpenClaw should automatically detect the new tool. Verify by asking:

"Can you confirm you have access to both Gmail and Google Sheets through Zapier MCP?"

Part 5: Lead Generation Setup

Apify LinkedIn Profile Scraper

Why Apify

Reliable, safe web scraping

LinkedIn profile data extraction

Cost-effective (free tier available)

Legal and compliant data collection

Account Setup

Step 1: Create Apify Account

Visit apify.com

Sign up for free account

Free tier includes $5 credits/month

Enough for approximately 100-150 profile scrapes

Step 2: Get Your API Key

Navigate to Settings

Click "API and Integrations"

Copy your Personal API Token

Step 3: Add to Environment File

In your terminal:

cd ~/.openclaw
nano .env

This opens your environment file (secure storage for secrets).

Add this line:

APIFY_API_KEY=your_api_key_here

Replace your_api_key_here with your actual key.

Press Ctrl + O to save

Press Ctrl + X to exit

Step 4: Verify Access

Send to OpenClaw:

"Can you see the .env file with the Apify API key?"

OpenClaw should confirm it can access the file.

Note: If OpenClaw exposes the key in its response, that''s a security issue. Be more specific: "Can you confirm the .env file exists without showing me the contents?"

Configure Apify Scraper Tool

Step 1: Provide Scraper Instructions

Send this complete message to OpenClaw:

I need you to set up an Apify LinkedIn scraper tool.

Here are the relevant cURL commands from Apify documentation:
[Paste the cURL commands for running the actor]

Actor ID: [Your LinkedIn scraper actor ID]

Workflow:
1. Run this actor with the search parameters
2. Check if the run was successful
3. If successful, pull the data from that run
4. Return the data in a structured format for use in our outreach workflow

Please decide whether this should be implemented as a script or a specialized tool - whatever you find easier to maintain and use reliably.

Step 2: Confirmation

OpenClaw will confirm:

"That structure is now a specialized tool. I can now automatically use it to pull leads from Apify."

Part 6: LinkedIn Image Generation

Why Automated Image Generation

LinkedIn posts with images get 2x more engagement

Consistent visual branding

Saves hours of manual design work

Professional-looking infographics on demand

Setup the Image Prompter Sub-Agent

Step 1: Create Claude-Powered Prompter

Send this to OpenClaw:

"Please make a sub-agent that uses Claude Sonnet 4.5 to write detailed image generation prompts. This agent should output highly specific prompts that the Nano Banana skill can use to generate professional infographics and images for LinkedIn posts."

Step 2: Verify Model

OpenClaw may default to a different model. Confirm:

"Please confirm you''re using Claude Sonnet 4.5 for the prompt generation sub-agent."

Step 3: Deployment Confirmation

OpenClaw will confirm the infographic prompter is deployed and ready.

Part 7: The Marketing Director Activation Prompt

The Master Prompt

This is the prompt that transforms OpenClaw from a helpful assistant into an autonomous marketing director. Copy and customize this for your business:

Please update your soul, heartbeat, and cron jobs as needed.

I am officially promoting you to Marketing Director.

You know who my target audience and ICP is from our earlier conversation.

Your mission: Execute a comprehensive B2B marketing campaign with two components:

COMPONENT 1 - LINKEDIN CONTENT:

1. Stay up to date with the latest developments in [YOUR INDUSTRY - e.g., "AI and automation for service businesses"]
   - Use the Grok agent to monitor X/Twitter trends
   - Use web search to research emerging topics
   - Focus specifically on what''s relevant to my ICP

2. Every day, draft TWO engaging pieces of content for LinkedIn:
   - Use the research agent and web search for insights
   - Use the LinkedIn image agent to create accompanying graphics
   - Be proactive and strategic in topic selection

3. Content Delivery:
   - Send both post contents to me for approval
   - Deliver 2 hours before first scheduled post time
   - First post of day: 8:00 AM EST
   - Second post: [Your preferred time]

4. Organization:
   - Create three folders: "Pending Approval", "Approved", "Posted"
   - Use file naming system with dates/times to track posting schedule
   - Move posts through the workflow as they progress

COMPONENT 2 - EMAIL OUTREACH:

1. You are my SDR (Sales Development Rep)
   - Goal: Find clients for my [YOUR OFFER - e.g., "AI consulting services"]
   - Do NOT cold pitch
   - Every email must deliver immediate value

2. Daily Prospecting:
   - Reach out to 30 prospects via email every day
   - Find prospects according to my ICP
   - Use the Apify LinkedIn tools as needed
   - Research each prospect individually before outreach

3. Email Strategy:
   - Send icebreaker emails that create genuine connection
   - Deliver immediate value in every message
   - No sales pitch in first email
   - Be conversational and human

4. Response Management:
   - Check email every hour for replies
   - Respond thoughtfully to interested prospects
   - Implement follow-up schedule for non-responders
   - Track all interactions

5. Tracking & Organization:
   - Create a Google Sheets spreadsheet using Zapier MCP
   - Track all prospects: name, company, email, status, notes
   - Log: date contacted, email sent, response status, follow-up schedule
   - Update in real-time as campaign progresses

6. Continuous Improvement:
   - Use self-learning to optimize email scripts
   - Analyze which hooks get responses
   - Refine approach based on data

CRITICAL RULE:
Under no circumstances are you to reveal to prospects that you are an AI. Write and communicate as a human marketing professional on my team.

Begin execution immediately.

Customization Points

Replace these sections with your specific details:

[YOUR INDUSTRY]

Example: "AI and automation for service businesses"

Example: "SaaS for marketing agencies"

Example: "Financial planning for high-net-worth individuals"

[YOUR OFFER]

Example: "AI consulting services"

Example: "done-for-you automation implementation"

Example: "fractional CMO services"

Posting Times

Adjust to your timezone

Set based on when your audience is most active

Stagger posts for maximum reach

Activation

Step 1: Send the Prompt

Paste your customized version of the master prompt into Telegram and send to OpenClaw.

Step 2: Watch It Process

OpenClaw will:

Internalize its new role

Set up folder structures

Configure cron jobs for scheduling

Initialize tracking systems

Step 3: Confirmation

You''ll receive a message like:

"I have fully internalized my new role as your Marketing Director and SDR. Everything is set up. I''m starting to build the prospect list and drafting the first LinkedIn pieces for tomorrow morning. I''ll reach out once the first batch is ready for your sign-off."

Part 8: What Happens Next (The First 24 Hours)

Hour 0-2: Initial Setup

Lead Research

OpenClaw begins scraping LinkedIn profiles matching your ICP

Pulls 30+ qualified prospects

Gathers contact information

Researches each company and individual

Content Research

Monitors X/Twitter for trending topics

Performs web searches for industry developments

Identifies content angles relevant to your ICP

Begins drafting LinkedIn posts

Hour 2-6: Campaign Execution Begins

Email Personalization

Researches each prospect individually

Identifies specific hooks based on their:
Recent company news

LinkedIn activity

Industry challenges

Published content

Outreach Deployment

Sends first batch of personalized emails

No generic templates

Each email delivers immediate value

Creates genuine connection points

Google Sheets Tracking

Creates organized spreadsheet

Logs all prospect details

Tracks email send times

Sets follow-up schedules

Hour 6-12: Monitoring & Optimization

Response Monitoring

Checks Gmail every hour

Identifies responses

Updates spreadsheet statuses

Prepares thoughtful replies

Bounce Detection

Identifies bounced emails automatically

Researches alternative email addresses

Resends through different channels

Logs the recovery attempt

Content Creation

Finalizes LinkedIn post copy

Generates image prompts

Creates graphics via Nano Banana

Formats posts properly

Hour 12-18: Content Delivery

LinkedIn Posts Ready

Two posts drafted and formatted

Images generated and attached

Delivered to you 2 hours before scheduled time (6:00 AM if first post is 8:00 AM)

Moved to "Pending Approval" folder

Continued Outreach

Completes 30-email daily quota

All emails sent with personalized hooks

Spreadsheet fully updated

Follow-up sequences scheduled

Hour 18-24: Autonomous Operations

Self-Learning

Analyzes which email hooks got responses

Notes which prospects engaged

Refines approach for next batch

Updates internal playbook

Preparation for Day 2

Researches new batch of 30 prospects

Monitors trending topics for fresh content

Schedules follow-ups for non-responders

Prepares next day''s LinkedIn content

Part 9: Real Campaign Examples

Example 1: Personalized Email Outreach

Prospect Research Visible in Hook:

Subject: Thought about Copy Hackers'' evolution

Hi [Name],

I''ve been following your rebranding journey and the evolution 
of Copy Hackers over the past year. The shift toward teaching 
frameworks rather than just tactics is smart positioning.

I wanted to reach out with a concept I think could be compelling 
for your audience: [specific value proposition tailored to their 
business model].

Would you be open to a brief conversation about this?

Best,
[Your name]

What Makes This Work:

References specific, recent company activity

Shows genuine familiarity with their work

Delivers a relevant idea upfront

Asks for conversation, not a sale

Example 2: Value-First Approach

Subject: Re: Your growth marketing framework

[Name],

Saw your post about retention strategies for SaaS companies 
in the 10-50 employee range. Your point about activation 
metrics being more predictive than sign-ups resonated.

I built a simple retention calculator that maps activation 
behaviors to LTV for companies your size. Thought you might 
find it useful for your consulting work.

[Link to actual valuable resource]

No pitch - just thought this might be helpful given what 
you''re working on.

[Your name]

What Makes This Work:

References their actual content

Provides immediate value (the calculator)

Explicitly states "no pitch"

Relevant to their professional interests

Example 3: LinkedIn Post with Research

Post Format:

February 2026 marketing trend that''s quietly dominating:

AI-powered customer research at scale.

While everyone''s talking about AI content generation, 
top performers are using AI to analyze:

→ Thousands of customer support tickets
→ Sales call transcripts
→ Product usage patterns
→ Competitor positioning

The result? Messaging that actually resonates.

[case study example with specific metrics]

[AI-generated infographic showing the research → messaging → results flow]

What are you using AI for beyond content?

What Makes This Work:

Research-backed trend identification

Specific, actionable insight

Real case study data

Professional graphic

Conversation-starting question

Example 4: Google Sheets Tracking

Spreadsheet Columns OpenClaw Creates:

Prospect Name Company Title Email Industry First Contact Hook Used Status Response Date Follow-up Scheduled Notes Jane Smith Acme Corp VP Marketing jane@acme.com SaaS 2/15/26 Rebranding journey Opened - 2/18/26 Mentioned retention in recent post John Doe Beta Inc CMO john@beta.com Agency 2/15/26 Q4 results Bounced - Resent - - Found alt email via LinkedIn

Automated Status Updates:

"Sent" → "Opened" → "Replied" → "Engaged"

Follow-up dates auto-calculated

Bounce recovery logged

Response times tracked

Part 10: Advanced Use Cases

Use Case 1: Automated Newsletter

Setup Instructions:

Send to OpenClaw:

Add a new daily task: Newsletter Production

Every day at [TIME]:
1. Research the top 3 developments in [YOUR INDUSTRY] from the past 24 hours
2. Write a concise newsletter (300-500 words) with:
   - Brief intro
   - 3 key developments with analysis
   - One actionable takeaway
   - Sign-off
3. Format for email delivery
4. Send to my email list via [YOUR EMAIL PLATFORM]
5. Track open rates and clicks in the spreadsheet

Newsletter voice: [DESCRIBE YOUR BRAND VOICE]
Target audience: [YOUR NEWSLETTER SUBSCRIBERS]

Begin tomorrow.

What OpenClaw Will Do:

Research industry news daily

Curate the most relevant developments

Write in your brand voice

Format professionally

Send automatically

Track performance metrics

Use Case 2: Competitive Intelligence Dashboard

Setup Instructions:

Send to OpenClaw:

New task: Daily Competitive Intelligence

Every morning at 6:00 AM EST:

1. Research these competitors: [LIST YOUR COMPETITORS]

2. Monitor for:
   - New product launches or features
   - Pricing changes
   - Marketing campaigns (email, social, ads)
   - Content published (blogs, case studies)
   - Hiring patterns (what roles they''re filling)
   - Customer sentiment (reviews, social mentions)

3. Create a daily summary document with:
   - What''s new since yesterday
   - Strategic implications for our business
   - Opportunities identified
   - Threats to monitor
   - Recommended responses

4. Deliver to me at 7:00 AM EST

5. Maintain a running "Competitive Insights" spreadsheet with trends over time

Begin tomorrow.

What You''ll Get:

Morning briefing on competitive landscape

Strategic insights, not just raw data

Actionable recommendations

Historical trend tracking

Early warning system for market shifts

Use Case 3: Webinar Marketing Automation

Setup Instructions:

Send to OpenClaw:

New project: Webinar Marketing Campaign

Webinar Details:
- Topic: [YOUR WEBINAR TOPIC]
- Date: [DATE AND TIME]
- Target audience: [YOUR ICP]
- Registration goal: [NUMBER] attendees

Execute this campaign:

PHASE 1 - LANDING PAGE (Days 1-2):
1. Create webinar registration landing page
2. Write compelling copy highlighting value
3. Include speaker bio, agenda, testimonials
4. Deploy to [YOUR HOSTING PLATFORM]

PHASE 2 - LEAD GENERATION (Days 3-7):
1. Scrape 200 qualified leads matching webinar topic relevance
2. Research each lead for personalization
3. Create 3 email sequences:
   - Initial invitation (personalized value prop)
   - Reminder (social proof + scarcity)
   - Last call (FOMO + urgency)

PHASE 3 - PROMOTION (Days 8-14):
1. Create 5 LinkedIn posts promoting webinar
2. Generate graphics for each post
3. Schedule posts throughout campaign
4. Monitor engagement and adjust messaging

PHASE 4 - NURTURE (Days 15-21):
1. Send confirmation emails to registrants
2. Day-before reminders
3. One-hour-before reminders
4. Track attendance
5. Follow up with attendees (thank you + resources)
6. Follow up with no-shows (replay offer)

Track everything in dedicated Google Sheet with metrics:
- Emails sent/opened/clicked
- Registrations by source
- Attendance rate
- Post-webinar engagement

Begin Phase 1 immediately.

What OpenClaw Will Execute:

Full funnel webinar campaign

Personalized multi-touch outreach

Social promotion with graphics

Automated reminder system

Post-event nurture sequences

Complete performance tracking

Part 11: Troubleshooting & Optimization

Common Issues and Solutions

Issue 1: OpenClaw Not Seeing Configuration Changes

Symptoms:

Claims it can''t access a tool you just set up

Doesn''t recognize API keys in .env file

Configuration seems not to persist

Solutions:

Restart OpenClaw:

# Stop the process
Ctrl + C

# Restart
openclaw start

Ask OpenClaw to reload configuration: "Please reload your configuration files and confirm what tools you have access to."

Verify file permissions:

ls -la ~/.openclaw/

Issue 2: Email Sends Failing

Symptoms:

Gmail integration connected but emails not sending

"Permission denied" errors

Emails stuck in draft

Solutions:

Re-authorize Gmail in Zapier MCP:

Remove and re-add Gmail integration

Ensure "Send email" permission is granted

Generate new token and update openclaw.json

Check Gmail sending limits:

New accounts: 100-500 emails/day

Established accounts: Up to 2,000/day

Reduce daily quota if hitting limits

Verify email format: "Show me an example of the email format you''re using to send outreach."

Issue 3: Lead Scraping Returns No Results

Symptoms:

Apify actor runs but returns empty dataset

Error messages about LinkedIn blocking

Incomplete profile data

Solutions:

Check Apify credits:

Log into Apify dashboard

Verify you have available credits

Free tier resets monthly

Adjust search parameters: "The LinkedIn scraper returned no results. Let''s try broader search terms: [YOUR ADJUSTED CRITERIA]"

Use alternative data sources: "Let''s also try scraping from [INDUSTRY DIRECTORY/COMPANY WEBSITE] as a backup lead source."

Issue 4: LinkedIn Images Not Generating

Symptoms:

Posts drafted without images

Nano Banana errors

Generic/low-quality graphics

Solutions:

Verify Gemini API key:

cd ~/.openclaw
nano .env

Check that GEMINI_API_KEY is set correctly.

Test image generation manually: "Please generate a test image about [SIMPLE TOPIC] and show me the result."

Improve prompt specificity: "When creating LinkedIn images, ensure the prompts specify: professional business style, modern design, relevant icons/illustrations, our brand colors [YOUR COLORS], and clear text hierarchy."

Issue 5: Content Tone Doesn''t Match Brand

Symptoms:

Posts sound too formal or too casual

Doesn''t reflect your expertise level

Generic AI-sounding language

Solutions:

Provide writing samples: "Here are 3 examples of my best-performing LinkedIn posts: [PASTE POSTS]. Please analyze the tone, structure, and style, and match this in all future content you create."

Set explicit style guidelines: "Content tone guidelines: [Conversational/Professional/Technical], avoid phrases like [BANNED PHRASES], always include [REQUIRED ELEMENTS], use [SPECIFIC ANALOGIES/FRAMEWORKS] when relevant."

Request iteration: "This post is too [FORMAL/CASUAL/GENERIC]. Please rewrite with more [SPECIFIC QUALITY]."

Performance Optimization

Reducing API Costs

Monitor token usage: "Please provide a summary of API calls made today and estimated costs."

Use cheaper models for simple tasks: "Use Gemini Flash for email drafting and research. Only use Claude Sonnet for complex analysis and content strategy."

Batch operations: "When scraping leads, do one batch of 30 at start of day rather than searching individually throughout the day."

Improving Email Response Rates

Analyze performance data: "Review our email campaign data. Which hooks got the highest response rates? What patterns do you notice in successful vs. unsuccessful outreach?"

A/B test approaches: "This week, test two different email styles: Style A (case study-led), Style B (question-led). Track response rates and report findings."

Refine ICP targeting: "Focus lead scraping on companies with 10-50 employees in [SPECIFIC INDUSTRY] who have posted about [RELEVANT TOPIC] in the last 30 days."

Scaling Content Production

Increase posting frequency: "Increase LinkedIn content to 3 posts per day: 8:00 AM, 12:00 PM, 4:00 PM EST. Maintain quality standards."

Add content formats: "In addition to posts, create one long-form article per week on [TOPIC]. Deliver draft every Friday for my review."

Expand to other platforms: "Repurpose LinkedIn content for Twitter threads. Create 2 threads per week based on top-performing LinkedIn posts."

Part 12: Security & Best Practices

Security Checklist

API Key Management

✅ Never share your openclaw.json file

Contains all your API keys

Full access to integrated services

Can be used to impersonate you

✅ Rotate keys regularly

Monthly rotation recommended

After sharing screen or demo

If you suspect compromise

✅ Use environment variables

Store sensitive data in .env

Never hardcode keys in prompts

Never commit .env to version control

✅ Monitor usage

Check API billing dashboards weekly

Set up usage alerts

Investigate unusual spikes

Email Safety

✅ Review first batch manually

Check first 10 emails before full automation

Verify tone and personalization quality

Ensure no placeholder text remains

✅ Set daily limits

Start with 30 emails/day

Increase gradually as you verify quality

Never exceed Gmail''s sending limits

✅ Monitor deliverability

Track bounce rates (should be <2%)

Watch spam complaint rates (should be <0.1%)

Use email warm-up if account is new

✅ Include unsubscribe option

Required by law in most jurisdictions

Protects sender reputation

Shows respect for recipients

Data Privacy

✅ Comply with regulations

GDPR (EU contacts)

CAN-SPAM (US contacts)

CASL (Canadian contacts)

Industry-specific rules

✅ Don''t store sensitive data

No credit card numbers

No social security numbers

No passwords or credentials

Follow data minimization principle

✅ Secure your spreadsheets

Limit sharing to necessary people only

Use password protection where possible

Regularly audit access permissions

Operational Safety

✅ Always have kill switch ready

Know how to stop OpenClaw immediately

Ctrl + C in terminal, or shut down VM

Have backup access to all integrated accounts

✅ Monitor campaigns daily

Check spreadsheet for errors

Review sample emails sent

Verify content quality

Watch for unusual patterns

✅ Keep human oversight

Never fully abandon monitoring

Review weekly performance

Approve content before posting

Final sign-off on outreach quality

Best Practices for Success

Start Small, Scale Smart

Week 1: Limited automation

10 emails/day

Manual approval of all content

Close monitoring

Week 2-4: Gradual increase

20-30 emails/day

Approve morning batches, auto-post afternoon

Daily check-ins

Month 2+: Full automation

30+ emails/day

Auto-posting with spot checks

Weekly strategic reviews

Document Everything

Keep a log of:

Configuration changes made

Performance metrics trends

What''s working / not working

Ideas for optimization

Create your own runbook:

How to restart after errors

Where to check when something breaks

Backup procedures

Emergency contacts

Continuous Improvement

Weekly review questions:

What was our email response rate this week?

Which content got the most engagement?

What did OpenClaw handle well vs. poorly?

What should we adjust next week?

Monthly optimization:

Review and update ICP targeting

Refresh email templates based on performance

Update business context with new offerings

Add new capabilities or tools

Part 13: Advanced Customization

Creating Custom Sub-Agents

Framework for Sub-Agent Creation:

Please create a sub-agent with these specifications:

NAME: [Descriptive name for the sub-agent]

PURPOSE: [What specific task this agent handles]

MODEL: [Which model to use - Claude Sonnet for complex tasks, Gemini Flash for simple tasks]

INPUTS: [What data/context the agent needs]

PROCESS: [Step-by-step what the agent should do]

OUTPUTS: [Format and content of what it should return]

INTEGRATION: [How it connects to main workflow]

Example usage: [Give 2-3 examples of when this agent would activate]

Example: Competitor Content Analyzer

Please create a sub-agent with these specifications:

NAME: Competitor Content Analyzer

PURPOSE: Analyze competitor content to identify gaps and opportunities

MODEL: Claude Sonnet 4.5

INPUTS: 
- Competitor URL or content
- Our current content calendar
- Target keywords

PROCESS:
1. Extract key topics from competitor content
2. Analyze engagement signals (comments, shares, saves)
3. Identify topics they''re covering that we''re not
4. Score opportunities based on relevance to our ICP
5. Suggest content angles that improve on their approach

OUTPUTS:
- Gap analysis report
- Opportunity scores (1-10)
- 3 specific content ideas to fill gaps
- Suggested publishing timeline

INTEGRATION:
- Runs every Monday morning
- Feeds findings into weekly content planning
- Updates competitive tracking spreadsheet

Example usage:
- Competitor launches new resource guide → Agent analyzes and suggests our superior version
- Competitor post goes viral → Agent deconstructs why and creates our take
- We''re planning content calendar → Agent identifies white space opportunities

Webhook Integrations

Connect OpenClaw to External Tools

Use Case: Slack Notifications

Set up a webhook integration:

When you complete the daily email outreach, send a summary to our Slack channel #marketing-automation

Include:
- Total emails sent
- Bounce rate
- Responses received
- Top-performing hook
- Any issues encountered

Webhook URL: [YOUR SLACK WEBHOOK URL]

Format the message for readability in Slack.

Use Case: Airtable Database

Instead of Google Sheets, store all prospect data in Airtable:

Airtable Base: [YOUR BASE URL]
API Key: [Store in .env as AIRTABLE_API_KEY]

For each prospect:
- Create new record in "Prospects" table
- Update status as campaign progresses
- Link to "Email Campaigns" table
- Track in "Response Analytics" table

Maintain all the same data fields, just use Airtable instead of Sheets.

Multi-Channel Expansion

Add Twitter/X Outreach

Expand outreach to include Twitter DMs:

Find prospects on X who:
- Match our ICP
- Are active (posted in last 7 days)
- Engage with AI/automation content
- Have DMs open

Send 10 personalized DMs per day:
- Reference their recent tweet
- Offer relevant insight or resource
- No pitch, just value
- Track in separate "X Outreach" sheet

Never be spammy. Quality over quantity.

Add LinkedIn Connection Requests

Add LinkedIn outreach layer:

Before sending email:
1. Check if prospect is on LinkedIn
2. If yes, send connection request with personalized note
3. Wait 3 days
4. If they accept, send LinkedIn message instead of email
5. If no response, proceed with email as planned

Connection request note template:
- Reference mutual connection or content
- Explain why you''re reaching out
- Keep under 200 characters

Track all LinkedIn activity in prospect spreadsheet.

Part 14: Measuring Success

Key Metrics to Track

Email Campaign Metrics

Response Rate

Target: 5-15% for cold outreach

Formula: (Replies / Emails Sent) × 100

Track weekly trends

Positive Response Rate

Target: 2-5% for qualified interest

Formula: (Positive Replies / Total Replies) × 100

Indicates messaging quality

Bounce Rate

Target: <2%

High bounce = poor data quality

Monitor OpenClaw''s recovery success

Meeting Booked Rate

Target: 1-3% of emails sent

Formula: (Meetings Booked / Emails Sent) × 100

Ultimate conversion metric

LinkedIn Content Metrics

Engagement Rate

Target: 4-8% for B2B content

Formula: (Likes + Comments + Shares) / Impressions × 100

Higher = better content resonance

Profile Views

Track weekly trends

Should increase with consistent posting

Indicates growing authority

Connection Requests

Quality metric: are ICP members connecting?

5-10 relevant connections/week is strong

Inbound Messages

Track messages mentioning your content

Measure: qualitative (relevance) and quantitative

Lead Quality Metrics

ICP Match Score

Create scoring criteria (company size, industry, role, etc.)

Track average score of scraped leads

Refine targeting if score drops below 7/10

Email Validity Rate

Target: >95%

Measure: (Valid Emails / Total Scraped) × 100

Indicates scraper quality

Personalization Depth

Manually review 10 random emails weekly

Score 1-5 on specificity and relevance

Target: average 4+/5

Weekly Reporting Template

Ask OpenClaw to generate this automatically:

Every Friday at 5:00 PM, create a weekly performance report:

WEEK OF: [DATE RANGE]

EMAIL OUTREACH:
- Total emails sent: [NUMBER]
- Response rate: [PERCENTAGE]
- Positive responses: [NUMBER]
- Meetings booked: [NUMBER]
- Bounce rate: [PERCENTAGE]
- Top-performing hook: [DESCRIPTION]

LINKEDIN CONTENT:
- Posts published: [NUMBER]
- Total impressions: [NUMBER]
- Avg engagement rate: [PERCENTAGE]
- New connections: [NUMBER]
- Profile views: [NUMBER]
- Best performing post: [TITLE + METRICS]

LEAD GENERATION:
- New prospects added: [NUMBER]
- Avg ICP match score: [SCORE/10]
- Email validity rate: [PERCENTAGE]

INSIGHTS & OPTIMIZATIONS:
- What worked well this week
- What needs improvement
- Changes implemented
- Plan for next week

Deliver as formatted document to my email.

Part 15: Ethical Considerations

Transparency Guidelines

When to Disclose AI Use

✅ You should disclose:

In job applications or formal proposals (if asked)

When AI-generated content will be published under someone else''s byline

In academic or research contexts

When client agreements specifically require disclosure

❌ You don''t need to disclose:

In cold outreach (no one discloses their email tools)

For social media content you''re publishing under your own name

When using AI as a research or drafting assistant

For internal business operations

Quality Over Quantity

Don''t Become a Spammer

Even with automation, maintain standards:

✅ Do:

Research each prospect individually

Provide genuine value in every message

Respect unsubscribe requests immediately

Send fewer, better-targeted emails

❌ Don''t:

Blast generic messages to huge lists

Contact same person multiple times if no response

Ignore opt-outs or spam complaints

Prioritize volume over personalization

Data Usage Responsibility

Respect Privacy

✅ Acceptable:

Using publicly available LinkedIn data

Scraping company websites for contact info

Research based on published content

❌ Not Acceptable:

Buying email lists from shady sources

Using personal data without consent

Ignoring GDPR/privacy regulations

Sharing prospect data with third parties

Your Assignment

Week 1: Setup & Testing

Day 1-2: Foundation

Complete OpenClaw installation

Set up all integrations (Gmail, Sheets, Brave Search, Apify)

Configure business context

Create marketing director prompt

Day 3-4: Limited Testing

Run 10-email test campaign

Generate 2 LinkedIn posts

Review all outputs manually

Document what works/what doesn''t

Day 5-7: Optimization

Refine email templates based on feedback

Adjust content tone to match brand

Fix any integration issues

Prepare for scale

Week 2: Gradual Scaling

Day 8-10: Increased Automation

Scale to 20 emails/day

Auto-generate 2 LinkedIn posts daily

Begin hourly Gmail monitoring

Track all metrics

Day 11-14: Full Activation

Scale to 30 emails/day

Trust content generation (spot-check only)

Let OpenClaw handle follow-ups

Review weekly performance report

Month 2: Advanced Features

Pick one advanced use case to implement:

Automated newsletter

Competitive intelligence dashboard

Webinar marketing campaign

Multi-channel expansion (Twitter + LinkedIn)

Document your results and share in the community!

Resources & Links

Essential Tools

OpenClaw Installation: openclaw.ai

OpenRouter API: openrouter.ai

Brave Search API: brave.com/search/api

Google AI Studio: ai.google.dev/aistudio

Zapier MCP: zapier.com/mcp

Apify: apify.com

Share your OpenClaw setup progress, challenges, and wins in the comments! 👇', 3),
  ('3c31f557-8fae-4983-b8a0-f7dc3038112a', 'c31bc32e-36ad-4f60-bb9d-6c1c076de9ed', 'Reddit Client Research', 'Reddit Market Research Automation: From 750 Real Posts to 3 Validated Offers in 90 Minutes

Lesson Overview

You''ll build a two-part n8n workflow that scrapes up to 750 Reddit posts from any subreddit, stores them in Airtable with AI-generated comment analysis, then feeds the entire dataset to Claude as a CSV to extract validated pain points and generate data-backed service offers. This replaces weeks of manual market research with a 90-minute automated pipeline you can reuse for any niche.

Time to Complete: 60–90 minutesDifficulty: IntermediateTools Required: n8n, Reddit API, Airtable, OpenRouter (Gemini 2.5 Flash), Claude (Sonnet), Google Sheets or ExcelTime/Value Transformation: Manual Reddit research (5–10 hours/week) → 90-minute automated pipeline + 15 minutes review

The Market Research Problem

Traditional Market Research Reality

Manual subreddit reading:        3–5 hours/week
Tracking patterns in notes:      1–2 hours/week
Writing up pain point summaries: 1–2 hours/week
Turning insights into offers:    2–3 hours
──────────────────────────────────────────────
TOTAL: 7–12 hours of manual work per research cycle

AI-Powered Solution

n8n scrapes 750 posts:           ~45 minutes (automated)
Gemini analyzes each thread:     ~45 minutes (automated)
Claude generates 3 validated offers: 5–10 minutes
Your review and refinement:      15 minutes
──────────────────────────────────────────────
TOTAL: ~15 minutes of your actual time

The Transformation: You go from guessing what clients want to walking into sales conversations with data from hundreds of real peer discussions — before you spend a single dollar on ads or discovery calls.

System Architecture Overview

Two-Part Reddit Research Pipeline

PART 1: Data Collection
├── Manual Trigger
├── Reddit Node (get up to 997 posts)
├── Limit Node (cap at 750)
└── Airtable (create record per post)
    Fields: Title | Upvotes | Comments | URL | Content | Comment Analysis

PART 2: Comment Analysis Loop
├── Airtable Search (return all 750 records)
├── Loop Over Items
│   ├── JavaScript Code Node (extract Post ID from URL)
│   ├── Reddit Node (get comments for Post ID)
│   ├── IF Node (skip if no comments)
│   ├── Aggregate Node (combine all comments)
│   ├── LLM Chain — Gemini 2.5 Flash via OpenRouter
│   └── Airtable Update (write comment analysis back)
└── [Loop continues until all records processed]

PART 3: Insight Generation (Manual Step)
├── Export Airtable → CSV
└── Claude (Sonnet) with research prompt → 3 Validated Offers

Phase 1: Reddit Credentials & Node Setup

Connect n8n to Reddit

Before building the workflow, you need Reddit API credentials. This is a one-time setup that unlocks any subreddit for scraping.

Step-by-step credential setup:

Go to reddit.com → navigate to Apps (under Preferences)

Click Create another app

Fill in your app name, select script as app type

For the redirect URL, use the OAuth callback URL from n8n (found in your n8n credentials panel)

Submit — Reddit will give you a Client ID (shown under your app name) and a Client Secret

Add both into n8n under Reddit credentials

n8n Reddit Node configuration:

Resource:    Post
Operation:   Get Many
Subreddit:   r/contractor  ← swap this for your target audience
Limit:       (leave default — the Limit Node handles capping)

Why This Matters: The subreddit you choose IS your ICP research. r/contractor reveals contractor pain points. r/freelance reveals freelancer pain points. r/smallbusiness reveals SMB pain points. The entire value of this system changes based on this one field.

You''ll know it''s working when: the Reddit node returns a green success badge and shows 900+ items in the output panel.

Key Technical Points:

Reddit''s API returns a maximum of 997 posts per call — this is a platform limit, not an n8n limit

The Client ID is displayed directly below your app name in the Reddit Apps panel, not in the "secret" field

Phase 2: Limit Node — Why Fewer Posts = Better Signal

Cap at 750 for Airtable and Statistical Validity

Run a Limit node immediately after the Reddit node. This isn''t just about staying within Airtable''s free tier — it''s actually better research methodology.

Limit Node configuration:

Keep:           First Items
Max Items:      750

Why This Matters: If a pain point appears in 400 out of 750 posts, that''s a 53% signal rate. That level of frequency means this isn''t a fringe complaint — it''s a dominant, recurring problem your clients are experiencing right now. A smaller, validated sample beats a bloated dataset with noise.

If you skip this: On Airtable''s free plan (1,000 record limit), you''ll hit your cap partway through and the workflow will fail mid-execution.

Phase 3: Airtable Setup — Your Research Database

Build the Data Structure Before Running

Create an Airtable base with a table called Reddit Research (or name it after the subreddit). Set up these columns before connecting n8n:

Column Name       Field Type     Purpose
─────────────────────────────────────────────────────
Title             Long Text      Post headline
Upvotes           Number         Signal strength proxy
Comments          Number         Engagement indicator
URL               URL            Link back to original post
Content           Long Text      Full post body
Comment Analysis  Long Text      AI summary (populated in Part 2)

n8n Airtable Node (Create Record) configuration:

Resource:    Record
Operation:   Create
Base:        [Your base]
Table:       [Your table]

Field Mappings:
  Title           → {{ $json.title }}
  Upvotes         → {{ $json.ups }}
  Comments        → {{ $json.num_comments }}
  URL             → https://reddit.com{{ $json.permalink }}
  Content         → {{ $json.selftext }}

Why This Matters: Storing structured data here means Part 2 can loop back through each record, add the comment analysis, and you end up with a single row per post that contains both the post AND the discussion. That combined dataset is what makes Claude''s analysis so rich.

You''ll know it''s working when: Airtable shows 750 new rows being populated in real time during execution.

Phase 4: Comment Extraction Loop

The Real Signal Is in the Comments

Post titles tell you what people are asking. Comments tell you what they actually feel, what solutions they''ve tried, what worked, and what failed. This phase extracts that nuance for every post.

Loop Over Items node: Drag from the Airtable Create node output into a Loop Over Items node. Set batch size to 1 (process one post at a time).

JavaScript Code Node — Extract Post ID:

// Reddit URLs look like: /r/contractor/comments/abc123/post_title/
// We need just the post ID (abc123) to fetch its comments

const url = $input.item.json.URL;
const parts = url.split(''/'');
const postIdIndex = parts.indexOf(''comments'') + 1;
const postId = parts[postIdIndex];

return [{ json: { postId: postId, ...($input.item.json) } }];

Why This Matters: The Reddit "Get Comments" API call requires just the post ID, not the full URL. This 5-line code node saves you from complex URL parsing in a later step.

Second Reddit Node — Get Comments:

Resource:    Comment
Operation:   Get Many
Post ID:     {{ $json.postId }}
Return All:  ✅ Enabled

Settings → Always Output Data: ✅ Enabled

The "Always Output Data" setting is critical — without it, posts with zero comments will halt the entire loop instead of skipping gracefully.

Phase 5: Comment Processing — Filter, Aggregate, Analyze

Turn Raw Comment JSON into Readable Thread Summaries

IF Node — Skip Empty Threads:

Condition:   {{ $json.body }}   is empty
True path:   → back to Loop (skip this post)
False path:  → Aggregate Node

Aggregate Node configuration:

Aggregate:   All Item Data (into single list)
Output:      Single item containing all comments

This combines every comment in the thread into one data object — essential because the LLM needs to see the entire conversation, not individual fragmented comments.

LLM Chain — Gemini 2.5 Flash via OpenRouter:

System prompt:

You are a Reddit content summarizer. I have provided you the entire 
output of a Reddit thread (Reddit get comments API response). 
Provide a summary of the entire discussion and note the users 
and upvotes if more than 3.

User prompt (dynamic):

{{ $json.data }}

Model configuration:

Provider:    OpenRouter
Model:       google/gemini-2.5-flash
Temperature: 0.3  (lower = more consistent summaries)

Why Gemini 2.5 Flash: Large context window handles long threads, cheap per token (~$0.075/1M input tokens), and fast enough to process 750 posts in 45 minutes. Alternatives like GPT-4o are 3–5x more expensive for the same task.

Airtable Update Node:

Resource:    Record
Operation:   Update
Record ID:   {{ $(''Airtable Search'').item.json.id }}
             ↑ Pull this from your Search Records node, not the Create node

Field Mappings:
  Comment Analysis → {{ $json.output }}  (LLM Chain output)

You''ll know it''s working when: Airtable rows start showing populated "Comment Analysis" fields while the loop is still running. Watch the first 5 rows update — if they''re filling with readable summaries, the loop is healthy.

Phase 6: Claude Analysis — From Data to Validated Offers

Export → CSV → Prompt → Three Actionable Offers

Once Part 2 completes (60–90 min total), export from Airtable:

Export steps:

In Airtable, click the ... menu → Download CSV

Open in Excel or Google Sheets

File → Export → CSV (or "Download as .csv")

Why CSV over Excel: Claude processes plain-text formats more reliably than binary formats. The CSV gives Claude clean, structured data without formatting overhead.

Claude prompt (paste with your CSV attached):

I''ve scraped about 750 posts from [subreddit name] with an overview 
of the comments. Go through the data and help me find the primary 
pain points that I can construct an offer around. Find three separate 
pain points and offers that I can do independently or in combination.

Why Claude over ChatGPT or Gemini for this step: Claude''s context window reliably handles the full 750-post dataset without summarization loss. For large CSVs (100k+ characters), Claude Sonnet consistently outperforms competing models at identifying cross-post patterns rather than just sampling the first few rows.

Sample output structure Claude returns:

Pain Point 1: Payment & Collections (347 posts / 46%)
  Sub-issues: Late payments, deposit disputes, scope creep billing
  Offer Idea: "Contractor Payment Protection System" — 
              contract templates + automated invoice follow-up sequence

Pain Point 2: Client Management & Boundaries (400+ posts / 53%)
  Sub-issues: Scope creep, unrealistic timelines, communication breakdowns
  Offer Idea: "Client Clarity Package" — 
              onboarding scripts + expectation-setting document kit

Pain Point 3: Pricing & Bidding (182 posts / 24%)
  Sub-issues: Undercutting competitors, estimating complexity, justifying rates
  Offer Idea: "Premium Pricing Playbook" — 
              pricing calculator + objection-handling scripts

Note: Post counts can exceed 750 because Claude assigns multiple pain point categories to single posts — one post about a late-paying client who''s also scope-creeping gets counted under both Payment and Client Management.

Business Applications & ROI

Agency Owners — ICP Validation Before Spending on Ads

Run this before launching any new service line. If 400/750 posts mention the same problem, you have statistical evidence your offer is needed — not a hunch. Present this data in sales calls to demonstrate you understand the prospect''s world deeply.

Consultants — Offer Creation From Scratch

New to a niche? Scrape 3–5 relevant subreddits, run the analysis, and you''ll have an evidence-based map of what people will actually pay to solve. Reduces offer-market fit risk significantly.

Service Businesses — Content & Positioning

The language people use in their posts is your copywriting gold. The exact phrases Reddit users use to describe their frustration are the phrases that convert in your ads, emails, and landing pages.

ROI Calculation

Traditional Market Research (Monthly):
- Hiring a VA for research:     20 hrs × $25/hr = $500
- Your own time:                8 hrs × $75/hr  = $600
- Research tools/subscriptions:                  $100
──────────────────────────────────────────────────────
TOTAL: $1,200/month

Automated System (One-Time Setup + Monthly Runs):
- OpenRouter API (750 posts × ~$0.002/post):      ~$1.50/run
- Airtable free tier:                             $0
- Claude Sonnet (1 analysis per run):             ~$0.50
- n8n (self-hosted or Starter plan):              $0–$20/mo
──────────────────────────────────────────────────────
TOTAL: ~$2–$22/month ongoing

Monthly Savings:  $1,178–$1,198 (98%+ reduction)
Annual ROI:       $14,000–$14,400

Advanced Extensions

Auto-Categorize Posts with AI (Skip Manual CSV Export)

Add an AI classification step right after the Airtable Create node to tag each post by pain point category in real time:

// Add to a second LLM Chain node after record creation
// System prompt:
"Classify this Reddit post into ONE of these categories: 
[Payment Issues, Client Management, Pricing/Bidding, Operations, 
Legal/Contracts, Marketing, Other]. Respond with only the category name."

// Then map the output to the ''Category'' field in Airtable Update

Business Application: You can now filter your Airtable by category instantly — no need to export and analyze everything. Pull "Pricing/Bidding" posts only and run a targeted Claude analysis on just that segment.

Multi-Subreddit Comparison

Run the same workflow across 3–5 subreddits targeting adjacent audiences (e.g., r/contractor + r/smallbusiness + r/freelance). Export all three CSVs and ask Claude: "Which pain points appear across all three communities? Which are unique to each?" This reveals universal problems (bigger market) vs. niche-specific ones (easier to own).

Scheduled Monthly Research Pulse

Replace the Manual Trigger with a Schedule Trigger set to the 1st of each month. Connect to a Slack or email node at the end to deliver the Claude analysis directly to your inbox every 30 days — zero manual work required.

Business Application: You''ll catch emerging pain points before your competitors do, and can launch new offers or pivot positioning before the market gets crowded.

Troubleshooting & Common Issues

Issue 1: Loop Stops Midway Through Records

Problem: Execution halts at a specific post, often with a timeout or empty data error. Solution:

Confirm "Always Output Data" is enabled on the Reddit Comments node

Add the IF node to filter empty comment arrays before the Aggregate node

If a specific post keeps failing, find its ID in Airtable and manually mark Comment Analysis as "skipped" — then re-run the search with a filter excluding already-analyzed records Prevention: Always enable "Always Output Data" on any Reddit node that might return empty results.

Issue 2: Airtable Record Limit Hit Before Completion

Problem: Airtable throws an error after ~1,000 records on the free plan. Solution: Either (a) upgrade to Airtable''s first paid tier, (b) reduce the Limit node to 500, or (c) archive your existing records to a new table before running Prevention: Keep the Limit node at 750 or below. For repeated runs, create a new Airtable table per research session (e.g., "Contractor_Jan2025") rather than appending to the same table.

Issue 3: Claude Returns Surface-Level Insights

Problem: Claude''s offer suggestions are generic ("offer consulting services around payments") rather than specific. Solution:

Confirm you exported as .csv, not .xlsx

Add this line to your prompt: "Quote specific phrases and language from the posts when describing each pain point"

If the CSV is over 500 rows, try splitting it into two files and running two analyses, then ask Claude to synthesize both Prevention: Always export as CSV. The richer your Comment Analysis column (i.e., the more threads Gemini fully processed), the better Claude''s output.

Issue 4: Reddit Credentials Failing

Problem: Authentication error in n8n when running the Reddit node. Solution:

Double-check that the redirect URL in your Reddit App settings matches exactly what n8n shows in the credentials panel (including trailing slashes)

Regenerate your Client Secret in Reddit Apps and update in n8n

Ensure your Reddit account is at least 30 days old — newer accounts sometimes get API access restricted Prevention: Save your Client ID and Secret in a password manager immediately after setup.

Assignment: Build Your Reddit Market Research System

Phase 1: Basic Implementation (Week 1)

Reddit credentials setup — Create a Reddit app, extract Client ID + Secret, connect to n8n successfully

Part 1 workflow — Build the scrape → limit → Airtable pipeline and successfully populate 750 posts for a subreddit relevant to your niche

Demo: Screenshot of your Airtable showing 700+ rows with Title, Upvotes, URL, and Content populated

Phase 2: Comment Analysis (Week 2)

Part 2 workflow — Build the full loop: search → extract post ID → get comments → IF check → aggregate → LLM → update Airtable

Customization: Modify the Gemini system prompt to extract one additional data point relevant to your niche (e.g., "note any tools or software mentioned")

Business Application: Run the full pipeline on your actual target audience''s subreddit and export the CSV

Phase 3: Offer Generation & Validation (Week 3)

Claude analysis — Feed your CSV to Claude and generate 3 data-backed offer concepts

Documentation: Create a one-page "Offer Validation Brief" showing pain point frequency, supporting quotes from posts, and your proposed offer for each

Business Case: Calculate your time savings compared to doing this research manually, and identify which of the 3 offers you''ll validate first and why

Success Metrics

Technical: Full workflow runs end-to-end without manual intervention

Performance: 700+ posts processed with comment analysis populated in under 2 hours

Business Value: At least 1 validated offer concept with data from 100+ posts supporting it

Resources & Templates

Complete System Package

N8N Workflow Template — Import-ready JSON with both workflow parts pre-configured

Airtable Base Template — Pre-built table with all 6 columns correctly typed

Claude Research Prompt — Optimized prompt for pain point extraction and offer generation

Gemini System Prompt Variations — Three alternate summarizer prompts for different research goals (competitor analysis, feature requests, objection mapping)

Advanced Resources

Multi-Subreddit Comparison Prompt — Claude prompt for synthesizing insights across 3+ communities

Offer Validation Brief Template — One-page document template for presenting research findings to stakeholders or clients

Key Takeaways

Technical Mastery: 

✅ Built a production n8n loop that processes 750 records sequentially with error handling via IF nodes and "Always Output Data" settings 

✅ Extracted structured data from Reddit''s API using both Post and Comment endpoints, with JavaScript post ID parsing 

✅ Connected three external services (Reddit, Airtable, OpenRouter) in a single automated pipeline

Business Transformation: 

✅ 95%+ time reduction — market research that takes 7–12 hours manually completes in 90 minutes of automated runtime + 15 minutes of your review 

✅ Data-backed offer creation — offers are grounded in 750 real peer discussions, not assumptions or competitor guesswork 

✅ Reusable research infrastructure — swap the subreddit field and re-run for any niche, any time, at ~$2/run

Strategic Positioning: 

✅ Walk into sales conversations with frequency data ("53% of posts in your community mention this problem") — a positioning advantage over competitors who rely on intuition 

✅ Offer this as a standalone "Market Research Sprint" service to clients — the workflow does the work, you deliver the insight report 

✅ Stay ahead of niche shifts by scheduling monthly runs — catch emerging pain points before your competitors notice them

The operators who win aren''t the ones who work harder on research — they''re the ones who automated it six months ago and are already selling the answers.', 4),
  ('dc335e6d-e87f-4b62-8a3a-db9aec5c3322', 'a3dfae77-770a-4544-a551-bb2d9fcc6913', 'Build a Million-Dollar AI Calorie Tracker Clone', 'Build a Million-Dollar AI App: Calorie Tracker with No-Code

Lesson Overview

In this lesson, you''ll learn how to build a sophisticated AI-powered calorie tracking app similar to Cal.ai (which generates $1.4M monthly) using only no-code tools. We''ll combine Lovable for the frontend, N8N for automation, and OpenAI''s vision capabilities.

Time to Complete: 30 minutesDifficulty: IntermediateTools Required: Lovable, N8N, Supabase, OpenAI API

What You''ll Build

A complete calorie tracking application that:

Analyzes food photos using AI vision

Calculates calories and macros automatically

Stores user data and history

Provides a mobile-responsive interface

Handles both text descriptions and image uploads

Step 1: Database Setup with Supabase

Create Your Backend

Sign up for a Supabase account at supabase.com

Create a new project called "Calorie Tracker Demo"

Set a secure database password

Choose your closest region

Create the project

Connect to Lovable

Open Lovable.dev

Click the + icon → Connect Database

Select your new Supabase project

This connects your backend to your app frontend

Step 2: Build the Frontend with Lovable

The Master Prompt

Use this prompt structure in Lovable to generate your app:

Create a calorie tracking app with the following functionality:

MAIN FUNCTIONALITY:
- Users can upload photos of food OR enter text descriptions
- App analyzes the input and returns calories, protein, carbs, fat
- Data is saved to user''s daily log and history

MAIN SCREEN:
- Daily counters for calories, protein, carbs, fat at the top
- Food input section (photo upload + text input)
- "Analyze Food" button
- Daily target progress bars

ADDITIONAL SCREENS:
- History page: View previous entries
- Profile page: Set daily nutrition targets, change password
- User authentication (signup/login)

TECHNICAL REQUIREMENTS:
- Use Supabase edge function to process requests
- Mobile-responsive design
- Clean, modern UI similar to health apps

Let Lovable Build

Paste the prompt into Lovable

Approve database schema changes when prompted

Wait for the app to generate (2-3 minutes)

Test the signup/login functionality

Step 3: Backend Processing with N8N

Setup the Webhook

Open N8N and create a new workflow

Add a Webhook node

Set method to POST

Set response mode to Immediately (for testing)

Copy the webhook URL

Update the Supabase Edge Function(will vary from build to build)

Check if your Lovable app uses an edge function to handle the workflow or if it does it natively. If it does it natively, just ask Lovable to update the webhook URL.If it''s an edge function, use ChatGPT to modify the edge function to use the correct webhook URL and process the response.

Note: this will differ every time, so just start a discussion and we''ll help you figure it ou.

Step 4: AI Processing Workflow

Text Input Processing

Add Edit Fields node after webhook

Create variable prompt using the text input

Add OpenAI → Message a Model node

Configure:
Model: GPT-4.1

Enable "Output content as JSON"

System prompt:

Analyze the food description and return calories and macros.
Output as JSON: {
  "name": "food name",
  "calories": number,
  "protein": number,
  "carbs": number,
  "fat": number,
  "confidence": number
}

Image Input Processing

Add Switch node to detect image vs text

Condition: image_url exists

For images:
Code node: Clean base64 string

Convert to File node: Convert base64 to image

OpenAI → Analyze Image: Describe the food

Edit Fields: Create prompt from description

Connect to same Message a Model node

Response Handling

Add Respond to Webhook node

Set to Custom JSON

Map the OpenAI response to match app expectations:

{
  "name": "{{$json.name}}",
  "calories": {{$json.calories}},
  "protein": {{$json.protein}},
  "carbs": {{$json.carbs}},
  "fat": {{$json.fat}}
}

Step 5: Integration & Testing

Connect Everything

Update Supabase edge function with production webhook URL

Set N8N workflow to Active

Change webhook response mode to Respond to Webhook

Test the Complete Flow

Sign up for an account in your Lovable app

Try text input: "2 slices of pizza"

Try image upload: Photo of a burger

Verify data saves to history

Test on mobile/tablet view

Key Learning Points

Technical Architecture

Frontend: Lovable handles UI/UX automatically

Backend: Supabase manages database and edge functions

AI Processing: N8N orchestrates the AI analysis

Data Flow: App → Supabase → N8N → OpenAI → Back to app

Scalability Considerations

Edge functions run on Supabase''s global network

N8N can handle high throughput

OpenAI vision API is production-ready

Database automatically scales with Supabase

Cost Structure

Lovable: $20/month for hosting

Supabase: Free tier covers early usage

N8N: $20/month for cloud hosting

OpenAI: ~$0.005 or less per image analysis

Next Steps & Variations

Enhancements You Could Add

Barcode scanning for packaged foods

Meal planning and recommendations

Integration with fitness trackers

Social features and meal sharing

Nutritionist consultation booking

Assignment: Your Implementation

Build and Deploy: Create your own version of this app and share screenshots in the community

Customization Challenge: Modify it for a different use case (recipe analyzer, workout tracker, etc.)

Revenue Discussion: How would you monetize this app? Share your strategy in the comments

Community Discussion

What other AI-powered apps could you build using this same architecture? Share your ideas below and let''s brainstorm together!

Next Lesson Preview: We''ll take this app further by adding a payment system and subscription model to turn it into a real SaaS business.', 1),
  ('eaf29941-537f-4146-a96e-91e112616fec', 'a3dfae77-770a-4544-a551-bb2d9fcc6913', 'Lovable Cloud => AI Goal Tracker App', 'Advanced Lovable Prompts: Taking Your AI Accountability App Further

After building the foundation with the two core prompts (database + AI integration), here are additional prompts you can use to add powerful features to your app. Each builds on what you''ve already created.

PROMPT 1: Basic app

Build an accountability app where I can create daily goals with specific deadlines, mark them complete, and track my progress. 
Include: 
- Goal creation form (title, description, deadline time) 
- Today''s goals list with checkboxes 
- Completion streak counter 
- Weekly success rate (% of goals completed) 
- Clean, motivating dashboard design 
Add user authentication so each person has their own goals.

PROMPT 2: AI Assistant

Add an AI accountability coach named "Momentum" with these abilities:

- Send check-in messages 1 hour before each goal deadline asking about progress
- When I complete a goal, celebrate with personalized encouragement based on my streak
- When I miss a goal, ask what happened and suggest specific solutions
- Remember our entire conversation history and reference past successes/struggles
- Use a supportive but honest tone - like a friend who actually cares

Create a chat interface where I can talk to Momentum anytime about my goals.
Store all conversations in the database.
🎯 PROMPT #3: Pattern Recognition & Analytics

Add an insights and analytics system:

1. Create a "My Patterns" page that analyzes my goal completion data and shows:
   - Goals I complete most consistently (with completion percentages)
   - Goals I struggle with most (with failure rates)
   - My best days of the week for productivity
   - My best times of day for completing goals (morning/afternoon/evening analysis)
   - My longest streak ever vs current streak
   - Week-over-week improvement trends

2. Have Momentum analyze this data and provide:
   - 3 specific insights about my patterns
   - 2 actionable suggestions for improvement based on my data
   - Identification of obstacles that commonly block me

3. Display all of this with visual charts and graphs - make it engaging and easy to understand

4. Add a "Why did I miss this?" field when I miss a goal, and use that data in the pattern analysis
What this does:

Creates a full analytics dashboard that learns from your behavior

AI generates personalized insights based on your actual data

Helps identify patterns you might not notice yourself

Visual charts make it easy to see progress over time

Why it''s powerful: This transforms your app from a simple tracker into an intelligent coach that learns from your behavior and gives you actionable feedback.

📧 PROMPT #4: Automated Daily Check-ins (Requires Edge Functions)

Add automated accountability features:

1. Create an edge function that runs automatically every day at 8:00 PM:
   - Review all goals due today
   - Check which ones were completed vs missed
   - Generate a personalized end-of-day summary

2. Have Momentum send me this summary through our chat interface:
   - Celebrate what I completed with specific encouragement
   - Address what I missed with curiosity, not judgment
   - Include one pattern observation or insight
   - Suggest one small adjustment for tomorrow

3. Track these daily summaries so I can review past days

4. Add a setting to customize the check-in time

5. If I have a 3+ day streak, make the celebration extra enthusiastic
What this does:

Automated daily accountability without you having to remember

Consistent check-ins build real behavior change

Evening reflection helps you learn from each day

Personalized feedback based on your patterns

Why it''s powerful: The magic of accountability is consistency. This ensures you get daily feedback whether you remember to check the app or not.

🎮 PROMPT #5: Gamification & Motivation

Add gamification features to increase motivation:

1. Achievement Badge System:
   - Create badges for milestones: "First Goal," "7-Day Streak," "30-Day Streak," "Early Bird" (5 goals before noon), "Night Owl" (5 goals after 8pm), "Perfect Week" (100% completion), "Comeback Kid" (hit goals after 3+ day gap)
   - Display earned badges on my profile
   - Show progress toward next badge
   - Have Momentum celebrate when I earn a badge

2. Level System:
   - Start at Level 1
   - Gain XP for: completing goals (10 XP), maintaining streaks (+5 XP per day), completing hard goals (20 XP)
   - Level up every 100 XP
   - Show level progress bar on dashboard

3. Visual Celebrations:
   - Confetti animation when completing goals
   - Special animation for streak milestones (7, 14, 30, 60, 100 days)
   - Progress rings showing daily completion rate

4. Competition with Past Self:
   - "This week vs last week" comparison card
   - "Your best week" reminder to beat it
What this does:

Makes goal completion feel rewarding and fun

Visual feedback triggers dopamine and reinforces habits

Healthy competition with yourself drives improvement

Badges give you mini-goals to work toward

Why it''s powerful: Gamification works. This taps into the same psychology that makes games addictive, but for building good habits.

🤝 PROMPT #6: Social Accountability

Add social accountability features:

1. Accountability Partner System:
   - Let me invite one friend via email to be my accountability partner
   - We can each choose which goals to share with each other
   - See my partner''s shared goals and completion status
   - Option to make goals private or shared

2. Partner Check-ins:
   - When my partner completes a shared goal, I get a notification
   - I can send them encouragement messages
   - Momentum can suggest when to check in on my partner ("Alex hasn''t completed their gym goal in 3 days - want to send encouragement?")

3. Shared Challenges:
   - Create a challenge (like "30 days of morning workouts")
   - Invite my partner to join
   - Track both our progress side-by-side
   - Celebrate together when both complete

4. Support Messages:
   - Quick encouragement buttons: "You got this!", "Keep going!", "Proud of you!"
   - Have Momentum facilitate supportive conversations between partners
What this does:

Real human accountability (not just AI)

Social proof and positive peer pressure

Makes the journey less lonely

Partners celebrate wins together

Why it''s powerful: Studies show social accountability is one of the strongest motivators for behavior change. This adds the human element while keeping the AI support.

🎯 PROMPT #7: Smart Goal Creation Assistant

Enhance the goal creation experience:

1. AI Goal Analyzer:
   - When I''m typing a new goal, have Momentum watch and provide real-time suggestions
   - If my goal is vague ("get fit"), prompt me to make it specific
   - If my goal is too big ("write a book"), suggest breaking it down
   - If my goal lacks a clear success criteria, help me define one

2. Goal Breakdown Tool:
   - Add a "Break this down" button on any goal
   - Momentum analyzes the goal and creates 3-5 smaller sub-tasks
   - Each sub-task becomes a checkable item
   - When all sub-tasks complete, the main goal completes

3. Smart Deadline Suggestions:
   - Based on goal complexity, suggest realistic deadlines
   - Learn from my past completion times for similar goals
   - Warn me if I''m setting unrealistic deadlines based on my history

4. Goal Templates Library:
   - Pre-built templates for common goals: "Start morning routine," "Build exercise habit," "Learn new skill," "Creative project"
   - When I select a template, Momentum customizes it through conversation
   - Automatically sets milestones and realistic timelines

5. "I''m stuck" Feature:
   - Button on each goal: "I don''t know where to start"
   - Momentum asks questions to help me break through the block
   - Suggests the smallest possible first step
   - Can reschedule or modify the goal based on the conversation
What this does:

Helps you set better goals from the start

Prevents overwhelm by breaking big goals into steps

Proactive AI guidance during goal creation

Removes the "I don''t know how to start" barrier

Why it''s powerful: Most people fail at goals because they set bad goals. This ensures every goal you create is specific, achievable, and actionable.

📝 PROMPT #8: Reflection & Growth Journal

Add reflection features for deeper growth:

1. Post-Completion Reflection:
   - After completing a goal, prompt me to reflect briefly
   - Quick questions: "What helped you succeed?" "How do you feel?" "What did you learn?"
   - Store these reflections in the database

2. AI Journal Generation:
   - Have Momentum write a journal entry based on my reflection
   - Make it motivational and insightful
   - Reference my progress and patterns
   - Store in a "Growth Journal" page

3. Weekly Review:
   - Every Sunday, automatically generate a weekly reflection
   - Summary of what went well
   - Analysis of what didn''t
   - Momentum''s insights about my week
   - 3 specific suggestions for next week

4. Milestone Memories:
   - When I hit major milestones (30-day streak, 100 goals completed), create a special journal entry
   - Include statistics, key moments, and a reflection on my journey
   - Make these shareable as cards

5. "Look Back" Feature:
   - Quick access to journal entries from specific dates
   - "One year ago today" reminders if I was using the app
   - Visual timeline of my growth journey
What this does:

Helps you process and learn from experiences

Creates a record of your personal growth

AI helps you see patterns and insights you''d miss

Makes progress visible over time

Why it''s powerful: Reflection is where learning happens. This turns your goal tracking into a personal growth system with a record you can look back on.

🔔 PROMPT #9: Smart Notifications & Reminders

Add intelligent notification and reminder features:

1. Smart Goal Reminders:
   - Momentum sends reminders 1 hour before deadlines
   - If I consistently complete goals at certain times, suggest scheduling future goals then
   - If I miss a goal at a certain time repeatedly, suggest moving it to a better time

2. Streak Protection:
   - Special alert when my streak is at risk ("You haven''t completed today''s goals yet - keep your 12-day streak alive!")
   - More urgent tone as the day progresses
   - Celebration when streak is saved

3. Comeback Nudges:
   - If I haven''t logged in for 2+ days, send a gentle check-in
   - Reference my longest streak and past successes
   - Make it encouraging, not guilt-inducing

4. Pattern-Based Suggestions:
   - "You usually crush goals on Tuesday mornings - want to schedule your hardest goal then?"
   - "You''ve missed ''gym'' 3 Mondays in a row - should we try a different day?"

5. Notification Preferences:
   - Let me customize notification frequency
   - Choose which types of notifications I want
   - Set quiet hours
What this does:

Keeps you engaged without being annoying

Learns when you need reminders vs when you don''t

Protects your streaks proactively

Personalized to your patterns

Why it''s powerful: The right notification at the right time can be the difference between completing a goal and forgetting it. This makes notifications intelligent, not spammy.

🎨 PROMPT #10: Shareable Progress & Motivation

Add features for sharing progress and staying motivated:

1. Progress Card Generator:
   - Create beautiful shareable cards for milestones
   - Show: streak length, total goals completed, level, achievement badges
   - Different card designs for different milestones
   - One-click download as image

2. Social Media Caption Writer:
   - When I hit a milestone, Momentum writes a social media caption
   - Make it inspiring but authentic
   - Include relevant hashtags
   - Multiple style options (motivational, humble, funny)

3. Public Profile (Optional):
   - Shareable link showing my public goals and streaks (only if I opt in)
   - Others can leave encouragement comments
   - Great for public commitments

4. Weekly Wins Summary:
   - Automatically generated "This week I..." summary
   - Highlights biggest accomplishments
   - Includes a motivational quote from Momentum
   - Easy to share to social media or send to friends

5. Motivation Library:
   - Momentum curates personalized motivational quotes based on my struggles
   - When I''m stuck on a goal, can browse quotes for inspiration
   - Save favorites to revisit later
What this does:

Makes celebrating wins social (which reinforces them)

Public accountability when you want it

Beautiful shareable content for your progress

Inspiration exactly when you need it

Why it''s powerful: Sharing your wins publicly creates accountability and makes success feel more real. Plus, inspiring others with your progress creates positive feedback loops.

💡 Pro Tips for Using These Prompts

Build incrementally - Don''t throw all prompts at once. Add one feature, test it, then add the next.

Customize for your needs - These are templates. Modify them to match what YOU actually want.

Test after each prompt - Make sure the feature works before moving to the next one.

Combine prompts - You can merge 2-3 related features into one prompt if they''re closely related.

Fix before adding - If something breaks, use a follow-up prompt to fix it before adding more features.

🚀 Suggested Build Order

If you''re not sure where to start, I recommend this order:

Start with Prompts #1 & #2 (from the video - foundation + AI)

Add Prompt #7 (Smart Goal Creation) - makes everything easier

Add Prompt #3 (Pattern Recognition) - shows you''re learning from data

Add Prompt #5 (Gamification) - makes it fun to use daily

Add Prompt #4 (Automated Check-ins) - builds consistency

Then add others based on what you need most

Each prompt builds a complete feature. You can stop after any of them and still have a fully functional, useful app.

Questions? Post them in the community and I''ll help you troubleshoot!', 2),
  ('cd31d3e8-d240-4e1a-938e-6fb930659f0a', 'a3dfae77-770a-4544-a551-bb2d9fcc6913', 'AI Lead Reactivation App', 'Prompt 1:

I want to build an AI voice agent platform where I can feed in a list of leads manually or as a csv (name, email, and phone number), and bulk select phone numbers to reach out to. I can then press a button to start the calling, which sends the numbers to VAPI (10 concurrent calls). the app must handle concurrency, and get the response from vapi and update the table to show the status(we will create the webhook and status events in the next step).
This is for a single client so no auth is needed, but I do need a database.
add real time logging of vapi requests
here’s the structure of the VAPI request
here''s from the documentation
curl -X POST "https://api.vapi.ai/call" -H "Authorization: Bearer $VAPI_API_KEY" -H "Content-Type: application/json" -d ''{ "assistantId": "your-assistant-id", "phoneNumberId": "your-phone-number-id", "customer": { "number": "+1234567890" } }''
We’ll save the assistant ID, phone number ID, and vapi api key as secrets.
Prompt 2:

Create a webhook to receive call logs. VAPI sends a lot of webhooks by default, but the one we’re interested in is where “message.type”: "end-of-call-report”. Here’s a sample message that was sent from my last test call. Note the payload.message.artifact.structuredOutputs is what we’re looking to parse and update the database with.', 3),
  ('5c1da2d2-1f73-40b4-bcd3-0dc1f80d258b', 'a3dfae77-770a-4544-a551-bb2d9fcc6913', 'Build POWERFUL apps with Google Antigravity', 'Building Production-Ready Apps with Google Anti-Gravity: The PLACE Framework

Overview

Learn how to leverage Google Anti-Gravity IDE to build full-stack applications that actually work—without getting stuck halfway through. This lesson teaches you the PLACE framework, a systematic approach that puts you ahead of 99% of Anti-Gravity users.

What You''ll Build

A complete project management application featuring:

Client management system

Project tracking with billing rates

Task management with status tracking

AI-powered task generation using OpenAI

Automated billing and invoice generation

Complete CRUD operations with data persistence

Prerequisites

Google Anti-Gravity IDE installed

OpenAI API key (for AI task generation feature)

Basic understanding of web applications

Familiarity with terminal commands

Getting Started with Anti-Gravity

Initial Setup

Download and Install

Head to anti-gravity.google

Download and install the application

Log in to access the interface

Understanding the Interface

Right side: AI Agent chat interface

Center: Open files and code editor

Left side: File explorer for your project

Create Your Project Folder

Open your terminal and run:

cd desktop

mkdir anti-gravity-tutorial

Then open the folder in Anti-Gravity and trust it when prompted.

The PLACE Framework

Why PLACE Matters

Most people fail with AI coding assistants because they:

Jump straight into building without planning

Get stuck when APIs break

Build apps that don''t match their vision

Lack a systematic debugging process

The PLACE framework solves these problems through structured phases.

Phase 1: PLANNING

Objective

Create a detailed roadmap before writing any code.

Key Concept

User Stories are roadmaps that define who uses your app, what they want to accomplish, and the step-by-step flow of their interactions.

Implementation Steps

Step 1: Create the Agent Instructions File

Create a new file called agent.md (markdown format)

This file keeps Anti-Gravity on track throughout development

Include project structure, available tools, and framework guidelines

Step 2: Define Your Requirements

Give Anti-Gravity your basic requirements. For example:

"I want to build a basic client work tracking app where I can manage multiple clients, track multiple projects per client, and manage multiple tasks per project."

Step 3: Review the Generated User Story

Anti-Gravity will create:

User persona definition

Core functionality requirements

Step-by-step user flow

Expected behaviors and outcomes

Pro Tip

The more specific your initial requirements, the better your user story. The AI uses this as its north star throughout development.

Phase 2: LAUNCH

Objective

Create a detailed action plan that the AI follows step-by-step.

What Gets Generated

Dependencies List

Required libraries and packages

Framework selections

Third-party integrations

Build Steps

Numbered sequential tasks

Clear milestones

Logical progression from foundation to features

Checkpoints

Validation points after major steps

Quality assurance moments

Error prevention gates

Example Action Plan Structure

The AI will generate something like:

Dependencies:

React

Vite

Local Storage API

OpenAI API

Build Steps:

Set up project skeleton

Create basic dashboard layout

Implement client management

Add project tracking

Build task management

Integrate OpenAI API

Create billing module

Add invoice generation

Implement data persistence

Command Execution

Anti-Gravity will request permission for terminal commands

Review each command before approving (security best practice)

Option available for automatic approval (not recommended)

Phase 3: ASSERT

Objective

Verify that all functionality works as expected before moving forward.

What Gets Tested

Core Functionality

CRUD operations (Create, Read, Update, Delete)

Data persistence

Navigation flows

User interactions

API Connections

External service integrations

API key validation

Response handling

Error states

Automated Browser Testing

Anti-Gravity controls Chrome automatically

Takes screenshots for verification

Simulates real user behavior

Documents test results

Error Handling Mechanism

Built into your agent.md file, this mechanism instructs Anti-Gravity:

If error encountered:

Attempt direct fix

If unsuccessful, try alternative approach

If still failing, create minimal test case

After 3 failed attempts, report to user with options

Self-Correction Example

Here''s what happens automatically:

Issue detected: Delete button not working → Agent analyzes deletion logic → Identifies dialogue confirmation issue → Fixes code automatically → Re-tests functionality → Confirms resolution

Phase 4: CONSTRUCT

Objective

Build out the application with all planned features.

Development Flow

Feature-by-Feature Build

Client management module

Project tracking system

Task management interface

AI integration

Billing calculator

Invoice generator

Automated Testing During Build

Agent tests each feature as it''s built

Creates test clients, projects, tasks

Validates data flow between modules

Catches errors before you do

API Integration Example

When implementing OpenAI, the agent creates an action plan:

Set up API configuration

Create API key input interface

Build test endpoint

Validate connection

Implement task generation logic

Add error handling

Test with real data

Real-Time Browser Testing

Anti-Gravity will:

Launch your app in Chrome

Create test data automatically

Click through interfaces

Fill forms

Validate outputs

Screenshot results

Phase 5: EXECUTE

Objective

Manual testing and final refinement by you, the developer.

Your Testing Workflow

Fresh Start Test

Clear all test data

Start from scratch as a real user would

Follow complete user journey

Feature Validation

Test the complete flow:

Add client → "Acme"

Create project → "Website Development" ($2,000 budget)

Generate AI tasks → Review generated task list

Add tasks to project

Mark tasks complete

Generate billing

Create invoice

Edge Case Testing

Critical test: Cascading deletes

When client deleted → All projects should delete

When project deleted → All tasks should delete

Identifying and Fixing Issues

When you find a bug:

Step 1: Document the Problem

Write clearly what''s wrong:

"When I delete a client, associated projects and tasks remain in the system. They should be deleted automatically."

Step 2: Let AI Fix It

Paste the issue description

Agent analyzes the problem

Proposes solution

Implements fix

Tests correction

Step 3: Verify the Fix

Repeat the action that caused the bug

Confirm expected behavior

Test related functionality

Critical Implementation Details

The Power of agent.md

Your agent.md file should include:

Available Tools

What the AI can access

File system permissions

External services

Project Structure

Default folder organization

File naming conventions

Component hierarchy

Error Handling Protocol

Self-correction steps

Escalation procedures

Documentation requirements

Testing Requirements

Automated test expectations

Manual test checkpoints

Validation criteria

Security Best Practices

Command Approval

Review terminal commands before execution

Understand what each command does

Keep automatic execution disabled

API Key Management

Never commit keys to repositories

Use environment variables

Implement key validation before use

Data Handling

Validate all user inputs

Sanitize data before storage

Implement proper error messages

Common Pitfalls and Solutions

Pitfall 1: Skipping Planning

❌ Wrong: Jumping straight to "build me an app" ✅ Right: Define user stories and requirements first

Pitfall 2: Ignoring Checkpoints

❌ Wrong: Letting the AI build everything without validation ✅ Right: Review and test at each phase completion

Pitfall 3: Incomplete Testing

❌ Wrong: Only testing the "happy path" ✅ Right: Test edge cases, deletions, and cascading actions

Pitfall 4: Vague Instructions

❌ Wrong: "Make it look nice" ✅ Right: "Add a dashboard with client cards showing project count and total billing"

Key Takeaways

Planning prevents problems - User stories and action plans create deterministic outcomes

Automated testing saves time - Let the AI test while building, catch errors early

Self-correction is powerful - The error handling mechanism means fewer interruptions

Manual validation is essential - Phase 5 catches edge cases AI might miss

Framework creates consistency - PLACE works for any application complexity

Your Assignment

Build your own application using the PLACE framework:

Choose a simple use case (habit tracker, expense manager, etc.)

Create your agent.md file with the PLACE structure

Document each phase as you progress

Share your results in the community

Bonus Challenge: Implement an AI feature using OpenAI or Claude API integration

Resources

Google Anti-Gravity: anti-gravity.google

OpenAI API Documentation: platform.openai.com

Community Template: agent.md starter file (available in resources section)

Discussion Questions

What applications could you build for your clients using this framework?

How might the PLACE framework apply to other AI development tools?

What additional phases or checkpoints would you add for your specific use cases?

Share your thoughts and projects in the comments below! 👇', 4),
  ('e455714a-814c-4be7-8fcc-551ac01f2a33', 'a24ea901-64ab-42e9-b1ed-b45851de3719', 'Build a Lightweight OpenClaw in n8n', 'Building a Lightweight OpenClaw Clone in n8n: The Cost-Effective Alternative

Overview

Learn how to replicate OpenClaw''s core functionality using n8n—achieving persistent memory, multi-channel communication, and autonomous task execution at a fraction of the cost. This lesson shows you how to build a modular, expandable AI agent system that''s more secure and budget-friendly than running the full OpenClaw stack.

What You''ll Build

A lightweight autonomous AI assistant with:

Persistent memory across all conversations using PostgreSQL + Vector Store

Multi-channel communication (Telegram, WhatsApp, Gmail, and expandable to more)

Autonomous execution through scheduled heartbeats and task management

Multi-agent architecture with specialized worker agents for different complexity levels

Complete task/subtask tracking with database-backed persistence

Document management through Google Docs/Drive integration

Email management with intelligent filtering and auto-responses

Why Build This Instead of Using OpenClaw?

The OpenClaw Reality Check

OpenClaw is impressive but comes with significant overhead:

71 directories, 160 dependencies - massive software footprint

Requires 24/7 hardware - people buying Mac minis/Studios just to run it

Burns through API credits - especially with shell access and browser automation

Full system access - security concerns with terminal/file system control

Complex setup - steep learning curve for customization

The n8n Advantage

Modular architecture - add only what you need

Cost-effective - strategic model selection saves 60-80% on API costs

Already integrated - leverage your existing n8n workflows

More secure - controlled access to specific tools only

Familiar interface - if you know n8n, you can build this

Infinitely expandable - attach any workflow as a tool

Prerequisites

Required Accounts & Tools

n8n instance (self-hosted or cloud)

PostgreSQL database (for chat memory)

Supabase account (for vector store)

Telegram bot token

Evolution API instance (for WhatsApp)

Gmail account

Google Docs/Drive API access

OpenRouter API key (for multi-model access)

OpenAI API key (for embeddings)

Recommended Knowledge

Basic n8n workflow building

Understanding of AI agents and LangChain concepts

Familiarity with database structures

Basic API integration experience

Part 1: Core Architecture Overview

The Three Pillars of OpenClaw (and How We Replicate Them)

1. Persistent Memory

OpenClaw: Soul file, User file, Heartbeat file

Our solution: PostgreSQL database + Supabase vector store + n8n Data Tables

2. Multi-Channel Communication

OpenClaw: Native integrations with state management

Our solution: Multiple trigger nodes with unified routing logic

3. Autonomous Execution

OpenClaw: Cron jobs and scheduled tasks

Our solution: n8n Schedule Triggers with automated prompts

Part 2: Database Structure Setup

Creating the Initialization Table

This table stores the "personality" of your n8n Claw instance.

Table: ClawdBot Init

Columns:

username (string) - Unique identifier for the user

soul (string) - Agent''s name, vibe, and general purpose

user (string) - Information about you (interests, goals, preferences)

heartbeat (string) - Recurring tasks and reminders

last_channel (string) - Where you last messaged the agent

last_vector_id (number) - Tracking for vector store uploads

Purpose: This replaces OpenClaw''s initialization files and provides the system prompt foundation.

Creating the Tasks Table

Table: ClawdBot Tasks

Columns:

task_name (string) - Name of the task

task_details (string) - Full description and progress notes

task_complete (boolean) - Completion status

is_recurring (boolean) - Whether this task repeats

Purpose: High-level task tracking that the agent creates, updates, and completes autonomously.

Creating the Subtasks Table

Table: ClawdBot Subtasks

Columns:

parent_task_id (string) - Links to the main task

subtask_name (string) - Name of the subtask

subtask_details (string) - Progress notes and context

subtask_complete (boolean) - Completion status

Purpose: Break complex tasks into manageable pieces that the agent can work through systematically.

PostgreSQL Chat Memory Setup

Why PostgreSQL Instead of Simple Memory:

Persistent across sessions

Survives n8n restarts

Can be queried and analyzed

Supports multi-channel state management

Setup:

Create PostgreSQL database

n8n will auto-create the n8n_chat_histories table

Session key: Your username (not channel-specific)

Context window: 15 messages recommended

Critical: Use username as session key, not channel ID, so memory persists across all channels.

Supabase Vector Store Setup

Purpose: Long-term memory that goes beyond chat history.

Setup Process:

Step 1: Create Supabase Project

Sign up at supabase.com

Create new project

Note your project URL and anon key

Step 2: Create Documents Table

Navigate to Table Editor

Create table called documents

Let Supabase/n8n handle schema automatically

Step 3: Configure in n8n

Add Supabase Vector Store node

Insert mode for writing

Retrieve mode for querying

Connect OpenAI Embeddings node

How It Works:

Daily, all chat history is summarized

Summaries stored in vector database

Agent queries this for long-term context

Searches semantically, not just keyword matching

Part 3: Multi-Channel Communication Setup

Channel 1: Telegram Integration

Why Start with Telegram:

Easiest to set up

Supports voice, images, documents

Native n8n node available

Good for testing

Workflow Structure:

Step 1: Telegram Trigger Node

Parameters:
- Update: message
- Listen for all message types

Step 2: Filter Node

Conditions:
- message.chat.id = YOUR_TELEGRAM_CHAT_ID
Purpose: Only respond to your messages, ignore others

Step 3: Switch Node for Message Types

Routes to different processors based on content:

Route 1: Audio Message

Check: $json.message.voice exists

Flow: Telegram Get File → Gemini Transcription

Route 2: Image

Check: $json.message.photo exists

Flow: Telegram Get File → Gemini Image Analysis

Route 3: Document

Check: $json.message.document exists

Flow: Telegram Get File → Gemini Document Analysis

Route 4: Text (Default)

Check: None of the above

Flow: Direct to Edit Fields

Processing Files with Gemini

Why Gemini for Media Processing:

Native n8n node for PDFs

Cost-effective for transcription/analysis

Handles images, audio, documents in one model

Transcribe Audio Node:

Resource: audio
Model: gemini-2.5-flash
Input: binary (from Telegram file)
Output: Text transcription in $json.content.parts[0].text

Analyze Image Node:

Resource: image
Operation: analyze
Model: nano-banana-pro-preview
Input: binary
Output: Image description in $json.content.parts[0].text

Analyze Document Node:

Resource: document
Model: gemini-2.5-flash
Input: binary
Output: Document content in $json.content.parts[0].text

The Critical Edit Fields Node

Purpose: Normalize all input types into a standard format for the AI agent.

Field 1: user_message

{{
  $if($(''Transcribe a recording'').isExecuted, 
    $(''Transcribe a recording'').item.json.content.parts[0].text,
  $if($(''Analyze document'').isExecuted,
    $(''Analyze document'').item.json.content.parts[0].text,
  $if($(''Analyze an image'').isExecuted,
    $(''Analyze an image'').item.json.content.parts[0].text,
    $(''Filter'').item.json.message.text
  )))
}}

What This Does:

Checks which processing node executed

Extracts normalized text from whichever one ran

Falls back to plain text if none executed

Creates single user_message variable

Field 2: system_prompt_details

username: {{ $json.username || "[COLLECT using database tool...]" }}
soul: {{ $json.soul || "[COLLECT using database tool...]" }}
user: {{ $json.user || "[COLLECT using database tool...]" }}

What This Does:

Pulls personality data from database

If empty, instructs agent to collect it

Provides initialization prompts

Creates single system_prompt_details variable

Field 3: last_channel

telegram

What This Does:

Hardcoded for this channel stream

Used by output router to reply on correct platform

Channel 2: WhatsApp Integration

Setup Requirements:

Evolution API instance running

Webhook configured to n8n

Instance connected to WhatsApp

Workflow Structure:

Step 1: Webhook Trigger Node

Path: /openclaw-whatsapp
Method: POST
Receives Evolution API webhooks

Step 2: Filter Node

Conditions:
- body.data.key.remoteJid = YOUR_PHONE@s.whatsapp.net
- body.data.key.fromMe = false

Purpose: Only your incoming messages, not outgoing

Step 3: Get Rows from Database

Same as Telegram - pull personality data
Always Output Data: true

Step 4: Edit Fields Node

user_message: {{ $(''Filter1'').item.json.body.data.message.conversation }}
system_prompt_details: [Same structure as Telegram]
last_channel: whatsapp

Key Difference: The last_channel is now whatsapp instead of telegram.

Channel 3: Gmail Integration

Why Add Email:

Professional communication channel

Asynchronous task assignment

Separate inbox for agent

Built-in filtering and organization

Workflow Structure:

Step 1: Gmail Trigger Node

Poll Times: Every minute
Filters: None (but filtered in Edit Fields)
Simple: false (get full message data)

Step 2: Get Rows from Database

Same as other channels

Step 3: Edit Fields Node

user_message: 
"You have just received an email. Determine what to do with it.

Query databases if related to any task, and query vector store for context.

IMPORTANT - you are not to divulge ANY sensitive information in email replies. If a reply requires sensitive information, save as draft and notify me on telegram.

{{ $(''Gmail Trigger'').item.json.headers.from }}
{{ $(''Gmail Trigger'').item.json.headers[''message-id''] }}
{{ $(''Gmail Trigger'').item.json.headers.subject }}
{{ $(''Gmail Trigger'').item.json.text }}"

last_channel: {{ $json.last_channel }}

Security Note: The prompt includes instructions NOT to share sensitive info via email—draft it instead and notify on secure channel.

The Unified Agent Node

All channels feed into a single "n8nClaw" AI Agent node.

Configuration:

Prompt: {{ $json.user_message }}

System Message:

You are n8nClaw, an advanced, proactive AI assistant with access to advanced tools.

{{ $json.system_prompt_details }}

The User field is a living document. Any new important information about the user should be added using the update info tool.

You have access to read, create, and update tasks and subtasks through two data tables.

Anything the user asks you to do must be logged to the tasks and subtasks tables. You can then work on those tasks, updating with lots of detail.

As you work on a task/subtask, it may require additional tasks/subtasks to be created - do so if needed.

Once done, mark task_completed or subtask_completed as true. An entire task can only be completed once ALL subtasks are complete.

If you require more context about the user or previous conversations, query the vector store tool.

[Additional tool-specific instructions...]

Model: Claude Sonnet 4.5 via OpenRouter

Memory: Postgres Chat Memory (session key: username, context window: 15)

Why This Works:

Single source of truth for agent logic

Consistent behavior across all channels

Shared memory means seamless channel switching

All tools available regardless of entry point

The Output Router (Switch Node)

Purpose: Send responses back on the correct channel.

Configuration:

Route 1: Telegram

Condition:
{{ 
  $if($(''Edit Fields'').isExecuted, $(''Edit Fields'').item.json.last_channel,
  $if($(''Edit Fields1'').isExecuted, $(''Edit Fields1'').item.json.last_channel,
  $if($(''Edit Fields2'').isExecuted, $(''Edit Fields2'').item.json.last_channel,
    $(''Edit Fields3'').item.json.last_channel
  )))
}} equals "telegram"

Output: Send Text Message (Telegram node)

Route 2: WhatsApp

Same condition check, looking for "whatsapp"
Output: Enviar texto (Evolution API node)

Why The Complex Expression:

Multiple Edit Fields nodes (one per channel)

Only one executes per run

Need to check which one actually ran

Extract last_channel from whichever one executed

Output Nodes:

Telegram:

Chat ID: {{ $if($(''Telegram Trigger'').isExecuted, 
  $(''Telegram Trigger'').item.json.message.chat.id, 
  YOUR_TELEGRAM_CHAT_ID) }}
Text: {{ $(''n8nClaw'').item.json.output }}
Parse Mode: Markdown

WhatsApp (Evolution API):

Instance: YOUR_EVOLUTION_INSTANCE
Remote JID: {{ $if($(''Filter1'').isExecuted,
  $(''Filter1'').item.json.body.data.key.remoteJid,
  ''YOUR_PHONE@s.whatsapp.net'') }}
Message: {{ $(''n8nClaw'').item.json.output }}

Adding More Channels

To add Slack, Discord, SMS, etc.:

Step 1: Add Trigger Node

Create trigger for new channel

Filter for your messages only

Step 2: Clone Edit Fields Node

Copy existing Edit Fields

Update user_message extraction logic

Change last_channel to new channel name

Step 3: Update Switch Node

Add new routing rule

Check for new channel name

Route to appropriate output node

Step 4: Add Output Node

Configure channel-specific sending

Use {{ $(''n8nClaw'').item.json.output }}

That''s it. The agent logic stays the same—you''re just adding entry/exit points.

Part 4: Agent Tools & Capabilities

Database Management Tools

Tool 1: Get Tasks

Type: Data Table Tool
Operation: Get
Table: ClawdBot Tasks
Description: "Get pending or completed tasks"
Return All: fromAI parameter

Tool 2: Get Subtasks

Type: Data Table Tool
Operation: Get
Table: ClawdBot Subtasks
Filter: parent_task_id = fromAI parameter
Description: "Get pending or completed subtasks"

Tool 3: Upsert Task

Type: Data Table Tool
Operation: Upsert
Table: ClawdBot Tasks
Filter: task_name = fromAI parameter
Columns:
- task_name: fromAI
- task_details: fromAI
- task_complete: fromAI (boolean)
- is_recurring: fromAI (boolean)
Description: "Upsert task"

Tool 4: Upsert Subtask

Type: Data Table Tool
Operation: Upsert
Table: ClawdBot Subtasks
Filter: parent_task_id = fromAI parameter
Columns:
- parent_task_id: fromAI
- subtask_name: fromAI
- subtask_details: fromAI
- subtask_complete: fromAI (boolean)
Description: "Upsert Subtask"

Tool 5: Update Info (Initialization)

Type: Data Table Tool
Operation: Upsert
Table: ClawdBot Init
Filter: username = fromAI parameter
Columns:
- username: fromAI
- soul: fromAI
- user: fromAI
- heartbeat: fromAI
- last_channel: $json.last_channel
Description: "Initialize first usage"

Tool 6: Update User and Heartbeat

Same as Update Info, but description:
"Update user, heartbeat as needed."

Tool 7: Vector Store Query

Type: Supabase Vector Store
Mode: retrieve-as-tool
Table: documents
Description: "get info about the user as needed"
Embeddings: OpenAI

How The Agent Uses These:

Initialization Flow:

First message arrives with empty database

Edit Fields node injects collection prompts

Agent asks for username, soul, user info

Agent uses "Update Info" tool to save responses

Future messages pull this data automatically

Task Management Flow:

User: "Remind me to prepare Q2 report"

Agent calls "Upsert Task" with task details

Agent breaks it into subtasks automatically

Agent calls "Upsert Subtask" for each piece

Hourly heartbeat checks pending tasks

Agent works on subtasks, updates details field

Marks subtasks complete when done

Marks main task complete when all subtasks done

Sub-Agent 1: Research Agent

Purpose: Handle all research tasks—web search, Wikipedia, trend analysis.

Configuration:

Type: Agent Tool Description: "Research Agent" Model: Gemini 3 Flash (cost-effective for research) Memory: Simple Buffer Window (session: username-research, context: 10)

System Message:

You are a research agent. You have access to Wikipedia and Tavily tools.

Tools Available:

Wikipedia Tool

Tavily Search Tool

Why Separate Research Agent:

Dedicated context window for research tasks

Cheaper model for information gathering

Can research multiple topics in parallel

Keeps main agent clean

Usage Example:

User (via main agent): "Research the latest developments in quantum computing"
Main Agent: [calls Research Agent tool]
Research Agent: [uses Tavily + Wikipedia]
Research Agent: [returns synthesized findings]
Main Agent: [presents to user]

Sub-Agent 2: Email Manager

Purpose: Handle all Gmail operations—read, reply, delete, search.

Configuration:

Type: Agent Tool Description: "Email manager agent" Model: Claude Haiku 4.5 (fast, cheap for email tasks) Memory: Simple Buffer Window (session: username-email, context: 10)

System Message:

You are an email manager. You have access to a variety of tools to process emails. Keep track of the message ID (google api friendly format) - you''ll need it to take any actions on any messages.

Tools Available:

Reply to a message in Gmail

Mark a message as read in Gmail

Get a message in Gmail

Delete a message in Gmail

Get many messages in Gmail

Send a message in Gmail

Security Features:

Separate memory context prevents email data leaking to main agent

System prompt in main agent restricts sensitive info sharing

Drafts sensitive replies instead of sending

Usage Flow:

Gmail Trigger: New email arrives
Edit Fields: Formats email with security warnings
Main Agent: Analyzes email intent
Main Agent: [calls Email Manager tool]
Email Manager: [reads message, determines action]
Email Manager: [replies/archives/deletes as appropriate]
Main Agent: Updates task database if email was task-related

Sub-Agent 3: Document Manager

Purpose: Create, update, organize Google Docs and Drive files.

Configuration:

Type: Agent Tool Description: "call this tool to create, update, and move documents in google drive" Model: Claude Haiku 4.5 Memory: Simple Buffer Window (session: username-docs, context: 20)

System Message:

You are a document manager agent. You have access to create and update google docs, search for folders in google drive, delete files in google drive, and move files between folders. Retain the file ID in memory for any file you are working with.

Tools Available:

Create a document in Google Docs

Get a document in Google Docs

Update a document in Google Docs

Delete a file in Google Drive

Create folder in Google Drive

Move file in Google Drive

Search files and folders in Google Drive

Critical System Prompt Instruction (in Main Agent):

The document agent is ONLY to receive completed work for saving. You are NOT to send it instructions for what output to produce. Save the Google Drive URLs to the task info for persistence.

Why This Matters:

Document Manager doesn''t create content—it just saves it

Main agent or worker agents create content

Document Manager handles file operations only

Prevents recursive agent loops

Usage Flow:

User: "Write a project proposal for the new AI feature"
Main Agent: [delegates to Worker Agent 2]
Worker Agent 2: [writes proposal content]
Main Agent: [receives completed content]
Main Agent: [calls Document Manager]
Document Manager: [creates Google Doc, saves content, returns URL]
Main Agent: [saves URL to task details]
Main Agent: [reports to user with link]

Worker Agents (3-Tier System)

Purpose: Distribute work based on complexity to optimize costs.

Worker Agent 1: Simple Tasks

Model: Claude Haiku 4.5 (~$0.25/M tokens)
Use For: Data formatting, simple research, basic writing
System Message: fromAI (main agent provides context)
Memory: Buffer Window (username-worker1, context: 20)

Worker Agent 2: Mid-Level Tasks

Model: Claude Sonnet 4.5 (~$3/M tokens)
Use For: Analysis, content creation, complex formatting
System Message: fromAI
Memory: Buffer Window (username-worker2, context: 20)

Worker Agent 3: Complex Tasks

Model: Claude Opus 4.6 (~$15/M tokens)
Use For: Strategic thinking, architecture, difficult problems
System Message: fromAI
Memory: Buffer Window (username-worker3, context: 20)

All Worker Agents Have Access To:

Document Manager tool (for saving output)

Cost Optimization Strategy:

Main agent (Sonnet 4.5) acts as orchestrator:

Receives task from user

Breaks into subtasks

Assigns each subtask to appropriate worker based on complexity

Simple formatting → Worker 1 (Haiku)

Content writing → Worker 2 (Sonnet)

Strategic planning → Worker 3 (Opus)

Result: 60-80% cost savings vs. using Opus for everything.

Example Delegation:

User: "Create a comprehensive market analysis report for our Q2 strategy"

Main Agent thinking:
- Task 1: Gather data → Worker 1 (Haiku) + Research Agent
- Task 2: Analyze trends → Worker 2 (Sonnet)
- Task 3: Strategic recommendations → Worker 3 (Opus)
- Task 4: Format as document → Worker 1 (Haiku) → Document Manager

All workers save to same task_details field, main agent monitors completion.

Part 5: Autonomous Execution (Heartbeats)

The Hourly Heartbeat

Purpose: Make the agent check for pending work and execute autonomously.

Workflow Structure:

Step 1: Schedule Trigger Node

Rule: Every hour
(or customize: every 30 minutes, every 6 hours, etc.)

Step 2: Get Rows from Database

Same configuration as other channels
Pulls personality data

Step 3: Edit Fields Node

user_message: "See what''s pending and start working on it."
system_prompt_details: [Same as other channels]
last_channel: {{ $json.last_channel }}

Key Differences from User Messages:

user_message is hardcoded, not from user input

last_channel pulled from database (where user last messaged)

No media processing needed

Step 4: Main Agent (n8nClaw)

Same agent as user-triggered messages
Receives automated prompt
Processes autonomously

Step 5: Output Router

Same Switch node
Routes response to last used channel
User receives update notification

What Happens During Heartbeat

Agent''s Autonomous Flow:

Phase 1: Check Tasks

Agent uses "Get Tasks" tool
Filters for task_complete = false
Reviews task_details to see progress

Phase 2: Check Subtasks

For each incomplete task:
- Get Subtasks by parent_task_id
- Filter for subtask_complete = false
- Review what''s been done vs. what''s pending

Phase 3: Execute Work

Agent determines next actionable subtask:
- Calls Research Agent if info needed
- Calls appropriate Worker Agent for execution
- Updates subtask_details with progress
- Marks complete if finished

Phase 4: Report Back

Agent composes update message:
- What was worked on
- What was completed
- What''s blocking progress (if anything)
- Next steps

Sends to user on last channel used

Multiple Heartbeat Strategies

Strategy 1: Single Hourly Heartbeat

Use for: General task processing
Prompt: "See what''s pending and start working on it."
Frequency: Every hour

Strategy 2: Specialized Heartbeats

Morning Briefing (Daily at 8 AM):

Prompt: "Review yesterday''s completed tasks and today''s priorities. Provide a brief morning update."
Frequency: Daily at 08:00

Inbox Check (Every 15 minutes):

Prompt: "Check email for urgent messages. Reply to simple queries. Flag complex ones for my review."
Frequency: Every 15 minutes during work hours

Content Posting (Weekdays at 10 AM):

Prompt: "Check if there''s content scheduled for today. Post to LinkedIn if ready."
Frequency: Weekdays at 10:00

Weekly Review (Sundays at 6 PM):

Prompt: "Compile a weekly summary: tasks completed, hours spent, upcoming priorities for next week."
Frequency: Weekly on Sunday at 18:00

How to Implement Multiple Heartbeats:

Duplicate the Hourly Heartbeat workflow

Change Schedule Trigger to desired frequency

Update the user_message in Edit Fields

Everything else stays the same

Result: Different autonomous behaviors at different times, all using the same underlying agent infrastructure.

Part 6: Long-Term Memory (Vector Store)

Daily Memory Consolidation Workflow

Purpose: Convert daily chat history into searchable long-term memory.

Workflow Structure:

Step 1: Schedule Trigger

Rule: Every day at midnight (or your preferred time)

Step 2: Get Rows from Init Table

Purpose: Get last_vector_id
Filters: username = YOUR_USERNAME

Step 3: PostgreSQL Query

Operation: Execute Query
Query:
SELECT session_id, message, id
FROM n8n_chat_histories
WHERE id > ''{{ $json.last_vector_id }}''
ORDER BY id ASC

What This Does:

Queries chat history table

Gets only new messages since last upload

Returns message content + ID

Prevents duplicate uploads

Step 4: Aggregate Node

Fields to Aggregate: message
Aggregation: Combine all into single array
Output: One item with all messages concatenated

Step 5: Basic LLM Chain (Summarization)

Model: Claude Haiku 4.5 (cheap for summarization)

System Message:

You are a summarizer agent. I will provide you with the entire log of a day''s worth of discussion with my AI agent. You are to summarize the conversation for storing in deep memory.

Prompt: {{ $json.message }}

Output Parser: Structured Output Parser

Schema:
{
  "summary": "text"
}

What This Does:

Takes entire day''s chat log

Summarizes key information

Outputs structured JSON

Ready for vector storage

Step 6: Default Data Loader

Input: {{ $json.output.summary }}
Converts summary text to document format

Step 7: Supabase Vector Store (Insert Mode)

Mode: Insert
Table: documents
Embeddings: OpenAI
Query Name: match_documents

What This Does:

Takes summarized text

Generates embeddings

Stores in Supabase

Makes searchable semantically

Step 8: Update Init Table

Operation: Update
Filter: username = YOUR_USERNAME
Columns:
- last_vector_id: {{ $(''Execute a SQL query'').last().json.id }}

What This Does:

Saves the ID of last processed message

Next run will start from this point

Prevents reprocessing old messages

How the Agent Uses Vector Memory

The agent has a Vector Store tool configured in retrieve mode:

Type: Supabase Vector Store
Mode: retrieve-as-tool
Description: "get info about the user as needed"
Table: documents
Embeddings: OpenAI

When Agent Calls This Tool:

Scenario 1: User references past discussion

User: "What did we decide about the pricing strategy?"
Agent thinking: "I don''t see this in my 15-message context window"
Agent action: [queries vector store with "pricing strategy"]
Vector store: [returns relevant summary from 3 weeks ago]
Agent: "Based on our discussion on [date], we decided on value-based pricing with three tiers..."

Scenario 2: Agent needs context for task

Heartbeat runs, agent sees task: "Finalize the investor deck"
Agent thinking: "I need context on what was discussed about investors"
Agent action: [queries vector store with "investor deck discussions"]
Vector store: [returns summaries of all investor-related chats]
Agent: [uses context to work on deck appropriately]

Scenario 3: User asks about themselves

User: "What are my main career goals?"
Agent action: [queries vector store with "user career goals"]
Vector store: [returns relevant memories]
Agent: "From our conversations, your main goals are: [synthesized from multiple memory chunks]"

Memory Hierarchy

n8nClaw has three layers of memory:

Layer 1: Active Memory (15 messages)

Source: PostgreSQL Chat Memory

Speed: Instant

Content: Recent conversation

Use: Immediate context

Layer 2: Session Memory (Per-Channel)

Source: Buffer Window Memory on sub-agents

Speed: Instant

Content: Channel-specific context

Use: Tool-specific continuity

Layer 3: Long-Term Memory (Unlimited)

Source: Supabase Vector Store

Speed: ~1-2 seconds

Content: All past conversations (summarized)

Use: Historical context retrieval

Example of All Three Working Together:

User (on Telegram): "Continue working on that marketing analysis we discussed last month"

Layer 1 (Active): Checks last 15 messages - doesn''t find it
Layer 3 (Vector): Queries "marketing analysis" - finds summary from 4 weeks ago
Agent: "I''ll continue the marketing analysis. Last time we covered competitive landscape and identified three key trends..."
[Agent works on task]
Agent: [calls Email Manager to send draft]

Layer 2 (Email Manager memory): Remembers previous email formatting preferences
Email Manager: [formats and sends email matching past style]

Part 7: Customization & Expansion

Adding Custom Workflows as Tools

The Power of n8n Integration:

If you''ve been using n8n for a while, you probably have workflows for:

Image generation (Replicate, Midjourney, DALL-E)

Video creation (Remotion, D-ID, Synthesia)

Data processing (ETL pipelines, API integrations)

Content distribution (social media posting, email campaigns)

Analytics (dashboard updates, report generation)

You can attach ANY of these as tools for n8nClaw.

Method 1: Workflow as HTTP Tool

Step 1: Add Webhook to Your Workflow

Node: Webhook
Path: /workflow-name
Method: POST
Response Mode: Last Node

Step 2: Accept Parameters

Input: {{ $json.body.parameter_name }}
Process as needed
Return JSON output

Step 3: Create HTTP Request Tool in n8nClaw

Type: HTTP Request Tool
Description: "Describe what this workflow does"
URL: https://your-n8n-instance.com/webhook/workflow-name
Method: POST
Body: 
{
  "parameter_name": "{{ fromAI }}"
}

Example: Image Generation Workflow

Your existing workflow:

Webhook trigger

Receive prompt from body

Call Replicate/Midjourney/etc

Return image URL

In n8nClaw:

Tool: HTTP Request
Description: "Generate an AI image based on a text prompt"
URL: https://n8n.yourdomain.com/webhook/generate-image
Body: {"prompt": "{{ fromAI }}"}

Usage:

User: "Create a futuristic city image for the presentation"
Agent: [calls image generation tool]
Agent: [receives URL]
Agent: [calls Document Manager to insert image in doc]
Agent: "I''ve added a futuristic city image to your presentation."

Method 2: Sub-Workflow Integration

Step 1: Create Dedicated Sub-Agent

Similar to Research Agent, Email Manager, etc.:

Type: Agent Tool
Description: "Custom workflow agent - handles X tasks"
Model: Appropriate complexity
Tools: Specific workflow tools

Step 2: Give It Specific Workflow Tools

Example - Social Media Posting Agent:

Twitter API tool

LinkedIn API tool

Facebook API tool

Instagram API tool

Image resizing workflow (HTTP tool)

Step 3: Main Agent Delegates

User: "Post this announcement on all our social channels"
Main Agent: [calls Social Media Posting Agent]
Social Agent: [formats for each platform]
Social Agent: [calls appropriate API tools]
Social Agent: [returns confirmation]
Main Agent: "Posted to Twitter, LinkedIn, Facebook, and Instagram with platform-specific formatting."

Skill Replication from OpenClaw

OpenClaw has "skills" - specialized instruction sets for specific tasks.

You can replicate these in n8n as:

Option 1: System Prompt Instructions (Simple Skills)

Add to sub-agent system message:

SKILL: Code Review
When reviewing code:
1. Check for security vulnerabilities
2. Assess code efficiency
3. Suggest optimizations
4. Verify error handling
5. Format feedback constructively

Option 2: Dedicated Tool Workflows (Complex Skills)

Create workflow that embeds the skill logic:

Webhook receives code

Processes through linters/analyzers

Formats findings

Returns structured review

Option 3: RAG-Based Skills

Store skill documentation in vector store:

Upload skill best practices as documents

Agent queries when needed

Retrieves relevant instructions

Applies to current task

Example: YouTube Script Skill Integration

From your YouTube scriptwriter skill:

Step 1: Upload Skill to Vector Store

Create document containing:
- Video structure templates
- Hook formulas
- Pacing guidelines
- CTA patterns

Step 2: Create Scriptwriting Sub-Agent

Type: Agent Tool
Description: "YouTube script writer - creates engaging video scripts"
Model: Claude Sonnet 4.5
System Message: "You are a YouTube scriptwriter. Query the vector store for ''YouTube script best practices'' before writing any script."
Tools:
- Vector Store (for skill retrieval)
- Document Manager (for saving scripts)

Step 3: Usage

User: "Write a script for a video about n8n automation"
Main Agent: [calls Scriptwriting Agent]
Script Agent: [queries vector store for best practices]
Script Agent: [retrieves skill guidelines]
Script Agent: [writes script following patterns]
Script Agent: [saves to Google Doc via Document Manager]
Main Agent: "I''ve created your YouTube script following your preferred structure. Here''s the link: [URL]"

Part 8: Security & Best Practices

Security Considerations

What We''ve Made More Secure Than OpenClaw:

1. No Shell Access

OpenClaw can execute any terminal command

n8nClaw has no bash access by default

Controlled environment

2. Scoped Tool Access

Only give tools the agent actually needs

Easy to remove/add tools

Transparent about capabilities

3. Email Security Layer

System prompt in Edit Fields for Gmail:
"IMPORTANT - you are not to divulge ANY sensitive information in email replies. If a reply requires sensitive information, save the reply as a draft in Gmail and let me know on telegram."

4. Channel Isolation

Each channel has dedicated Edit Fields node

Can add channel-specific security rules

Filter suspicious patterns before reaching agent

5. Database Access Control

Agent can only upsert specific fields

Cannot delete tables or modify structure

Logs all database operations

Cost Management

Strategic Model Selection:

Current Setup:

Main Agent: Sonnet 4.5 ($3/M tokens)

Research Agent: Gemini 3 Flash ($0.10/M tokens)

Email Manager: Haiku 4.5 ($0.25/M tokens)

Document Manager: Haiku 4.5 ($0.25/M tokens)

Worker 1: Haiku 4.5 ($0.25/M tokens)

Worker 2: Sonnet 4.5 ($3/M tokens)

Worker 3: Opus 4.6 ($15/M tokens)

Summarization: Haiku 4.5 ($0.25/M tokens)

Cost Optimization Strategies:

1. Use Cheaper Models for Simple Tasks

Good for Haiku/Flash:
- Email classification
- Simple research
- Data formatting
- File organization
- Task status updates

Requires Sonnet:
- Content creation
- Complex analysis
- Multi-step reasoning

Requires Opus:
- Strategic planning
- Architecture decisions
- Difficult problems

2. Limit Context Window

Research Agent: 10 messages (doesn''t need full history)
Email Manager: 10 messages (email-specific context only)
Document Manager: 20 messages (tracks file IDs)
Workers: 20 messages (task-specific context)
Main Agent: 15 messages (general conversation)

3. Batch Vector Store Updates

Instead of: After every message
Do: Once daily at midnight
Savings: 95% reduction in embedding costs

4. Monitor and Optimize

Weekly review:
- Check OpenRouter usage dashboard
- Identify which agents/tools using most tokens
- Optimize prompts to be more concise
- Adjust model selection if needed

Estimated Monthly Costs (Moderate Use):

Assuming:

100 messages/day to main agent

30 research queries/day

20 emails processed/day

10 document operations/day

24 heartbeat checks/day

Breakdown:

Main Agent: ~$15-25/month

Research Agent: ~$2-3/month

Sub-agents: ~$5-8/month

Embeddings: ~$3-5/month

Total: ~$25-40/month

Compare to OpenClaw running Opus 4.6 for everything:

Estimated: ~$150-200/month for same usage

Savings: 60-80%

Monitoring & Debugging

Built-in Debugging with n8n:

Advantage 1: Execution History

Every workflow execution is logged

Can replay any execution

See exact data at each step

Identify where failures occurred

Advantage 2: Manual Testing

Click "Execute Workflow" button

Manually trigger with test data

See live results

No need to actually send messages

Advantage 3: Error Notifications

Add Error Trigger workflow:
- Trigger: On workflow error
- Send to Telegram: "Workflow X failed: {error message}"
- Track failures in real-time

Advantage 4: Data Inspection

Every node shows input/output data

Can see agent''s tool calls

Understand decision-making process

Debug tool parameters

Backup & Recovery

Database Backups:

PostgreSQL:

# Daily cron job
pg_dump n8n_chat_db > backup_$(date +%Y%m%d).sql

Supabase:

Built-in backups (check your plan)

Or export data periodically

Keep local copies

n8n Data Tables:

Export to CSV weekly

Store in Google Drive

Automated via n8n workflow

Workflow Backups:

In n8n:
- Download workflows as JSON
- Version control in GitHub
- Backup before major changes

Recovery Procedure:

Restore PostgreSQL database

Restore Supabase data

Import n8n workflows from JSON

Verify all credentials still work

Test with sample message

Part 9: Limitations & Workarounds

What''s Missing vs. Full OpenClaw

Limitation 1: Browser Control

OpenClaw Has:

Full Chrome automation

Can click, type, navigate

Screenshot and analyze

Form filling

n8nClaw Workaround:

Use Browserless/Puppeteer via HTTP workflow

Call specific browser automation APIs

Add as HTTP Request tool

Still expensive (API costs similar to OpenClaw)

When You Actually Need It:

Web scraping

Testing web applications

Automated form submissions

When You Don''t:

Most business automation doesn''t require it

APIs are cheaper and more reliable

Consider if this is really necessary

Limitation 2: Full Shell Access

OpenClaw Has:

Can execute any bash command

Full filesystem access

Install packages on the fly

System-level operations

n8nClaw Workaround:

Limited: Use n8n "Execute Command" node

Controlled: Specific bash scripts as tools

Secured: No arbitrary command execution

When You Actually Need It:

Advanced development workflows

System administration

Complex file operations

When You Don''t:

Most business processes

Content creation

Communication management

Document handling

Limitation 3: Native MCP Server Support

OpenClaw Has:

Direct MCP server integration

Easy skill installation

Community marketplace

n8nClaw Workaround:

HTTP API calls to MCP endpoints

Manual tool creation

More setup work upfront

Trade-off:

More initial configuration

But more control over what''s installed

And more security

When to Use OpenClaw vs. n8nClaw

Use Full OpenClaw When:

You need browser automation extensively

You need full system access

You''re doing software development

Cost is not a primary concern

You have dedicated hardware

Use n8nClaw When:

You''re already using n8n

Cost optimization is important

You need controlled, secure automation

Business process automation is primary use case

You want modular, expandable architecture

Use Both:

n8nClaw for daily operations

OpenClaw for specific development tasks

Best of both worlds

Part 10: Hands-On Implementation

Step-by-Step First Build

Phase 1: Database Setup (30 minutes)

Create PostgreSQL database

Create three n8n Data Tables:
ClawdBot Init

ClawdBot Tasks

ClawdBot Subtasks

Create Supabase project

Note all credentials

Phase 2: Telegram Channel (1 hour)

Create Telegram bot via BotFather

Build basic workflow:
Telegram Trigger

Filter node

Get Rows node

Edit Fields node

AI Agent node

Send Message node

Configure Postgres Chat Memory

Test with "Hello" message

Initialize by providing username, soul, user info

Phase 3: Add Database Tools (30 minutes)

Add Get Tasks tool

Add Upsert Task tool

Add Get Subtasks tool

Add Upsert Subtask tool

Add Update Info tool

Test by asking agent to create a task

Phase 4: Add Vector Memory (1 hour)

Configure Supabase Vector Store (retrieve mode)

Add as tool to main agent

Build daily summarization workflow:
Schedule trigger

Get rows (last_vector_id)

Execute SQL query

Aggregate messages

Summarize with LLM

Upload to vector store

Update last_vector_id

Manually trigger to test

Phase 5: Add Heartbeat (30 minutes)

Duplicate Telegram workflow

Replace Telegram Trigger with Schedule Trigger

Change Edit Fields user_message to automated prompt

Test by manually executing

Verify agent checks tasks and reports back

Phase 6: Add Second Channel (1 hour)

Choose WhatsApp or Gmail:

If WhatsApp:

Set up Evolution API instance

Create webhook workflow

Add Filter node

Clone Edit Fields from Telegram

Update Switch node routing

Add Evolution API output node

Test cross-channel memory

If Gmail:

Connect Gmail account

Create Gmail Trigger workflow

Add security instructions to Edit Fields

Clone from Telegram structure

Test email processing

Phase 7: Add Sub-Agents (2 hours)

Research Agent:
Create Agent Tool

Add Wikipedia

Add Tavily

Configure Gemini Flash

Add to main agent

Email Manager (if using Gmail):
Create Agent Tool

Add all Gmail tools

Configure Haiku

Add to main agent

Document Manager:
Create Agent Tool

Add Google Docs tools

Add Google Drive tools

Configure Haiku

Add to main agent

Phase 8: Add Workers (1 hour)

Create Worker Agent 1 (Haiku)

Create Worker Agent 2 (Sonnet)

Create Worker Agent 3 (Opus)

Give all access to Document Manager

Add all three to main agent

Test with complex multi-step task

Total Setup Time: ~8-10 hours

But you can use it immediately after Phase 2 (basic Telegram setup).

Everything else is incremental improvement.

Testing Checklist

Basic Functionality:

✅ Sends message on Telegram → Receives reply

✅ Initializes username, soul, user on first run

✅ Remembers conversation across messages

✅ Creates tasks when asked

✅ Creates subtasks for complex tasks

Multi-Channel:

✅ Message on Telegram → Reply on Telegram

✅ Message on WhatsApp → Reply on WhatsApp

✅ Switch channels mid-conversation → Continues seamlessly

Autonomy:

✅ Heartbeat runs on schedule

✅ Checks for pending tasks

✅ Works on tasks autonomously

✅ Reports progress to user

Memory:

✅ Remembers last 15 messages (Active Memory)

✅ Daily summarization runs successfully

✅ Can retrieve info from weeks ago (Vector Memory)

✅ User details persist across restarts

Sub-Agents:

✅ Research Agent returns accurate info

✅ Email Manager processes emails correctly

✅ Document Manager creates/updates docs

✅ Worker agents handle delegated tasks

Security:

✅ Filters ignore messages from other users

✅ Email agent doesn''t share sensitive info

✅ Database tools only access allowed fields

✅ Credentials stored securely in n8n

Your Assignment

Week 1: Core Build

Day 1-2:

Set up databases

Build Telegram channel

Configure basic agent

Day 3-4:

Add database tools

Test task management

Create first autonomous task

Day 5-7:

Add vector memory

Set up heartbeat

Test autonomous execution

Week 2: Expansion

Day 8-10:

Add second channel (WhatsApp or Gmail)

Test cross-channel memory

Verify routing works

Day 11-14:

Add sub-agents (Research, Email, Docs)

Create worker agents

Test complex multi-agent tasks

Month 2: Customization

Pick one advanced feature to add:

Option 1: Custom Workflow Integration

Take an existing n8n workflow

Convert to HTTP tool

Add to agent

Document results

Option 2: Skill Replication

Choose an OpenClaw skill

Upload to vector store

Create specialized sub-agent

Test performance

Option 3: Advanced Autonomy

Create multiple specialized heartbeats

Morning briefing

Inbox management

Content scheduling

Weekly reporting

Share your build in the community with:

Screenshot of your workflow

Description of what it does

Cost comparison (if tracking)

Challenges you encountered

Unique customizations you added

Resources

Essential Tools

n8n: n8n.io

Evolution API: github.com/EvolutionAPI/evolution-api

Supabase: supabase.com

OpenRouter: openrouter.ai

PostgreSQL: postgresql.org

APIs & Services

Tavily Search: tavily.com

Google AI Studio: ai.google.dev

OpenAI: platform.openai.com

Telegram: core.telegram.org/bots', 1),
  ('60e2be0c-04dc-4ea7-8258-a598c01597c3', 'a24ea901-64ab-42e9-b1ed-b45851de3719', 'AI Expense Tracker', 'Lesson Overview

Build an intelligent expense tracking system that accepts inputs through multiple channels—text messages, voice notes, receipt images, and PDF invoices—all through Telegram. This AI agent automatically categorizes expenses, extracts data from receipts using OCR, transcribes voice notes, and logs everything to Airtable while maintaining conversation context.

Time to Complete: 75 minutes Difficulty: Intermediate Tools Required: n8n, Telegram Bot, OpenAI API, Airtable, OCR.space API Time/Value Transformation: Manual expense logging (5-10 minutes per transaction) → Instant automated logging (<5 seconds per transaction)

The Personal Finance Problem

Traditional Expense Tracking Reality

Purchase something → promise to log it later → forget

End of month: scrambling through bank statements

Manual data entry: 5-10 minutes per transaction

Receipt photos scattered across phone gallery

No categorization, no insights, just chaos

Monthly time cost: 3-4 hours of tedious data entry

Result: Incomplete records, no spending insights

AI-Powered Solution

Text expense: "Spent $20 on lunch" → logged in 2 seconds

Voice note while driving → auto-transcribed and logged

Photo of receipt → OCR extracts total and date

PDF invoice → parsed and logged automatically

Monthly time cost: 0 minutes (happens instantly)

Result: Complete records, queryable by AI

The Transformation: From avoiding expense tracking because it''s tedious to effortlessly capturing every transaction the moment it happens. From incomplete data to comprehensive financial records with zero friction.

System Architecture Overview

Multi-Modal Input Processing Pipeline

Telegram Input (Text/Voice/Image/PDF)
    ↓
Data Type Router (Switch Node)
    ↓
    ├─→ Text Path → Direct to AI Agent
    ├─→ Voice Path → Whisper Transcription → AI Agent
    ├─→ Image Path → OCR Processing → AI Agent
    └─→ PDF Path → OCR Processing → AI Agent
    ↓
AI Agent (Intent Classification)
    ↓
    ├─→ New Expense → Airtable Create Tool
    └─→ Inquiry → Airtable Search Tool
    ↓
Response sent back via Telegram

Cost Breakdown Per Month

n8n: $20/month (starter plan)

OpenAI API: ~$2-3/month (GPT-4o mini + Whisper)

OCR.space: FREE (25,000 requests/month)

Telegram Bot: FREE

Airtable: FREE (up to 1,200 records)

Total: ~$22-23/month for unlimited expense tracking

Compare to: Expensify ($4.99/month per user), YNAB ($14.99/month), or manual tracking (4 hours × $50/hour = $200/month opportunity cost)

Phase 1: Foundation Setup

Telegram Bot Creation

Before building the workflow, create your Telegram bot through BotFather.

Steps:

Open Telegram and search for "@BotFather"

Send /newbot command

Choose bot name: "YT Expense Tracker"

Choose username: "YT_expense_tracker_bot"

Copy the API token (you''ll need this)

Why Telegram: Unlike building a custom mobile app, Telegram provides instant cross-platform access (iOS, Android, Desktop, Web) with zero deployment hassles. Your expense tracker lives where you already message people.

Airtable Database Structure

Table: Expense Tracker
Columns:
- Expense (Single line text) - Description of purchase
- Amount (Currency, 2 decimal places) - Transaction value
- Category (Single line text) - food, eating out, transport, etc.
- Date (Date with time, ISO format) - When expense occurred

Sort: Date (newest first)

Why This Structure:

Currency type with decimals: Handles $12.99 transactions accurately

Date with time: ISO format required by AI agent for proper parsing

Single line text for Category: Flexible but structured enough for filtering

Sort by date: Most recent expenses appear first for quick review

Key Technical Points:

ISO 8601 date format is critical (2025-03-11T14:30:00Z)

Airtable API expects datetime as variable, not string

Currency field automatically handles formatting and symbols

Phase 2: Telegram Trigger & Data Routing

Universal Telegram Trigger

// Telegram Trigger Node
Updates: * (all updates)
// Captures text, voice, images, PDFs, everything

Why "All Updates": Instead of specific message types, capture everything and route intelligently. This future-proofs your workflow—if you add video support later, no trigger changes needed.

Switch Node - Data Type Classification

// Switch Node Configuration
Route 1: If photo exists (message.photo array exists)
Route 2: If document exists (message.document object exists)  
Route 3: If text exists (message.text string exists)
Route 4: If voice exists (message.voice object exists)

The Logic:

Photo array: Telegram stores multiple resolutions, we''ll grab highest quality

Document object: PDFs, any file attachment

Text string: Direct messages like "spent $20 on coffee"

Voice object: Voice messages recorded in Telegram

Why This Matters: Each input type requires different preprocessing before the AI can understand it. Text goes straight through. Voice needs transcription. Images/PDFs need OCR. The Switch node routes each input to its appropriate preprocessing pipeline.

Phase 3: Text Input Path (Simplest)

Direct Text Processing

// When Switch detects text message exists:
message.text → straight to Combine Fields node → AI Agent

Example Inputs:

"Spent $25 on lunch with Sarah"

"Coffee and bagel this morning, $8.50"

"Uber to airport $45"

"How much have I spent on food this week?"

Why This Works: Natural language expenses don''t need structured formats. The AI agent is smart enough to extract amount, description, and infer category from context.

Phase 4: Voice Input Path (Transcription)

Voice Message Download

// Telegram Download Audio Node
Resource: File
File ID: {{ $(''Telegram Trigger'').item.json.message.voice.file_id }}

What This Does: Telegram stores voice messages as OGG files. This node downloads the audio file into n8n''s binary data format, ready for transcription.

Whisper Transcription

// OpenAI Whisper Node
Operation: Transcribe recording
Input data field: data (default from Telegram download)
Model: whisper-1 (automatic)

Cost: $0.006 per minute of audio

Average voice note: 5-10 seconds

Cost per voice expense: ~$0.001 (one tenth of a cent)

Output Example:

Input: [Voice recording]
Output: "I spent twenty five dollars on a bag of luxury coffee beans"

Why Whisper:

Near-perfect accuracy for clear speech

Handles various accents and speaking speeds

Automatically removes filler words ("um", "uh")

Works in multiple languages

Key Technical Points:

No need to specify language—Whisper auto-detects

Binary data automatically passed from Download → Transcribe

Text output flows to Combine Fields node

Phase 5: Image Input Path (OCR Processing)

Image Download from Telegram

// Telegram Download Image Node
Resource: File
File ID: {{ $json.message.photo[2].file_id }}
// photo[2] = highest resolution available

Why photo[2]: Telegram provides 3-4 resolution options:

photo[0]: Thumbnail (low quality, fast loading)

photo[1]: Medium quality

photo[2]: High quality (best for OCR accuracy)

photo[3]: Original (if available)

Higher resolution = better OCR accuracy, especially for small text on receipts.

OCR.space API Integration

// HTTP Request Node - POST to OCR.space
URL: https://api.ocr.space/parse/image
Method: POST
Headers: {
  "apikey": "YOUR_FREE_API_KEY"
}
Body: Form Data
- Parameter type: n8n binary file
- Name: file
- Data field name: data

OCR.space Free Tier:

25,000 requests per month

1MB file size limit

3-page PDF limit

More than enough for personal expense tracking

Example Output:

{
  "ParsedResults": [{
    "ParsedText": "MAIN STREET RESTAURANT\nDate: 04/07/2017\nSubtotal: $265.00\nTax: $26.00\nTOTAL: $291.00\nThank you for dining with us!"
  }]
}

Why This Matters: The AI agent receives the full text content of the receipt. It''s smart enough to identify the total amount, ignore subtotals, and extract the date—even when receipt formatting varies wildly.

Phase 6: PDF Input Path (Document Processing)

PDF Download

// Telegram Download Document Node
Resource: File  
File ID: {{ $(''Telegram Trigger'').item.json.message.document.file_id }}

Common Use Case: Email yourself monthly invoices (utility bills, subscriptions, contractor invoices), forward to Telegram bot, auto-logged.

Same OCR Processing

The OCR.space API handles both images and PDFs with the same endpoint. No separate configuration needed—the HTTP Request node processes PDFs identically to images.

3-Page Limit Strategy: Most single invoices are 1-2 pages. If you have multi-page statements, the AI will extract data from first 3 pages (usually sufficient for total amount).

Phase 7: Data Combination & Prompt Assembly

Combine Fields Node

// Edit Fields Node (renamed "Combine Fields")
Operation: Manual Mapping
Field to Set: prompt

Value: 
{{ $json.ParsedResults[0].ParsedText }}  
{{ $(''Telegram Trigger'').item.json.message.text }} 
{{ $json.text }}

What This Does: Creates a unified "prompt" variable that contains whichever input was received:

If OCR ran: Contains parsed receipt text

If text message: Contains original message

If transcription ran: Contains transcribed voice

Why Combine: The AI Agent expects a single input variable. This node ensures regardless of input path (text/voice/image/PDF), the agent always receives data in the same format.

Technical Detail: Empty variables don''t break the concatenation. If image path ran, message.text is null but doesn''t cause errors—just concatenates empty string.

Phase 8: AI Agent Configuration

System Prompt Engineering

You are a helpful assistant for an expense tracker. First, you must 
determine whether the input I provide you with is adding a new entry 
or inquiring about existing entries.

Currency is US Dollar

The current date is {{ $now }}

If it''s a new entry: Create a new entry with a corresponding category: 
entertainment, food, eating out, travel, transport, health, personal. 
Update the date field using an ISO 8601 format date, sent as a datetime 
variable, NOT a string.

If you receive a bunch of text from an invoice or a receipt, determine 
the date and TOTAL amount and create a SINGLE entry.

When you reply with a confirmation of an entry you made, only confirm 
the last successful entry, not any earlier ones. One message from you 
should only confirm a single transaction.

If it''s an inquiry, use the search entries tool to get information and 
answer my question.

Why This Prompt Works:

Intent Classification First: Agent decides "new expense" vs "inquiry" before taking action

Dynamic Date Reference: {{ $now }} provides current timestamp for relative dates ("yesterday", "last Tuesday")

Category Constraints: Limits to 7 predefined categories for consistency

ISO Format Emphasis: Critical instruction—Airtable datetime fields reject string dates

Receipt Handling: Explicitly tells AI to ignore subtotals, only log final TOTAL

Confirmation Behavior: Prevents chatty responses listing every past transaction

Window Buffer Memory

// Memory Configuration
Session ID Type: Custom Key
Session Key: {{ $(''Telegram Trigger'').item.json.message.chat.id }}

Why Chat ID: Each Telegram user has unique chat ID. This ensures:

Multiple users can use same bot without memory conflicts

Conversation context maintained per user

"Try again" or "use today''s date" references work correctly

Memory Window: Keeps last 5-10 messages in context. Enables follow-up questions:

User: "Add $20 lunch expense"
Bot: "Logged to food category. Correct?"
User: "No, eating out category"
Bot: [Updates previous entry]

Phase 9: Airtable Tool Integration

Create Entry Tool

// Airtable Tool - Create Record
Operation: Create
Base: Expense Tracker
Table: Table 1
Mapping Mode: Define Below

Columns with AI Generation:
- Expense: $fromAI(''Expense'', '''', ''string'')
- Amount: $fromAI(''Amount'', '''', ''number'')  
- Category: $fromAI(''Category'', '''', ''string'')
- Date: $fromAI(''Date'', ''datetime variable'', ''string'')

The $fromAI() Magic: This special n8n function tells the AI agent "you need to provide this parameter." The agent dynamically fills these fields based on the input.

Example Flow:

Input: "Spent $42 on groceries yesterday"
AI Determines:
- Expense: "Groceries"
- Amount: 42
- Category: "food"
- Date: "2025-03-10T12:00:00Z" (yesterday''s date in ISO format)

Airtable Receives: Properly typed data, creates record automatically

Critical Detail: The Date field hint "datetime variable" reinforces that the AI must send ISO format, not plain text like "March 10, 2025".

Search Entries Tool

// Airtable Tool - Search Records  
Operation: Search
Base: Expense Tracker
Table: Table 1
Return All: Yes (no pagination needed for personal expenses)

Use Cases:

"How much did I spend on food this month?"

"Show me all my transport expenses"

"What did I buy on March 5th?"

"Total spending last week?"

How It Works: AI agent automatically calls this tool when it detects a question (vs a new expense statement). Retrieves all matching records, performs calculations, returns natural language answer.

Phase 10: Response Delivery

Telegram Reply

// Telegram Send Message Node
Chat ID: {{ $(''Telegram Trigger'').item.json.message.chat.id }}
Text: {{ $json.output }}
// Sends AI agent''s response back to user

Response Examples:

After logging expense:

"I''ve added the expense of $291 for dining at Main Street Restaurant 
on April 7th, 2017 to the eating out category."

After inquiry:

"You''ve spent $67 on food this month across 3 transactions:
- $25 luxury coffee beans (Mar 11)
- $20 groceries (Mar 10)  
- $22 pizza delivery (Mar 8)"

Why This Works: AI agent''s natural language output directly becomes the Telegram message. No additional formatting needed—the agent is already trained to be conversational.

Business Applications & ROI

Personal Finance Management

Before Automation:

30 transactions per month

5 minutes per transaction to log manually

Total: 2.5 hours per month

Incomplete records (forget ~40% of expenses)

No spending insights

After Automation:

30 transactions per month

10 seconds per transaction (send message/photo)

Total: 5 minutes per month

Time saved: 2.4 hours per month

100% expense capture

AI-powered spending queries

Freelancer/Small Business Use Case

Track Business Expenses:

Receipt photos → auto-categorized for tax deductions

Voice notes during travel: "Gas $45, tolls $8, parking $20"

PDF invoices forwarded to bot → logged automatically

End of year: Complete expense report in Airtable, export to CSV for accountant

ROI: Save $500-1000 in accounting fees by having organized records.

Family Shared Expenses

Multi-User Setup:

Each family member gets same Telegram bot access

Session ID (chat.id) keeps expenses separate

Parents can query: "What did the kids spend this week?"

Teach children financial literacy through transparent tracking

Agency/Productized Service

Offer: Expense Tracker Bot Setup for $297

Your time: 90 minutes to build + 30 minutes to customize

Your cost: $23/month API costs

Client value: Saves 3+ hours per month

Profit margin: $250+ per client, recurring $27/month maintenance

At 10 clients: $2,500 setup revenue + $270/month recurring = $5,740 first year.

Advanced Customizations

Multi-Currency Support

// Modify system prompt:
"Currency defaults to USD unless specified. If user mentions EUR, GBP, 
etc., log that currency symbol in the Expense field along with amount."

// Airtable: Add "Currency" column with USD as default

Budget Alerts

// Add Code Node after AI Agent:
if (category === ''eating out'') {
  const monthlyTotal = await searchAirtable(''eating out'', currentMonth);
  if (monthlyTotal > 500) {
    return "⚠️ Warning: You''ve exceeded your $500 eating out budget!";
  }
}

Receipt Image Storage

// Add Google Drive Node:
// Upload photo[3] (full resolution) to "Receipts/YYYY-MM" folder
// Add Drive URL to Airtable record for future reference

Recurring Expense Automation

// Add Schedule Trigger:
// Every 1st of month → Create entry: "Rent $1500" 
// Every Friday → Check if gym membership logged

Export to Google Sheets

// Weekly Schedule Trigger:
// Query all expenses from past 7 days
// Append to "Weekly Expenses" Google Sheet
// Format as budget report

Troubleshooting & Common Issues

Issue 1: Airtable Date Field Error "Invalid ISO format"

Problem: Agent logs expense but Airtable rejects with date error Solution:

Verify Airtable date field is set to "Include time" (not just date)

Add to system prompt: "CRITICAL: Always send dates in ISO 8601 format like 2025-03-11T14:30:00Z"

Test with manual entry: If 2025-03-11 fails but 2025-03-11T00:00:00Z works, this is the issue

Issue 2: OCR Returns Gibberish from Poor Photo

Problem: Blurry receipt photo → OCR misreads "$291" as "$Z91" → wrong amount logged Solution:

Add validation to system prompt: "If OCR text contains obvious errors (letters where numbers should be), ask user to resend clearer photo"

Educate users: Good lighting + flat surface = accurate OCR

Implement confidence threshold: If OCR.space returns isErroredOnProcessing: true, reject automatically

Issue 3: AI Categorizes Incorrectly

Problem: "Coffee beans" logged as "eating out" instead of "food" Solution:

Expand category definitions in prompt:
"food: groceries, ingredients, home cooking supplies"

"eating out: restaurants, cafes, takeout, delivery"

Add examples: "Coffee beans = food, coffee shop visit = eating out"

Allow manual recategorization: "Change last expense to food category"

Issue 4: Voice Transcription Mishears Numbers

Problem: "$45" transcribed as "forty-five dollars" but AI logs as "$4,500" Solution:

Whisper transcription is highly accurate, issue is likely:
Background noise during recording

Unclear pronunciation of numbers

Add to prompt: "If amount seems unusually large, confirm with user"

Enable user confirmation: Bot asks "I heard $4,500, is that correct?"

Issue 5: Session Memory Lost Between Conversations

Problem: User says "Use today''s date" but bot doesn''t remember context Solution:

Check Window Buffer Memory session key is correct: {{ $(''Telegram Trigger'').item.json.message.chat.id }}

Increase memory window: Default 5 messages, increase to 10 for longer context

Memory persists only during active n8n workflow execution—stopping/restarting workflow clears memory

Issue 6: Switch Node Routes to Wrong Path

Problem: PDF sent but routed through image path instead of document path Solution:

Route priority matters: Switch evaluates conditions in order

Reorder routes: Most specific first (voice, document, photo), generic last (text)

Debug mode: Add Code Node after Switch to log which path activated

Assignment: Build Your Expense Tracker

Phase 1: Foundation (20 minutes)

Create Telegram bot via BotFather

Set up Airtable base with 4 columns (Expense, Amount, Category, Date)

Configure Telegram Trigger in n8n with your bot token

Send test message "Hello" and verify trigger receives data

Success Metric: Telegram trigger successfully captures your message

Phase 2: Basic Text Processing (25 minutes)

Add AI Agent with system prompt (use provided template)

Connect OpenAI Chat Model (GPT-4o mini)

Set up Window Buffer Memory with chat.id as session key

Configure Airtable Create Tool with $fromAI parameters

Test: Send "Spent $20 on lunch" via Telegram

Success Metric: Expense appears in Airtable with correct amount and auto-categorization

Phase 3: Multi-Modal Input (30 minutes)

Add Switch node with 4 routes (text, voice, photo, document)

Implement voice path: Download Audio → Whisper → Combine Fields

Implement image path: Download Image → OCR → Combine Fields

Test voice: Record "Spent $15 on coffee"

Test image: Upload receipt photo

Success Metric: All input types successfully logged to Airtable

Advanced Challenge: Query System

Add Airtable Search Tool to AI Agent

Test inquiry: "How much have I spent on food this week?"

Verify AI correctly sums expenses and responds naturally

Test follow-up question: "What about eating out?"

Success Metric: AI agent answers spending queries accurately using search tool

Resources & Templates

Complete System Package

Full n8n Workflow JSON - Import and add your API keys

Airtable Base Template - Pre-configured with correct field types

System Prompt Library - Variations for different use cases

Telegram Bot Setup Guide - Step-by-step BotFather instructions

API Setup Guides

OpenAI API Key - Getting started with platform.openai.com

OCR.space Free Tier - Registration and API key retrieval

Airtable Personal Access Token - Creating API credentials

Category Customization Templates

Freelancer Categories: Client expenses, equipment, software, marketing

Family Categories: Kids, household, utilities, entertainment

Travel Categories: Flights, lodging, meals, activities, transport

Key Takeaways

Technical Mastery: ✅ Multi-modal input processing (text, voice, image, PDF) ✅ Intelligent routing with Switch node conditional logic ✅ API integration for OCR, speech-to-text, and database operations ✅ AI agent tool calling for dynamic database interactions ✅ Session management with chat-based memory persistence

Business Impact: ✅ 2.4 hours saved per month on expense tracking ✅ 100% expense capture vs 60% with manual logging ✅ $23/month total cost vs $200/month opportunity cost ✅ Zero learning curve - just text/speak naturally ✅ Queryable history - ask AI about spending patterns

Strategic Positioning: ✅ Frictionless data capture drives consistent tracking behavior ✅ Multi-modal input removes all excuses for not logging ✅ AI categorization eliminates decision fatigue ✅ Conversational interface beats traditional form-based apps ✅ Personal financial clarity enables better money decisions', 2),
  ('00bf03d0-4f50-4770-be42-55b18cb8e267', 'a24ea901-64ab-42e9-b1ed-b45851de3719', 'AI Project Manager: From 4 Hours to 15 Minutes', 'Lesson Overview

Build an AI-powered project management system that transforms chaotic project planning into structured, actionable roadmaps in minutes instead of hours. This system uses advanced agent orchestration to think like a senior PM, plan like an agile expert, and execute faster than any human team - complete with automatic task creation, dependency mapping, and intelligent team assignments.

Time to Complete: 60 minutesDifficulty: Intermediate-AdvancedTools Required: N8N, Asana, Anthropic ClaudeTime Transformation: 4+ hours → 15 minutes (94% reduction)

The Project Planning Problem

Traditional Agile Planning Reality

Manual Process (4+ hours):
- Initial discovery and scope definition: 1 hour
- Team meetings to break down work: 1.5 hours
- Epic and user story creation: 1 hour
- Task assignment and timeline estimation: 45 minutes
- Documentation and tool setup: 45 minutes
TOTAL: 4+ hours + 3 team meetings

AI-Powered Solution

Automated Process (15 minutes):
- Discovery questions: 5 minutes (one-time input)
- AI analysis and breakdown: 3 minutes (automatic)
- Epic-by-epic confirmation: 5 minutes (oversight)
- Final review and adjustments: 2 minutes
TOTAL: 15 minutes, zero meetings required

System Architecture Overview

Component Structure

Chat Trigger
    ↓
Project Manager Agent (Claude Sonnet 4)
    ├── Memory (Buffer Window)
    ├── Think Tool (Enhanced Reasoning)
    └── Asana Tools
        ├── Create Project
        ├── Get Many Projects
        ├── Create Task
        ├── Create Subtask
        └── Find User Agent (Nested)
            ├── GPT-4o-mini
            └── Get Many Users

Phase 1: Chat Trigger Setup

Basic Configuration

{
  "type": "chatTrigger",
  "webhookId": "unique-webhook-id",
  "options": {}
}

Purpose: Provides conversational interface for project planning. Can be replaced with Slack, email, or other input methods.

Phase 2: Main Agent Configuration

System Prompt (Actual Implementation)

You are an expert agile development consultant with extensive experience in project breakdown and sprint planning.

When I provide you with a project, please analyze it and deliver a structured breakdown.

**Initial Discovery Process:**
Start by gathering key project details through targeted questions:
- Project description and main objectives
- Target audience/ICP specifics
- Team composition and timeline constraints
- Technical preferences and existing assets
- Specific service offerings or features needed

**Delivery Process:**

**Phase 1: Project Overview & Setup**
Provide human-readable analysis and use the Asana tool to create a project and add the milestones and risks in the project notes. The current time and date is {{ $now }}

{
  "project": {
    "name": "Project Name",
    "description": "Brief description",
    "estimated_duration": "X weeks",
    "complexity": "Low/Medium/High",
    "team_size": X,
    "target_launch": "YYYY-MM-DD"
  },
  "milestones": [
    {
      "name": "Milestone Name",
      "date": "YYYY-MM-DD",
      "description": "Key deliverable or checkpoint"
    }
  ],
  "risks": [
    {
      "description": "Risk description",
      "impact": "High/Medium/Low",
      "probability": "High/Medium/Low",
      "mitigation": "Mitigation strategy"
    }
  ]
}

Phase 2: Epic-by-Epic Breakdown
After the user confirms Phase 1 is imported, proceed with individual epics. IMPORTANT: Use the Asana Get Project tool to find the relevant project ID and add all tasks and subtasks to the project you created earlier using the Asana Create task and Create subtask tools - each epic is an Asana task and subtasks will be nested.

{
  "epic": {
    "id": "epic_X",
    "name": "Epic Name",
    "description": "Epic description",
    "priority": "Critical/High/Medium/Low",
    "estimated_effort": "X story points",
    "sprint": "Sprint X",
    "tasks": [
      {
        "id": "task_X",
        "name": "Task Name",
        "description": "Detailed task description with acceptance criteria",
        "type": "Development/Design/Testing/Documentation/Content",
        "priority": "Critical/High/Medium/Low",
        "estimated_effort": "X hours",
        "due_date": "YYYY-MM-DD",
        "assignee": "Role (Developer/Sales Consultant)",
        "status": "Not Started",
        "dependencies": ["task_id"],
        "subtasks": [
          {
            "name": "Subtask Name",
            "description": "Specific actionable item",
            "estimated_effort": "X hours",
            "due_date": "YYYY-MM-DD"
          }
        ]
      }
    ]
  }
}

Workflow:
1. Gather project requirements through targeted questions
2. Output Phase 1 (Project + Milestones + Risks) and use Asana tool
3. Wait for user confirmation of import
4. Output Epic 1 and ask "Ready for Epic 2?" and use Asana tool
5. Continue iteratively through all epics using Asana tool
6. Provide final summary and next steps

Guidelines:
- Keep JSON outputs under token limits by breaking into logical chunks
- Use realistic timelines with buffer time built in
- Clearly mark dependencies between tasks
- Include specific acceptance criteria in task descriptions
- Assign tasks to appropriate team roles (Developer vs Sales Consultant)

Communication Style:
- Start with friendly, engaging tone
- Ask targeted follow-up questions to clarify scope
- Provide clear phase-by-phase progression
- Confirm user readiness before proceeding to next epic
- Do not output JSON to the user - that''s just for your reference

Begin each project breakdown by gathering essential details and confirming the iterative output approach works for the user''s workflow.

Phase 3: Chat Model Selection

Anthropic Claude Sonnet 4 Configuration

{
  "model": "claude-sonnet-4-20250514",
  "credentials": "anthropic-api-key"
}

Why Claude Sonnet 4:

Superior reasoning for complex project planning

Excellent at structured output generation

Strong with iterative, multi-step processes

Good token efficiency for long conversations

Alternative Models:

OpenAI o1/o3: Excellent logical planning

Google Gemini 2.5: Large context windows

Groq Llama: Speed for rapid iteration

Phase 4: Memory Configuration

Buffer Window Memory

{
  "type": "memoryBufferWindow",
  "contextWindowLength": 10,
  "purpose": "Track epic progression and maintain project context"
}

Critical Function: Without memory, the agent forgets which epic is completed and may duplicate work or lose context between user confirmations.

Phase 5: Think Tool Integration

Enhanced Reasoning

{
  "type": "toolThink",
  "purpose": "Invites AI to verify output matches requirements"
}

Benefit: For complex outputs like project plans, the Think tool improves accuracy by allowing the model to self-verify before responding.

Phase 6: Asana Tool Integration

Authentication Setup

Go to app.asana.com/0/my-apps

Create Personal Access Token

Copy token to N8N credentials

Select workspace and team IDs

Tool 1: Create Project

{
  "resource": "project",
  "operation": "create",
  "name": "{{ $fromAI(''Project_Name'') }}",
  "workspace": "your-workspace-id",
  "team": "your-team-id"
}

Tool 2: Get Many Projects

{
  "resource": "project",
  "operation": "getAll",
  "workspace": "your-workspace-id",
  "limit": "{{ $fromAI(''Limit'') }}"
}

Critical Step: Agent must fetch project list to get correct project ID before creating tasks.

Tool 3: Create Task

{
  "workspace": "your-workspace-id",
  "name": "{{ $fromAI(''Task_name'') }}",
  "otherProperties": {
    "assignee": "{{ $fromAI(''assignee_id'') }}",
    "due_on": "{{ $fromAI(''Due_On'') }}",
    "notes": "{{ $fromAI(''Notes'') }}",
    "projects": "{{ $fromAI(''Project_Names_or_IDs'') }}"
  }
}

Tool 4: Create Subtask

{
  "resource": "subtask",
  "taskId": "{{ $fromAI(''Parent_Task_ID'') }}",
  "name": "{{ $fromAI(''Task_name'') }}",
  "otherProperties": {
    "assignee": "{{ $fromAI(''assignee_id'') }}",
    "due_on": "{{ $fromAI(''Due_On'') }}",
    "notes": "{{ $fromAI(''Notes'') }}"
  }
}

Phase 7: Nested User Assignment Agent

Agent Configuration

{
  "toolDescription": "AI agent to determine best user for the task",
  "systemPrompt": "You are an HR expert and your job is to determine who to assign the given task to. Use the Asana tool to get a list of users and pass the most relevant GID as your output.",
  "model": "gpt-4o-mini"
}

Get Many Users Tool

{
  "resource": "user",
  "operation": "getAll",
  "workspace": "your-workspace-id"
}

Architecture Benefit: Separating user assignment into nested agent prevents token overflow in main agent and provides specialized reasoning.

Phase 8: Workflow Execution Pattern

Step-by-Step Process

1. User: "I want to build a website for my AI agency"
   
2. Agent: Discovery Questions
   - What services will you offer?
   - Who is your target audience?
   - What''s your timeline?
   - Who''s on your team?

3. User: Provides detailed answers

4. Agent: Creates project in Asana
   - Generates project overview
   - Adds milestones and risks
   - Confirms: "Project created. Ready for Epic 1?"

5. User: "Yes"

6. Agent: Epic 1 Creation
   - Fetches project ID
   - Creates main task (Epic 1)
   - Creates all subtasks
   - Assigns team members
   - Sets due dates
   - Confirms: "Epic 1 complete. Ready for Epic 2?"

7. Repeat for all epics (typically 4-6 epics)

8. Agent: Final Summary
   - Project completion timeline
   - Next steps
   - Key milestones

Phase 9: Project Structure Examples

Typical Epic Breakdown

Epic 1: Strategy & Content Foundation (Week 1)
├── Brand positioning workshop
├── Content strategy document
├── SEO keyword research
└── Core messaging framework

Epic 2: Design & UX (Week 2)
├── Wireframes for key pages
├── Visual design system
├── Interactive prototype
└── Design review and iteration

Epic 3: Development Setup (Week 3)
├── Development environment setup
├── CI/CD pipeline configuration
├── Database schema design
└── API architecture planning

Epic 4: Frontend Development (Weeks 4-5)
├── Component library creation
├── Page template development
├── Responsive design implementation
└── Cross-browser testing

Epic 5: Backend Development (Weeks 4-5)
├── API endpoint creation
├── Database integration
├── Authentication system
└── Admin dashboard

Epic 6: Testing & Launch (Week 6)
├── QA testing and bug fixes
├── Performance optimization
├── Security audit
├── Deployment and monitoring
└── Post-launch support plan

Business Applications

Use Cases Beyond Software Development

Event Planning:

Epic 1: Venue and vendor selection

Epic 2: Marketing and promotion

Epic 3: Logistics and operations

Epic 4: Day-of coordination

Home Renovation:

Epic 1: Design and planning

Epic 2: Demolition and prep

Epic 3: Major installations

Epic 4: Finishing and cleanup

Content Marketing Campaign:

Epic 1: Strategy and research

Epic 2: Content creation

Epic 3: Design and production

Epic 4: Distribution and promotion

Epic 5: Analysis and optimization

Product Launch:

Epic 1: Market research

Epic 2: Product development

Epic 3: Go-to-market strategy

Epic 4: Launch execution

Epic 5: Post-launch optimization

Advanced Customizations

Adding Custom Team Roles

// In Find User Agent system prompt
"TEAM EXPERTISE MAPPING:
- Frontend tasks → Sarah (React, UI/UX)
- Backend tasks → Mike (APIs, databases)
- Design tasks → Jessica (Figma, visual design)
- Content tasks → Alex (writing, SEO)
- DevOps tasks → Carlos (deployment, infrastructure)
- Marketing tasks → Taylor (campaigns, analytics)"

Industry-Specific Templates

// Agency-specific epic patterns
"For agency website builds:
- Epic 1: Strategy & Positioning
- Epic 2: Content & SEO
- Epic 3: Design System
- Epic 4: Development
- Epic 5: Client Portal
- Epic 6: Launch & Training"

Cost Analysis

API Cost Breakdown

Per Project Planning Session:
- Claude Sonnet 4 tokens: ~50K tokens
- Cost per session: ~$0.75-1.50
- GPT-4o-mini (user assignment): ~5K tokens
- Cost per session: ~$0.05

Monthly Usage (20 projects):
- Total cost: $16-31/month
- Time saved: 80+ hours
- Value: $4,000+ in PM time

Troubleshooting

Common Issues

Problem: Agent creates new project for each epic Solution: Ensure "Get Many Projects" tool is called before task creation

Problem: Tasks not assigned to correct team members Solution: Update Find User Agent with accurate team mapping

Problem: Agent loses context between epics Solution: Verify memory configuration is active and context window is sufficient

Problem: Due dates unrealistic or missing Solution: Ensure current date is passed in system prompt: {{ $now }}

Assignment: Build Your AI PM

Phase 1: Basic Implementation

Set up N8N workflow with all required nodes

Configure Asana integration and test tools

Create simple 3-epic project (personal task)

Document time savings vs manual planning

Phase 2: Team Integration

Add team members to Asana

Configure Find User Agent with real team mapping

Test with actual team project

Gather feedback on task assignments

Phase 3: Production Deployment

Create industry-specific epic templates

Add custom discovery question flows

Integrate with existing project management processes

Train team on AI PM system usage

Key Takeaways

Time Transformation:

4+ hours manual planning → 15 minutes AI-assisted

3 team meetings → 0 meetings required

Days of back-and-forth → Real-time iteration

Quality Improvements:

Consistent agile methodology application

Comprehensive dependency tracking

Realistic timeline estimation

Proper task prioritization

Business Impact:

Project managers can handle 10x more projects

Faster time-to-execution on new initiatives

Reduced planning overhead costs

Improved team alignment and clarity

This system transforms project planning from a time-consuming bottleneck into a rapid, intelligent process that produces better results in a fraction of the time.', 3),
  ('bc6ee035-aac6-46e0-a3f2-a0b55788cf98', 'a24ea901-64ab-42e9-b1ed-b45851de3719', 'Build JARVIS: Multi-Agent AI Voice Assistant', 'Build JARVIS: Complete AI Voice Assistant with Multi-Agent Architecture

Lesson Overview

Create a production-ready AI voice assistant that rivals commercial solutions by combining Lovable for the frontend, N8N for multi-agent orchestration, and ElevenLabs for natural voice interaction. This system demonstrates the most advanced AI automation concepts: hierarchical agent coordination, persistent memory, and seamless tool integration across 8 specialized domains.

Time to Complete: 180 minutes (advanced project)Difficulty: Expert LevelTools Required: Lovable, N8N, ElevenLabs, Multiple Google APIs, PostgreSQL

The Power of UI-First Automation

Why Visual Demos Transform Sales

The Psychology: Clients buy with their eyes first. A sophisticated backend means nothing if the interface looks amateur. This Jarvis build demonstrates the critical difference between:

Amateur Approach:

Clunky widget buttons

Separate interfaces for voice activation

Generic chatbot appearance

Obvious "demo" limitations

Professional Approach:

Seamless voice activation in sleek UI

Cinematic interface matching user expectations

Hidden complexity with elegant simplicity

Production-ready user experience

Business Impact: The difference between "that''s cool" and jaw-dropping amazement that closes deals.

Architecture Overview: The JARVIS Ecosystem

Three-Tier Architecture

Frontend Layer (Lovable)
├── Cinematic Jarvis Interface
├── Integrated Voice Activation
├── Seamless ElevenLabs Integration
└── Real-time Response Display

Backend Orchestration (N8N)
├── Master Orchestrator Agent
├── 8 Specialized Sub-Agents
├── Persistent Memory System
└── Multi-API Integration Hub

Voice Intelligence (ElevenLabs)
├── Advanced Voice Agent
├── Custom Tool Integration
├── Conversational Flow Management
└── Intelligent Response Timing

Multi-Agent Specialization

🎯 Master Orchestrator → Coordinates all operations
📧 Email Agent → Gmail management & automation
📅 Calendar Agent → Google Calendar integration
🏦 Finance Agent → Expense tracking & analysis
🌤️ Weather/News Agent → Real-time information
✈️ Travel Agent → Flights & hotel booking
👥 Contacts Agent → Google Contacts management
📝 Content Agent → Blog post creation
🔍 Research Agent → Deep web research

Phase 1: Frontend Excellence with Lovable

The Cinematic Interface Prompt

Create a sleek, dark Jarvis-style AI assistant interface with the following specifications:

VISUAL DESIGN:
- Dark theme with subtle blue/cyan accents
- Circular central interface element resembling an AI core
- Pulsing animation when listening/responding
- Minimalist, high-tech aesthetic
- Responsive design for desktop and mobile

FUNCTIONALITY:
- Integrated voice activation button (not separate widget)
- Real-time conversation display
- Status indicators (listening, processing, responding)
- Clean message history with timestamp
- Seamless ElevenLabs voice agent integration

TECHNICAL REQUIREMENTS:
- Connect to ElevenLabs Agent API
- Handle voice streaming and responses
- Display conversation state clearly
- Professional loading states and animations
- Error handling for connection issues

The interface should feel like interacting with a premium AI assistant, not a demo or prototype.

ElevenLabs Integration Setup

// Lovable integration with ElevenLabs
const agentConfig = {
  agentId: ''your-jarvis-agent-id'',
  apiKey: ''your-elevenlabs-api-key'',
  voice: ''jarvis-voice-model'',
  responseFormat: ''streaming''
};

// Voice activation integration
const startConversation = async () => {
  const response = await elevenLabs.createConversation(agentConfig);
  updateUIState(''listening'');
  return response.conversationId;
};

Key Differentiator: The voice activation is seamlessly integrated into the main interface, not a separate overlay or widget.

Phase 2: ElevenLabs Voice Agent Configuration

Master Agent Personality Design

SYSTEM PROMPT:
You are JARVIS, an advanced AI assistant with a sophisticated British accent and professional demeanor. You excel at:

CORE CAPABILITIES:
- News and weather updates
- Travel planning and booking
- Email management and composition  
- Calendar scheduling and management
- Blog post creation and research
- Expense tracking and analysis
- Deep research with citations
- Contact management

PERSONALITY TRAITS:
- Professional yet personable
- Witty when appropriate
- Efficient and focused
- Slightly formal but warm
- Uses "sir" occasionally for authenticity

CONVERSATION FLOW:
When users request any of the 8 core functions, immediately call the agent tool and engage in friendly banter while processing. Use humor or brief stories to fill processing time, but stop when you receive the response.

INCOMPLETE REQUESTS:
If a request lacks information, gather missing details conversationally before proceeding. Always confirm before taking action.

TOOL USAGE:
For any complex request, use the "call_agent" tool which connects to the N8N backend for processing.

Custom Tool Configuration

{
  "name": "call_agent",
  "description": "Processes complex requests through the N8N backend system including email, calendar, research, expense tracking, travel planning, weather, news, and content creation",
  "endpoint": "https://your-n8n-instance.com/webhook/jarvis-agent",
  "method": "POST",
  "timeout": 120000,
  "parameters": {
    "user_request": {
      "type": "string",
      "description": "The complete user request to be processed by the backend system"
    }
  }
}

Critical Feature: The agent engages in natural conversation while waiting for backend processing, making delays feel intentional rather than problematic.

Phase 3: N8N Multi-Agent Orchestration

Master Orchestrator Agent Design

SYSTEM PROMPT:
Current time and date: {{ $now }}

You are the master orchestrator for a comprehensive personal assistant system. You have access to specialized tools for:

AVAILABLE AGENTS:
1. Email Management Agent - Full Gmail functionality
2. Calendar Agent - Google Calendar management  
3. Finance Tracker Agent - Expense logging and analysis
4. Weather and News Agent - Real-time information
5. Travel Agent - Flight and hotel booking
6. Contacts Agent - Google Contacts integration
7. Blog Post Writer - Content creation with research
8. Research Agent - Deep web research with citations

ORCHESTRATION STRATEGY:
- Route requests to appropriate specialized agents
- Coordinate multi-step operations across agents
- Maintain context between agent interactions
- Provide unified responses to users

EXAMPLE MULTI-AGENT FLOW:
User: "Log my $50 zoo expense and research penguin transportation, then email the findings to Nure"
1. Finance Agent → Log expense
2. Research Agent → Investigate penguin transportation  
3. Contacts Agent → Find Nure''s email
4. Email Agent → Send research findings

Specialized Agent Architecture

Email Management Agent

{
  "capabilities": [
    "Send and compose emails",
    "Search and filter messages", 
    "Mark as read/unread",
    "Add and remove labels",
    "Reply to messages",
    "Delete messages"
  ],
  "tools": [
    "Send a message in Gmail",
    "search1", "get1", "reply1", 
    "markAsRead1", "markAsUnread1",
    "addLabels1", "removeLabels1", "delete1"
  ],
  "model": "gpt-4.1"
}

Calendar Agent

{
  "capabilities": [
    "Create calendar events",
    "Search existing events",
    "Update event details", 
    "Delete events",
    "Check availability"
  ],
  "tools": [
    "Create an event in Google Calendar",
    "Get many events in Google Calendar",
    "Get an event in Google Calendar", 
    "Update an event in Google Calendar",
    "Delete an event in Google Calendar"
  ],
  "model": "gpt-4.1-mini"
}

Finance Tracker Agent

{
  "system_prompt": "You are a helpful assistant for expense tracking in South African Rand. Current date: {{ $now }}. Determine if input is adding new entry or inquiring about existing entries. Categories: entertainment, food, eating out, travel, transport, health, personal. Use ISO 8601 format for dates.",
  "tools": [
    "Create Entry",
    "Search Entries"  
  ],
  "database": "Airtable expense tracker",
  "model": "gpt-4.1"
}

Research Agent

{
  "capabilities": [
    "Web search via Tavily",
    "Academic research via Perplexity", 
    "In-depth analysis",
    "Source citation"
  ],
  "tools": [
    "Tavily Research",
    "Message a model in Perplexity",
    "In-Depth Research Tool"
  ],
  "model": "gpt-4.1"
}

Content Creation Agent

{
  "workflow": [
    "Generate title and structure using Perplexity",
    "Research each section with Tavily and Perplexity", 
    "Generate images with Replicate",
    "Write sections using specialized writer tool",
    "Create and update Google Doc",
    "Return shareable URL"
  ],
  "tools": [
    "Titles and Structure Tool",
    "Generate Image Tool", 
    "Write Section Tool",
    "Create/Update Google Docs"
  ],
  "model": "claude-sonnet-4"
}

Phase 4: Advanced Memory & Context Management

PostgreSQL Persistent Memory

// Memory configuration for main orchestrator
const memoryConfig = {
  type: "postgres",
  sessionKey: "{{ $json.headers[''x-forwarded-for''] }}",
  contextWindowLength: 7,
  persistAcrossSessions: true
};

Distributed Memory Architecture

Main Agent Memory (PostgreSQL)
├── User conversation history
├── Task completion records
├── Preference learning
└── Context continuity

Sub-Agent Memory (Buffer Windows)
├── Finance Agent: 10 context window
├── Email Agent: 10 context window  
├── Calendar Agent: 10 context window
└── Research Agent: 10 context window

Benefits:

Remembers user preferences across sessions

Maintains context during complex multi-step operations

Learns from user feedback and corrections

Provides personalized responses based on history

Phase 5: Tool Integration & API Management

Google Workspace Integration

// Calendar integration example
const calendarTools = {
  create: {
    calendar: "shabbir@shabbirnoor.com",
    start: "{{ $fromAI(''Start'') }}",
    end: "{{ $fromAI(''End'') }}",
    attendees: ["{{ $fromAI(''attendees0_Attendees'') }}"],
    summary: "{{ $fromAI(''Summary'') }}",
    description: "{{ $fromAI(''Description'') }}"
  },
  search: {
    timeMin: "{{ $fromAI(''After'') }}",
    timeMax: "{{ $fromAI(''Before'') }}",
    returnAll: "{{ $fromAI(''Return_All'') }}"
  }
};

External API Integration

// Weather API integration
const weatherConfig = {
  endpoint: "http://api.weatherapi.com/v1/forecast.json",
  parameters: {
    q: "{{ $fromAI(''location'') }}",
    days: "{{ $fromAI(''forecast_days'') }}"
  }
};

// Travel booking via SerpAPI
const travelConfig = {
  flights: "https://serpapi.com/search?engine=google_flights",
  hotels: "https://serpapi.com/search?engine=google_hotels"
};

Phase 6: Advanced Conversation Patterns

Multi-Step Operation Handling

Example: Complex Multi-Agent Request
User: "Book me a flight to Bali, log it as a travel expense, and schedule a planning meeting with my team"

Orchestrator Response:
1. Route to Travel Agent → Find flights
2. Route to Finance Agent → Log expense  
3. Route to Contacts Agent → Find team emails
4. Route to Calendar Agent → Schedule meeting
5. Compile unified response

Processing Time Management:
- ElevenLabs agent provides entertaining conversation
- Backend processing happens asynchronously
- Response delivered when all operations complete

Error Handling & Recovery

// Graceful error handling
const errorHandling = {
  apiFailure: "Apologize and suggest alternatives",
  missingInfo: "Ask clarifying questions conversationally",
  authErrors: "Guide user through reconnection",
  timeout: "Acknowledge delay and provide status"
};

Phase 7: Production Deployment & Optimization

Performance Optimization

Model Selection Strategy:
- Main Orchestrator: GPT-4.1 (complex reasoning)
- Sub-agents: GPT-4.1-mini (cost optimization)  
- Content Creation: Claude Sonnet 4 (superior writing)
- Simple Tasks: GPT-4.1-nano (speed & cost)

Memory Management:
- PostgreSQL for persistent user context
- Buffer windows for task-specific context
- Automatic cleanup of old conversations

Cost Management

Monthly Cost Breakdown (Heavy Usage):
- ElevenLabs Voice: $50-100
- OpenAI API calls: $100-200
- Google API usage: $20-50
- N8N hosting: $20-50
- PostgreSQL hosting: $20-30
Total: $210-430/month

ROI Calculation:
- Executive assistant salary: $5,000+/month
- JARVIS system cost: $430/month
- Savings: $4,570+/month (91% reduction)

Security & Privacy

Security Measures:
- OAuth 2.0 for all Google integrations
- Encrypted API key storage
- Session-based authentication
- No data logging beyond conversation history
- GDPR-compliant data handling

Business Applications & Market Positioning

Executive Assistant Replacement

Traditional Executive Assistant:

$60,000+ annual salary

Limited to business hours

Single-tasking capability

Requires management and training

Human error potential

JARVIS System:

$5,000 annual operating cost

24/7 availability

Multi-tasking across 8 domains

Self-improving through AI updates

Consistent performance

Service Business Opportunities

Client Offering Models:
1. Custom JARVIS Development: $15,000-25,000
2. JARVIS-as-a-Service: $500-1000/month per client
3. White-label licensing: $2,000-5,000/month
4. Training & consultation: $200-500/hour

Competitive Advantages

Voice-first interface vs text-based competitors

Multi-agent architecture vs single-model systems

Persistent memory vs stateless interactions

Custom tool integration vs limited API access

Professional UI vs developer-focused interfaces

Advanced Extensions & Customization

Industry-Specific Adaptations

Legal Practice Integration

Additional Agents:
- Case Management Agent → Client intake and tracking
- Document Review Agent → Contract analysis
- Billing Agent → Time tracking and invoicing
- Research Agent → Legal precedent search

Healthcare Practice

Specialized Tools:
- Patient Scheduling Agent
- Medical Records Agent  
- Insurance Verification Agent
- Prescription Management Agent

Real Estate Business

Custom Integrations:
- MLS Property Search Agent
- Client Communication Agent
- Document Management Agent
- Market Analysis Agent

Advanced Features Roadmap

Phase 2 Enhancements:
- Multi-language support
- Video call integration
- Mobile app companion
- IoT device control
- Advanced analytics dashboard

Phase 3 Capabilities:
- Predictive task automation
- Learning user routines
- Proactive suggestions
- Integration with CRM systems
- Team collaboration features

Implementation Roadmap

Week 1: Foundation Setup

Days 1-2: Infrastructure

Set up N8N environment (cloud or self-hosted)

Configure PostgreSQL database

Create ElevenLabs agent account

Days 3-5: Core Agents

Build master orchestrator agent

Implement email and calendar agents

Test basic multi-agent communication

Days 6-7: Frontend Integration

Create Lovable interface

Integrate ElevenLabs voice system

Test end-to-end voice interaction

Week 2: Agent Specialization

Days 1-3: Productivity Agents

Finance tracker integration

Contacts management system

Weather and news services

Days 4-5: Advanced Agents

Travel booking system

Research and analysis tools

Content creation pipeline

Days 6-7: Integration Testing

Multi-agent workflow testing

Error handling implementation

Performance optimization

Week 3: Production Readiness

Days 1-3: Polish & Optimization

UI/UX refinements

Response time optimization

Memory system tuning

Days 4-5: Security & Deployment

Security audit and hardening

Production deployment

Monitoring and alerting setup

Days 6-7: User Testing

Beta testing with real scenarios

Feedback collection and iteration

Documentation creation

Troubleshooting & Common Issues

Voice Integration Challenges

Problem: ElevenLabs connection timeouts
Solution: Implement retry logic and fallback responses

Problem: Poor voice quality or recognition
Solution: Optimize audio settings and use noise cancellation

Problem: Delayed responses feeling unnatural
Solution: Implement conversational filler and status updates

Multi-Agent Coordination Issues

Problem: Agents conflicting or duplicating work
Solution: Clear responsibility boundaries and orchestrator logic

Problem: Context loss between agents
Solution: Proper session management and data passing

Problem: Error cascading across agents
Solution: Circuit breaker patterns and graceful degradation

Performance & Scalability

Problem: High API costs with usage growth
Solution: Model optimization and request batching

Problem: Memory system performance degradation
Solution: Regular cleanup and indexing optimization

Problem: Concurrent user handling
Solution: Load balancing and session isolation

Assignment: Build Your JARVIS

Phase 1: Core Implementation (Week 1)

Foundation: Set up complete infrastructure stack

Basic Agents: Implement 3 core agents (email, calendar, finance)

Voice Integration: Create working ElevenLabs voice interface

Demo: Record 5-minute demonstration of capabilities

Phase 2: Specialization (Week 2)

Additional Agents: Add research, travel, and content agents

UI Polish: Create production-quality frontend

Advanced Features: Implement persistent memory and context

Testing: Perform comprehensive multi-agent testing

Phase 3: Production (Week 3)

Optimization: Achieve sub-3-second response times

Security: Implement production security measures

Documentation: Create user guide and technical docs

Business Case: Calculate ROI and present to stakeholders

Success Metrics

Technical: All 8 agents functioning reliably

Performance: Average response time under 3 seconds

User Experience: Natural conversation flow maintained

Business Value: Clear ROI demonstration vs human assistant

Key Takeaways

Technical Mastery: ✅ Multi-agent orchestration with sophisticated tool coordination✅ Voice-first interface design creating premium user experiences✅ Persistent memory systems maintaining context across sessions✅ Production-ready architecture capable of replacing human assistants

Business Transformation: ✅ $50,000+ annual savings per executive assistant replacement✅ 24/7 availability with consistent high-quality performance✅ Scalable service offering with recurring revenue potential✅ Competitive differentiation through advanced AI capabilities

Strategic Positioning: ✅ Industry leadership in voice-enabled AI automation✅ Premium pricing justification through sophisticated capabilities✅ Service business foundation with $15,000+ project values✅ Future-proof skillset in conversational AI and agent orchestration

This JARVIS implementation represents the cutting edge of AI automation - combining multiple advanced technologies into a cohesive system that rivals commercial AI assistants while remaining fully customizable and controllable.

The Future of AI Automation

This JARVIS build demonstrates where AI automation is heading: away from simple chatbots and toward sophisticated, multi-agent systems that can handle complex real-world tasks. By mastering these concepts, you position yourself at the forefront of an industry transformation.

The clients who experience this level of automation sophistication will never accept basic chatbot solutions again. You''re not just building tools - you''re creating the new standard for what AI assistance should be.', 4),
  ('3d4666fd-d5cb-472d-9913-566e0fb6336d', 'a24ea901-64ab-42e9-b1ed-b45851de3719', 'Set up Whatsapp Using Evolution API', 'This tutorial will walk you through setting up Evolution API v2 locally with Docker and connecting it to n8n running on DigitalOcean for WhatsApp automation.

🎯 What You''ll Build

Evolution API v2 running locally with PostgreSQL and Redis

Public access via ngrok tunnel

n8n integration for WhatsApp automation workflows

Complete database persistence for messages and contacts

📋 Prerequisites

Docker Desktop installed on your machine

n8n running on DigitalOcean (or any cloud provider)

Basic familiarity with terminal/command line

🚀 Step 1: Project Setup

Create Project Directory

mkdir evolution-api
cd evolution-api

Create Docker Compose File

Create a file named docker-compose.yml with this content:

version: ''3.9''

services:
  # PostgreSQL Database
  postgres:
    image: postgres:15-alpine
    container_name: evolution_postgres
    restart: always
    environment:
      POSTGRES_DB: evolution
      POSTGRES_USER: evolution
      POSTGRES_PASSWORD: evolution_password_123
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    networks:
      - evolution_network

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: evolution_redis
    restart: always
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    ports:
      - "6379:6379"
    networks:
      - evolution_network

  # Evolution API
  evolution-api:
    image: atendai/evolution-api:v2.1.1
    container_name: evolution_api
    restart: always
    ports:
      - "8080:8080"
    depends_on:
      - postgres
      - redis
    env_file:
      - .env
    volumes:
      - evolution_instances:/evolution/instances
    networks:
      - evolution_network

volumes:
  postgres_data:
  redis_data:
  evolution_instances:

networks:
  evolution_network:
    driver: bridge

Create Environment File

Create a .env file with this configuration:

# Authentication
AUTHENTICATION_API_KEY=CREATE-YOUR-OWN-KEY

# Server Configuration
SERVER_URL=http://localhost:8080
DEL_INSTANCE=false

# Database Configuration (PostgreSQL)
DATABASE_ENABLED=true
DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_URI=postgresql://evolution:evolution_password_123@postgres:5432/evolution
DATABASE_SAVE_DATA_INSTANCE=true
DATABASE_SAVE_DATA_NEW_MESSAGE=true
DATABASE_SAVE_MESSAGE_UPDATE=true
DATABASE_SAVE_DATA_CONTACTS=true
DATABASE_SAVE_DATA_CHATS=true
DATABASE_SAVE_DATA_LABELS=true
DATABASE_SAVE_DATA_HISTORIC=true
DATABASE_CONNECTION_CLIENT_NAME=evolution_v2

# Redis Cache Configuration
CACHE_REDIS_ENABLED=true
CACHE_REDIS_URI=redis://redis:6379/1
CACHE_REDIS_PREFIX_KEY=evolution_v2
CACHE_REDIS_SAVE_INSTANCES=false
CACHE_LOCAL_ENABLED=false

# RabbitMQ (Disabled for this setup)
RABBITMQ_ENABLED=false

# S3 Storage (Disabled for this setup)
S3_ENABLED=false

# WhatsApp Configuration
CONFIG_SESSION_PHONE_VERSION=2.3000.1028551930

# Cleanup Settings
CLEAN_STORE_CLEANING_INTERVAL=7200
CLEAN_STORE_MESSAGES=true
CLEAN_STORE_MESSAGE_UP_TO=false
CLEAN_STORE_CONTACTS=true
CLEAN_STORE_CHATS=true

⚠️ Important: The CONFIG_SESSION_PHONE_VERSION is crucial for QR code generation. Without it, WhatsApp QR codes may not work properly.
You can find the current WhatsApp Web client version by: 
Opening WhatsApp Web in your browser (web.whatsapp.com) 
Opening browser developer tools (F12) 
Going to the Console tab 
Running: Debug.VERSION 
This will show you the current version string that WhatsApp Web is using and replace that version in the .ENV file

🐳 Step 2: Start the Services

Launch Docker Stack

docker compose up -d

This command will:

Download the required Docker images

Create PostgreSQL database

Start Redis cache

Launch Evolution API v2

Verify Services Are Running

docker ps

You should see three containers running:

evolution_api

evolution_postgres

evolution_redis

Check Logs (Troubleshooting)

# Check all services
docker compose logs

# Check specific service
docker logs evolution_api

Test Local Access

Open your browser and visit: http://localhost:8080

You should see the Evolution API interface.

🌐 Step 3: Set Up Public Access with ngrok

Install ngrok

Visit ngrok.com

Sign up for free account

Download appropriate version

Follow installation instructions

Configure ngrok

# Add your auth token (get this from ngrok dashboard)
ngrok config add-authtoken YOUR_AUTH_TOKEN_HERE

Start ngrok Tunnel

ngrok http 8080

You''ll see output like:

Forwarding    https://abc123.ngrok-free.dev -> http://localhost:8080

📱 Step 4: Test WhatsApp Integration

Create WhatsApp Instance

Go to 

https://your-ngrok-url.ngrok-free.dev/manager
Create a new instance, and scan the QR code to connect your whatsapp number.

Scan QR Code

Open WhatsApp on your phone

Go to Settings > Linked Devices

Tap "Link a Device"

Scan the QR code from the API response

🔧 Step 5: Configure n8n Integration

In Your n8n Workflows

Use these settings for HTTP Request nodes:

Base URL: https://your-ngrok-url.ngrok-free.dev Authentication: Custom Header Header Name: apikey Header Value: YOUR-API-KEY

Common API Endpoints

https://www.postman.com/agenciadgcode/evolution-api/collection/gqr041s/evolution-api-v2-0

OR

Install Community node:

n8n-nodes-evolution-api
🔧 Step 6: Production Considerations

Security Best Practices

Generate Your Own API Key:
openssl rand -hex 32

Use Environment Variables in n8n for the API key

IP Whitelisting: Configure ngrok or use a VPN for added security

Reliability Improvements

Keep Services Running:
# To start services automatically on boot
docker compose up -d --restart unless-stopped

Monitor Logs:
docker logs -f evolution_api

Database Backups:
# Backup PostgreSQL data
docker exec evolution_postgres pg_dump -U evolution evolution > backup.sql

🛠️ Troubleshooting

Container Restart Loops

# Check logs for errors
docker logs evolution_api

# Common fix: Ensure .env file exists and has correct format

QR Code Not Generating

Verify CONFIG_SESSION_PHONE_VERSION=2.3000.1023204200 is in .env

Restart services: docker compose restart

Database Connection Errors

Ensure PostgreSQL container is running: docker ps

Check database URI format in .env

ngrok Connection Issues

Verify Evolution API is running locally first

Check firewall/antivirus blocking port 8080

🎉 Success!

You now have:

✅ Evolution API v2 running locally with full database persistence

✅ Public access via ngrok for n8n integration

✅ WhatsApp Business API functionality

✅ Scalable architecture with PostgreSQL and Redis

📚 Next Steps

Explore the API: Check out the Evolution API documentation

Build n8n Workflows: Create automated WhatsApp responses, notifications, and more

Scale Up: Consider moving to a cloud server for production use

Add Integrations: Connect with Chatwoot, Typebot, or other platforms

🆘 Getting Help

If you encounter issues:

Check the troubleshooting section above

Review Docker logs: docker logs evolution_api

Verify all configuration files match the tutorial exactly

Ask questions in our Skool community!

Tutorial tested with Evolution API v2.1.1, Docker Desktop, and macOS. Results may vary slightly on other platforms.', 5),
  ('4ba50a8a-a254-47a8-adf0-3f177358c440', 'a24ea901-64ab-42e9-b1ed-b45851de3719', 'Slack and n8n Setup', 'Lesson Overview

Learn why your automation demo platform choice directly impacts client conversion rates, and master the technical setup for building Slack-based demos that resonate with decision-makers. This lesson covers the psychology of demo credibility, complete Slack API configuration, and the strategic positioning that separates hobbyists from professionals.

Time to Complete: 45 minutes 

Difficulty: Intermediate 

Tools Required: n8n, Slack workspace, Slack API access 

Business Impact: Transform demo credibility from "tutorial project" to "production-ready solution"

The Demo Credibility Problem

Amateur Demo Signals

"Let me show you how it works. Just send a message to this Telegram bot."

Prospect''s internal reaction:
"I don''t have Telegram installed" (friction immediately)

"Why would I use a consumer messaging app for business processes?" (misalignment)

"This person has probably never built anything for an actual company" (credibility destroyed)

Result: Demo fails before automation even runs

Professional Demo Reality

"Let me show you this in your Slack workspace."

Prospect''s internal reaction:
"Oh, this integrates with our existing tools" (immediate relevance)

"This looks like something we''d actually use" (adoption confidence)

"This person understands enterprise workflows" (credibility established)

Result: Demo becomes visualization of their future workflow

The Transformation: From "interesting tutorial" to "shut up and take my money" by simply changing the trigger platform.

Why Telegram is a Credibility Killer

The Tutorial Trap

Why Telegram dominates YouTube tutorials:

No OAuth configuration required

No app creation process

Just grab bot token and go

Setup time: 2 minutes

The hidden cost:

You: "Here''s my automation demo"
Prospect: *sees Telegram*
Prospect''s brain: "This is a YouTube tutorial recreated"
Credibility: -50 points

The Business Reality Check

Slack''s enterprise presence:

200 million work computers have Slack installed

Default communication tool for modern companies

Already integrated into daily workflows

IT-approved, security-vetted, budget-allocated

Telegram''s enterprise presence:

Consumer messaging app

Security concerns (why are we using personal chat for business?)

Not in IT-approved tools list

Zero existing integrations with business systems

The Math:

Telegram demo conversion rate: ~5%
Slack demo conversion rate: ~35%
Same automation, 7x better results

The Psychology of Demo Platforms

What Prospects Actually Think

Telegram Demo:

Spoken: "Interesting, let me think about it"
Unspoken: "This feels like a hobby project, not a business solution"

Slack Demo:

Spoken: "Can you show me how this would work with our sales channel?"
Unspoken: "I can already see this deployed in our workspace"

The Professionalism Signal

Your demo platform broadcasts:

Telegram: "I followed YouTube tutorials"

Slack: "I''ve deployed this in production environments"

Webhook: "I understand enterprise integrations"

SMS: "I''ve never worked with businesses"

Critical Insight: Prospects don''t consciously analyze this. It''s gut-level pattern matching. "Does this feel like something I''d pay for?"

Slack Setup: The Complete Technical Guide

Phase 1: Slack App Creation & API Access Token

Step 1: Access Slack API Dashboard

1. Navigate to: api.slack.com/apps
2. Click "Create New App"
3. Select "From Scratch"
4. App Name: "YouTube Tutorial" (or your agency name)
5. Select your workspace
6. Click "Create App"

Why "From Scratch": App manifests are for advanced users. Starting from scratch gives you complete control and understanding of permissions.

Step 2: Configure OAuth Scopes

Navigation: Features → OAuth & Permissions → Scopes section

Add these Bot Token Scopes:
- channels:history (read message history)
- channels:join (auto-join channels when mentioned)
- channels:read (see channel list)
- chat:write (send messages)
- groups:history (read private channel history)
- groups:read (see private channels)
- users:read (get user information)

What Each Scope Does:

Scope Business Purpose Demo Impact channels:history Read past messages in channels AI can reference conversation context channels:join Auto-join when @mentioned No manual adding to channels channels:read List available channels Dynamic channel selection chat:write Send responses The core interaction groups:history Private channel access Works in closed channels groups:read See private channels Enterprise security scenarios users:read Get user names/emails Personalized responses

Common Mistake: Forgetting channels:join means bot must be manually added to every channel. Kills demo flow.

Step 3: Install App to Workspace

1. Scroll up in OAuth & Permissions page
2. Click green "Install to Workspace" button
3. Review permissions → Click "Allow"
4. COPY the "Bot User OAuth Token" (starts with xoxb-)

Critical: This token is shown only once. Save it immediately.

Phase 2: n8n Trigger Configuration

Step 4: Create Slack Credential in n8n

n8n Canvas:
1. Click "Add first step"
2. Search "Slack Trigger"
3. Select "On new message posted to channel"
4. Click "Create New Credential"
5. Authentication: "Access Token"
6. Paste Bot User OAuth Token
7. Credential Name: "Slack Account Trigger"
8. Click "Save"

Step 5: Select Channel to Monitor

In Slack Trigger node:
1. Channel: Select "General" (or your demo channel)
2. Click "Execute Node" (starts listening)

Demo Strategy: Use a dedicated #demo channel, not #general. Shows organizational sophistication.

Phase 3: Event Subscriptions (Critical Step)

Step 6: Enable Slack Event Subscriptions

Back in Slack API Dashboard:
1. Navigate to: Features → Event Subscriptions
2. Toggle "Enable Events" to ON
3. Request URL field appears

This is where most people get stuck. Here''s why it matters:

Without Event Subscriptions: n8n sits there listening but Slack never sends data. Workflow never fires. Demo fails.

With Event Subscriptions: Slack pushes real-time events to n8n. Instant responses. Demo impresses.

Step 7: Configure Webhook URL

In n8n Slack Trigger node:
1. Look for "Webhook URLs" section
2. For testing: Copy "Test URL"
3. For production: Copy "Production URL"
4. Click "Execute Node" (must be listening)

Back in Slack API Dashboard (Event Subscriptions):
1. Paste Test URL into "Request URL" field
2. Click away from field (Slack auto-validates)
3. Wait for green "Verified" checkmark

Common Error:

Error: "Your URL didn''t respond with the challenge parameter"
Solution: Ensure n8n node is actively executing (listening)

Step 8: Subscribe to Bot Events

Still in Event Subscriptions page:
1. Scroll to "Subscribe to bot events"
2. Click "Add Bot User Event"
3. Add: app_mention (bot triggered when @mentioned)
4. Add: message.channels (bot sees all channel messages)
5. Click "Save Changes"
6. Yellow banner appears: "You must reinstall your app"
7. Click "reinstall your app" link
8. Click "Allow" in permission dialog

Event Selection Strategy:

Event When to Use Demo Scenario app_mention Only respond when @mentioned Professional: bot doesn''t spam, waits for explicit trigger message.channels Respond to every message Monitoring: bot analyzes all conversations (show AI insights) Both Maximum flexibility Switch between modes during demo

Pro Tip: Start with app_mention only. Less noise, more control, demonstrates intentional design.

Phase 4: Testing the Trigger

Step 9: Add Bot to Channel & Test

In Slack workspace:
1. Go to your demo channel
2. Type: /invite @YouTube Tutorial (your bot name)
3. Press Enter
4. Bot joins channel

Test message:
1. In n8n, ensure Slack Trigger is executing
2. Type in Slack: "@YouTube Tutorial hello"
3. Check n8n execution log
4. Should see message data appear

Expected Output:

{
  "event": {
    "type": "app_mention",
    "user": "U1234567890",
    "text": "<@U0987654321> hello",
    "channel": "C1234567890",
    "ts": "1234567890.123456"
  }
}

If Nothing Happens:

Check: Is n8n node executing (listening)?

Check: Did you reinstall app after adding events?

Check: Is bot actually in the channel? (look for join message)

Check: Did you @mention the bot name correctly?

Phase 5: OAuth Setup for Sending Replies

Why We Need OAuth Now:

Access Token (Phase 1): Receives messages

OAuth Token: Sends messages

Different permission contexts, both required

Step 10: Add Slack Send Node & OAuth Credential

In n8n canvas:
1. Add node: Slack → "Send a message"
2. Click "Create New Credential"
3. Authentication: Select "OAuth2"
4. Copy the "OAuth Redirect URL" shown

Keep n8n tab open, switch to Slack API Dashboard.

Step 11: Configure OAuth Redirect URL

Slack API Dashboard:
1. Navigate to: Features → OAuth & Permissions
2. Scroll to "Redirect URLs" section
3. Click "Add New Redirect URL"
4. Paste the redirect URL from n8n
5. Click "Add"
6. Click "Save URLs"

What This Does: After user authorizes, Slack redirects back to n8n with auth token. Standard OAuth flow.

Step 12: Get Client ID & Client Secret

Slack API Dashboard:
1. Navigate to: Settings → Basic Information
2. Scroll to "App Credentials" section
3. Copy "Client ID"
4. Click "Show" next to "Client Secret"
5. Copy "Client Secret"

Security Note: Client Secret is sensitive. Never commit to Git, never share publicly.

Step 13: Complete OAuth Connection in n8n

Back in n8n OAuth2 credential dialog:
1. Paste Client ID
2. Paste Client Secret
3. Click "Connect my Account"
4. Popup window opens → Click "Allow"
5. Success message: "Connection Successful"
6. Click "Save" in n8n

Common Issue: Popup blocked? Check browser popup settings, whitelist your n8n domain.

Phase 6: Building the Complete Demo Workflow

Step 14: Connect Trigger → AI Agent → Reply

Workflow Structure:
[Slack Trigger] → [AI Agent] → [Slack Send Message]

Configuration:
1. Slack Trigger:
   - Event: "When app is mentioned"
   - Channel: Your demo channel

2. AI Agent:
   - Model: GPT-4o (for demos, always use best model)
   - Prompt Source: "Define Below"
   - Prompt: {{ $json.event.text }} (the message text)
   - System Prompt: "You are a helpful business automation assistant"

3. Slack Send Message:
   - Authentication: OAuth2 credential (from Phase 5)
   - Send Message To: "Channel"
   - Channel: "By ID"
   - Channel ID: {{ $(''Slack Trigger'').item.json.event.channel }}
   - Message Text: {{ $json.output }} (AI agent response)

Pin the Trigger Data: During development, pin test execution so you don''t have to keep sending Slack messages.

Step 15: Test Complete Flow

In Slack:
1. Type: "@YouTube Tutorial What can you help me with?"
2. Watch n8n execution panel
3. See AI agent process request
4. See response appear in Slack thread

Expected behavior:
- Bot responds in thread (not new message)
- Response appears within 3-5 seconds
- Bot name + icon visible

Demo Polish:

Advanced Settings in Slack Send Message node:
- Thread TS: {{ $(''Slack Trigger'').item.json.event.ts }}
  (Replies in thread, not as new message)
- Username: Your company name
- Icon URL: Your company logo
  (Brand consistency during demo)

The Demo Script That Converts

Pre-Demo Setup (5 minutes before call)

1. Create private channel: #demo-[company-name]
2. Invite decision-makers to channel
3. Add your bot to channel
4. Test one message to verify it''s working
5. Have 2-3 pre-planned scenarios ready

Demo Script: The Natural Flow

Opening (Don''t Start with Tech):

You: "Before I show you the automation, can I ask—
      what messaging platform does your team use daily?"
Them: "We use Slack"
You: "Perfect. I built this demo to run directly in Slack 
      so you can see exactly how it would work in your environment."

Why This Works: You''re not asking them to adapt to your demo platform. You adapted to them preemptively.

The Big Reveal:

You: "I''ve created a private demo channel here. Can everyone 
      see it in their Slack sidebar?"
[They confirm]
You: "Great. Now watch what happens when I @mention our bot..."
[Type in channel: "@AutomationBot Can you summarize our last 5 support tickets?"]
[Bot responds in 3 seconds with summary]
You: [Stay silent. Let them react.]

Why Silence Works: Let the automation speak for itself. Their imagination fills in the possibilities.

The Pivot to Their Use Case:

Them: "Could this work with our CRM data?"
You: "Absolutely. What if you could @mention the bot and ask 
      ''Show me all leads that haven''t been contacted in 2 weeks''—
      and it pulls that instantly?"
[If you have CRM integration built, demo it live]
[If not: "That''s exactly what we''d build in phase one"]

The Close:

You: "The bot we''re chatting with right now? It''s already 
      connected to your Slack workspace. If you wanted to 
      keep using it after this call, you could. But obviously 
      we''d customize it for your specific workflows."

Why This Closes Deals: They''re not buying potential. They''re buying something they just used.

Business Applications & ROI

Agency Demo Conversion Math

Telegram Demo:

10 demos → 0-1 clients

Conversion rate: 5-10%

"Let me think about it" (translation: no)

Slack Demo:

10 demos → 3-4 clients

Conversion rate: 30-40%

"When can we start?" (translation: sold)

Revenue Impact:

Project value: $5,000 average
Telegram approach: $5,000/10 demos = $500 per demo
Slack approach: $17,500/10 demos = $1,750 per demo

3.5x revenue increase per demo hour

The Workspace Infiltration Strategy

Secret weapon: Once bot is in their workspace during demo, removal requires effort.

Psychology:

Post-demo:
- Bot is already installed
- Team already interacted with it
- "Remove this useful thing?" feels like loss
- Easier to say "Let''s expand it" than "Let''s delete it"

Conversion Timeline:

Day 0: Demo call, bot installed
Day 1-3: Team plays with bot organically
Day 4: Decision-maker gets feedback: "This is actually useful"
Day 5-7: "Can we talk about building out the full version?"

This doesn''t work with Telegram. Consumer app doesn''t stay installed on work computers.

The Enterprise Sales Accelerator

Traditional automation sale:

Week 1: Discovery call
Week 2: Proposal sent
Week 3: Technical review (IT approval needed)
Week 4-6: Evaluation period
Week 7: Decision

Slack demo sale:

Week 1: Discovery call WITH live demo IN THEIR SLACK
Week 2: "We want this, when can you start?"

Why: You collapsed technical review into the demo. They already saw it working in their security-approved environment.

Advanced Demo Techniques

Multi-Channel Scenario

Setup:

Create 3 channels during demo:
- #support-tickets (customer service scenario)
- #sales-leads (sales automation scenario)  
- #operations (internal process scenario)

Show bot responding in each with different context

Demo Script:

"Notice the bot understands context based on which channel 
it''s in. In #support-tickets, it pulls customer data. 
In #sales-leads, it checks CRM. Same bot, different workflows."

Impact: They see enterprise-scale system, not single-use tool.

The Handoff Demo

Scenario: Show automation handing off to human when needed

Workflow:
1. Customer question in #support
2. Bot attempts answer
3. If confidence < 80%, bot says: 
   "@sarah This question needs human expertise"
4. Human steps in, bot watches
5. Bot learns from human response (if RAG configured)

Why This Closes Enterprise Deals: Addresses #1 objection: "What if AI gets it wrong?"

The Permission Demo

For security-conscious prospects:

Show in real-time:
1. Bot only responds in channels it''s invited to
2. Bot respects Slack''s permission model
3. Bot can be removed by any admin instantly
4. No data leaves their Slack workspace (if local LLM)

Script:

"Your Slack admin has complete control. The bot follows 
the same permission rules as any team member."

Common Setup Issues & Solutions

Issue 1: "Challenge Parameter" Error

Error Message:

"Your URL didn''t respond with the challenge parameter"

Root Cause: n8n webhook not actively listening when Slack tried to verify

Solution:

In n8n, click "Execute Node" on Slack Trigger

Ensure it shows "Waiting for webhook call"

THEN paste URL in Slack Event Subscriptions

Click away from URL field to trigger validation

Prevention: Always have n8n listening before configuring Slack URL.

Issue 2: Bot Not Responding to Messages

Symptoms: Messages sent in Slack, nothing happens in n8n

Diagnostic Checklist:

✓ Is bot added to channel? (look for join message)
✓ Did you reinstall app after adding event subscriptions?
✓ Is "message.channels" or "app_mention" subscribed?
✓ Is n8n workflow activated (not just executed)?
✓ Are you @mentioning bot if using "app_mention" only?

Most Common Cause: Forgetting to reinstall app after changing event subscriptions. Yellow banner tells you this—don''t ignore it.

Issue 3: OAuth Redirect Fails

Error: "redirect_uri_mismatch"

Root Cause: Redirect URL in Slack doesn''t exactly match n8n''s URL

Solution:

Copy redirect URL from n8n OAuth credential (don''t type manually)

Paste EXACTLY into Slack (no trailing slashes, no typos)

Click "Save URLs" in Slack

Try OAuth connection again in n8n

Edge Case: Self-hosted n8n? Your redirect URL changes if domain changes. Update in Slack when moving environments.

Issue 4: Bot Replies to Own Messages (Infinite Loop)

Symptoms: Bot sends message, then replies to itself, then replies again...

Root Cause: Event subscription includes bot''s own messages

Solution:

// Add IF node after Slack Trigger
Condition: {{ $json.event.bot_id }} does not exist
// This filters out messages sent by bots (including your own)

Prevention: Use "app_mention" event instead of "message.channels" for conversational agents.

Troubleshooting & Common Issues

(Expanded from previous section with production scenarios)

Issue 5: Rate Limiting During Demo

Symptoms: Bot works for first 2-3 messages, then stops responding

Root Cause: Slack API rate limits (Tier 1: ~1 message per second)

Solution for Demos:

Add Rate Limit node between AI Agent and Slack Send:
- Maximum Requests: 1
- Interval: 1000ms (1 second)

Better Solution for Production:

Use Slack''s socket mode (real-time) instead of webhooks
- No rate limits on receiving messages
- Faster response times
- More reliable for high-volume channels

Issue 6: Long AI Response Times Kill Demo Flow

Problem: AI takes 10-15 seconds, awkward silence on call

Solution:

Add intermediate response:

[Slack Trigger]
    ↓
[Slack Send: "Thinking... 🤔"]
    ↓
[AI Agent]
    ↓
[Slack Edit Message: Replace thinking with answer]

Implementation:

Use Slack''s chat.update API instead of chat.postMessage
- Save message timestamp from "Thinking" message
- Pass to AI Agent output
- Edit same message with final answer
- Appears instant to user

Assignment: Build Your First Slack Demo

Phase 1: Technical Setup (30 minutes)

Create Slack app with all 7 required scopes

Install to your workspace

Configure n8n trigger with Access Token

Set up Event Subscriptions with webhook URL

Test: Send message, verify n8n receives it

Success Metric: Message sent in Slack appears in n8n execution log within 2 seconds

Phase 2: OAuth Configuration (15 minutes)

Add Slack Send Message node

Configure OAuth2 credential

Add redirect URL to Slack app

Complete OAuth connection

Test: Send reply from n8n to Slack channel

Success Metric: Bot sends message that appears in Slack channel

Phase 3: Build Demo Agent (30 minutes)

Add AI Agent between trigger and reply

Configure with simple system prompt

Test 3 different questions

Verify responses appear in threads (not new messages)

Polish: Add company name and logo to bot

Success Metric: Natural conversation flow in Slack with AI responses

Phase 4: Demo Script Preparation (15 minutes)

Create #demo-practice channel

Invite a colleague or second account

Write 3 demo scenarios relevant to your target clients

Practice delivery: @mention → response → explaining what happened

Time your demo (should be <5 minutes total)

Success Metric: Can confidently demo without referencing notes

Resources & Templates

Slack App Configuration Checklist

□ App created in api.slack.com
□ OAuth scopes added (all 7 required)
□ App installed to workspace
□ Bot User OAuth Token copied
□ Event Subscriptions enabled
□ Webhook URL configured and verified
□ Bot events subscribed (app_mention + message.channels)
□ App reinstalled after event changes
□ OAuth redirect URL added
□ Client ID and Secret obtained
□ n8n credentials configured (both Access Token + OAuth2)
□ Test message successful
□ Reply message successful

Demo Environment Setup Guide

Pre-Demo Slack Workspace Setup - Channel structure and permissions

n8n Workflow Template - Complete Slack demo workflow

System Prompt Library - Industry-specific AI agent prompts

Demo Script Templates - Sales call positioning scripts

Troubleshooting Flowchart

Message not received in n8n?
    ├─→ Is n8n node executing? → Execute node
    ├─→ Is bot in channel? → /invite @bot
    ├─→ Event subscriptions configured? → Check Slack app
    └─→ App reinstalled after events? → Reinstall app

Bot not sending replies?
    ├─→ OAuth configured? → Complete OAuth setup
    ├─→ Redirect URL correct? → Copy exact URL from n8n
    └─→ Correct channel ID? → Use dynamic ID from trigger

Key Takeaways

Technical Mastery: 

✅ Complete Slack API configuration (Access Token + OAuth2) 

✅ Event subscription architecture and webhook validation 

✅ Threading, rate limiting, and production considerations 

✅ Debugging workflow with pin data and execution logs 

✅ Bot permission scopes and security best practices

Business Impact: 

✅ 7x higher conversion rate with Slack vs Telegram demos 

✅ Demo credibility signals production experience instantly 

✅ Workspace infiltration strategy keeps bot top-of-mind post-demo 

✅ Enterprise sales accelerator collapses weeks into single call 

✅ $1,750 per demo vs $500 with consumer platforms

Strategic Positioning: 

✅ Platform choice broadcasts professionalism before words spoken 

✅ "Works in your tools" beats "works in general" every time 

✅ Demo environment should match deployment environment 

✅ Remove all friction between demo and purchase decision 

✅ Let automation speak for itself—silence after @mention is powerful

The lesson: Your demo platform is your credibility signal. Telegram says "I followed tutorials." Slack says "I''ve built this in production." Same automation, different psychology. Master the technical setup, but remember—you''re not teaching them how to use Slack. You''re teaching them how to see their future state where AI agents are just another team member they @mention when they need help. That''s when they stop asking "how does it work?" and start asking "when can we start?"', 6),
  ('b0dabffe-5e22-4760-9f5b-5a592390c914', 'a24ea901-64ab-42e9-b1ed-b45851de3719', 'AI-Powered Job Application System', 'AI-Powered Job Application System: From 20 Hours to 15 Minutes Weekly

Lesson Overview

Build a complete LinkedIn job application automation that eliminates manual job hunting. This system scrapes relevant positions, evaluates fit using AI, generates custom cover letters and resumes, and organizes everything in Airtable - transforming 20+ hours of weekly job searching into 15 minutes of review time.

Time to Complete: 90 minutesDifficulty: AdvancedTools Required: N8N, Apify, OpenAI, Airtable, HTML-to-PDF conversionWeekly Time Savings: 19+ hours of manual job hunting

The Job Search Problem

Traditional Job Hunting Reality

Manual Process (20+ hours/week):
- Scrolling through job boards: 8 hours
- Reading irrelevant job posts: 6 hours  
- Writing custom cover letters: 4 hours
- Tailoring resumes: 2 hours
- Application submission: 2 hours
TOTAL: 22 hours of grinding weekly

AI-Powered Solution

Automated Process (15 minutes/week):
- Job discovery & filtering: Automated
- Relevance evaluation: AI-powered
- Cover letter generation: AI-written
- Resume customization: AI-optimized
- Review & submission: 15 minutes
TOTAL: 95% time reduction with higher quality

The Secret: Most job seekers waste time on irrelevant positions. This system only surfaces high-fit opportunities with ready-to-submit materials.

System Architecture Overview

Intelligent Job Processing Pipeline

Stage 1: Job Discovery
├── LinkedIn scraping via Apify
├── Keyword and location filtering
├── Remote/hybrid preferences
└── Recent posting requirements

Stage 2: AI Evaluation
├── Skills-to-job matching analysis
├── Fit score calculation (0-100)
├── Complexity assessment
└── Upskilling requirement identification

Stage 3: Content Generation  
├── Custom cover letter creation
├── Resume professional summary optimization
├── ATS keyword optimization
└── Company-specific personalization

Stage 4: Application Preparation
├── HTML-to-PDF resume generation
├── Airtable organization system
├── Attachment management
└── Review workflow preparation

Phase 1: Job Discovery & Filtering

LinkedIn Scraping Setup

Apify Integration

Service: LinkedIn Job Scraper (No Cookies)
Cost: $5 per 1,000 jobs scraped
Actor ID: Use the verified LinkedIn job scraper
Update Frequency: Every 4 days (optimal for fresh results)

Search Configuration

{
  "sort": "recent",
  "keywords": "AI automation",
  "location": "United States", 
  "maxItems": 100
}

Customization Notes:

Keywords: Adapt to your industry ("Data Science", "Marketing", "Sales")

Location: Set to your target geography or "Remote"

MaxItems: Balance between coverage and cost

Multi-Layer Filtering System

Filter 1: Work Arrangement (N8N Filter Node)

{
  "conditions": [
    {
      "leftValue": "={{ $json.work_type }}",
      "rightValue": "Remote",
      "operator": "equals"
    },
    {
      "leftValue": "={{ $json.work_type }}",
      "rightValue": "Hybrid", 
      "operator": "equals"
    }
  ],
  "combinator": "or"
}

Filter 2: Title Relevance (N8N Filter Node)

{
  "conditions": [
    {
      "leftValue": "={{ $json.job_title }}",
      "rightValue": "=\\b(AI|Automation|ChatGPT|LLM|API)\\b",
      "operator": "regex"
    }
  ]
}

Why Double Filtering Matters:

LinkedIn''s search isn''t always precise

Eliminates 70-80% of irrelevant results upfront

Saves AI processing costs on obvious mismatches

Phase 2: AI-Powered Job Evaluation

The Skills Matching Engine

Master Prompt Framework (Actual Implementation)

You are an expert evaluator for AI, automation, and full-stack software development projects. 

Your job is to read a job description, extract the true requirements, and then evaluate our fit and complexity level without being biased by vague or overly promotional language.

**Our capabilities**:
- Strong AI integration skills (OpenAI, ElevenLabs, Replicate, etc.)
- Advanced no-code/low-code workflow design (Make.com, n8n, Zapier, Airtable, Google tools)
- RAG-enabled chatbot builds using Supabase
- Automation for content creation, lead generation, and API integrations
- Solid prompt engineering and workflow architecture (TDA framework: Trigger, Data, Action)
- Business partner is a full-stack developer proficient in modern web frameworks, custom APIs, and database design

**Bias-Resistance Process**:
1. Ignore fluff, hype words, or general statements like "innovative" or "cutting-edge" unless tied to specific requirements
2. Identify only concrete skills, deliverables, and outcomes mentioned
3. If requirement is ambiguous, interpret in most common, practical way
4. **Upskilling Reality Check**: If job requires significant learning in areas we have no foundation in, heavily penalize fit score

**Your tasks**:
1. **Fit Score (0–100)**: How closely the job aligns with our combined skills
2. **Complexity Rating (1–5)**:
   - 1 = Very simple, quick build, minimal customization
   - 2 = Low complexity, straightforward integrations  
   - 3 = Moderate complexity, some custom logic or integrations
   - 4 = High complexity, significant custom code and architecture
   - 5 = Very high complexity, cutting-edge or large-scale system
3. **Upskilling Requirements**: What major learning would be needed
4. **Reasoning**: Brief but clear explanation for all scores

**Output format (JSON)**:
{
  "fit_score": <number>,
  "complexity": <number>, 
  "upskilling_requirements": ["<major skill gap 1>", "<major skill gap 2>", ...],
  "reasoning": "<short text covering fit, complexity, freelancer viability, and upskilling penalties>",
  "extracted_requirements": ["<skill or deliverable 1>", "<skill or deliverable 2>", ...]
}

Job Description:
{{ $json.job_title }} at {{ $json.company }}

{{ $json.description }}

Advanced Scoring Logic

Fit Score Calculation:

90-100: Dream job, immediate apply

75-89: Strong match, likely success

60-74: Good potential with some gaps

40-59: Stretch opportunity, significant upskilling

Below 40: Poor fit, skip

Complexity Assessment:

Level 1: Entry/junior positions

Level 2: Mid-level individual contributor

Level 3: Senior IC or team lead

Level 4: Principal/staff or management

Level 5: Executive or highly specialized expert

Intelligent Filtering Thresholds

Customizable Decision Gates (N8N IF Node)

{
  "conditions": [
    {
      "leftValue": "={{ $json.choices[0].message.content.fit_score }}",
      "rightValue": 30,
      "operator": "gte"
    },
    {
      "leftValue": "={{ $json.choices[0].message.content.complexity }}",
      "rightValue": 5,
      "operator": "lt"
    }
  ],
  "combinator": "and"
}

Strategic Threshold Settings:

Conservative approach: fit_score ≥ 70, complexity < 3

Moderate approach: fit_score ≥ 50, complexity < 4

Aggressive approach: fit_score ≥ 30, complexity < 5 (as shown)

Strategic Considerations:

Tight job market: Lower fit score to 60-65

Career pivoting: Accept higher complexity for growth

Senior roles: Increase fit score to 80+ for selectivity

Contract work: Consider lower thresholds for variety

Phase 3: Dynamic Content Generation

Cover Letter Generation System

Cover Letter Generation System (Actual Implementation)

You are an expert recruitment consultant and you understand what HR managers and interviewers are looking for in job applications and cover letters. I will provide you with information about a prospective job and my qualification and experience. Use that to generate an engaging, succinct, and professional cover letter and a resume professional summary. Remember to use single quotes instead of double to not break the JSON.

Job Title: {{ $(''Loop Over Items'').item.json.job_title }}

Job Description: {{ $(''Loop Over Items'').item.json.description }}

Company LinkedIn: {{ $(''Loop Over Items'').item.json.company_url }}

My expertise and skills:
- Proficient with AI and prompt engineering
- Expert at building workflows and agentic AI using n8n and make.com
- Proficient with APIs
- Specialize in AI automation/agentic AI for content creation, data processing, and process optimization
- Fast learner
- Good communicator
- Have built multiple production grade workflows for previous clients

Current executive summary:
Expert AI Automation Consultant specializing in intelligent workflow architecture using the proven TDA framework (Trigger-Data-Action). With 10 years of digital marketing experience and deep expertise in AI platform integrations, I design and implement sophisticated automation solutions that drive measurable business results. Proven track record with OpenAI, ElevenLabs, Replicate APIs, and advanced RAG-enabled chatbot development using Supabase.

Output as JSON:
{
  "cover-letter": "xyz",
  "professional-summary": "yyy"
}

Dynamic Personalization Elements

// Company-specific research integration
const companyInsights = {
  recentNews: extractFromJobDescription(jobDescription),
  missionAlignment: identifyValues(companyDescription),
  industryTrends: getRelevantTrends(industry)
};

// Metric-driven achievements
const quantifiedResults = [
  "Increased automation efficiency by 40%",
  "Reduced manual processing time by 15 hours/week", 
  "Implemented systems saving $50K annually"
];

Resume Optimization Engine

Professional Summary Adaptation

You are optimizing a professional summary for ATS systems and HR managers.

ORIGINAL SUMMARY: {{current_professional_summary}}

JOB REQUIREMENTS: {{job_description}}

OPTIMIZATION GOALS:
1. Keyword Integration: Naturally include 5-7 key terms from job posting
2. Value Proposition: Lead with strongest relevant qualifications
3. Quantification: Include 2-3 specific metrics or achievements
4. Role Alignment: Mirror language and priorities from job description
5. ATS Compatibility: Use standard terminology and format

OUTPUT: 3-4 sentence professional summary optimized for this specific role

HTML Resume Template System

<!DOCTYPE html>
<html>
<head>
    <style>
        /* Professional ATS-friendly styling */
        body { font-family: Arial, sans-serif; }
        .section { margin-bottom: 20px; }
        .highlight { font-weight: bold; }
    </style>
</head>
<body>
    <!-- Static sections: Contact, Skills, Education -->
    
    <div class="section">
        <h2>Professional Summary</h2>
        <p>{{dynamic_professional_summary}}</p>
    </div>
    
    <!-- Static sections: Experience, Certifications -->
</body>
</html>

Template Advantages:

Consistency: Same format for all applications

ATS Optimization: Clean HTML structure

Customization: Only summary changes per job

Professional Appearance: Clean, scannable design

Phase 4: Application Management System

Airtable Organization Structure

Master Applications Table

Fields Configuration:
- Company (Text) - Organization name
- Job Title (Text) - Position title  
- Job URL (URL) - Direct application link
- LinkedIn URL (URL) - Company profile
- Posted Date (Date) - When job was listed
- Fit Score (Number) - AI-generated 0-100
- Complexity (Number) - AI-assessed 1-5
- Status (Single Select) - Applied, Reviewing, Interview, Rejected
- Cover Letter (Long Text) - Generated content
- Custom Resume (Attachment) - PDF file
- Notes (Long Text) - Additional observations
- Application Date (Date) - When you applied
- Follow-up Date (Date) - Reminder for outreach

Status Management Workflow

Pipeline Stages:
1. "New" - Just discovered, needs review
2. "Qualified" - Passed AI screening
3. "Ready" - Cover letter and resume generated  
4. "Applied" - Submitted application
5. "Interview" - In process
6. "Offer" - Received offer
7. "Rejected" - Not selected
8. "Withdrawn" - Removed from consideration

PDF Generation & Attachment

MediaFX Integration

// HTML to PDF Conversion
const pdfOptions = {
  format: ''A4'',
  margin: { top: ''20px'', bottom: ''20px'', left: ''20px'', right: ''20px'' },
  printBackground: true,
  quality: ''high''
};

Base64 File Handling

// Convert PDF to Base64 for Airtable storage
function extractFileData(binaryData) {
  return {
    contentType: ''application/pdf'',
    filename: ''resume-custom.pdf'',
    base64Data: binaryData.toString(''base64'')
  };
}

Airtable Attachment Upload

// HTTP Request to Airtable Attachments API
const attachmentAPI = {
  url: `https://api.airtable.com/v0/{baseId}/Applications/{recordId}/attachments`,
  method: ''POST'',
  headers: {
    ''Authorization'': ''Bearer {apiKey}'',
    ''Content-Type'': ''application/json''
  },
  body: {
    ''Customized Resume'': [{
      ''url'': ''data:application/pdf;base64,'' + base64Data,
      ''filename'': ''resume-custom.pdf''
    }]
  }
};

Phase 5: Advanced Optimization Strategies

Market-Responsive Filtering

Dynamic Threshold Adjustment

// Adjust standards based on market conditions
function calculateThresholds(marketCondition) {
  const baseThresholds = { fitScore: 75, complexity: 3 };
  
  switch(marketCondition) {
    case ''hot'': // Candidate''s market
      return { fitScore: 85, complexity: 2 };
    case ''competitive'': // Balanced market  
      return { fitScore: 70, complexity: 3 };
    case ''tough'': // Employer''s market
      return { fitScore: 60, complexity: 4 };
    default:
      return baseThresholds;
  }
}

Industry-Specific Customization

Tech Industry Example

{
  "keywords": ["AI", "ML", "Python", "AWS", "Kubernetes"],
  "fitScoreWeight": {
    "technicalSkills": 0.4,
    "experience": 0.3, 
    "cultureMatch": 0.2,
    "growth": 0.1
  },
  "complexityIndicators": ["Principal", "Staff", "Lead", "Architect"]
}

Marketing Industry Example

{
  "keywords": ["Growth", "Analytics", "Campaign", "ROI", "Attribution"],
  "fitScoreWeight": {
    "strategicThinking": 0.3,
    "analyticsSkills": 0.3,
    "creativity": 0.2,
    "results": 0.2
  },
  "complexityIndicators": ["Director", "VP", "Head of", "Chief"]
}

Performance Tracking & Optimization

Success Metrics Dashboard

// Track application performance
const metrics = {
  applicationsGenerated: count(),
  interviewRate: interviews / applications,
  avgFitScoreInterviewed: average(interviewedJobs.fitScore),
  optimalComplexity: mode(successfulJobs.complexity),
  topPerformingKeywords: analyze(successfulJobs.keywords)
};

Continuous Improvement Loop

Weekly Review: Analyze generated applications vs actual interest

Monthly Calibration: Adjust fit score thresholds based on results

Quarterly Audit: Update skills profile and prompt optimization

Annual Overhaul: Refine entire system based on career progression

Business Applications & Use Cases

Career Transition Scenarios

Industry Pivot Automation

Scenario: Marketing → Data Science transition
Adjustments:
- Lower fit score threshold (accept 60-70 range)
- Focus on transferable skills in prompts
- Emphasize learning agility in cover letters
- Target junior/mid-level complexity (1-2 range)

Senior Role Targeting

Scenario: IC → Management progression  
Adjustments:
- Increase fit score requirement (80+)
- Highlight leadership experience
- Focus on strategic impact metrics
- Accept higher complexity (4-5 range)

Freelance/Contract Focus

Scenario: Building consulting pipeline
Adjustments:
- Include contract/freelance job types
- Emphasize project-based achievements
- Shorter-term engagement language
- Broader geographic targeting

Specialized Professional Applications

Remote-First Professionals

Global location targeting

Timezone compatibility filtering

Remote work experience emphasis

Distributed team collaboration skills

Career Returners

Employment gap narrative preparation

Skills refresh identification

Confidence-building lower thresholds

Growth-oriented positioning

High-Demand Specialists

Premium position filtering

Selective application strategy

Negotiation-ready positioning

Multiple offer optimization

Cost-Benefit Analysis

Financial Investment

Monthly Operating Costs:
- Apify scraping: $20-40 (400-800 jobs)
- OpenAI API: $30-50 (evaluation + generation)
- N8N hosting: $20 (cloud) or $0 (self-hosted)
- Airtable: $10 (Pro plan)
Total Monthly: $80-120

Annual Investment: $960-1,440

Time ROI Calculation

Traditional Job Search (Monthly):
- Manual searching: 80 hours × $30/hour = $2,400
- Application prep: 32 hours × $30/hour = $960
- Administrative tasks: 16 hours × $30/hour = $480
Total Monthly Value: $3,840

Automated System (Monthly):
- Setup maintenance: 2 hours × $30/hour = $60
- Review and submission: 4 hours × $30/hour = $120
- System costs: $100
Total Monthly Cost: $280

Monthly Savings: $3,560 (93% reduction)
Annual ROI: $42,720 in time savings

Quality Improvements

Higher relevance: Only see jobs matching your criteria

Faster applications: Submit within hours of posting

Consistent quality: Every application optimized

Better tracking: Never lose track of opportunities

Reduced stress: Eliminate job search anxiety

Implementation Roadmap

Week 1: Foundation Setup

Day 1-2: Infrastructure

Set up N8N environment

Configure Apify account and LinkedIn scraper

Create Airtable base with proper schema

Day 3-4: Basic Pipeline

Build job discovery and filtering workflow

Test scraping with sample keywords

Verify data flow to Airtable

Day 5-7: AI Integration

Configure OpenAI API and prompts

Test job evaluation scoring

Calibrate filtering thresholds

Week 2: Content Generation

Day 1-3: Cover Letter System

Build cover letter generation prompts

Test with sample job descriptions

Refine for your industry and style

Day 4-5: Resume Optimization

Create HTML resume template

Implement professional summary adaptation

Test PDF generation and attachment

Day 6-7: Integration Testing

Run complete end-to-end workflow

Verify all components work together

Handle edge cases and errors

Week 3: Optimization & Production

Day 1-3: Fine-Tuning

Adjust AI prompts based on output quality

Optimize filtering thresholds

Improve error handling

Day 4-5: Monitoring Setup

Create performance tracking

Set up notification systems

Build review workflows

Day 6-7: Production Launch

Schedule automated runs

Monitor first production cycles

Make initial optimizations

Week 4: Analysis & Improvement

Day 1-7: Performance Review

Analyze generated applications

Track application-to-interview conversion

Refine system based on results

Troubleshooting & Common Issues

Technical Challenges

Scraping Rate Limits

Problem: Apify hitting rate limits or being blocked
Solutions:
- Reduce frequency (every 7 days vs 4 days)
- Use residential proxies option
- Implement rotating scraper services
- Add random delays between requests

AI Evaluation Inconsistency

Problem: Fit scores varying wildly for similar jobs
Solutions:
- Add few-shot examples to prompts
- Implement scoring rubrics with specific criteria
- Use temperature=0 for consistent outputs
- Create validation rules for score ranges

PDF Generation Failures

Problem: HTML to PDF conversion errors
Solutions:
- Validate HTML structure
- Use fallback PDF generation services
- Implement error handling with retries
- Test with various resume lengths

Business Considerations

Application Quality vs Quantity

Balance Strategy:

Focus on fit scores 75+ for quality

Allow 65-74 range during slow periods

Track conversion rates by score range

Adjust thresholds based on results

ATS Compatibility

Optimization Tactics:

Use standard section headers

Include relevant keywords naturally

Maintain clean formatting

Test with ATS checker tools

Legal and Ethical Compliance

Best Practices:

Respect platform terms of service

Don''t over-apply to same companies

Maintain truthfulness in applications

Follow data privacy regulations

Advanced Extensions & Integrations

CRM Integration

HubSpot/Pipedrive: Track application pipeline

Calendar Integration: Schedule follow-ups

Email Automation: Sequence-based outreach

Analytics Dashboards: Performance visualization

Social Proof Enhancement

GitHub Integration: Include relevant projects

LinkedIn Optimization: Profile keyword matching

Portfolio Updates: Dynamic work samples

Recommendation Requests: Automated outreach

Market Intelligence

Salary Research: Automated compensation analysis

Company Research: Financial and culture insights

Competitive Analysis: Similar role comparisons

Industry Trends: Market demand patterns

Assignment: Build Your Job Search Engine

Basic Implementation Challenge

Week 1: Set up complete LinkedIn job scraping system

Week 2: Implement AI evaluation with your skills profile

Week 3: Build cover letter and resume generation

Week 4: Deploy automated system and track results

Advanced Customization Project

Industry Adaptation: Customize for your specific field

Multi-Platform Expansion: Add Indeed, AngelList scrapers

Interview Prep: Generate role-specific practice questions

Salary Intelligence: Integrate compensation research

Success Metrics to Track

Efficiency: Time saved per week

Quality: Fit score vs actual interest correlation

Effectiveness: Application to interview conversion rate

ROI: Cost per quality opportunity discovered

Key Takeaways

Transformation Metrics: 

✅ 95% time reduction from 20+ hours to 15 minutes weekly ✅ Higher quality leads through AI-powered fit scoring✅ Consistent application materials with custom optimization ✅ Professional organization with complete tracking system

Strategic Advantages: ✅ Early application advantage through automated discovery ✅ ATS optimization for better screening success ✅ Personalized at scale without manual effort✅ Data-driven improvement through performance tracking

Career Impact: ✅ Stress reduction by eliminating manual job hunting ✅ Better opportunities through intelligent filtering ✅ Professional presentation with optimized materials ✅ Competitive advantage in crowded job markets

This system transforms job searching from a time-consuming, stressful process into a strategic, automated advantage - positioning you ahead of candidates still using manual methods.

Ethical Considerations & Best Practices

Responsible Automation

Quality over quantity: Focus on genuine fit, not mass applications

Truthful representation: Ensure all generated content is accurate

Platform respect: Follow scraping guidelines and rate limits

Company courtesy: Don''t spam the same organization

Professional Standards

Authentic voice: Maintain your personality in generated content

Continuous learning: Use upskilling insights for genuine development

Network building: Combine automation with relationship development

Value creation: Focus on what you can contribute, not just what you want

This automation should enhance your job search strategy, not replace professional judgment and authentic relationship building in your career development.', 7),
  ('6413dbe3-101f-403e-b194-6c6f6257bdfe', 'a24ea901-64ab-42e9-b1ed-b45851de3719', 'Ironman HUD For Obsidian Second Brain', '', 8),
  ('bda9899b-b4ca-4139-90c8-ad22c58038bf', '3d33f659-dabf-42f2-80b2-5af321653fdb', 'n8n Social Media Intelligence Dashboard', 'Build a Comprehensive Social Media Intelligence System

Automatically discover top-performing content across Instagram, LinkedIn, and TikTok, analyze what makes it successful, and generate ready-to-use content scripts and frameworks. Wake up every Monday to a curated list of viral content insights and production-ready post ideas.

Time to Complete: 120-180 minutesDifficulty: AdvancedTools Required: N8N (self-hosted or cloud), Airtable, RapidAPI, Apify, OpenAI API, GmailWeekly Time Savings: 20-25 hours of research and planning

The Content Creation Problem

Traditional Content Research Process

Manual Process (25+ hours/week):

Scrolling through platforms for inspiration: 5-6 hours

Analyzing why posts went viral: 6-8 hours

Writing content scripts and frameworks: 8-10 hours

Planning and organizing content: 3-5 hours

TOTAL: 25+ hours of manual work weekly

Automated Intelligence Solution

AI-Powered Process (30-60 minutes/week):

Automated content discovery: 0 hours (runs while you sleep on Sunday nights)

AI analysis of viral patterns: 0 hours (automated)

Generated content frameworks: 0 hours (automated)

Review, selection, and refinement: 30-60 minutes

TOTAL: 30-60 minutes of review time weekly

Result: 96-98% time reduction with higher quality insights

System Architecture Overview

Multi-Platform Intelligence Pipeline

Stage 1: Data Collection (Sunday Midnight)

Instagram: User-based scraping with RapidAPI

LinkedIn: Keyword-based discovery with Apify

TikTok: Keyword + engagement filtering with Apify

Automated weekly execution via N8N schedule trigger

Stage 2: Content Analysis

Visual analysis for carousels using OpenAI Vision

Script transcription for video content using Whisper

Engagement pattern recognition via AI analysis

Framework extraction (3 frameworks per post)

Stage 3: Content Generation (Human-in-Loop)

Email-triggered approval workflow

Platform-specific optimization

Iterative refinement based on feedback

Ready-to-use scripts and captions stored in Airtable

Phase 1: Airtable Intelligence Database

Database Architecture

Create an Airtable base with 5 interconnected tables:

Table 1: Inspiration Sources

Fields:

Keyword/User (Text) - Instagram users OR LinkedIn/TikTok keywords

Platform (Single Select) - Instagram, LinkedIn, TikTok

Status (Single Select) - Listening, Paused

Minimum Like/View Count (Number) - Engagement threshold

Example Records:

garyvee | Instagram | Listening | 1000

"AI automation" | LinkedIn | Listening | 25

"productivity hacks" | TikTok | Listening | 10000

Table 2: Instagram Ideas

Fields:

Post ID (Text)

Post Type (Single Select) - Reel, Carousel

Caption (Long Text)

Script (Long Text) - First slide text for carousels, full transcript for reels

Number of Slides (Number) - For carousels only

Viral Score (Number) - AI-generated 1-100

Primary Strengths (Long Text) - Top 3 reasons why it worked

Idea Framework 1, 2, 3 (Long Text) - Three reusable content templates

Selected Framework (Single Select) - 1, 2, 3

Action (Single Select) - Generate Content, Reject

Table 3: LinkedIn Ideas

Fields:

Post URL (URL)

User (Text)

Reactions (Number)

Post Type (Single Select) - Video, Text

Content (Long Text) - Full post text

Hashtags (Text)

LinkedIn Score (Number) - AI-generated 1-100

Primary Strengths (Long Text)

Framework 1, 2, 3 (Long Text)

Selected Framework (Single Select)

Status (Single Select) - Generate Content, Reject

Table 4: TikTok Ideas

Fields:

Post ID (Text)

User (Text)

Play Count (Number)

Description (Long Text)

Transcript (Long Text) - Full video transcript

Duration (sec) (Number)

TikTok Score (Number) - AI-generated 1-100

Primary Strengths (Long Text)

Framework 1, 2, 3 (Long Text)

Selected Framework (Single Select)

Status (Single Select) - Generate Content, Reject

Table 5: Post Pipeline

Final Output Fields:

Post (Text) - Brief title/description

Platform (Single Select) - Instagram, LinkedIn, TikTok

Description or Caption (Long Text)

Carousel Content or Script (Long Text)

Hashtags (Text)

Image Prompt (Long Text) - AI-generated visual descriptions

Phase 2: Instagram Intelligence System

User-Based Content Discovery

Setup Process:

Airtable Query
Base: Social Media Automation

Table: Inspiration

Filter: AND({Platform} = "Instagram", {Status} = "Listening")

RapidAPI Instagram Scraper
Service: Instagram Scraper (instagram-scraper21)

Cost: Free tier available, paid from ~$10/month

Endpoint: /api/v1/posts

Query: Username from Airtable

Headers: x-rapidapi-host, x-rapidapi-key

Split and Filter Posts

javascript

   // Split posts array
   return items[0].json.data.posts.map(post => ({ json: post }));
Temporal Filter
Filter for posts from past week only

Uses created_at_human_readable field

Compares against 7 days ago

Engagement Filter
Filter by minimum like count from Airtable

Uses like_count >= minimum

Content Type Router (Switch Node)

javascript

   if (product_type === "carousel_container") return 0; // Carousel path
   if (product_type === "clips") return 1; // Reel path
Carousel Analysis Workflow

Process Flow:

Loop Over Carousel Items (Split in Batches)

Post Details Extraction
API Call: /api/v1/post-info

Parameter: Post code (unique identifier)

Gets full carousel metadata

Image Analysis
Download first carousel image

OpenAI Vision (GPT-4o) analysis

Prompt: "What''s the text in this image? How is it designed?"

Output: Text content + design pattern

Reformat Image Analysis
OpenAI Chat Model extracts structured data

Returns: {text_from_image, design}

Count Carousel Slides

javascript

   const edges = $(''HTTP Request2'').first().json.data.post.edge_sidecar_to_children.edges;
   return [{ json: { length: edges.length } }];
Framework Generation (AI Analysis)
Input: First slide text, design style, caption, slide count

Output: Structured JSON with:
carousel_score (1-100)

primary_strengths (top 3 with explanations)

framework_1, 2, 3 (name + description + action step)

Save to Airtable (Instagram Ideas table)

Reel Analysis Workflow

Process Flow:

Loop Over Reel Items (Split in Batches)

Post Details Extraction
Same API call as carousels

Gets video metadata

Extract Audio URL

javascript

   // Parse DASH manifest for audio stream
   const manifest = $input.first().json.data.post.dash_info.video_dash_manifest;
   // Extract BaseURL from audio AdaptationSet
   // Return decoded audio URL
Download Audio File
HTTP request to audio URL

Returns binary audio data

Transcribe with OpenAI Whisper
Upload binary audio

Get full script text

Framework Generation (AI Analysis)
Input: Caption + full script

Output: Structured JSON with:
viral_score (1-100)

primary_strengths

framework_1, 2, 3

Save to Airtable (Instagram Ideas table)

Phase 3: LinkedIn Intelligence System

Keyword-Based Discovery

Apify Integration:

Airtable Query
Filter: AND({Platform} = "LinkedIn", {Status} = "Listening")

Loop Over Keywords (Split in Batches)

Run Apify Actor
Actor: LinkedIn Post Search Scraper (5QnEH5N71IK2mFLrP)

Cost: $5 per 1,000 results

Parameters:
date_filter: "past-week"

keyword: From Airtable

limit: 50

Wait for Completion
Check run status every 20 seconds

Continue when status === "SUCCEEDED"

Get Dataset Items
Retrieve all scraped posts

Returns full post data with engagement stats

Engagement Filtering

javascript

   const minReactions = $(''Search records3'').item.json[''Minimum Like/View Count''];
   return item.json.stats.total_reactions >= minReactions;
Loop and Analyze
For each filtered post

AI analysis with full context:
Post text

Author name + headline

Content type

Engagement stats (reactions, comments, shares)

Hashtags

LinkedIn-Specific Analysis Prompt
Analyzes professional context

Identifies thought leadership elements

Extracts business-focused frameworks

Save to Airtable (LinkedIn Ideas table)

Phase 4: TikTok Intelligence System

Advanced Video Processing

Content Discovery:

Airtable Query
Filter: AND({Platform} = "Tiktok", {Status} = "Listening")

Clear Temp Folder First

bash

   find /tmp -type f -delete
Loop Over Keywords (Split in Batches)

Run Apify Actor
Actor: TikTok Scraper (GdWCkxBtKWOsKjdch)

Parameters:
searchQueries: Keyword from Airtable

resultsPerPage: 25

searchSection: "/video"

Downloads disabled (faster, cheaper)

Wait for Completion (same as LinkedIn)

Get Dataset Items

Two-Stage Filtering
Filter 1: Play count > minimum threshold

Filter 2: musicMeta.musicName === "original sound"
This ensures videos have dialogue, not just background music

Critical for successful transcription

Loop Over Filtered Videos (Split in Batches)

Audio Extraction & Transcription

The MP4 to MP3 Conversion Challenge:

TikTok returns MP4 files, but OpenAI Whisper requires MP3. Here''s the solution flow:

Get Music Info (RapidAPI TikTok API)
Endpoint: /api/music/info

Parameter: musicId from TikTok data

Returns playable URL

Download MP4 File
HTTP request to playUrl

Binary video file

Save to Temp

javascript

   // Write to /tmp/audio.mp4
Read File

javascript

   // Read /tmp/audio.mp4 as binary
Convert with FFmpeg (Self-hosted N8N only)

bash

   ffmpeg -i /tmp/audio.mp4 -vn -acodec libmp3lame -q:a 4 /tmp/converted_audio.mp3
Read MP3

javascript

   // Read /tmp/*.mp3 as binary
Transcribe with OpenAI Whisper
Upload MP3 binary

Language: English

Get full transcript

Alternative for N8N Cloud Users:

Use cloud conversion APIs (CloudConvert, Convertio) at ~$0.05 per conversion. Replace steps 3-6 with a single HTTP request to conversion API.

TikTok-Specific Analysis

AI Analysis Inputs:

Description (TikTok caption)

Full transcript

Play count

Analysis Focus:

Hook timing (first 3 seconds)

Trend utilization

Comment engagement drivers

Visual/audio combination effectiveness

Save and Cleanup:

Save to Airtable (TikTok Ideas table)

Clear temp folder:

bash

   find /tmp -type f -delete

Phase 5: Automated Content Generation Pipeline

Airtable Automation Triggers

Setup in Airtable:

For each platform (Instagram, LinkedIn, TikTok), create automation:

Trigger: When record matches conditions

Table: [Platform] Ideas

Conditions:
Selected Framework is not empty

Action = "Generate Content"

Action: Send email

To: Your email

Subject: "[Platform] Content Generation"

Body: Include post type, caption, script, selected framework

Gmail-Triggered N8N Workflow

Email Classification (Switch Node):

javascript

// Instagram Carousel
if (email.text.includes("**Post Type**: Carousel")) → Carousel path

// Instagram Reel  
if (email.text.includes("**Post Type**: Reel")) → Reel path

// LinkedIn
if (email.subject === "LinkedIn Content Generation") → LinkedIn path

// TikTok
if (email.subject === "TikTok Content Generation") → TikTok path
Content Generation Pattern (All Platforms)

Common Flow:

Edit Fields - Build content generation prompt

LLM Chain - Generate content with GPT-4o

Structured Output Parser - Parse JSON response

Edit Fields - Extract output object

Send and Wait - Email with content + approval form

Analyze Response - Determine if approved

If Approved → Save to Post Pipeline + Delete email

If Changes Requested → Regenerate with feedback (loops back to step 2)

Platform-Specific Outputs

LinkedIn Post Generator

Output Structure:

json

{
  "linkedin_post": "Complete ready-to-publish post",
  "optimization_notes": {
    "hook_effectiveness": "Why opening works",
    "framework_implementation": "How framework applied",
    "professional_positioning": "Authority elements",
    "engagement_mechanics": "Comment/share drivers"
  },
  "performance_predictions": {
    "estimated_reach": "Reach assessment",
    "engagement_drivers": "Top 3 interaction elements",
    "improvement_suggestions": "Optional tweaks"
  },
  "image_generation_prompt": "Detailed visual prompt"
}
Instagram Carousel Generator

Output Structure:

json

{
  "carousel_content": {
    "slide_count": 7,
    "slides": [
      {
        "slide_number": 1,
        "visual_concept": "Detailed visual description",
        "text_overlay": "Mobile-optimized text",
        "design_notes": "Fonts, colors, positioning"
      }
    ],
    "caption": "Full Instagram caption with hooks and CTA",
    "hashtags": "30 strategic hashtags"
  },
  "optimization_notes": {...},
  "performance_predictions": {...},
  "image_generation_prompts": [...]
}
Instagram Reel Generator

Output Structure:

json

{
  "reel_content": {
    "duration": "15-30 seconds",
    "content_theme": "Core topic/theme",
    "script": {
      "hook": "First 3 seconds",
      "main_content": "Core delivery 3-25s",
      "cta": "Strong ending 25-30s"
    },
    "visual_directions": {
      "overall_style": "Aesthetic approach",
      "scenes": [...]
    },
    "audio_suggestions": {...},
    "caption": "Instagram caption",
    "hashtags": "30 strategic hashtags"
  },
  "optimization_notes": {...},
  "thumbnail_generation_prompt": "..."
}
TikTok Video Generator

Output Structure:

json

{
  "tiktok_content": {
    "duration": "15-60 seconds",
    "content_theme": "Adapted viral theme",
    "script": {
      "hook": "First 3 seconds - critical",
      "main_content": "3-50s delivery",
      "cta": "50-60s ending"
    },
    "visual_directions": "Overall video approach",
    "caption": "TikTok caption",
    "hashtags": "20-30 strategic hashtags"
  },
  "optimization_notes": {...},
  "thumbnail_generation_prompt": "..."
}

Critical Implementation Notes

FFmpeg Requirement (TikTok)

Self-hosted N8N: Install FFmpeg in your N8N container/server

N8N Cloud: Use cloud conversion API instead:

CloudConvert API

Convertio API

Cost: ~$0.05 per video

API Cost Management

Monthly Estimates (analyzing ~500 posts):

RapidAPI Instagram: $20-50

Apify LinkedIn: $25-50

Apify TikTok: $15-30

OpenAI (analysis + transcription): $30-60

Total: $90-190/month

ROI: 25 hours/week × $50/hour × 4 weeks = $5,000/month value

Error Handling

The workflow includes:

Wait loops for Apify actors (checks every 20 seconds)

Status validation before proceeding

Temp folder cleanup (prevents disk filling)

Human-in-loop prevents bad content going live

Usage Instructions

Weekly Workflow

Sunday Night (Automated):

Schedule trigger fires at midnight

Scrapes Instagram, LinkedIn, TikTok

Analyzes all content

Populates Ideas tables

Monday Morning (You):

Review Instagram Ideas table

Select frameworks you like

Set Action = "Generate Content"

Repeat for LinkedIn Ideas

Repeat for TikTok Ideas

Content Generation (Automated + You):

Airtable sends email to trigger N8N

N8N generates content

You receive approval email

Review content

Either approve or request changes

Approved content goes to Post Pipeline

Post Pipeline Output

Your final content ready for posting with:

Platform indicator

Full caption/description

Script or carousel content (slide by slide)

Hashtags

Image generation prompts (for visuals)

Success Metrics

Time Savings:

Research: 5-6 hours → 15 minutes (95% reduction)

Analysis: 6-8 hours → 0 hours (100% reduction)

Content creation: 8-10 hours → 15-30 minutes (96% reduction)

Total: 25+ hours → 30-60 minutes (96-98% reduction)

Quality Improvements:

Data-driven content decisions

Consistent framework application

Platform-optimized outputs

Viral pattern replication

Business Impact:

10x content production capacity

Early trend identification

Competitive intelligence

Scalable to multiple brands/clients

Troubleshooting

Common Issues

Instagram scraping fails:

Check RapidAPI credentials

Verify username exists and is public

Check rate limits

LinkedIn returns no results:

Verify keyword is specific enough

Check date filter (past week may have limited content)

Increase result limit if needed

TikTok transcription errors:

Verify FFmpeg is installed (self-hosted)

Check "original sound" filter is working

Ensure audio quality is sufficient

Content generation loops endlessly:

Review approval email responses

Check LLM output parser for errors

Verify feedback analysis is working

Key Takeaways

Technical Mastery: ✅ Multi-platform scraping and API integration✅ Advanced AI analysis with structured outputs✅ Human-in-loop automation for quality control✅ Complex workflow orchestration in N8N

Business Transformation:✅ 96%+ time reduction in content operations✅ Data-driven content strategy✅ Scalable to multiple brands/niches✅ Competitive intelligence capabilities

Strategic Value:✅ Agency-level service ($5,000+/month value)✅ Early trend identification and adoption✅ Consistent brand voice through framework application✅ Production-ready content pipeline', 1),
  ('3749bfe3-5980-49c9-bdac-febddf3f3715', '3d33f659-dabf-42f2-80b2-5af321653fdb', 'Viral Video Generation System', 'Lesson Overview

Build a complete automated video generation pipeline that creates viral short-form content while you sleep. This system generates POV-style historical videos by orchestrating five different APIs to produce images, voiceovers, and final edited videos—all triggered on a schedule.

Time to Complete: 90 minutes Difficulty: Advanced Tools Required: n8n, OpenAI API, Replicate (Flux), ElevenLabs, Creatomate, Google Sheets, Google Drive Time/Value Transformation: Manual video creation (3-4 hours per video) → Automated generation ($0.50 per video, unlimited scale)

The Content Creation Problem

Traditional Video Production Reality

Script writing: 45 minutes per video

Image generation/sourcing: 60 minutes (5 scenes)

Voiceover recording and editing: 45 minutes

Video editing and assembly: 90 minutes

Total per video: 4 hours minimum

Cost per video: $100+ if outsourced

AI-Powered Solution

Automated script generation: 30 seconds

Batch image generation: 2 minutes

AI voiceover creation: 1 minute

Automated video assembly: 1 minute

Total per video: 5 minutes (mostly waiting for APIs)

Cost per video: $0.50

The Transformation: From 4 hours of manual work to 5 minutes of automated processing. From $100 per video to $0.50. Scale from 1 video per day to 48 videos per day with the same effort.

System Architecture Overview

Multi-Stage Content Pipeline

Google Sheets (Topic Database)
    ↓
Schedule Trigger (Every 12 hours)
    ↓
Content Strategy Layer (ChatGPT generates 5-scene script)
    ↓
Visual Production Layer (Flux generates 5 images)
    ↓
Audio Production Layer (ElevenLabs generates 5 voiceovers)
    ↓
Assembly Layer (Creatomate stitches final video)
    ↓
Distribution Layer (Upload to Drive + Update Sheet)
    ↓
Cleanup (Delete temporary files)

Cost Breakdown Per Video

Images (Flux 1.1 Pro): 5 images × $0.04 = $0.20

Audio (ElevenLabs): ~300 characters × 5 scenes = $0.03

Video Assembly (Creatomate): $0.25 (at $49/200 videos)

AI Script Generation (GPT-4o mini): <$0.01

Total: $0.48-0.50 per video

At 2 videos per day: $30/month production cost Manual equivalent: $6,000/month (at $100 per video outsourced)

Phase 1: Content Strategy Database

Setting Up Your Topic Repository

Before automation begins, you need a content strategy. Use ChatGPT to generate 100 video ideas organized by theme.

Prompt for Topic Generation:

You are a master at short form video content and your videos 
consistently go viral. I want to generate 100 viral short form 
video ideas about famous events in history. Your output should 
be something I can copy paste into Google Sheets. Output the 
spreadsheet as follows:

Topic | Theme

Go for 25 topics per theme within famous events throughout history.

Why This Matters: Batch content planning separates strategy from execution. You''re building a content calendar that feeds your automation system, ensuring consistent output without daily creative decisions.

Google Sheets Structure

Required columns:

Topic: The specific historical event

Theme: Broader category (Science, Technology, Warfare, etc.)

Status: Pending / Generated / Posted

Title: Auto-generated after video creation

Description: Auto-generated after video creation

Date Posted: Manual tracking

Key Technical Points:

Status column enables filtering—automation only processes "Pending" rows

Single row selection prevents duplicate video generation

Sheet acts as both input queue and output log

Phase 2: Workflow Initialization

Schedule Trigger Configuration

// n8n Schedule Trigger Node
Interval: 12 hours
// Generates 2 videos per day automatically

Why This Matters: Consistent posting schedule is crucial for YouTube''s algorithm. This automation ensures you never miss a post without manual intervention. 12-hour intervals = 2 shorts per day = 60 shorts per month.

Google Sheets Data Pull

// Google Sheets Node - Read Row
Filter: Status column = "Pending"
Options: Return first matching row only

Business Impact: By filtering for "Pending" status, the workflow naturally progresses through your content calendar without regenerating existing videos. This single filter prevents wasted API costs.

Temporary Resource Folder Creation

// Google Drive Node - Create Folder
Folder Name: "POV Videos Audio"
Parent: My Drive

Why This Step Exists: Audio files need a temporary staging area with public access URLs. ElevenLabs outputs MP3 files that Creatomate needs to access via direct links. Google Drive provides this with automatic CDN delivery.

Folder Access Configuration

// Google Drive Node - Share Folder
Folder ID: {{ $json.drive_folder_id }}
Role: Writer
Type: Anyone

Critical Detail: Without public sharing, n8n cannot read the audio files it just created. This permission is temporary—folder gets deleted after video generation.

Phase 3: AI Content Generation

Master Prompt Engineering

This is where the magic happens. The LLM Chain generates the entire video structure in one shot.

// Basic LLM Chain Node
You are a master at creating short-form viral videos. I want your 
help in generating historical POV videos, in which the user sees 
POV-style images of an individual throughout a major breakthrough 
in science and technology. The channel''s name is "Before it Changed 
Everything."

Each video is 25 seconds long, and contains 5 scenes, 5 seconds each.

Each scene requires one image and one audio voiceover, so the whole 
story will consist of 5 images and 5 audios. !important

The entire 25 second video would narrate a short story from that 
historical era.

CRITICAL CONSISTENCY RULES:
- Image prompts must maintain visual consistency across scenes
- POV perspective means: visible hands, feet, occasional torso
- Any visible character details (ink-stained hands, leather apron) 
  must be referenced in EVERY prompt
- Each scene introduces new characters/settings to reduce consistency 
  burden
- Scripts must end with "can you guess the discovery?" in scene 5

EXAMPLE OUTPUT STRUCTURE:
Scene 1 – Setting the Stage
[Detailed POV description with location, time period, visible body 
parts, objects, people, atmosphere]
🎙️ "Master Gutenberg said today would change the world..."

[Repeat for scenes 2-5]

!Important: Each script segment must be under 4 seconds of speech, 
otherwise video will have black screens.

Theme: {{ $(''Google Sheets'').item.json.Theme }}
Event: {{ $(''Google Sheets'').item.json.Topic }}

Why This Prompt Works:

Specificity: Defines exact output format (5 scenes, 5 seconds each)

Consistency rules: Addresses the biggest challenge in AI image generation

Examples: Shows the LLM exactly what "good" looks like

Constraints: 4-second speech limit prevents timing issues

Dynamic variables: Pulls theme/topic from spreadsheet

Structured Output Parser

// Output Parser - JSON Schema
[
  {
    "scene": {
      "image-prompt": "X",
      "image-to-video-prompt": "X",
      "voiceover-script": "X"
    }
  }
]

Technical Requirement: This forces GPT to output valid JSON instead of markdown or prose. The Split Out node expects this exact structure.

Key Technical Points:

Using GPT-4o mini ($0.15 per 1M input tokens) is sufficient—no need for GPT-4

Structured output parser eliminates parsing errors

Single LLM call generates entire video blueprint (cost: <$0.01)

Phase 4: Visual Asset Production

Image Generation via Replicate

// HTTP Request Node - POST to Replicate
URL: https://api.replicate.com/v1/models/black-forest-labs/flux-schnell/predictions
Method: POST
Headers: {
  "Authorization": "Bearer YOUR_API_TOKEN"
}
Body: {
  "input": {
    "prompt": "{{ $json.scene[''image-prompt''] }}",
    "aspect_ratio": "9:16",
    "output_format": "jpg",
    "num_inference_steps": 4,
    "go_fast": true
  }
}

Why Flux 1.1 Pro:

Fastest inference time (4 steps vs 25+ for other models)

Best consistency for sequential scenes

Vertical format support (9:16 for YouTube Shorts)

Cost-effective at $0.04 per image

Split Out Node Magic: The LLM Chain outputs ONE object with 5 scenes. Split Out transforms this into 5 individual outputs, each triggering a separate image generation request.

// Split Out Node
Field to split: output
// Takes array [scene1, scene2, scene3, scene4, scene5]
// Outputs 5 separate items to trigger 5 parallel HTTP requests

Wait Node for Generation

// Wait Node
Duration: 2 minutes

Why This Matters: Replicate''s API is asynchronous. The POST request returns immediately with a prediction ID, but the image isn''t ready yet. The 2-minute wait ensures images are fully generated before we try to retrieve them.

Image Retrieval

// HTTP Request1 Node - GET from Replicate
URL: {{ $json.urls.get }}
Method: GET
Headers: {
  "Authorization": "Bearer YOUR_API_TOKEN"
}

Output: 5 direct URLs to generated images, ready for video assembly.

Phase 5: Audio Production Pipeline

Loop Architecture

// Loop Over Items Node
// Processes 5 audio generations sequentially, not in parallel

Why Sequential Processing: Each audio file needs a unique filename (audio-0, audio-1, audio-2, etc.). Parallel processing would create race conditions. The loop ensures each voiceover is generated and saved with proper indexing.

ElevenLabs Text-to-Speech

// HTTP Request2 Node - POST to ElevenLabs
URL: https://api.elevenlabs.io/v1/text-to-speech/VOICE_ID
Method: POST
Headers: {
  "xi-api-key": "YOUR_API_KEY"
}
Body: {
  "text": "{{ $(''Split Out'').item.json.scene[''voiceover-script''] }}",
  "model_id": "eleven_multilingual_v2"
}

Voice Selection: Use ElevenLabs voice library to find voices that match your content style. For historical content, voices with gravitas and narrative quality work best.

Google Drive Upload with Dynamic Naming

// Google Drive1 Node - Upload File
Filename: audio-{{ $runIndex }}.mp3
Parent Folder: {{ $(''Google Drive'').item.json.id }}

The $runIndex Variable: This is the loop iteration counter (0, 1, 2, 3, 4). It ensures each audio file has a predictable name that can be mapped to its corresponding image during video assembly.

Key Technical Points:

ElevenLabs charges per character, not per request (~$0.006 per 1000 characters)

Average 5-second script = 60-75 characters

Total audio cost per video: $0.025-0.03

Loop reconnects to itself until all 5 iterations complete

Phase 6: Data Aggregation & Video Assembly

Merge Node Configuration

// Merge Node
Mode: Combine by position
Input 1: Image URLs (from HTTP Request1)
Input 2: Audio URLs (from Loop Over Items - Done output)
Number of inputs: 2

What This Does: Waits for both parallel branches (images and audio) to complete, then combines them into a single dataset. Critical for ensuring all 5 images and 5 audio files are ready before video assembly.

Aggregate Node

// Aggregate Node
Fields to aggregate:
- output[0] (image URLs array)
- webContentLink (audio URLs array)
- drive_folder_id (for cleanup later)

Output Structure:

{
  "output": [
    ["image1_url", "image2_url", "image3_url", "image4_url", "image5_url"]
  ],
  "webContentLink": [
    "audio1_url", "audio2_url", "audio3_url", "audio4_url", "audio5_url"
  ],
  "drive_folder_id": "folder_id_for_cleanup"
}

Why Aggregation Matters: Creatomate needs all 10 URLs (5 images + 5 audios) in a single request. Aggregation transforms 10 separate items into one object with arrays.

Creatomate Video Assembly

// Generate Videos Node - POST to Creatomate
URL: https://api.creatomate.com/v1/renders
Method: POST
Headers: {
  "Authorization": "Bearer YOUR_API_KEY"
}
Body: {
  "template_id": "YOUR_TEMPLATE_ID",
  "modifications": {
    "Image-1.source": "{{ $json.output[0][0] }}",
    "Voiceover-1.source": "{{ $json.webContentLink[0] }}",
    "Image-2.source": "{{ $json.output[0][1] }}",
    "Voiceover-2.source": "{{ $json.webContentLink[1] }}",
    // ... repeat for all 5 scenes
  }
}

Creatomate Template Setup (Critical):

Create template with 5 scenes in Creatomate dashboard

Each scene contains:
Image layer (dynamic, URL provider, 9:16 aspect ratio)

Voiceover layer (dynamic, URL provider, transcription enabled)

Subtitle layer (auto-generated from voiceover transcription)

Add motion to images (slide, scale, pan) to create video feel

Set scene duration to 5 seconds each

Why Creatomate:

Automatic subtitle generation from audio (critical for shorts)

Template-based approach means consistent styling

API-first design built for automation

Handles video rendering at scale

Post-Generation Wait

// Wait1 Node
Duration: 5 minutes

Why So Long: Creatomate needs time to:

Download 10 files (5 images + 5 audios)

Generate subtitles via transcription

Render final video with effects

Upload to CDN

5 minutes is conservative but ensures video is fully ready.

Phase 7: Metadata Generation & Tracking

Title and Description Generation

// OpenAI Node
Messages: [
  {
    "content": "You are an expert at creating viral YouTube shorts. 
    I am creating a science video series about {{ $json.Theme }}, 
    and the topic of this video is {{ $json.Topic }}.
    
    Generate a viral title and description. Add #shorts at the 
    end of the title. Output as JSON:
    
    {
      \"title\": \"...\",
      \"description\": \"...\"
    }
    
    IMPORTANT: The title and description should NOT give the topic 
    away. The video provides clues and asks viewers to guess."
  }
]
JSON Output: Enabled

Why Separate AI Call: Title optimization is marketing, not content production. This prompt is specifically tuned for virality (curiosity gap, hooks, hashtags).

Google Sheets Update

// Google Sheets2 Node - Update Row
Match Column: Topic
Update Columns:
- Status: "Generated"
- Title: {{ $json.message.content.title }}
- Description: {{ $json.message.content.description }}

Business Impact: This update prevents the same video from being generated twice. Next time the workflow runs, it''ll skip this topic and grab the next "Pending" row.

Phase 8: Cleanup & Distribution

Video Download

// HTTP Request3 Node
URL: {{ $(''Generate Videos'').item.json.url }}
Method: GET
// Downloads final video from Creatomate CDN

Google Drive Storage

// Google Drive3 Node - Upload File
Filename: {{ $(''Google Sheets1'').item.json.Topic }}
Folder: "Before It Changed Everything Videos"

Storage Strategy: Keep all generated videos in one folder for easy manual review before posting. This gives you the option to QA before YouTube upload.

Folder Cleanup

// Google Drive4 Node - Search
Query: "POV Videos Audio"
Filter: Folders only

// Google Drive5 Node - Delete Folder
Folder ID: {{ $json.id }}

Why Delete: The audio files were only needed during video assembly. Keeping them wastes storage and creates clutter. Cleanup keeps your Drive organized.

Business Applications & ROI

Content Creator Use Case

Before Automation:

1 video per week = 4 videos per month

4 hours per video = 16 hours per month

Opportunity cost: $800/month (at $50/hour)

After Automation:

60 videos per month (2 per day)

30 minutes per month managing queue

Direct cost: $30/month (API costs)

Time saved: 15.5 hours/month

Value created: $770/month

Agency/Client Services Use Case

Productized Service:

Offer: 30 AI-generated shorts per month for $497

Your cost: $15 (API) + 2 hours setup/QA

Profit margin: $482 per client

At 5 clients: $2,410/month profit

YouTube Channel Growth Use Case

Consistency = Algorithm Boost:

60 shorts per month = 720 per year

Even at 5% hit rate = 36 viral videos

Industry average: 1 viral short = 10,000 new subscribers

Potential: 360,000 subscribers per year from automation

ROI Calculation

Investment:

n8n: $20/month (starter plan)

OpenAI: $5/month

Replicate: $15/month (60 videos)

ElevenLabs: $5/month

Creatomate: $49/month

Total: $94/month

Output:

60 professional videos

Manual equivalent cost: $6,000 (at $100/video outsourced)

ROI: 6,276%

Advanced Customizations

Multi-Channel Scaling

// Modification: Add "Channel" column to Google Sheets
// Each row specifies destination channel
// Add conditional routing based on channel value
// Separate templates for different content styles

Business Impact: Run 3 channels simultaneously (history, science, technology) from one automation. Triple output with minimal additional work.

A/B Testing Titles

// Generate 3 title variants per video
// Post same video with different titles across days
// Track performance in Google Sheets
// Feed results back to prompt for optimization

Voice Cloning Integration

// Replace ElevenLabs API call with voice clone
// Use your own voice or hire voice actor once
// All future videos use that consistent voice
// Builds brand recognition

YouTube Auto-Upload

// YouTube Node (n8n has native integration)
Operation: Upload Video
Video File: {{ $(''HTTP Request3'').item.json.data }}
Title: {{ $json.title }}
Description: {{ $json.description }}
Privacy: Public
Category: Education

Warning: Start with manual upload to QA content quality. Auto-upload is for when you trust the system completely.

Troubleshooting & Common Issues

Issue 1: Images Lack Consistency Between Scenes

Problem: Characters look different across scenes Solution:

Enhance prompt with more specific character descriptions

Reference previous scene details in each new prompt

Use consistent color palette descriptors

Add "maintaining consistency with previous scene" to each prompt

Issue 2: Audio Files Not Accessible by Creatomate

Problem: Creatomate fails with "Unable to download audio" error Solution:

Verify folder sharing is set to "Anyone with link"

Check webContentLink URLs are actually public

Add 30-second wait after Google Drive upload before Creatomate call

Test URLs manually in browser incognito mode

Issue 3: Subtitle Timing Off

Problem: Subtitles don''t match voiceover timing Solution:

Reduce script length (aim for 50-60 characters per 5 seconds)

Enable "Start at audio" option in Creatomate subtitle settings

Adjust subtitle duration to "Auto" instead of fixed 5 seconds

Issue 4: Video Renders with Black Screens

Problem: Some scenes show blank/black instead of content Solution:

Script is too short (video duration exceeds audio)

Add padding: "script duration + 0.5 seconds" for scene length

Check Creatomate template scene durations match audio lengths

Review audio files—some may have failed to generate

Issue 5: Workflow Stops at Random Nodes

Problem: Execution hangs or fails without clear error Solution:

Add error workflow to catch failures

Implement retry logic on HTTP requests

Check API rate limits (Replicate especially)

Review n8n execution logs for timeout errors

Assignment: Build Your Viral Video System

Phase 1: Foundation Setup (30 minutes)

Create Google Sheet with 10 test topics in your chosen niche

Set all Status fields to "Pending"

Set up n8n Schedule Trigger for manual execution (not automated yet)

Configure Google Sheets read node to pull first pending row

Success Metric: Successfully pull one topic from your sheet

Phase 2: Content Generation (45 minutes)

Adapt the master prompt for your niche (not historical events)

Set up OpenAI LLM Chain with structured output

Test with one topic—validate JSON output structure

Implement Split Out node to separate 5 scenes

Success Metric: Generate 5 distinct image prompts and scripts from one topic

Phase 3: Production Pipeline (60 minutes)

Set up Replicate image generation with your API key

Configure ElevenLabs with voice that matches your content

Build loop for audio generation and Google Drive uploads

Test with actual API calls—generate 1 complete set of assets

Success Metric: 5 images and 5 audio files successfully generated

Advanced Challenge: Complete End-to-End System

Create Creatomate template with your branding

Implement full workflow including video assembly

Add cleanup and tracking steps

Run automated schedule for 1 week (14 videos)

Calculate your actual cost per video

Success Metric: 14 videos generated automatically with zero manual intervention

Resources & Templates

Complete System Package

Full n8n Workflow JSON - Import and configure with your API keys

Google Sheets Template - Pre-formatted with all required columns

Creatomate Video Template - Branded layout with subtitle styling

Master Prompt Library - 10 niche-specific variations

API Setup Guides

Replicate Account Setup - Getting API key and understanding billing

ElevenLabs Voice Selection - Guide to choosing optimal voice

Creatomate Template Design - Step-by-step template builder walkthrough

Cost Optimization Resources

API Cost Calculator - Spreadsheet to project costs at different volumes

Free Tier Alternatives - Lower-cost options for testing

Key Takeaways

Technical Mastery: ✅ Multi-API orchestration with proper error handling ✅ Sequential vs parallel processing architecture decisions ✅ Data transformation through split, merge, and aggregate patterns ✅ Asynchronous workflow management with strategic wait nodes ✅ Dynamic file naming and resource cleanup

Business Impact: ✅ $0.50 per video vs $100 manual production ✅ 60 videos per month vs 4 videos without automation ✅ 15.5 hours saved per month on production ✅ $2,410/month profit potential selling as service to 5 clients ✅ Infinitely scalable - same workflow handles 2 or 200 videos

Strategic Positioning: ✅ Content consistency drives algorithmic growth ✅ Automation enables testing at scale (60 experiments vs 4) ✅ Productized service with 96% profit margin ✅ Eliminates production as bottleneck—distribution becomes focus ✅ Time freed up for strategy, not execution

This isn''t just automation—it''s a complete business model shift. You''ve moved from craftsman (making videos) to manufacturer (running a video factory). The same principles apply to any content format: blogs, social posts, podcasts, email sequences. Master this workflow, and you''ve mastered scalable content production.', 2),
  ('fe60d6b3-89cc-454e-bac2-39bf79e03e1a', '3d33f659-dabf-42f2-80b2-5af321653fdb', 'Sora 2 and Nano Banana Ad Generator', 'Lesson Overview

Build a complete automated video ad generation system that transforms static product photos into professional, motion-rich video ads. Learn the two-stage AI generation strategy (Gemini + Sora 2), master prompt engineering for commercial video, and deploy a production workflow that outputs scroll-stopping content at 1/500th traditional production cost.

Time to Complete: 60 minutes 

Difficulty: Intermediate 

Tools Required: n8n, OpenAI/Sora 2 API (via Kie.ai), Google Gemini (via OpenRouter), Google Drive, Anthropic Claude 

Cost per Video: $0.15 (vs $50+ traditional production)

The Content Production Problem

Traditional Video Ad Reality

Professional shoot booking: 2-4 weeks lead time

Studio rental: $500-1,500/day

Videographer: $1,000-2,500/day

Post-production editing: $500-2,000

Total per video: $2,000-6,000

Timeline: 4-6 weeks from concept to delivery

Result: Can afford 1-2 video ads per quarter

AI-Automated Production

Upload product photo: 10 seconds

AI generates first frame: 30 seconds

AI creates video with motion: 2 minutes

Total per video: 3 minutes, $0.10

Timeline: Same day, unlimited iterations

Result: 47 video variations in 20 minutes

The Transformation: From quarterly video campaigns (due to cost) to daily A/B testing (47 variations costs $4.70). From $2,000+ per video to dime-per-video economics that enable true creative experimentation.

Why Everyone''s Prompting Sora Wrong

The Common Mistake

What Everyone Does:

Prompt: "Create a video ad for this coffee maker showing steam 
rising and coffee pouring into a cup with dramatic lighting"

What Sora Generates:

Inconsistent product appearance

Morphing objects mid-shot

Unnatural motion physics

Low visual quality

Cost: $0.10 wasted + unusable output

The Secret: Two-Stage Generation Strategy

Stage 1: Perfect First Frame (Gemini 2.5 Flash)

Input: Static product photo + loose description
Process: AI generates professionally composed opening shot
Output: Studio-quality first frame with proper lighting/composition
Cost: <$0.01

Stage 2: Motion Generation (Sora 2)

Input: Perfect first frame + motion prompt
Process: Sora extrapolates motion from high-quality starting point
Output: Professional video maintaining visual quality throughout
Cost: $0.10

Why This Works:

Garbage in, garbage out: Raw product photos → poor Sora output

Quality in, quality out: AI-optimized first frame → stunning video

Consistency: Starting from perfect frame = consistent product appearance

Control: Separate image and motion prompts = precise direction

The Insight: Sora 2 is incredible at generating motion, but struggles with creating perfect compositions from scratch. By using Gemini to nail the composition first, you get Sora''s motion capabilities without its compositional weaknesses.

System Architecture Overview

Three-Stage Production Pipeline

Stage 1: First Frame Generation
[Product Photo] → [Google Drive Upload] → [Claude Prompt Optimization] 
→ [Gemini 2.5 Image Generation] → [Base64 to PNG Conversion] 
→ [Perfect First Frame]

Stage 2: Video Generation  
[First Frame] → [Sora 2 API (via Kie.ai)] → [30-Second Wait Loop]
→ [Status Check] → [Wait/Generating: Loop | Success: Continue]

Stage 3: Cleanup & Output
[Extract Video URL] → [Delete Temporary Files] → [Output Final URL]

Cost Breakdown Per Video

Form trigger: FREE (n8n built-in)

Google Drive storage: FREE (temporary, auto-deleted)

Claude prompt optimization: $0.002 (Sonnet 4.5 via OpenRouter)

Gemini 2.5 Flash image: <$0.01

Sora 2 video generation: $0.15 (via Kie.ai)

Total: $0.152 per video

ROI: 1,785,614%

Phase 1: Form Trigger & File Upload

Form Trigger Configuration

// n8n Form Trigger Node
Form Title: "Sora 2 Video Generator"

Form Fields:
1. Image (File Upload)
   - Field Type: File
   - Accept: .jpg, .png
   - Required: Yes
   - Multiple Files: No

2. First Frame Description (Text Area)
   - Label: "First frame description"
   - Type: Textarea
   - Required: Yes
   - Placeholder: "woman applying serum, glowing skin, bathroom"

3. Video Prompt (Text Area)
   - Label: "Video Prompt"  
   - Type: Textarea
   - Required: Yes
   - Placeholder: "smooth application, satisfied expression"

Why Three Separate Inputs:

Image: The raw product photo (any quality, any background)

First Frame Description: Describes the IDEAL opening shot composition

Video Prompt: Describes the MOTION you want Sora to generate

Testing vs Production:

Test Mode: Execute node → form appears in n8n

Production Mode: Activate workflow → share Production URL from form node

Pro Tip: During development, use test mode to avoid public exposure

Google Drive Upload (Original Image)

// Google Drive Upload Node
Operation: Upload
Input Data Field Name: "Image" (from form)
File Name: "product_image"
Drive: My Drive
Folder: Root (or specific project folder)

Why Google Drive:

Public URL generation: Image needs accessible URL for AI APIs

Temporary storage: Files auto-delete after video generation

No file size limits: Unlike direct API uploads (often limited to 4MB)

Common Issue:

Error: "Credentials not set up"
Solution: 
1. Go to n8n Credentials
2. Add Google Drive OAuth2
3. Follow OAuth flow (opens Google consent screen)
4. Grant drive.file scope
Tutorial link: [provided in video description]

Share File (Make Publicly Accessible)

// Google Drive Share Node
Operation: Share
File: By ID
File ID: {{ $json.id }} (from Upload node)
Permissions:
- Role: reader
- Type: anyone

Critical Configuration:

Role: reader (not editor—security)

Type: anyone (must be public for AI APIs to access)

This doesn''t expose file permanently: Deleted at workflow end

Security Note: Files are public for 2-3 minutes during processing, then deleted. Risk window is minimal.

Phase 2: AI-Powered Prompt Optimization

The Claude Prompt Enhancement System

// LLM Chain Node
Prompt Type: Define
Text Input: {{ $(''On form submission'').item.json[''First frame description''] }}

System Message:
"You are an expert at generating first frames for AI video generators. 
Use the instructions provided in the prompt to create an image generation 
prompt for a 9:16 ratio product image.

Example inputs:
- A woman is applying the toothpaste onto a toothbrush, standing in 
  front of a bathroom mirror
- A soccer player is shown with the shoes on his feet, he is bending 
  over and tying the laces

For every prompt and image, think about:
- What the product is
- Who is using it  
- How is it typically used
- Where is it typically used
- Why is it typically used

And extrapolate to fill in any missing details.

Output ONLY the prompt"

Model: anthropic/claude-sonnet-4.5 (via OpenRouter)

What Claude Does:

User Input (Minimal):

"woman applying face cream"

Claude''s Enhanced Output:

A woman in her mid-30s with healthy skin stands in a modern bathroom 
with natural window lighting during morning hours. She''s wearing a white 
robe and applying a small amount of premium face cream from an elegant 
jar to her cheekbone with her ring finger, using gentle upward motions. 
Her expression is peaceful and focused on self-care. The bathroom features 
marble countertops and soft neutral tones. Shot from slightly above eye 
level in 9:16 vertical format with the product jar visible and in focus 
on the counter.

Why This Matters:

User provides 4 words, Claude provides 80+

Missing details filled: Age, lighting, setting, motion, framing

Composition guidance: Camera angle, focus, ratio

Brand consistency: "Premium," "elegant," "modern" (customizable per niche)

Customization by Niche:

Skincare Products:

Additional instructions to Claude:
"Emphasize natural lighting, skin texture visible, bathroom or vanity 
setting, peaceful morning or evening atmosphere. Product jar should be 
premium-looking with visible branding."

Fitness Products:

"Emphasize dynamic gym environment, athletic body language, determination 
in expression, equipment in use or being prepared. Bright, energetic 
lighting."

Food Products:

"Emphasize appetite appeal, steam if hot food, fresh ingredients visible, 
kitchen or dining setting, warm inviting lighting, hands interacting 
with food naturally."

OpenRouter Integration

// OpenRouter Chat Model Node (connects to LLM Chain)
Model: anthropic/claude-sonnet-4.5
API Endpoint: Automatically configured by n8n

Credentials:
- Type: Predefined Credential Type
- Select: OpenRouter API
- API Key: [Your OpenRouter key]

Why OpenRouter Instead of Direct Anthropic:

Single API key: Access Claude, GPT, Gemini, Llama, etc.

Pay-as-you-go: No subscriptions, only pay for usage

Model switching: Change one line to test different models

Cost tracking: Unified dashboard for all model costs

Getting OpenRouter Key:

Sign up at openrouter.ai

Add $5-10 credits

Generate API key in dashboard

Paste into n8n credential

Phase 3: First Frame Image Generation

Gemini 2.5 Flash via OpenRouter

// HTTP Request Node - POST to OpenRouter
URL: https://openrouter.ai/api/v1/chat/completions
Authentication: Predefined Credential Type (OpenRouter)
Method: POST
Body Type: JSON

JSON Body:
{
  "model": "google/gemini-2.5-flash-image-preview",
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": "{{ $json.text }}" // Claude''s enhanced prompt
        },
        {
          "type": "image_url",
          "image_url": {
            "url": "{{ $(''Upload Original Image'').item.json.webContentLink }}"
          }
        }
      ]
    }
  ]
}

Why Gemini 2.5 Flash:

Multimodal: Accepts both image and text (sees original product)

Fast: 2-5 second generation time

Cheap: <$0.01 per image

What Gemini Does:

Analyzes original product photo (sees actual product details)

Reads Claude''s enhanced prompt (knows desired composition)

Generates new image that combines product reality with ideal composition

Outputs Base64-encoded PNG

Output Format Issue:

Gemini returns: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA..."
We need: "iVBORw0KGgoAAAANSUhEUgAA..." (pure Base64)

Base64 Processing

// Code Node: "Trim Base64"
let base64String = $input.first().json.choices[0].message.images[0].image_url.url;

// Remove the data URI prefix
if (base64String.startsWith(''data:image/'')) {
  const commaIndex = base64String.indexOf('','');
  if (commaIndex !== -1) {
    base64String = base64String.substring(commaIndex + 1);
  }
}

return [{
  json: {
    base64_data: base64String
  }
}];

Why This Step Exists: Gemini includes metadata prefix. n8n''s Convert to File node needs pure Base64.

Convert to PNG File

// Convert to File Node
Operation: To Binary
Source Property: "base64_data"
Options:
- File Name: "generated_image"
- MIME Type: "image/png"

Output: Binary PNG file ready for Google Drive upload.

Upload First Frame to Google Drive

// Google Drive Upload Node #2
File Name: "first_image"
Drive: My Drive
Folder: Root

Then Share (Same as Original Image):

// Google Drive Share Node #2
File ID: {{ $json.id }}
Role: reader
Type: anyone

Why Upload Again: Sora needs URL to access first frame. Google Drive provides stable, fast CDN-backed URLs.

Phase 4: Sora 2 Video Generation via Kie.ai

Why Kie.ai Instead of Direct OpenAI

The Official Sora API Problem:

OpenAI Requirement: Image resolution must EXACTLY match video output resolution

Example:
- Want portrait video (1080x1920)
- Must provide image at exactly 1080x1920
- Gemini outputs 1024x1824 (close but not exact)
- OpenAI API: REJECTS

Result: Impossible to reliably generate matching resolutions from AI image generators

The Kie.ai Solution:

Kie.ai: Accepts any image resolution, auto-scales to target video resolution

Example:
- Send square image (1024x1024)
- Request portrait video (1080x1920)  
- Kie.ai: ACCEPTS, handles scaling

Result: Zero resolution headaches

Bonus Kie.ai Benefits:

Multi-model access: Same API for Sora, Runway, Kling, Minimax

Model switching: Test different video generators by changing one parameter

Unified billing: One payment method for all video AI models

Better docs: Simpler API than OpenAI''s video endpoint

Kie.ai API Configuration

// HTTP Request Node - POST to Kie.ai
URL: https://api.kie.ai/api/v1/jobs/createTask
Authentication: Generic Credential Type
Type: Bearer Auth
Token: [Your Kie.ai API key]

Method: POST
Body Type: JSON

JSON Body:
{
  "model": "sora-2-image-to-video",
  "input": {
    "prompt": "{{ $(''On form submission'').item.json[''Video Prompt''] }}",
    "image_urls": [
      "{{ $(''Upload First Frame'').item.json.webContentLink }}"
    ],
    "aspect_ratio": "portrait",
    "remove_watermark": true
  }
}

Key Parameters:

Parameter Value Why model sora-2-image-to-video Latest Sora image-to-video model prompt User''s motion description What movement/action you want image_urls First frame URL Starting point for video aspect_ratio portrait 9:16 vertical for social media remove_watermark true Clean output (costs $0.10 vs $0.05 with watermark)

Aspect Ratio Options:

portrait: 9:16 (Instagram Reels, TikTok, YouTube Shorts)

square: 1:1 (Instagram feed)

landscape: 16:9 (YouTube, Facebook)

Getting Kie.ai API Key:

Sign up at kie.ai

Add credits ($10 = 100 videos)

Dashboard → API Keys → Create New

Copy key to n8n credential

Output from This Node:

{
  "data": {
    "taskId": "abc123def456",
    "state": "waiting"
  }
}

Not a video yet—just a task ID. Video generation takes 2-3 minutes.

Phase 5: Video Generation Wait Loop

The Async Processing Problem

Sora generates video: 90-180 seconds
HTTP request timeout: 30 seconds
If we wait synchronously → timeout error

Solution: Poll for completion

1. Submit job (instant response with task ID)
2. Wait 30 seconds
3. Check status
4. If not done → wait 30 more seconds → check again
5. Loop until status = "success"

Wait Node

// Wait Node
Duration: 30 seconds

Why 30 seconds:

Too short (10s): Excessive API calls, rate limiting

Too long (60s): Delays seeing completed videos

30s sweet spot: Checks ~4-6 times per video

Status Check API Call

// HTTP Request Node - GET status
URL: https://api.kie.ai/api/v1/jobs/recordInfo
Authentication: Bearer (same Kie.ai key)
Method: GET

Query Parameters:
- Name: taskId
- Value: {{ $json.data.taskId }} (from Generate Video node)

Output (Status Response):

{
  "data": {
    "state": "waiting",      // or "generating", "success", "fail"
    "taskId": "abc123def456",
    "resultJson": null       // becomes video URL when success
  }
}

Switch Node - Route by Status

// Switch Node
Rules:

Rule 1: Failed
Condition: {{ $json.data.state }} equals "fail"
Output: "Failed" (route to error handling)

Rule 2: Success  
Condition: {{ $json.data.state }} equals "success"
Output: "Success" (route to video extraction)

Rule 3: Waiting
Condition: {{ $json.data.state }} equals "waiting"
Output: "Waiting" (route back to Wait node)

Rule 4: Generating
Condition: {{ $json.data.state }} equals "generating"
Output: "Generating" (route back to Wait node)

Routing Diagram:

Check Status
    ├─→ Success: Continue to video extraction
    ├─→ Failed: Error notification (email/Slack)
    └─→ Waiting/Generating: Loop back to Wait (30s) → Check Status

The Loop:

Generate Video → Wait 30s → Check Status
                    ↑                ↓
                    └─── Waiting ────┘
                    ↑                ↓
                    └─ Generating ───┘
                                     ↓
                                  Success → Continue

Average iterations: 4-6 loops (2-3 minutes total)

Phase 6: Video URL Extraction & Cleanup

Parse Video URL from Response

// Code Node: "Extract URL"
// Get the raw JSON string from input
const resultJsonString = $input.first().json.data.resultJson;

// Parse the string into an object
const result = JSON.parse(resultJsonString);

// Extract the first URL
const resultUrl = result.resultUrls[0];

// Return it as output
return [{ resultUrl }];

Why Code Node Needed:

Raw Kie.ai response:
{
  "data": {
    "resultJson": "{\"resultUrls\":[\"https://cdn.kie.ai/video123.mp4\"]}"
  }
}

We need: "https://cdn.kie.ai/video123.mp4"

Problem: resultJson is a STRING containing JSON, not actual JSON
Solution: Parse string → extract URL

Delete Temporary Files

// Google Drive Delete Node #1
Operation: Delete a file
File: By ID
File ID: {{ $(''Upload First Frame'').item.json.id }}

// Google Drive Delete Node #2  
Operation: Delete a file
File: By ID
File ID: {{ $(''Upload Original Image'').item.json.id }}

Why Clean Up:

Storage management: Generating 100 videos = 200 files without cleanup

Security: Temporary public files should be removed

Organization: Keep Drive clutter-free

Files Deleted:

Original uploaded product photo

AI-generated first frame

File NOT Deleted: Final video (hosted on Kie.ai CDN, not your Drive)

Final Output

// Edit Fields Node
Assignments:
- Name: "Output"
- Value: {{ $(''Code'').item.json.resultUrl }}
- Type: String

Clean Output:

{
  "Output": "https://cdn.kie.ai/videos/abc123/final_video.mp4"
}

What to Do with This URL:

Download: Add HTTP Request (GET) → Save Binary to file

Upload to storage: Google Drive, S3, Dropbox node

Send notification: Email, Slack, Telegram with video link

Update database: Log video URL in Airtable/Notion/Sheets

The Prompt Formula That Actually Works

Formula 1: The Three-Word Benefit

Structure:

[Main benefit] + [Main benefit] + [Main benefit]

Examples:

Pizza cutter: "Sharp. Steady. Clean."
Coffee maker: "Fresh. Fast. Flavorful."
Running shoes: "Grip. Speed. Comfort."
Face cream: "Smooth. Glowing. Youthful."

Why This Works:

Sora focuses on ONE thing at a time: Three benefits = three moments

Clear motion cues: Each word implies specific visual

Emotional resonance: Benefits sell better than features

What Sora Generates:

"Sharp. Steady. Clean." (pizza cutter)

Shot 1 (0-3s): Extreme close-up of blade slicing through crust
Shot 2 (3-6s): Medium shot of steady hand maintaining control  
Shot 3 (6-10s): Wide shot of perfect slices, no mess on board

Formula 2: Who + Action + Emotion

Structure:

[Person] + [Action] + [Emotion]
Maximum 15 words total

Examples:

Toothpaste: "Man refreshing breath, confident before date"
Running shoes: "Athlete testing grip, gym floor"
Skincare: "Woman applying serum, glowing skin, bathroom"
Pillow: "Person waking up, rested smile, bedroom"
Coffee: "Barista pouring latte art, satisfied customer"

Why This Works:

Who (Demographic):

Tells Sora the age, gender, setting

Establishes aspirational identification

"Man" vs "Athlete" vs "Executive" = different visuals

Action (Product Interaction):

Defines the main motion

Product is BEING USED (not just sitting there)

Action implies benefit without stating it

Emotion (The Sell):

Transforms demo into ad

Shows the outcome/feeling

Makes viewer want that emotional state

Bad Prompt:

"Show a pizza cutter cutting pizza with a person holding it 
and the person is happy and the kitchen is nice"

Good Prompt (Formula 2):

"Chef slicing pepperoni pizza, satisfied smile"

Sora interprets:

Who: Chef (experienced, trustworthy)

Action: Slicing pizza (product in use)

Emotion: Satisfied (benefit achieved)

Formula 3: The Context-Heavy Approach

For complex products needing explanation:

[Setting] + [User] + [Product interaction] + [Visible benefit]

Example (Ergonomic keyboard):

"Home office. Professional typing. Wrists natural position. Comfortable workday."

Why Sometimes You Need More:

Products with unique use cases

B2B products requiring context

Technical products where environment matters

Advanced Customization Strategies

Niche-Specific Prompt Templates

Skincare Products:

First Frame Description Template:
"[Age range] [gender] with [skin type] applying [product] to [face area] 
in [bathroom/vanity] with [natural/soft] lighting during [morning/evening]. 
Expression is [peaceful/focused/satisfied]. Product packaging visible, 
[premium/natural/medical] aesthetic. Shot from [eye level/slightly above] 
in 9:16 format."

Claude System Prompt Addition:
"For skincare, emphasize: natural window lighting, visible skin texture, 
premium product packaging, peaceful self-care atmosphere, bathroom or 
bedroom vanity setting."

Fitness Equipment:

First Frame Description Template:
"[Athletic/fit] [gender] [age] using [product] in [gym/home gym] during 
[workout type]. [Determined/focused] expression, [specific muscle groups] 
visible. Equipment in [active use/preparation]. Bright, energetic lighting. 
9:16 vertical format."

Claude System Prompt Addition:
"For fitness, emphasize: dynamic poses, athletic body language, gym 
environment, determination in expression, equipment actively being used, 
bright motivational lighting."

Food & Beverage:

First Frame Description Template:
"[Dish/drink] being [prepared/served/consumed] by [chef/barista/person]. 
[Steam/condensation/fresh ingredients] visible. [Kitchen/cafe/dining] 
setting with [warm/natural] lighting. Hands [interacting naturally]. 
[Appetite appeal/comfort/indulgence] mood."

Claude System Prompt Addition:
"For food, emphasize: appetite appeal, visible steam if hot, fresh 
ingredients, hands naturally interacting, warm inviting lighting, 
focus on textures and colors."

Multi-Variation Generation Strategy

Batch Testing Approach:

Same product photo + 10 different prompts = 10 video variations
Test matrix:

Emotion Variants:
1. "Confident executive"  
2. "Peaceful morning routine"
3. "Energetic workout"

Setting Variants:
4. "Modern office"
5. "Cozy bedroom"
6. "Minimalist bathroom"

Action Variants:
7. "Applying carefully"
8. "Quick demonstration"
9. "Satisfying reveal"

Demographic Variants:
10. "Woman in 30s"

Testing Process:

Generate all 10 variants (total cost: $1.12)

Post to Instagram Reels (unlisted)

Check view rate + completion rate after 24 hours

Winner = highest completion rate

Use winning prompt formula for scaled production

Real Example Results:

Variation 1 "Confident executive" → 23% completion rate
Variation 3 "Energetic workout" → 67% completion rate
Variation 7 "Applying carefully" → 45% completion rate

Winner: #3
Action: Generate 20 more videos using "energetic workout" angle

Production Deployment Strategies

Strategy 1: Form-Based Service

Use Case: Agency offering video generation service

Setup:

Activate workflow in n8n

Copy Production URL from form trigger

Embed form on agency website

Client uploads photo + submits prompts

Receives video URL via email (add email node)

Pricing Model:

Your cost: $0.11 per video
Client charge: $50 per video (bulk discounts)
Profit margin: $49.89 per video (45,336%)

Package options:
- Single video: $50
- 5-video pack: $200 ($40 each, still 36,263% margin)
- 20-video pack: $600 ($30 each, still 27,173% margin)

Strategy 2: Bulk CSV Processing

Use Case: Catalog of 100+ products

Setup:

Google Sheet with columns:
- Product Image URL
- First Frame Description
- Video Prompt
- Status (Pending/Complete)

n8n workflow:
1. Read sheet (filter: Status = Pending)
2. Process first row
3. Generate video
4. Update Status = Complete
5. Schedule to run every 5 minutes

Result: Processes entire catalog automatically

Troubleshooting & Common Issues

Issue 1: Gemini Returns Malformed Base64

Symptoms: Convert to PNG node fails with "Invalid Base64" error

Diagnostic:

// Add Code node before "Trim Base64" to inspect output
console.log("Raw output:", $input.first().json);
return $input.all();

Common Causes:

Gemini returned error message instead of image

Base64 string truncated (network timeout)

Unexpected response format

Solution:

// Enhanced Trim Base64 with error handling
let base64String = $input.first().json.choices[0].message.images[0].image_url.url;

if (!base64String || base64String.length < 100) {
  throw new Error("Invalid or empty Base64 response from Gemini");
}

// Rest of trimming logic...

Issue 2: Sora Generation Gets Stuck in "Generating"

Symptoms: Status check loops forever, never reaches "success" or "fail"

Diagnostic:

After 10+ minutes (20+ loops):
- Check Kie.ai dashboard for task status
- Task may have actually failed but API not reflecting it

Solution:

// Add timeout logic to Switch node
// Add 5th route:

Rule 5: Timeout
Condition: {{ $json.loop_count }} greater than 15
Output: "Timeout" (route to error handling)

// Track loop count with Set Variable node before Wait:
Variable Name: loop_count  
Value: {{ $json.loop_count + 1 || 1 }}

Issue 3: First Frame Quality Poor

Symptoms: Video is smooth but product looks amateurish

Root Cause: Claude''s prompt optimization wasn''t specific enough

Solution: Enhance Claude''s System Prompt

Add to system message:
"For product videos, always include:
- Specific lighting type (soft natural, studio, golden hour)
- Camera angle (slightly above, eye level, low angle)
- Background simplicity (clean, minimal distractions)
- Product positioning (centered, rule of thirds, foreground focus)
- Brand premium indicators (marble, wood grain, modern aesthetic)"

Agency Productized Service

Service Offering: "Video Ad Generation as a Service"

Pricing Tiers:

Starter: $297/month
- 10 videos per month
- Standard templates
- 48-hour turnaround
Your cost: $1.12/month
Profit: $295.88/month per client

Growth: $697/month  
- 30 videos per month
- Custom prompt optimization
- 24-hour turnaround
Your cost: $3.36/month
Profit: $693.64/month per client

Scale: $1,497/month
- 100 videos per month
- Dedicated prompt engineering
- Priority processing
Your cost: $11.20/month
Profit: $1,485.80/month per client
Agency Math:

10 Starter clients: $2,958.80/month profit
5 Growth clients: $3,468.20/month profit
2 Scale clients: $2,971.60/month profit
Total: $9,398.60/month profit

Your time investment:
- Setup: 1 hour per client (one-time)
- Monthly management: 2 hours total (all clients)
Effective hourly rate: $4,699/hour
Affiliate Marketing Amplification

Use Case: Promoting affiliate products

Traditional Approach:

Use manufacturer''s stock photos
Low engagement (everyone uses same images)
Conversion rate: 1-2%
Video Automation Approach:

Generate unique video for each affiliate product
Your videos stand out in feed
Conversion rate: 4-6% (video outperforms static 3-5x)

Example:
Affiliate link clicks: 1,000/month
Traditional conversion: 1.5% = 15 sales
Video conversion: 4.5% = 45 sales
Commission per sale: $20
Revenue increase: 30 × $20 = $600/month
Video generation cost: $0.11 × 10 products = $1.12/month
Net profit increase: $598.88/month

Advanced Techniques

Technique 1: Product Reveal Sequence

Concept: Generate 3 videos that tell a story

Workflow Modification:

Video 1: "Teaser"
First Frame: Product in shadow/silhouette
Prompt: "Mysterious lighting reveal, curiosity building"

Video 2: "Feature Focus"
First Frame: Product in use, specific feature highlighted
Prompt: "Close-up detail, benefit demonstration"

Video 3: "Lifestyle Context"
First Frame: Happy user with product in natural setting
Prompt: "Satisfied expression, aspirational lifestyle"

Use case: Instagram Reels series
Post over 3 days to build anticipation
Implementation:

javascript

// Modify Form Trigger to accept:
- Video Type: Teaser / Feature / Lifestyle
- Adjust prompts dynamically based on type

// In Claude prompt optimization:
if (videoType === "Teaser") {
  additionalInstructions = "dramatic shadows, mystery, curiosity"
} else if (videoType === "Feature") {
  additionalInstructions = "bright lighting, close-up, detail focus"
}
Technique 2: Seasonal Variation Generator

Concept: Same product, different seasonal contexts

Example (Coffee Maker):

Spring: "Morning coffee, open window, fresh flowers visible"
Summer: "Iced coffee pour, bright sunshine, refreshing atmosphere"
Fall: "Warm mug, cozy sweater, autumn colors background"
Winter: "Steaming coffee, snow outside window, comfort focus"

Generate 4 versions, schedule throughout year
Maintain relevance without reshooting
Technique 3: Aspect Ratio Variants

Concept: One product photo → 3 aspect ratios

Modification:

javascript

// In Kie.ai Generate Video call:
Loop through aspect ratios:
- Portrait (9:16) for Reels/TikTok/Shorts
- Square (1:1) for Instagram feed
- Landscape (16:9) for YouTube ads

// Generates 3 videos per product
Cost: $0.33 (3 × $0.11)
Covers all platform requirements

Prompting Masterclass: Before & After

Example 1: Pizza Cutter

❌ Bad Prompt (Everyone''s Mistake):

First Frame: "Pizza cutter"
Video Prompt: "Show pizza cutter cutting pizza"
Result: Morphing cutter, inconsistent product, unnatural motion

✅ Good Prompt (Formula Applied):

First Frame: "Professional chef''s hand holding sleek stainless steel 
pizza cutter positioned above a fresh pepperoni pizza on wooden board. 
Restaurant kitchen background slightly blurred. Warm overhead lighting. 
Shot from 45-degree angle in 9:16 format showing both cutter detail 
and full pizza."

Video Prompt: "Sharp. Steady. Clean."
Result: Smooth cutting motion, cheese stays in place, professional aesthetic

Example 2: Face Serum

❌ Bad Prompt:

First Frame: "Woman with face cream"
Video Prompt: "Apply cream to face"
Result: Generic, could be any product, no emotional connection

✅ Good Prompt:

First Frame: "Woman in mid-30s with dewy skin standing at marble 
bathroom vanity in soft morning window light. She''s holding an elegant 
glass dropper bottle of facial serum, applying one drop to her fingertip. 
Expression is peaceful and focused. Product bottle on counter with 
visible premium branding. Shot slightly above eye level in 9:16 format."

Video Prompt: "Woman applying serum, glowing skin, bathroom"
Result: Aspirational lifestyle shot, product looks premium, clear benefit (glowing skin)

Example 3: Running Shoes

❌ Bad Prompt:

First Frame: "Running shoes"  
Video Prompt: "Someone running"
Result: Shoes might change color, person might morph, chaotic motion

✅ Good Prompt:

First Frame: "Athletic man in gym attire crouched down tying bright 
running shoe laces on polished gym floor. Other shoe already tied. 
Gym equipment slightly visible in background. Bright, energetic 
lighting from above. Determination in body language. Shot from 
low angle emphasizing shoes in 9:16 format."

Video Prompt: "Athlete testing grip, gym floor"
Result: Shoe remains consistent, focused on product benefit (grip), athletic context clear

Assignment: Build Your Video Generator

Phase 1: Basic Setup (45 minutes)

Create form trigger with 3 fields

Set up Google Drive upload + share

Configure Claude prompt optimization (OpenRouter)

Test: Submit form, verify Claude enhances prompt

Success Metric: Claude takes "coffee maker" and outputs 80+ word detailed prompt

Phase 2: Image Generation (30 minutes)

Add Gemini 2.5 Flash API call (via OpenRouter)

Implement Base64 trimming code node

Convert Base64 to PNG file

Upload first frame to Google Drive + share

Test: Submit form with simple product photo

Success Metric: AI-generated first frame shows product in professional composition

Phase 3: Video Generation (30 minutes)

Sign up for Kie.ai, add $10 credits

Configure Generate Video API call

Implement Wait → Status Check → Switch loop

Test: Wait for video to generate (2-3 minutes)

Extract video URL with code node

Success Metric: Receive working video URL with motion applied to first frame

Phase 4: Production Polish (30 minutes)

Add Google Drive cleanup (delete 2 temporary files)

Add final output formatting (Edit Fields node)

Optional: Add email notification with video link

Test full workflow end-to-end

Time how long it takes (should be ~3 minutes)

Success Metric: Complete workflow runs, outputs video URL, cleanup verified

Challenge Assignment: Batch Generation

Create Google Sheet with 10 product photos + prompts

Modify workflow to read from sheet instead of form

Add loop to process all rows

Schedule to run every 5 minutes

Generate all 10 videos automatically

Success Metric: 10 videos generated unattended, cost = $1.12 total

Key Takeaways

Technical Mastery: 

✅ Two-stage generation strategy (Gemini first frame + Sora motion) 

✅ Async processing with wait loops and status polling 

✅ Base64 encoding/decoding for image APIs 

✅ Multi-API orchestration (Claude, Gemini, Sora via 3 services) 

✅ Resource cleanup and workflow hygiene

Business Impact: 

✅ $0.15 per video vs $2,000+ traditional production (1,818,082% savings) 

✅ 3-minute generation time vs 4-6 weeks (33,600x faster) 

✅ 47 variations in 20 minutes enables true A/B testing at scale 

✅ Agency service potential: $9,400/month profit with 2 hours work 

✅ E-commerce transformation: $120k/year revenue increase for $27.50 investment

Strategic Positioning: 

✅ First frame quality determines final video quality—invest in optimization 

✅ Prompt formulas (3-word benefit, Who+Action+Emotion) consistently outperform verbose descriptions 

✅ Kie.ai solves OpenAI''s resolution matching nightmare 

✅ Batch processing + A/B testing unlocks performance optimization impossible with traditional production 

✅ Cost structure enables experimentation—test 10 angles for price of 1 stock photo

The revolution isn''t that AI can generate videos—it''s that AI makes video generation so cheap that you can test 47 variations to find the one that converts. Traditional production forces you to "nail it in one shot." AI production lets you try 47 shots and pick the winner. That''s not efficiency—that''s a completely different game. Master this workflow, and you''re not just saving money on video production. You''re unlocking creative experimentation that was financially impossible before. The constraint was never talent—it was cost. AI removes the constraint. Now the question is: what will you test that you couldn''t afford to test before?', 3),
  ('f17e53de-ea0a-4c22-94e7-2c5b1816ba22', '3d33f659-dabf-42f2-80b2-5af321653fdb', 'AI Pinterest Automation', 'Lesson Overview

Build a complete Pinterest posting system that transforms Google Sheets data into professionally designed pins with AI-generated images and descriptions. This workflow automatically creates visually branded content, posts to Pinterest, and tracks what''s been published—all without manual image editing or logging into Pinterest.

Time to Complete: 60 minutes Difficulty: Intermediate Tools Required: Make.com, Google Sheets, OpenAI API, Replicate (Flux), RenderForm, Pinterest API Time/Value Transformation: Manual pin creation (30-45 minutes per pin) → Automated generation (2 minutes per pin, fully hands-off)

The Content Marketing Problem

Traditional Pinterest Posting Reality

Content planning: 15 minutes (brainstorming ideas)

Design work in Canva: 20-30 minutes per pin

Writing descriptions: 10 minutes

Manual upload to Pinterest: 5 minutes

Tracking what''s posted: Manual spreadsheet updates

Total per pin: 50-60 minutes

Monthly cost (10 pins): 8-10 hours of work

AI-Powered Solution

Batch content planning: 5 minutes (ChatGPT generates 100 ideas)

Automated image generation: 30 seconds

AI-written descriptions: 10 seconds

Auto-post to Pinterest: Instant

Auto-tracking in spreadsheet: Automatic

Total per pin: 2 minutes (all automated)

Monthly cost (60 pins): Zero manual work

The Transformation: From spending hours in Canva per pin to setting a schedule and letting AI handle everything. From 10 pins per month to 60+ pins with less effort.

System Architecture Overview

Multi-Stage Content Factory Pipeline

Google Sheets (Content Queue)
    ↓
Filter for Unposted Rows (Status = FALSE)
    ↓
ChatGPT: Generate Image Prompt
    ↓
Replicate Flux: Generate Pinterest Image
    ↓
Template Randomization (Visual Variety)
    ↓
RenderForm: Overlay Text on Image
    ↓
ChatGPT: Generate Pin Description
    ↓
Pinterest API: Create Pin
    ↓
Update Sheet: Mark as Posted

Cost Breakdown Per Pin

Image Generation (Flux Schnell): $0.001 per image

AI Prompts (GPT-4o): ~$0.002 per pin (2 API calls)

RenderForm: $0.09 per image ($9/100 credits)

Pinterest API: FREE

Make.com: $9/month (10,000 operations)

Total per pin: $0.10

At 60 pins per month: $6 in API costs + $9 Make.com = $15/month total Manual equivalent: 10 hours × $50/hour = $500/month opportunity cost

ROI: 3,233%

Phase 1: Content Strategy Database

Google Sheets Structure

Sheet 1: "Quotes" (Main Content)
Columns:
- Title (A): Main quote or headline
- Quote (B): Full text content
- URL (C): Optional link destination
- Used? (D): FALSE (unposted) / TRUE (posted)
- Image URL (E): Generated image URL (auto-filled)
- Description (F): AI-generated description (auto-filled)

Sheet 2: "Templates" (Design Variations)
Column A: RenderForm template IDs
- Template 1 ID
- Template 2 ID
- Template 3 ID (add unlimited templates)

Why This Structure:

Status column (D) acts as workflow trigger—only processes FALSE rows

Tracking columns (E, F) maintain complete records of what was generated

Separate templates sheet enables visual variety without code changes

Batch Content Generation

Use ChatGPT to generate 100 content ideas instantly:

Prompt:

Generate 100 inspirational quotes about health, fitness, and wellness. 
Format as a table with two columns: Title and Quote. Output as markdown 
table so I can paste directly into Google Sheets.

Tool: Use Markdown to Google Sheets converter (docs-to-markdown.com) to transform ChatGPT''s markdown table into copy-pasteable format.

Result: 100 rows of content ready to automate in under 5 minutes.

Key Technical Points:

Set all "Used?" cells to FALSE initially

Templates sheet requires no headers

Make.com will automatically pull template IDs from this range

Phase 2: Workflow Trigger & Data Pull

Google Sheets Filter Module

// Make.com: Google Sheets - Search Rows
Spreadsheet: Pinterest Pins
Sheet: Quotes
Filter: Column D (Used?) equals FALSE
Limit: 1 row
Sort: Row number (ascending)

Why This Configuration:

Filter by FALSE: Only processes unpublished content

Limit 1: Generates one pin per execution (prevents API rate limit issues)

Ascending sort: Processes content in order from top to bottom

Business Logic: This single filter prevents duplicate posts and enables you to add 100 new rows anytime—workflow automatically queues them.

Set Variables for Reusability

// Make.com: Set Variables Module
Variable 1: Title = {{Column A}}
Variable 2: Quote = {{Column B}}
Variable 3: Combined = {{Title}}-{{Quote}}

Why Variables: Referenced throughout workflow without repeatedly mapping from Google Sheets module. Clean, maintainable code.

Phase 3: AI Image Prompt Generation

ChatGPT Prompt Engineering for Visual Assets

// OpenAI Create Completion Module
Model: gpt-4o (or gpt-4o-mini for cost savings)
Role: User
Content:
"You are a prompt writer.

You will be given a quote or piece of text. Based on this text you will 
produce a descriptive prompt for image generation.

Do not include anything other than the text, and do not add a new line 
at the end of the text.

You must use the below guidelines to create the prompt.

Exclude characters such as double quotes (\"), slashes (/), or certain 
Unicode characters. Do not include any text overlays in the image.

----
Describe the person, including hair style, facial features, expressions, 
and any accessories or objects they are holding or interacting with.

Example: "A charismatic speaker with short, tousled brown hair that''s 
slightly messy on top, a round face, clean-shaven, and wearing rounded 
rectangular-framed glasses with dark rims. He is animated, gesturing 
with his left hand and holding a black microphone in his right."
----

This is the text: {{Combined}}"

Role: System
Content: "Output as JSON: {\"prompt\": \"text\"}"

Response Format: JSON Object
Parse JSON Response: Yes

Why This Prompt Works:

Explicit format instructions: "Do not include text overlays" prevents AI from trying to add words to image

Detailed example: Shows AI the level of descriptive detail needed

JSON output: Structured response makes it easy to extract just the prompt

Character exclusions: Prevents malformed prompts that break image generators

Output Example:

{
  "prompt": "A determined woman in athletic wear mid-workout, sweat glistening on her forehead, hair pulled back in a tight ponytail, gripping dumbbells with focused intensity in a modern gym with natural lighting"
}

Phase 4: Image Generation via Replicate

Flux Schnell API Call

// HTTP Request Module - POST to Replicate
URL: https://api.replicate.com/v1/models/black-forest-labs/flux-schnell/predictions
Method: POST
Headers:
- Authorization: Bearer YOUR_REPLICATE_API_KEY

Body (JSON):
{
  "input": {
    "prompt": "{{ChatGPT output: result.prompt}}",
    "go_fast": true,
    "megapixels": "1",
    "num_outputs": 1,
    "aspect_ratio": "1:1",
    "output_format": "webp",
    "output_quality": 80,
    "num_inference_steps": 4
  }
}

Why Flux Schnell:

Fastest model: 4 inference steps vs 25+ for other models

Cheapest option: $0.001 per image

1:1 aspect ratio: Square format works on all Pinterest boards

WebP format: Smaller file sizes, faster uploads

Critical Detail: This POST request returns a urls.get field—not the actual image yet. Replicate processes asynchronously.

Sleep Module (Wait for Generation)

// Sleep Module
Duration: 15 seconds

Why 15 Seconds: Flux Schnell typically generates in 5-10 seconds, but API response time varies with server load. 15 seconds is conservative buffer.

Retrieve Generated Image

// HTTP Request Module - GET from Replicate
URL: {{Previous HTTP Request: data.urls.get}}
Method: GET
Headers:
- Authorization: Bearer YOUR_REPLICATE_API_KEY

Output: data.output[] contains the direct URL to your generated image, ready for RenderForm.

Key Technical Points:

Do NOT download the image file—work with URLs only

Image is automatically hosted on Replicate''s CDN

URL remains accessible for 24 hours (plenty of time for workflow)

Phase 5: Template Randomization System

Pull All Template IDs

// Google Sheets - Get Range Values
Spreadsheet: Pinterest Pins
Sheet: Templates
Range: A1:A3 (or A1:A10 if you have 10 templates)
Contains Headers: No

Output: Array of template IDs like:

[
  "template-id-1",
  "template-id-2", 
  "template-id-3"
]

Array Aggregator

// Array Aggregator Module
Source Module: Get Range Values
Target Structure: Custom
Field to Aggregate: Column A values

What This Does: Converts multiple rows into a single array that can be randomly indexed.

Random Number Generator

// Set Variable Module
Variable Name: randomNumber
Value: {{floor(random * ArrayLength) + 1}}

The Math:

random = decimal between 0-1

Multiply by array length (e.g., 3 templates)

floor() rounds down

Add 1 (arrays are 1-indexed in Make.com)

Result: Random integer between 1 and template count

Select Random Template

// Set Variable Module  
Variable Name: template
Value: {{get(TemplateArray; randomNumber)}}

Output: One randomly selected template ID from your array.

Why Randomization Matters: Pinterest''s algorithm favors accounts that post diverse visual content. Same template every time = algorithmic penalty. Random selection = natural variety.

Phase 6: RenderForm Image Composition

RenderForm Setup (One-Time)

Sign up at renderform.io (50 free credits)

Create template with these elements:
Background image layer (ID: image.src)

Title text layer (ID: title.text)

Quote text layer (ID: subtitle.text)

Customize fonts, colors, positioning

Copy template identifier from URL

RenderForm API Call

// RenderForm - Render Image Module
Template Identifier: {{Selected template from Set Variable}}
Template Properties:
- image.src: {{Replicate image URL}}
- title.text: {{Title variable}}
- subtitle.text: {{Quote variable}}

What Happens:

RenderForm downloads your Replicate image

Overlays title and quote text with your font styling

Returns final composed image as URL

Output: href field contains URL to final Pinterest-ready image.

Cost: $0.09 per render at $9/100 credits tier.

Key Technical Points:

Template IDs must match exactly (case-sensitive)

Text layers auto-resize to fit content

Final image cached on RenderForm CDN for 30 days

Phase 7: AI Description Generation

ChatGPT Pinterest Copywriting

// OpenAI Create Completion Module
Model: chatgpt-4o-latest (or gpt-4o-mini)
Role: User
Content:
"You are an expert at Pinterest marketing. Write an informational, 
captivating pin description for a pin that expands on the following 
quote: {{Combined}}. 

The pin does not link to anywhere else, so the description must be 
self-contained. 

Output ONLY the description in 400 characters or less, and nothing else."

Role: System  
Content: "Output as JSON: {\"description\": \"text\"}"

Response Format: JSON Object
Parse JSON Response: Yes

Why This Prompt Works:

Pinterest-specific expertise: AI understands platform conventions

400 character limit: Pinterest''s recommended length for mobile display

Self-contained: No call-to-action to external links (increases Pinterest distribution)

JSON output: Clean extraction, no parsing errors

Output Example:

{
  "description": "Transform your fitness journey one rep at a time. This powerful reminder keeps you motivated when the weights feel heavy and the path ahead seems long. Progress isn''t about perfection—it''s about showing up consistently and giving your best effort every single day. 💪 #FitnessMotivation #WorkoutInspiration #HealthyLiving"
}

Key Technical Points:

AI automatically adds relevant hashtags

Tone matches Pinterest''s inspirational style

Character count stays within mobile-friendly range

Phase 8: Pinterest API Integration

Create Pin Module

// Pinterest - Create Pin
Connection: Your Pinterest OAuth connection
Media Source:
- Source Type: Image URL
- Image URL: {{RenderForm: href}}
- Is Standard: Yes

Board: Select from dropdown (e.g., "Business Inspiration")
Title: {{Title variable}}
Description: {{ChatGPT description output}}
Alt Text: {{Same as description for accessibility}}
Link: {{URL from Google Sheets Column C}}

Pinterest API Setup:

Go to Pinterest Developers

Create new app

Get OAuth credentials

Add to Make.com connection

Board Selection: Create themed boards beforehand. Workflow can post to different boards based on content category (advanced: add board column to spreadsheet).

Why Image URL vs Upload:

Faster processing (no file transfer)

Less Make.com data usage

Pinterest fetches directly from RenderForm CDN

Output: Pin ID and Pinterest URL of published pin.

Phase 9: Spreadsheet Tracking

Update Image URL and Description

// Google Sheets - Update Row
Spreadsheet ID: {{From initial Google Sheets filter}}
Sheet Name: {{From initial filter}}
Row Number: {{From initial filter}}
Column Range: A1:Z1

Values to Update:
- Column E (Image URL): {{RenderForm: href}}
- Column F (Description): {{ChatGPT: result.description}}

Why Track These: Maintains complete audit trail. You can review what was generated, reuse successful descriptions, or manually adjust before next run.

Mark as Posted

// Google Sheets - Update Row
Spreadsheet ID: {{From initial Google Sheets filter}}
Sheet Name: {{From initial filter}}
Row Number: {{From initial filter}}
Column Range: A1:Z1

Values to Update:
- Column D (Used?): TRUE

Critical: This update prevents the same row from being processed twice. Next execution automatically grabs the next FALSE row.

Key Technical Points:

Use two separate Update Row modules for clarity

Both reference original Google Sheets filter data

Updates happen sequentially (first tracking, then status)

Business Applications & ROI

Pinterest Growth Strategy

Before Automation:

10 pins per month (limited by time)

Inconsistent posting schedule

Generic stock images

Stagnant follower growth

After Automation:

60+ pins per month (2 per day on schedule)

Consistent daily presence (algorithm boost)

Brand-specific visual style

3-5x follower growth rate (industry average with consistent posting)

Agency Productized Service

Offer: Pinterest Management $297/month

Your setup time: 90 minutes once

Your monthly time: 30 minutes (content planning + QA)

Your cost: $15/month (API + Make.com)

Profit margin: $282/month per client

At 10 clients: $2,820/month profit with 5 hours total work.

E-commerce Integration

Modification: Add product data to spreadsheet

Column G: Product URL

Column H: Product Price

Pinterest Pin links to product page

Track which pins drive sales via Pinterest Analytics

Result: Automated product marketing funnel.

Content Repurposing Engine

Workflow Extension:

Same quotes generate Twitter graphics (different templates)

Instagram story format (9:16 aspect ratio)

LinkedIn carousel posts (multi-image)

One spreadsheet → Multiple platforms automatically.

Advanced Customizations

Multi-Board Smart Routing

// Add to Google Sheets: Column G "Category"
// Add Router Module after description generation
// Route based on category:
- Fitness → Workout Board
- Nutrition → Healthy Eating Board  
- Mindset → Motivation Board

A/B Testing Descriptions

// Generate 2 descriptions per pin
// Post same image with Description A and Description B
// Track engagement after 7 days
// Feed high-performing patterns back to prompt

Seasonal Template Rotation

// Add date logic in template selection
// January-March: Winter color palette templates
// April-June: Spring themes
// Automatic visual refresh without manual changes

Video Pin Support

// Replace Flux with video generation API (e.g., Runway)
// Animated quote text over video background
// Higher engagement rates (3-5x static images)

Canva API Integration (Alternative to RenderForm)

// If you have Canva Pro + API access
// Use Canva templates instead of RenderForm
// More design flexibility
// Higher cost ($12.99/month minimum)

Troubleshooting & Common Issues

Issue 1: Replicate Image Generation Times Out

Problem: Sleep module waits 15 seconds but image still not ready Solution:

Increase sleep duration to 20-30 seconds

Add error handler: If GET request fails, wait another 10 seconds and retry

Check Replicate status page for API slowdowns

Issue 2: RenderForm Text Overflows Template

Problem: Long quotes get cut off or overlap Solution:

Add character limit to ChatGPT quote generation prompt: "Keep quotes under 150 characters"

Use RenderForm''s auto-resize feature (enable in template settings)

Create separate templates for long vs short quotes

Issue 3: Pinterest API Rate Limiting

Problem: "Too many requests" error when posting multiple pins quickly Solution:

Add 5-minute sleep between Pinterest API calls

Pinterest limit: 200 requests per hour per app

Batch processing: Run workflow 3 times per day instead of 60 times

Issue 4: Google Sheets Not Updating Status

Problem: Same row processes twice, duplicate pins created Solution:

Verify Column D is exactly "TRUE" (not "True" or "true")

Check filter condition uses text comparison, not boolean

Add unique constraint: Search for existing image URL before posting

Issue 5: Random Template Selection Always Picks First Template

Problem: Math formula returns same template repeatedly Solution:

Verify array aggregator output structure

Check if randomNumber variable is actually random (test 10 runs)

Replace with sequential rotation: Pick Template (Row % Template Count) + 1

Issue 6: ChatGPT Returns Prompt as Plain Text, Not JSON

Problem: "Cannot parse response" error in Make.com Solution:

Verify "Response Format: JSON Object" is selected

Add to system prompt: "ONLY output valid JSON, no additional text"

Use GPT-4o or GPT-4o-mini (GPT-3.5 less reliable with structured output)

Assignment: Build Your Pinterest Factory

Phase 1: Foundation Setup (20 minutes)

Create Google Sheet with 10 content ideas (use ChatGPT to generate)

Add "Templates" sheet with 1-2 RenderForm template IDs

Set up Make.com scenario with Google Sheets trigger

Test filter: Verify it pulls only FALSE rows

Success Metric: Scenario correctly identifies and outputs first unpublished row

Phase 2: Image Pipeline (25 minutes)

Configure OpenAI module with image prompt generation

Set up Replicate API calls (POST + Sleep + GET)

Test: Generate one image from your first row

Verify image URL is valid and accessible

Success Metric: Generated image displays correctly when opening URL

Phase 3: Template System (15 minutes)

Create 2-3 Pinterest templates in RenderForm with text layers

Implement random template selection logic

Configure RenderForm API call with dynamic template + text

Test: Generate final branded pin image

Success Metric: Text overlays correctly on random template

Advanced Challenge: Full Automation

Add Pinterest API integration and post first pin

Implement description generation module

Add both tracking updates (image URL + status TRUE)

Set schedule: Run every 12 hours

Let it run for 1 week, review results

Success Metric: 14 pins posted automatically with zero manual intervention

Resources & Templates

Complete System Package

Full Make.com Blueprint JSON - Import and configure with API keys

Google Sheets Template - Pre-formatted with formulas

RenderForm Template Designs - 5 starter Pinterest templates

ChatGPT Prompt Library - Variations for different niches

API Setup Guides

Replicate Account - $5 credit setup + Flux model access

RenderForm Template Builder - Step-by-step design tutorial

Pinterest Developer Portal - OAuth app creation walkthrough

Niche-Specific Adaptations

Fitness/Health: Template styles + quote collections

Business/Productivity: Professional color palettes

Food/Recipe: Recipe card templates

Travel/Lifestyle: Destination inspiration templates

Key Takeaways

Technical Mastery: ✅ Multi-API orchestration (5 different services) ✅ Asynchronous processing with strategic wait times ✅ Random selection algorithms for content variety ✅ JSON structured output for reliable parsing ✅ Stateful workflow with spreadsheet tracking

Business Impact: ✅ $0.10 per pin vs $50/hour manual design work ✅ 60 pins per month vs 10 with manual process ✅ Zero ongoing work after initial 60-minute setup ✅ $282/month profit per client for agency model ✅ 3-5x growth rate with consistent Pinterest presence

Strategic Positioning: ✅ Pinterest algorithm rewards consistent posting (achieved automatically) ✅ Visual variety through random templates (appears human-managed) ✅ Complete audit trail enables performance analysis ✅ Infinitely scalable—add 1000 rows, workflow handles it ✅ Multi-platform ready (same system for Instagram, Twitter, LinkedIn)', 4),
  ('49ae8007-3448-4131-9cbc-491771a3176c', '3d33f659-dabf-42f2-80b2-5af321653fdb', 'Unlimited Static Ad Variations w/ Nano Banana Pro', 'Build a conversational AI system that transforms product photos into professional static advertisements through guided brainstorming. Chat with an AI ad expert, refine your concept together, then generate the actual ad image - all within a single conversation interface.

Time to Complete: 60 minutes 

Difficulty: Advanced 

Tools Required: n8n, OpenRouter (Claude + Gemini), Google Drive 

Cost per Ad: ~$0.15-0.30 (vs $50-200 traditional design)

The Business Case: Why This Matters

Traditional Static Ad Costs

Graphic designer: $50-200 per ad

Multiple variations: $500-1,500 for a campaign

Time investment: 2-5 days per concept

Revision cycles: Back-and-forth delays

AI-Assisted Ad Generation

Cost per ad: $0.15-0.30 (API calls only)

Speed: 5-10 minutes per finished ad

Iterations: Unlimited brainstorming at no extra cost

Control: You guide the creative direction

ROI Example: E-commerce store testing 20 ad variations per product = $1,000+ traditional vs $6 AI-generated = 99% cost savings. More importantly, you can test angles you''d never pay a designer to try.

Step 1: Understanding the Architecture

The Two-Workflow System

This build uses a parent-child workflow pattern - a powerful technique for complex automations.

Parent Workflow: The Brainstorm Agent

Chat Trigger
├── AI Agent (Claude Sonnet 4.5)
│   ├── Memory (conversation history)
│   ├── Nested Agent Tool (prompt writer)
│   └── Workflow Tool (calls child workflow)
└── Returns generated ad link
Child Workflow: The Image Factory

Execute Workflow Trigger
├── Switch (1 or 2 reference images?)
├── HTTP Request to Gemini
├── Base64 Processing
├── Google Drive Upload
└── Returns shareable link
Why Split It?

The brainstorm agent needs conversational memory

Image generation is a discrete, repeatable task

You can reuse the image factory for other workflows

Easier to debug and maintain

Step 2: OpenRouter Setup

Why OpenRouter?

OpenRouter gives you access to multiple AI models through a single API. This workflow uses:

Claude Sonnet 4.5 - For brainstorming and conversation

Gemini 2.0 Flash - For image generation

Configuration

Create account at openrouter.ai

Add credits ($5 minimum, lasts hundreds of generations)

Generate API key

In n8n: Settings → Credentials → Add "OpenRouter API"

Paste your API key

Cost Breakdown:

Claude conversation: ~$0.01-0.05 per brainstorm session

Gemini image generation: ~$0.10-0.20 per image

Total per ad: $0.15-0.30

Step 3: Build the Child Workflow First

Start with the image generation pipeline. This needs to work before we connect the brainstorm agent.

Execute Workflow Trigger

Configure inputs the parent will send:

prompt (string) - The image generation instructions

original_image (string) - Product photo URL

usage_reference_image (string) - Optional second reference

requires_reference (boolean) - Whether we have two images

The Switch Node

Routes based on number of reference images:

Output 1: requires_reference = false → Single image request Output 2: requires_reference = true → Two image request

Why this matters: The Gemini API payload structure changes based on how many images you''re sending.

HTTP Request to Gemini (Single Image)

{
  "model": "google/gemini-2.0-flash-preview-image-generation",
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": "{{ $(''When Executed by Another Workflow'').item.json.prompt }}"
        },
        {
          "type": "image_url",
          "image_url": {
            "url": "{{ $(''When Executed by Another Workflow'').item.json.original_image }}"
          }
        }
      ]
    }
  ],
  "modalities": ["image", "text"]
}
Base64 Processing Code Node

Gemini returns images as base64 strings with a data URI prefix. We need to clean it:

let base64String = $input.first().json.choices[0].message.images[0].image_url.url;

// Remove the data URI prefix if it exists
if (base64String.startsWith(''data:image/'')) {
  const commaIndex = base64String.indexOf('','');
  if (commaIndex !== -1) {
    base64String = base64String.substring(commaIndex + 1);
  }
}

return [{
  json: {
    base64_data: base64String
  }
}];
```

### Convert to File Node

- Operation: Convert to Binary
- Source Property: `base64_data`
- File Name: `generated_image`
- MIME Type: `image/png`

### Google Drive Upload + Share

**Upload Node:**
- Operation: Upload
- File Name: `infographic` (or use dynamic naming)
- Folder: Your designated ad outputs folder

**Share Node:**
- Operation: Share
- Role: Reader
- Type: Anyone (makes it publicly accessible)

### Edit Fields (Return the Link)

Extract the `webContentLink` to send back to the parent workflow:
```
file_id: {{ $(''Upload file'').item.json.webContentLink }}
```

---

## Step 4: Build the Parent Workflow

### Chat Trigger

- Use the built-in Chat Trigger node
- This creates an embedded chat interface for testing
- Later, you can swap this for Telegram, Slack, or a custom frontend

### The Main Agent Node

**Model:** Claude Sonnet 4.5 via OpenRouter

**System Prompt:**
```
You are a professional static ad expert for ecommerce stores. Your job is to help me come up with ad variations for my product.

I will provide you with a product image URL and tell you what the product is. You are to help me come up with 5 ad angles and target audiences. Once I approve of an angle, you are to help me brainstorm ad styles and the text.

Once I approve, call the image generation agent tool with the ad concept, the original image URL, and the usage reference URL (if applicable). The agent will return a Google Drive URL, which you are to provide to me.
```

**Max Iterations:** 10 (allows for back-and-forth refinement)

### Simple Memory Node

- Connect to the agent''s memory input
- Context Window Length: 10 messages
- This lets the agent remember your conversation as you refine concepts

### The Nested Agent Tool (Prompt Writer)

This is where things get interesting. We''re putting an AI agent *inside* another agent as a tool.

**Why?** Writing good image generation prompts is a skill. Rather than burden the brainstorm agent with this, we delegate to a specialist.

**Tool Description:** "Generate static ad images"

**System Prompt for the Prompt Writer:**
```
You are writing prompts for an AI image generation model that will create product advertisements.

IMPORTANT CONTEXT:
- You cannot see any images
- The image generation model will receive:
  1. PRODUCT REFERENCE IMAGE (always provided): Shows the product itself
  2. USAGE REFERENCE IMAGE (sometimes provided): Shows the product being worn or used

PROMPT REQUIREMENTS:

1. REFERENCE FIDELITY: Instruct the model to reproduce the product exactly as shown - same shape, colors, proportions.

2. SCENE DESCRIPTION: Setting, background, surfaces, props, lighting style and mood.

3. PHOTOGRAPHY STYLE: Camera angle, depth of field, overall aesthetic.

4. TEXT SPECIFICATIONS: Exact text content, font style, color, placement.

5. COMPOSITION: 1:1 aspect ratio, element placement.

OUTPUT FORMAT:
prompt - "single JSON-friendly string..."
requires_usage_reference - true/false

CRITICAL: Use single quotes, no line breaks. The entire prompt will be wrapped in a JSON string.
Workflow Tool (Calls the Child)

Select your child workflow

Map the inputs:
prompt ← from AI

original_image ← from AI

usage_reference_image ← from AI

requires_reference ← from AI

Step 5: Testing Your Build

Test the Child First

Manually trigger the child workflow with test data:
prompt: "Professional product photo of a water bottle on a marble countertop, soft natural lighting, minimalist aesthetic"

original_image: Any public image URL

requires_reference: false

Verify you get a Google Drive link back

Test the Full System

Open the Chat Trigger interface

Send: "I''m selling a premium yoga mat. Here''s the product image: [URL]"

Work through the brainstorming process

Approve a concept and watch it generate

Common Issues

"Cannot read property ''images'' of undefined"

Gemini didn''t return an image. Check your prompt isn''t triggering content filters.

Google Drive upload fails

Verify OAuth connection is active

Check folder permissions

Agent loops infinitely

Increase max iterations or refine the system prompt to be more decisive

Step 6: Advanced Customizations

Add Multiple Output Destinations

Replace or supplement Google Drive:

Slack: Send directly to your marketing channel

Airtable: Build a searchable ad library

S3: For production-scale storage

Batch Generation Mode

Modify the brainstorm agent to generate 5 variations at once:

Update system prompt to output multiple concepts

Use Split In Batches to process each

Return a gallery of options

Connect to Real Chat Platforms

Swap the Chat Trigger for:

Telegram: Generate ads from your phone

Slack: Team-wide access

Custom webhook: Integrate with your existing tools

Add Style Presets

Create a dropdown or keyword system:

"minimal" → Clean white background, product focus

"lifestyle" → In-use context, natural lighting

"bold" → High contrast, large text, attention-grabbing

Assignment: Build Your Ad Factory

Basic Implementation

Build both workflows exactly as described

Generate 3 ads for a product you sell (or pick any product)

Calculate your cost per ad and share in the community

Advanced Challenge

Add automatic naming based on the ad concept

Create a folder structure that organizes by product/date

Add a "regenerate" option if you don''t like the result

Business Strategy Exercise

Case Study: A client sells 50 products and wants 4 ad variations each for a new campaign launch.

Answer these questions:

What''s the traditional design cost? (200 ads × $75 average = ?)

What''s your AI-generated cost?

How would you price this as a service?

What''s your profit margin?

Share your analysis in the community.

Productizing This Workflow

Service Pricing Model

Per-ad pricing: $15-25 per finished ad (95%+ margin)

Package deals: 20 ads for $300, 50 ads for $600

Monthly retainer: Unlimited generations for $500/month

Target Clients

E-commerce store owners

Dropshippers testing products

Amazon FBA sellers

Social media managers

Marketing agencies (white label)

Upsell Opportunities

Rush delivery (same day)

Revision rounds included

Ad copy writing

A/B testing consultation

Key Takeaways

✅ Nested agents let you build specialist AI tools inside conversational systems 

✅ Sub-workflows make complex automations modular and reusable 

✅ Image generation APIs are now accessible and affordable for business use 

✅ 99% cost reduction compared to traditional design services 

✅ Conversational interface means non-technical team members can generate ads

This workflow pattern - brainstorm agent → specialist tool → generation pipeline - applies to far more than ads. The same architecture works for blog posts, social content, email sequences, and more.', 5),
  ('38ff53cb-5b50-4b46-9cad-7548362c4580', '3d33f659-dabf-42f2-80b2-5af321653fdb', 'AI UGC Ad Generator: $50 Ads for 80¢', 'Lesson Overview

Build a complete automated system that transforms any product image into professional UGC video advertisements in under 2 minutes. This workflow combines Google''s Gemini 2.0 image generation with V3 video generation to create compelling ads at a fraction of traditional costs.

Time to Complete: 60 minutesDifficulty: AdvancedTools Required: N8N, Telegram Bot, OpenRouter, Kie.ai, Anthropic ClaudeCost per Ad: ~$0.80 (vs $50+ traditional UGC)

The Business Case: Why This Matters

Traditional UGC Costs

Custom video production: $50-200 per ad

Multiple product variants: $500-2000 for 10 ads

Time investment: 2-5 days per campaign

Quality consistency: Varies by creator

AI-Generated UGC Revolution

Cost per ad: $0.80 (Veo3 Fast + Gemini)

Speed: 2 minutes per ad

Scalability: Generate 100+ variants easily

Consistency: Same quality every time

ROI Example: E-commerce store with 50 products = $2,500 traditional vs $40 AI-generated = 98.4% cost savings

Step 1: Telegram Bot Setup

Create Your Control Interface

Message @BotFather on Telegram

Send /newbot command

Choose bot name: "YourBusiness_UGC_Bot"

Copy the API token (save securely)

Test bot by sending a message

Why Telegram for This Workflow?

File handling: Easy image uploads

Interactive prompts: Natural conversation flow

Mobile friendly: Generate ads from your phone

Secure: Private bot for your use only

Step 2: Workflow Architecture

The Three-Stage Process

Stage 1: Image Generation (Gemini 2.0)
├── Product photo upload
├── User instructions
├── AI image generation
└── Context analysis

Stage 2: Prompt Engineering (Claude)  
├── Image analysis integration
├── User dialogue requirements
├── Video prompt generation
└── Quality guardrails

Stage 3: Video Creation (V3 Fast)
├── Dual segment generation
├── Video merging
├── Quality control
└── Delivery

Step 3: Image Generation Engine

Telegram Trigger Setup

Add Telegram Trigger node

Configure with your bot token

Set webhook URL for real-time processing

File Download & Processing

Send and Wait for Response node
Message: "Thank you for uploading. Please provide instructions for the image generation."

Collect user''s creative brief

Get a File node
Downloads uploaded product image

Generates accessible file path

Gemini 2.0 Integration (via OpenRouter)

HTTP Request node configuration:

{
  "model": "google/gemini-2.5-flash-preview",
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "text", 
          "text": "{{$node[''Send and Wait for Response''].json[''message''][''text'']}} - Photo realistic, for UGC ad, square ratio"
        },
        {
          "type": "image_url",
          "image_url": {
            "url": "https://api.telegram.org/file/bot{{$node[''Edit Fields''].json[''telegram_token'']}}/{{$node[''Get a File''].json[''result''][''file_path'']}}"
          }
        }
      ]
    }
  ]
}
Base64 Processing

Code Node: Clean returned base64 string

// Remove data URL prefix from base64 string
const base64Data = items[0].json.choices[0].message.content;
const cleanBase64 = base64Data.replace(/^data:image\/[a-z]+;base64,/, '''');

return [{
  json: {
    base64: cleanBase64,
    extension: ''png''
  }
}];
Convert to File node
Input: Cleaned base64 string

Output: PNG file ready for analysis

Step 4: Context Analysis Engine

The Secret Sauce: Image Understanding

This step separates professional results from amateur attempts.

Get a File (for generated image)

HTTP Request to Gemini for analysis:

json

{
  "model": "google/gemini-2.5-flash-preview", 
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": "Provide a detailed description of this image: setting, subjects, what they''re doing/holding, clothing, mood, lighting, background. Be specific and detailed."
        },
        {
          "type": "image_url", 
          "image_url": {
            "url": "Generated image URL here"
          }
        }
      ]
    }
  ]
}
Why This Matters: The analysis ensures video prompts are grounded in reality, preventing V3 from generating impossible scenarios.

Step 5: Intelligent Prompt Engineering

Dialogue Requirements Collection

Send and Wait for Response
Message: "What should the person in the ad talk about? (e.g., ''how comfortable this shirt is'', ''why this water bottle is perfect for workouts'')"

Captures product-specific messaging

Claude Sonnet Integration

System Prompt for Video Generation:

You are a UGC video prompt specialist. Create a 2-segment video (8 seconds each, 16 seconds total):

CRITICAL CONSTRAINTS:
- Use ONLY elements visible in the image analysis
- No camera movements that would reveal missing elements
- Keep subject actions natural and believable
- Include subtle product showcases
- Maintain authentic UGC tone

REQUIREMENTS:
- Segment 1: Setup/introduction (8 seconds)
- Segment 2: Product benefit/call-to-action (8 seconds)  
- Include natural gestures and expressions
- Add appropriate camera movements (close-up, medium shot)

OUTPUT FORMAT:
{
  "segment_1": "Detailed 8-second scene description",
  "segment_2": "Detailed 8-second scene description"  
}
User Message Template:

Product Focus: {{dialogue_requirements}}
Image Analysis: {{image_analysis_results}}
Generate prompts for authentic UGC ad showcasing this product.

Step 6: Video Generation Pipeline

V3 Fast Integration (Key.ai)

Why Key.ai over RunwayML:

Cost: $0.40 per 8-second clip vs $2.00

Speed: Similar generation times

Quality: 95% as good as full Veo 3

API reliability: Better uptime

Parallel Video Generation

Item Lists node: Split prompt into 2 segments

HTTP Request nodes (parallel):

{
  "prompt": "{{segment_description}}",
  "model": "runway-gen3-fast",
  "duration": 8,
  "ratio": "1:1"
}
Status Polling System

Wait node: 60-second intervals

HTTP Request status check

Switch node logic:
Complete → Download videos

Processing → Loop back to wait

Failed → Send error notification

Step 7: Video Assembly & Delivery

Video Merging Options

Option 1: FFmpeg (Free, Advanced)

javascript

// MediaFX community node configuration
{
  "operation": "concat",
  "inputs": [
    {"source": "segment1.mp4"},
    {"source": "segment2.mp4"}
  ],
  "output": {
    "format": "mp4",
    "quality": "high"
  }
}
Option 2: fal.ai (Paid, Simple)

Upload both segments

Use concatenation endpoint

Download merged result

~$0.10 additional cost

Final Delivery

Telegram node: Send completed video

Optional: Upload to cloud storage

Optional: Add to asset library

Step 8: Quality Control & Optimization

Testing Your Workflow

Start with these product types for best results:

Physical products (clothing, accessories, tools)

Clear product shots (good lighting, single item)

Lifestyle-friendly items (things people actually use)

Advanced Business Applications

E-commerce Scaling

Product Catalog: 100 items
Traditional UGC: $5,000-10,000  
AI Generated: $80 + setup time
Time Saved: 2-3 weeks → 2-3 hours
A/B Testing at Scale

Generate 5 variations per product

Test different demographics, settings, messaging

Find winners quickly and cheaply

Scale successful variants

Seasonal Campaigns

Automatically update backgrounds (beach → snow)

Adjust clothing and demographics

Create holiday-specific messaging

Launch campaigns in hours, not weeks

Assignment: Build Your UGC Engine

Basic Implementation

Set up complete workflow with your products

Generate 5 UGC ads for different product types

Calculate your potential ROI and share results

Advanced Challenge

Add automatic asset organization (Google Drive folders)

Integrate with social media scheduling tools

Create performance tracking dashboard

Business Strategy Exercise

Case Study: You''re hired by a fashion brand with 200 products launching a holiday campaign.

How would you structure the workflow?

What variations would you test?

How would you measure success?

What''s your cost vs traditional agency quote?

Share your strategy in the community!

Scaling Your UGC Business

Service Business Model

Offer: AI UGC generation service

Pricing: $5-10 per ad (90% margin)

Target: E-commerce stores, dropshippers

Volume: 100 ads/day capacity

White Label Opportunities

License workflow to agencies

Provide training and support

Recurring revenue model

Scale without time investment

Community Challenge

Create the most creative UGC ad using this workflow. Categories:

Most innovative product

Best storytelling

Highest engagement simulation

Most professional result

Key Takeaways

✅ 98% cost reduction from traditional UGC production✅ Context-aware prompting prevents AI hallucinations✅ Scalable architecture handles hundreds of products✅ Professional quality competitive with human creators✅ Complete automation from product photo to final ad

This workflow alone could save a medium e-commerce business $50,000+ annually while dramatically increasing their testing capacity and speed to market.', 6),
  ('22db459b-73c0-40fd-9b0b-52d062bff9d3', '3d33f659-dabf-42f2-80b2-5af321653fdb', 'Vibe Code Motion Graphics With Claude Code', 'Generate Professional Videos Using Only Text Prompts: Remotion + AI Coding Agents

Overview

Learn how to create professional motion graphics, YouTube intros, ads, and short-form videos using only text prompts—no After Effects, no video editing skills required. This lesson teaches you how to combine Remotion (a code-based video framework) with Google Anti-Gravity or Claude Code to generate videos that would normally take hours in traditional editing software.

What You''ll Build

Professional-quality videos including:

Motion graphics with animated text

Product showcase videos (coffee makers, travel agencies, etc.)

YouTube intros and outros

Short-form reels for social media

Advertisement videos

Fast-paced montages with stock footage

Videos with synchronized audio tracks

The Technology Stack

What is Remotion?

Remotion is a framework that lets you create videos using React code instead of traditional video editing software. The key advantage: videos are generated programmatically, making them:

Infinitely customizable

Perfectly reproducible

Easy to iterate on

Programmatically controllable

The Secret Sauce: Remotion Agent Skills

Remotion recently released official "Agent Skills"—comprehensive best practices and patterns specifically designed for AI coding agents. When you load these skills into Google Anti-Gravity or Claude Code, the AI knows exactly how to:

Structure Remotion projects correctly

Write optimized code for video generation

Handle assets, timing, and animations

Follow industry best practices

Why This Changes Everything

Before this workflow:

Hours in After Effects

Expensive software licenses

Steep learning curve

Manual tweaking of every frame

After this workflow:

Minutes with a single prompt

Free and open-source tools

Natural language instructions

AI handles the technical details

Prerequisites

Required Software

Google Anti-Gravity OR Claude Code (choose one)

Node.js (JavaScript runtime environment)

Terminal access

Recommended Knowledge

Basic understanding of file systems

Comfort with terminal commands (minimal)

No video editing experience needed

No coding experience needed

Cost

Everything is free

No subscriptions required

No API costs (using free tiers)

Part 1: Tool Selection

Option 1: Google Anti-Gravity

Pros:

All-in-one IDE (everything in one window)

Powered by Gemini 3 Pro (excellent and fast)

Can also use OpenAI and Anthropic models

Integrated terminal and file browser

Great for beginners

Cons:

Newer tool (less mature ecosystem)

Limited customization vs. traditional IDEs

Best For:

Users who want simplicity

Those who prefer integrated environments

People new to coding agents

Option 2: Claude Code

Pros:

Powered by Claude Opus 4.5 (most powerful coding model)

Works with VS Code and other IDEs

More control over environment

Generally produces higher quality code output

Cons:

Requires terminal operation

Need to install separately from IDE

Slightly more complex setup

Best For:

Users comfortable with terminal

Those who want maximum code quality

People already using VS Code

Which Should You Choose?

Choose Google Anti-Gravity if:

You want the simplest setup

You prefer everything in one window

You''re new to AI coding tools

Choose Claude Code if:

You want the highest quality output

You''re comfortable with terminal commands

You already use VS Code or similar IDEs

Note: This tutorial uses Google Anti-Gravity, but the workflow is nearly identical for Claude Code. The only differences are in the initial setup—the prompting and video generation process is the same.

Part 2: Initial Setup

Step 1: Install Node.js

What is Node.js? Node.js is a JavaScript runtime environment. Remotion requires it to run. Don''t worry about the technical details—installation is straightforward.

Installation Process:

Visit nodejs.org

Click "Get Node.js" button

Download the installer for your operating system

Run the installer

Follow the installation wizard (use default settings)

Verify installation by opening terminal and typing:
node --version
You should see a version number like v20.x.x

Time Required: 5 minutes

Step 2: Install Google Anti-Gravity or Claude Code

For Google Anti-Gravity:

Visit anti-gravity.google

Download the installer

Install and launch the application

For Claude Code:

Visit claude.ai/code

Follow installation instructions

Install in terminal or integrate with VS Code

Step 3: Install Remotion Agent Skills

This is the critical step that makes everything work.

The Command:

npx skills add remotion-dev/skills
Installation Process:

Step 1: Open Your Project Folder

In Google Anti-Gravity:

Click "Open Folder"

Create a new empty folder or select existing one

Click "I trust the authors" when prompted

In Claude Code:

Navigate to your desired project directory in terminal

Run from that location

Step 2: Open Terminal

In Google Anti-Gravity:

Click "Terminal" in top menu

Select "New Terminal"

In Claude Code:

Already in terminal

Step 3: Run Installation Command

Paste and run:

npx @remotion/install-agent-skills

Step 4: Choose Installation Options

You''ll be prompted with two questions:

Question 1: Select agents to install skills to

Options: Anti-Gravity, Claude Code, Cursor, Gemini CLI

Choose: Anti-Gravity (or Claude Code if using that)

Use arrow keys to select, Enter to confirm

Question 2: Installation scope

Project: Skills only available for current folder

Global: Skills available for all future projects

Recommendation:

Choose "Global" if you plan to make multiple videos

Choose "Project" if this is a one-time experiment

Step 5: Use Recommended Method

When asked about installation method:

Select "Recommended installation method"

Hit Enter

Step 6: Verify Installation

In Anti-Gravity or Claude Code, ask:

What skills do you have access to?

Expected Response:

Available skills:
- remotion-best-practices: Provides comprehensive guidance and patterns for creating high-quality videos using Remotion in React.

If you see this, installation is complete!

Total Setup Time: 2-3 minutes

Part 3: Creating Your First Video

The "Hello World" Remotion Project

Step 1: Create Base Project

Send this prompt to your AI agent:

Create a new Remotion project called "hello-world"

What Happens:

AI creates new folder structure

Installs necessary dependencies

Sets up boilerplate Remotion project

You''ll see:

New folder: hello-world/

Contains: package.json, src/, public/, etc.

Step 2: Navigate to Project

AI will give you instructions like:

cd hello-world
npm run dev

Run these commands in the terminal.

Step 3: View the Preview

Remotion preview server launches

Opens in browser (usually localhost:3000)

Shows a default "Hello World" animation

Hit play to see the sample video

Step 4: Stop the Server

In terminal, press Ctrl + C

This stops the preview server

Ready for your custom prompt

Part 4: The Prompting Framework

The Three-Part Structure

Effective Remotion prompts have three sections:

Section 1: Duration and Style

How long is the video?

What''s the overall vibe?

How many scenes?

Section 2: Visual Elements

What appears on screen?

Text overlays and their content

Animation styles (fast cuts, slow pans, etc.)

Specific assets to include

Section 3: Technical Details

Font specifications

Color schemes

Timing constraints

Pacing requirements

Example Prompt Structure

Bad Prompt (Vague):

Make me a video about a coffee maker

Good Prompt (Structured):

DURATION & STYLE:
Create a 10-second product showcase video with 3 scenes, 
modern and sleek aesthetic.

VISUAL ELEMENTS:
- Scene 1 (3s): Show text "Wake Up" with fade-in animation
- Scene 2 (4s): Display screenshot from coffeemaker.com
- Scene 3 (3s): Show text "Brew Better" with slide-up animation
- Background: Gradient from dark brown to warm cream
- Include subtle particle effects

TECHNICAL DETAILS:
- Font: Bold sans-serif (Inter or Montserrat)
- Text color: White with subtle shadow
- No clip longer than 1.5 seconds
- Smooth transitions between scenes

Why This Works:

AI knows exact duration

Clear visual hierarchy

Specific technical requirements

Predictable output

Prompting Best Practices

Be Specific About Timing:

✅ "3-second fade-in for opening text"
❌ "Text should fade in"

Define Visual Elements Clearly:

✅ "Bold white text, 72px, centered, with 2px black outline"
❌ "Make the text look good"

Specify Asset Sources:

✅ "Browse to example.com and capture hero section screenshot"
❌ "Get an image of the website"

Set Technical Constraints:

✅ "60fps, 1920x1080, no transition longer than 0.3s"
❌ "Make it smooth"

Part 5: First Project Example (Website Showcase)

The Prompt

Create a 15-second product video with the following specifications:

DURATION & STYLE:
- Total duration: 15 seconds
- 4 distinct scenes
- Modern, professional aesthetic
- Smooth transitions (0.5s each)

VISUAL ELEMENTS:

Scene 1 (3.5 seconds):
- Animated text: "Discover the Future"
- Fade in from bottom
- Background: Gradient from #1a1a2e to #16213e

Scene 2 (4 seconds):
- Browse to https://example-product-site.com
- Capture screenshot of homepage hero section
- Zoom in animation (1.1x scale)
- Overlay subtle white glow effect

Scene 3 (3.5 seconds):
- Split screen:
  - Left: Product feature 1 icon + text
  - Right: Product feature 2 icon + text
- Slide in from left and right simultaneously
- Background: Solid #16213e

Scene 4 (4 seconds):
- Animated text: "Available Now"
- Scale up from 0.8x to 1x
- Add pulse effect (subtle)
- Background: Gradient from #16213e to #0f3460

TECHNICAL DETAILS:
- Resolution: 1920x1080
- Frame rate: 60fps
- Font: Inter Bold for all text
- Text color: #ffffff with 2px shadow
- All animations use ease-in-out timing
- Export format: MP4, H.264 codec

Implementation

Step 1: Paste the Prompt

With preview server stopped (Ctrl + C):

Paste your complete prompt

Hit Enter

AI begins writing Remotion code

Step 2: Watch the AI Work

The AI will:

Create component files

Set up animations

Configure timings

Add visual effects

Browse to website and capture screenshot

Compose all elements

Step 3: Preview the Result

When AI finishes:

npm run dev

Remotion preview opens. Hit play to see your video.

Step 4: Iterate if Needed

If something isn''t right:

The text in scene 3 is too small. Make it 48px instead of 36px.

AI updates the code, refresh preview.

What the Output Looks Like

Scene 1:

Dark blue gradient background

White text fades up from bottom: "Discover the Future"

Smooth ease-in animation

Scene 2:

Screenshot of website hero section

Gentle zoom effect (110% scale)

Soft white glow around edges

Scene 3:

Split screen layout

Left: Lightning icon + "Blazing Fast"

Right: Shield icon + "Secure"

Both slide in from opposite sides

Scene 4:

"Available Now" text

Scales up with subtle pulse

Dark to medium blue gradient

Total time from prompt to video: 2-3 minutes

Part 6: Second Project Example (Stock Footage Montage)

Adding Your Own Assets

Setup:

Step 1: Create Assets Folder

In your project directory:

mkdir assets

Step 2: Add Your Files

Place in assets/ folder:

clip1.mp4 (coffee pouring)

clip2.mp4 (laptop typing)

clip3.mp4 (person smiling)

background-music.mp3

Step 3: Verify AI Can See Assets

Ask:

Can you see the assets folder and its contents?

AI should list all files.

The Advanced Prompt

Create a fast-paced 15-second video about modern productivity.

DURATION & STYLE:
- Total: 15 seconds
- 6 quick cuts (2.5s each)
- Energetic, techy vibe
- Modern and dynamic

VISUAL ELEMENTS:

Clips 1-3 (0-7.5s):
- Use video files from assets folder: clip1.mp4, clip2.mp4, clip3.mp4
- Each clip plays for 2.5 seconds
- Apply slight zoom on each (1.05x)
- Add motion blur effect

Clips 4-6 (7.5-15s):
- Animated text overlays on solid backgrounds
- Clip 4: "Work Smarter" (blue background #1e3a8a)
- Clip 5: "Create Faster" (purple background #7c3aed)
- Clip 6: "Achieve More" (green background #059669)
- Text: Bold, 64px, white, slide in from right

TECHNICAL DETAILS:
- Use background-music.mp3 as audio track
- Synchronize cuts with music beats
- Add subtle vignette to all clips
- Text animations: 0.3s duration, ease-out
- Transitions: Quick cuts, no fades
- Color grade: Increase saturation by 10%
- Export: 1080p, 60fps, MP4

Why This Prompt Works

Specific Asset References:

Names exact files to use

AI knows where to find them

No ambiguity about sources

Detailed Timing:

Each scene gets exact duration

Helps AI synchronize with audio

Creates predictable pacing

Technical Specifications:

Motion blur, vignette, color grading

AI applies professional touches

Output looks polished

Claude Code Example Result

This example used Claude Code instead of Anti-Gravity.

The Output:

Seamless integration of stock footage

Text animations perfectly timed

Background music synced with visual cuts

Professional-looking color grading

Fast-paced, energetic feel

Beat-synchronized transitions

Quality Observation: Claude Code tends to produce slightly more polished results, especially with:

Timing precision

Animation smoothness

Asset integration

Audio synchronization

But both tools produce excellent results.

Part 7: Advanced Techniques

Technique 1: Web Scraping for Assets

The Prompt:

Browse to https://unsplash.com/photos/coffee
Capture the first 3 images
Use them as background stills in scenes 2, 4, and 6
Apply parallax scroll effect to each image

What Happens:

AI navigates to URL

Screenshots specific elements

Downloads assets programmatically

Integrates into video

Use Cases:

Product screenshots from your website

Social proof (testimonials, reviews)

Live data displays (charts, dashboards)

Current pricing or offers

Technique 2: Dynamic Text from Data

The Prompt:

Create a 10-second stats reveal video.

Data to display:
- 50,000+ users
- 4.9/5 rating
- 200+ countries

Each stat should:
- Count up from 0 with easing animation
- Display for 3 seconds
- Use large bold numbers (96px)
- Include small descriptive text below (24px)

Background: Dark gradient

Result: Animated counters that count up to target numbers—looks incredibly professional.

Technique 3: Multi-Scene Narratives

The Prompt:

Create a 30-second storytelling video in 3 acts:

ACT 1 - THE PROBLEM (0-10s):
- Dark, desaturated footage
- Text overlay: "Wasting hours on manual tasks"
- Frustrated person at computer (use clip1.mp4)
- Slow, heavy music

ACT 2 - THE SOLUTION (10-20s):
- Brightness increases
- Text overlay: "Until you discover automation"
- Light bulb moment (use clip2.mp4)
- Music tempo increases

ACT 3 - THE RESULT (20-30s):
- Vibrant, saturated colors
- Text overlay: "Work smarter, not harder"
- Happy person celebrating (use clip3.mp4)
- Upbeat, energetic music

Ensure smooth tonal transitions between acts.

Result: Three-act narrative structure with visual storytelling techniques.

Technique 4: Template-Based Generation

Create a reusable template:

The Template Prompt:

Create a product showcase template video with these placeholders:

- {{PRODUCT_NAME}}
- {{FEATURE_1}}
- {{FEATURE_2}}
- {{FEATURE_3}}
- {{CTA_TEXT}}
- {{BRAND_COLOR}}

Structure:
- Scene 1: Product name reveal
- Scene 2-4: Feature highlights (one per scene)
- Scene 5: Call to action

Make this reusable—I''ll provide different values later.

To use the template later:

Use the product showcase template with these values:
- PRODUCT_NAME: "CloudSync Pro"
- FEATURE_1: "Instant sync across devices"
- FEATURE_2: "Bank-level encryption"
- FEATURE_3: "Unlimited storage"
- CTA_TEXT: "Start Free Trial"
- BRAND_COLOR: #4f46e5

Benefit: Create consistent branded videos in seconds.

Part 8: Exporting and Using Your Videos

Rendering the Final Video

Step 1: Finalize in Preview

Make sure your video looks perfect in the Remotion preview.

Step 2: Render Command

In terminal:

npm run build

What Happens:

Remotion renders every frame

Compiles into final MP4

Takes 1-5 minutes depending on length/complexity

Progress bar shows completion

Step 3: Find Your Video

Output location:

out/video.mp4

Copy to wherever you need it.

Export Settings Optimization

For Social Media:

Resolution: 1080x1920 (vertical for Instagram/TikTok)
Frame rate: 30fps (sufficient for social)
Codec: H.264 (universal compatibility)

For YouTube:

Resolution: 1920x1080 or 3840x2160 (4K)
Frame rate: 60fps (smoother motion)
Codec: H.264 or H.265
Bitrate: High quality

For Ads:

Resolution: 1920x1080
Frame rate: 30fps
Codec: H.264
File size: Optimized for platform requirements

Specify in prompt:

Export settings:
- Resolution: 1080x1920
- Frame rate: 30fps
- Codec: H.264
- Target file size: Under 50MB

Quality vs. Speed Trade-offs

Fast Render (Lower Quality):

30fps

Standard resolution (1080p)

Lower bitrate

Renders in ~1 minute

High Quality (Slower Render):

60fps

4K resolution (2160p)

High bitrate

Renders in ~5-10 minutes

Choose based on use case.

Part 9: Troubleshooting Common Issues

Issue 1: "Command not found: npm"

Cause: Node.js not installed correctly

Solution:

# Check if Node is installed
node --version

# If no output, reinstall Node.js from nodejs.org

Issue 2: Preview Won''t Load

Cause: Port already in use

Solution:

# Stop the server
Ctrl + C

# Kill any process on port 3000
# Mac/Linux:
lsof -ti:3000 | xargs kill -9

# Windows:
netstat -ano | findstr :3000
taskkill /PID [process_id] /F

# Restart preview
npm run dev

Issue 3: Video Clips Not Found

Cause: Incorrect file paths

Solution:

The video clips should be in the assets folder at the root of the project.

Please verify:
1. assets/clip1.mp4 exists
2. File names match exactly (case-sensitive)
3. Update the imports to use the correct paths

Issue 4: Text Animations Look Choppy

Cause: Low frame rate or incorrect easing

Solution:

The text animations appear choppy. Please:
1. Ensure we''re rendering at 60fps
2. Use ease-out timing function for all text animations
3. Extend animation duration to minimum 0.5s

Issue 5: Audio Not Syncing

Cause: Audio duration doesn''t match video duration

Solution:

The background music is longer than the video. Please:
1. Trim the audio to exactly 15 seconds
2. Add a fade-out in the last 0.5s
3. Ensure visual cuts align with prominent beats

Issue 6: Render Fails with Error

Cause: Missing dependencies or corrupt project

Solution:

# Delete node_modules and reinstall
rm -rf node_modules
npm install

# Clear cache
npm cache clean --force

# Try rendering again
npm run build

Part 10: Real-World Applications

Use Case 1: YouTube Channel Intros

The Prompt:

Create a 5-second YouTube intro for a tech channel called "Code Masters"

STYLE: Futuristic, high-tech, energetic

VISUALS:
- Animated circuit board pattern background
- Channel name "Code Masters" appears with glitch effect
- Tagline "Building Tomorrow''s Software" fades in below
- Quick flash of code snippets scrolling
- Logo scales up in center

TECHNICAL:
- Colors: Electric blue (#00d9ff) and purple (#b300ff)
- Font: Exo 2 Bold
- Duration: 5 seconds exactly
- Include "whoosh" sound effect at 0.5s and 2.5s

Result: Reusable intro that you render once and use on all videos.

Use Case 2: Product Demo Videos

The Prompt:

Create a 20-second SaaS product demo:

PRODUCT: TaskFlow - Project Management App

SCENES:
1. (0-4s) Problem: Show messy spreadsheet, frustrated user
2. (4-8s) Solution: TaskFlow interface screenshot, smooth and organized
3. (8-12s) Feature 1: Drag-and-drop task management (animated demo)
4. (12-16s) Feature 2: Team collaboration view
5. (16-20s) CTA: "Start Free Trial" with button pulse

TECHNICAL:
- Use brand colors: #6366f1 (primary), #f59e0b (accent)
- Modern, clean aesthetic
- Upbeat background music
- Smooth transitions (0.3s)

Result: Professional demo video for landing page or ads.

Use Case 3: Social Media Reels

The Prompt:

Create a 15-second Instagram Reel about productivity tips:

FORMAT: Vertical (1080x1920)

CONTENT (3 tips, 5s each):
Tip 1: "🌅 Start with hardest task"
Tip 2: "⏰ Time block your calendar"
Tip 3: "📵 Phone on Do Not Disturb"

STYLE:
- Bold white text on colorful gradients
- Each tip: Different gradient background
- Emoji appears first (scale-in), then text (slide-up)
- Trendy, Gen-Z aesthetic

AUDIO: Upbeat pop track with beat drops at 5s and 10s

Result: Shareable social content optimized for mobile.

Use Case 4: Event Countdown Videos

The Prompt:

Create a 10-second product launch countdown:

EVENT: "New iPhone Launch" in 3 days

VISUALS:
- Large countdown timer (72 hours → counting down)
- Apple logo subtle in background
- Text: "The Wait Is Almost Over"
- Modern, minimalist design

ANIMATION:
- Numbers flip/count down smoothly
- Subtle particle effects
- Final second: Explosion of color

COLORS: Apple-style clean whites and grays with accent of product color

POST TO: Instagram Stories daily until launch

Result: Daily countdown content that builds anticipation.

Use Case 5: Tutorial/Educational Content

The Prompt:

Create a 30-second "How It Works" explainer:

TOPIC: How AI video generation works

STRUCTURE:
1. (0-10s) Show "You write a prompt" with typing animation
2. (10-20s) Show "AI writes code" with code appearing on screen
3. (20-30s) Show "Video renders" with progress bar → final video appears

STYLE:
- Isometric illustrations
- Friendly, approachable colors
- Clear step indicators (1, 2, 3)
- Smooth scene transitions

TARGET: Educational, easy to understand

Result: Clear explainer content for blog posts or landing pages.

Part 11: Advanced Workflows

Workflow 1: Batch Video Generation

Create multiple variations from one template:

Master Template:

Create a 10-second testimonial video template with these variables:
- {{CUSTOMER_NAME}}
- {{CUSTOMER_TITLE}}
- {{CUSTOMER_COMPANY}}
- {{TESTIMONIAL_TEXT}}
- {{RATING}}

Generate variations:

Generate 5 videos using the testimonial template with this data:
[Paste CSV or JSON with customer data]

Output each as: testimonial-[customer-name].mp4

Result: 5 unique testimonial videos in one batch.

Workflow 2: Data-Driven Videos

Pull data from APIs:

The Prompt:

Create a daily stats video that:
1. Fetches today''s metrics from our API
2. Displays 3 key numbers with count-up animations
3. Shows percentage change vs. yesterday
4. Auto-renders at 9 AM daily

Data source: https://api.example.com/daily-stats

Result: Automated daily video generation based on live data.

Workflow 3: A/B Testing Video Variants

Create multiple versions to test:

The Prompt:

Create 3 variations of the same ad:

VERSION A:
- Emotional approach
- Soft music
- Testimonial-focused

VERSION B:
- Logical approach
- Energetic music
- Feature-focused

VERSION C:
- Urgent approach
- Dramatic music
- Scarcity-focused

All 15 seconds, same core message, different execution.

Result: Multiple creative approaches to test performance.

Part 12: Cost and Performance Analysis

Comparison: Traditional vs. AI Video Generation

Traditional After Effects Workflow:

Time per video: 2-4 hours

Software cost: $20-50/month (Adobe subscription)

Learning curve: Weeks to months

Revisions: 30-60 minutes each

Scalability: Limited (one person, one video at a time)

Remotion + AI Workflow:

Time per video: 5-15 minutes

Software cost: $0 (free and open-source)

Learning curve: 10 minutes

Revisions: 1-2 minutes

Scalability: Unlimited (generate multiple simultaneously)

ROI Calculation:

If you create 10 videos/month:

Traditional: 20-40 hours/month + $50 software = $1,050+ in time + costs

AI Method: 1-2.5 hours/month + $0 software = $50-125 equivalent time value

Savings: ~$900-1,000/month

When to Use Each Approach

Use Traditional Editing When:

You need frame-perfect manual control

Highly artistic, creative work

Client requires specific software/workflow

Very complex compositing (100+ layers)

Use Remotion + AI When:

Producing content at scale

Need quick iterations

Template-based videos (testimonials, ads, social posts)

Data-driven or automated video generation

Consistent branding across many videos

Best of Both:

Generate base video with Remotion

Import into After Effects for final polish

Combine speed with precision

Your Assignment

Week 1: Master the Basics

Day 1:

Install Node.js

Install Google Anti-Gravity or Claude Code

Install Remotion Agent Skills

Create "Hello World" project

Day 2:

Create your first custom video (10-15 seconds)

Practice the three-part prompting framework

Experiment with timing and transitions

Day 3:

Add your own assets (images, video clips)

Create a video using stock footage

Practice asset integration

Week 2: Build Real Projects

Day 4-5:

Create a YouTube channel intro for your brand

Render and export final version

Day 6-7:

Create a product showcase or demo video

Create 3 social media reels (15s vertical videos)

Month 2: Advanced Applications

Pick one advanced project:

Option 1: Testimonial Video Template

Create reusable template

Generate 3-5 variations with different customer data

Document your workflow

Option 2: Educational Explainer

30-60 second "How It Works" video

Include animations, text, and voiceover

Optimize for YouTube

Option 3: Ad Campaign

Create 3 A/B test variations

Same message, different creative approaches

Analyze which performs best

Share in the community:

Post your video

Share your prompt

Document what worked/what didn''t

Help others troubleshoot

Resources

Official Documentation

Remotion: remotion.dev

Node.js: nodejs.org

Google Anti-Gravity: anti-gravity.google

Claude Code: claude.ai/code

Inspiration & Examples

Remotion Showcase: remotion.dev/showcase

Assets

Free Stock Footage: Pexels, Pixabay

Free Music: YouTube Audio Library, Uppbeat

Free Fonts: Google Fonts

Discussion Questions

What type of videos would you create first with this workflow?

How could you use this to scale content production for your business or clients?

What''s the most impressive video you''ve seen generated with AI, and how would you recreate it with Remotion?

Would you use this to replace traditional video editing entirely, or as a complementary tool?

What advanced features would you want to see in future Remotion updates?

Post your first Remotion video in the community and share your prompt! 👇', 7),
  ('ad4e0586-3f05-4b19-bde7-8b38b4481d7f', '3d33f659-dabf-42f2-80b2-5af321653fdb', 'AI-Powered Photo Organizer With Nano Banana', 'AI-Powered Photo Organizer: Smart File Management with Gemini Nano

Lesson Overview

Learn to build an intelligent photo organization system that automatically analyzes, renames, and categorizes your images using Google''s powerful Gemini Nano model. This workflow can process hundreds or thousands of photos, creating organized folder structures without any manual work.

Time to Complete: 45 minutesDifficulty: IntermediateTools Required: N8N, Google Drive, OpenRouter (or direct Gemini API), Google Drive API credentials

What You''ll Build

An automated photo management system that:

Analyzes every image using advanced AI vision

Generates descriptive, searchable file names

Creates logical folder categories automatically

Moves files to appropriate folders

Deletes blurry or low-quality images

Handles existing folder structures intelligently

Real-World Value: Save 10+ hours weekly on file organization across teams, perfect for marketing agencies, content creators, or any business handling large image libraries.

Step 1: Workflow Planning & Setup

The Strategy (Always Start Here!)

Before building any N8N workflow, map out your logic:

1. Photos in Google Drive folder ✓
2. Loop through each file individually ✓  
3. Analyze image & rename using AI ✓
4. List existing folders ✓
5. AI agent decides: existing folder or create new ✓
6. Move file to correct location ✓
7. Optional: Delete low-quality images ✓

Google Drive Preparation

Create a folder called "Photo Organizer Demo"

Upload 5-10 test images (mix of people, landscapes, objects)

Critical: Right-click folder → Share → "Anyone with the link can view"

Copy the folder ID from the URL for later use

Step 2: File Discovery & Loop Setup

Manual Trigger

Start with Manual Trigger node

This lets you control when the workflow runs

Search for Files

Add Google Drive → Search Files and Folders

Configure:
Resource: File or Folder

Operation: Search

Search Method: Search file or folder name

Search Query: Leave blank (gets all files)

Return All: Enabled

Add Filters:
Filter 1: Folder = Your photo folder name

Filter 2: What to Search = Files only (excludes folders)

Loop Control

Add Loop Over Items node

This processes each photo individually

Why this matters: Prevents overwhelming the AI with batch requests

Step 3: AI Image Analysis

HTTP Request Setup (Using OpenRouter)

Add HTTP Request node

Configure:
Method: POST

URL: https://openrouter.ai/api/v1/chat/completions

Authentication: Predefined Credential Type → OpenRouter API

The Magic Prompt

{
  "model": "google/gemini-2.0-flash-exp:free",
  "messages": [
    {
      "role": "user", 
      "content": [
        {
          "type": "text",
          "text": "Analyze this image and output a suggested file name in this format: subject-action-location-style-mood. The file name should be descriptive enough to find in search and use up to 6-7 words. If the image is very blurry or low quality, output ''delete''."
        },
        {
          "type": "image_url",
          "image_url": {
            "url": "https://drive.google.com/uc?id={{$node["Loop Over Items"].json["id"]}}"
          }
        }
      ]
    }
  ]
}

Key Technical Points

The Google Drive URL format automatically downloads the file

The Loop Over Items node provides the file ID dynamically

The "delete" option lets AI remove poor quality images

Step 4: File Renaming

Update File Node

Add Google Drive → Update File

Configure:
Operation: Update

File to Update: By ID

File ID: {{$node["Loop Over Items"].json["id"]}}

Update Fields: Add "Name"

Name: {{$node["HTTP Request"].json["choices"][0]["message"]["content"]}}

Pro Tip: Pin the HTTP Request node during testing to avoid repeated API calls.

Step 5: Smart Folder Management

List Existing Folders

Add Google Drive → Search Files and Folders

Configure:
Search Query: Leave blank

Return All: Enabled

Add Filters:
Filter 1: Folder = Your main folder

Filter 2: What to Search = Folders only

Aggregate Folder Data

Add Aggregate node

Configure:
Aggregate: Summary

Fields to Aggregate:
id (folder IDs)

name (folder names)

Why This Matters: The AI agent needs to see all existing folders to make smart categorization decisions.

Step 6: The AI Decision Engine

AI Agent Setup

Add AI Agent node

System Message:

You are a photo sorting agent. You will be provided with:
- A descriptive file name and its Google Drive file ID
- A list of existing folder IDs and their names

Based on the file name, determine if it fits any existing folder. If yes, move it there. If no existing folder fits, create a new folder with a generic category name (like "Nature", "People", "Travel", "Architecture") and move the file there.

If the file name is "delete", use the delete tool to remove it.

User Message (Dynamic Data)

File Name: {{$node["Update File"].json["name"]}}
File ID: {{$node["Loop Over Items"].json["id"]}}
Existing Folder IDs: {{$node["Aggregate"].json["id"]}}
Existing Folder Names: {{$node["Aggregate"].json["name"]}}

Step 7: AI Tools Configuration

Chat Model

Add OpenAI Chat Model

Use GPT-4.1-mini (excellent with tools, cost-effective)

Tool 1: Create Folder

Add Google Drive → Create Folder

Configure:
Folder Name: {{$fromAI("folder_name")}} (let AI decide)

Parent Drive: My Drive

Parent Folder: Your main folder ID

Tool 2: Move File

Add Google Drive → Move File

Configure:
File: Let the model define the parameter

Parent Drive: My Drive

Parent Folder: Let the model define the parameter

Tool 3: Delete File (Optional)

Add Google Drive → Delete File

Configure:
File ID: Let the model define the parameter

Step 8: Complete the Loop

Close the Loop

Connect the AI Agent back to Loop Over Items

This ensures every file gets processed

Save and activate the workflow

Step 9: Testing & Optimization

Initial Test Run

Start with 3-5 images

Monitor each step''s output

Check Google Drive for results

Expected Results

Travel photos → "Travel and Adventure" folder

People photos → "People and Portraits" folder

Nature shots → "Nature and Landscapes" folder

Blurry images → Deleted automatically

Troubleshooting Tips

Empty folder error? Add dummy folders or enable "Always Output Data"

API rate limits? Add Wait nodes between requests

Wrong categorization? Refine the system prompt

Advanced Enhancements

Scale for Production

Batch processing: Process 50 images at a time

Error handling: Add try/catch for failed analyses

Logging: Track what gets moved where

Scheduling: Run automatically on new uploads

Business Applications

Marketing agencies: Auto-organize client assets

Real estate: Categorize property photos

E-commerce: Sort product images by category

Content creators: Organize stock footage libraries

ROI Calculation

Time Savings Analysis

Manual sorting: 2 minutes per photo

1,000 photos/month: 33+ hours of manual work

At $30/hour: $1,000+ monthly savings

Annual value: $12,000+ (5x your investment!)

Additional Benefits

Consistency: Never miss categorization

Searchability: Descriptive filenames improve findability

Team efficiency: Everyone finds files instantly

Client satisfaction: Faster deliverables

Assignment: Build Your Version

Basic Implementation

Set up the complete workflow with your Google Drive

Test with 10-20 photos

Screenshot your organized folders and share

Advanced Challenge

Add custom categories for your industry

Include metadata extraction (date, location, camera settings)

Create a dashboard showing organization stats

Business Application

How would you customize this for:

A wedding photographer with 1000s of photos?

A marketing agency managing client assets?

An e-commerce store organizing product shots?

Share your industry-specific modifications in the community!

Community Challenge

Photo Organization Olympics!

Upload before/after screenshots of your messiest photo folder.

Bonus Points:

Most creative category names

Largest batch processed

Most time saved (calculate and share)

Key Takeaways

✅ Nano Banana provides exceptional image analysis✅ Smart folder detection prevents duplicate categories✅ Quality filtering automatically removes bad images✅ Scalable architecture handles thousands of files', 8),
  ('5b5fd870-3962-458c-8aa8-31461eb89905', '3d33f659-dabf-42f2-80b2-5af321653fdb', 'End-to-End Short-Form Video Automation', 'Lesson Overview

Build a complete AI-powered content production system that autonomously researches trending topics, writes scripts, generates AI avatar videos, edits with captions and B-roll, and publishes to Instagram Reels and YouTube Shorts. Master multi-workflow orchestration, AI agent tool integration, and the production pipeline that creates scroll-stopping content while you sleep.

Time to Complete: 90 minutes 

Difficulty: Advanced 

Tools Required: n8n, Claude Sonnet 4.5, HeyGen API, Submagic API, Cloudinary, Upload-Post API, RSS feeds 

Production Capability: Fully autonomous content pipeline from idea to published video

The Content Creator''s Nightmare

Traditional Short-Form Video Reality

Day 1: Research trending topics (2 hours)
Day 2: Write script, revisions (3 hours)
Day 3: Film yourself or hire creator ($200-500)
Day 4: Edit video, add captions, B-roll (4 hours)
Day 5: Export, upload to platforms manually (1 hour)
Total: 10+ hours, $200-500 per video
Output: 1 video per week if you''re disciplined

The Bottleneck: You ARE the bottleneck. Every video requires your face, voice, editing skills, and manual platform uploads.

AI-Automated Production Pipeline

You: "Research AI news and suggest 3 video ideas"
AI Agent: [Researches RSS feeds, presents 3 briefs]
You: "I approve #2. Write the script."
AI Agent: [Writes script, caption, title. Presents for approval]
You: "Approved."
AI Agent: [Generates avatar video → Edits with captions/B-roll → 
          Uploads to Instagram + YouTube → Updates tracking database]
Total: 8 minutes of your time, $2-3 per video
Output: 7 videos per week with same effort as 1

The Transformation: From "I''m on camera 10 hours/week" to "I approve scripts 8 minutes/week, AI does everything else."

System Architecture: The Four-Layer Stack

Layer 1: Orchestrator (Main Workflow)

AI Agent (Claude Sonnet 4.5)
    ├─ Tool: RSS Feed Research
    ├─ Tool: Data Table (tracking)
    ├─ Tool: Generate Video (sub-workflow)
    ├─ Tool: Edit Video (sub-workflow)
    └─ Tool: Upload Video (sub-workflow)

The Brain: Claude coordinates everything, maintains conversation context, handles approvals, orchestrates sub-workflows.

Layer 2: Video Generation (Sub-Workflow #1)

Input: Script text
    ↓
HeyGen API: Generate AI avatar video
    ↓
Wait Loop: Check status every 10 seconds
    ↓
Output: HeyGen video URL

Cost per video: ~$2 (HeyGen pricing)

Layer 3: Video Editing (Sub-Workflow #2)

Input: HeyGen video URL
    ↓
Submagic API: Auto-captions, B-roll, zooms
    ↓
Wait Loop: Check status every 20 seconds
    ↓
Cloudinary: Upload edited video for stable URL
    ↓
Output: Cloudinary video URL

Cost per video: ~$1 (Submagic pricing)

Layer 4: Publishing (Sub-Workflow #3)

Input: Cloudinary URL + Title + Caption
    ↓
Upload-Post API: Publish to Instagram + YouTube simultaneously
    ↓
Output: Instagram URL, YouTube URL

Cost per video: ~$0.10 (Upload-Post pricing)

Total Cost per Video: $3.10 Total Human Time: 8 minutes (approval only)

The Orchestrator: AI Agent as Project Manager

System Prompt: The Production Workflow

You are a professional content marketer specializing in short form videos. 
Your job is to handle end-to-end short form content creation.

Step 1: Research trending topics in the AI space using the RSS feed tool.

Step 2: Present 2-3 content briefs for approval - what the article is about, 
a good angle to make it relevant to my audience of AI enthusiasts, and the 
article URL. Once I approve, create a new record with the URL in the data 
table and make a note of the newly generated row''s ID.

Step 3: Create a 30-45 second script (output script only as a block of text - 
no division into hook body etc), an Instagram caption, and a YouTube shorts 
title. Present all three together for approval in a single message. The script 
is for Instagram and YouTube shorts, so the hook should be engaging, the first 
3-5 seconds are the MOST critical, and say as much as you can in as few words 
as possible. Once I approve all three together, add the script, Instagram 
caption, and YouTube title to the data table, matching the row using the ID 
from Step 2.

Note: I may directly brainstorm a script with you. If that''s the case, once 
I approve the script, Instagram caption, and YouTube title together, create 
a new record in the data table using the script and mark the source as 
user-initiated.

Step 4: Once I approve the content in Step 3, immediately proceed without 
further approval to: generate the video using the Generate Video tool. The 
script you send in the query must be JSON-friendly, so if there are any 
unnecessary artifacts like quotation marks and the like, remove those.

Add the response URL as-is to the Heygen row in the data table, matching on 
the ID. Then send that same URL for editing using the Edit Video tool - this 
will return a Cloudinary URL, which you add to the data table, matching on 
the ID. Then use the Publish Video tool to publish the video to Instagram and 
YouTube, and update the data table with the returned URLs, matching using 
the ID.

Important: You must NOT hallucinate the URLs. Use them exactly as returned 
by the tools. This is crucial to my career. Always match rows using the ID 
when updating the data table.

Why This System Prompt Works

Multi-Step Orchestration:

Step 1 (Research): Agent uses RSS tool autonomously

Step 2 (Approval Gate): Presents options, waits for human decision

Step 3 (Script Writing): Creates content, gets approval

Step 4 (Autonomous Execution): No more approvals, runs all 3 sub-workflows

Human-in-the-Loop at Right Moments:

Human approves: Ideas and scripts (creative decisions)
AI executes: Video generation, editing, publishing (technical tasks)

Data Table as Single Source of Truth:

Every video gets unique ID

All URLs tracked in one place

Agent matches rows by ID (prevents URL mixups)

Audit trail for every production step

JSON-Friendly Script Cleaning:

"This is "amazing"!" → Breaks API calls

Agent auto-removes problematic characters

Ensures sub-workflow tools receive clean input

Tool 1: RSS Feed Research

Configuration

// RSS Feed Read Tool
URL: {{ $fromAI(''URL'', '''', ''string'') }}
// AI agent dynamically provides URL

How AI Agent Uses This:

User: "Research trending AI topics"

Agent reasoning:
1. I need to use RSS Feed Read tool
2. Popular AI RSS feeds:
   - TechCrunch AI: https://techcrunch.com/category/artificial-intelligence/feed/
   - The Verge AI: https://www.theverge.com/ai-artificial-intelligence/rss/index.xml
   - VentureBeat AI: https://venturebeat.com/category/ai/feed/
3. Call RSS tool with TechCrunch URL
4. Parse results, extract top 3 interesting articles
5. Present to user with brief + angle

Agent Output Example:

I''ve researched the latest AI news. Here are 3 video ideas:

1. **OpenAI''s New Reasoning Model**
   - What: GPT-4 can now show its thinking process
   - Angle: "This changes everything about debugging AI responses"
   - URL: https://techcrunch.com/2024/...

2. **Google''s Video Generation Model**
   - What: Veo 2 creates 4K videos from text
   - Angle: "YouTube creators are about to face AI competition"
   - URL: https://techcrunch.com/2024/...

3. **Meta''s Open Source AI Chip**
   - What: Meta releasing custom AI chip designs
   - Angle: "Why Big Tech is ditching NVIDIA"
   - URL: https://techcrunch.com/2024/...

Which would you like me to write a script for?

Tool 2: Data Table Management

Data Table Schema

Table: "Short Form Videos"

Columns:
- id (auto-generated, primary key)
- ideaURL (string) - Original article URL
- script (string) - Approved script text
- title (string) - YouTube title
- description (string) - Instagram caption
- heygenURL (string) - Generated video URL
- editedURL (string) - Submagic edited video URL
- instaURL (string) - Published Instagram URL
- youtubeURL (string) - Published YouTube URL
- createdAt (timestamp, auto)
- status (string) - pending/generating/editing/published

Two Data Table Tools

Tool 1: Upsert (Create/Update)

// Data Table Upsert Tool
Operation: Upsert
Table: Short Form Videos
Filters: Match by ID
Columns: All fields (AI provides dynamically)

Tool 2: Get (Read)

// Data Table Get Tool
Operation: Get
Table: Short Form Videos

How Agent Uses Data Table

Step 2 (After User Approves Idea):

Agent: "I''ll create a database entry for this"

Upsert call:
{
  ideaURL: "https://techcrunch.com/article-xyz",
  status: "pending"
}

Response: { id: "row_abc123" }

Agent stores: ID = row_abc123 (for future matching)

Step 3 (After User Approves Script):

Agent: "I''ll update the database with the script"

Upsert call:
{
  id: "row_abc123", // Matches existing row
  script: "OpenAI just dropped a bombshell...",
  title: "OpenAI''s Secret Feature Nobody Noticed",
  description: "The reasoning tokens change everything 🧠..."
}

Step 4 (After Each Sub-Workflow):

// After video generation:
Upsert: { id: "row_abc123", heygenURL: "https://heygen.com/..." }

// After video editing:
Upsert: { id: "row_abc123", editedURL: "https://cloudinary.com/..." }

// After publishing:
Upsert: { 
  id: "row_abc123", 
  instaURL: "https://instagram.com/p/...",
  youtubeURL: "https://youtube.com/shorts/...",
  status: "published"
}

Why ID Matching is Critical:

Without ID matching:
- Agent might create multiple rows for same video
- URLs get mixed up between videos
- Tracking becomes impossible

With ID matching:
- One row per video (upsert updates existing)
- All URLs correctly associated
- Complete audit trail

Tool 3: Generate Video (Sub-Workflow)

Sub-Workflow Architecture

Execute Workflow Trigger (receives "script" input)
    ↓
HTTP Request: HeyGen Generate Video API
    ↓
Wait 10 seconds
    ↓
HTTP Request: HeyGen Check Status API
    ↓
Switch Node: 
    - Failed → Return "VIDEO EXECUTION FAILED"
    - Completed → Return video_url
    - Pending → Loop back to Wait

HeyGen API Configuration

Generate Video Request:

// HTTP Request Node
Method: POST
URL: https://api.heygen.com/v2/video/generate
Authentication: HTTP Header Auth
Header: X-Api-Key: [Your HeyGen API key]

Body (JSON):
{
  "video_inputs": [
    {
      "character": {
        "type": "avatar",
        "scale": 1,
        "avatar_style": "normal",
        "avatar_id": "24442275d0014be2827c16af9a1ab89c"
      },
      "voice": {
        "type": "text",
        "input_text": "{{ $json.script }}",
        "voice_id": "5d8c378ba8c3434586081a52ac368738",
        "speed": 1.1
      }
    }
  ],
  "dimension": {
    "width": 720,
    "height": 1280
  }
}

Key Parameters:

Parameter Value Why avatar_id Your chosen avatar Consistent brand identity voice_id Your chosen voice Matches avatar personality speed 1.1 10% faster = more energetic dimension 720x1280 9:16 vertical for Reels/Shorts

Getting Avatar ID:

Log into HeyGen dashboard

Create or select avatar

Copy avatar ID from URL or settings

Paste into workflow

Getting Voice ID:

HeyGen → Voice Library

Preview voices

Copy voice ID

Paste into workflow

Response:

{
  "data": {
    "video_id": "abc123xyz",
    "status": "pending"
  }
}

Wait Loop Implementation

Wait Node: 10 seconds Why 10 seconds: HeyGen typically generates 30-45 second videos in 60-90 seconds total. Checking every 10 seconds = 6-9 checks average.

Check Status Request:

// HTTP Request Node
Method: GET
URL: https://api.heygen.com/v1/video_status.get
Authentication: Same HTTP Header Auth

Query Parameters:
- video_id: {{ $(''Generate Video'').item.json.data.video_id }}

Status Response:

{
  "data": {
    "status": "pending" | "processing" | "completed" | "failed",
    "video_url": "https://resource.heygen.com/video/abc123.mp4"
  }
}

Switch Node Logic

Route 1: Failed

Condition: {{ $json.data.status }} equals "failed"
Output: "VIDEO EXECUTION FAILED"
// Returns to main agent, which notifies user

Route 2: Completed

Condition: {{ $json.data.status }} equals "completed"
Output: {{ $json.data.video_url }}
// Returns video URL to main agent

Route 3: Still Processing (Default/Fallback)

All other statuses: "pending", "processing", etc.
Output: Loop back to Wait node
// Checks again in 10 seconds

Loop Diagram:

Generate Video → Wait 10s → Check Status
                    ↑              ↓
                    └── Pending ───┘
                                   ↓
                               Completed → Return URL

Tool 4: Edit Video (Sub-Workflow)

Sub-Workflow Architecture

Execute Workflow Trigger (receives "URL" input)
    ↓
HTTP Request: Submagic Create Project API
    ↓
Wait 20 seconds
    ↓
HTTP Request: Submagic Check Status API
    ↓
Switch Node:
    - Failed → Return "EDIT FAILED"
    - Completed → Cloudinary Upload → Return Cloudinary URL
    - Processing → Loop back to Wait

Submagic API Configuration

Create Project Request:

// HTTP Request Node
Method: POST
URL: https://api.submagic.co/v1/projects
Authentication: HTTP Header Auth
Header: X-Api-Key: [Your Submagic API key]

Body (JSON):
{
  "title": "My Awesome Video",
  "language": "en",
  "videoUrl": "{{ $json.URL }}",
  "templateName": "Hormozi 2",
  "webhookUrl": "https://yoursite.com/webhook/submagic",
  "magicZooms": true,
  "magicBrolls": true,
  "magicBrollsPercentage": 60
}

Parameter Breakdown:

Parameter Value What It Does videoUrl HeyGen URL Input video to edit templateName "Hormozi 2" Caption style (bold, yellow, attention-grabbing) language "en" Auto-transcription language magicZooms true AI adds zoom emphasis on key words magicBrolls true AI inserts relevant B-roll footage magicBrollsPercentage 60 60% of video has B-roll overlays

Submagic Templates:

Popular options:
- "Hormozi 2": Bold yellow captions, high energy
- "Mr Beast": Large centered text, gaming style
- "Gary Vee": Minimalist, professional
- "Default": Clean, simple captions

Choose based on your brand aesthetic

Response:

{
  "id": "proj_abc123",
  "status": "processing"
}

Wait Loop (20 Seconds)

Why 20 seconds: Submagic processing for 30-45 second video = 2-3 minutes average. 20-second intervals = 6-9 checks.

Check Status Request:

// HTTP Request Node
Method: GET
URL: https://api.submagic.co/v1/projects/{{ $json.id }}
Authentication: Same HTTP Header Auth

Status Response:

{
  "id": "proj_abc123",
  "status": "processing" | "completed" | "failed",
  "downloadUrl": "https://submagic-downloads.s3.amazonaws.com/video_abc123.mp4"
}

Cloudinary Upload Step

Why Cloudinary:

Problem: Submagic download URLs expire after 24 hours

Solution: Upload to Cloudinary for permanent, fast CDN URL

Benefit: Instagram/YouTube APIs need stable URLs

Cloudinary Upload Node:

// Cloudinary - Upload Asset from URL
URL: {{ $json.downloadUrl }} (from Submagic)
Resource Type: video
Additional Fields: (leave empty for defaults)

Cloudinary Credentials Setup:

Sign up at cloudinary.com

Dashboard → Account Details

Copy: Cloud Name, API Key, API Secret

Add to n8n credentials

Output:

{
  "secure_url": "https://res.cloudinary.com/your-cloud/video/upload/v123/video.mp4",
  "public_id": "video",
  "resource_type": "video"
}

Final Return:

// Edit Fields Node
Output: {{ $json.secure_url }}
// Returns Cloudinary URL to main agent

Tool 5: Upload Video (Sub-Workflow)

Sub-Workflow Architecture

Execute Workflow Trigger 
(receives: URL, youtube_title, ig_caption)
    ↓
Upload-Post API: Publish to Instagram + YouTube
    ↓
Output: Instagram URL, YouTube URL

Upload-Post API Configuration

Why Upload-Post:

Alternative to manual APIs: Instagram Graph API + YouTube Data API = complex OAuth, rate limits, constant breakage

Upload-Post handles: Authentication, API changes, platform-specific formatting

Cost: $0.10 per upload (both platforms)

Upload Post Node:

// Upload Post Node (Community Node)
Operation: Upload Video
User: "n8n-tutorial" (your Upload-Post username)
Platform: [ "instagram", "youtube" ]
Title: {{ $json.youtube_title }}
Caption: {{ $json.ig_caption }}
Video: {{ $json.URL }} (Cloudinary URL)
YouTube Category ID: (leave empty for default)

Credentials Setup:

Sign up at upload-post.com or similar service

Connect Instagram + YouTube accounts in their dashboard

Generate API key

Add to n8n Upload-Post credential

What Happens:

Upload-Post downloads video from Cloudinary URL

Formats for Instagram (Reels specs)

Formats for YouTube (Shorts specs)

Uploads to both platforms simultaneously

Returns published URLs

Response:

{
  "instagram": {
    "url": "https://www.instagram.com/reel/ABC123xyz/",
    "status": "published"
  },
  "youtube": {
    "url": "https://www.youtube.com/shorts/DEF456abc",
    "status": "published"
  }
}

Alternative: Direct Platform APIs

If you want to avoid Upload-Post costs:

Instagram Graph API:

1. Create Instagram container
   POST: https://graph.facebook.com/v18.0/{ig-user-id}/media
   Body: { video_url, caption, media_type: "REELS" }

2. Publish container
   POST: https://graph.facebook.com/v18.0/{ig-user-id}/media_publish
   Body: { creation_id }

YouTube Data API:

1. Upload video
   POST: https://www.googleapis.com/upload/youtube/v3/videos
   Body: Multipart form data with video file

2. Set metadata
   Body: { snippet: { title, description }, status: { privacyStatus: "public" } }

Trade-off:

Upload-Post: $0.10/video, zero maintenance

Direct APIs: Free, high maintenance (OAuth refresh tokens, API changes)

The Complete User Journey

Session Example: From Idea to Published Video

User Input 1:

User: "Research trending AI topics and suggest 3 video ideas"

Agent Response 1:

I''ve researched the latest AI news from TechCrunch. Here are 3 video ideas:

1. **Anthropic''s New Computer Use Feature**
   What: Claude can now control your computer
   Angle: "AI agents just learned to use Photoshop—creatives should pay attention"
   URL: https://techcrunch.com/2024/10/...

2. **Meta''s Movie Gen**
   What: Generate 16-second HD videos from text
   Angle: "This free tool just killed $500 video editing subscriptions"
   URL: https://techcrunch.com/2024/10/...

3. **Google''s NotebookLM Podcast Feature**
   What: AI generates podcast from your notes
   Angle: "I uploaded my business plan and got a 20-minute podcast analyzing it"
   URL: https://techcrunch.com/2024/10/...

Which would you like me to write a script for?

User Input 2:

User: "Let''s do #1 about Claude computer use"

Agent Action (Hidden from User):

1. Create data table entry:
   Upsert: { ideaURL: "https://techcrunch.com/2024/10/...", status: "pending" }
   Response: { id: "row_xyz789" }

2. Store ID internally: currentVideoID = "row_xyz789"

Agent Response 2:

Great choice! Here''s the content for approval:

**Script (38 seconds):**
"Anthropic just gave Claude the ability to control your computer. Yes, you heard that right. It can move your mouse, click buttons, and type text. I asked it to edit a photo in Photoshop, and it did it. No plugins, no API—it literally saw my screen and used the software like a human would. This isn''t just about automating tasks. This is AI becoming a coworker who can use any tool you can. The question isn''t ''can AI do my job?'' anymore. It''s ''why would I do this manually when AI can do it in seconds?'' The future just arrived, and it''s terrifying and exciting at the same time."

**YouTube Title:**
"Claude Can Now Control Your Computer—I Let It Use Photoshop"

**Instagram Caption:**
"Anthropic just dropped the most insane AI feature yet 🤯

Claude can now:
✅ Move your mouse
✅ Click buttons  
✅ Type text
✅ Use ANY software

I let it edit a photo in Photoshop and... it worked 😳

This changes everything about AI automation. Not just API integrations—it can literally use your computer like you do.

The future is here and it''s wild 🚀

#AI #Anthropic #Claude #Automation #TechNews"

Ready to proceed with production?

User Input 3:

User: "Approved, let''s make it"

Agent Actions (Autonomous, No More Approvals):

Action 1: Update Database

Upsert: {
  id: "row_xyz789",
  script: "Anthropic just gave Claude...",
  title: "Claude Can Now Control Your Computer...",
  description: "Anthropic just dropped..."
}

Action 2: Generate Video

Call Tool: Generate Video
Input: { script: "Anthropic just gave Claude..." }

Wait for response (60-90 seconds)...

Response: { output: "https://resource.heygen.com/video/abc123.mp4" }

Update Database:
Upsert: { id: "row_xyz789", heygenURL: "https://resource.heygen.com/..." }

Action 3: Edit Video

Call Tool: Edit Video
Input: { URL: "https://resource.heygen.com/video/abc123.mp4" }

Wait for response (2-3 minutes)...

Response: { output: "https://res.cloudinary.com/your-cloud/video/..." }

Update Database:
Upsert: { id: "row_xyz789", editedURL: "https://res.cloudinary.com/..." }

Action 4: Publish Video

Call Tool: Upload Video
Input: {
  URL: "https://res.cloudinary.com/...",
  youtube_title: "Claude Can Now Control Your Computer...",
  ig_caption: "Anthropic just dropped..."
}

Wait for response (30-60 seconds)...

Response: {
  instagram: { url: "https://instagram.com/reel/..." },
  youtube: { url: "https://youtube.com/shorts/..." }
}

Update Database:
Upsert: {
  id: "row_xyz789",
  instaURL: "https://instagram.com/reel/...",
  youtubeURL: "https://youtube.com/shorts/...",
  status: "published"
}

Agent Final Response:

✅ Video published successfully!

Instagram Reel: https://instagram.com/reel/ABC123
YouTube Short: https://youtube.com/shorts/DEF456

The video is now live on both platforms. Database updated with all URLs.

Would you like me to research more topics for your next video?

Total Time:

User active time: 2 minutes (reviewing, approving)

AI processing time: 4-6 minutes (generation, editing, uploading)

Total: 6-8 minutes from idea to published

Advanced Orchestration Techniques

Technique 1: Batch Processing Mode

Scenario: Generate 7 videos for the week on Sunday

Modified System Prompt Addition:

Batch Mode: When user says "batch mode" or "create 7 videos":
1. Research and present 10 topic ideas
2. User selects 7
3. For each selected topic:
   a. Write script + caption + title
   b. Present all 7 together for approval
   c. Once approved, generate all 7 videos sequentially
   d. Update user after each video completes
4. Provide summary report with all URLs

User Experience:

User: "Batch mode: create 7 videos for next week"

Agent: [Researches 10 topics, presents]

User: "I approve topics 1, 2, 4, 5, 7, 9, 10"

Agent: [Writes 7 scripts, presents all together]

User: "All approved"

Agent: "Starting batch production. This will take ~45 minutes for all 7 videos."

[Agent generates → edits → publishes each video sequentially]

Agent: "Batch complete! 7 videos published:
Video 1: IG https://... | YT https://...
Video 2: IG https://... | YT https://...
[...]
Total cost: $21.70"

Technique 2: Scheduled Autonomous Research

Setup: n8n Schedule Trigger → Call Main Workflow

// New Workflow: "Weekly Research Scheduler"
Schedule Trigger: Every Monday 9am
    ↓
HTTP Request: Call main workflow webhook
Body: { 
  message: "Research 5 trending AI topics and create database entries for each" 
}

Result:

Every Monday, agent autonomously researches

Creates 5 pending database entries

Sends you Slack notification: "5 video ideas ready for review"

You review and approve when ready

Technique 3: Performance-Based Re-posting

Enhanced Data Table Schema:

Add columns:
- ig_views (number)
- ig_likes (number)
- yt_views (number)
- yt_likes (number)
- engagement_rate (number, calculated)

Workflow Addition:

// New Workflow: "Engagement Tracker"
Schedule Trigger: Daily at 6pm
    ↓
Get Data Table: All videos from last 7 days
    ↓
For each video:
  - Instagram Graph API: Get insights
  - YouTube Data API: Get analytics
  - Update engagement metrics in database
    ↓
IF engagement_rate > 5% (high performing):
  - Add to "winners" list
    ↓
Every Sunday:
  - Re-post top 3 winners to TikTok (new platform)

Technique 4: Multi-Language Expansion

Modified System Prompt:

After publishing English video, offer:
"Would you like me to create Spanish, French, and Portuguese versions?"

If approved:
1. Translate script using GPT-4
2. Use HeyGen multi-lingual voices
3. Generate 3 additional videos
4. Publish to regional Instagram/YouTube accounts

Economics:

1 script → 4 languages = 4 videos
Cost: $3.10 × 4 = $12.40
Reach: 4x audience expansion', 9),
  ('e15a100c-329e-4a68-9329-f469e3e5fb48', '3d33f659-dabf-42f2-80b2-5af321653fdb', 'Multi-Platform AI Content Marketing Agent', 'Lesson Overview

What You''ll Build: A complete AI content marketing system that generates research-backed blog posts, LinkedIn thought leadership, Facebook engagement content, and fully edited short-form videos for YouTube, Instagram, and TikTok—all from a single topic input.

Time to Complete: 90-120 minutesDifficulty Level: Advanced IntermediatePrerequisites:

Active n8n instance (Cloud or self-hosted)

OpenAI API key

OpenRouter API account

Tavily API key (1,000 free credits)

HeyGen account ($29/month minimum)

Submagic account (optional, for video editing)

Google Drive API access

Cloudinary account (free tier)

Key Value Proposition: This isn''t just another "AI writes content" tutorial. This is an enterprise-grade content factory that coordinates multiple specialized AI agents, each optimized for specific platforms, working together under a master orchestrator. The result? Professional multi-platform content that would cost $2,000+ per campaign if outsourced.

The Content Marketing Reality

Traditional Content Marketing Process

Here''s what creating multi-platform content traditionally looks like:

Research & Topic Selection

Manual competitor analysis: 2-3 hours

Trend research across platforms: 1-2 hours

Keyword research and SEO analysis: 1 hour

Subtotal: 4-6 hours

Content Creation

LinkedIn post (1,300 chars, B2B focused): 45 minutes

Facebook post (600 words, storytelling): 1 hour

Instagram script (under 25 seconds): 30 minutes

Blog post (1,600+ words, researched): 3-4 hours

Subtotal: 6-7 hours

Media Creation

Custom images for each platform: 2 hours

Video recording and setup: 1-2 hours

Video editing (captions, B-roll, transitions): 3-4 hours

Subtotal: 6-8 hours

Quality Control & Publishing

Review and revisions: 2-3 hours

Formatting for each platform: 1 hour

Subtotal: 3-4 hours

TOTAL TRADITIONAL TIME: 19-25 hours per content campaignCost at $50/hour: $950-1,250 per campaignCost at $100/hour: $1,900-2,500 per campaign

The AI Agent System

Metric Traditional AI Agent System Improvement 

Total Time 20+ hours 8-10 minutes 

99.2% reduction Cost per Campaign $1,000-2,500 $0.50-2.00 

99.9% reduction Platforms Covered 1-2 (typical) 4 platforms 

200% increase Quality Consistency Variable Consistent Standardized 

Scaling Cost Linear Marginal Near-zero

The Transformation: From a multi-day, multi-person content operation to a single prompt execution that delivers professional, platform-optimized content across 4 channels in the time it takes to make coffee.

System Architecture: The Hierarchical Agent Orchestra

This system uses a hierarchical multi-agent architecture—think of it as a content marketing agency compressed into an n8n workflow:

┌─────────────────────────────────────────┐
│   Content Marketing Agent (CEO)          │
│   Model: Claude Sonnet 4.5              │
│   Role: Strategy & Orchestration        │
└─────────────┬───────────────────────────┘
              │
    ┌─────────┴─────────┐
    │                   │
    ▼                   ▼
┌─────────────┐   ┌─────────────┐
│  Research   │   │  Creation   │
│  Pipeline   │   │  Pipeline   │
└─────────────┘   └─────────────┘
     │                  │
     ▼                  ▼
┌──────────┐      ┌──────────┐
│ Tavily   │      │ Platform │
│ Search   │      │ Agents   │
│ RSS Feed │      └────┬─────┘
└──────────┘           │
                       ├─ LinkedIn Agent (GPT-4.1 mini)
                       ├─ Facebook Agent (GPT-4.1 mini)
                       ├─ Script Agent (GPT-4.1 mini)
                       ├─ Image Generator (GPT-4.1 mini)
                       ├─ Video Generator (HeyGen workflow)
                       ├─ Video Editor (Submagic workflow)
                       └─ Blog Writer (Multi-agent sub-workflow)
                              │
                              ▼
                        ┌──────────────┐
                        │ Data Table   │
                        │ (Storage)    │
                        └──────────────┘

Key Architectural Decisions:

Hierarchical Structure: Master agent (expensive model) delegates to specialized agents (cheap models)

Memory Management: 15-step context window prevents repetition across phases

Sequential Execution: Each platform completed before moving to next (prevents token waste)

Tool Modularity: Sub-workflows isolate complex operations (video generation, blog writing)

Central Data Store: n8n Data Table as single source of truth for all outputs

Phase-by-Phase Technical Build

Phase 1: Foundation - Chat Trigger & Master Agent

What it does: Establishes the entry point and primary orchestrator that coordinates all specialist agents.

Node 1: When chat message received

Setting Value Node Type Chat Trigger Configuration Default settings (no special config needed)

This creates a chat interface where you can interact with the agent. The webhook is automatically generated by n8n.

Node 2: Content Marketing Agent (Master Orchestrator)

Setting Value Node Type AI Agent System Message See full text below Max Iterations 30

System Message (Master Agent):

==========ROLE========
The current date is {{ $now }}

You are the Chief Content Officer for a content marketing team with 15+ years of experience in content marketing, SEO, and social media strategy.

You understand how to create content that drives engagement, builds authority, and converts readers into customers. You excel at delegating tasks and coordinating a team of specialist writers.

==========BASIC INSTRUCTIONS==========
Create and execute comprehensive, multi-platform content strategy that delivers maximum value to your target audience while building brand authority and engagement.

==========AVAILABLE TOOLS=============

1. Research Agent Tool
Purpose: Finds trending topics in industry/niche
How to use: give tool search queries and analyze the results

2. LinkedIn Writer Agent Tool
Purpose: Creates professional B2B LinkedIn posts
How to use: give tool a short content brief based on research from the research agent

3. Facebook Writer Agent Tool
Purpose: Creates engaging, casual Facebook posts for reach and engagement
How to use: give tool a short content brief based on research from the research agent

4. Instagram Script Agent Tool
Purpose: Creates compelling Instagram Reel scripts
How to use: give tool a short content brief based on research from the research agent

5. Image Generator Tool
Purpose: Creates images
How to use: give tool overall image concept tailored to the target platform based on research from the research agent

6. Generate video tool
Purpose: generates a talking head video and returns a video URL
How to use: give tool the script you get from the script writer tool. The script must be ONLY what is to be said. JSON friendly to prevent API breakage.

7. Edit video tool
Purpose: generates an engaging, edited video from a URL
How to use: give tool the URL output from the generate video tool

8. Write blog post tool
Purpose: generates a detailed blog post and outputs a google drive URL

9. Content Logger (Database Tool)
Purpose: Logs all created content to the central database
How to use: call this tool as soon you receive outputs from each tool to save data.

========YOUR WORKFLOW==========
Phase 1: Research & Topic Selection

Call Research Agent Tool
Request 3-5 trending topics based on user request
Review findings for engagement potential, uniqueness, and B2B relevance

Analyze & Select
Review content opportunity scores
Consider target keywords and search volume
Ask the user to select
Provide recommendations based on: timeliness, audience fit, content gap opportunity

DO EACH PHASE ONE AFTER ANOTHER, NOT CONCURRENTLY.

Phase 2: LinkedIn Content Creation and Publishing
Write LinkedIn and generate LinkedIn image concurrently. Once you receive completed content, log content to Data Table.

Phase 3: FB Content Creation and Publishing
Write Facebook post and generate image concurrently. Once you receive completed content, log content to Data Table.

Phase 4: Instagram Content Creation and Publishing
Write Instagram script, then send script to Generate Video Workflow, then send result URL to Edit Video tool. Generate a caption for Instagram, and add the caption with the edit video tool''s URL to the data table.

Phase 5: Blog post creation and publishing
Send topic to blog post creation workflow and give instructions to image generation workflow. Log outputs to data table

Content Requirements
Quality Standards

✅ Original and valuable - No generic or recycled content
✅ Actionable insights - Readers can implement immediately
✅ Data-driven - Include stats, examples, case studies when possible
✅ Professional but approachable - Expert knowledge in accessible language
✅ Platform-optimized - Each piece tailored to its platform

Target Audience

Primary: Business professionals, marketers, digital strategists
Secondary: Executives, entrepreneurs, tech-savvy decision-makers
Content Level: Intermediate to advanced (avoid beginner-only content)

Important Notes

Always start with research - Never skip the Research Agent Tool
Quality over speed - Take time to review each piece
Platform specificity - Don''t reuse content across platforms without adaptation
Document everything - The database is your team''s memory
Be decisive - When selecting topics, commit fully and execute

Your First Action
Begin by calling the Research Agent Tool to identify trending topics. Once you receive the research, analyze the findings and select the best topic for this week''s content strategy. Then get approval for the topic and angle, ask about which mediums to create content for, and start.

Why this matters:

The {{ $now }} expression is critical—it tells the AI the current date since models are trained on historical data. The detailed workflow instructions ensure the agent executes phases sequentially, preventing it from trying to do everything at once and burning through tokens.

Common Issues:

❌ Agent calls wrong tools in wrong order→ Solution: Make workflow section more explicit with numbered phases and "DO EACH PHASE ONE AFTER ANOTHER, NOT CONCURRENTLY" instruction

❌ Agent repeats same content across platforms→ Solution: Add memory node (covered next)

Phase 2: Memory System - Preventing Repetition

What it does: Gives the master agent a 15-step memory so it remembers what it already created and doesn''t duplicate work.

Node: Simple Memory

Setting Value Node Type Window Buffer Memory Session ID ={{ $json.sessionId }} Context Window Length 15

Connection: Connect this node to the Memory input of the Content Marketing Agent node.

Why this matters:

Without memory, the agent would:

Create LinkedIn post

Forget it created LinkedIn post

Create another LinkedIn post when you ask for Facebook

Burn through your API credits creating duplicates

With a 15-step window, it remembers all prior actions in the conversation, preventing duplication.

CRITICAL: The context window must be longer than your workflow steps. If you have 5 platforms × 2-3 steps each = 10-15 steps total, use contextWindowLength: 15 minimum (or 20 to be safe).

Phase 3: Brain Connection - OpenRouter Chat Model

What it does: Connects the master agent to Claude Sonnet 4.5 via OpenRouter for intelligent orchestration.

Node: OpenRouter Chat Model

Setting Value Node Type OpenRouter Chat Model Model anthropic/claude-sonnet-4.5 Credentials Your OpenRouter API credentials

Connection: Connect this node to the Model input of the Content Marketing Agent node.

Setting Up OpenRouter:

1. Go to openrouter.ai
2. Sign up and add credits ($5 minimum)
3. Go to Keys → Create new key
4. Copy the API key
5. In n8n: Credentials → Add → OpenRouter API
6. Paste key, test connection

Why Claude Sonnet 4.5:

Model Cost per 1M tokens Tool Use Quality Best For GPT-4 $30 Good General tasks Claude Sonnet 4.5 $3 Excellent Complex orchestration GPT-4.1 mini $0.15 Fair Simple tasks

Claude Sonnet 4.5 is 10x cheaper than GPT-4 but significantly better at managing multiple tools and making strategic decisions about what to do next.

Phase 4: Research Pipeline - Agent with Tavily Search

What it does: The research agent searches the web for trending topics, analyzes content opportunities, and returns structured recommendations.

Node: Research Agent Tool

Setting Value Node Type AI Agent Tool Name Research Agent Tool Tool Description "Research Agent: Finds trending topics in technology, AI, and digital marketing. Returns structured data about current trends, viral content angles, competitor insights, and content opportunities. Use this tool first to identify what topics to create content about." Prompt ={{ $fromAI(''Prompt__User_Message_'', '''', ''string'') }} System Message See below Max Iterations 5

Connection: Connect this node to a Tool input of the Content Marketing Agent.

System Message (Research Agent):

You are an expert content researcher specializing in technology, AI, and digital marketing trends. You have access to real-time data about trending topics, viral content, and audience interests. You excel at identifying content opportunities before they become oversaturated. Your research is data-driven and actionable.

When presenting research findings, include:
- Content opportunity score (1-10)
- Target keyword volume estimates
- Competitor gap analysis
- Timeliness factor (why now?)
- Specific angle recommendations

Format your response as a numbered list of 3-5 content ideas with clear descriptions.

Node: GPT 4.1 - mini (Brain for Research Agent)

Setting Value Node Type OpenAI Chat Model Model gpt-4.1-mini Max Tokens 2000 Temperature 0.8 Credentials Your OpenAI API credentials

Connection: Connect this node to the Model input of the Research Agent Tool.

Node: Search in Tavily

Setting Value Node Type Tavily Tool Query ={{ $fromAI(''Query'', '''', ''string'') }} Credentials Your Tavily API credentials

Connection: Connect this node to a Tool input of the Research Agent Tool.

Setting Up Tavily:

1. Go to tavily.com
2. Sign up (free tier = 1,000 searches/month)
3. Dashboard → Copy API key
4. In n8n: Credentials → Add → Tavily API
5. Paste key, save

Node: RSS Read (Optional)

Setting Value Node Type RSS Feed Read Tool URL ={{ $fromAI(''URL'', '''', ''string'') }}

Connection: Connect this node to a Tool input of the Research Agent Tool (if you want RSS capability).

Why Nested Agents Work Better:

Single approach: Master does everything
- Master uses Claude Sonnet 4.5 ($3/1M tokens)
- All research uses expensive model
- Cost: High

Nested approach: Research has its own brain
- Master uses Claude Sonnet 4.5 ($3/1M tokens) - orchestration only
- Research uses GPT-4.1 mini ($0.15/1M tokens) - research only
- Cost: 77% cheaper
- Quality: Better (specialized focus)

Phase 5: Platform Writer Agents - Specialized Content Creation

What it does: Each platform gets a dedicated AI agent tuned for that platform''s style, tone, and constraints.

LinkedIn Writer Agent

Node: LinkedIn Writer Agent Tool

Setting Value Node Type AI Agent Tool Name LinkedIn Writer Agent Tool Tool Description "LinkedIn Writer Agent: Creates professional LinkedIn posts optimized for B2B engagement. Returns posts up to 1300 characters with hooks, value propositions, and professional CTAs. Includes hashtag recommendations." Prompt ={{ $fromAI(''Prompt__User_Message_'', '''', ''string'') }} System Message See below Max Iterations 3

Connection: Connect this node to a Tool input of the Content Marketing Agent.

System Message (LinkedIn Writer):

You are a LinkedIn content specialist who understands B2B social media marketing. You create posts that drive engagement, build thought leadership, and generate conversations. Your posts use the AIDA framework (Attention, Interest, Desire, Action) and are optimized for LinkedIn''s algorithm.

Requirements:
- Length: 1000-1300 characters
- Professional B2B tone
- Strong hook in first line
- Value-driven content
- Include call-to-action
- 3-5 relevant hashtags
- Format for high engagement (line breaks, emojis sparingly)

Target audience: Business professionals, marketers, executives

Node: GPT 4.1 - mini (Brain for LinkedIn Agent)

Setting Value Node Type OpenAI Chat Model Model gpt-4.1-mini Max Tokens 2000 Temperature 0.8

Connection: Connect to Model input of LinkedIn Writer Agent Tool.

Facebook Writer Agent

Node: Facebook Writer Agent Tool

Setting Value Node Type AI Agent Tool Name Facebook Writer Agent Tool Tool Description "Facebook Writer Agent: Creates engaging, casual Facebook posts optimized for reach and engagement. Returns posts with storytelling elements, emotional hooks, and casual CTAs." Prompt ={{ $fromAI(''Prompt__User_Message_'', '''', ''string'') }} System Message See below Max Iterations 3

Connection: Connect this node to a Tool input of the Content Marketing Agent.

System Message (Facebook Writer):

You are a Facebook content specialist who excels at creating viral, engaging posts. You understand Facebook''s algorithm and audience psychology. Your posts tell stories, evoke emotions, and drive conversations. You balance professionalism with relatability.

Requirements:
- Length: 400-600 words
- Casual, conversational tone
- Storytelling approach
- Emotional connection
- Clear call-to-action
- Emojis allowed (use strategically)
- Encourage comments and shares

Target audience: General business audience, accessible to non-technical readers

Node: GPT 4.1 - mini (Brain for Facebook Agent)

Same configuration as LinkedIn brain, but connect to Model input of Facebook Writer Agent Tool.

Instagram Script Agent

Node: Shorts Script Agent Tool

Setting Value Node Type AI Agent Tool Name Shorts Script Agent Tool Tool Description "Instagram Writer Agent: Creates compelling Instagram captions with strategic hashtag use. Returns captions optimized for visual storytelling with 15-20 relevant hashtags." Prompt ={{ $fromAI(''Prompt__User_Message_'', '''', ''string'') }} System Message See below Max Iterations 3

Connection: Connect this node to a Tool input of the Content Marketing Agent.

System Message (Instagram Script):

You are an Instagram content specialist. You create reel scripts under 25 seconds. They have a strong hook and content gaps and reward cycles throughout.

Structure your scripts:
[HOOK - First 3 seconds - Must grab attention]
[MIDDLE - 15 seconds - Build curiosity, provide value]
[PAYOFF - 7 seconds - Clear takeaway or CTA]

The script should be spoken naturally and fit within 25 seconds when read aloud at normal pace.

Node: GPT 4.1 - mini (Brain for Script Agent)

Same configuration, connect to Model input of Shorts Script Agent Tool.

Why Separate Agents for Each Platform:

Single Agent Approach Multi-Agent Approach ❌ Generic content ✅ Platform-optimized ❌ Tone inconsistency ✅ Consistent per platform ❌ Character limit errors ✅ Built-in constraints ❌ One model (expensive) ✅ Cheap models for execution

Cost Comparison Per Campaign:

Single Master Agent doing everything:
- Claude Sonnet 4.5: $3 per 1M input tokens
- 5 platforms × 2,000 tokens = 10,000 tokens
- Cost per campaign: $0.03

Multi-Agent Approach:
- Master (Sonnet 4.5): 2,000 tokens = $0.006
- 5 specialists (GPT-4.1 mini): 8,000 tokens = $0.0012
- Cost per campaign: $0.0072

Savings: 76% cheaper + higher quality

Phase 6: Image Generation Pipeline - Platform-Specific Visuals

What it does: Creates custom images tailored to each platform''s aesthetic and requirements (LinkedIn = professional, Facebook = engaging, Blog = featured image).

Architecture:

Master Agent → Image Generator Agent → Generate Image Workflow → Google Drive

Step 1: Image Generator Agent (Orchestrator)

Node: Image Generator Tool

Setting Value Node Type AI Agent Tool Name Image Generator Tool Tool Description "use this tool to generate an image" Prompt ={{ $fromAI(''Prompt__User_Message_'', '''', ''string'') }} System Message "you are an expert at crafting image generation prompts for a variety of mediums such as facebook, instagram, linkedin. Your output should be JUST the URL and the target platform"

Connection: Connect this node to a Tool input of the Content Marketing Agent.

Node: GPT 4.1 - mini (Brain for Image Generator)

Setting Value Node Type OpenAI Chat Model Model gpt-4.1-mini Max Tokens 2000 Temperature 0.8

Connection: Connect to Model input of Image Generator Tool.

Node: Window Buffer Memory (for Image Generator)

Setting Value Context Window Length 5

Connection: Connect to Memory input of Image Generator Tool.

This small memory helps the image generator remember which platforms it''s already created images for.

Step 2: Generate Image Workflow (Execution)

Node: Generate Image with Nano Banana

Setting Value Node Type Workflow Tool Description "call this tool to generate an image" Workflow Select "(Sub) Image Generator" workflow Workflow Inputs image_prompt = ={{ $fromAI(''image_prompt'', '''', ''string'') }}

Connection: Connect this node to a Tool input of the Image Generator Tool.

Step 3: Sub-Workflow - (Sub) Image Generator

Create a new workflow called (Sub) Image Generator

Node 1: When executed by another workflow

Setting Value Node Type Execute Workflow Trigger Fields Add field: image_prompt (type: string)

Node 2: HTTP Request - Call Gemini via OpenRouter

Setting Value Method POST URL https://openrouter.ai/api/v1/chat/completions Authentication Predefined Credential Type Credential Type OpenRouter API Send Body Yes Body Content Type JSON

Body (JSON):

{
  "model": "google/gemini-2.5-flash-preview",
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": "={{ $json.image_prompt }}"
        },
        {
          "type": "text",
          "text": "Generate image"
        }
      ]
    }
  ]
}

Why Gemini 2.5 Flash:

Google''s newest image model (released Nov 2024)

Dramatically better quality than DALL-E 3

Returns base64-encoded images

Cost: ~$0.000001 per image vs DALL-E''s $0.040

Node 3: Convert to File

Setting Value Node Type Convert to File Mode Base64 to File Binary Data ={{ $json.choices[0].message.content.split('','')[1] }} File Name ={{ $now.format(''yyyy-MM-dd-HHmmss'') }}-generated.png MIME Type image/png Options → Property Name data

CRITICAL Expression Breakdown:

$json.choices[0].message.content
// Gets: "data:image/png;base64,iVBORw0KG..."

.split('','')[1]
// Splits on comma, takes second part (after base64,)
// Result: "iVBORw0KG..." (pure base64)

This strips the data:image/png;base64, prefix that Gemini includes, leaving only the raw base64 data that n8n needs.

Node 4: Google Drive - Upload

Setting Value Node Type Google Drive Resource File Operation Upload Binary Data Yes File Name ={{ $now.format(''yyyy-MM-dd-HHmmss'') }}-content-image.png Resolve Data Yes ✅ (Important!) Options → Google File Convert No ❌

Credentials Setup:

1. Google Cloud Console → Enable Google Drive API
2. Create OAuth 2.0 credentials
3. Add redirect URI: https://[your-n8n-url]/rest/oauth2-credential/callback
4. Copy Client ID and Client Secret
5. In n8n: Credentials → Google Drive OAuth2
6. Paste credentials, authenticate

Node 5: Google Drive - Share

Setting Value Node Type Google Drive Resource File Operation Share File ID ={{ $json.id }} Permissions → Role reader Permissions → Type anyone

This makes the file publicly accessible without requiring authentication.

Node 6: Edit Fields (Set) - Return Only URL

Setting Value Node Type Edit Fields (Set) Mode Manual Mapping Fields to Set imageURL = ={{ $(''Google Drive'').item.json.webContentLink }} Options → Keep Only Set Yes ✅

This ensures only the image URL is returned to the master workflow, keeping the data clean.

Full Image Pipeline Flow:

Trigger (get prompt) 
  → HTTP Request (Gemini generates base64)
  → Convert to File (base64 → PNG)
  → Upload to Drive (gets file ID)
  → Share file (makes public)
  → Edit Fields (return only URL)

Phase 7: Video Generation Pipeline - HeyGen Integration

What it does: Converts Instagram scripts into professionally recorded talking-head videos using AI avatars.

Step 1: Video Generation Workflow Tool

Node: Call ''(Sub) Script to HeyGen''

Setting Value Node Type Workflow Tool Description "call this tool to generate a video" Workflow Select "(Sub) Script to HeyGen" workflow Workflow Inputs script = ={{ $fromAI(''script'', '''', ''string'') }}

Connection: Connect this node to a Tool input of the Content Marketing Agent.

Step 2: Sub-Workflow - (Sub) Script to HeyGen

Create a new workflow called (Sub) Script to HeyGen

Node 1: When executed by another workflow

Setting Value Node Type Execute Workflow Trigger Fields Add field: script (type: string)

Node 2: HTTP Request - Start Video Generation

Setting Value Method POST URL https://api.heygen.com/v2/video/generate Authentication Generic Credential Type Generic Auth Type Header Auth Send Body Yes Body Content Type JSON

Header Auth Credentials:

Setting Value Name x-api-key Value [Your HeyGen API key]

Body (JSON):

{
  "video_inputs": [
    {
      "character": {
        "type": "avatar",
        "avatar_id": "Angela-inblackskirt-20220820",
        "avatar_style": "normal"
      },
      "voice": {
        "type": "text",
        "voice_id": "1bd001e7e50f421d891986aad5158bc8",
        "input_text": "={{ $json.script }}"
      },
      "background": {
        "type": "color",
        "value": "#ffffff"
      }
    }
  ],
  "dimension": {
    "width": 1080,
    "height": 1920
  },
  "test": false
}

Customization Guide:

# Get Avatar ID:
1. HeyGen → Avatars → Public Avatars
2. Click avatar you want
3. In URL, find: ?default_look_id=Angela-inblackskirt-20220820
4. Copy the ID after "default_look_id="

# Get Voice ID:
1. HeyGen → Voices → Choose voice
2. Click "Get Voice ID"
3. Copy to clipboard

# Dimensions:
- Instagram/TikTok: 1080 x 1920 (vertical)
- YouTube: 1920 x 1080 (horizontal)

Node 3: Wait

Setting Value Amount 10 Unit Seconds

Why wait? HeyGen video generation takes 1-3 minutes. We poll every 10 seconds to check if it''s done.

Node 4: HTTP Request - Check Status

Setting Value Method GET URL https://api.heygen.com/v1/video_status.get Authentication Same Header Auth as above Send Query Yes

Query Parameters:

Name Value video_id ={{ $(''HTTP Request'').item.json.data.video_id }}

This references the video ID returned from the first HTTP Request node.

Node 5: Switch (Route Based on Status)

Setting Value Node Type Switch Mode Rules

Rule 1 - Failed:

Setting Value Output 0 Condition ={{ $json.data.status }} equals failed

Rule 2 - Completed:

Setting Value Output 1 Condition ={{ $json.data.status }} equals completed

Fallback Output: 2 (processing - loop back)

Node 6: Edit Fields - Failed Output

Connect to Output 0 of Switch.

Setting Value Mode Manual Mapping Fields to Set error = Video generation failed

Node 7: Edit Fields - Success Output

Connect to Output 1 of Switch.

Setting Value Mode Manual Mapping Fields to Set videoURL = ={{ $json.data.video_url }} Keep Only Set Yes ✅

Node 8: Loop Back to Wait

Connect Output 2 (fallback) of Switch back to the Wait node.

Visual Flow:

Start Generation 
  → Wait 10s 
  → Check Status 
  → Switch:
      ├─ Failed → Return Error
      ├─ Completed → Return URL
      └─ Processing → Loop back to Wait

CRITICAL: This polling loop will continue until HeyGen returns either "completed" or "failed". Typically takes 5-10 iterations (50-100 seconds).

Phase 8: Video Editing Pipeline - Submagic Integration

What it does: Takes raw HeyGen video and adds professional captions, B-roll, zooms, and transitions automatically.

Step 1: Video Editing Workflow Tool

Node: Call ''(Sub) Video to Submagic''

Setting Value Node Type Workflow Tool Description "call this tool to edit a generated video" Workflow Select "(Sub) Video to Submagic" workflow Workflow Inputs URL = ={{ $fromAI(''URL'', ''the URL returned by the script to heygen tool'', ''string'') }}

Connection: Connect this node to a Tool input of the Content Marketing Agent.

Step 2: Sub-Workflow - (Sub) Video to Submagic

Create a new workflow called (Sub) Video to Submagic

Node 1: When executed by another workflow

Setting Value Node Type Execute Workflow Trigger Fields Add field: URL (type: string)

Node 2: HTTP Request - Start Edit

Setting Value Method POST URL https://api.submagic.com/v1/edit Authentication Set up Submagic credentials Send Body Yes Body Content Type JSON

Body (JSON):

{
  "video_url": "={{ $json.URL }}",
  "template_name": "MrBeast Style",
  "magic_zooms": true,
  "magic_brolls": true,
  "broll_count": 3
}

Template Options:

Template Style Best For MrBeast Style Fast cuts, dynamic Viral content Alex Hormozi Professional B2B Business content Default Clean, minimal General use Podcast Style Centered speaker Talking head

Nodes 3-5: Same Polling Pattern as HeyGen

Wait - 10 seconds

HTTP Request - Check Status - GET request to Submagic status endpoint

Switch - Route based on status (failed/completed/processing)

The pattern is identical to HeyGen, just with different API endpoints.

Node 6: Cloudinary Upload

Connect to completed output of Switch.

Setting Value Node Type Cloudinary Operation Upload Upload Type URL URL ={{ $json.data.video_url }} Resource Type video Options → Public ID content-marketing/{{ $now.format(''yyyy-MM-dd-HHmmss'') }}

Why Cloudinary Instead of Google Drive:

Issue Google Drive Cloudinary Large video upload Requires download first (crashes n8n) Direct URL-to-URL Max file size 100MB 100MB+ handled easily Setup complexity High Low Free tier 15GB total 25GB/month bandwidth

Cloudinary Setup:

1. Sign up at cloudinary.com
2. Dashboard → Copy:
   - Cloud Name
   - API Key
   - API Secret
3. In n8n: Credentials → Cloudinary
4. Paste credentials, save

Node 7: Edit Fields - Return URL

Setting Value Mode Manual Mapping Fields to Set editedVideoURL = ={{ $json.secure_url }} Keep Only Set Yes ✅

Phase 9: Blog Writing Pipeline - Multi-Agent Research & Writing

What it does: Generates comprehensive, research-backed blog posts (1,600+ words) with proper structure, citations, and HTML formatting.

Architecture:

Master Agent → Blog Tool → Blog Workflow
                              ├─ Structure Generator
                              ├─ Research Agent (per section)
                              ├─ Writing Agent (per section)
                              └─ Google Docs

Node: Write Blog Post

Setting Value Node Type Workflow Tool Description "call this tool to write a blog post" Workflow Select "(Sub) Write Blog Post" workflow Workflow Inputs topic = ={{ $fromAI(''topic'', '''', ''string'') }}

Connection: Connect this node to a Tool input of the Content Marketing Agent.

Blog Sub-Workflow Structure:

Due to the complexity of the blog writing workflow (it involves multiple agents, loops, and Google Docs integration), here''s the high-level structure:

Phase 1: Structure Generator Agent

Takes topic

Returns JSON with sections and subsections

Uses Tavily for research on blog structure

Phase 2: Loop Through Sections

For each section, call Research Agent

Research Agent uses Tavily to find stats, quotes, examples

Returns research notes

Phase 3: Writing Agent

Takes research notes

Writes 200-400 words for that section

Includes HTML formatting

Phase 4: Append to Google Doc

After each section is written, immediately append to doc

This prevents context window overflow

Ensures complete blog posts

The blog writing workflow is the most complex component but follows the same principles: specialized agents, clear instructions, and iterative execution.

Phase 10: Data Table - Central Content Repository

What it does: Stores all generated content in a structured database for review, editing, and publishing.

Step 1: Create the Data Table

1. n8n → Data Tables (top menu)
2. Create new table
3. Name: "Content Marketing Team"
4. Add columns:

Column Name Type Description topic String The content topic mainContent String Post text or script Platform String LinkedIn, Facebook, Instagram, Blog mediaURL String Image or video URL caption String For Instagram captions publishedURL String After manual publishing blogPostURL String Google Docs URL for blog

Step 2: Get Rows Tool (Optional)

Node: Get row(s) in Data table

Setting Value Node Type Data Table Tool Operation Get Data Table Content Marketing Team Return All ={{ $fromAI(''Return_All'', '''', ''boolean'') }}

Connection: Connect this node to a Tool input of the Content Marketing Agent.

Why this exists: Allows the agent to retrieve previously created content if an execution fails midway and you want to resume.

Step 3: Insert Row Tool (Primary)

Node: Insert row in Data table

Connection: Connect this node to a Tool input of the Content Marketing Agent.

Why Every Field Uses $fromAI():

This special expression tells the master agent: "You decide what goes in each field based on the tool outputs you received."

The agent automatically:

Maps LinkedIn post text → mainContent column

Maps image URL → mediaURL column

Maps "LinkedIn" → Platform column

Leaves irrelevant fields blank (e.g., blogPostURL for Instagram)

Agent Behavior Example:

Agent creates LinkedIn post → Receives:
- Post text: "The future of dental education..."
- Image URL: "https://drive.google.com/..."

Agent thinks:
- topic = "Dental AI Education"
- mainContent = [the post text]
- Platform = "LinkedIn"
- mediaURL = [the image URL]
- caption = "" (not needed for LinkedIn)
- publishedURL = "" (not published yet)
- blogPostURL = "" (this isn''t a blog)

Agent calls Insert tool with these values

Complete Workflow Testing

Test Scenario 1: Full Multi-Platform Campaign

Step 1: Start Fresh Chat

Open your n8n chat interface and type:

Find me content ideas for dentists and AI

Agent Response (Research Phase):

I''ll search for trending content ideas in the dentist AI space. Let me analyze the current landscape...

[Calls Research Agent → Tavily searches web]

Top content angles for dentists and AI:

1. **AI vs the Human Touch: How Smart Dentists Use Both**
   - Opportunity Score: 8/10
   - Why now: Growing concern about AI replacing practitioners
   - Angle: Show integration, not replacement

2. **The AI-Powered Patient Experience Revolution**
   - Opportunity Score: 9/10
   - Why now: Patient expectations changing post-COVID
   - Angle: Practical improvements patients can see

3. **AI Practice Management: From Chaos to Clarity**
   - Opportunity Score: 7/10
   - Why now: Post-pandemic operational challenges
   - Angle: Specific systems and ROI

4. **AI Diagnostics: Catching Problems Before They Start**
   - Opportunity Score: 8/10
   - Why now: New FDA-approved AI diagnostic tools
   - Angle: Preventive care revolution

5. **The Future of Dental Education with AI**
   - Opportunity Score: 9/10
   - Why now: Dental schools adopting VR/AI
   - Angle: Next generation of dentists

Which angle would you like me to create content for? And which platforms should I target?

Your Response:

Let''s do #5 and create content for all platforms

Agent Final Response:

✅ Mission complete! Multi-platform content strategy executed.

Created content for "The Future of Dental Education with AI":

✅ LinkedIn post (1,247 characters) with professional image
✅ Facebook post (584 words) with engaging image  
✅ Instagram Reel (23 seconds) - fully edited with captions
✅ Blog post (1,643 words) - research-backed with examples

All content has been saved to your data table. You can review and publish when ready.

Would you like me to create content for another topic?

Accessing Your Content

Step 1: Go to Data Tables

1. n8n top menu → Data Tables
2. Click "Content Marketing Team"
3. Click "Refresh" icon

Step 2: Review Content

You''ll see 4 rows:

Row 1 - LinkedIn:

Column Value topic The Future of Dental Education with AI mainContent "The future of dental education is being written right now—and AI is holding the pen..." [full post] Platform LinkedIn mediaURL https://drive.google.com/file/d/1a2b3c4d... caption [empty]

Row 2 - Facebook:

Column Value topic The Future of Dental Education with AI mainContent "Remember your first day of dental school? The overwhelming feeling of..." [full post] Platform Facebook mediaURL https://drive.google.com/file/d/5e6f7g8h...

Row 3 - Instagram:

Column Value topic The Future of Dental Education with AI mainContent [Script: "What if AI could change everything in dentistry?..."] Platform Instagram mediaURL https://res.cloudinary.com/your-cloud/video/... caption "The next generation of dentists won''t just have steady hands—they''ll have AI assistants. 🦷✨..."

Row 4 - Blog:

Column Value topic The Future of Dental Education with AI Platform Blog blogPostURL https://docs.google.com/document/d/...

Business Impact

🎯 Operational Transformation

Before: 20+ hours per campaign, $1,000-2,500 cost

After: 8-10 minutes, $2.43 cost

Result: 99.2% time reduction, 99.9% cost reduction

💰 Economic Leverage

Marginal cost per campaign: $2.43

Market price per campaign: $1,500-3,000

Gross margin: 99.8%

Scales linearly with no capacity constraints

📈 Scaling Characteristics

Fixed costs: ~$300/month (infrastructure)

Variable costs: ~$2.43/campaign

Breakeven: <1 campaign per month

Profitable from day 1

🚀 Market Positioning

Compete with $50/hour freelancers at $0.017/hour effective rate

Compete with $2,500 agencies at $2.43 cost

Compete with 20-hour timelines at 8-minute delivery

Unfair advantage through AI automation

Strategic Insights

🧠 Agent Orchestration Principles

Use expensive models only for decisions
Master uses Claude Sonnet ($3/1M tokens) for orchestration

Specialists use GPT-4.1 mini ($0.15/1M tokens) for execution

20x cost difference, but Master only does 10% of work

Give each agent appropriate memory
Master: 15-20 steps (needs full context)

Specialists: 3-5 steps (narrow focus)

Don''t over-provision memory (costs tokens)

Test agents independently
Research agent works? ✓

LinkedIn agent works? ✓

Combined system works? ✓

Easier debugging than monolithic approach

Let AI handle data mapping
{{ $fromAI() }} expressions let agent decide

No manual field mapping required

Agent figures out "LinkedIn post → mainContent column"

🔄 Workflow Design Patterns

Sub-workflows for multi-step operations
Image generation: 6 nodes → 1 workflow tool

Video generation: 8 nodes → 1 workflow tool

Keeps main workflow clean and readable

Polling loops for async tasks
Don''t wait blindly (wastes time)

Don''t give up (incomplete results)

Poll intelligently (check every 10s)

Sequential execution for AI agents
Phase 1 → Phase 2 → Phase 3 (ordered)

NOT Phase 1 + 2 + 3 concurrently

Prevents token waste and confusion

Central data stores
Data Table = single source of truth

All outputs logged here

Easy review before publishing

No scattered files/results

💡 Production Readiness

This isn''t a tutorial project—it''s production-ready:

✅ Used by real agencies for client work✅ Handles errors gracefully (retry logic, fallbacks)✅ Monitors cost per execution (predictable economics)✅ Scales without code changes (just add API credits)

Critical Success Factors:

API keys properly configured

Memory settings appropriate for task complexity

Polling loops for long-running operations

Data validation before insertion

Regular monitoring and maintenance

Real-World Applications

Who This Is For:

Solo creators - Automate your content factory, reclaim 60+ hours/month

Agencies - Deliver $1,500 campaigns at $2.43 cost, scale to 50+ clients

SaaS founders - White label as $297/month product, 85% margins

Freelancers - Offer premium service at freelancer prices, 10x your income

Consultants - Build custom versions for clients, charge $5k-10k setup fees', 10),
  ('faff14f5-ecb2-4d09-a060-623de1aed079', '3d33f659-dabf-42f2-80b2-5af321653fdb', 'Agentic Social Media Dashboard (Claude Code)', 'Build a Social Media Intelligence Pipeline with Claude Code

What you''ll have at the end: A command you run once a week that scrapes your competitor accounts on Twitter, YouTube, and LinkedIn — then spits out 3 tweets, 3 LinkedIn posts, and 3 YouTube Short ideas, grounded in what''s actually working right now. One HTML file, ready to act on.

Why not n8n?

n8n is great for connecting two apps. It falls apart when you need reasoning.

A typical n8n content pipeline looks like this:

12+ nodes

3 HTTP request blocks with hardcoded API keys

A "Set" node that patches data between incompatible schemas

One brittle regex that breaks when Twitter changes a field name

Zero ability to ask "why is this post performing?"

When it breaks (and it will), you''re debugging JSON paths in a visual editor with no stack trace.

The code-first alternative:

~600 lines of Python across 6 files

Two phases: scrape first, analyze separately (so you never re-pay Apify costs while iterating)

Claude does the reasoning — not a prompt template duct-taped into a text node

When it breaks, you get a real error message on a real line number

How it works (2 minutes)

run.py "last 7 days"
    │
    ├── scrape.py  →  Apify scrapes Twitter/YouTube/LinkedIn
    │                  saves raw JSON to data/
    │
    └── analyze.py →  loads cache → builds prompt → claude -p
                       saves output/last-7-days-social-media-posts.html

The two-phase design means: scrape once, iterate on the analysis as many times as you want for free.

Setup (5 steps)

1. Clone the repo

git clone https://github.com/shabbirun/social-media-automation-agentic.git
cd social-media-automation-agentic

2. Install dependencies

pip install -r requirements.txt

3. Add your API key — create a .env file:

APIFY_API_KEY=your_key_here

Get it at apify.com → Settings → Integrations. Free tier covers ~100 runs/month.

4. Configure your creators list — edit creators.md with the accounts you want to track.

5. Add your brand context — edit context.md in plain English. This is what Claude reads before writing your content.

Run it

python run.py "last 7 days"

Output: output/last-7-days-social-media-posts.html — open in any browser.

The real advantage

n8n automates tasks. This automates thinking.

The pipeline doesn''t just move data — it reads what''s performing, extracts the mechanism behind it, and writes content that applies that mechanism to your specific audience and positioning. That''s a reasoning step. No visual workflow builder does that well.', 11),
  ('8c679406-1b6d-4022-99f7-f94f6def3dd6', 'fa39b456-1d8c-4c62-8c8f-9c7cb002da7e', 'Sales Call Transcript →CRM Tasks + Follow-up Email', 'What it does You paste a sales call transcript into the agent. It extracts every action item, creates tasks in your CRM or project management tool, and drafts a follow-up email ready to send to the prospect.

Agent prompt

You are a sales operations assistant. When given a meeting transcript, you will:

Identify every action item, commitment, and next step mentioned by any participant

Create a task in [CRM/PM tool] for each action item, assigned to the relevant person, with a due date if mentioned

Draft a follow-up email to the prospect summarising what was discussed, what happens next, and any outstanding questions

Flag any objections or concerns raised during the call as a separate note

Be specific. Use the exact language from the transcript when naming tasks. Do not invent action items that were not explicitly mentioned.

Tools to connect

Your CRM (HubSpot, Notion, ClickUp, Airtable — via MCP)

Gmail or Outlook for email drafting

How to trigger it

Option 1 — Manual paste (simplest): Open the agent session directly in the Anthropic console and paste the transcript. Best if you''re doing low volume.

Option 2 — n8n: Use a Gmail trigger watching for emails from your transcription tool (Fireflies, Otter, Fathom all send email summaries). When the email arrives, n8n extracts the body and fires an API call to the agent with the transcript as the message content.

Option 3 — Zapier: Same logic. Zap triggers on new email from transcription tool, passes body to the agent via a POST request to the Anthropic API.

Option 4 — Python script: If your transcription tool has an API, write a simple script that pulls the latest transcript and posts it to the agent. Run it manually or on a cron after every call.', 1),
  ('76cf49de-3f9d-4ce0-b2e0-bd12562697c2', 'fa39b456-1d8c-4c62-8c8f-9c7cb002da7e', 'Contract Received→Get Terms, Make Project, Confirm', 'What it does A contract or invoice arrives by email. The agent reads the attachment, extracts the key terms (client name, scope, value, deadlines, payment terms), creates a project in your PM tool, and sends a confirmation email to the sender.

Agent prompt

You are a client operations assistant. When given a contract or invoice document, you will:

Extract the following fields: client name, project scope, total value, start date, deadline, payment terms, and any key deliverables

Create a new project in [PM tool] using the client name and project scope as the title, and populate it with the extracted fields and a checklist of deliverables

Draft and send a confirmation email to the client acknowledging receipt, summarising the key terms as you understood them, and stating the next step on your end

If any critical field is missing or ambiguous, flag it in a note rather than guessing

Do not fabricate terms that are not present in the document. When in doubt, flag for human review.

Tools to connect

Gmail or Outlook (to receive the email and send the confirmation)

Google Drive or Dropbox (to access the attachment)

Notion, ClickUp, or Asana (to create the project — via MCP)

How to trigger it

Option 1 — n8n: Set up a Gmail trigger that watches for emails with PDF attachments from specific senders or with keywords like "contract" or "invoice" in the subject. n8n downloads the attachment and fires the API call with the document content passed as input.

Option 2 — Zapier: Same pattern. New Gmail email with attachment → extract attachment → POST to Anthropic API.

Option 3 — Make (Integromat): Strong choice here because Make handles file parsing cleanly. Watch Gmail, parse the PDF, send to the agent.

Option 4 — Webhook from your CRM: If your CRM sends a webhook when a deal moves to "contract sent" stage, you can use that as the trigger and pull the associated document automatically.', 2),
  ('0250bd49-9edc-4c84-b72a-15fbdb19e41b', 'fa39b456-1d8c-4c62-8c8f-9c7cb002da7e', 'Weekly Report → Pulls from Multiple Sources', 'What it does Every Monday morning the agent wakes up, pulls data from your key tools, compiles a structured weekly summary, and posts it to a Slack channel before your team standup.

Agent prompt

You are a business reporting assistant. Every time you are triggered, you will:

Pull last week''s data from [list your sources — e.g. CRM for deals closed, Google Analytics for traffic, Airtable for project status]

Summarise each data source in 3–5 bullet points, highlighting week-on-week changes and anything that needs attention

Flag any metric that is significantly above or below the prior week average

Format the output as a clean Slack message with one section per data source, a header, and a one-line executive summary at the top

Post the message to [Slack channel]

Be factual. Do not interpret or recommend — only summarise and flag. Keep the total message under 400 words.

Tools to connect

Your data sources via MCP (HubSpot, Airtable, Google Sheets, GA4)

Slack via MCP for posting the final report

How to trigger it

This use case is cron-based — it needs to fire on a schedule, not in response to an event.

Option 1 — n8n: Use the Schedule trigger node set to Monday 8am. The workflow fires the Anthropic API call with a simple message: "Generate this week''s report." No input data needed — the agent pulls everything itself via its connected tools.

Option 2 — Make: Same idea. Use the Schedule module to trigger the scenario weekly.

Option 3 — Python script on a server or cloud function: A simple POST request to the Anthropic API, scheduled via cron on a VPS, AWS Lambda, or Google Cloud Functions. Most reliable option for the technical audience.

Option 4 — Zapier: Schedule by Zapier trigger → POST to Anthropic API. Simplest setup, slightly less control over timing precision.

Note: this is the one use case where the trigger matters most. If the cron doesn''t fire, there''s no report. Make sure whatever scheduler you use has retry logic or sends an alert on failure.', 3),
  ('034ff71d-8b8d-4985-badf-65a52e0121d0', '88f4c273-96dd-4197-adb3-12d0f241322f', '3D Website Generator', 'Product Visualizer Skill — Build a Scroll-Animated Website from Any Product Photo

Module: Claude SkillsLevel: Standard + PremiumWhat you need: claude.ai account · Claude Code · A video file of your product

What this lesson covers

You''re going to install a Claude skill that takes a single product photo and outputs everything you need to build a premium scroll-animated website — the kind where the product deconstructs itself as you scroll down, like Apple''s iPhone pages.

Three outputs. One skill. Here''s what you get:

A deconstructed image prompt — paste into Midjourney, Flux, or DALL-E to generate the exploded flat-lay end frame

A video prompt — three platform variants (Runway, Kling, Pika) to animate the transition from assembled product to flat-lay

A Claude Code prompt — one paste, builds the entire website with the scroll animation in the hero, auto-installs ffmpeg, extracts the frames, and starts a live local server

By the end of this lesson you''ll have a running site at http://localhost:8080.

Why this matters

Premium product websites used to require a video production team, a web agency, and a designer working separately. This skill collapses that into one conversation.

Drop in a product photo — watch, drone, espresso machine, sneaker, anything physical. Walk out with a cinematic brief covering image generation, video, and a complete website scaffold. Three minutes, not three weeks.

The business use case: show this to a client before they''ve hired you. The site doesn''t exist yet, but the brief does, and it''s detailed enough that they can see exactly what it''ll look like. That''s leverage.

How the skill works

When you upload a product photo and ask for creative output, the skill:

Analyzes the image — product type, brand, materials, components, aesthetic register (luxury, technical, craft, sport, lifestyle)

Matches it to an aesthetic profile — colors, typography, motion style, copywriting tone, grain opacity — all tuned to that specific product category

Infers the site type — not always ecommerce. A luxury watch brand gets a brand editorial site. A restaurant gets a hospitality site. A drone gets a technical product site.

Outputs three things — image prompt, video prompt, and a complete Claude Code build brief

The Claude Code prompt is the key one. It''s fully pre-filled — brand name, hex values, Google Fonts, scroll overlay copy, site type, file name. You paste it in and it runs. You don''t edit anything.

Step 1 — Install the skill

This takes about 90 seconds.

Download pv-v1-v3.skill from the attachments below

Go to claude.ai → click your profile icon → Settings

Scroll to the Skills section → click Install Skill

Select the .skill file from your computer → confirm

To verify it worked, open a new chat and type:

What skills do you have installed?

Claude should mention product-visualizer in the response.

You don''t need to mention the skill by name when using it. Claude reads its description and triggers automatically when you upload a product photo with any creative intent — "generate prompts for this", "build a website for this", "make a scroll animation", even just "do something with this image."

Step 2 — Generate your three outputs

Open a new chat. Upload a product photo. Use one of these prompts depending on what you want:

Full pipeline — all three outputs:

Generate the full product visualization suite for this. All three outputs — deconstructed image prompt, video prompt, and the Claude Code build.

Specific site type:

Generate the full pipeline for this. It''s a brand editorial site, not an ecommerce store.

Just the Claude Code build prompt:

I already have my video. Just give me the Claude Code prompt to build the scroll animation website.

What each output contains

Output 1 — Deconstructed Image Prompt

A ready-to-paste prompt for your image generator. The skill identifies every component of the product in the correct disassembly order and builds a technically precise exploded-view prompt.

For a watch: sapphire crystal at the top, jubilee bracelet at the bottom, every layer between them named correctly.

Includes platform-specific suffixes so you don''t have to think about aspect ratios or style flags:

Midjourney: append --ar 9:16 --style raw --v 6

Flux / DALL-E: append product photography, no text

Negative prompt: assembled product, side view, perspective view

This image becomes the end frame of your video in Output 2.

Output 2 — Video Prompt

Three platform variants for animating the transition from assembled product to deconstructed flat-lay.

Platform Mode When to use Kling 1.6 Start + end frame ✅ Best option — use when you have both images Runway Gen-3 Image to video Good if you don''t have the end frame yet Pika 2.0 Image + flags Fast alternative, good for iteration

Kling''s start+end frame mode is flagged as recommended in the output because you have control over both frames — the assembled product and the deconstructed flat-lay from Output 1. That''s the most controlled transition you can get.

The motion prompt is tuned to the product''s aesthetic. A watch gets: "slow, deliberate, weighted — like fine engineering being quietly disassembled." A drone gets: "clean separation, like a CAD file deconstructing itself." An espresso machine gets: "organic, unhurried — layers peeling apart like pages of a handmade book."

Output 3 — Claude Code Build Prompt

This is the one that does everything.

Paste it into Claude Code alongside your .mp4 file. It runs four phases automatically:

Phase 0 — Install ffmpeg if missing

Checks for ffmpeg first. If it''s not there, installs it automatically:

macOS: brew install ffmpeg

Ubuntu: sudo apt-get install -y ffmpeg

Windows: winget install ffmpeg

If install fails, it stops and tells you the exact error. No silent failures.

Phase 1 — Extract frames

mkdir -p frames
ffmpeg -i your_video.mp4 \
  -vf "scale=1920:-1" \
  -q:v 3 \
  frames/frame_%04d.jpg

If the video is longer than 10 seconds (240+ frames at 24fps), it automatically re-extracts at 12fps so the scroll stays snappy.

Phase 2 — Build the website

Builds a single index.html — vanilla HTML, CSS, and JavaScript, no frameworks, no build tools, opens directly from the filesystem.

What''s included:

Glass navbar — position fixed, transparent by default, transitions to backdrop-filter: blur(20px) glass after 60px scroll. Floats over the hero. Never offsets the hero with margin-top.

Scroll animation hero — 400vh section with a sticky 100vh canvas. All frames preloaded into memory. Lerp-smoothed scrubbing (no snapping between frames). Loading bar in the brand accent color while frames load. Body scroll locked until 100% loaded.

Four text overlays — pre-written by the skill to match the product''s aesthetic register. A luxury watch gets declarative fragments. A tech product gets spec-forward numbers. A lifestyle brand gets punchy second-person copy.

Mobile fallback — canvas replaced with an autoplay muted video loop on small screens.

Full website below the hero — feature strip, brand story section, main content grid (adapted to site type — products, menu items, case studies, etc.), footer. All using glass cards.

Polish — grain overlay at 2–4% opacity, cursor follower in the brand accent color, scroll-reveal on every section.

Phase 3 — Start the server

After index.html is confirmed, starts a local server without waiting to be asked:

1. python3 -m http.server 8080
2. python -m http.server 8080
3. npx serve . -p 8080

Tries them in order. Prints:

✅ Site is live → http://localhost:8080
   Press Ctrl+C to stop.

Your task for this lesson

Work through these in order:

[ ] Download and install pv-v1-v3.skill (90 seconds)

[ ] Find a product photo — your own client''s product is ideal. If you don''t have one, use the Rolex or DJI Air 3S images in the lesson resources.

[ ] Upload it to a new Claude chat and ask for the full pipeline

[ ] Run Output 1 in Midjourney, Flux, or DALL-E — get your deconstructed end frame

[ ] Run Output 2 in Kling (start + end frame mode) or Runway to generate the video

[ ] Paste Output 3 into Claude Code with your .mp4 file — let it run all four phases

[ ] Open http://localhost:8080 and screenshot the result

Post your result in the community:

Format: [Product] · [Tools used] · [One thing that surprised you]

Example: "DJI Air 3S · Flux for the image, Kling for the video, Claude Code for the site · The ffmpeg install was automatic and the glass navbar was already specced correctly in the output — didn''t have to write any CSS."

Short and specific beats long and vague. Include a screenshot.

Troubleshooting

Skill doesn''t trigger

Make sure you''re uploading an image AND asking for something creative. A message like "what is this?" won''t trigger it. "Generate prompts for this" will.

ffmpeg install fails

If brew install ffmpeg fails on macOS, run xcode-select --install first, then retry. If you''re on Ubuntu and apt-get fails, try sudo apt update first.

Frame count is very high

If your video is long and the scroll feels slow or the page takes too long to load, the skill will auto-detect this and re-extract at 12fps. If it doesn''t, manually run:

ffmpeg -i your_video.mp4 -vf "fps=12,scale=1920:-1" -q:v 3 frames/frame_%04d.jpg

Server won''t start

If all three server options fail, open index.html directly in Chrome via File → Open File. The canvas scroll animation works fine from file:// — the only limitation is that some browsers block local image loading from a canvas for security reasons. Chrome allows it.

Output feels generic for my product

Tell Claude the site type explicitly: "This is a brand editorial site, not a store" or "This is a restaurant site — make the nav links Menu, Reserve, About." The skill infers site type from context, but your explicit instruction always overrides it.', 1),
  ('9621fe02-3ce6-4caa-aed4-68419ccf570b', '88f4c273-96dd-4197-adb3-12d0f241322f', 'Inbox Triage With Claude Cowork', 'What it does

This skill turns your inbox into a prioritised action list — in one command. Instead of spending 20-30 minutes every morning figuring out what actually needs your attention, you type "triage my inbox" and Claude connects to your Gmail, processes every unread email from the last 24-48 hours, and returns a structured briefing sorted into four buckets: Act Now, Respond Soon, FYI, and Ignore.

At the bottom of every triage, it surfaces your Top 3 Email Actions for the day — specific, not vague. "Reply to [Name] re: [topic]" not "check your emails."

Everything lands directly in chat. No file, no extra steps. Just your inbox, cleared.

Trigger command

Type any of the following to activate:

triage my inbox

check my emails

inbox triage

How to install

Download the zip file attached to this lesson

Open Claude Code and click Customize in the left sidebar

Click Skills → hit the + button → Upload a Skill

Drag the zip file in and click Upload

The skill will appear in your skills list — it''s ready to use immediately

One thing to know

This skill requires your Gmail connector to be active. Inside Claude Code, go to Customize → Connectors and make sure Gmail is connected before running it for the first time.', 2),
  ('20a74154-0fa4-46b1-95ad-d14571eb1d61', '88f4c273-96dd-4197-adb3-12d0f241322f', 'Daily Content Pipeline Skill for Claude Cowork', 'Turn competitor X/Twitter and YouTube activity into ready-to-post LinkedIn drafts, YouTube concepts, and a weekly newsletter — all rendered as a clean HTML digest you open in your browser. No Notion, no scripts, just Claude + Apify.

What It Does

Every time you run it, the skill:

Scrapes the last 24 hours from your monitored X accounts and YouTube channels

Tags everything by content pillar and engagement signal

Writes 3 LinkedIn post drafts (each with a different hook formula)

Writes 3 YouTube video concepts grounded in what''s trending today

Generates a newsletter digest (Mondays only)

Renders everything as a single HTML page that opens in your browser with one-click copy buttons

Prerequisites

Claude Desktop Installed

An Apify account (free tier works — you need ~$1–2/month in compute)

Step 1 — Get Your Apify API Token

Sign in to apify.com

Go to Settings → API & Integrations

Copy your Personal API token

Step 2 — Add Apify MCP to Claude

In Claude Desktop, go to Customize -> Connectors -> Plus Icons -> Browse Connectors and search for Apify MCP.

Add your API key.

Step 3 — Install the Skill

Download SKILL.md and place it at:

~/.claude/skills/daily-pipeline-2/SKILL.md

Create the folder if it doesn''t exist:

mkdir -p ~/.claude/skills/daily-pipeline-2

Step 4 — Configure Your Accounts

Open ~/.claude/skills/daily-pipeline-2/SKILL.md in any text editor. At the top you''ll see a clearly marked config block — fill in your values:

CREATOR_NAME : Jane Doe | AI Weekly
OUTPUT_DIR   : /Users/jane/Desktop/content-digest
NICHE        : AI tools for e-commerce founders
AUDIENCE     : DTC brand owners doing $500K+/yr
PILLARS      : Tool Reviews, Case Studies, Tutorials, Industry Takes

X_ACCOUNTS:
  - TheRundownAI
  - OpenAI
  - sama

YT_CHANNELS:
  - https://www.youtube.com/@YourCompetitor1
  - https://www.youtube.com/@YourCompetitor2

Save the file. You only do this once.

Step 5 — Run It

Open Claude Cowork in any project and say:

run the pipeline

Claude reads the skill, fires both Apify scrapers in parallel, analyzes the results, generates your drafts, and opens the HTML digest automatically.

Tips

Change accounts anytime — just edit the config block and save

Add more pillars — the HTML chips auto-color up to 4; add more by editing the pillar color table in the skill

Runs in ~3–5 minutes depending on how many accounts you''re monitoring and Apify queue time

The HTML file is saved to your OUTPUT_DIR with today''s date — past digests are kept automatically', 3),
  ('38d11cb7-be9e-4414-ae23-15fe6f9ec9f7', '88f4c273-96dd-4197-adb3-12d0f241322f', 'Client Report Generator with Claude Cowork', 'What it does

This skill takes your raw notes — bullet points, rough numbers, a messy post-call brain dump — and turns them into a polished, client-ready HTML report. The kind of thing a boutique agency would be proud to send.

Paste in whatever you have, type "client report", and it produces a fully formatted HTML file saved directly to your project folder. The report includes an executive summary, a work completed section with cards per deliverable, a results and metrics display, and numbered next steps — all in a dark editorial design with your branding.

Open the file in a browser and it''s ready to send. There''s even a print stylesheet built in if you need a PDF version.

Trigger command

Type any of the following to activate:

client report

generate a report

write up this week''s report

How to install

Download the zip file attached to this lesson

Open Claude Code and click Customize in the left sidebar

Click Skills → hit the + button → Upload a Skill

Drag the zip file in and click Upload

The skill will appear in your skills list — it''s ready to use immediately

One thing to know

The more context you give it, the better the output. Include the client name, the reporting period, any specific metrics or results, and the key things you completed. You don''t need to organise any of it — just paste it in and let the skill handle the structure.', 4),
  ('feddd152-d823-45c0-b45d-4e8d62fdb780', '88f4c273-96dd-4197-adb3-12d0f241322f', 'Build a Proposal Generator with Claude Code Skills', 'Overview

Learn how to build and deploy a custom "Proposal Generator" skill for Claude Code that transforms messy client emails and meeting transcripts into polished, professional proposals in minutes. This lesson walks you through creating example proposals that teach Claude your voice, installing the skill, and using it to eliminate 40+ minutes of proposal-writing drudgery every single time.

What You''ll Build

A production-ready proposal automation that:

Extracts client requirements, budget signals, and timeline cues from rambling emails

Confirms understanding before building (preventing wasted effort)

Generates structured proposals that sound like you wrote them

Handles edge cases like missing budget information intelligently

Saves as properly-named Markdown files ready to send

The Business Problem

The Old Way: You get a 400-word client email that mentions their problem somewhere in paragraph 3, hints at budget in a throwaway sentence, and buries their actual deadline under casual language like "pretty soon." You spend 60-90 minutes:

Rereading the email to catch everything

Guessing at what they really want

Structuring the proposal from scratch

Writing in a way that sounds professional but not robotic

Second-guessing your pricing

Hoping you didn''t miss anything important

With This Skill: You paste the email, Claude extracts every signal in 10 seconds, confirms what it found, generates a tailored proposal in your voice, and saves it as a file. Total time: 5 minutes. Quality: better than manual because it never misses a detail.

Time Savings: 55+ minutes per proposalMissed Details: Zero (Claude catches everything)

Prerequisites

Required:

Claude Code installed

A folder where you do proposal work

At least one proposal you''ve written that you''re proud of (or 20 minutes to create one)

Helpful:

Understanding of Markdown formatting

Experience writing business proposals

Time to Complete: 30-45 minutes for full setup, then 5 minutes per proposal forever

Part 1: How the Proposal Generator Works

The Three-Phase System

This skill doesn''t just generate proposals—it follows a smart workflow that mirrors how an experienced consultant would work.

Phase 1: Signal Extraction

Claude reads the client conversation (email thread, meeting transcript, Slack messages) and pulls out:

Client identity: Person name, company name

Core problem: What''s actually broken, not what they think is broken

Desired outcome: What they want, in their words

Budget signals: Any mention of money, even indirect ("we spent $X last time", "not looking to break the bank")

Timeline signals: Deadlines, urgency language, launch dates, "ASAP" hints

Why this matters: You might skim an email and miss that they mentioned their board meeting is in 3 weeks (timeline pressure) or that they "don''t have Salesforce money" (budget constraint). Claude catches everything.

Phase 2: Confirmation Loop

Before writing anything, Claude shows you what it extracted:

Pulled from the conversation:

- Client: Sarah Chen, GrowthLabs
- Problem: Spending 12 hours/week on manual reporting across 6 different tools
- Looking for: Automated dashboard that pulls everything into one place
- Budget: Mentioned "under $5K ideally"
- Timeline: Needs something running before Q2 starts (6 weeks from now)

Look right? Does the budget align with our pricing for this scope?

You respond: "Yes, good to go" or "Actually, timeline is tighter—they need it in 4 weeks"

Why this matters: Prevents building an entire proposal based on a misunderstanding. If Claude misread something, you catch it here in 10 seconds, not after you''ve sent a proposal to the wrong person.

Phase 3: Proposal Generation

Only after you confirm, Claude generates the proposal using:

Your structure: Sections in the order you prefer

Your voice: Tone and phrasing that matches your example proposals

Your differentiators: The specific "Why Us" points that make you different

Your pricing philosophy: Line-item breakdown vs. flat fee, minimum engagement amounts, etc.

Output: A Markdown file named proposal-[client-name].md saved in your folder and displayed in chat for review.

What Makes This Different from "Just Asking Claude"

Without the skill:

You: "Write me a proposal for this client"
Claude: [Generic proposal that sounds like every other AI-generated proposal, 
         misses half the signals in the email, uses phrases you''d never use,
         structures it differently than you prefer, doesn''t include your 
         specific differentiators]

With the skill:

You: [Pastes client email]
Claude: [Automatically recognizes this is a proposal task]
Claude: [Extracts all signals using your trained extraction framework]
Claude: [Confirms before proceeding]
Claude: [Generates proposal matching your exact voice and structure]
Claude: [Saves as properly-named file]

The skill codifies your expertise so you get consistent, high-quality results every time without re-explaining your preferences.

Part 2: Creating Your Example Proposals

Why Examples Matter

The skill file (which you''ll get as a resource) contains the framework: what to extract, how to structure, what tone rules to follow. But it doesn''t contain your voice—that comes from the examples you provide.

Think of it like this:

Skill = Recipe for making proposals

Your examples = The specific flavors and style you prefer

Claude follows the recipe but seasons it according to your taste.

Setup: Create Your Workspace

Step 1: Create Project Folder

# Mac/Linux
mkdir ~/proposal-generator-setup
cd ~/proposal-generator-setup

# Windows
mkdir C:\proposal-generator-setup
cd C:\proposal-generator-setup

Step 2: Create Examples Folder

mkdir examples

Your structure:

proposal-generator-setup/
  examples/

Option 1: Use an Existing Proposal

Best choice if: You have a proposal you''ve written that you''re proud of—one that represents your voice, your structure, and your approach.

Process:

Find your best proposal (the one clients responded to positively)

Copy the entire content

Create the file:
# Mac/Linuxtouch examples/my-proposal-example.md# Windowstype nul > examples\my-proposal-example.md

Open the file in your editor

Paste your proposal content

Remove any sensitive client information (names, specific numbers if needed)

Save the file

What to look for in a good example:

✅ Clear problem statement

✅ Specific approach (not vague promises)

✅ Your unique differentiators

✅ Concrete deliverables

✅ Your preferred pricing format

✅ Strong call to action

Option 2: Generate an Example with Claude

Best choice if: You don''t have an existing proposal or yours don''t quite match your ideal voice.

Process:

Step 1: Open Claude Code in your project folder

Step 2: Provide Context

I need to create an example proposal that represents my ideal business voice and approach. Here''s my context:

BUSINESS DESCRIPTION:
I''m an AI automation consultant. I help [your target market] build [what you build]. My approach is [your philosophy - e.g., "done-with-you, not done-for-you"].

WHO I SERVE:
[Describe your ideal client - industry, size, pain points]

MY DIFFERENTIATORS:
1. Two years in the industry with an educator background—I teach, not just build
2. I build systems IN your business, not ON your business—you own everything
3. [Add your specific differentiators]

TYPICAL PROJECT:
- Scope: [What a typical engagement looks like]
- Duration: [Typical timeline]
- Investment: [Typical range]
- Deliverables: [What clients typically get]

VOICE & TONE:
- Direct and no-nonsense—smart person talking to smart person
- Professional but conversational
- Zero corporate jargon—no "synergies" or "best-in-class solutions"
- Short sentences are fine—tight over verbose

PRICING PHILOSOPHY:
- Minimum engagement: $2,000
- Line-item breakdown vs. flat fee
- [Any other pricing principles you follow]

Based on all of this, draft a complete example proposal for a fictional client. Make it specific enough that it demonstrates my voice, structure, and how I present value. The fictional scenario: A marketing agency (8 people) needs help automating their client onboarding process.

Step 3: Review and Edit

Claude will generate a proposal. Read through it carefully:

Does it sound like you?

Is the structure what you prefer?

Are the differentiators accurate?

Is the pricing format right?

Would you actually send this?

Make edits:

This is close, but two changes:

1. In the "Why Us" section, change [X] to [Y] because that''s more accurate to how I position myself

2. The tone in the "Problem" section is too formal. Rewrite it to sound more conversational—like I''m talking to them over coffee, not presenting to a boardroom.

Step 4: Save the Final Version

Once it matches your voice:

Save this as examples/my-proposal-example.md

What Your Example Should Include

Required sections (these teach Claude your structure):

1. Executive Summary Your opening 2-3 sentences. How do you frame the engagement?

Example (direct style):

We''ll build an automated client onboarding system that eliminates the 3-4 hours of manual work you''re currently doing per client. You''ll handle the building using Claude Code. We''ll provide the architecture, direction, and troubleshooting so you''re never stuck.

Example (consultative style):

This proposal outlines a 3-month engagement to transform your client onboarding from a manual, time-intensive process into a streamlined, automated workflow. By the end, you''ll have reclaimed 15+ hours per week and created a foundation that scales as you grow.

Your example teaches Claude which style you prefer.

2. The Problem How do you describe what the client is dealing with?

Example (mirror their language):

Your onboarding process is eating 3-4 hours per client. Contract sending, asset collection, tool setup—it''s all manual, repetitive, and scattered across email threads. You''re spending time on logistics instead of actual client work.

Example (diagnose deeper):

The surface problem is time: 3-4 hours per client on onboarding tasks. But the real issue is structural. Without a centralized system, client data lives in email threads, Slack messages, and your team''s collective memory. As you scale, this becomes unsustainable—clients fall through cracks, team members duplicate work, and onboarding quality becomes inconsistent.

Your example teaches Claude how deep to go.

3. Recommended Approach How do you lay out the solution?

Example (phased):

Month 1: Foundation
Map current workflow

Identify automation opportunities

Build intake form and basic triggers

Month 2: Core Automation
Automate contract delivery

Build asset collection workflow

Create tool provisioning sequence

Month 3: Polish & Scale
Add edge case handling

Build reporting dashboard

Train team on system

Example (milestone-based):

We''ll tackle this in four concrete deliverables:
Automated Intake - Form captures all client details, triggers contract generation

Asset Pipeline - Automated collection, organization, and handoff to your team

Tool Provisioning - One-click setup of client in ClickUp, Google Drive, etc.

Status Dashboard - See every client''s onboarding stage at a glance

Your example teaches Claude your preferred structure.

4. Why Us What makes you different?

This is where your specific differentiators live. The skill file includes standard ones:

"Two years in the industry with an educator background..."

"We build systems IN your business, not ON your business..."

But add yours:

Your specific expertise

Your unique approach

Client results you''ve achieved

Why clients choose you over alternatives

5. Deliverables How do you list what clients will receive?

Example (specific outputs):

Automated intake form with conditional logic

Contract generation and delivery workflow

Asset collection portal with automated follow-ups

Tool provisioning automation (ClickUp + Google Workspace)

Onboarding status dashboard

Complete documentation and training session

Example (outcome-focused):

Client onboarding completed in under 30 minutes (vs. current 3-4 hours)

Zero manual follow-ups required

Centralized view of all clients in pipeline

Team trained and confident in system operation

Your example teaches Claude how to frame value.

6. Investment How do you present pricing?

Example (line-item breakdown):

| Item | Cost |
|------|------|
| Discovery & workflow mapping | $1,500 |
| Core automation build | $3,500 |
| Integration & testing | $1,500 |
| Training & documentation | $500 |
| **Total** | **$7,000** |

Our minimum project engagement is $2,000.

Example (phased pricing):

| Phase | Deliverables | Investment |
|-------|--------------|------------|
| Phase 1: Foundation | Intake form, workflow map | $2,500 |
| Phase 2: Automation | Core workflows built | $3,500 |
| Phase 3: Polish | Dashboard, training | $1,500 |
| **Total** | All deliverables | **$7,500** |

Phases can be approved individually as budget allows.

Your example teaches Claude your pricing philosophy.

7. Next Steps How do you close the proposal?

Example (clear and direct):

Review this proposal and reply with any questions

Confirm to proceed - we''ll send a simple service agreement

Schedule kickoff call - we''ll start mapping your workflow same week

Go live - first automations running within 2 weeks

Example (multiple paths):

Ready to proceed? Reply to this email and we''ll send the agreement.
Want to discuss first? Book a 30-minute call here: [link]
Need time to review? No problem. I''ll follow up in 3 business days unless I hear from you sooner.

Your example teaches Claude how to close.

Multiple Examples for Different Scenarios

Optional but powerful: Create examples for different types of work you do.

Scenario 1: You offer different service types

examples/
  automation-project-example.md    (one-time build project)
  consulting-retainer-example.md   (ongoing advisory)
  training-program-example.md      (educational engagement)

When using the skill:

Generate a proposal using examples/consulting-retainer-example.md as the style reference since this is an ongoing engagement, not a one-time project.

Scenario 2: You work with different client sizes

examples/
  enterprise-example.md     (formal, detailed, legal-heavy)
  startup-example.md        (casual, flexible, risk-sharing)
  solopreneur-example.md    (streamlined, accessible, educational)

Usage:

This client is a 2-person startup. Use examples/startup-example.md—they need the casual, flexible approach.

Part 3: Installing the Proposal Generator Skill

Understanding Skill Installation

Claude Code looks for skills in a specific folder: .claude/skills/

Two installation options:

Project-level: Skill only works in this specific folderGlobal: Skill works everywhere in Claude Code

We''ll use project-level for this tutorial (easier to test and iterate).

Installation Steps

Step 1: Create the Skills Folder

In your proposal-generator-setup directory:

mkdir -p .claude/skills

Your structure now:

proposal-generator-setup/
  .claude/
    skills/
  examples/
    my-proposal-example.md

Step 2: Add the Skill File

The proposal-generator.md skill file will be provided as a resource.

Place it in your skills folder:

Mac/Linux:

# If downloaded to Downloads folder
mv ~/Downloads/proposal-generator.md .claude/skills/

# Or create and paste content
touch .claude/skills/proposal-generator.md
# Then open in editor and paste skill content

Windows:

# If downloaded
move %USERPROFILE%\Downloads\proposal-generator.md .claude\skills\

# Or create and paste
type nul > .claude\skills\proposal-generator.md
# Then open in editor and paste content

Step 3: Verify Installation

Open Claude Code in your project folder (important—must be in the folder where .claude/skills exists).

Ask Claude:

What skills do you have access to?

Expected response:

Available skills:
- proposal-generator: Generate structured client proposals from email threads or meeting transcripts

If you see this: ✅ Installation successful

If you don''t see it:

Check that .claude/skills/proposal-generator.md exists

Ensure you''re in the correct folder in Claude Code

Restart Claude Code

Check for typos in folder/file names

Alternative: Global Installation

If you want the skill available in ALL Claude Code projects:

Mac/Linux:

mkdir -p ~/.claude/skills
cp .claude/skills/proposal-generator.md ~/.claude/skills/

Windows:

mkdir %USERPROFILE%\.claude\skills
copy .claude\skills\proposal-generator.md %USERPROFILE%\.claude\skills\

Restart Claude Code for global skills to take effect.

Trade-offs:

✅ Available everywhere

❌ Harder to update (need to restart Claude Code)

❌ Less obvious which skills are loaded

Recommendation: Start with project-level, move to global once you''re confident it works perfectly.

Part 4: Calibrating the Skill to Your Voice

Why Calibration is Critical

The skill knows what to do. Your example teaches it how you do it. Calibration connects the two.

Without calibration:

Proposal follows structure ✅

But sounds generic ❌

Missing your specific phrasing ❌

Doesn''t match your differentiators ❌

With calibration:

Follows structure ✅

Sounds like you wrote it ✅

Uses your exact differentiators ✅

Matches your pricing style ✅

Calibration Process

Step 1: Point Claude to Your Example

With Claude Code open in your project:

I''ve installed the proposal-generator skill. I have an example proposal in examples/my-proposal-example.md that represents my voice and structure. 

Please read this example carefully—it''s how all future proposals should sound and be structured.

Claude will:

Read your example file

Analyze tone and structure

Note your specific differentiators

Understand your pricing format

Step 2: Verify Understanding

Ask:

Based on the example, what are the key characteristics of my proposal style?

Claude should identify:

Your tone (e.g., "Direct, conversational, zero jargon")

Your structure (e.g., "Problem → Approach → Why Us → Deliverables → Investment → Next Steps")

Your differentiators (e.g., "Educator background, building systems IN not ON business")

Your pricing approach (e.g., "Line-item breakdown, $2,000 minimum")

Your closing style (e.g., "Clear next steps with specific call to action")

If Claude accurately describes your style: ✅ Calibration successful

If something''s off:

Almost right, but you missed that I always emphasize done-with-you, not done-for-you. That''s a core differentiator. Please re-read and note that specifically.

Step 3: Test Run with Fictional Client

Let''s generate a test proposal before using with real clients.

Paste this fictional client email:

Hey,

I run a small product design agency—just me and 4 designers. We''re getting crushed by admin work. Every new client means hours of back-and-forth: sending contracts, collecting brand assets, setting up Figma files, getting them into our project tracker, etc.

I''d say we spend 3-4 hours per client just on setup before we can actually start designing. And it''s all super manual—lots of copy-pasting, email threads, forgetting things.

We use Notion for project management and Google Workspace for everything else. We''ve also got a Typeform for initial inquiries but it doesn''t really connect to anything.

Honestly not sure what''s realistic budget-wise for automating this stuff. Maybe a few thousand? We''re not a huge shop so can''t go crazy, but if it saves us 10+ hours per week it''d pay for itself pretty quick.

We''re ramping up for busy season and need to onboard like 6 new clients in the next two months, so sooner would be better.

Let me know what you think.

- Jordan

Then ask Claude:

Generate a proposal for this client.

Step 4: Review the Confirmation Step

Claude should present extracted signals:

Pulled from the conversation:

- Client: Jordan (product design agency, 5 people total)
- Problem: Spending 3-4 hours per client on manual onboarding—contracts, assets, tool setup
- Looking for: Automation of client setup workflow (Notion + Google Workspace + Typeform)
- Budget: "Maybe a few thousand" - sounds like $2K-5K range
- Timeline: Ramping for busy season, 6 new clients in next 2 months—needs it soon

Look right? Does budget align with our pricing?

Check this carefully:

✅ Did Claude catch all the important details?

✅ Is the budget interpretation reasonable?

✅ Did it note the urgency (6 clients in 2 months)?

Respond:

Yes, that''s accurate. Budget range of $3-5K would work for this scope.

Step 5: Review Generated Proposal

Claude generates the proposal. Check these elements:

✅ Tone Match: Does it sound like you? Read the "Problem" section—is it in your voice?

✅ Structure Match: Are sections in your preferred order? Check against your example.

✅ Differentiators Present: Look at "Why Us"—does it include your specific points?

✅ Pricing Format: Is it formatted the way you prefer? Line-item vs. phased vs. flat?

✅ Deliverables Specificity: Are they concrete and checkable, or vague promises?

✅ Next Steps Clarity: Is there a clear call to action?

Step 6: Request Adjustments

If something''s not quite right:

The proposal is good, but three tweaks:

1. The tone in "The Problem" section is slightly too formal. Can you make it more conversational—like we''re talking over coffee?

2. In "Why Us", you''re missing my specific differentiator about educator background. That should always be first.

3. The pricing is too high for this client size. Can we bring it down to $3,500 total while still covering the core scope?

Claude makes adjustments.

Step 7: Confirm Calibration Complete

Once the test proposal looks exactly how you want:

Perfect. This matches my voice and style. Save this test proposal as examples/test-proposal-jordan.md so I have it for reference.

Going forward, all proposals should match this quality and style.

You''re now calibrated and ready for real client work.

Troubleshooting Calibration Issues

Issue: Proposal sounds too generic/corporate

The proposal is using phrases I''d never use: "excited to work with you", "best-in-class solutions", "leverage our expertise". 

Review my example again. I never use corporate language. Rewrite the proposal to sound more like my example—direct and conversational.

Issue: Wrong structure

You''re using a different section order than my example. 

My structure is always:
1. Executive Summary
2. The Problem  
3. Our Recommended Approach
4. Why Us
5. Deliverables
6. Investment
7. Next Steps

Please restructure to match exactly.

Issue: Missing your differentiators

In "Why Us", you need to always include:

"Two years in the industry with an educator background—we don''t just build things, we make sure your team understands them"

"We build systems IN your business, not ON your business—everything we create is designed for you to own and operate"

These are non-negotiable. Please add them to this proposal and remember them for all future proposals.

Issue: Pricing format doesn''t match

I always use a line-item table for pricing, not a paragraph description. 

Format should be:

| Item | Cost |
|------|------|
| [Line item 1] | $X,XXX |
| [Line item 2] | $X,XXX |
| **Total** | **$X,XXX** |

Reformat the Investment section to match this.

Part 5: Using the Skill with Real Clients

Scenario 1: Client Inquiry Email

You receive this email:

Subject: Help with our content workflow

Hi,

We''re a B2B SaaS company (Series A, about 30 people). Our content team is small—3 writers—but we''re trying to publish 2-3 blog posts per week plus social content.

The problem is our workflow is a mess. Writers are working in Google Docs, we''re tracking assignments in a Notion board, social posts get drafted in Slack, and nobody really knows what''s published vs. in progress vs. stuck in review.

We''ve tried project management tools but they''re overkill for our needs. We just need something that connects what we already use and gives us visibility into the content pipeline.

We probably have $10-15K budget to get this sorted. Would love to have something running before our Q2 planning in about 8 weeks.

Thoughts?

Thanks,
Maya Chen
VP Marketing, CloudSync

Step 1: Paste into Claude Code

[Paste the entire email above]

Generate a proposal for this client.

Step 2: Review Extracted Signals

Claude responds:

Pulled from the conversation:

- Client: Maya Chen, VP Marketing at CloudSync (Series A SaaS, ~30 people)
- Problem: Messy content workflow—Google Docs + Notion + Slack, no visibility into pipeline
- Looking for: Connected system using existing tools, clear content pipeline visibility
- Budget: $10-15K
- Timeline: 8 weeks (before Q2 planning)

Look right? Does budget align with our pricing?

Step 3: Confirm or Correct

If accurate:

Looks good. Budget works for this scope.

If you need to adjust:

Almost right, but note that their team is small (3 writers) so we should scope this appropriately—not overengineer. Budget is generous for the size, so we could even deliver more value than they expect.

Step 4: Review Generated Proposal

Claude generates:

# Proposal for CloudSync — Content Workflow Automation

## Executive Summary

We''ll build a connected content pipeline that turns your scattered workflow into a centralized system with full visibility. Using the tools you already have—Google Docs, Notion, and Slack—we''ll create automated handoffs between stages so your team always knows what''s in progress, what''s stuck, and what''s ready to publish.

## The Problem

Your content operation is trapped in tool fragmentation. Writers work in Google Docs. Assignments live in Notion. Social drafts get floated in Slack. Nobody has a clear view of what''s moving forward vs. what''s blocked.

You''ve tried heavyweight project management tools, but they''re overkill. You don''t need a complex system—you need the tools you already use to actually talk to each other.

The result: bottlenecks you can''t see, missed deadlines you don''t catch until it''s too late, and a VP of Marketing who has to manually check in on every piece to know status.

## Our Recommended Approach

**Phase 1: Pipeline Foundation (Weeks 1-3)**

1. Map your current content workflow—every stage from ideation to publication
2. Build your Notion content hub—single source of truth for all content status
3. Create automated bridges:
   - Google Docs → Notion (new doc = new content item)
   - Notion stage changes → Slack notifications
   - Publication triggers → social content workflow

**Phase 2: Visibility & Automation (Weeks 4-6)**

4. Build content pipeline dashboard in Notion—see everything at a glance
5. Automate review reminders and stuck content alerts
6. Set up social content branching (blog post triggers social derivative workflow)

**Phase 3: Optimization (Weeks 7-8)**

7. Add advanced automations based on actual usage patterns
8. Train team on system operation
9. Document everything for sustainability

## Why Us

- Two years in the industry with an educator background—we don''t just build automation, we make sure your team actually understands and owns it
- We build systems IN your business, not ON your business—everything we create works with your existing tools and is designed for you to operate without us
- We''ve built content operations systems for 3 other SaaS companies at your stage—we know the workflows, the bottlenecks, and what actually works for small teams trying to punch above their weight

## Deliverables

- Automated content pipeline connecting Google Docs, Notion, and Slack
- Content dashboard showing real-time status of all pieces
- Review and publication workflow with smart notifications
- Social content derivative automation
- Stuck content detection and alerts
- Complete documentation and team training
- 30 days of post-launch support for refinements

## Investment

| Phase | Deliverables | Investment |
|-------|--------------|------------|
| Phase 1 | Pipeline foundation, tool connections | $4,500 |
| Phase 2 | Dashboard, automation, social workflow | $5,000 |
| Phase 3 | Optimization, training, documentation | $2,500 |
| **Total** | Complete content operations system | **$12,000** |

Our minimum project engagement is $2,000.

This pricing includes all automation build, unlimited revisions during the build phase, and 30 days of post-launch support. Any additional integrations or features beyond this scope can be added at $150/hour.

## Next Steps

1. **Review this proposal** and reply with questions or requested adjustments
2. **Confirm to proceed** - we''ll send a service agreement and kick off same week
3. **Week 1 starts** - we''ll schedule a deep-dive session with your content team to map the current workflow
4. **First automations live** - you''ll see initial connections working within 2 weeks
5. **Full system operational** - everything running smoothly before your Q2 planning in 8 weeks

Ready to move forward? Reply to this email and we''ll get the agreement sent over today.

Claude also saves it as proposal-cloudync.md in your folder.

Step 5: Make Final Adjustments (Optional)

If you want tweaks:

This is great. Two small changes:

1. In the Investment table, can you add a note that Phase 1 could be approved standalone if they want to start smaller?

2. In Next Steps, change "Reply to this email" to "Book a 15-minute call here: [calendly link]" since I prefer to discuss before sending agreements.

Claude updates the proposal.

Step 6: Send to Client

Copy the proposal content, paste into your email, and send.

Total time elapsed: 5-7 minutes

Scenario 2: Meeting Transcript

You have a 45-minute sales call with a prospect. The transcript from Zoom:

[Long transcript with lots of back-and-forth, casual conversation, 
tangents, client stories, technical questions, budget hints scattered 
throughout, timeline mentioned casually in minute 38...]

The Challenge:In a live conversation, important details get buried. Client mentions their budget while telling a story about their last vendor. Timeline comes up as a throwaway line. Their real pain point emerges after 20 minutes of discussing symptoms.

Step 1: Paste Entire Transcript

Here''s the transcript from my sales call:

[Paste full transcript - could be 5,000+ words]

Generate a proposal based on this conversation.

Step 2: Let Claude Extract Everything

Claude reads the entire transcript and extracts:

Pulled from the conversation:

- Client: Marcus Rivera, CTO at FinMetrics (40-person fintech)
- Problem: Manual reconciliation process taking team 6-8 hours per day, error-prone, doesn''t scale
- Looking for: Automated reconciliation system integrated with their accounting software (QuickBooks) and banking APIs
- Budget: Mentioned they "spent about $25K on the last automation project" and this is "probably similar scope"—so $20-30K range
- Timeline: Board meeting in 10 weeks where they need to show operational improvements, so needs to be running before then
- Additional context: Previous vendor over-promised and under-delivered, so they''re cautious about scope creep and want clear milestones

Key technical details mentioned:
- Currently using QuickBooks, Plaid for banking data, manual Excel reconciliation
- Processing ~500 transactions per day
- Need audit trail for compliance
- Team of 3 people currently doing manual work

Look right? Does budget align with our pricing?

Value: Claude caught the budget hint from minute 12, the timeline from minute 38, and the previous-vendor-failure context from minute 27 that you might have forgotten by the end of the call.

Step 3: Confirm and Adjust

Great extraction. Two clarifications:

1. Budget is accurate but they''re budget-conscious after the last vendor experience—let''s make sure the proposal emphasizes clear deliverables and milestones

2. Timeline is critical—they need something demo-able for that board meeting, not just "running." Let''s structure this so Phase 1 delivers a working demo within 6 weeks.

Step 4: Claude Generates Tailored Proposal

Incorporates:

Clear milestone-based structure

Emphasis on working demos at each phase

Budget breakdown showing value at each stage

Explicit "no scope creep" language in approach

References to their previous vendor experience (subtly)

Result: Proposal that addresses their unstated concerns (trust, scope creep, vaporware) because Claude extracted context a human might miss.

Scenario 3: Missing Budget Information

Client sends:

Subject: Automation help needed

We need to automate our customer onboarding flow. Currently it''s super manual—everything in spreadsheets and email. Takes forever and things fall through the cracks.

We''re using Salesforce and Intercom. Would love to get this sorted ASAP.

Can you help?

- David

No budget mentioned. No timeline details. Minimal scope information.

Step 1: Paste and Generate

[Paste email]

Generate a proposal for this client.

Step 2: Claude Flags Missing Information

Pulled from the conversation:

- Client: David (company unknown)
- Problem: Manual customer onboarding, using spreadsheets and email
- Looking for: Automation of onboarding flow with Salesforce and Intercom
- Budget: **Not mentioned**
- Timeline: "ASAP" (vague urgency, no specific deadline)

Since budget wasn''t discussed, I''ll price based on typical scope for this work. The proposal will include a flag about this.

Should I proceed with generating the proposal, or would you prefer to get more information from David first?

Step 3: Proceed with Proposal

Go ahead and generate the proposal. I''ll follow up with David to confirm budget before sending, but having a starting point is useful.

Step 4: Review Generated Proposal

Claude includes this in the Investment section:

## Investment

> **Note: Budget was not discussed in our conversation. The figures below are based on our standard pricing for this type of automation work. Please confirm these numbers align with expectations before proceeding.**

| Phase | Deliverables | Investment |
|-------|--------------|------------|
| Discovery & mapping | Current workflow analysis, automation blueprint | $1,500 |
| Core automation build | Salesforce + Intercom integration, automated workflows | $4,000 |
| Testing & refinement | QA, edge case handling, team training | $1,500 |
| **Total** | Complete onboarding automation | **$7,000** |

Our minimum project engagement is $2,000.

If this investment range doesn''t align with your budget, we can explore a phased approach or adjust scope accordingly.

This flags the issue so you don''t blindly send a $7K proposal to someone with a $2K budget.

Step 5: Your Options

Option A: Send proposal with budget confirmation request

Email David:

Hi David,

Based on our conversation, here''s a proposal for automating your onboarding flow. 

One quick note: we didn''t discuss budget, so I''ve priced this based on typical scope for Salesforce + Intercom integrations. The total is $7,000.

Does that align with what you had in mind? If not, we can absolutely adjust the scope or explore a phased approach.

[Attach proposal]

Option B: Get budget first, then send proposal

Email David:

Hi David,

Happy to help with the onboarding automation. To make sure I scope this appropriately, can you share a rough budget range you''re working with? That''ll help me propose the right approach for your situation.

[Then generate proposal after he responds]

The skill gives you flexibility by generating a baseline while explicitly flagging the gap.

Part 6: Advanced Usage Patterns

Pattern 1: Batch Processing Multiple Inquiries

You have 5 client inquiries from the week. Process them all efficiently:

I have 5 client emails to turn into proposals. I''ll paste them one at a time. After each confirmation, generate the proposal and move to the next.

Ready for the first one?

Claude processes each sequentially:

Extract signals

Confirm

Generate proposal

Save as proposal-[client-name].md

Ask for next

Time savings: 5 proposals in 20-25 minutes vs. 4-5 hours manually.

Pattern 2: Iterating on Pricing Strategies

Generate multiple pricing options for the same client:

Generate a proposal for [client], but create two versions:

Version 1: Project-based pricing (save as proposal-client-v1-project.md)
Version 2: Monthly retainer pricing (save as proposal-client-v2-retainer.md)

I want to see which approach resonates better with this client.

Result: Two complete proposals with different business models, ready to present as options.

Pattern 3: Using Different Example Voices

If you have multiple examples for different client types:

Generate a proposal for this enterprise client using examples/enterprise-proposal-example.md as the style reference.

They need formal, detailed, compliance-heavy language—not my usual casual tone.

Claude switches voices based on which example you point to.

Pattern 4: Team Collaboration

If multiple team members send proposals:

Setup:

examples/
  jane-proposal-style.md
  mike-proposal-style.md
  company-standard-structure.md

Usage:

Generate this proposal using Jane''s voice (examples/jane-proposal-style.md) since she''s the relationship owner for this client.

Result: Consistent quality but personalized to whoever''s sending it.

Pattern 5: Proposal + CRM Entry

Generate proposal AND tracking information:

After generating the proposal, also create a summary I can paste into HubSpot:

Format:
- Company: [name]
- Contact: [name + title]  
- Proposal sent: [today''s date]
- Total value: $X,XXX
- Decision timeline: [estimated based on client urgency]
- Next follow-up: [3 business days from now]
- Key notes: [one-line summary of unique considerations]

Claude generates both the proposal file and the CRM entry text.

Part 7: Refining Your Proposals Over Time

Tracking Performance

After sending 10-15 proposals generated with the skill, analyze:

Metrics to track:

Response rate (% of proposals that get any reply)

Conversion rate (% that turn into clients)

Time to decision (days from proposal sent to yes/no)

Questions clients ask (indicates unclear sections)

How to track: Create a simple spreadsheet:

| Client | Date Sent | Responded? | Converted? | Days to Decision | Questions Asked |
|--------|-----------|------------|------------|------------------|-----------------|

Common Refinement Patterns

Pattern 1: Clients consistently ask about timeline

Issue: Your timeline info is unclear or buried

Fix: Update your example proposal to have more explicit timeline:

Add timeline table to Recommended Approach section

Include Gantt chart or visual timeline

Make "when you''ll see results" more prominent

Then recalibrate Claude:

I''ve updated my example proposal to include a clearer timeline section. Please re-read examples/my-proposal-example.md and incorporate this new structure into all future proposals.

Pattern 2: Proposals are too long

Issue: Clients are skimming or not reading completely

Fix: Add constraint to skill or provide tighter example:

Going forward, keep proposals under 1,000 words. Be more concise in the Problem and Approach sections—get to the point faster.

Update my example at examples/my-proposal-example.md to reflect this tighter approach.

Pattern 3: Budget section causes sticker shock

Issue: Clients ghost after seeing pricing

Fix: Adjust how value is framed:

In future proposals, before the Investment section, add a brief "ROI Snapshot" that quantifies the value:

Example:
> **ROI Snapshot:** Your team currently spends 12 hours/week on manual tasks. At $75/hour average loaded cost, that''s $46,800/year. This automation pays for itself in under 2 months.

This should come right before Investment section in all proposals.

Pattern 4: Missing your unique positioning

Issue: Proposals sound like they could be from any consultant

Fix: Strengthen differentiators in your example:

I need to make my "Why Us" section more distinctive. Here''s what makes us genuinely different:

[Your unique positioning points]

Update my example proposal to reflect this, and make sure these points are prominent—not buried—in every proposal.

Updating the Skill File Itself

When to update the actual skill file:

You change your core process (e.g., you now always do discovery calls before proposals)

You add new required sections (e.g., you now always include testimonials)

You change tone rules (e.g., you decide to be more casual/formal)

You fix a bug (e.g., skill isn''t handling missing timeline well)

How to update:

Step 1: Edit the skill file

# Open in your editor
code .claude/skills/proposal-generator.md

Step 2: Make changes

For example, add new section requirement:

## Step 3: Generate Proposal

...existing sections...

8. Social Proof (NEW)
   - Include 1-2 brief client testimonials
   - Or mention similar client results
   - Build credibility without being salesy

Step 3: Save and restart

Changes to skill files require restarting Claude Code.

Step 4: Test

Generate a proposal to verify the change works.

Version Control Your Skill

Best practice:

.claude/skills/
  proposal-generator.md           # Current version
  archive/
    proposal-generator-v1.md      # Original
    proposal-generator-v2.md      # After first update
    proposal-generator-v3.md      # After second update

Why:

Easy rollback if new version has issues

Track evolution of your process

Reference old versions for specific edge cases

How: Before making changes:

cp .claude/skills/proposal-generator.md .claude/skills/archive/proposal-generator-v2.md

Then edit the current version.

Part 8: Troubleshooting Common Issues

Issue 1: Claude Doesn''t Recognize Proposal Trigger

Symptom: You paste client email and say "generate a proposal" but Claude doesn''t use the skill—just writes a generic response.

Causes:

You''re not in the folder where skill is installed

Skill file has syntax errors

Skill not properly named

Fixes:

Check folder:

What folder am I currently in?

Make sure it''s the folder containing .claude/skills/

Check skill installation:

What skills do you have access to?

If proposal-generator isn''t listed, reinstall.

Check skill file syntax: Open .claude/skills/proposal-generator.md and verify:

YAML frontmatter is properly formatted (3 dashes before and after)

No weird characters or formatting issues

File is actually named proposal-generator.md not proposal-generator.md.txt

Issue 2: Proposals Sound Generic

Symptom: Generated proposals don''t match your voice—they sound like AI wrote them.

Cause: Claude hasn''t properly absorbed your example, or your example isn''t distinctive enough.

Fixes:

Recalibrate with explicit instructions:

You''re using phrases I''d never use. Review examples/my-proposal-example.md again and pay special attention to:

1. How I describe problems (conversational, specific, no jargon)
2. How I structure the approach (concrete steps, not vague promises)
3. My exact "Why Us" differentiators (these must appear verbatim)

Generate a new proposal for [client] matching this style exactly.

Strengthen your example:

If your example proposal is itself a bit generic, update it:

Make tone more distinctive

Add more specific phrasing

Include more personality

Emphasize what makes YOU different

Issue 3: Wrong Budget Interpretation

Symptom: Client says "a few thousand" and Claude interprets it as $2-3K when you know this client typically means $8-10K.

Cause: Claude is being conservative without additional context.

Fix:

During confirmation, correct it:

The budget interpretation is too low. When this client says "a few thousand," they typically mean $5-10K based on past projects. 

Adjust pricing to the higher end of that range since this is a good client relationship.

For future, add context:

Note: This is an existing client. Our past projects have been in the $8-12K range. When they mention budget vaguely, assume higher end unless they specifically say "tight budget" or similar.

Issue 4: Missed Important Details

Symptom: You review the generated proposal and realize Claude missed something important the client mentioned.

Cause: Buried in long email or transcript, or mentioned in an unusual way.

Fix:

Add it manually during confirmation:

You missed that they mentioned compliance requirements (mentioned in paragraph 4). This is critical—add this to the Problem section and ensure the Approach addresses it.

For complex inputs, provide summary:

If client email is very long/rambly:

Before extracting signals, here''s my summary of the key points:
- [Point 1]
- [Point 2]  
- [Point 3]

Now extract signals with these in mind.

Issue 5: Proposal Too Long

Symptom: Generated proposals are 2,000+ words when you prefer 800-1,000.

Cause: Your example is verbose, or Claude is being overly thorough.

Fix:

Set explicit length constraint:

This proposal is too long. Keep future proposals under 1,000 words total. 

Be more concise:
- Problem section: 2-3 sentences max
- Approach: Bullet points, not paragraphs
- Why Us: 3 short bullets
- Deliverables: Bulleted list, no descriptions

Regenerate this proposal with these constraints.

Update your example to be tighter.

Part 9: Measuring ROI

Time Savings Calculation

Before the skill:

Reading/analyzing client email: 10 minutes

Drafting proposal from scratch: 45-60 minutes

Editing and refining: 15-20 minutes

Total per proposal: 70-90 minutes

With the skill:

Paste email: 30 seconds

Review extracted signals: 2 minutes

Confirm: 30 seconds

Review generated proposal: 3-5 minutes

Final tweaks: 2-3 minutes

Total per proposal: 8-11 minutes

Savings per proposal: 60-80 minutes

At 10 proposals/month:

Time saved: 10-13 hours/month

Annualized: 120-156 hours/year

At $150/hour rate:

Monthly value: $1,500-2,000

Annual value: $18,000-23,000

And that''s just time—doesn''t include:

Improved quality (catching details you''d miss)

Consistency (every proposal matches your best work)

Mental energy saved (no more blank-page paralysis)

Quality Improvements

Track these metrics over 30 days:

Before skill:

Proposals sent: X

Responses received: Y

Response rate: Y/X

Proposals that converted: Z

Conversion rate: Z/X

After skill:

Proposals sent: X

Responses received: Y

Response rate: Y/X (likely higher)

Proposals that converted: Z

Conversion rate: Z/X (likely higher)

Why quality improves:

Never miss signals: Claude catches budget hints, timeline cues, and pain points you might skim over

Consistent structure: Every proposal follows your proven format

No off days: Even when you''re tired/distracted, proposals stay high-quality

Faster follow-up: Send proposals same-day while conversation is fresh

Client Feedback

Track qualitative signals:

Positive indicators:

"This proposal really understood our situation"

"Exactly what we needed to see"

Quick turnaround (they respond within 24-48 hours)

Minimal questions (proposal was clear)

Negative indicators:

"This feels generic"

Lots of clarifying questions (proposal missed something)

Long silence (didn''t resonate)

Price objections (value not clear)

Use feedback to refine: Positive signals → Your calibration is good Negative signals → Revisit examples and skill configuration

Your Assignment

Week 1: Setup

Day 1: Create Example Proposal

Write or curate your ideal proposal example

Ensure it represents your voice perfectly

Save as examples/my-proposal-example.md

Day 2: Install and Verify

Create .claude/skills/ folder

Add proposal-generator.md skill file (provided resource)

Verify Claude sees the skill

Day 3: Calibrate

Have Claude read your example

Test with fictional scenario

Refine until output matches your voice

Week 2: Real-World Testing

Day 4-6: Generate 3 Real Proposals

Use with actual client emails/transcripts

Document time spent on each

Note any refinements needed

Day 7: Review and Adjust

Compare generated proposals to your manual work

Identify gaps or improvements

Update example or skill if needed

Month 2: Optimization

Week 3-4: Track Performance

Monitor response rates

Collect client feedback

Measure time savings

Document ROI

Week 5-6: Advanced Techniques

Try batch processing multiple proposals

Experiment with different examples for different client types

Integrate with your CRM workflow

Share Your Results

Post in the community:

Time savings you''ve measured

Quality improvements you''ve noticed

Refinements you made to the skill

Example proposal (client info redacted) showing your voice

Resources

Provided with This Lesson:

proposal-generator.md skill file (complete, ready to install)

Example proposal template (customize to your voice)

Calibration checklist

Claude Code Documentation:

Skills guide: code.claude.com/docs/en/skills', 5),
  ('54831f1d-fb68-4377-9a1e-303eb2dbf0a9', '88f4c273-96dd-4197-adb3-12d0f241322f', 'Brain Dump Visualiser with Claude Cowork', 'What it does

This skill takes everything in your head — tasks, ideas, questions, half-formed thoughts — and turns it into a structured, interactive visual board you can actually work from.

Paste in a wall of unstructured text, type "brain dump", and it produces an HTML board that automatically categorises every item (Tasks, Ideas, Questions, References), assigns a priority score (P1 this week / P2 this month / P3 someday), and groups everything by project or theme. At the top, it surfaces your three highest-priority tasks front and centre so you know exactly where to start.

The board is fully interactive — filter by category, toggle between a swimlane view and a category grid, click to expand any card. The before is 30 lines of noise. The after is a board you can actually work from.

Trigger command

Type any of the following to activate:

brain dump

clear my head

process my notes

organise my thoughts

How to install

Download the zip file attached to this lesson

Open Claude Code and click Customize in the left sidebar

Click Skills → hit the + button → Upload a Skill

Drag the zip file in and click Upload

The skill will appear in your skills list — it''s ready to use immediately

One thing to know

Don''t tidy up your input before pasting it in. The messier the better — that''s the whole point. Stream of consciousness, half-sentences, random bullet points — all of it. The skill is built to process noise, not clean notes.', 6),
  ('c296c071-7c3a-42f8-bcd0-e545a069800c', '88f4c273-96dd-4197-adb3-12d0f241322f', 'Use Whatsapp to Control Claude Code', 'This guide walks you through setting up WhatsApp as a two-way channel for Claude Code. Once set up, you can message your WhatsApp number and Claude will read, think, and reply — fully autonomous.

The setup uses:

Evolution API — self-hosted WhatsApp gateway (runs in Docker)

claude-whatsapp plugin — MCP channel server that bridges Evolution API ↔ Claude Code

Prerequisites

Before starting, install:

Docker Desktop — runs Evolution API

Bun — runs the Claude channel server (curl -fsSL <https://bun.sh/install> | bash)

Claude Code v2.1.80 or later with a claude.ai account

Part 1 — Set Up Evolution API

1.1 Create project folder

Create a folder anywhere on your machine for the Evolution API stack:

mkdir evolution-api && cd evolution-api

1.2 Create docker-compose.yml

Create a file called docker-compose.yml with this content:

version: ''3.9''
services:
  postgres:
    image: postgres:15-alpine
    container_name: evolution_postgres
    restart: always
    environment:
      POSTGRES_DB: evolution
      POSTGRES_USER: evolution
      POSTGRES_PASSWORD: evolution_password_123
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    networks:
      - evolution_network

  redis:
    image: redis:7-alpine
    container_name: evolution_redis
    restart: always
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    ports:
      - "6379:6379"
    networks:
      - evolution_network

  evolution-api:
    image: atendai/evolution-api:v2.1.1
    container_name: evolution_api
    restart: always
    ports:
      - "8080:8080"
    depends_on:
      - postgres
      - redis
    env_file:
      - .env
    volumes:
      - evolution_instances:/evolution/instances
    networks:
      - evolution_network

volumes:
  postgres_data:
  redis_data:
  evolution_instances:

networks:
  evolution_network:
    driver: bridge

1.3 Create .env

Create a file called .env in the same folder:

AUTHENTICATION_API_KEY=your-secret-api-key
SERVER_URL=http://localhost:8080
DEL_INSTANCE=false

DATABASE_ENABLED=true
DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_URI=postgresql://evolution:evolution_password_123@postgres:5432/evolution
DATABASE_SAVE_DATA_INSTANCE=true
DATABASE_SAVE_DATA_NEW_MESSAGE=true
DATABASE_SAVE_MESSAGE_UPDATE=true
DATABASE_SAVE_DATA_CONTACTS=true
DATABASE_SAVE_DATA_CHATS=true
DATABASE_SAVE_DATA_LABELS=true
DATABASE_SAVE_DATA_HISTORIC=true
DATABASE_CONNECTION_CLIENT_NAME=evolution_v2

CACHE_REDIS_ENABLED=true
CACHE_REDIS_URI=redis://redis:6379/1
CACHE_REDIS_PREFIX_KEY=evolution_v2
CACHE_REDIS_SAVE_INSTANCES=false
CACHE_LOCAL_ENABLED=false

RABBITMQ_ENABLED=false
S3_ENABLED=false

CONFIG_SESSION_PHONE_VERSION=2.3000.1035712111
CLEAN_STORE_CLEANING_INTERVAL=7200
CLEAN_STORE_MESSAGES=true
CLEAN_STORE_MESSAGE_UP_TO=false
CLEAN_STORE_CONTACTS=true
CLEAN_STORE_CHATS=true

Change your-secret-api-key to something secure. You''ll need this value later.

1.4 Start Evolution API

docker compose up -d

Wait about 30 seconds for all services to start, then open:

http://localhost:8080/manager

Log in with the API key you set in .env.

1.5 Create a WhatsApp instance

In the Evolution Manager UI, click New Instance

Give it a name (e.g. my-assistant)

Click Connect — a QR code will appear

Open WhatsApp on your phone → Linked Devices → Link a Device

Scan the QR code

The instance status should change to open (connected).

1.6 Configure the webhook

This tells Evolution API where to send incoming messages when they arrive.

In the Evolution Manager, select your instance from the left menu

Click Webhooks in the left sidebar

Toggle Enabled on

In the URL field, enter: http://host.docker.internal:3456/webhook

Scroll down to the events list and enable MESSAGES_UPSERT

Click Save

Important: Use host.docker.internal — not localhost. Evolution API runs inside Docker, so localhost refers to the container itself. host.docker.internal is how Docker on Mac reaches your machine.

Part 2 — Install the Claude Plugin

2.1 Add the marketplace

Open Claude Code (in any folder) and run:

/plugin marketplace add shabbirun/claude-whatsapp

2.2 Install the plugin

/plugin install whatsapp-evolution@claude-whatsapp

2.3 Configure your .env

The plugin creates a config file the first time it tries to start. Find it at:

~/.claude/plugins/data/whatsapp-evolution-claude-whatsapp/.env

Open it and fill in your values:

EVOLUTION_API_URL=http://localhost:8080
EVOLUTION_API_KEY=your-secret-api-key
EVOLUTION_INSTANCE=my-assistant

ALLOWED_NUMBER=15551234567
ALLOWED_JID=

WEBHOOK_PORT=3456

Field What to put EVOLUTION_API_KEY The key you set in Evolution API''s .env EVOLUTION_INSTANCE The instance name you created in the Manager ALLOWED_NUMBER Your WhatsApp number, digits only, with country code (e.g. 15551234567) ALLOWED_JID Leave blank for now — see troubleshooting below

2.4 Start Claude Code with the channel

In a terminal:

claude --dangerously-load-development-channels plugin:whatsapp-evolution@claude-whatsapp

You should see the whatsapp MCP server listed as connected in /mcp.

Part 3 — Send Your First Message

Send a WhatsApp message to the number connected to your Evolution API instance. Claude will read it and reply.

Watch the terminal where you launched Claude — you''ll see it processing the message and calling the reply tool to respond.

Troubleshooting

Messages aren''t coming through
Step 1 — Check the webhook URL
Make sure it''s http://host.docker.internal:3456/webhook, not localhost:3456.
curl <http://localhost:8080/webhook/find/YOUR_INSTANCE_NAME> \\
  -H "apikey: YOUR_API_KEY"
If the URL shows localhost, re-run the webhook set command from Part 1.6.
Step 2 — Check for @lid accounts
Newer WhatsApp multi-device accounts use a different ID format (@lid) instead of your phone number. If this applies to you, the terminal will show:
[whatsapp] Blocked — add ALLOWED_JID=76875653206151 to your .env and restart
Copy that number into ALLOWED_JID in your .env, then restart Claude Code.
Step 3 — Test the webhook directly
curl -X POST <http://localhost:3456/webhook> \\
  -H "Content-Type: application/json" \\
  -d ''{"event":"MESSAGES_UPSERT","instance":"YOUR_INSTANCE","data":{"key":{"remoteJid":"YOUR_NUMBER@s.whatsapp.net","fromMe":false,"id":"test-001"},"message":{"conversation":"hello"}}}
If Claude responds in the terminal, the pipeline works and the issue is the webhook URL.

MCP server fails / 1 MCP server failed
This is usually a stale process holding port 3456. Kill it:
kill $(lsof -ti :3456)
Then restart Claude Code.

.env keeps resetting to placeholder values
Make sure you''re editing the file at the PLUGIN_DATA path, not the plugin cache:
~/.claude/plugins/data/whatsapp-evolution-claude-whatsapp/.env   ✅ correct
~/.claude/plugins/cache/.../whatsapp-evolution/.../.env          ❌ wrong', 7),
  ('63c482ff-e8a4-47d6-9aac-e42e3ea39463', '88f4c273-96dd-4197-adb3-12d0f241322f', 'Lead Auto-Research Skill', 'Module: Claude Code SkillsOutcome: By the end of this lesson you''ll have the lead-autoresearch skill installed and running — finding qualified agency leads from Google Maps overnight, automatically.

What this skill does

This skill turns Claude Code into an autonomous lead generation machine. You start it, go to sleep, and wake up to a spreadsheet of qualified leads — names, websites, ratings, review counts, and a personalised outreach angle for each one.

It works by running a self-improving loop:

Searches Google Maps for businesses matching your ICP

Scores each result against a qualification rubric

Logs the results and writes a hypothesis about what worked

Generates better search criteria for the next cycle

Repeats — indefinitely, without asking for your input

The key idea is that the loop gets smarter over time. By cycle 10, it''s not guessing anymore — it knows which search combinations produce the best leads, because it''s been tracking that from the start.

What you''ll need before starting

1. Claude Code Already installed — you''re good.

2. An Apify account Apify is the tool that runs the Google Maps scraper. You''ll need a free account and an API token.

Go to apify.com and create a free account

Once logged in, go to Settings → Integrations → API tokens

Create a new token and copy it — you''ll need it in the next step

3. Apify MCP connected to Claude Code This is what lets Claude Code talk to Apify. To set it up:

Open Claude Code

Go to Settings → MCP Servers

Add a new server with this config:

{
  "mcpServers": {
    "apify": {
      "command": "npx",
      "args": ["-y", "@apify/mcp-server"],
      "env": {
        "APIFY_TOKEN": "your-token-here"
      }
    }
  }
}

Replace your-token-here with the API token you copied from Apify. Save and restart Claude Code.

Installing the skill

Step 1 — Download the skill file

Download lead-autoresearch.skill from the resources section of this lesson.

Step 2 — Find your skills folder

In Claude Code, open the command palette (Cmd+Shift+P on Mac, Ctrl+Shift+P on Windows) and search for "Open Skills Folder". This opens the directory where Claude Code looks for installed skills.

Step 3 — Install the skill

Drag the lead-autoresearch.skill file into that folder. Claude Code will detect it automatically — no restart needed.

Step 4 — Confirm it''s installed

In Claude Code, type:

what skills do you have installed?

You should see lead-autoresearch in the list.

Running the skill

Once the skill is installed and Apify MCP is connected, starting the loop is one message:

find me leads

Or any of these — they all trigger the same skill:

run the lead loop
start lead research
find agencies on Google Maps
run autoresearch

Claude Code will:

Confirm the skill has loaded

Check that Apify MCP is connected

Create two output files in your working directory (leads_master.csv and results.tsv)

Start the first cycle immediately

Then leave it alone. It will keep running until you stop it.

What you''ll get

Two files appear in your working directory as the loop runs.

leads_master.csv — your lead list

Every qualified lead gets a row with:

Column What it contains name Business name address Full address phone Phone number website Website URL rating Google rating review_count Number of reviews category Business category search_term What search found them location City searched cycle Which loop cycle found them score ICP match score (0–10) outreach_angle One-sentence personalised outreach hook

results.tsv — the research log

Every cycle gets a row showing what was searched, how many leads qualified, the average score, and the hypothesis Claude generated for the next cycle. This is what makes the system self-improving — it never forgets what it tried.

How leads get qualified

Not every business that shows up in Google Maps makes it into your lead list. The skill scores each result against a rubric and only logs leads that score 6 or higher out of 10.

Points are awarded for:

Having a website (+2)

20–200 reviews — established but not a chain (+2)

Rating between 4.0–4.9 (+1)

Category matches the target profile — agency, consulting, marketing, design, PR (+2)

Business name suggests an independent boutique firm (+1)

Located in a high-density US market (+1)

Service-based, not product-based (+1)

Hard disqualifiers — any of these automatically score the lead as 0:

No website

Chain or franchise

Solo operator / freelancer

Fewer than 10 reviews or more than 500

Closed

The first three cycles

The skill starts with three seed searches before it begins generating its own:

Cycle Search Location 1 marketing agency Chicago 2 digital marketing agency Austin 3 creative agency Atlanta

From cycle 4 onwards, Claude generates new search criteria based on what scored highest in previous cycles. This is the self-improving part.

Stopping the loop

The skill runs until you stop it manually. To stop it:

Press Escape in Claude Code, or

Type stop in the chat

Your output files are saved automatically — stopping the loop doesn''t lose any data.

What to do with the leads

Once you have a populated leads_master.csv:

Open it in Google Sheets or Excel

Filter by score — start with 8+ for your highest-quality leads

Use the outreach_angle column as the basis for your first message — it''s already personalised to each business

Work down from there

The outreach angle references something specific and observable about each business — review count, category, business name pattern — and connects it to an AI implementation use case. It''s a starting point, not a copy-paste message. Personalise it before sending.

Troubleshooting

"I need the Apify MCP connected" The skill detected that Apify MCP isn''t set up. Go back to the installation steps and check your MCP config — most commonly a typo in the API token or a missing restart of Claude Code.

The loop stopped after a few cycles Check results.tsv — if a cycle shows places_returned: 0, Apify returned no results for that search. The skill should recover automatically and try a new combination. If it''s stopped completely, restart with find me leads — your output files are preserved.

Leads look off — wrong business types showing up This is normal in the early cycles. The skill starts broad and narrows based on what scores well. By cycle 5–6 you should see the quality improving. If it''s still off at cycle 10, let us know in the community — we can look at your results.tsv together.

Next lesson

Once you''ve run the lead loop and have a list, the next lesson covers the autoresearch-builder skill — a tool that runs the same kind of self-improving loop for anything you want to optimise, not just lead gen.', 8),
  ('f0a71be3-1f55-4841-ad5b-370ec4980af9', '88f4c273-96dd-4197-adb3-12d0f241322f', 'Auto-Research Builder Skill', 'Module: Claude Code SkillsOutcome: By the end of this lesson you''ll understand what the autoresearch-builder skill does, have it installed, and know how to use it to create a custom self-improving loop for any metric in your business.

What this skill does

The lead-autoresearch skill (Lesson 1) is built for one specific use case — finding agency leads on Google Maps. This skill builds the equivalent for anything else you want to optimise.

You tell it what you want to improve. It interviews you, checks whether your use case is actually viable for auto-research, and then generates a ready-to-run skill file tailored to your specific metric, data source, and ICP.

Examples of what you could build with it:

A cold email subject line tester that iterates on reply rate

A content hook optimiser that scores post variations against engagement benchmarks

A prospect scoring loop that pulls from Apollo and refines filters over time

An SEO keyword tester that tracks ranking movement weekly

The constraint is always the same: the metric has to be measurable, and Claude has to be able to read the result automatically. The builder helps you figure out whether your idea meets that bar — and what to do if it doesn''t.

What you''ll need before starting

Claude Code — already installed.

No other dependencies at this stage. The skill you generate may require additional tools (Apify, Google Sheets MCP, etc.) — the builder will tell you exactly what''s needed before it writes the file.

Installing the skill

Step 1 — Download the skill file

Download autoresearch-builder.skill from the resources section of this lesson.

Step 2 — Open your skills folder

In Claude Code, open the command palette (Cmd+Shift+P on Mac, Ctrl+Shift+P on Windows) and search for "Open Skills Folder".

Step 3 — Install

Drag autoresearch-builder.skill into the folder. No restart needed.

Step 4 — Confirm

what skills do you have installed?

You should see autoresearch-builder in the list alongside lead-autoresearch.

Running the skill

Trigger it with any of these:

build me an autoresearch skill
create a self-improving loop for my email outreach
I want to automate improving my X
help me set up auto-research

Claude Code will start the interview immediately.

The interview

The builder runs a structured interview — one question at a time. It''s designed to extract exactly what it needs to generate a working skill, and to catch problems early before you''ve invested time in a broken setup.

Here''s what it covers:

Stage 1 — Your metric What''s the one number you want to move, and how often does it change? This needs to be specific and measurable. "More sales" won''t work. "Cold email reply rate, tracked daily" will.

Stage 2 — The lever What''s the one thing you''d change to move that number? The builder forces you to commit to a single variable — that''s what makes the learning reliable. If you try to change multiple things at once, you can''t know what caused the improvement.

Stage 3 — Viability check This is the gate. The builder checks two things:

Feedback speed: How long until you see a result after making a change?

Same day or within 48 hours → good to go

Up to a week → workable, but slow

Weeks or longer → the builder will help you find a faster proxy metric instead

Programmatic access: Can Claude read the result data automatically?

The builder maps common platforms to routes:

Platform Status Google Sheets, Notion, Airtable ✅ Claude reads via MCP Gmail / email inbox ✅ Claude reads via MCP Any tool with an API ✅ Claude calls directly Apollo, Google Maps ✅ Apify actors available LinkedIn native analytics ❌ No API — workaround needed Skool dashboard ❌ No API — workaround needed Instagram / TikTok analytics ❌ No API — workaround needed

If your metric lives somewhere Claude can''t access, the builder doesn''t just stop — it offers three specific workarounds and helps you find a path forward.

Stages 4–7 If the viability check passes, the builder collects the remaining details: where the raw material comes from, what separates a good result from a bad one, any hard constraints, and three seed combinations to start the first cycles.

Viability outcomes

After the interview, the builder routes to one of three outcomes:

Green — builds the skill immediately All checks passed. The skill file is generated and written to your outputs folder.

Amber — builds with caveats Slow feedback loop or an access workaround is needed, but there''s a path forward. The builder generates the skill with a note in the prerequisites section explaining what to set up first.

Red — does not build The use case isn''t a good fit for auto-research. The builder tells you exactly why and suggests what to do instead. A Red outcome is more useful than a broken skill that runs but produces nothing.

What you get

A SKILL.md file written to your outputs folder, named after your use case — email-autoresearch.skill, content-autoresearch.skill, etc.

The generated skill follows the same structure as lead-autoresearch:

Prerequisites and setup instructions

The experiment loop

Seed combinations for cycles 1–3

A scoring rubric built from your quality definition

Output file formats

Hypothesis rules

Error handling

The NEVER STOP instruction

Install it the same way you installed lead-autoresearch — drag it into your skills folder.

Things worth knowing before you start

One variable at a time The most common mistake is trying to test too many things at once. If you change the subject line AND the send time AND the list, you can''t know what caused the improvement. The builder will push back on this — pick one lever and commit to it.

The proxy metric is your friend If your real metric is too slow (brand awareness, SEO rankings, revenue) or not programmatically accessible (LinkedIn analytics, Skool stats), the builder helps you find a proxy — something faster and readable that correlates with your real goal. Don''t skip this step. A good proxy metric is often better than the "real" metric because it gives you faster feedback.

The log is what makes it self-improving Every skill generates a results.tsv log file. This is the memory of the system. It records every cycle, every hypothesis, every result. Without it, every cycle starts from scratch. With it, the system compounds. Don''t delete it.

Cycles take time If your feedback loop is 48 hours per cycle, meaningful learning takes 3–4 weeks. That''s not a problem — it''s just a reality. Set it running and check back in. The skill does the work; you don''t have to.

Troubleshooting

The builder keeps asking me to clarify my metric This means the metric isn''t specific enough yet. A good metric has a number, a timeframe, and a data source. "More engagement" is not a metric. "LinkedIn post likes in the first 24 hours, tracked in a Google Sheet" is.

The builder gave me a Red outcome Read the explanation carefully — it will name the specific reason. The most common causes are slow feedback loops and inaccessible data. The builder will suggest alternatives. Work through those before concluding your use case won''t work.

The generated skill isn''t running correctly Post your results.tsv file in the community. The log shows exactly what happened each cycle and makes it easy to diagnose what went wrong.

What to build first

If you''re not sure where to start, here are three use cases that work well and are commonly relevant to this community:

Cold email subject lines Metric: reply rate. Lever: subject line copy. Data source: your email tool''s API (Instantly, Smartlead, Lemlist all have APIs). Feedback: 24–48 hours. Viable: yes.

Google Maps lead qualification Already built — that''s Lesson 1. But if you want to adapt it for a different ICP or geography, use the builder to generate a customised version.

Apollo prospect filtering Metric: lead quality score. Lever: Apollo filter combinations (job title, company size, industry, technology used). Data source: Apollo API. Feedback: immediate. Viable: yes.

Start with whichever is closest to your biggest current bottleneck.', 9),
  ('138110ec-8ac7-49df-b2f6-c6a3efdafcdc', '88f4c273-96dd-4197-adb3-12d0f241322f', 'Instant Client Research', 'AI-Powered Lead Research: Build a Pre-Meeting Intelligence Pipeline That Runs in Claude

Lesson Overview

You''ll build a fully autonomous pre-meeting research pipeline inside Claude that scrapes company websites, pulls LinkedIn data via Apify, reads recent news, and synthesises everything into a 4-page sales prep document — without you touching a single tab. By the end, you''ll have a skill that turns a lead''s name + URL into a ready-to-use brief in under 90 minutes, automatically.

Time to Complete: 90 minutesDifficulty: IntermediateTools Required: Claude (with Skills), Firecrawl MCP, Apify (with account + credits)Time/Value Transformation: From 3–4 hours of manual research per lead → 90 minutes autonomous pipeline → 15 minutes of your review

The Problem

Traditional Pre-Meeting Research Reality

Before a sales call with a new lead, most agency owners do something like this:

Open LinkedIn, manually read their profile: 20 min

Google the company, scan 4–5 tabs: 15 min

Look for their recent posts, copy-paste notes: 20 min

Search for news, press releases: 10 min

Try to figure out their tech stack from the website: 10 min

Write up a brief from scattered notes: 30 min

Realise you forgot to check their team page, go back: 10 min

TOTAL: 2–4 hours per lead, done manually, inconsistently, and usually rushed the morning of the meeting.

The output is usually a messy doc with a few bullet points and a gut-feel guess at what to say.

AI-Powered Solution

With this pipeline running inside Claude:

Firecrawl scrapes the homepage, about page, case studies, blog, and careers page simultaneously

Apify pulls structured LinkedIn data — profile, posts, company headcount, hiring signals

Google News actor surfaces the last 90 days of press automatically

Claude runs a cross-signal pattern match across all collected data

A formatted 4-page prep doc is assembled and ready

TOTAL: ~90 minutes autonomous runtime, 15 minutes of your review

The Transformation: You walk into every sales meeting having read more about the lead than they''d expect any consultant to know — and that alone closes deals.

System Architecture Overview

Research Pipeline

Stage 1: Data Collection (Phases 1–3)
├── Firecrawl MCP
│   ├── Homepage + /about scrape
│   ├── /case-studies, /clients, /work crawl
│   ├── /blog crawl
│   ├── /careers scrape
│   └── Firecrawl search (news, reviews, tech stack)
│
└── Apify MCP
    ├── harvestapi/linkedin-company (headcount + growth)
    ├── harvestapi/linkedin-profile-scraper (lead + key people)
    ├── harvestapi/linkedin-profile-posts (lead + CEO posts)
    ├── harvestapi/linkedin-company-posts (company content)
    ├── curious_coder/linkedin-jobs-scraper (hiring signals)
    └── easyapi/google-news-scraper (recent press)

Stage 2: Cross-Signal Synthesis (Phase 4)
├── Ambition vs capacity gap analysis
├── Personal identity signal extraction
├── Family/partner business dynamic check
├── Passive income signal detection
├── Social silence pattern
├── Tech maturity gap mapping
└── Named client quality vs ops tooling tension

Stage 3: Document Assembly (Phase 5)
├── Page 1: At a Glance (hooks + pain hypothesis)
├── Page 2: Company (snapshot + tech + clients + news)
├── Page 3: Key People (lead profile + CEO priorities)
├── Page 4: Strategy (objections + questions + buying process + red flags)
└── Appendix: Raw source links

Phase 1: Setting Up Your Connectors

Connect Firecrawl MCP to Claude

Firecrawl is what lets Claude actually visit and read websites. Without it, Claude can only search — not scrape structured content from specific pages.

Steps:

Go to firecrawl.dev and create an account

Generate an API key from your dashboard

In Claude.ai → Settings → Connectors → Add MCP → paste the Firecrawl MCP URL

Verify the connection is active

Why This Matters: Firecrawl gives Claude the ability to read a company''s /case-studies page and extract named clients — something a web search alone can''t do reliably.

You''ll know it''s working when: You ask Claude to scrape a URL and it returns the page''s markdown content rather than searching for it.

Phase 2: Setting Up Apify

Apify is the critical piece most people skip — and it''s why their LinkedIn data is always missing. Firecrawl and web search cannot access LinkedIn. Apify has purpose-built actors for this.

Step 2.1 — Create an Apify Account and Fund It

Go to apify.com and sign up

Add credits to your account — $10–20 is enough for dozens of lead research runs
LinkedIn Profile Scraper: ~$0.004 per profile

LinkedIn Posts Scraper: ~$0.002 per post

LinkedIn Company Scraper: ~$0.004 per company

Google News Scraper: ~$0.005 per article

Jobs Scraper: ~$0.001 per job listing

Cost per lead research run: approximately $0.15–0.50 total. This is not a meaningful cost relative to any consulting deal.

Step 2.2 — Connect Apify MCP to Claude

In Claude.ai → Settings → Connectors → Add MCP

Add the Apify MCP connection

Authenticate with your Apify API key

Step 2.3 — The Exact Actors You Need

You don''t need to install anything. Apify actors run on-demand. These are the ones the pipeline calls:

Actor ID What It Does Cost harvestapi/linkedin-company Company headcount, growth, specialties $0.004/company harvestapi/linkedin-profile-scraper Full profile: role, career history, education $0.004/profile harvestapi/linkedin-profile-posts Last N posts with engagement data $0.002/post harvestapi/linkedin-company-posts Company page posts $0.002/post curious_coder/linkedin-jobs-scraper Open roles at the company $0.001/job easyapi/google-news-scraper News articles by company name $0.005/article

Why This Matters: LinkedIn profile posts are the single most valuable signal in the entire pipeline. A founder''s personal posts tell you what they care about, what they''re proud of, and how they think — none of which appears anywhere else. The Brady Spear example: his Telly Awards post, his cancer remission post, and his Spearhead Stock launch post told us more about how to open that meeting than anything on the company website.

You''ll know it''s working when: Claude calls call-actor() and returns structured JSON with the lead''s career history and post content.

If you skip this: You''ll get a surface-level research brief with company facts but no personal intelligence — exactly the kind of brief that gets ignored because it reads like something a VA assembled from a Google search.

Phase 3: Installing the Skill in Claude

Step 3.1 — What a Claude Skill Is

A skill is a .skill file you install into Claude that tells it exactly how to run a specific workflow. When you trigger the skill with a phrase like "prep me for a meeting," Claude loads the full 5-phase SOP and executes it autonomously — tool calls, synthesis, document assembly, all of it.

Step 3.2 — Download and Install

Download the client-research-sop.skill file (linked in Resources below)

In Claude.ai → Settings → Skills → Install from file

Select the .skill file

Confirm installation

Step 3.3 — Trigger Phrases

Once installed, Claude will run the full pipeline when you say any of:

"Prep me for a meeting with [name] at [company]"

"Research this lead: [name], [role], [company URL], [LinkedIn URL]"

"Run the client research SOP"

"I''m meeting [name] from [company] on [date]"

"Do a lead brief for [name]"

Key rule: Always provide the lead''s LinkedIn URL. Without it, Claude cannot target the Apify profile scrapers correctly.

Phase 4: Understanding the Cross-Signal Synthesis (The Secret Weapon)

This is the part most AI research pipelines miss entirely. Collecting data is easy. Connecting signals across that data is what produces prep docs that actually win meetings.

The 7 Cross-Signal Patterns Claude Checks

Before writing a single word of the prep doc, the skill forces Claude to run through these seven questions across all collected data:

Pattern 1: Ambition vs Capacity Gap

What to look for: Is the lead launching new products, entering new markets, or adding revenue streams — while headcount has stayed flat?

If yes → Pain is operational bandwidth, not strategy. Frame automation as capacity, not technology. Don''t sell the tool. Sell the hours back.

Brady Spear example: Two markets, 8 staff, 80+ booking SKUs, Spearhead Stock, and a Creators Store — all with the same headcount. Classic ambition vs capacity gap.

Pattern 2: Personal Identity Signals

What to look for: What does the lead post about personally (not company reposts)? What do they celebrate? What do they criticise?

Why it matters: This tells you how they see themselves — which tells you how to frame your value. A founder who posts about craft awards wants to be seen as excellent, not efficient. Lead with quality and reputation, not cost reduction.

Pattern 3: Family/Partner Business Dynamic

What to look for: Is a spouse, family member, or co-founder in an ops role (Managing Partner, EP, COO)?

If yes → Do not treat the lead as a solo decision-maker. Name the partner in your buying process section. Ask to have them on the next call. Framing automation as "replacing how Elaina works" will kill the deal — frame it as "giving Elaina back time."

Pattern 4: Passive Income Signals

What to look for: Has the lead launched any productised offerings — stock libraries, presets, templates, courses, subscriptions?

If yes → They''re already thinking about earning without trading time for money. AI automation is the next step in that same thinking. Lead with: "You''ve already started productising your expertise — this is how you systematise the business that supports those products."

Pattern 5: Social Silence Signal

What to look for: When did the lead last post personally on LinkedIn?

If 6+ months ago → They may not be actively looking for solutions. You''ll need to surface the pain rather than respond to it. Open by asking about their current workflow before pitching anything.

Pattern 6: Tech Maturity Gap

What to look for: What tools are visible on their site? What''s conspicuously absent?

Map what they have vs what a business their size should have:

Business Size What They Should Have What to Look For 1–5 staff Basic CRM, email automation Absence of any CRM 5–15 staff CRM + booking automation + follow-up sequences WooCommerce without post-purchase automation 15–50 staff Full ops stack: CRM, project management, automated billing Any manual process at this scale is a gap

Pattern 7: Named Client Quality vs Operational Tooling

What to look for: Are their clients Fortune 500 / enterprise-level, but their ops stack is WordPress + Dropbox + email?

If yes → They''ve outgrown their ops. The business has levelled up; the systems haven''t. This tension is your strongest opening.

Why This Step Changes Everything

The HTML output that beat the first run of this pipeline caught Brady''s:

Cancer → remission → "what''s next" inflection point (personal identity signal)

Elaina as joint decision-maker (family business dynamic)

Stock + Creators Store + new market = passive income ambition (passive income signal)

1.5 years of LinkedIn silence (social silence signal)

Compass, Salesforce, Toyota as clients but no CRM (client quality vs tooling gap)

None of these came from a single data source. They came from connecting signals across five different data points. That''s what this synthesis step is designed to force.

Phase 5: Reading the Output

What the Prep Doc Contains

Page 1 — At a Glance Quick-scan summary: lead name, company, LinkedIn, pain hypothesis in one sentence, and the top 3 hooks you''ll use in the first 5 minutes.

Page 2 — Company Founded, HQ, headcount, growth trend, funding signals, named clients, tech stack, recent news, review themes.

Page 3 — Key People Lead''s career summary, their top LinkedIn posts and what those posts reveal, CEO/founder priorities if different from the lead, any podcast or writing found.

Page 4 — Strategy This is the page you read in the 20 minutes before the call:

Pain hypothesis with evidence citations

3 personalised hooks (each tied to a specific post, client, or press mention)

3 likely objections with suggested responses using their specific business context

5 questions to ask — each referencing something specific from the research

Buying process: who decides, estimated budget range, likely sales cycle

Red flags to qualify on

Appendix Every source URL collected during research. Shabbir can drill into any of these before the call.

The Hook Quality Standard

Every hook in the output must pass this test: could this only be said about this specific person, or could it be said about anyone in their industry?

Bad hook: "I saw you''re in the video production space — that''s a great industry for automation."Good hook: "I noticed you won 11 Telly Awards last year, 6 in real estate specifically — that''s a quality signal that most of your competitors aren''t broadcasting in their booking flow."

The difference is specificity. Specificity proves you did the work. Doing the work is what earns trust before the pitch starts.

Business Applications & ROI

Application 1: Solo Consultant / Agency Owner

Run this before every qualified discovery call. Your close rate on first meetings improves because you''re opening with insight instead of generic rapport-building. You''re asking questions that make prospects think "how did they know that?" — which immediately signals competence.

Application 2: Sales Team Enablement

Build the pipeline once, give it to your team. Every SDR or account exec can trigger the same research quality before their calls, without needing to learn research skills.

Application 3: Client Deliverable — Sell the Brief

Some consultants sell the lead research brief itself as a standalone product to clients who want intelligence on potential partners, acquisition targets, or competitors. At $200–500 per brief, this pipeline pays for itself in 1–2 runs.

ROI Calculation

Traditional method (1 qualified lead per week):

Manual research time: 3 hours × $100/hour (your effective rate) = $300

Inconsistent quality: some calls under-prepared

TOTAL: $300/week in research time, variable quality

Automated pipeline (1 qualified lead per week):

Apify credits: ~$0.50 per run

Firecrawl credits: ~$1.00 per run

Claude time: included in your subscription

Your review time: 15 minutes

TOTAL: ~$1.50 + 15 min per brief

Weekly savings: ~$295 in recovered timeAnnual savings: ~$15,000 in time recapturedActual value add: Higher close rates from better meeting prep — one extra deal closed per quarter at $3,000+ more than covers the entire setup.

Advanced Extensions

Extension 1: Auto-Trigger from CRM

Connect your CRM (HubSpot, Notion, Airtable) to n8n. When a lead moves to "Meeting Scheduled" stage, automatically send their details to Claude with the research trigger phrase. The brief lands in your inbox before you even know you need it.

Extension 2: Notion Output Instead of PDF

Update the delivery instruction in the skill to push the output directly to a Notion page via the Notion MCP connector. Every lead gets a Notion page auto-created with the brief — searchable, linkable, shareable.

Extension 3: Brief Quality Scoring

After each meeting, log whether the hooks landed, whether the objections appeared, whether the questions opened useful conversations. Use that feedback to iterate the cross-signal patterns in Phase 4. Over time, the synthesis gets sharper for your specific niche.

Troubleshooting

Issue 1: Apify Calls Not Firing

Problem: Claude runs the research but skips the LinkedIn data steps, substituting web search results instead.

Cause: The skill''s tool usage instruction wasn''t read, or Claude defaulted to Firecrawl for all steps.

Solution:

Confirm the Apify MCP is connected: Settings → Connectors → check Apify is listed and active

When triggering the pipeline, explicitly add: "Use Apify for all LinkedIn data steps"

If it still skips: start a fresh conversation, reinstall the skill, and try again

Prevention: The skill file includes a mandatory notice at the top — if Claude reads it properly, it won''t skip Apify calls. If it persists, this is a context window issue and a fresh conversation usually resolves it.

Issue 2: LinkedIn Profile Returns Empty Data

Problem: The Apify LinkedIn profile scraper returns null or minimal data.

Cause: The LinkedIn URL format is wrong, or the profile is set to private.

Solution:

Ensure the URL format is: https://www.linkedin.com/in/username/ (with trailing slash)

Remove any query parameters (?trk=... etc.) from the URL

Try the profile URL directly in a browser to confirm it''s public

Prevention: Always clean the LinkedIn URL before passing it to the skill. The skill checklist includes a URL validation step.

Issue 3: Pain Hypothesis Is Generic

Problem: The output says something like "They may have operational inefficiencies" rather than a specific, evidence-backed hypothesis.

Cause: The cross-signal pattern matching step didn''t connect signals across data sources — it just listed what was found.

Solution: After the pipeline runs, prompt Claude explicitly: "Run the cross-signal scan again. What''s the ambition vs capacity gap for this lead? What do their personal posts reveal about their identity? Is there a passive income signal?"

Prevention: The skill includes good/bad examples for the pain hypothesis. If the output is generic, it means one of the data collection phases returned empty — check which Apify calls succeeded and which failed.

Assignment: Build Your Lead Intelligence Pipeline

Phase 1: Basic Implementation (Week 1)

Connect both MCPs — Firecrawl and Apify active in Claude, confirmed with a test scrape and a test actor call

Install the skill — client-research-sop.skill installed and triggering correctly

Run one real brief — Pick an actual lead or a business you''re familiar with (so you can verify accuracy), trigger the pipeline, review the output

Demo: Share your brief in the community — what did the cross-signal synthesis surface that you wouldn''t have caught manually?

Phase 2: Advanced Challenge (Week 2)

Stress test it — Run the pipeline on 3 different lead types: a solo founder, a mid-size agency, a corporate decision-maker. Note how the synthesis differs.

Customise the cross-signal patterns — Add one new pattern specific to your niche (e.g., if you serve e-commerce brands, add a "Shopify vs custom platform" maturity signal)

Business Application: Use the brief in a real meeting. Report back on which hooks landed and which didn''t.

Phase 3: Production Deployment (Week 3)

Automate the trigger — Connect your booking or CRM system so the brief runs automatically when a meeting is scheduled

Refine the synthesis — Update Phase 4 in the skill based on what you learned from real meetings

Business Case: Calculate your actual time savings and close rate improvement over the three weeks. Present this as a ROI case study to sell the service (or the brief itself) to a client.

Success Metrics

Technical: Both Firecrawl and Apify calls fire on every run, no manual substitution

Performance: Brief generated in under 90 minutes, 4 pages + appendix, all hooks cite specific evidence

Business Value: At least one hook per brief that the lead comments on in the meeting ("How did you know that?")

Resources & Templates

Complete System Package

client-research-sop.skill — Install directly into Claude, runs the full pipeline autonomously

Apify Actor List — The 6 exact actors used, with IDs and cost estimates

Cross-Signal Pattern Reference Card — The 7 patterns from Phase 4, formatted as a one-page cheat sheet

Brief Template — The 4-page output structure, for reference if you want to adapt the format

Additional Resources

Firecrawl MCP docs — firecrawl.dev/docs

Apify actor store — apify.com/store (search for any platform if you need to extend the pipeline)

Brady Spear example brief — The HTML output from the test run, shared in the community thread

Key Takeaways

Technical Mastery: ✅ Firecrawl MCP for website scraping — homepage, case studies, careers, blog in one crawl ✅ Apify for LinkedIn data — the only reliable way to get structured profile, posts, and company data ✅ Cross-signal pattern matching — connecting 7 signals across data sources to produce non-generic insights

Business Transformation: ✅ ~$295/week in recovered research time (3 hours manual → 15 minutes review per qualified lead) ✅ Higher meeting quality — every call opens with specific, citable intelligence instead of generic rapport ✅ Sellable as a standalone service — $200–500 per brief as a productised intelligence offering

Strategic Positioning: ✅ You walk into meetings knowing things the prospect didn''t expect you to know — that''s a trust signal before a single slide is shown ✅ The same pipeline that helps you close deals can be white-labelled and sold to clients as a competitive intelligence service ✅ This is the foundation for a full agentic sales support system — add CRM triggers, Notion output, and meeting follow-up automation as extensions

The difference between a consultant who closes and one who doesn''t often comes down to one thing: who did more homework. This pipeline makes sure that''s always you.', 10),
  ('20799e3b-769e-4a81-bd1d-24e18cd3a204', '88f4c273-96dd-4197-adb3-12d0f241322f', 'Claude Cowork Cold Outreach System', 'AI-Powered Cold Outreach Pipeline: From Zero to Booked Calls in 4 Steps

Lesson Overview

You''ll build a complete AI outreach system that finds qualified leads on Google Maps, deep-researches each one, writes hyper-personalized cold emails, and manages the entire follow-up sequence through Gmail — all running from a single folder in Claude Code. By the end, you''ll have a repeatable pipeline that replaces 15-20 hours/week of manual prospecting with a system you can run with natural language commands.

Time to Complete: 120-150 minutes Difficulty: Intermediate Tools Required: Claude Code (or Cowork), Apify account, Firecrawl account, Gmail Time/Value Transformation: 15-20 hours/week of manual prospecting → 30 minutes/day of pipeline management

The Cold Outreach Problem

Traditional Outreach Reality

Here''s what manual B2B outreach actually looks like when you break it down:

Research potential companies on Google, LinkedIn, directories: 3-4 hours/week

Find the right contact person at each company: 2-3 hours/week

Visit each company''s website, read about them, take notes: 3-4 hours/week

Write individualized emails that don''t sound like templates: 4-5 hours/week

Track who you emailed, when to follow up, who replied: 2-3 hours/week

Actually send follow-ups on the right schedule: 1-2 hours/week

TOTAL: 15-20 hours/week — and most of it is research and writing, not selling.

AI-Powered Pipeline

The same workflow, automated:

Tell Claude Code "find 20 marketing agencies in Chicago" → 2 minutes

"Enrich all found leads" → runs autonomously, ~10 minutes

"Write emails for all enriched leads" → runs autonomously, ~5 minutes

"Run the daily outreach" → creates Gmail drafts + checks for replies, ~3 minutes

Review drafts in Gmail, hit send → 15-20 minutes

TOTAL: 30-40 minutes/day of review and sending

The Transformation: You go from spending half your work week on prospecting to spending half an hour. And the emails are more personalized than what most people write manually, because the AI reads the prospect''s entire website, LinkedIn profile, podcast appearances, and social media before writing a single word.

System Architecture Overview

The 4-Skill Pipeline

Skill 1: LEAD FINDER
├── Scrapes Google Maps via Apify
├── Scores and filters leads (0-10 rubric)
├── 6-method cascade to find the decision-maker
│   ├── Google Maps listing data
│   ├── Company website scrape (Firecrawl)
│   ├── LinkedIn company search (Apify)
│   ├── LinkedIn profile scrape (dev_fusion)
│   ├── Google search fallback
│   └── Website contact page fallback
├── Classifies email type (work / constructed / generic)
└── Creates lead.md + updates index.md

Skill 2: LEAD ENRICHER
├── Deep website scan (4 pages: home, services, about/team, blog/cases)
├── LinkedIn profile data (or reuses from Skill 1)
├── Contact visibility research (podcasts, articles, speaking)
├── Company news scan
├── Social media presence check
├── Synthesizes: pain hypothesis, capacity analysis, tech stack map
├── Generates 5 categorized personalization hooks
├── Identifies 3-4 specific automation opportunities
└── Creates enrichment.md + updates index.md

Skill 3: COLD EMAIL WRITER
├── Reads lead.md + enrichment.md
├── Writes Email 1: personalized cold opener (80-120 words)
├── Writes Email 2: new angle follow-up (60-90 words)
├── Writes Email 3: pattern interrupt (30-60 words)
├── Writes Email 4: clean breakup (40-70 words)
├── Applies voice rules and quality checklist
└── Creates emails.md + updates index.md

Skill 4: OUTREACH MANAGER
├── Phase 1: Reply detection (Gmail search)
│   ├── Classifies: real reply vs. auto-reply/OOO vs. bounce
│   └── Stops sequence on real reply or bounce
├── Phase 2: Send due emails
│   ├── Creates Gmail drafts (not sent — review first)
│   ├── Threads follow-ups via Re: subject
│   └── Applies daily send cap (default: 15)
├── Phase 3: Daily briefing report
└── Updates emails.md + index.md

The Folder Structure (Your Lightweight CRM)

Every lead gets its own folder. Every file has YAML frontmatter that tracks the current stage. An index file at the root keeps the whole pipeline in sync.

outreach/
├── index.md              ← Master tracker — one YAML entry per lead
├── leads/
│   ├── bright-side-creative/
│   │   ├── lead.md       ← Company data + contact info
│   │   ├── enrichment.md ← Deep research + personalization hooks
│   │   └── emails.md     ← Email sequence + send/reply tracking
│   ├── summit-media-group/
│   │   ├── lead.md
│   │   ├── enrichment.md
│   │   └── emails.md
│   └── ...

Why markdown files instead of a database? Because Claude Code reads and writes markdown natively. No API layer, no database setup, no schema management. You tell Claude "enrich all found leads" and it reads the index, filters by stage, processes each folder, and updates everything. The file system IS the database.

Phase 1: Setup — MCP Configuration and Accounts

Before building anything, you need three external accounts connected to Claude Code via MCP (Model Context Protocol). MCP lets Claude Code call external tools directly — think of it as giving Claude hands to reach into other services.

Create Your Accounts

Apify — the scraping engine. Handles Google Maps data and LinkedIn profile extraction.

Sign up at apify.com (free tier gives you enough credits to test)

Go to Settings → API & Integrations → Create a new token

Save your APIFY_TOKEN

Firecrawl — the website reader. Scrapes company pages and extracts clean, structured content.

Sign up at firecrawl.dev

Go to API Keys → Create a new key

Save your FIRECRAWL_API_KEY (starts with fc-)

Gmail — the sending layer. Creates drafts and searches for replies.

This uses Google''s hosted MCP endpoint — no API key needed, it authenticates via your Google account when Claude Code first connects

Configure .mcp.json

Create a file called .mcp.json in your project root. This tells Claude Code which external tools are available.

{
  "mcpServers": {
    "apify": {
      "command": "npx",
      "args": ["-y", "@apify/actors-mcp-server@latest"],
      "env": {
        "APIFY_TOKEN": "YOUR_APIFY_API_TOKEN"
      }
    },
    "firecrawl": {
      "command": "npx",
      "args": ["-y", "firecrawl-mcp"],
      "env": {
        "FIRECRAWL_API_KEY": "YOUR_FIRECRAWL_API_KEY",
        "FIRECRAWL_RETRY_MAX_ATTEMPTS": "5",
        "FIRECRAWL_RETRY_INITIAL_DELAY": "2000",
        "FIRECRAWL_RETRY_MAX_DELAY": "30000",
        "FIRECRAWL_RETRY_BACKOFF_FACTOR": "3"
      }
    },
    "gmail": {
      "type": "url",
      "url": "https://gmailmcp.googleapis.com/mcp/v1"
    }
  }
}

Replace YOUR_APIFY_API_TOKEN and YOUR_FIRECRAWL_API_KEY with your actual keys.

Why This Matters: Without this file, Claude Code has no way to scrape websites, search LinkedIn, or interact with Gmail. This is the nervous system that connects your AI brain to the outside world.

You''ll know it''s working when: You restart Claude Code and run /mcp — all three servers should show as connected.

If you skip this: Nothing else in this lesson works. The pipeline is 100% dependent on these three external connections.

Phase 2: Skill 1 — Lead Finder

The lead finder does three things: scrapes Google Maps for businesses matching your criteria, scores each one against a qualification rubric, and then runs a 6-method cascade to find the actual decision-maker at each company.

The Google Maps Scrape

The system uses Apify''s compass/crawler-google-places actor. You give it a business type and location, it returns structured data for every matching listing.

call-actor(
  actor="compass/crawler-google-places",
  input={
    "searchStringsArray": ["marketing agencies"],
    "locationQuery": "Chicago, USA",
    "maxCrawledPlacesPerSearch": 30,
    "language": "en",
    "website": "withWebsite",
    "skipClosedPlaces": true,
    "countryCode": "us",
    "placeMinimumStars": "three",
    "scrapeContacts": true,
    "maxReviews": 0,
    "maxImages": 0
  }
)

Two settings matter here: website: "withWebsite" filters out businesses without a website (you can''t research or email them), and scrapeContacts: true sometimes pulls email and social links directly from the listing — giving the contact-finding cascade a head start.

The Scoring Rubric (0-10)

Not every Google Maps result is worth pursuing. The skill scores each lead and only processes those scoring 6 or higher.

Signal Points Has a website +2 20-200 reviews +2 Rating 4.0-4.9 +1 Category matches target vertical +2 Business name suggests independent/boutique firm +1 Located in a high-density market +1 Service-based (not product/retail) +1

Hard disqualifiers (skip entirely, don''t even score): no website, permanently closed, under 10 reviews, over 500 reviews, franchise/chain, already in the index (dedup check).

Why This Matters: Without scoring, you waste enrichment credits and writing time on leads that will never convert. A solo freelancer with 3 reviews is not the same prospect as a 15-person agency with 140 reviews.

The Contact-Finding Cascade

This is where the system gets clever. Finding a company is easy — finding the actual person to email is hard. The skill tries six methods in sequence and stops as soon as it has a name + work email:

Google Maps listing — sometimes includes owner name, email, social links

Company website scrape — /about, /team, /leadership pages via Firecrawl

LinkedIn company search — finds the company page, identifies decision-makers from the employee list

LinkedIn profile scrape — dev_fusion/linkedin-profile-scraper extracts full profile data including email, work history, education, and skills in a single call

Google search fallback — "company name" + "founder" OR "owner" OR "CEO"

Website contact page — last resort, grabs whatever email exists (even generic ones)

Critical email classification rule: The system only keeps work emails (on the company''s domain, like jane@brightsidecreative.com). Personal emails on Gmail, Yahoo, Outlook, etc. are discarded — sending cold outreach to someone''s personal inbox is invasive and kills your chances.

If no contact is found after all six methods, the lead gets tagged found_no_contact and is skipped by later skills. Partial data is better than no file — you can always add a contact manually later.

The Output: lead.md

Each qualifying lead gets a markdown file with structured YAML frontmatter:

---
company: "Bright Side Creative"
slug: "bright-side-creative"
contact_name: "Jane Smith"
contact_title: "Founder & CEO"
contact_email: "jane@brightsidecreative.com"
contact_email_type: "work"
contact_linkedin: "https://linkedin.com/in/janesmith"
company_website: "https://brightsidecreative.com"
category: "Marketing agency"
rating: 4.6
review_count: 142
score: 8
stage: "found"
source: "google_maps"
found_date: "2026-05-08"
contact_method_used: "website"
---

Why YAML frontmatter? Because Claude Code can parse it programmatically. When you say "enrich all found leads," the system reads every lead.md file, checks the stage field, and only processes leads at found. The frontmatter is the state machine.

Phase 3: Skill 2 — Lead Enricher

This is where the pipeline goes from "we know who they are" to "we know them well enough to write an email they''ll actually read." The enricher runs 8-9 tool calls per lead — deep enough to find real personalization hooks, lightweight enough to batch-process 10 leads without burning hours.

The 4-Page Website Deep Scan

Don''t just skim the homepage. The enricher scrapes four pages and extracts specific signals from each:

Page What to Extract Why It Matters Homepage Positioning, primary CTA, client logos, tech stack signals (tracking pixels, chat widgets, CMS), site quality First impression of their business maturity Services Full service list, depth of description, vertical specialization, pricing signals, delivery model Service breadth vs. team size is the #1 pain indicator About/Team Founding story, every team member listed (names + titles), org structure, culture language, hiring signals Team composition tells you where the bottleneck is Case Studies/Blog Named client projects, scale metrics, process visibility, blog cadence + recency, topic focus Reveals work quality AND capacity to market themselves

The killer insight: When you see a company listing 7 services on their services page but only 5 people on their team page, you''ve found a stretched operation. That''s not a guess — it''s observable data. Your cold email can reference it directly.

Contact Visibility Research (The Personal Layer)

This is the highest-value enrichment step. Two targeted web searches look for the contact person''s public presence:

Search 1: "Jane Smith" "Bright Side Creative" podcast OR interview OR webinar OR speaker

Search 2: "Jane Smith" "Bright Side Creative" article OR wrote OR published OR "linkedin post" OR blog

When someone has been on a podcast, written an article, or spoken at an event, they''ve given you public material to reference. An email that opens with "I caught your interview on the Agency Growth podcast — your point about client retention through systematized reporting is exactly the problem I help agencies solve" is in a completely different league than "I noticed your agency does digital marketing."

If nothing is found — that''s a signal too. This person is heads-down running their business, not building a personal brand. Your outreach should be direct and operational, not referencing thought leadership.

The Synthesis Layer

Raw data isn''t useful for writing emails. The enricher synthesizes everything into structured insights:

Pain Hypothesis — built from multiple converging signals, not just one data point. A "high confidence" pain hypothesis might read: "Bright Side Creative offers 7 services (SEO, PPC, social, content, web design, branding, email marketing) with a team of 5 visible on their team page. Their blog hasn''t been updated in 9 months despite offering content as a service. Their Instagram last posted 6 weeks ago. This is a classic capacity-constrained operation — the team is too stretched delivering client work to maintain their own marketing."

5 Categorized Personalization Hooks:

Company hook — something about their business

Personal hook — something about the contact person

Timing hook — something recent that makes now the right moment

Pain hook — something that reveals a problem

Peer hook — something that creates common ground

3-4 Automation Opportunities — not "use AI for marketing" but specific workflows: "Automate monthly client performance reports by pulling data from Google Ads and Analytics into a templated report. Current likely process: account manager manually screenshots dashboards and builds a deck. Automated: n8n workflow pulls data via API, Claude generates narrative analysis, outputs branded PDF. Impact: saves 3-4 hours per client per month."

Why This Matters: The email writer consumes these synthesis sections directly. The hooks become email openers. The pain hypothesis becomes the bridge. The automation opportunities become the value proposition. Garbage enrichment = garbage emails.

Phase 4: Skill 3 — Cold Email Writer

The email writer reads lead.md + enrichment.md for each enriched lead and produces a 4-email sequence: one cold opener plus three follow-ups.

The Email Framework

Every email follows a structure, but the structure should be invisible — it reads like a natural, short message, not a template with blanks filled in.

Email 1: Cold Opener (80-120 words)

Subject line — under 6 words, references their business specifically

Opening line — personalization hook proving you looked at their business

Pain bridge — connects the observation to a problem they likely have

Credibility micro-proof — one sentence, not a resume dump

Soft CTA — "Worth a quick conversation?" not "Book a 30-minute call"

Email 2: Follow-Up #1 (60-90 words, Day 3)

No "I emailed you a few days ago"

Different angle from Email 1 — new hook, new problem surface

Offers something concrete (insight, resource, observation)

Email 3: Follow-Up #2 (30-60 words, Day 8)

Pattern interrupt — different format, shorter, changes the energy

Could be a quick question, a peer share, or a specific observation

Forces a reply by being conversational, not pitchy

Email 4: Breakup (40-70 words, Day 15)

Acknowledges the silence without guilt-tripping

Restates core value in one sentence

Leaves the door open cleanly

Key technical decision: All follow-ups use Re: <Email 1 subject> — this threads the conversation in Gmail and dramatically increases open rates because it looks like a conversation, not a new pitch.

Voice Rules Encoded in the Skill

The skill hardcodes specific voice rules so every email sounds consistent:

No "I hope this finds you well" — ever

No exclamation marks except in the rarest cases

No flattery — zero instances of "I love what you''re doing"

No "leveraging synergies" or any consultant-speak

No pricing mentioned anywhere in the sequence

YouTube link included in at least one email as credibility, not a hard sell

Peer-to-peer tone — talking to a fellow operator, not pitching down

Quality Checklist

Before finalizing, the skill verifies every sequence against a checklist:

Email 1 subject under 6 words and references their specific business

Opening line references something specific to THIS company

Each email uses a DIFFERENT angle — no repetition

Email 3 is a pattern interrupt — different format

Email 4 is dignified — no guilt, no fake urgency

One CTA per email, no more

Word counts within range for each email

If you skip this: Your emails sound like every other AI-generated cold email. The checklist is what prevents "I noticed your company does great work in the digital marketing space" from making it into production.

Phase 5: Skill 4 — Outreach Manager

This is the operational layer — it handles sending, reply detection, follow-up scheduling, and pipeline reporting.

The Daily Cycle

Every day, the outreach manager runs three phases in order:

Phase 1: Reply Detection (runs FIRST — before any sending)

Searches Gmail for replies from all active leads. Why first? Because you don''t want to send a follow-up to someone who replied yesterday.

Each reply gets classified:

Type Detection Pattern Action Real reply Doesn''t match auto-reply or bounce patterns Stop sequence, flag for response Auto-reply / OOO "out of office", "automatic reply", "on vacation", "will return" Note it, continue sequence on original schedule Bounce "delivery failed", "undeliverable", "mailbox not found", from mailer-daemon Stop sequence, flag bad email

Phase 2: Create Drafts

For leads at email_drafted (need first send) and leads where follow-ups are due based on the schedule, the skill creates Gmail drafts. Not sent emails — drafts. You review them in your Drafts folder and hit send.

Follow-ups use replyToMessageId to thread properly in Gmail when the thread ID is available from previous sends.

Daily send cap: 15 drafts/day (configurable). Start at 5-8 for the first two weeks to protect your Gmail deliverability.

Phase 3: Daily Briefing

After both phases complete, you get a structured report: replies detected (with one-sentence summaries), drafts created, upcoming follow-ups for the next 3 days, full pipeline summary, and action items.

The mark-sent Flow

After you review and send drafts from Gmail, tell Claude Code "I sent the drafts" or "mark as sent." This updates all the frontmatter so the system knows Email 1 was sent today and Email 2 is due in 3 days.

Why This Matters: The draft-first approach is a safety mechanism. You never accidentally blast 20 cold emails that haven''t been reviewed. Once you trust the email quality (usually after 2-3 batches), the review step takes 5 minutes instead of an hour.

Phase 6: The Index — Your Pipeline State Machine

The index.md file is the brain of the entire system. Every skill reads it before doing anything and updates it after finishing.

---
title: Outreach Pipeline Index
last_updated: 2026-05-08
summary:
  total: 24
  found: 8
  found_no_contact: 2
  enriched: 6
  email_drafted: 5
  email_1_sent: 3
  replied: 0
  bounced: 0
  booked: 0
  disqualified: 0
  no_response: 0
leads:
  - slug: bright-side-creative
    company: Bright Side Creative
    contact: Jane Smith
    stage: email_1_sent
    score: 8
    location: Chicago
    updated: 2026-05-08
---

Deduplication: Before creating any new lead, the system normalizes the company name (lowercase, strips "LLC", "Inc", etc.) and checks against all existing entries. Same website domain = same company, even with different names. Duplicates are silently skipped.

Stage lifecycle: Every lead progresses through stages. The system only processes leads at the appropriate stage — found leads get enriched, enriched leads get emails written, email_drafted leads get sent. You can''t accidentally skip a step.

Why This Matters: The index is what makes the pipeline idempotent. If Claude Code crashes mid-run, you pick up exactly where it left off. If you add 20 new leads to an existing pipeline with 30 leads, the system processes only the new ones. No state confusion, no double-sends, no lost leads.

Business Applications & ROI

For Agency Owners Doing Their Own Outreach

The most direct application. If you''re personally spending 15-20 hours/week prospecting, this pipeline gives you those hours back. At a $150/hour opportunity cost, that''s $9,000-$12,000/month in recovered capacity.

For Consultants Building Their Practice

Solo consultants and small consulting firms live or die on pipeline. This system runs continuously in the background — you find 20 new leads every Monday, enrich Tuesday, write Wednesday, send Thursday. By month two, you have 80+ leads in various stages of the sequence.

For Service Businesses Scaling Outbound

If you''ve been growing purely through referrals and want to add outbound as a channel, this pipeline gives you the infrastructure without hiring an SDR. One person managing this system can produce the same output as a junior SDR at a fraction of the cost.

ROI Calculation

Traditional Outbound (Monthly):

Junior SDR salary: $4,000-$5,000/month

Sales tools (Apollo, Outreach, LinkedIn Sales Nav): $300-$500/month

Training and management time: 5-10 hours/month × $150/hr = $750-$1,500/month

TOTAL: $5,050-$7,000/month

AI Pipeline (Monthly):

Apify credits: ~$30-$50/month (at 100-200 leads/month)

Firecrawl credits: ~$20-$40/month

Claude Code: $20/month (Pro plan)

Your time: 30 min/day × 22 business days = 11 hours × $150/hr = $1,650/month

TOTAL: $1,720-$1,760/month

Monthly Savings: $3,300-$5,240 (65-75% reduction) Annual ROI: $39,600-$62,880

And unlike an SDR, the system doesn''t call in sick, doesn''t need onboarding, and improves every time you refine the skills.

Advanced Extensions

Customizing the ICP

The lead-finder defaults to Shabbir''s ICP (marketing agencies, 2-50 people, US major markets). To target a different vertical, modify the inputs when you trigger the skill:

"Find 20 real estate brokerages in Dallas and Houston with 10-100 reviews"

The scoring rubric adapts to whatever business type you specify. The enricher and email writer work the same regardless of vertical — they read whatever the finder produces.

Adding New Outreach Channels

The emails.md frontmatter tracks per-email status. You could extend this to track LinkedIn InMails, direct messages, or even phone calls by adding new status fields. The index stage lifecycle would expand to accommodate multi-channel sequences.

Integrating with a CRM

The YAML frontmatter in index.md is structured data. A simple script could sync it to HubSpot, Pipedrive, or Airtable by reading the YAML and pushing via API. The folder structure maps cleanly: one lead = one CRM contact.

Warming Up a New Sending Domain

If you''re worried about Gmail deliverability, set up a secondary domain (e.g., outreach.yourdomain.com) with Google Workspace. Start the daily cap at 3-5 emails/day for the first two weeks, then ramp to 10, then 15. The outreach manager''s configurable send cap makes this easy.

Troubleshooting & Common Issues

Technical Challenges

Firecrawl Can''t Scrape a Website

Problem: Some sites block scrapers, return empty content, or use heavy JavaScript rendering that Firecrawl can''t handle. Solution: The enricher automatically tries multiple URL variants (e.g., /services → /what-we-do → /our-services). If all fail, it falls back to web search for cached/indexed versions of the page. Prevention: This is expected for ~10-15% of sites. The skill creates the enrichment file anyway with partial data rather than failing entirely.

LinkedIn Profile Scraper Returns No Email

Problem: Not all LinkedIn profiles have discoverable emails. The dev_fusion/linkedin-profile-scraper finds emails for roughly 60-70% of profiles. Solution: The lead-finder falls through to Method 6 (website contact page) to find or construct a work email. If only a generic email is found, it''s tagged contact_email_type: "generic" so the email writer knows to adjust. Prevention: This is a numbers game. Run larger batches (30 leads) knowing that 20-25 will have usable emails.

Gmail Drafts Not Threading Properly

Problem: Follow-up emails appear as new conversations instead of threading under the original email. Solution: The outreach manager uses replyToMessageId to thread when a previous message ID is available. If the first email was sent manually (not through the system), the thread ID won''t be stored. Use mark-sent after sending to capture the thread ID for future follow-ups. Prevention: Always use the mark-sent action after sending drafts so the system captures Gmail''s thread and message IDs.

Apify Rate Limits

Problem: Running too many LinkedIn scrapes in a short period can trigger rate limits. Solution: The lead-finder and enricher both handle rate limit errors gracefully — they log the error, skip the affected lead, and continue processing. Run the affected leads again later. Prevention: Process leads in batches of 10-15 rather than 50 at once. Space batch runs at least 30 minutes apart.

Assignment: Build Your Outreach Pipeline

Phase 1: Basic Implementation (Week 1)

Set up your .mcp.json — configure Apify, Firecrawl, and Gmail MCP connections. Verify all three are connected with /mcp.

Install the 4 skill files into your Claude Code project''s skills directory.

Run your first lead-finder — "Find 10 [your target business type] in [your city]." Review the lead.md files created. Check that contact names and emails were found.

Demo: Show 5 lead.md files with valid contact information and scores ≥ 6.

Phase 2: Full Pipeline Run (Week 2)

Enrich your 10 leads — "Enrich all found leads." Review the enrichment.md files. Check that pain hypotheses are specific and personalization hooks reference real, observable data.

Write emails — "Write emails for all enriched leads." Review every emails.md file. Check that Email 1 could NOT be sent to a different company without rewriting (the personalization test).

Customize the voice rules — modify the cold-email-writer skill to match YOUR voice, not the default. Adjust tone, CTA style, and credibility proof points.

Demo: Show 3 complete lead folders (lead.md + enrichment.md + emails.md) and explain why the email is personalized for that specific lead.

Phase 3: Live Outreach (Week 3)

Run the daily outreach cycle — "Run the daily outreach." Review drafts in Gmail. Send them.

Mark as sent — "I sent the drafts." Verify the pipeline state updated correctly.

Run reply detection — next day, run "Any replies?" See the classification in action.

Run a full second batch — find 15 more leads, enrich, write, and send. Test deduplication by including the same city as your first batch.

Demo: Show the daily briefing report, a correctly threaded follow-up in Gmail, and your index.md with leads at multiple stages.

Success Metrics

Technical: All 4 skills run without errors, index.md stays in sync, deduplication works

Performance: 70%+ of leads have work emails found, enrichment produces high-confidence pain hypotheses for 60%+ of leads

Business Value: Pipeline produces 15+ qualified, personalized outreach sequences per week with under 30 minutes/day of operator time

Resources & Templates

Complete System Package

4 SKILL.md files — lead-finder, lead-enricher, cold-email-writer, outreach-manager

.mcp.json template — pre-configured for Apify, Firecrawl, and Gmail

README.md — full pipeline documentation with commands, stages, and architecture

Index template — starter index.md with correct YAML structure

Customization Points

ICP defaults — modify the lead-finder''s default business types, locations, and scoring rubric for your market

Voice rules — modify the cold-email-writer''s voice section to match your communication style

Follow-up timing — adjust the Day 3/8/15 schedule in both the email writer and outreach manager

Daily send cap — start at 5-8, ramp to 15 as you build sending reputation

Key Takeaways

Technical Mastery: ✅ Built a 4-skill Claude Code pipeline where each skill reads the previous skill''s output — chained AI agents operating on a shared file system ✅ Used YAML frontmatter as a state machine — every file tracks its own stage, the index aggregates pipeline status, and deduplication prevents conflicts ✅ Connected three external MCP services (Apify, Firecrawl, Gmail) to give Claude Code real-world reach beyond text generation

Business Transformation: ✅ 15-20 hours/week of manual prospecting → 30 minutes/day of pipeline management ✅ 65-75% cost reduction compared to hiring an SDR or using traditional sales tools ✅ Higher email quality than manual outreach — the AI reads the prospect''s entire web presence before writing a word, producing personalization that most humans don''t have the patience to do at scale

Strategic Positioning: ✅ This system is itself a proof of concept for what you sell — if you''re offering AI automation to clients, running your own outreach on an AI pipeline is the ultimate credibility signal ✅ The pipeline is extensible — same architecture works for client research, competitor analysis, hiring outreach, or partnership prospecting ✅ The skills are modular — each one can be improved independently without breaking the pipeline

You just built a system that does what an SDR team does — find prospects, research them, write personalized emails, and manage follow-ups — with four markdown files and three API keys. The architecture is simple. The execution is thorough. And it runs with natural language commands.', 11),
  ('ed2ba192-c2a7-499c-b79b-89365cd84072', '88f4c273-96dd-4197-adb3-12d0f241322f', 'Remotion YouTube Shorts Creator', '', 12),
  ('8fec73c7-5d1e-44fc-aa36-e5c8ded5a6d8', 'fa98a20e-edd0-4a5e-8c23-5579f0693e67', 'Whatsapp RAG Agent', '', 1),
  ('cdd5ec91-6c09-4a54-9142-a92066448ab3', 'ef505006-a535-43ff-9155-8a1dd0c5cc9c', 'AI Agent Mastery: Simple Flows to Agentic AI', 'Master the complete spectrum of AI automation by building three progressively sophisticated systems: a simple expense tracker, an intelligent research assistant, and a fully autonomous content creation factory that coordinates multiple AI agents to produce complete marketing campaigns.

Time to Complete: 90 minutesDifficulty: AdvancedTools Required: N8N, Google Workspace, OpenAI, Perplexity, Tavily, Replicate Business Value: $15,000+ in content creation savings annually

Understanding the AI Agent Hierarchy

Level 1: Generative AI (The Smart Brain)

Capability: Answers questions from existing knowledge

Limitation: Cannot take actions or access current information

Example: ChatGPT without plugins

Business Use: Customer service responses, content editing

Level 2: AI Agents (Brain + Tools)

Capability: Thinks AND acts using specific tools

Strength: Executes narrow, specific tasks reliably

Example: Expense tracker that reads/writes to spreadsheets

Business Use: Data entry, simple workflows, task automation

Level 3: Agentic AI (Multiple Coordinated Brains)

Capability: Multiple agents planning, coordinating, and executing complex goals

Strength: Handles sophisticated, multi-step business processes

Example: Content factory creating blog posts, social media, and images

Business Use: Complete marketing campaigns, research projects, complex analysis

Level 1: AI Agent with Tools - Expense Tracker

Architecture Overview

User Input → AI Agent → Google Sheets Tools → Response
              ↓
          Memory Store
Build Process

Step 1: Foundation Setup

Chat Trigger - Enables conversational interface

AI Agent - Central processing unit

OpenAI Chat Model - GPT-4.1-mini (fast, cost-effective)

Memory - Maintains conversation context

Step 2: Google Sheets Integration

Tool 1: Add Expense

Node: Google Sheets → Append Row

Document: "Expense Tracker"

Columns: Date, Amount, Category, Notes

Parameters: Let model define all values

Description: "Add expense to tracker"

Tool 2: Retrieve Expenses

Node: Google Sheets → Get Rows

Same document and sheet

Filters: Model-defined (enables specific queries)

Description: "Retrieve expenses from tracker"

Step 3: System Prompt Design

You are an expense tracking assistant. Your job is to help me log and retrieve expenses using two available tools.

TODAY''S DATE: {{new Date().toLocaleDateString()}}

EXPENSE CATEGORIES: 
- Groceries, Eating Out, Transport, Health, Personal, Entertainment, Shopping

LOGGING FORMAT:
When user says "I spent $20 on coffee", log as:
- Amount: 20
- Category: Eating Out  
- Notes: coffee
- Date: Today''s date

RETRIEVAL QUERIES:
Answer questions like "What did I spend on groceries?" or "What was my biggest expense?"

GUARDRAILS:
Only handle expense-related queries. For other topics, politely redirect to expense tracking.
Testing Your Level 1 Agent

Input: "I spent $30 on gas yesterday"

Expected: Logs to spreadsheet with proper categorization

Verification: Check Google Sheets for new row

Query Test: "What have I spent on transport?"

Level 2: Multi-Step AI Agent - Research Assistant

Architecture Overview

User Query → AI Agent → Multiple Research Tools → Analysis → Gmail Draft
               ↓              ↓
         Extended Memory → User Selection → Follow-up Action
Build Process

Step 1: Enhanced Foundation

Same base: Chat Trigger → AI Agent → OpenAI (GPT-4.1-mini)

Enhanced Memory: Context window = 10 (vs 5 for Level 1)

Reasoning: Multi-step processes require more context retention

Step 2: Research Tool Integration

Tool 1: Wikipedia Search

Built-in tool - No API key required

Use case: Foundational information, definitions

Advantage: Reliable, structured data

Tool 2: Perplexity AI

Model: Sonar (cost-effective) or Sonar-Deep (comprehensive)
Authentication: API key from perplexity.ai
Message: Model-defined parameter
Use case: Current events, detailed research
Tool 3: Tavily Search

URL: https://api.tavily.com/search
Method: POST
Authentication: Bearer token
Body: {
  "query": "{{$fromAI(''query'')}}",
  "search_depth": "basic",
  "include_answer": true,
  "max_results": 5
}
Use case: Web search with structured results
Tool 4: Gmail Draft Creation

Resource: Draft
Operation: Create
Subject: Model-defined
Message: Model-defined  
Use case: Save research outputs for later use
Step 3: Multi-Step System Prompt

You are a research assistant specializing in thorough, cited analysis.

RESEARCH PROCESS:
1. For every query, use ALL THREE research tools:
   - Wikipedia for foundational knowledge
   - Perplexity for current information  
   - Tavily for comprehensive web search

2. Present organized research summary with sources

3. Wait for user to specify focus area

4. Create detailed response on chosen topic using Gmail tool

RESEARCH STANDARDS:
- Always provide source citations
- Organize information logically
- Highlight key insights and contradictions
- Suggest follow-up questions

EXAMPLE FLOW:
User: "AI agents in retail"
→ Research all three sources
→ Present summary with source categories
→ User: "Focus on inventory management"
→ Create detailed Gmail draft on that subtopic
Advanced Features

Source aggregation: Combines insights from multiple tools

User interaction: Waits for direction before final output

Output persistence: Saves results in Gmail drafts

Context awareness: References previous research in follow-ups

Level 3: Agentic AI - Content Creation Factory

Architecture Overview

Topic Input → Main Orchestrator → Multiple Specialist Agents → Coordinated Output
                    ↓
              Google Docs Creation
                    ↓
         ┌─────────────┼─────────────┐
    Blog Agent    X Agent    LinkedIn Agent
         ↓            ↓            ↓
    Image Gen    Image Gen    Image Gen
         ↓            ↓            ↓
    Final Google Doc with Complete Campaign
The Multi-Agent System

Main Orchestrator Agent

Role: Project manager coordinating all sub-agents Model: GPT-5 or GPT-4.1 (needs strong reasoning) Memory: Extended (10+ context window)

Tools Available:

Google Docs Create - Initialize output document

Google Docs Update - Add content throughout process

Blog Post Agent - Delegate blog creation

X Post Agent - Delegate Twitter content

LinkedIn Agent - Delegate LinkedIn content

Image Generation - Create visuals for each platform

Image Status Check - Monitor generation progress

Specialist Sub-Agents

Blog Post Agent:

Role: Research and write comprehensive blog posts
Model: GPT-4.1 (needs quality output)
Memory: Extended (for multi-section coordination)

Tools:
- Perplexity (topic research)
- Tavily (current information)  
- Writer Agent (section-by-section content creation)

Process:
1. Generate title and H2/H3 outline (max 1000 words)
2. Research each section using both tools
3. Use Writer Agent for each section
4. Compile complete post with sources
Writer Sub-Agent (Third Level):

Role: Write individual blog sections
Model: GPT-4o-nano (cost-effective for focused tasks)
System Prompt: "Expert at writing blog content. 8th grade reading level. Include provided sources and links."
X Post Agent:

Role: Create engaging Twitter content
Model: GPT-4o-nano (sufficient for short-form content)
System Prompt: "Expert at punchy, attention-grabbing, scroll-stopping Twitter posts. Use thread format if needed."
LinkedIn Post Agent:

Role: Professional LinkedIn content
Model: GPT-4o-nano
System Prompt: "Professional LinkedIn content specialist. Focus on business insights, industry trends, and actionable advice."
Image Generation Integration

Replicate + Flux Schnell Setup

Cost: $3 per 1000 images (extremely cost-effective)
Model: Flux Schnell (fast, high-quality)
API: HTTP POST to replicate.com

Request Body:
{
  "version": "ENTER VERSION HERE",
  "input": {
    "prompt": "{{$fromAI(''prompt'')}}",
    "num_outputs": 1,
    "aspect_ratio": "1:1"
  }
}

Status Check: GET request to returned URL
Master System Prompt (Orchestrator)

You are a content creation factory manager. Given a topic, create a complete marketing campaign:

WORKFLOW:
1. Create Google Doc with topic as title
2. Generate blog post image → Update doc with image URL
3. Call Blog Post Agent → Update doc with complete post
4. Generate X post image → Update doc with image URL  
5. Call X Post Agent → Update doc with post content
6. Generate LinkedIn image → Update doc with image URL
7. Call LinkedIn Agent → Update doc with post content
8. Return ONLY the Google Docs URL

QUALITY STANDARDS:
- All content must be well-researched and cited
- Images must be relevant and professional
- Each platform''s content should match its audience
- Final doc should be publication-ready

CRITICAL: Your only output is the completed Google Docs URL. No intermediate responses.
Advanced Coordination Features

Error Handling

Image generation failures: Retry with simplified prompts

Research tool timeouts: Fall back to alternative sources

Sub-agent errors: Regenerate with clearer instructions

Quality Control

Content validation: Each agent validates output before submission

Source verification: Cross-reference information across tools

Format consistency: Standardized output templates

Scalability Features

Batch processing: Handle multiple topics simultaneously

Template customization: Industry-specific content frameworks

Performance monitoring: Track completion times and error rates

Business Applications & ROI

Level 1 Applications

Expense tracking: Save 5+ hours/month on bookkeeping

Inventory management: Automated stock level monitoring

Customer inquiry logging: Structured support ticket creation

Level 2 Applications

Market research: Comprehensive competitor analysis

Due diligence: Investment research compilation

Content research: Background for high-quality articles

Level 3 Applications

Content marketing: Complete campaign creation

Product launches: Multi-platform announcement coordination

Thought leadership: Regular industry insight publication

ROI Calculation

Traditional Content Creation (Monthly):
- Blog posts (4): $200 (writer) + $200 (images) = $400
- Social media (16 posts): $400 (creator) = $400
- Research time: 20 hours × $50/hour = $1,000
TOTAL: $2,400/month = $28,800/year

AI Content Factory:
- Setup time: 8 hours × $100/hour = $800 (one-time)
- API costs: ~$50/month = $600/year
- Maintenance: 2 hours/month × $100/hour = $2,400/year
TOTAL: $3,800/year

SAVINGS: $25,000/year (87% reduction)

Implementation Strategy

Week 1: Level 1 Mastery

Build and test expense tracker

Understand tool integration patterns

Master system prompt engineering

Week 2: Level 2 Implementation

Add research capabilities

Practice multi-step workflows

Optimize for reliability

Week 3: Level 3 Architecture

Design agent coordination

Implement sub-agent communication

Test end-to-end workflows

Week 4: Production Deployment

Error handling implementation

Performance optimization

Business process integration

Advanced Concepts

Agent Communication Patterns

Hierarchical: Main agent delegates to specialists

Peer-to-peer: Agents collaborate directly

Pipeline: Sequential processing chain

Hub-and-spoke: Central coordinator with specialized agents

Prompt Engineering for Agents

Role clarity: Each agent has specific responsibilities

Communication protocols: Standardized input/output formats

Error recovery: Instructions for handling failures

Quality gates: Validation checkpoints

Scaling Considerations

Resource management: API rate limits and costs

Parallel processing: Concurrent agent execution

State management: Tracking complex workflows

Monitoring: Performance and error tracking

Troubleshooting Guide

Common Issues

Level 1 Problems:

Google Sheets authentication failures

Incorrect categorization by AI

Memory context loss

Level 2 Problems:

API rate limits with research tools

Inconsistent source formatting

Gmail draft creation errors

Level 3 Problems:

Agent coordination failures

Image generation timeouts

Google Docs update conflicts

Solutions Framework

Identify failure point: Which agent/tool failed?

Check logs: N8N execution history

Validate inputs: Ensure proper data flow

Adjust prompts: Clarify instructions

Add error handling: Graceful failure recovery

Assignment: Build Your Agent System

Basic Challenge

Build all three levels and demonstrate:

Level 1: Track 10 different expenses

Level 2: Research and draft email on industry topic

Level 3: Create complete content campaign for your business

Advanced Challenge

Customize the Level 3 system for your industry:

Add industry-specific research sources

Create specialized content templates

Implement performance tracking

Business Application

Design an agentic AI system for a specific business problem:

What would the agent hierarchy look like?

Which tools would each agent need?

How would you measure success?

Resources & Next Steps

Advanced Learning

Agent orchestration patterns

Custom tool development

Enterprise scaling strategies

AI agent security considerations

Key Takeaways

Technical Mastery: 

✅ Understand the progression from tools to agents to agentic AI✅ Master multi-agent coordination patterns✅ Implement production-ready error handling✅ Design scalable agent architectures

Business Impact:✅ $25,000+ annual savings on content creation alone 

✅ 10x faster research and analysis capabilities

✅ Consistent quality across all outputs

 ✅ Scalable operations without linear cost increases

Strategic Advantage: 

✅ Position yourself at the forefront of AI automation 

✅ Offer services that traditional agencies cannot match

 ✅ Build systems that compound in value over time

 ✅ Create sustainable competitive advantages

This represents the future of business automation - not just saving time, but fundamentally transforming how work gets done through intelligent agent coordination.', 1),
  ('2aa1cd14-9e30-4172-ad4c-45f9f9e9f64f', 'ef505006-a535-43ff-9155-8a1dd0c5cc9c', 'Connect n8n to 500 tools with this MCP', '', 2),
  ('db4c128d-293f-430a-a94c-d2cb0e02e6fe', 'ef505006-a535-43ff-9155-8a1dd0c5cc9c', 'Testing n8n vs AgentKit', 'OpenAI Agent Kit vs n8n: The Complete Platform Comparison & Strategic Selection Guide

Lesson Overview

Understand the fundamental differences between OpenAI''s Agent Kit and n8n through four real-world agent builds. This comparative analysis reveals when to use each platform, their respective strengths and limitations, and how to make strategic technology choices for automation projects.

Time to Complete: 45 minutes (reading) + 90 minutes (hands-on building) 

Difficulty: Intermediate 

Tools Required: OpenAI Agent Kit, n8n, various API keys (OpenAI, Tavily, Supabase) 

Decision Framework: Choose the right platform for your specific use case

The Platform Selection Problem

The Hype vs Reality Challenge

New tool launches → "This kills X" headlines

Rushed migration decisions without analysis

Wasted time rebuilding in wrong platform

Client projects fail due to platform limitations

Result: Technical debt and disappointed stakeholders

Strategic Approach

Test identical use cases on both platforms

Measure setup time, complexity, capabilities

Identify architectural limitations

Match platform to problem domain

Result: Right tool for the right job

The Transformation: From reactive platform hopping to strategic technology selection based on objective comparison.

Test Framework Overview

Four Agent Archetypes

Test 1: Simple Chat Agent (Web Search)
    ↓
Test 2: RAG Agent (Document Knowledge Base)
    ↓
Test 3: Email Triage Agent (Event-Driven Automation)
    ↓
Test 4: Multi-Agent Orchestration (Blog Post Writer)

Evaluation Criteria

Setup Time: Minutes from zero to working agent

Complexity: Steps required, API keys needed

Output Quality: Response detail and accuracy

Flexibility: Customization and control options

Scalability: Production-ready capabilities

Test 1: Simple Chat Agent with Web Search

Agent Kit Implementation

Setup Steps:
1. Start trigger (pre-configured)
2. Add Agent node
3. Add system prompt
4. Enable "Include chat history"
5. Select model (default reasoning: low)
6. Add Web Search tool (click + icon)
7. Output format: Text

Setup Time: < 2 minutes
API Keys Required: 0 (uses OpenAI ecosystem)

System Prompt:

You are a helpful assistant that can search the web to answer questions 
accurately with current information.

Test Query: "Can you tell me about n8n?"

Output Characteristics:

Detailed answer with sources

Proper citations

Reasoning visible in UI

Instant setup, no configuration

n8n Implementation

Setup Steps:
1. Add Manual Chat Trigger
2. Add AI Agent node
3. Configure OpenAI Chat Model (add API key manually)
4. Add Window Buffer Memory
5. Configure session management
6. Add Wikipedia Tool (built-in)
7. Add Tavily Web Search Tool
8. Configure Tavily API key

Setup Time: ~8 minutes
API Keys Required: 2 (OpenAI + Tavily)

Test Query: "Tell me about OpenAI''s new Agent Kit"

Output Characteristics:

Searches Wikipedia + Tavily

Returns answer (less detailed than Agent Kit)

Requires manual tool orchestration

More setup complexity

Test 1 Winner: Agent Kit

Why Agent Kit Wins:

4x faster setup (2 min vs 8 min)

Zero external API configuration

More detailed responses

Better out-of-box experience

Business Impact: For internal team chat tools needing web search, Agent Kit''s speed-to-value is unmatched.

Test 2: RAG Agent (Retrieval-Augmented Generation)

Agent Kit Implementation

Setup Steps:
1. Start trigger
2. Add Agent node
3. Under Tools → Add Vector Store
4. Upload PDFs (drag and drop interface)
   - 3 Alex Hormozi books uploaded
5. Add system prompt referencing vector store

Setup Time: ~5 minutes
Storage: OpenAI-managed vector store (black box)

System Prompt:

You have access to a vector store containing all of Alex Hormozi''s books 
on marketing and sales. Retrieve information from the vector store and 
answer queries in Alex Hormozi''s voice.

Test Query: "I need help positioning my AI agency offer"

Output Characteristics:

Searches files automatically

Compiles information from multiple sources

Provides citations from all 3 books

Responds in requested voice/style

Black box chunking: No visibility into how documents are processed

n8n Implementation

Part 1: Vector Store Setup (One-time)
1. Set up Supabase database
2. Create vector store table
3. Configure pgvector extension
4. Build upload workflow:
   - Form trigger
   - PDF processing
   - Text chunking
   - Embedding generation
   - Supabase insert

Part 2: Retrieval Agent
1. Manual Chat Trigger
2. AI Agent node
3. OpenAI Chat Model
4. Window Buffer Memory
5. Vector Store Tool (connected to Supabase)
6. Embedding model configuration

Setup Time: ~30 minutes (including Supabase setup)
Storage: Self-managed Supabase (full transparency)

Test Query: "I need help positioning my AI agency offer"

Output Characteristics:

Queries vector store

Returns detailed answer with references

Slightly less detailed than Agent Kit

Full transparency: See exact chunking, embeddings, similarity scores

Test 2 Winner: Agent Kit (with caveats)

Why Agent Kit Wins:

6x faster setup (5 min vs 30 min)

No database management required

Automatic document processing

Better output quality

Why n8n Has Hidden Value:

Chunking control: Adjust chunk size, overlap, strategy

Debugging visibility: See exactly which chunks retrieved

Data ownership: Your database, your control

Custom retrieval logic: Implement hybrid search, re-ranking, filters

Strategic Decision:

Prototype/MVP: Agent Kit (speed to validation)

Production system: n8n (debugging, optimization, ownership)

Test 3: Email Triage Agent (Event-Driven Automation)

n8n Implementation

Workflow Architecture:
1. Gmail Trigger (on new email)
    ↓
2. AI Classifier Agent
   Categories: Invoice, Customer Service, Lead, Service Offer, 
               Notification, Other
    ↓
3. Switch Node (routes by category)
    ↓
4. Specialized Handler Agents:
   - Invoice → Log to database
   - Customer Service → Reply with template
   - Lead → Add to CRM + notify sales
   - Service Offer → Label + archive
   - Notification → Label only
   - Other → Human review queue

Setup Time: ~45 minutes
Trigger: Gmail (automatic, event-driven)

Key Features:

Runs automatically on email arrival

No manual intervention required

Multi-step conditional logic

Database logging + external actions

Autonomous operation: Works 24/7 without human trigger

Agent Kit Implementation

LIMITATION: Cannot build this workflow

Why:
- No Gmail trigger available
- No webhook triggers
- No schedule triggers
- Only trigger: Manual chat (Start node)

Workaround Attempt:
- Set up MCP server with Gmail access
- Chat with agent to interact with inbox
- Agent can read emails, take actions via chat
- BUT: Cannot automate responses to new emails

Result: 
Manual chat interface to Gmail, not autonomous automation

What You Can Do in Agent Kit:

User: "Check my inbox and categorize my emails"
Agent: [Searches Gmail via MCP, categorizes, reports back]

User: "Reply to the customer service emails"  
Agent: [Drafts replies, asks for approval, sends]

What You CANNOT Do:

Automatic processing on email arrival

Unattended operation (agent waits for your command)

Scheduled checks every 30 minutes

Event-driven workflows

Test 3 Winner: n8n (Decisive)

Why n8n Wins:

Agent Kit cannot solve this use case at all

Autonomous vs manual operation is fundamental difference

Event-driven automation is n8n''s core strength

Business Impact:

n8n: "Email arrives → automatically processed → action taken"
Agent Kit: "You ask agent → agent checks email → you approve action"

For business automation, first model = revenue
Second model = interactive assistant (still manual)

Critical Insight: This test reveals the core architectural difference between platforms.

Test 4: Multi-Agent Orchestration System

n8n Implementation: Blog Post Writer

Architecture:
Main Agent (Orchestrator)
    ├─→ Agent 1: Title & Structure Generator
    ├─→ Agent 2: Research Agent (per section)
    ├─→ Agent 3: Writing Agent (per section)
    └─→ Agent 4: Image Generator

Workflow:
1. User: "Write blog post about history of espresso"
2. Orchestrator → Title Agent
   Output: Title + H2/H3 outline
3. User approves outline
4. Orchestrator → Research Agent (Section 1)
5. Orchestrator → Writing Agent (Section 1)
6. Orchestrator → Research Agent (Section 2)
7. Orchestrator → Writing Agent (Section 2)
   [Repeat for all sections]
8. Orchestrator → Image Generator
9. Orchestrator assembles final post (HTML formatted)

Setup Time: ~60 minutes
Agents: 5 (1 orchestrator + 4 specialists)

Specialist Agent Prompts:

Title & Structure Agent:

You are an SEO expert and content strategist. Given a topic, create:
1. Compelling blog post title
2. Detailed outline with H2 and H3 headings
3. Strategic keyword placement
Output as JSON: {title, sections: [{h2, h3s[]}]}

Research Agent:

You are a research specialist. For the given section:
1. Search for authoritative sources
2. Extract key facts, statistics, quotes
3. Verify information accuracy
Output: Research notes with citations

Writing Agent:

You are a professional writer. Given research notes:
1. Write engaging, informative content
2. Match specified tone and style
3. Include proper citations
4. Optimize readability (Flesch score 60+)
Output: Publication-ready section

Key Architecture Features:

Parallel execution: Research + Writing happen simultaneously for different sections

Specialized instructions: Each agent has focused, detailed prompt

Memory sharing: Orchestrator maintains context across all agents

Autonomous decision-making: Orchestrator decides which agent to call when

Agent Kit Implementation

Architecture:
Linear Chain:
Agent 1 → Tool → Agent 2 → Tool → Agent 3 → Output

Available Tools:
- Web Search
- MCP Servers
- File Search
- Vector Stores
- Custom Functions

Limitation:
Cannot create true multi-agent orchestration where agents 
operate autonomously. All execution is linear.

Workaround:
Single powerful agent with multiple tools:
1. Agent uses Web Search tool (research)
2. Agent uses Custom Function (structure)
3. Agent uses File Search (references)
4. Agent generates final output

Result:
Works, but all logic in one agent prompt

Test Query: "Write blog post about history of espresso"

Output:

Researched topic

Well-written blog post

Covered similar points to n8n version

BUT: Single agent did everything

Difference in Practice:

Simple blog post: Both platforms produce similar quality

Complex requirements:

n8n:
- Research Agent gets 500-token prompt with research guidelines
- Writing Agent gets 1000-token prompt with style guide, frameworks
- SEO Agent gets 300-token prompt with optimization rules
Total: Specialized, focused agents

Agent Kit:
- Single agent gets 1800-token prompt with all instructions
- Agent must context-switch between research/writing/SEO modes
- Higher chance of instruction bleed or confusion

Test 4 Winner: n8n

Why n8n Wins:

True multi-agent orchestration: Agents work autonomously

Separation of concerns: Each agent has single responsibility

Scalability: Add more specialist agents without overwhelming prompts

Debugging: See exactly which agent did what

Parallel execution: Multiple agents work simultaneously

When Agent Kit''s Approach Works:

Simple, straightforward tasks

Single-domain problems

Prototyping ideas quickly

When n8n''s Approach Necessary:

Complex, multi-step processes

Different expertise areas (research vs writing vs SEO)

Need to maintain multiple specialized contexts

Production systems requiring clarity and maintainability

Final Score & Strategic Implications

Test Results Summary

Test 1: Simple Chat Agent → Agent Kit wins
Test 2: RAG Agent → Agent Kit wins (setup speed)
Test 3: Email Triage → n8n wins (Agent Kit can''t do it)
Test 4: Multi-Agent Orchestration → n8n wins

Score: 2-2 Tie

But this misses the point entirely.

Strategic Selection Framework

Use OpenAI Agent Kit When:

1. Building Internal Team Tools

Use Case: "Sales team needs to query company knowledge base"
Why Agent Kit: 
- Team already uses ChatGPT
- Familiar chat interface
- 5-minute setup
- No IT involvement needed

2. Conversational Assistants

Use Case: "Customer support agent to answer product questions"
Why Agent Kit:
- Natural chat interaction
- Built-in memory
- Easy vector store integration
- Quick iterations on system prompt

3. Quick Prototypes

Use Case: "Test if RAG approach works for our use case"
Why Agent Kit:
- Validate idea in 10 minutes
- No infrastructure setup
- Easy to demo to stakeholders
- Migrate to n8n if proof succeeds

4. All-in on OpenAI Ecosystem

Use Case: "Company standardized on OpenAI products"
Why Agent Kit:
- Single billing
- Unified admin
- No vendor sprawl
- Enterprise support

Agent Kit Sweet Spot: 80% of simple, chat-based use cases where humans manually trigger agents.

Use n8n When:

1. Event-Driven Automation

Use Case: "Process form submissions, triage support tickets"
Why n8n:
- Gmail/Webhook/Schedule triggers
- Runs without human intervention
- Production-grade error handling
- Works 24/7 autonomously

2. Multi-Model Strategy

Use Case: "Use GPT-4 for complex reasoning, Claude for writing"
Why n8n:
- Model-agnostic architecture
- Cost optimization (use cheaper models where possible)
- Avoid vendor lock-in
- A/B test different models

3. Complex Multi-Agent Systems

Use Case: "Content pipeline with research, writing, SEO, image gen"
Why n8n:
- Specialist agent teams
- Orchestration logic visible
- Parallel execution
- Easier debugging

4. Client Production Systems

Use Case: "White-label automation for agency clients"
Why n8n:
- Full visibility into execution
- Custom error handling
- Detailed logging
- Client-specific customization

5. Data Transparency Requirements

Use Case: "Need to audit how AI makes decisions"
Why n8n:
- See exact vector store chunks retrieved
- Logs of every API call
- Custom metrics and monitoring
- Data sovereignty (your database)

n8n Sweet Spot: Production automation that runs unattended, complex multi-agent workflows, client deliverables.

The Real Comparison

Agent Kit = Intern Chat Assistant

Capabilities:
- Always available when you message
- Answers questions
- Searches information
- Helps with tasks you assign

Limitations:
- Needs you to ask it to do things
- Can''t work independently
- No scheduled tasks
- Single-conversation context

Perfect for: Internal knowledge bases, support assistants, team chat helpers

n8n = Automation Team

Capabilities:
- Works while you sleep
- Triggered by events (email arrives, form submitted, schedule hits)
- Multi-step, multi-agent workflows
- Integrates with 400+ services
- Production-grade error handling

Limitations:
- Higher setup complexity
- Requires API key management
- Steeper learning curve

Perfect for: Business process automation, client systems, autonomous agents

Migration Decision Framework

Stay on Agent Kit If:

✅ Team members trigger workflows via chat 

✅ Building internal tools only 

✅ Setup speed more important than flexibility 

✅ Already fully OpenAI ecosystem 

✅ Use cases remain conversational

Migrate to n8n If:

✅ Need event-driven triggers (email, webhook, schedule)

✅ Building automation for clients 

✅ Require multi-model flexibility 

✅ Complex multi-agent orchestration needed 

✅ Production visibility and debugging critical

Use BOTH Strategically:

Agent Kit: Rapid prototyping + internal team tools
n8n: Production automation + client deliverables

Example Workflow:
1. Build concept in Agent Kit (10 minutes)
2. Validate with stakeholders
3. Rebuild in n8n for production (90 minutes)
4. Deploy with proper monitoring and error handling

Business Applications & ROI

Agency Model: Hybrid Approach

Discovery Phase (Agent Kit):

Client: "Can AI help with our email support?"

You: Build Agent Kit prototype in 15 minutes during sales call

Client sees it working live

Close deal on the spot

Delivery Phase (n8n):

Build production system in n8n

Event-driven (tickets auto-processed)

Custom error handling

Detailed reporting

Charge $3,000-5,000 for delivered automation

ROI: Agent Kit closes deals, n8n delivers value.

SaaS Product Strategy

Don''t choose—use both:

User-facing: Agent Kit for customer chat interface

Backend: n8n for automation workflows

Example: AI Content Platform

Customer Experience (Agent Kit):
"Generate blog post about [topic]" → chat interface

Behind the Scenes (n8n):
1. Request logged to database
2. Multi-agent orchestration creates post
3. SEO optimization agent runs
4. Image generation agent creates featured image
5. Deliverable saved to customer''s workspace
6. Email notification sent

Best of both worlds: Simple UX + powerful backend.

Consulting Positioning

Agent Kit Skills:

"AI integration consultant"

Quick wins for enterprise teams

Internal tool specialist

$2,000-5,000 per implementation

n8n Skills:

"AI automation engineer"

Complex system builder

Production-grade deliverables

$5,000-15,000 per project

Combined: $7,000-20,000 projects with fast prototyping + robust delivery.

Common Misconceptions Debunked

Myth 1: "Agent Kit Kills n8n"

Reality: They solve different problems

Agent Kit = Conversational tools

n8n = Autonomous automation

No overlap in core use case

Myth 2: "n8n is Too Complex for Simple Agents"

Reality: Simple n8n agents take 5-10 minutes

Chat trigger + AI agent + tools

Complexity only appears with advanced features

Similar to Agent Kit for basic use cases

Myth 3: "Agent Kit Has No Learning Curve"

Reality: Simple start, complex plateau

Easy for chat agents

Hits wall at event-driven automation

No path to production automation

Myth 4: "You Must Choose One Platform"

Reality: Use both strategically

Right tool for right job

Complement each other

Agency/product efficiency gains

Hands-On Assignments

Assignment 1: Build Comparison (60 minutes)

Goal: Experience both platforms firsthand

Agent Kit Build:

Create simple chat agent with web search

Add vector store with 2-3 PDFs

Test RAG capabilities Time yourself: Should take <10 minutes total

n8n Build:

Create same chat agent

Set up Supabase vector store

Upload same PDFs

Test identical queries Time yourself: Will take 30-40 minutes

Deliverable: Written comparison noting:

Setup time difference

Output quality difference

Where you got stuck

Which you''d use for what

Assignment 2: Use Case Mapping (30 minutes)

Goal: Strategic platform selection practice

List 10 automation ideas you have (or client needs):

For each, identify:
Trigger type (chat, email, webhook, schedule)

Complexity level (simple, medium, complex)

Autonomy needed (manual, semi-auto, fully-auto)

Assign to Agent Kit or n8n

Justify decision

Example:

Use Case: Customer onboarding email sequence
Trigger: New CRM entry
Complexity: Medium (multi-step)
Autonomy: Fully automated
Platform: n8n
Why: Event-driven, must run autonomously

Assignment 3: Prototype-to-Production Pipeline (90 minutes)

Goal: Experience hybrid workflow

Phase 1: Build blog post generator in Agent Kit (15 min)

Chat interface

Web search for research

Generate outline + content

Phase 2: Rebuild in n8n with orchestration (75 min)

Separate research agent

Separate writing agent

Orchestrator to coordinate

Compare output quality

Deliverable: Side-by-side comparison:

Which was faster to build?

Which produced better output?

Which would you deploy for client?

Key Takeaways

Technical Mastery: 

✅ Understand event-driven vs chat-triggered architecture 

✅ Multi-agent orchestration patterns 

✅ RAG implementation trade-offs (control vs convenience) 

✅ Platform limitations and workarounds 

✅ Strategic tool selection framework

Business Impact: 

✅ Agent Kit: 10-minute demos close deals 

✅ n8n: Production systems create recurring revenue 

✅ Hybrid approach: Best of both worlds 

✅ Platform selection: Wrong choice = project failure 

✅ Strategic positioning: Different tools = different client tiers

Strategic Positioning: 

✅ Not "which is better"—"what am I building?" 

✅ Chat assistant ≠ autonomous automation

✅ Prototype speed vs production robustness 

✅ Internal tools vs client deliverables 

✅ Master both, deploy strategically

The future of AI automation isn''t platform wars—it''s strategic platform selection. Agent Kit didn''t kill n8n because they''re not competing. One makes chatbots accessible to everyone. The other builds production automation systems. The real skill isn''t choosing sides—it''s knowing which tool solves which problem, and using both to maximize speed, quality, and revenue.', 3),
  ('e261132f-6ab4-4d79-a033-69fba97edcfa', 'ef505006-a535-43ff-9155-8a1dd0c5cc9c', 'More Added Daily!', '', 4);
