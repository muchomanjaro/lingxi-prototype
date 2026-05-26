# Hermes Agent — Comprehensive Business Plan (v2 — Full Automation)

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Business Model & Pricing](#2-business-model--pricing)
3. [Aura: The AI Assistant](#3-aura-the-ai-assistant)
4. [Disclaimer Agreement](#4-disclaimer-agreement)
5. [Technical Architecture & Provisioning](#5-technical-architecture--provisioning)
6. [Skill Pack System](#6-skill-pack-system)
7. [WeChat Operations & Delivery](#7-wechat-operations--delivery)
8. [Referral System](#8-referral-system)
9. [Risk & Compliance](#9-risk--compliance)
10. [Hiring & Team Build](#10-hiring--team-build)
11. [Launch Plan & Timeline](#11-launch-plan--timeline)
12. [Content Production Strategy](#12-content-production-strategy)

---

## 1. Executive Summary

**Thesis:** Set up Hermes Agent for Chinese professionals via WeChat. Automate **everything** except the marketing video. Target: professionals who want an AI agent but cannot use a terminal and should never need to.

The core insight is radical: **the human element should be ONLY the WeChat marketing videos** showing what Hermes can do. Everything else — onboarding, setup, support, troubleshooting, billing, referral payouts, community management — is handled by an AI assistant called **Aura** (奥拉助手).

Aura is not Hermes. Aura is our own branded AI concierge that lives in WeChat as a mini-program bot. Customers interact with Aura from first touchpoint through ongoing support. Aura handles the survey, tier recommendation, payment, provisioning coordination, setup guidance, post-purchase troubleshooting, and escalation. The customer never talks to a human unless Aura fails 3 times in a row on the same issue.

Hermes delivers one thing: a working agent for your job, on your computer, through WeChat, with WeChat Pay, no English required, no terminal exposed, no human interaction needed. Setup takes 20–60 minutes (1–3 hours if issues arise). Aura sets honest expectations upfront and celebrates progress at each step. The customer buys a result, not software.

Chinese professionals face three specific barriers to adopting AI agents: CLI fear (80% of drop-off), API key confusion (15% of drop-off), and no skill authoring (5% of drop-off, but 100% of value gap). The terminal is a psychological wall. Even a single terminal command in a tutorial causes 80% of readers to abandon it. Hermes eliminates all three barriers by delivering a pre-configured, domain-tuned agent as a zip file through WeChat — and Aura eliminates the fourth barrier: confusion during setup.

The business has near-zero fixed costs: no office, no employees initially, no cloud infrastructure costs (serverless, pay-per-use), and no marketing spend (organic WeChat distribution). Aura runs on serverless LLM inference at approximately ¥0.15 per conversation, far cheaper than any human support interaction. At scale, the only significant costs are API key procurement and Aura's inference budget, yielding 85–95% margins at any volume above 15 customers/month.

### Summary Metrics

| Metric | Value |
|--------|-------|
| Tiers | Starter (¥1,999) / Pro (¥4,999) / Enterprise (¥14,999) / Custom |
| Margins | 91-95% (tier-dependent) |
| Breakeven | 15 customers/month (Aura eliminates early support bottleneck) |
| Path to ¥1M revenue | ~400 customers at blended ¥4,500 |
| Human touchpoints | Zero per customer (unless Aura escalates) |
| Aura resolution rate target | > 85% of all interactions |
| Escalation threshold | 3 failed resolution attempts → human |
| K-factor | 0.054 (growth accelerator, not engine) |
| Team target | 3 FTE + contractors at scale (automation delays hiring by 6+ months) |

### Decision Records

1. **One-time payment, not subscription** — Chinese consumer preference, WeChat Pay compatibility, no refund disputes. Upsells provide recurrence.
2. **WeChat-only distribution** — Zero CAC. No website, no ads, no sales. All acquisition through Moments, groups, and referrals.
3. **Zip delivery, not SaaS** — Customer owns the agent. No hosting costs, no server downtime, no data privacy liability.
4. **Domain skill packs** — The moat. Generic agents are commoditized. Profession-tuned prompts create switching costs and premium pricing.
5. **No VC funding** — Profitable from month 1. Growth constrained by Aura's learning curve, not capital. Freedom to operate independently.
6. **Aura-first, human-last** — Every customer interaction routes through Aura by default. Humans are the escalation layer, not the primary interface. This is the single most important architectural decision.

### How the Pieces Fit Together

```
Customer sees Moments post ──▶ WeChat Operations (Phase 1)
           │
           ▼
Customer scans QR ───────────▶ Aura greets in WeChat mini-program
           │
           ▼
Aura conducts interactive ───▶ Onboarding (Aura-guided)
onboarding (not a static survey)
           │
           ▼
Aura recommends tier ────────▶ Pricing Strategy (computed by Aura)
           │
           ▼
Payment via WeChat Pay ──────▶ WeChat Operations (Phase 3)
           │
           ▼
Aura confirms payment ───────▶ Provisions (server-side, triggered by Aura)
           │
           ▼
Aura guides setup step ──────▶ Delivery (Aura walks customer through each step)
by step through mini-program
           │
           ▼
Aura monitors for issues ────▶ Support (Aura-first, human if 3 failures)
           │
           ▼
Aura handles upsells / ──────▶ Referral System (Aura manages)
referrals proactively
           │
           ▼
Aura pushes pack updates ────▶ Skill Packs + Quality Assurance
```

---

## 2. Business Model & Pricing

### Business Model

**Revenue Model:** Pure transaction revenue. No subscriptions. No recurring billing. This is a deliberate choice: Chinese consumers prefer one-time payments for software (WPS Office model, not SaaS model); WeChat Pay supports one-time transfers seamlessly; one-time payment eliminates refund disputes; and upsells and add-on skill packs provide recurring revenue without subscription fatigue. Aura handles all upsell conversations proactively — after 30 days, Aura sends a personalized message offering the Professional upgrade at "¥3,000 off," with reasoning tailored to the customer's usage patterns.

### Unit Economics

Aura's cost is a first-class line item. Each customer conversation averages 12 messages (onboarding + setup + first-week support), at approximately ¥0.15 total inference cost using a distilled Chinese-language model deployed on serverless GPU inference. At scale, dedicated model fine-tuning drops this to ¥0.05 per customer.

**Starter (¥1,999)**

| Item | Cost (¥) |
|------|----------|
| Provisioning compute (serverless) | 2 |
| Storage + bandwidth (zip file) | 3 |
| WeChat Pay fee (0.6%) | 12 |
| Aura conversation budget | 15 |
| API key wholesale cost (month 1) | 60 |
| **Total COGS** | **92** |
| **Margin** | **95.4%** |

**Professional (¥4,999)**

| Item | Cost (¥) |
|------|----------|
| Provisioning + 2 packs | 5 |
| Storage + bandwidth | 4 |
| WeChat Pay fee (0.6%) | 30 |
| Aura conversation budget | 25 |
| API key wholesale cost (month 1) | 60 |
| Custom pack assembly | 200 |
| **Total COGS** | **324** |
| **Margin** | **93.5%** |

**Enterprise (¥14,999 for 3 seats)**

| Item | Cost (¥) |
|------|----------|
| Provisioning × 3 + packs | 15 |
| Storage + bandwidth | 10 |
| WeChat Pay fee (0.6%) | 90 |
| Aura conversation budget (enterprise SLA) | 50 |
| API key wholesale × 3 | 180 |
| Custom pack assembly + admin | 800 |
| **Total COGS** | **1,145** |
| **Margin** | **92.4%** |

API credits are purchased in bulk through aggregated accounts that accept Alipay/WeChat Pay. Maintaining relationships with 3+ resellers ensures continuity. Wholesale negotiation can cut API costs by 40%.

### Scale Constraints

**Provisioning Capacity:** The current pipeline provisions ~1 agent per 3 minutes. One serverless instance handles this. At 50+ agents/day, parallelization is needed with negligible cost impact.

**Support Bandwidth (Human):** With Aura handling >85% of interactions, human support is needed only for escalated cases. Each escalation costs ~¥50 in staff time. At 15 escalations per 100 customers, this is ¥7.50 per customer — a 10× reduction from the non-automated model. Human support headroom: 1 operator handles up to 500 customers (vs. 50 customers without Aura).

**API Key Risk:** If a key reseller is cut off, all active agents stop working. Mitigation: maintain multiple reseller relationships and eventually negotiate directly with domestic providers (Baichuan, Zhipu, MiniMax) for wholesale access.

**Copycats:** The barrier to entry is low technically. The moat is WeChat community trust, skill pack quality, Aura's accumulated knowledge base (which improves with every interaction), and first-mover advantage in key professional WeChat groups.

### Path to ¥1M Annual Revenue

| Month | Customers | Avg Price | Revenue | Cumulative |
|-------|-----------|-----------|---------|------------|
| 1 | 5 | ¥1,999 | ¥10k | ¥10k |
| 3 | 30 | ¥3,500 | ¥105k | ¥180k |
| 6 | 100 | ¥4,000 | ¥400k | ¥1.0M |
| 12 | 250 | ¥4,500 | ¥1.125M | ¥4.3M |

¥4.3M ≈ $590k USD. Path to ¥1M USD requires ~400 customers at the blend or expanding enterprise. Aura enables faster scaling because human support is no longer the bottleneck.

### Pricing Strategy

Hermes prices are value-based, anchored to what Chinese professionals already pay for professional services. Each tier is priced just below an existing spending category.

**Starter: ¥1,999** — Anchored to a dinner for 4 at a mid-range Beijing restaurant (¥2,000). Includes full Aura-guided setup and first-week support. First-time AI users, risk-averse professionals, teachers, and freelancers. Aura initiates upsell after 30 days.

**Professional: ¥4,999** — Anchored to a single coaching session or full-day workshop (¥5,000–8,000). Includes all Starter features, 2 domain-specific skill packs, priority Aura escalation lane (Aura tries harder before escalating), 3 months of API usage, and quarterly pack updates. Upsell path: additional skill packs at ¥999 each, handled by Aura.

**Enterprise: ¥14,999 (3 seats)** — Anchored to the corporate software procurement threshold. Most Chinese companies have a "¥15,000 or less" approval tier. ¥14,999 is deliberately ¥1 below this threshold. Includes 3 seats of Professional, admin dashboard, custom skill pack, dedicated Aura instance (fine-tuned on company terminology), and 6 months of API usage. Human escalation within 30 minutes. Upsell path: seat expansion at ¥4,999 per additional seat.

**Custom: Negotiated (10+ seats)** — Anchored to IT consulting rates (¥1,000–2,000/hour). Pricing formula: (Seats × ¥4,999) × 0.8 + ¥15,000 setup fee. Example: 20 seats = ¥94,984. Includes on-premises deployment option, custom pack development (up to 5), dedicated API key pool, and dedicated Aura + human support.

No sales or coupons are run except for a teacher discount (¥500 off), early adopter pricing (first 50 get Professional at Starter price), and the referral rebate.

### Price Testing Plan

In the first 3 months, two price points are tested: Group A (control) at ¥1,999 / ¥4,999 / ¥14,999 and Group B (test) at ¥2,499 / ¥5,999 / ¥17,999. Aura randomly assigns customers to test groups and tracks conversion by group. If conversion drops >25% in Group B, control pricing is kept. If <10%, prices are raised. Aura presents the price naturally within the conversation, adapting the framing to the customer's segment.

| Tier | Price | Anchor | Anchor Cost | Feels Like |
|------|-------|--------|-------------|------------|
| Starter | ¥1,999 | Dinner for 4 | ¥2,000 | Less than dinner |
| Professional | ¥4,999 | One-day workshop | ¥5,000–8,000 | Half a workshop |
| Enterprise | ¥14,999 | Corporate approval cap | ¥15,000 | Below budget limit |
| Custom | ~¥95k | Consulting fees | ¥200k+ | Fraction of consulting |

---

## 3. Aura: The AI Assistant

### What Is Aura

Aura (奥拉助手) is our branded AI concierge — the sole customer-facing interface for the Hermes setup service. Aura is not Hermes. Aura is a purpose-built guided assistant that handles everything from the first "hello" to ongoing support. The customer never sees a terminal, never fills a form, never waits for a human. They talk to Aura.

Aura lives in WeChat as a mini-program bot. It communicates in fluent Simplified Chinese, with optional code-switching to English for technical terms. It has a personality: patient, encouraging, never condescending. For customers who are afraid of computers (Q4: "I avoid it completely"), Aura adjusts to be more supportive and breaks instructions into smaller steps.

Aura is built on a fine-tuned Chinese LLM (Qwen2.5-72B distilled to 7B for latency and cost), deployed on serverless GPU inference (Alibaba Cloud Elastic GPU Service). The fine-tuning dataset comes from: 200 synthetic customer conversations, the entire Hermes knowledge base, past support interactions, and ongoing conversation logs (with privacy filtering).

### Persuasive Design Philosophy

Aura is not a neutral FAQ bot. It is a persuasive guide designed to move the customer through a sequence of states:

1. **Curious** → "What is this? Do I need it?"
2. **Informed** → "I understand what Hermes does and why I want it."
3. **Committed** → "I will pay and try it."
4. **Capable** → "I have set it up successfully."
5. **Confident** → "I use it daily and know how to get value."
6. **Advocate** → "I tell my colleagues about it."

Every Aura response is designed to nudge the customer toward the next state. State transitions are tracked in Aura's session memory. If a customer stalls at "Committed" (paid but hasn't unzipped), Aura sends a proactive WeChat message 2 hours later: "Setup usually takes 20–30 minutes with my guidance. Most people finish in one sitting. Would you like me to walk you through it step by step?"

The persuasion is not manipulative — it is genuinely helpful guidance. The tone is "your helpful colleague who knows the product inside out," not a sales script.

### Aura Interaction Architecture

```
Customer sends message
        │
        ▼
WeChat mini-program ──▶ Message Router
        │
        ▼
Aura NLU Engine ──────▶ Intent Classifier
        │                    │
        ├── Onboarding intent ──▶ Onboarding Flow
        ├── Setup intent ──────▶ Setup Flow
        ├── Support intent ────▶ Support Flow (→ Knowledge Base → Diagnose → Escalate)
        ├── Billing intent ────▶ Billing Flow
        ├── Referral intent ───▶ Referral Flow
        └── Chitchat ──────────▶ General Response
        │
        ▼
Response Generator ──▶ Policy Enforcer (guardrails, disclaimers)
        │
        ▼
WeChat mini-program ──▶ Customer sees response
```

### Onboarding Flow (Aura-Guided)

Instead of a static 6-question survey, Aura conducts an interactive conversation:

```
Aura: "你好！我是奥拉，你的AI助手。让我了解你的工作情况，为你推荐最合适的方案。你从事什么行业？"
Customer: "我是中学老师。"
Aura: "太好了！我有很多老师用户。你平时花最多时间在哪些工作上？比如备课、批改作业、写报告？"
Customer: "备课和批改作业最花时间。"
Aura: "明白了。我推荐你使用教师专用包，它包含教案编写、作业批改和家校沟通模板。你平时使用什么电脑？"
...
```

This feels natural, not like filling a form. Aura extracts structured data from the conversation (profession, pain points, tools, computer type, purchase context) and builds the JSON payload internally. The customer never sees a form.

### Aura Memory

Aura maintains a session memory for each customer (stored encrypted, keyed by WeChat ID, retained for the duration of the relationship). Memory includes:

- Survey responses (extracted from conversation, structured)
- Tier selection and purchase history
- Setup progress (which steps completed, which failed)
- Support interaction history (issues, resolutions, sentiment)
- Knowledge gaps (topics where Aura had to escalate — used to improve the knowledge base)
- Conversation state (which state in the 6-state model the customer is in)
- Interaction count and pattern (daily active, struggling, dormant)

Memory is pruned after 180 days of inactivity. Customers can request Aura to forget their data at any time, which triggers a hard deletion.

### Aura Knowledge Base

The knowledge base is a vector store (Alibaba Cloud Vector Engine or Milvus) indexed with bilingual embeddings. It contains:

- **Setup guides** (15 articles covering every setup scenario, including edge cases like macOS security warnings)
- **Known issues** (continuously updated from support logs, each entry: symptom → diagnosis → resolution)
- **FAQ** (200+ questions organized by topic, bilingual)
- **Troubleshooting playbooks** (flowcharts that Aura follows to diagnose issues)
- **Product documentation** (feature descriptions, update logs, scope boundaries)
- **Pricing and policy documents** (tier comparisons, refund policy, disclaimer agreement)
- **Pack documentation** (what each skill pack does, example outputs, trigger phrases)

The knowledge base is the product. It improves with every customer interaction. Aura's feedback loop:

1. Aura encounters an issue it cannot resolve
2. Aura logs the question, attempted resolutions, and failure point
3. Escalation triggers human review
4. Human writes the resolution, adds to knowledge base
5. Aura can resolve this issue autonomously going forward
6. Monthly review: top 20 escalated patterns get permanent fixes in the knowledge base or provisioning pipeline

### Aura as a Diagnostic Engine

When a customer reports an issue, Aura runs a diagnostic sequence:

1. **Question** — "What exactly happened? What were you trying to do?"
2. **Classify** — Intent classification maps the issue to a known pattern
3. **Knowledge base lookup** — Semantic search for similar issues with resolutions
4. **Diagnostic command** — Aura sends a guided instruction: "请在终端中运行这个命令，然后把输出结果发给我：`bash ~/.hermes/diagnose.sh --quick`" (Aura adapts this for the user's comfort level — CLI-fearful users skip this step)
5. **Interpret results** — Aura reads the diagnostic output codes (H-OK through H-UNK)
6. **Resolve** — Apply known fix, or generate structured resolution steps
7. **Verify** — "问题解决了吗？" If yes, log resolution. If no, increment failure counter.
8. **Escalate** — After 3 failed attempts, route to human with full conversation transcript and diagnostic output

Aura never gives raw terminal commands to CLI-fearful customers. Instead, Aura says: "我可以在你的电脑上帮你运行这个检查。请点击下面的按钮授权。" with a WeChat mini-program button that triggers a controlled remote diagnostic (via a secure, ephemeral SSH tunnel initiated by the agent — the customer authorizes once, and the diagnostic runs with visible progress in the mini-program).

### Escalation Protocol

Aura escalates to a human only after:

1. 3 failed resolution attempts (different approaches each time)
2. The issue is flagged as a security concern (potential data breach, abuse)
3. The customer explicitly asks for a human ("我要找真人客服")
4. Sentiment analysis detects extreme frustration (anger, threats, repeated cursing)
5. The issue involves financial disputes outside the refund policy scope

When escalating, Aura prepares a complete handoff package in the human's support dashboard: full conversation transcript (tagged by intent), diagnostic results (if run), attempted resolutions and their outcomes, customer sentiment score, and customer tier and history. The human picks up without asking the customer to repeat anything.

### Aura Continuous Learning

After each interaction, Aura generates a structured feedback record:

```
{
  "customer_id": "wx_abc123",
  "timestamp": "2026-05-25T10:30:00+08:00",
  "interaction_type": "support | onboarding | billing",
  "intent": "setup_macos_permission",
  "resolution": "resolved | escalated | unresolved",
  "resolution_path": ["knowledge_base_article_42", "diagnostic_step_3"],
  "customer_sentiment": "positive | neutral | negative | frustrated",
  "new_pattern": false,
  "key_terms": ["macOS", "安全提示", "权限", "Privacy & Security"]
}
```

Aggregated feedback drives:
- **Weekly knowledge base expansions** — top unresolved patterns → write new articles
- **Model fine-tuning** — every 500 interactions → retrain Aura's response generation on resolved patterns
- **Pipeline improvements** — if 3+ customers hit the same setup issue, fix the provisioning pipeline to prevent it
- **Pack improvements** — if customers consistently ask how to do X, X was supposed to be a skill pack feature — add it

### Aura Performance Targets

| Metric | Target |
|--------|--------|
| First-response time | < 3 seconds |
| Resolution rate (no escalation) | > 85% |
| Customer satisfaction (post-interaction survey) | > 4.2 / 5.0 |
| Average conversation length | < 8 messages for support |
| Escalation to human | < 15% of all interactions |
| Human resolution time (after escalation) | < 30 minutes |
| Time to knowledge base update after novel issue | < 24 hours |

---

## 4. Disclaimer Agreement

### Legal Document Overview

Before a customer completes purchase, Aura presents a Chinese-language disclaimer agreement as an interactive step in the mini-program. The customer must tap "我已阅读并同意" (I have read and agree) before the WeChat Pay sheet opens. The agreement is short, readable, and uses plain language (not legalese). It is designed to be read, not buried.

Aura does not just show the agreement — it explains each clause conversationally: "你需要知道的是，Hermes使用你提供的API密钥来工作。我们不会存储你的密钥，但API服务的稳定性和费用由提供商决定。条款里第3条解释了这一点，你可以随时问我。" This serves both as legal protection and expectation management.

### Full Text of the Hermes Service Disclaimer Agreement

**Hermes AI Agent Setup Service — Customer Agreement (服务协议)**

Last updated: May 2026

**1. Service Scope**

1.1 Hermes (hereinafter "we," "us," or "our") provides an automated setup service for third-party AI agent software ("Hermes Agent"). Our service includes: configuration file generation, skill pack installation, setup guidance through our AI assistant Aura, and post-setup technical support through Aura.

1.2 We do not operate, host, or maintain the AI agent runtime. The agent runs locally on your computer. We do not provide cloud-based AI inference services.

**2. Customer Responsibilities**

2.1 You are responsible for providing your own API key from a supported third-party AI model provider (e.g., OpenAI, Anthropic, domestic providers). We will assist in key configuration through Aura.

2.2 You are solely responsible for all costs associated with API usage, including but not limited to per-token charges, rate limits, and any overage fees imposed by the API provider.

2.3 You are responsible for maintaining the security of your API key, your computer, and your WeChat account. We recommend enabling two-factor authentication on all accounts.

2.4 You must have a compatible computer (macOS 12+ on Apple Silicon or Intel) with internet access to use the agent. Windows support is not currently available.

**3. API Key and Data Privacy**

3.1 We do not store your API key on our servers. Your API key is encrypted and stored locally in your agent configuration file on your computer.

3.2 We do not collect, store, or monitor the content of conversations between you and the AI agent. All processing occurs locally on your computer.

3.3 We collect only the following data: your WeChat ID (for order processing and support), survey responses (for skill pack selection), and diagnostic codes (for troubleshooting, if you voluntarily run diagnostics). This data is stored on Alibaba Cloud (Shanghai region) and deleted 180 days after your last interaction with us.

3.4 We do not sell, share, or transfer your personal data to third parties except as required by law.

3.5 You may request deletion of your data at any time by messaging Aura "请删除我的数据." Deletion will be completed within 72 hours.

**4. No Warranty and Limitation of Liability**

4.1 THE SERVICE IS PROVIDED "AS IS" AND "AS AVAILABLE." WE MAKE NO WARRANTIES, EXPRESS OR IMPLIED, REGARDING THE FUNCTIONALITY, ACCURACY, RELIABILITY, OR AVAILABILITY OF THE AGENT OR THE SETUP SERVICE.

4.2 We do not guarantee that:
- (a) The AI agent will function as expected in all use cases
- (b) The setup process will complete without interruption
- (c) The API provider will maintain service availability
- (d) The agent will produce accurate, appropriate, or useful outputs
- (e) Specific outcomes will be achieved through agent usage

4.3 We are not responsible for any damages, losses, or costs arising from:
- (a) API provider outages, rate limits, or policy changes
- (b) Errors, omissions, or inappropriate outputs generated by the AI agent
- (c) Data loss or corruption on your computer
- (d) Compatibility issues with your specific hardware or software configuration
- (e) Third-party actions, including but not limited to API key theft or unauthorized access

4.4 Our total liability for any claim arising from this agreement is limited to the amount you paid for the service.

**5. Refund Policy**

5.1 You may request a full refund within 7 days of purchase, no questions asked. To request, message Aura "我要退款."

5.2 Between 8 and 30 days of purchase, refunds are pro-rated based on usage. We reserve the right to deduct the cost of API credits already consumed.

5.3 After 30 days, refunds are handled on a case-by-case basis. We are not obligated to provide refunds for issues caused by:
- API provider changes or discontinuation
- Your computer or operating system incompatibility
- Changes in your personal circumstances or needs
- Failure to follow setup instructions

5.4 Refunds are processed through WeChat Pay and credited within 3 business days.

**6. Agreement to Terms**

6.1 By tapping "我已阅读并同意," you confirm that you have read, understood, and agreed to all terms in this agreement.

6.2 We reserve the right to update this agreement. Customers will be notified of material changes via Aura and must accept the updated terms before continued use.

---

## 5. Technical Architecture & Provisioning

### Philosophy

Hermes Agent is not a SaaS product. It is a provisioning system that produces configured agent environments. The "product" the customer buys is a zip file. The technical architecture has three planes: the **Aura plane** (customer-facing AI assistant), the **provisioning plane** (server-side, event-driven) which builds the zip, and the **runtime plane** (client-side, on Mac) which runs the agent.

The Aura plane is the only customer-facing layer. The provisioning plane is invisible. The runtime plane is also invisible — the customer interacts with the agent through a Chinese chat interface, not a terminal.

### Aura Plane Infrastructure

Aura runs on Alibaba Cloud Elastic GPU Service (serverless inference) using a fine-tuned Qwen2.5-7B-Instruct model. The model is deployed as a single GPU instance with auto-scaling (1–5 instances based on queue depth). Inference cost: ~¥0.0003 per token (input + output), ~¥0.15 per average conversation. Cold start: < 500ms with continuous keep-warm pings.

The Aura backend consists of:

**Conversation Router** — Node.js (Alibaba Cloud Function Compute). Routes incoming messages to the NLU engine. Maintains a distributed conversation lock per WeChat ID to prevent race conditions. Latency budget: 50ms.

**NLU Engine** — Python 3.12 (GPU instance). Intent classification (5-class: onboarding, setup, support, billing, chitchat) + entity extraction. Uses a distilled BERT model (60ms classification). Falls back to LLM-based classification if confidence < 0.85.

**Knowledge Base Retriever** — Alibaba Cloud Vector Engine. Semantic search over 500+ embedded documents. Returns top-3 relevant chunks per query. Latency: 30ms. Embedding model: BAAI/bge-small-zh-v1.5.

**Response Generator** — The fine-tuned LLM. Generates responses conditioned on: conversation history, retrieved knowledge chunks, customer state (from memory store), and policy constraints (guardrails). Latency: 800–1500ms. Temperature: 0.3 for factual responses, 0.7 for onboarding/chitchat.

**Memory Store** — Alibaba Cloud TableStore (DynamoDB-compatible). Customer profiles, session state, interaction history. TTL-indexed: inactive entries expire at 180 days.

**Diagnostic Runner** — A secure microservice that accepts diagnostic authorization tokens from Aura. When a customer clicks "授权诊断" in the mini-program, an ephemeral SSH tunnel opens to the customer's agent (the agent has a built-in SSH server that activates only on authorization). The diagnostic runner executes a predefined diagnostic script and returns structured results to Aura. The tunnel lives for exactly 60 seconds, then self-destructs. All traffic is encrypted. No file transfer is possible — only stdout of the diagnostic script.

### Provisioning Plane Infrastructure

The system uses Alibaba Cloud (primary, for China compliance) with AWS Lambda as fallback (Singapore region). Compute is Function Compute with 1024 MB memory, 5-minute timeout per step, Node.js 20.x or Python 3.12, and up to 50 concurrent executions. Cost: ~¥0.003 per invocation, 7 invocations per customer = ¥0.021.

Storage uses OSS (Alibaba) for templates, packs, working directories (7-day retention), and finished archives (30-day retention). DynamoDB-compatible TableStore handles customer records, provisioning state (indefinite), and audit logs (90-day retention).

### 8-Step Provisioning Pipeline

The pipeline is orchestrated via Alibaba Cloud Serverless Workflow (or AWS Step Functions), event-driven from Aura's payment confirmation:

**Step 1: Validate (~10s)** — Validate JSON schema conformance (generated by Aura's onboarding conversation), check OS compatibility (reject Windows with waitlist redirect), verify WeChat ID is not blacklisted, check payment confirmation webhook, generate unique customer ID, log to audit trail. Schema failure returns to Aura with request for clarification; Windows users get a waitlist redirect; blacklisted IDs are silently escalated to human.

**Step 2: Clone (~30s)** — Fetch base agent template from S3/OSS, clone into a customer-specific working directory, copy selected skill pack files, copy tier-specific assets (documentation, tutorial videos). S3 failures retry 3x with exponential backoff, falling back to local cache. Missing skill packs substitute "general" pack and flag for human follow-up.

**Step 3: Inject API Key (~5s)** — Select API key from key pool (keys are rotated and rate-limited per tier), write key to config in encrypted form (XOR + base64 with machine-UUID-derived seed), write model selection config, set environment variables. Keys expire after 60 days. If the zip is shared, the key will not decrypt on a different machine. Key pool exhaustion queues provisioning and alerts Aura; Aura informs the customer of a 30-minute delay.

**Step 4: Load Skills (~20s)** — Resolve skill pack dependencies (packs can depend on other packs), copy pack files into the agent's skill directory, generate pack manifest index for runtime loading, translate any bilingual skill content. Dependency cycles default to general pack with operator alert.

**Step 5: Generate Config (~15s)** — Generate master config.yaml, Chinese-language command aliases (aliases.sh), agent initialization script (init.lua), one-command installer (setup.sh), and pre-flight check script (env_check.sh).

**Step 6: Verify (~60s)** — Run setup.sh --dry-run for syntax check, verify all skill pack files exist and are non-empty, validate config YAML, check API key format, ensure total size < 50 MB. Verification failure blocks delivery — Aura informs the customer of a 2-hour delay for manual inspection. Size exceeded triggers compression or splitting.

**Step 7: Package (~30s)** — Create password-protected zip (password = last 8 chars of WeChat ID, communicated separately by Aura), upload to WeChat CDN or iCloud shared folder. Aura sends a WeChat message with download link and step-by-step Chinese instructions through the mini-program.

**Step 8: Aura Activation** — Once the zip is ready, Aura initiates the setup guidance flow: "你的文件已经准备好了！点击这里下载。下载完成后，告诉我，我会一步一步教你安装。" Aura then walks the customer through each setup step interactively, verifying completion at each stage.

### API Key Pool Architecture

The key pool is the most sensitive component. Three tiers are maintained: a shared pool of 20 keys for Starter, 10 dedicated keys for Professional, and 5 dedicated keys for Enterprise. Key selection uses round-robin across available keys with remaining token checks. A daily usage monitor Lambda checks and auto-rotates keys. Keys are XOR-encrypted at rest with machine-UUID-derived keys, decrypted into memory at runtime, and expire every 60 days with transparent rotation. Aura can trigger a key rotation on demand if a customer reports API errors.

### Security Architecture

A Hermes relay proxy sits between the agent and the API provider, adding rate limiting (per customer), audit logging, and abuse detection without inspecting request content. Enterprise customers get their own proxy instance. No customer data is stored on Hermes infrastructure — all processing is client-side. Agent logs are stored locally and are user-deletable. Telemetry is opt-in only. Zero payment data is stored by Hermes — WeChat Pay handles all payment processing.

The diagnostic tunnel is the most sensitive surface. Each tunnel requires a one-time authorization token generated by Aura, signed with the customer's WeChat session key, valid for exactly 60 seconds, and single-use. The agent's SSH server binds only to localhost and rejects all connections without a valid token. The diagnostic script is a read-only operations list — it cannot write files, install software, or modify configuration.

### Runtime Plane (Customer Mac)

The zip contains setup.sh (one-command installer), env_check.sh (pre-flight system check), diagnose.sh (diagnostic tool), the ~/.hermes/ configuration directory with skills, pack manifest, config, aliases, init script, plus setup instructions in Chinese and scope documentation. Total size: 15–35 MB.

The setup script checks macOS version ≥ 12 (Monterey), verifies architecture (Apple Silicon or Intel), ensures disk space > 500 MB, creates directory structure, copies configs, injects aliases into .zshrc, verifies the agent binary runs, and tests API connection — all with Chinese progress messages. The terminal is never opened unless explicitly run; setup is designed to be double-clicked in Finder. Aura guides the user through the entire process with screenshots and step-by-step instructions embedded in the mini-program.

The agent binary uses claude-sonnet-4-20260514 (default, tier-dependent) with Chinese interface enabled, skill packs loaded from ~/.hermes/skills/, and no raw terminal access — the user types natural language only. File access covers Desktop, Documents, and Downloads folders by default.

### Desktop Application (Jiesi GUI)

A native macOS desktop application ("捷思") replaces the zip-based delivery as the primary runtime plane. Built with **Tauri** (Rust backend + React/TypeScript frontend) for a 5-10 MB bundle — critical for WeChat file transfer where 150 MB Electron apps are impractical.

**Architecture decisions:**
- **Tauri over Electron** — 5 MB vs 150 MB bundle size respects Chinese internet constraints (GFW, slow mirrors, mobile hotspot distribution via WeChat). Rust `std::process` provides reliable Hermes agent child process management (PID tracking, signal handling, no orphaned/zombie processes).
- **React + TypeScript + Tailwind CSS** — Widely known in the Chinese developer ecosystem; easy to find React developers who speak Chinese.
- **Rust backend handles all sensitive operations** — Process manager, encrypted config store (macOS Keychain), file system mediation, update engine. The WebView UI is presentation-only and never directly touches the filesystem or secrets.
- **JSON-line IPC over stdin/stdout** between Rust and the Hermes Python agent — human-readable, easy to debug, no binary protocol.

**Bilingual requirement (all UI):**
Every piece of UI text — every label, button, message, tooltip, toast, error, confirmation dialog — displays Chinese as the primary language with English subtitles in smaller gray text beneath. Examples: button shows "开始使用" with gray "Start Using" below; error shows "网络连接失败" with gray "Network connection failed". The app supports switching between CN-only and EN-only modes in Settings, but the default (and the only mode at launch) is Chinese primary + English subtitle. This applies to all 20+ screens: wizard, dashboard, chat, settings, skill manager, profiles, MCP, gateways, tasks, memory, plugins, files, voice, and log viewer.

**Security-first messaging:**
Every permission request in the desktop app is accompanied by a contextual security note at the point of the request:
- "捷思在本地运行。你的数据不会离开你的电脑。"
- "你的API密钥仅存储在你的设备上。"
- "我们无法访问你的文件。所有操作都在你的控制之下。"
- "Hermes是开源软件，代码公开可审查。"
These are displayed as subtle banners or inline text, not blocking modals, and appear at the exact moment the permission is requested.

**Conversational setup wizard:**
The setup wizard in the desktop app is an 8-step conversation (not a dashboard dump):
1. Welcome screen with single "开始设置" button
2. Import onboarding JSON from Aura's WeChat mini-program, or full wizard (profession → pain points → computer type → AI experience)
3. Environment checks with security explanations before each permission
4. Automated Obsidian install — detects if Obsidian is present; if not, downloads macOS version from obsidian.com and installs automatically. Creates a "捷思" vault at `~/Documents/捷思/`
5. API key setup — guides user to DeepSeek, tests the key, stores encrypted in macOS Keychain
6. Hermes engine installation with animated progress bar (clone, venv, pip install, config write)
7. Skill pack loading based on profession, with per-pack toggle
8. Final confirmation screen — green checkmark summary of everything configured, with "一切就绪，开始使用！" / "All set, start using!" button

**Automated Obsidian install:**
The setup wizard checks for Obsidian via `mdfind` or Spotlight. If not found, Rust downloads the macOS `.dmg` from obsidian.com (with China-mirror fallback), shows a download progress bar with Chinese status text, mounts and copies to `/Applications/`, and creates a vault at `~/Documents/捷思/`. All data stays local. Security note: "Obsidian将用于存储你的AI记忆和知识库。所有数据保存在你的电脑上。"

**Bilingual in all screens — not just the wizard:**
The bilingual pattern applies to every page: Chat (message bubbles, input placeholder, toolbar icons), Dashboard (stat cards, status indicators, quick action buttons), Settings (all 10+ tabs, every field label and description), Skill Manager (pack names, descriptions, status badges), Profiles (Roman Cohort names and descriptions in both languages), MCP Servers (table headers, status labels, tool names), Gateways (connection status, configuration labels), Tasks (schedule descriptions, status), Memory (entry keys, category labels), Plugins (store listings, configuration fields), Files (context menus, search placeholder), Voice (recording state, settings labels), and Log Viewer (level labels, search, timestamps). Implementation: a single i18n utility that returns `{ cn: string, en: string }` for every string key, with the UI always rendering both unless the user switches to single-language mode.

### Offline Mode (Custom/Enterprise)

For organizations that cannot route data through external API providers, offline deployment is supported using bundled Ollama with Qwen2.5-7B-Instruct (Chinese-optimized). Skill packs are pre-compiled into GGUF format. Setup is longer (30–60 minutes for model download) but zero network dependency. Requires 16 GB+ RAM and 10 GB+ free disk space. Quality is 80–90% of cloud model quality. Aura guides the user through the offline setup, adapting instructions to skip network-dependent steps.

### Monitoring and Observability

**Aura plane alerts:** Aura resolution rate < 80% triggers knowledge base review; average conversation length > 15 messages triggers flow optimization; escalation rate > 20% triggers human review of top escalation patterns; model latency > 3s triggers GPU instance scaling; sentiment score < 3.5 triggers tone/response review.

**Provisioning plane alerts:** Pipeline error rate > 1% pauses provisioning; pipeline duration > 15 min average triggers bottleneck investigation; key pool < 10 keys triggers reseller contact; S3/OSS latency > 500ms triggers failover; WeChat webhook lag > 5 min triggers manual processing.

**Runtime plane alerts (relay proxy):** API error rate per customer > 5% triggers key rotation; API latency > 5s avg triggers model failover; daily active customers < 50% triggers Aura re-engagement; API cost per customer > ¥100/month triggers abuse check.

### Scaling Limits

| Component | Current Capacity | Bottleneck | Upgrade Path |
|-----------|-----------------|------------|--------------|
| Aura conversations | ~500/day (1 GPU instance) | Single instance | Auto-scale to 5 instances |
| Provisioning pipeline | 1 agent/3 min | Sequential state machine | Parallelize per step |
| API key pool | 50 keys | Reseller relationships | Direct provider agreement |
| Aura knowledge base | 500 documents | Manual curation | Automated extraction from escalation logs |
| Human escalation capacity | 50 cases/week (1 operator) | Single operator | Hire support at 200+ customers/month |
| WeChat CDN delivery | 100 MB/file | WeChat file limit | Split files or use iCloud links |
| Pack registry | 1 repo, 10 packs | Manual pack authoring | Pack marketplace with revenue share |

---

### 5.1 Time Expectation Management & Reduction Roadmap

#### Realistic Timeframes

Every step has a range. Aura communicates these upfront and never promises a fixed time.

| Step | Best Case | Typical | Worst Case | Key Drivers |
|------|-----------|---------|------------|-------------|
| API key creation | 2 min | 5 min | 15 min | Existing account vs new; email/SMS delays |
| Download zip | 1 min | 3 min | 10 min | Internet speed; WeChat file limits |
| Unzip + locate | 1 min | 3 min | 10 min | macOS vs Windows; zip password confusion |
| Run installer | 1 min | 5 min | 20 min | macOS Gatekeeper; terminal fear |
| Verify agent works | 1 min | 2 min | 5 min | API key validity; network issues |
| **Total** | **6 min** | **20–60 min** | **1–3 hours** | See factors below |

**Factors driving time up:**
- **No Python installed (+5–15 min):** Download Python + create venv + install pip deps. Worse on slow connections or old macOS.
- **First terminal use (+10–30 min):** Each terminal interaction multiplies hesitation. Aura avoids showing the terminal, but some edge cases require it.
- **macOS Gatekeeper (+5–20 min):** "无法验证开发者" warning, navigating Privacy & Security settings, restart required.
- **Slow internet (+5–20 min):** Downloads take longer; pip installs time out; CDN access issues in China.
- **Windows (+15–60 min):** Not supported. Redirect to waitlist or suggest cloud alternatives.
- **API provider issues (+5–30 min):** Account creation delays, rate limits, key generation failures, firewall blocks.

#### How Aura Manages Expectations

Aura is honest about time from the first interaction:

1. **Pre-purchase:** "安装通常需要20–30分钟。我会全程指导你。如果遇到问题，最坏情况可能需要1–2小时，但我会一直陪着你。"
2. **Post-purchase:** "后台准备约3分钟。安装过程大约20–30分钟，我一步步教你。"
3. **During setup, after each step:** "太棒了！第一步完成！还有3步，大约需要15分钟。" — celebrates progress, keeps estimates visible.
4. **If stuck:** "别着急，这个问题很常见。大约5分钟就能解决。我们一步步来。"
5. **If delayed:** "比预期长了一些。感谢你的耐心。我们换个方法试试。"

Aura never claims "10 minutes" or "3 minutes." Every time estimate is conservative. If a step finishes faster, that's a pleasant surprise. Progress is celebrated explicitly at each stage.

#### How to Legitimately Reduce Time Over Time

These investments compound over successive customers, prioritized by impact:

**1. Pre-built Docker Images (saves 15–30 min)**
Python + venv + pip deps + git + agent code pre-installed in a Docker image. Customer only installs Docker Desktop. Eliminates "no Python" and dependency failures entirely.
- If customer has Docker: 0 min dependency setup
- If customer installs Docker: 10–15 min, still faster than Python from scratch

**2. Native macOS Installer (.dmg/.pkg) (saves 10–20 min)**
Bundles Python runtime, frozen pip dependencies, and agent binary into a single double-clickable installer. Built with `create-dmg`, `pkgbuild`, or PyInstaller. Eliminates 80% of setup friction. Trade-off: download grows to 100–200 MB.

**3. Cloud Desktop / VM Fallback (saves 30–60 min for edge cases)**
Pre-configured Alibaba Cloud ECS instance with everything installed. Customer connects via RDP. Aura provisions and sends credentials. Cost: ¥1–2/hour, included in tier pricing. Useful when local setup fails repeatedly or customer is on Windows.

**4. Aura Knowledge Base Compounding (saves 5–20 min per incident)**
Each novel issue Aura resolves via escalation → human → KB makes future resolutions faster:
- 10 customers: ~5 distinct issues seen
- 100 customers: ~30 issues, 90% coverage
- 500 customers: 95%+ resolution without escalation

**5. Vendor Directory (offline pip) (saves 5–15 min)**
All pip dependencies pre-downloaded into a `vendor/` directory in the zip. Setup runs `pip install --no-index --find-links ./vendor`. Eliminates failed downloads due to GFW or slow mirrors. Adds ~50 MB to zip.

**6. Error Pattern Database (saves 5–20 min per error)**
Regex-matched error messages (Python, pip, git, macOS) mapped to Chinese troubleshooting steps. Aura instantly identifies issues from error output instead of asking the customer to describe them. Covers top 50 error patterns after 3 months.

#### Time Reduction Roadmap

| Timeframe | Investment | Typical Case Savings |
|-----------|-----------|---------------------|
| Month 1 | Vendor directory + error database (top 20 patterns) | 10 min |
| Month 2 | Native .pkg installer + Aura pre-checks Python/git | 20 min |
| Month 3 | Docker images + Aura has seen 30+ issues | 25 min |
| Month 4 | Cloud desktop fallback + KB covers 90% | 30 min |
| Month 5+ | Installer + Docker + experienced Aura | 10–15 min typical |

**Honest long-term target:** After 6 months of compounding improvements, typical setup drops from 20–60 min to 10–20 min. It will never be "10 minutes flat" for everyone — computers and humans are unpredictable. Aura's job is not to promise speed. It is to deliver a smooth, honest, guided experience at whatever pace the customer needs.

---

## 6. Skill Pack System

### What Is a Skill Pack

A skill pack is a directory of structured files that teach the AI agent how to perform domain-specific tasks. Each pack contains prompt templates, tool configurations, output format specifications, and guardrails. Packs are the product. The agent is the delivery mechanism.

The skill pack system directly feeds Aura's knowledge base. When a new pack is added, Aura automatically ingests the pack documentation — trigger keywords, example outputs, and common use cases — so it can answer questions about what the pack does and recommend it during onboarding.

### Pack Directory Structure

Every pack follows a standard contract: root contains pack.json (required manifest), prompts/ directory (required, with skill markdown files), tools/ directory (optional, with YAML tool definitions and custom scripts), templates/ directory (optional, with output format templates and examples), guardrails/ directory (optional, with constraints and disclaimers), and dependencies.yaml (optional, for external pack dependencies). A minimal pack needs only pack.json and one prompt.

### pack.json Manifest

Each manifest includes pack_id, name (in English and Chinese), version (semver), min/max agent version compatibility, author, description (bilingual), category, skills array (each with id, name, description, trigger keywords, output formats, and complexity), dependencies (pack dependencies, required tools, required models), update channel, install size, and checksum.

### Semver and Dependency Resolution

Packs follow strict semantic versioning: major (breaking changes, requires user approval — Aura asks the user), minor (new skills, backward compatible, auto-update allowed), patch (bug fixes, silent auto-update). The dependency resolution algorithm checks each dependency for installation and version compatibility, recursively fetches missing dependencies, detects cycles using DFS visited set, and installs a compatibility stub if cycles are found. The dependency graph is intentionally kept shallow (max depth: 2).

### Pack Registry

All packs are stored in a private Git repository (GitHub or Gitee mirror). The registry index is a single registry.json containing pack IDs, latest versions, all versions, and compatibility constraints. The provisioning system fetches registry.json at build time, resolves the latest compatible version, and downloads the specific version tarball.

### Skill Definition

Each skill is defined as a markdown file in prompts/ containing trigger keywords (bilingual), system prompts in English and Chinese, output format specification (YAML schema), and guardrails for quality and safety.

### Update Delivery Mechanism

Updates are checked automatically every 7 days (configurable). Downloads are incremental (diff-based, changed files only). Checksums are verified against pack.json. Major updates prompt the user for approval (Aura sends a message: "有一个重要的更新：合同审查技能包增加了新功能。是否更新？"); minor/patch updates are applied silently on next agent launch. Update notifications are delivered in Chinese through the agent's chat interface. Customers do not see version numbers — the agent just gains capabilities over time. When Aura detects that a customer is struggling with a task that a new or updated pack addresses, Aura proactively suggests: "我注意到你经常需要写教案。教师技能包最近更新了教案模板功能，需要我帮你更新吗？"

### Pack Authoring Process

Each pack is authored by a subject-matter expert (a teacher for teacher packs, a lawyer for lawyer packs) paired with a technical writer. The expert provides 10 example tasks, 5 example outputs, and 3 edge cases. The technical writer creates prompt templates following the standard format. The pack is tested against 20 representative queries, versioned, and added to the registry. This model is itself a future revenue stream: domain experts can submit pack proposals and receive 30% revenue share on pack sales.

When a new pack is approved, the pack author also writes a "Pack FAQ" — the top 20 questions customers will ask about this pack, with answers. This FAQ is ingested into Aura's knowledge base automatically, so Aura can answer pack-specific questions from day one.

### Existing Packs

**agent-core:** Core system prompts required by every agent. Prompts: core-system.md, chinese-interface.md, error-handling.md.

**file-operations:** File I/O required dependency. Prompts: file-read.md, file-write.md, format-convert.md, file-search.md.

**teacher-general:** Teacher domain pack with prompts for lesson-planning.md, worksheet-gen.md, grading-rubric.md, parent-comm.md.

**lawyer-contracts:** Lawyer domain pack with prompts for contract-review.md, legal-memo.md, clause-compare.md, compliance-checklist.md.

---

## 7. WeChat Operations & Delivery

### Philosophy

WeChat is not just a distribution channel. It is the operating system of the business. Every customer interaction — acquisition, payment, delivery, support, community, and retention — happens inside WeChat, primarily through Aura. No website, no app, no email. Chinese professionals live inside WeChat. Asking them to leave is asking them to change their behavior.

### Phase 1: Moments Acquisition

Content is produced across three pillars that cover the full acquisition-to-conversion funnel. All content is posted by the founder (months 1–3) and by early customers (month 3+), with Aura distributing and tracking each piece.

**Pillar 1 — "Look what my AI agent just did" (演示视频):** 30–60 second screen recordings showing Hermes completing a real task. The hook is the result — "3 hours of lesson plans done in 20 minutes." Posted to Moments 2–3× per week. This is the highest-converting format.

**Pillar 2 — "Simple AI tips that work with any tool" (AI通用技巧):** Free PDF giveaways with universal AI prompts for ChatGPT, DeepSeek, Claude (not Hermes-specific). Lead magnets: genuinely useful standalone, but hint at what a properly configured agent could do. CTA points to Aura's mini-program. Posted to Moments and the free group 1× per week.

**Pillar 3 — "Behind the build" (幕后揭秘):** WeChat articles and longer content showing how Hermes works, its architecture, and why it costs what it costs. Builds authority that justifies premium pricing. Posted 1× per week.

A "Moments kit" is provided to early users: pre-written posts in Chinese with emojis, a screenshot template, and a referral QR code. Each post is unique to avoid duplicate content penalties. A good post generates 20–50 new group joins. All QR codes link directly to Aura's mini-program.

**This is the only human-driven step in the entire funnel.** The content is human-generated because authenticity matters. The three pillars ensure every post serves a strategic purpose: acquisition (Pillar 2), conversion (Pillar 1), or premium positioning (Pillar 3). Everything after this is Aura.

Conversion from QR scan to survey completion: ~40% (higher than the static form because Aura's conversational onboarding is engaging). Conversion from survey to paid: ~20% (higher because Aura addresses objections naturally during conversation). Effective CAC from organic Moments: ¥0.

### Phase 2: Aura in Free WeChat Group

A free group called "AI for Workplace Efficiency" ("AI提升职场效率") is managed by Aura. Aura has a WeChat Official Account bot that posts daily: AI Tip of the Week on Monday (paired with a PDF giveaway download link — members download a free AI prompt guide with a CTA to start Aura onboarding), case studies on Tuesday, Q&A session on Wednesday (Aura answers questions), industry spotlights on Thursday, Weekend Project on Friday (another PDF drop, different topic), and quiet weekends. PDF giveaways serve as the primary lead magnet — they provide immediate value while subtly priming members for the paid offer. Aura tracks every download and follows up with a private message: "Did the PDF help? I can set up something similar specifically for your work." Aura also sends automated welcome messages on join with a strict no-spam policy.

The group is invite-only via Moments post QR code, capped at 200 members. When a new member joins, Aura sends a personal welcome in the group: "欢迎加入！我是奥拉，你的AI助手。如果你想了解如何用AI提升工作效率，可以随时和我聊聊。" After day 5, Aura sends a private message to each member: "你已经加入群5天了。想试试用AI帮你完成日常工作吗？让我了解一下你的工作情况？" This invites the customer into the onboarding conversation.

### Phase 3: Aura-Guided Payment

The customer clicks the Aura mini-program link (from the group or a referral), and Aura conducts the onboarding conversation. After extracting the customer's requirements and recommending a tier, Aura presents the price and asks for confirmation. The customer confirms via the mini-program, and Aura opens the WeChat Pay native payment sheet — no foreign credit card needed.

The payment flow:
1. Aura confirms recommendation: "根据你的情况，我推荐入门版，¥1,999。包含教师技能包、3个月API使用、以及我的全程指导。要开始吗？"
2. Customer confirms in mini-program
3. Aura presents the disclaimer agreement for signature
4. Customer taps "我已阅读并同意"
5. WeChat Pay sheet opens (fingerprint or passcode)
6. Payment success webhook fires → Aura sends confirmation: "支付成功！正在为你准备专属AI助手。后台准备工作大约需要3分钟，然后我会一步步指导你安装，整个过程大约需要20–30分钟。准备好了吗？"
7. Payment failure → Aura sends retry link and offers help

WeChat credentials are not stored. Receipts are sent automatically by WeChat Pay.

### Phase 4: Aura-Guided Delivery

Once the zip is built (about 3 minutes), Aura sends a WeChat message through the mini-program: "你的AI助手已经准备好了！安装需要20–30分钟，我会陪你一步步完成。准备好了吗？" Aura then guides the customer through:

1. **Download** — "点击这里下载文件（约25MB）。下载完成后告诉我。"
2. **Unzip** — "找到下载的ZIP文件，双击打开。输入密码：你的微信ID后8位。"
3. **Run setup** — "打开解压后的文件夹，双击'安装'文件。如果系统提示安全警告，请告诉我。"
4. **Handle macOS warnings** — "如果出现'无法验证开发者'的提示，请告诉我，我会指导你解决。"
5. **Verify completion** — "安装完成后，你的AI助手应该已经启动了。试试输入'你好'看看有没有回复。"

Each step is interactive — Aura waits for the customer to confirm before proceeding. If the customer gets stuck, Aura provides alternative instructions (e.g., using the terminal as fallback, or a video call as last resort). If the customer does not complete step 1 within 2 hours, Aura sends a follow-up: "安装过程遇到问题了吗？我可以提供更详细的指导。"

### Phase 5: Tier Support Groups

After successful setup, Aura invites the customer to a WeChat group corresponding to their tier. Aura is a member of all groups, answering questions and monitoring sentiment:

- **Starter** — "Hermes 入门交流群" (Starter Group), unlimited size. Aura answers questions in the group. Peer support is encouraged. Aura posts weekly tips automatically.
- **Professional** — "Hermes 专业版用户群" (Pro Group), max 50 members. Aura provides priority responses. Human escalation within 2 hours if Aura cannot resolve.
- **Enterprise** — "Hermes 企业版: {Company Name}", custom size. Aura provides dedicated support with human escalation within 30 minutes.

Aura monitors all group conversations for sentiment. If it detects frustration ("这个怎么用不了" with angry emoji), Aura sends a private message: "我注意到你遇到了问题。让我来帮你解决。" This proactive outreach catches issues before they escalate.

### Phase 6: Referrals (Aura-Managed)

After each successful setup, Aura sends: "恭喜你成功安装！你知道吗，每推荐一位朋友使用Hermes，你们都会获得¥50红包。你的专属推荐链接在这里：..."

Every user has a unique referral link tied to their WeChat ID. When someone purchases through the link:
1. Aura detects the referrer from the link parameter
2. After the new customer's payment succeeds, Aura sends both parties a WeChat Red Packet (¥50 each) within 1 minute
3. Aura sends a thank-you message: "感谢推荐！你和你的朋友各获得了¥50红包。你的推荐链接仍然有效，可以继续分享。"

Aura also runs the referral gamification program: monthly leaderboard posting, VIP Referrer status tracking, and team referral management for Enterprise customers.

### Crisis Management

If Aura detects a complaint in Moments or a large WeChat group (via sentiment monitoring), Aura:
1. Flags the post for human review within 30 minutes
2. Sends a private message to the customer: "我注意到你遇到了一些问题。很抱歉让你不满意。让我来帮你解决。"
3. Attempts resolution through the standard support flow
4. If resolution succeeds, Aura offers compensation (¥100 WeChat Red Packet) and asks if the customer would update their post
5. If resolution fails after 3 attempts, escalates to human

One unresolved complaint in a 200+ group can kill 2 weeks of acquisition. Aura's proactive detection and rapid response minimize this risk.

### Content Calendar Template

The weekly content calendar is managed in a shared markdown file (or Notion) and covers all three pillars across Moments and the free group:

| Day | Channel | Format | Pillar | Topic Example | CTA |
|-----|---------|--------|--------|---------------|-----|
| Mon | Moments | 30s video | Pillar 1 | Agent grades 20 essays in 2 min | Scan to try |
| Tue | Free Group | PDF link | Pillar 2 | "5 Prompts for Teachers" | Download → Aura |
| Wed | Moments | Video testimonial | Pillar 1 | Customer: "Saved me 10 hrs/week" | Join group |
| Thu | Free Group | Article link | Pillar 3 | How a skill pack is built | Questions → Aura |
| Fri | Moments | PDF link | Pillar 2 | "AI Meeting Notes" | Download → Aura |
| Sat | Group Share | 2–5 min video | Pillar 1 | Full walkthrough: contract review | Start onboarding |
| Sun | — | Rest | — | — | — |

Each Monday, the founder (or later, the content contractor) plans the week's 6 pieces. Content is batched: record 3 videos, write 2 PDFs, draft 1 article in a single session. Aura posts on schedule and tracks engagement per piece.

---

## 8. Referral System

### The Core Mechanism

Every customer gets a referral link. When a new customer purchases through that link through Aura's mini-program, the referrer receives ¥50 and the new customer receives ¥50 as a welcome gift. Total cost per successful referral: ¥100 (~$14 USD). Compared to paid acquisition channels (WeChat Moments ads at ¥200–500 per conversion, Baidu SEM at ¥1,000+, KOL sponsorships at ¥5,000–50,000), this is the cheapest acquisition channel by 5–10×. Referred customers have lower support needs and higher satisfaction.

### Why ¥50

¥50 is a specific amount: it is above the Red Packet minimum that feels meaningful (buys a nice lunch, triggers dopamine), below the threshold where the referrer feels like a salesperson, and symmetrical (both parties receive the same amount, preserving peer-to-peer dynamics).

### The Viral Loop

Customer buys Hermes Agent → Aura sends referral link with invitation message → customer posts link in Moments and professional groups → colleague clicks, starts Aura onboarding conversation, pays → Aura detects referrer ID and triggers dual payout → both receive Red Packets simultaneously → Aura tells new customer about their own referral link → loop repeats.

### Incentive Stack

Beyond the direct payout, three additional layers drive referrals:

1. **Leaderboard (gamification):** Monthly top referrers are posted in the support group by Aura. 1st place gets a free upgrade to next tier (3 months), 2nd gets one free skill pack, 3rd gets ¥200 Red Packet.

2. **Stacked rewards:** A customer who refers 5+ people unlocks VIP Referrer status (badge, early access to new packs, direct line to founder for feature requests). Aura tracks this and notifies customers when they level up.

3. **Team referral:** Enterprise customers get enhanced referral — each seat has its own link. If any team member refers someone, the enterprise account gets ¥100 (not ¥50). Aura manages the enterprise pool of referral links.

### K-Factor Estimate

The corrected estimate: 30% of customers send private referrals, averaging 2 sends each, with 60% CTR, and 15% survey-to-paid conversion. This gives 30% × 2 × 60% × 15% = 0.054 referrals per customer. A K-factor of 0.054 means the loop is not self-sustaining — the free WeChat group remains the growth engine. But 5.4 new customers per 100 existing customers at ¥100 CAC is excellent. The referral system is a growth accelerator, not a growth engine.

### Fraud Prevention

Same WeChat ID cannot refer itself (IP + device fingerprint check, enforced by Aura's backend). Refunded purchases void the referral reward. Suspicious patterns (10+ referrals from one account in 24 hours) are flagged for manual review. Referrers must be active customers for 7+ days before earning rewards. Aura handles all fraud checks programmatically.

### Channel Comparison

| Channel | Share Rate | CTR | Trust | Best For |
|---------|-----------|-----|-------|----------|
| Moments | 20% | 3% | Medium | Brand awareness |
| Private message | 30% | 60% | High | Direct conversion |
| Group chat | 15% | 15% | Medium | Niche communities |

The highest-value referral is a private message from a trusted colleague. Aura's referral messaging specifically encourages sharing with trusted colleagues: "把这个链接发给你觉得可能需要的同事，而不是群发。"

---

## 9. Risk & Compliance

### Risk Mitigation

Each risk is assessed on likelihood (1–5) and impact (1–5). The product score (L × I) determines mitigation priority.

**Risk 1: Aura Cannot Resolve Novel Issue (Score: 12)**
Aura's knowledge base may lack coverage for edge cases. Mitigations: graceful escalation protocol (3 attempts → human); continuous learning pipeline populates knowledge base from each escalation; fallback to human with full context preserves customer experience; monthly knowledge base audits identify gaps proactively; Aura signals uncertainty when confidence is low ("我不确定这个问题的答案，让我请教我的同事"), setting appropriate expectations.

**Risk 2: Aura Misleads Customer (Score: 14)**
Incorrect instructions from Aura erode trust. Mitigations: all instructions are generated from verified knowledge base chunks, not free-form; policy enforcer layer checks outputs against guardrails (no medical advice, no financial recommendations, no terminal commands beyond safe set); response confidence scoring — below-threshold responses are rephrased as "我建议你参考这个文档" rather than direct instruction; human review of escalated conversations identifies hallucination patterns.

**Risk 3: API Key Theft or Abuse (Score: 15)**
Key encryption at rest with machine-UUID-derived seed prevents cross-machine use. Rate limiting (100 requests/hour, 1M tokens/month) contains abuse. Daily usage monitoring auto-rotates keys if usage spikes >3× normal. Key pool isolation: Starter keys are shared, Professional keys are dedicated, Enterprise keys are dedicated with no shared pool exposure. Three+ API reseller relationships provide backup. All API calls are proxied through a Hermes-managed relay.

**Risk 4: Great Firewall / Network Restrictions (Score: 12)**
Domestic model fallback (Baichuan, Zhipu, MiniMax, DeepSeek) transparently activates if the primary endpoint fails. Proxy detection in the setup script routes through VPN or domestic endpoints. China-optimized CDN (Alibaba Cloud) ensures fast downloads. Offline mode using Ollama + Qwen2.5 for Custom/Enterprise removes network dependency entirely.

**Risk 5: macOS Version Compatibility (Score: 12)**
Pre-flight check (env_check.sh) validates macOS version, architecture, disk space, and dependencies before setup. Compatibility matrix in each skill pack's pack.json prevents delivery to incompatible systems. Post-update testing within 48 hours of Apple releases. Intel Macs receive a different build (no arm64-specific binaries).

**Risk 6: Scope Creep (Score: 10)**
Clear scope documentation in the delivery zip and Aura's first support message. Aura's support triage starts with "你想完成什么任务？" Community self-policing in support groups.

**Risk 7: Copycats (Score: 12)**
Community moat — real, active, trusted WeChat groups take months to build. Aura's accumulated knowledge base (improves with every interaction) creates a data moat. Skill pack quality from domain experts with real usage refinement. Speed of iteration through direct WeChat delivery. Low price (¥1,999) means low switching incentive but high switching friction. Defensive positioning as a "service with a community" rather than a product. White-label partnership option for copycats in specific professions.

**Risk 8: Customer Data Privacy Concern (Score: 10)**
Privacy disclosure in disclaimer agreement before payment (Aura explains each clause). Aura never asks for sensitive data. Opt-in telemetry only, revocable. Enterprise on-premises deployment using domestic models. Agent system prompt includes privacy reminders.

**Risk 9: Payment Fraud (Score: 6)**
WeChat Pay merchant protection handles most fraud. Aura flags suspicious patterns (multiple purchases from same IP, rapid-fire purchases) for manual review without alarming the customer. Delayed delivery (24-hour hold) for suspicious transactions.

| Risk | Score | Mitigation | Status |
|------|-------|-----------|--------|
| Aura misleads customer | 14 | Verified KB, policy enforcer, confidence scoring | Active |
| API key theft | 15 | Encryption, monitoring, isolation | Active |
| Network restrictions | 12 | Domestic fallback, proxy CDN | Active |
| OS compatibility | 12 | Pre-flight check, matrix testing | Active |
| Aura novel issue | 12 | Escalation protocol, continuous learning | Active |
| Scope creep | 10 | Clear docs, Aura triage | Passive |
| Copycats | 12 | Community moat, data moat, pack quality | Active |
| Data privacy | 10 | Disclosure, opt-in, enterprise option | Active |
| Payment fraud | 6 | Platform protection, Aura flagging | Passive |

The risk register is reviewed monthly by the founder, with input from Aura's escalation logs showing which risks materialized most frequently.

### Compliance and Legal Framework

**Business Registration:** Phase 1 (1–50 customers) operates as a sole proprietor (个体工商户) registered in a startup-friendly jurisdiction (Chengdu or Hangzhou) with a WeChat Pay merchant account. Tax is filed as small-scale taxpayer (小规模纳税人) at 3% VAT. Phase 2 (50+ customers) registers a Limited Liability Company (有限责任公司) in Shanghai or Beijing with ¥100,000 registered capital and business scope covering software development and IT consulting. Phase 3 (500+ customers) considers ICP license and ISO 27001 certification.

**WeChat Pay Compliance:** Requires real-name verified WeChat account, business license, and bank account in the same name. Processing fee: 0.6% per transaction. Single payments have no limit. Red Packets max at ¥200 (¥50 is well within limit). Refunds processed through WeChat Pay merchant dashboard within 3 business days.

**Data Privacy and Security:** Applicable laws include PIPL (China's GDPR), Data Security Law, and Cybersecurity Law. WeChat ID, survey answers, customer name, and WeChat Pay transaction ID are collected and stored on Alibaba Cloud (Shanghai region) — never sold or shared. Conversation content and file contents processed by the agent are not collected by Hermes. Aura conversation logs are stored encrypted with customer-WeChat-ID-derived keys — even Hermes cannot read them without the customer's session. PIPL compliance includes consent checkbox in Aura's disclaimer flow, purpose limitation, data localization, retention for duration of relationship (deleted 180 days after last contact, with customer deletion right), and 72-hour breach notification. Cross-border data transfer to API providers is disclosed to customers; Enterprise/Custom customers can use domestic models only.

**Consumer Protection:** All prices displayed in ¥ inclusive of tax. 7-day full refund policy, no questions asked. Business information visible on WeChat Official Account profile. Invoices provided to Enterprise customers.

**AI-Specific Regulations:** Under the Generative AI Service Management Measures, Hermes does not operate an AI service — it provides a tool connecting users to third-party APIs. Aura is a guided assistant, not a generative AI service aimed at the public. This is a gray area. Conservative approach: register as a Generative AI service provider before 500 customers (2–3 month process). If registered, implement content filtering at the relay proxy using a domestic content moderation API.

**Intellectual Property:** Skill packs written by Hermes are owned by the Hermes entity. Domain expert contributions follow either work-for-hire (¥2,000–5,000 flat fee) or revenue share (30% to expert) models. Customer-created customizations are owned by the customer. "Hermes Agent" trademark registration in China (Class 9 and 42) with fallback names "赫密斯", "信使智能", or "Herme AI" if "Hermes" is blocked. Domain hermes-agent.cn required. Skill pack prompts are copyrightable. Terms of service prohibit redistribution.

**Tax Framework:** Small-scale taxpayer VAT at 3% on revenue. General taxpayer VAT at 6% if invoicing enterprises. Corporate income tax at 25% (0% if loss-making in early months; first ¥1M profit at 2.5% for small enterprises). Founder salary at standard progressive IIT rates (3–45%).

Sample monthly calculation at 20 customers (¥1,999): Revenue ¥39,980, VAT ¥1,199, Net revenue ¥38,781, COGS ¥2,140 (including ¥300 Aura inference), Gross profit ¥36,641, Operating costs ¥11,200 (founder salary ¥10,000, part-time support ¥1,000, infrastructure ¥200), Pre-tax profit ¥25,441, Corporate income tax ¥0, Net profit ¥25,441, Margin 63%.

**Compliance Timeline:** Launch (month 1) — register sole proprietor and open WeChat Pay merchant before first sale. 50 customers — register LLC within 30 days. 200 customers — trademark and domain registration within 60 days. 500 customers — CAC AI service registration (if required). Enterprise deals — ISO 27001 and legal contract review. Ongoing — annual tax filing and business license renewal.

---

## 10. Hiring & Team Build

### Philosophy

Hermes is designed as a lean business. The founder operates everything for the first 3–6 months. **Aura's automation pushes hiring needs 6+ months later than a traditional service business.** Aura handles onboarding, support triage, community management, and referral operations that would require 2–3 full-time support staff in a non-automated model. Hiring is driven by capacity constraints in Aura's escalation lane, not general support volume.

Each hire must pay for themselves within 30 days.

### Role Definitions

**Founder (CEO) — Months 1 to Ongoing:** All operations for months 1–6, with Aura handling most customer-facing work. The founder's time shifts from reactive support to proactive improvement. Time allocation in months 1–6: knowledge base curation 30%, pack development 25%, Aura quality review 20%, content creation (Moments posts) 15%, admin/compliance 10%. By month 6: strategy and partnerships 40%, pack development 30%, Aura performance monitoring 20%, compliance 10%.

**Hire #1: Knowledge Base Engineer — Month 6–8:** Triggered when Aura's escalation rate exceeds 15% consistently or the knowledge base backlog exceeds 50 unresolved patterns. Not a support role — an engineering role focused on making Aura smarter. Responsibilities: analyze escalation logs, write knowledge base articles, improve Aura's diagnostic playbooks, fine-tune Aura's NLU model on new conversation data, and close the loop on each escalation so the same issue never reaches a human again. Salary: ¥15,000–20,000/month. Training: 1 week (shadow Aura conversations, learn knowledge base schema, understand escalation patterns).

**Hire #2: Pack Engineer — Month 8–10:** Triggered when pack development backlog exceeds 10 requests or pack authoring consumes >10 hours/week of founder time. Skilled in prompt engineering, Git, markdown, YAML, JSON. Domain expertise in at least one professional field. Salary: ¥15,000–20,000/month. Responsibilities: author new skill packs, maintain existing packs, manage pack registry, work with domain experts, quality assurance, pack documentation.

**Hire #3: Support Associate (Human Escalation Layer) — Month 10–12:** Triggered when Aura escalates 20+ cases per week to human review. First-line human responder for cases Aura cannot resolve. Reviews escalation transcripts, works with the Knowledge Base Engineer to close knowledge gaps, handles billing disputes and refunds. Salary: ¥8,000–12,000/month. This is deliberately the last hire because Aura should handle 85%+ of all interactions before a human is needed.

### Contractor Network

**Domain Experts (Freelance):** Engaged per pack. Practicing professionals (teachers, lawyers, consultants, accountants) who can articulate workflows and provide example tasks/outputs/edge cases. Payment: ¥3,000–5,000 flat fee (work-for-hire) or 30% revenue share on pack sales. Sourced from the customer base, professional WeChat groups, and industry forums (知乎, Xiaohongshu, Bilibili).

**WeChat Content Creator (Freelance):** Creates short-form content, 30-second demo videos, and case study posts. Payment: ¥500–1,000 per piece or ¥3,000/month retainer for 4 posts/week. Not needed at launch — founder creates all content initially.

### Hiring Sequence and Financial Impact

| Month | Headcount | Additional Monthly Cost | Cumulative Monthly OpEx |
|-------|-----------|------------------------|------------------------|
| 1–6 | 1 (founder) | ¥0 | ¥0 |
| 7 | 2 (+ KB engineer) | ¥17,000 | ¥17,000 |
| 9 | 3 (+ pack engineer) | ¥17,000 | ¥34,000 |
| 11 | 4 (+ support associate) | ¥10,000 | ¥44,000 |
| 12 | 4–6 (+ contractors) | ¥5,000 | ¥49,000 |

Compared to the non-automated model, Aura delays hiring by 3–4 months and reduces total headcount requirement at 12 months from 4 FTE to 3 FTE. At scale (500+ customers), Aura saves 5+ support hires, representing ¥500k–800k annual savings.

### Culture and Values

Zero bullshit with customers — honesty is a differentiator in a market burned by overpromising AI products. Speed is the product — Aura responds in seconds. The terminal is invisible — every employee internalizes this. Aura must be invisible too — the customer should feel guided, not "talk to a bot." Customers teach us the product — the best pack ideas and knowledge base improvements come from Aura's escalation logs. Profitability is freedom — no VC funding, no board pressure, no growth-at-all-costs. Every hire passes the "30-day payback" test.

---

## 11. Launch Plan & Timeline

### Operating Rhythm

With Aura handling the vast majority of operations, the founder's daily rhythm shifts from reactive to proactive:

**Morning check (9:00 AM Beijing time, ~30 minutes):** Review Aura's overnight log (escalations, unresolved issues, sentiment outliers), confirm escalation queue depth (anything waiting > 4 hours), review Aura performance metrics (resolution rate, average conversation length, customer satisfaction), check provisioning pipeline health, and scan Aura's flagged conversations (sentiment < 3.5).

**Mid-day check (1:00 PM, ~15 minutes):** Quick scan of Aura's escalation queue, review new knowledge base entries from overnight learning (Aura's feedback loop generates draft KB articles that need approval), and spot-check 3 random Aura conversations for quality.

**Evening check (6:00 PM, ~15 minutes):** Review daily metrics (new orders, Aura resolution rate, escalations, key pool, referrals, refunds), approve any pending knowledge base articles for publication, and review the top 3 customer questions of the day.

**Weekly responsibilities (Monday, ~60 minutes):** Escalation pattern analysis (which issues hit humans most frequently — each one is a fix that needs to happen), knowledge base coverage audit, Aura model performance review (any drift? any new hallucination patterns?), pack refinement based on recurring questions, and reseller check-in.

**Monthly responsibilities (first Monday, ~120 minutes):** Financial review, business metrics review, Aura's learning progress report (resolution rate trend, escalation trend, top unsolved patterns), pack roadmap planning, price testing analysis, and risk register review.

### Automation Roadmap

| Month | Automation Milestone |
|-------|---------------------|
| 1 | Aura v1 launched — basic onboarding and setup guidance |
| 2 | Aura knowledge base populated with 100+ articles |
| 3 | Diagnostic tunnel integrated — Aura can run remote diagnostics |
| 4 | Continuous learning pipeline active — Aura improves from escalations |
| 5 | Referral tracking automated — Aura manages rewards and leaderboard |
| 6 | Proactive re-engagement — Aura contacts dormant users |
| 7 | Sentiment monitoring — Aura detects and responds to frustration |
| 8 | Self-serve knowledge base — customers can search Aura's KB directly |
| 9 | Fine-tuned Aura model (first iteration on 500+ conversations) |
| 10 | Full dashboard for exception-only intervention |
| 11–12 | Human-in-the-loop only for escalations < 10% volume |

**Content Production Milestones:**

| Month | Content Milestone |
|-------|------------------|
| 1 | Voice cloning reference recorded, 3 PDF lead magnets published, content repository structure created, 3 video demos produced manually |
| 2 | AI script generation pipeline functional, first batch of weekly videos on schedule, content calendar template established, Aura integrated with content distribution (posts links, tracks downloads) |
| 3 | PDF production workflow fully AI-assisted (draft → edit → design → post in 2 hours per PDF), video pipeline automated (record → describe → script → voiceover → assemble), 10+ video demos in library |
| 4 | Content metrics dashboard live (views, shares, joins, conversions per piece), underperforming pillars identified and adjusted, customer testimonial content pipeline active |
| 5+ | Content contractor takes over weekly production, founder reviews only strategy and outlier pieces, full content library at 50+ videos and 20+ PDFs |

The goal is zero daily operations overhead at 200+ customers. The founder's time should shift entirely to pack development, community building, and strategic growth.

### Crisis Protocols

Four crisis scenarios are defined. Aura plays a role in each:

1. **API provider cutoff** — All agents stop working. Aura sends immediate group message ("正在进行网络优化，预计2小时内恢复"), triggers domestic model fallback, messages each reseller. If Aura detects no resolution within 2 hours, it alerts the founder and prepares compensation (¥100 Red Packet to each Enterprise customer).

2. **Negative viral post** — Complaint in large WeChat group or Xiaohongshu with 1,000+ views. Aura detects via sentiment monitoring, flags to founder within 30 minutes, and sends a private message to the poster: "我注意到你遇到了问题。很抱歉。让我帮你解决。" Aura attempts resolution; if it escalates beyond Aura's capability, the founder takes over.

3. **Provisioning system down** — Cannot build new agents. Aura detects pipeline failure and switches to holding mode: "系统正在升级，新订单将在4小时内处理。完成后我会第一时间通知你。" Aura offers to notify the customer when service resumes.

4. **Aura degradation** — If Aura's response accuracy drops below 75% (detected via automated eval suite), Aura automatically switches to "limited mode" — it stops handling complex support and funnels all cases to human review. The founder receives an immediate alert and investigates the model drift or knowledge base corruption.

### Quality Assurance

Every zip file passes six automated checks before delivery: structural integrity (valid CRC, expected directory structure, no empty directories, size < 50 MB), configuration validity (valid YAML, all required fields, valid model, matching skills, non-empty API key), script syntax (bash -n passes for all scripts), skill pack validation (each referenced pack has pack.json, dependencies satisfied, no cycles, at least one prompt, no duplicate skill IDs, no trigger conflicts), Chinese language check (all user-facing files contain Chinese, no English-only errors, Chinese getting-started docs), and smoke test (setup.sh --dry-run passes, agent binary executable, parses config, loads skill pack).

Every 10th delivery is spot-checked manually. Each agent includes diagnose.sh for user-initiated diagnostics, outputting codes from H-OK (all normal) through H-API, H-CFG, H-PACK, H-NET, H-DISK, H-PERM, to H-UNK (unknown, escalate). Diagnostic codes appearing 5+ times in a week trigger a permanent fix.

**Aura-specific QA:** Aura's responses are evaluated weekly against a held-out test set of 100 customer scenarios. Automated evaluation checks: accuracy (does the response match the knowledge base?), safety (no harmful instructions), tone (appropriate for customer state), and completeness (does it answer the question?). A score below 80% triggers a model retraining cycle.

### Quality Targets

| Metric | Target |
|--------|--------|
| Pre-delivery QA pass rate | > 99% |
| User-reported issues within 7 days | < 5% |
| False positive QA (blocked good builds) | < 1% |
| Aura resolution rate | > 85% |
| Aura response accuracy (eval set) | > 90% |
| Pack update failure rate | < 1% |

### Support Standard Operating Procedures (Human Escalation Layer)

Aura handles all first-line support. These SOPs apply only when Aura escalates.

**Escalation triage tree:** Aura's escalation handoff includes the issue category. The human picks up without asking the customer to repeat anything.

**Setup flows (escalated)** cover: unzipped but don't know how to run (confirm MacBook, guide to double-click setup.sh, offer voice call or video link), double-click no response (guide through terminal fallback), macOS security warning (guide through Privacy & Security settings), API key invalid after setup (trigger key rotation from admin dashboard).

**Usage flows (escalated)** cover: agent not responding (check network, run diagnose.sh, interpret diagnostic codes), English responses (switch to Chinese mode, check config), poor quality output (gather specifics, create pack improvement, suggest detailed prompts), can't open files (identify format, recommend tools, convert to preferred format).

**Billing flows (escalated)** cover: refund requests (listen, empathize, attempt resolution, process refund if needed; refund policy: 7-day full refund, 7–30 days pro-rated, after 30 days case-by-case), additional skill pack purchases (¥999 per pack, provision within 30 minutes), API quota exhaustion (offer ¥199/month extension or upgrade recommendation).

**Complaint flow (escalated):** Do not deflect or defend. Acknowledge and listen fully before proposing solutions. Fix the issue including manual work if needed. After resolution, offer apology compensation (skill pack or ¥50 Red Packet). Ask for another chance. If refused, full refund with no hard feelings.

**Re-engagement (Aura-driven):** Inactive users (>14 days) receive an Aura message highlighting new features and offering help. If Aura's re-engagement fails 3 times, the customer is flagged as "disengaged" and no further messages are sent for 90 days.

### Aura Feedback Loop Quick Reference

```
Customer issue → Aura attempts resolution
    ├── Resolved → Log success → Improve similar pattern weight
    └── Unresolved → Log failure → Try alternative approach
        ├── Resolved → Log success → Add alternative to KB
        └── After 3 failures → Escalate to human
            ├── Human resolves → Human writes KB article → Aura ingests
            └── Human cannot resolve → Flag as product gap → Prioritize in roadmap
```

---

*This document is a compilation of the complete Hermes Agent business architecture, with deep automation embedded in every layer. It is a living artifact — all sections are reviewed and updated monthly based on operational experience, market feedback, Aura's learning data, and risk register reviews.*

---

## 12. Content Production Strategy

### 12.1 Philosophy

Content on WeChat serves two functions: (1) top-of-funnel acquisition — attracting new members to the free group, and (2) trust building — demonstrating competence so members convert to paying customers. Unlike the rest of the business, content production is intentionally NOT fully automated. Authenticity drives conversion in Chinese social commerce. AI assists the pipeline, but a human reviews every piece before posting. The three content pillars (defined in §7) ensure every piece of content serves a deliberate strategic function.

### 12.2 Freebie PDFs (Lead Magnets)

Each PDF is a self-contained lead magnet that provides immediate value with any AI tool (ChatGPT, DeepSeek, Claude — not Hermes-specific) while hinting at what a properly configured agent can do.

**Template:**
- **Title** — Benefit-driven, specific: "5 AI Prompts That Save Teachers 2 Hours a Week"
- **Length** — 5–8 pages, skimmable with bullet points and bolded prompts
- **Structure** — 5 copy-paste-ready prompts, each with: prompt text, what to expect, before/after example
- **Tone** — Practical, not technical. "Here's what to type, here's what you get."
- **Design** — WeChat-optimized vertical layout, clean typography, brand colors
- **CTA** — Last page: "Want these prompts set up automatically on your computer? Join our WeChat group for the full setup." QR code to Aura's mini-program

**Initial PDF Titles:**

1. **"5 AI Prompts That Save Teachers 2 Hours a Week" (教师版)**
   — Lesson plan drafts, worksheet generation, parent email templates, quiz creation, progress report writing. CTA: teacher-specific Hermes skill pack setup.

2. **"How to Use AI to Draft Client Emails in 30 Seconds" (职场版)**
   — Cold outreach, follow-up, meeting confirmation, status update, difficult conversation templates. CTA: professional Hermes skill pack setup.

3. **"AI-Powered Meeting Notes: From Recording to Action Items" (通用版)**
   — Meeting transcription prompts, summary extraction, action item generation, follow-up drafting. CTA: universal Hermes setup.

These PDFs work standalone — a reader gets immediate value without buying. Each one hints at the paid offer: "Imagine never typing another prompt — your AI just knows what your job needs." The CTA bridges from free value to paid setup.

**Production workflow:**
1. Identify topic from group Q&A patterns (what do people ask most?)
2. AI drafts PDF content (Claude or DeepSeek) from a structured brief
3. Human edits for accuracy, Chinese naturalness, and tone
4. Design in Canva (vertical WeChat-optimized layout)
5. Upload to WeChat CDN — Aura posts link in free group and Moments
6. Aura tracks downloads (unique link per PDF) and sends follow-up: "Did the PDF help? I can set up a version that works automatically for your specific job."
7. Monthly review: which PDF drives most group joins? Highest conversion rate? Lowest? Topics that underperform are replaced.

### 12.3 AI Video Production Pipeline

The founder does NOT appear on camera. Every video is screen recording + AI voiceover + captions.

**Step-by-step workflow:**

```
1. RECORD SCREEN → OBS Studio (free) or QuickTime (built-in)
       │
2. DESCRIBE → 2-3 sentences from the human: what happened, what the agent did, the result
       │
3. AI WRITES SCRIPT → DeepSeek (free, already set up)
       │
4. AI VOICEOVER → ElevenLabs (~$5/mo) — clone voice once from 3-min recording, then generate any script
       │
5. ASSEMBLE → Descript (~$30/mo) — import screen recording + voiceover, auto-captions, edit by editing text
       │
6. EXPORT MP4 → Post to WeChat Moments
```

**Tools & cost:**

| Tool | Purpose | Cost |
|------|---------|------|
| OBS Studio / QuickTime | Screen recording | $0 |
| DeepSeek | Script generation | $0 |
| ElevenLabs | AI voiceover (cloned voice) | $5/mo |
| Descript | Video assembly + captions | $30/mo |
| **Total** | | **~$35/mo** |

Time per video: ~20–30 minutes after voice is cloned.

**Voice cloning setup (one-time, ~3 minutes):**
1. Founder records 3 minutes of reference audio: reading a script in their natural speaking voice
2. Audio is uploaded to ElevenLabs to train a custom voice model
3. After cloning, no further recording is needed — every script is generated from text
4. Every video description includes: "配音由AI生成，内容经本人审核" (Voiceover generated by AI, content reviewed by the person)

**Production batching (recommended):** One weekly production session produces 3 videos. Founder records 3 demos back to back, describes them, AI generates all scripts, all voiceovers, then assembly. Total time: ~2 hours for 3 finished videos.

### 12.4 Content Repository Structure

All raw materials and finished assets organized under a single project directory:

```
/content-library/
├── raw-footage/               # Original screen recordings, unedited
│   ├── 2026-05/
│   ├── 2026-06/
│   └── ...
├── scripts/                   # AI-generated + human-edited scripts
│   ├── drafts/
│   ├── final/
│   └── voiceover-scripts/     # Scripts exactly as read for TTS
├── voiceovers/                # AI-generated audio files
│   ├── raw/                   # Directly from TTS, before timing adjust
│   └── final/                 # Cleaned and synced to video timeline
├── videos/                    # Finished exported MP4s
│   ├── moments/               # 30s cuts for WeChat Moments
│   ├── group/                 # 2–5 min full versions for group shares
│   └── articles/              # Versions embedded in WeChat articles
├── pdfs/                      # Lead magnet PDFs
│   ├── designs/               # Canva source files (.canva or PDF)
│   ├── drafts/                # AI-generated draft text
│   └── final/                 # Exported PDFs ready to distribute
├── articles/                  # WeChat article drafts and finals
│   ├── drafts/
│   └── published/             # Final text + any embedded media references
├── assets/                    # Reusable brand assets
│   ├── bumper-intro.mp4       # 5s branded intro
│   ├── bumper-outro.mp4       # 5s branded outro with CTA
│   ├── logo.png
│   ├── logo-white.png
│   └── fonts/                 # Brand fonts for Canva designs
└── calendar/                  # Weekly content calendar
    ├── 2026-05.md
    ├── 2026-06.md
    └── template.md            # Blank weekly template
```

**Naming convention:** `YYYY-MM-DD_pillar_{1|2|3}_topic-description_lang`. Example: `2026-05-26_pillar1_teacher-grades-20-essays_zh.mp4`.

**Retention policy:** Raw footage and drafts: 90 days, then archived to cold storage. Final videos and PDFs: kept indefinitely. Voice cloning reference audio: backed up offline + one cloud copy. Calendar files: kept for 1 year for quarterly pattern analysis.

### 12.5 Content Metrics & Measurement

Every content piece is tracked through the full funnel from initial view to paid conversion.

| Metric | Definition | Target | Tracking Method |
|--------|-----------|--------|-----------------|
| Views | Number of Moments views or video plays | > 500 per post | WeChat native analytics |
| Shares | Times a Moments post or video is forwarded | > 20 per piece | WeChat native share count |
| Group joins | New members who joined the free group from a specific piece | > 10 per piece | Aura tracks join source (unique QR/link per piece) |
| PDF downloads | Link clicks on a specific PDF | > 50 per PDF | WeChat CDN analytics per link |
| Survey starts | Free group members who start Aura's onboarding survey | > 30% of joiners | Aura tracks entry point |
| Paid conversions | Purchases attributed to a specific content piece | > 5% of survey starts | Aura referral tracking per content link |
| Cost per piece | Time cost (founder or contractor hours) + tool cost (TTS, AI) | < ¥200 | Manual time tracking |
| CVR (join→pay) | Percentage of group joiners who become paying customers | > 2% | Aura funnel tracking |

**Attribution system:**
- Every content piece carries a unique QR code or WeChat link parameter
- Aura logs the entry point for every new conversation: `source: pillar1_2026-05-26_teacher-essays`
- Monthly content audit: which pillar drives the most joins? Which PDF shows highest conversion? Which video format generates most shares?
- Data feeds back into the content calendar — underperforming pillars are adjusted or replaced. If Pillar 3 (Behind the Build) generates views but zero conversions after 8 weeks, it is replaced with a new format (e.g., customer interview clips).

**Funnel stages by content maturity:**

| Phase | Timeline | Focus Metric | Target |
|-------|----------|-------------|--------|
| Launch | Weeks 1–4 | Views, shares, group joins | 5–10 joins/week from content |
| Growth | Weeks 5–12 | Survey starts, paid conversions | 3–5 paid customers/month from content |
| Scale | Month 4+ | Cost per acquisition, CVR optimization | < ¥100 CPA through content |

(End of file)
