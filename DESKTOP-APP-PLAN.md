# Lingxi Hermes Agent — Desktop GUI Application Architecture Plan

## Table of Contents

1. [Tech Stack Recommendation](#1-tech-stack-recommendation)
2. [Application Structure](#2-application-structure)
3. [Setup & Installation Flow](#3-setup--installation-flow)
4. [GUI Pages / Screens](#4-gui-pages--screens)
5. [Agent Process Management](#5-agent-process-management)
6. [File Structure](#6-file-structure)
7. [Update System](#7-update-system)
8. [Security Considerations](#8-security-considerations)

---

## 1. Tech Stack Recommendation

### Candidate Comparison

| Criterion | Electron | Tauri | Flutter Desktop | PyQt/PySide |
|-----------|----------|-------|-----------------|-------------|
| Bundle size | 150–200 MB | 5–10 MB | 20–30 MB | 30–50 MB |
| Shell subprocess mgmt | Node.js `child_process` | Rust `std::process` (superior) | Platform channel bridge | Python `subprocess` |
| Native look & feel | Web-in-window | System WebView (native) | Skia-rendered (close to native) | Native Qt widgets |
| Chinese ecosystem familiarity | Very high (WeChat DevTools, DingTalk, Feishu all use Electron) | Low (growing, but few Chinese reference apps) | Moderate (some Chinese Flutter apps) | Low (few modern apps) |
| Cross-platform Mac→Windows | Mature | Mature (Windows good, Mac excellent) | Beta-quality on desktop | Mature but painful to package |
| Auto-update | Mature (`electron-updater`) | Mature (`@tauri-apps/plugin-updater`) | None built-in | None built-in |
| Memory footprint | High (Chromium) | Low (system WebView) | Medium | Medium |
| Rust learning curve | None | Team must learn Rust | None | Already know Python |

### Recommendation: **Tauri**

**Rationale:**

1. **Bundle size wins the decision.** Hermes delivers via WeChat file transfer. A 5 MB app vs 150 MB is the difference between "downloads in 10 seconds" and "用户需要等5分钟." The BUSINESS-PLAN explicitly calls out download size as a friction point and targets optimization for Chinese internet conditions (GFW, slow mirrors, mobile hotspot). A 5 MB Tauri app respects this constraint. An Electron app violates it.

2. **Rust backend is the correct substrate for process management.** The desktop app's primary job is to spawn, monitor, restart, and communicate with a Python child process (Hermes agent). Rust's `std::process` gives us reliable PID tracking, signal handling (SIGTERM with timeout → SIGKILL), and zero-overhead stdin/stdout pipes. Node.js `child_process` is adequate for short-lived processes but shows edge cases with orphaned children, zombie processes, and pipe buffer deadlocks in long-running daemons. Rust eliminates an entire class of "agent stopped responding" bugs at the architecture level.

3. **System WebView delivers native feel without the Chromium tax.** On macOS, Tauri uses WKWebView (Safari). On Windows, it uses WebView2 (Edge Chromium). Both are already installed on the user's machine. The UI renders with native font rendering, native scroll behavior, and native text selection. For Chinese users, this means proper CJK character rendering, IME input method compatibility (critical for Chinese chat input), and no Chromium memory overhead. The app feels like a Mac app, not a web page in a frame.

4. **The Chinese ecosystem gap is real but manageable.** Few Chinese desktop apps use Tauri today. However, this is a greenfield app — there is no legacy code to integrate. The frontend can use any web framework (React, Vue, Svelte) for the UI, which is the same development experience as Electron. The Rust backend requires a different skill set, but the backend surface is narrow (process manager, file I/O, IPC bridge, update checker) and well-defined. A single Rust developer can own and maintain it.

5. **Auto-update is solved.** Tauri's updater plugin works with S3, GitHub Releases, or any static file server. Incremental downloads via `.tar.gz` patches keep updates under 2 MB. This aligns with the BUSINESS-PLAN's skill pack update mechanism (diff-based, automatic).

### Frontend Framework: **React + TypeScript + Tailwind CSS**

- React is the most widely known web framework; finding Chinese-speaking React developers is easy.
- Tailwind CSS keeps the bundle small (no heavy component library).
- The chat interface benefits from React's virtual DOM for smooth message rendering.
- TypeScript catches class of bugs before they reach users who cannot file bug reports easily.

### Additional Toolchain

| Layer | Choice | Reason |
|-------|--------|--------|
| Frontend | React 18+ + TypeScript + Tailwind CSS | Developer availability, bundle efficiency |
| State management | Zustand (lightweight, no boilerplate) | Simpler than Redux, sufficient for this scope |
| IPC bridge (UI ↔ Rust) | Tauri `invoke` + event system | Built-in, type-safe with `@tauri-apps/api` |
| Rust IPC protocol | JSON-line over stdin/stdout to agent | Human-readable, easy to debug, no binary protocol |
| Bundler | Vite (via Tauri CLI) | Fastest HMR, native ESM, best Tauri integration |
| Desktop packaging | Tauri CLI + `.dmg` (macOS) → `.msi` (Windows) | Native installers per platform |

---

## 2. Application Structure

### High-Level Architecture

```
┌─────────────────────────────────────────────────────┐
│                    Tauri Window                      │
│  ┌─────────────────────────────────────────────────┐│
│  │              WebView (React UI)                  ││
│  │  ┌──────┐ ┌───────┐ ┌──────┐ ┌──────────┐      ││
│  │  │Page 1│ │Page 2 │ │Page 3│ │  Page 4  │ ...  ││
│  │  └──────┘ └───────┘ └──────┘ └──────────┘      ││
│  │         Zustand store (shared state)             ││
│  └─────────────────────────────────────────────────┘│
│                          │ IPC (invoke / events)      │
│  ┌─────────────────────────────────────────────────┐│
│  │             Rust Backend (Tauri)                 ││
│  │  ┌──────────┐ ┌──────────┐ ┌────────────────┐  ││
│  │  │ Process  │ │  Config  │ │ Update/Install │  ││
│  │  │ Manager  │ │  Store   │ │ Engine         │  ││
│  │  └────┬─────┘ └──────────┘ └────────────────┘  ││
│  │       │ stdin/stdout                             ││
│  │       ▼                                          ││
│  │  ┌──────────┐                                    ││
│  │  │ Hermes   │ (Python child process)             ││
│  │  │ Agent    │                                    ││
│  │  └──────────┘                                    ││
│  └─────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────┘
```

### Layer Responsibilities

**WebView (React UI) — Presentation only.**
- Renders all screens (wizard, dashboard, chat, settings, skill manager).
- Maintains transient UI state (which page is open, scroll position, form input state).
- Sends commands to Rust via `invoke()` (blocking request-response).
- Listens for events from Rust via `listen()` (streaming data, agent status changes).
- Never directly touches the filesystem, spawns processes, or reads agent state.
- Stores no secrets — API keys live in Rust's encrypted config store, never in the DOM.

**Rust Backend — Trusted controller.**
- **Process Manager:** Spawns, monitors, restarts, kills the Hermes Python process. Sends heartbeat pings. Emits `agent-status-changed` events. Holds a `HashMap<Pid, ProcessState>`.
- **Stdio Bridge:** Writes JSON messages to Hermes stdin; reads JSON messages from Hermes stdout. Handles line buffering, backpressure, and pipe errors. Maps agent responses to `agent-message` Tauri events for the UI.
- **Config Store:** Reads/writes `~/.lingxi/config.toml` (encrypted API keys, user preferences, window state). Encryption uses platform keychain (macOS Keychain via `security` framework, Windows Credential Manager via winapi).
- **Update Engine:** Checks registry for new agent versions and skill pack updates. Downloads diffs, verifies checksums, applies updates. Emits `update-available` and `update-progress` events.
- **Auto-Start Service:** Manages launchd plist (macOS) / Task Scheduler (Windows) entries. Toggle on/off from settings.

### Data Flow — Chat Interaction

```
User types message in chat input
  → React state updates (optimistic UI, show "sending...")
  → invoke("send_message", { text: "你好" })
    → Rust serializes { type: "user_message", text: "你好" }\n
    → Writes to Hermes agent stdin (non-blocking)
      → Agent processes and writes response to stdout
    → Rust reads line from agent stdout (async reader task)
    → Parses JSON: { type: "agent_message", text: "...", done: false }
    → Emits event("agent-message", parsed)
      → React listens, appends to message list
    → Repeat until done: true
  → invoke() resolves when agent signals completion
```

Streaming responses (agent typing in real-time) use Tauri events, not `invoke`. The Rust backend emits a stream of `agent-token` events as the agent generates output. React accumulates them into the message bubble. This gives a natural "typing" feel.

### Data Flow — Agent Lifecycle

```
App launches
  → Rust reads config, checks if agent was running on last quit
  → If auto-start enabled: Process Manager spawns agent
  → Emits "agent-status-changed" { status: "starting" | "running" | "stopped" | "error", pid?, uptime? }
  → UI updates dashboard indicator

App quits
  → Rust sends SIGTERM to agent process (graceful shutdown, 5s timeout)
  → If agent still alive after 5s: SIGKILL
  → Saves process state to config (was running / was stopped)
  → Window closes
```

### State Machine — Agent Process

```
  ┌──────────┐   spawn   ┌──────────┐   health check OK   ┌──────────┐
  │ STOPPED  │ ────────→ │ STARTING │ ──────────────────→ │ RUNNING  │
  └──────────┘           └──────────┘                     └──────────┘
       ↑                      │                                │
       │                      │ spawn fails                    │ process dies
       │                      ▼                                ▼
       │                  ┌──────────┐                    ┌──────────┐
       │                  │  ERROR   │ ←─── crash ─────── │ CRASHED  │
       │                  └──────────┘                    └──────────┘
       │                       │                               │
       └───────────────────────┘ user clicks "Restart" ───────┘
```

- Crashed → auto-restart (up to 3 attempts, exponential backoff: 1s, 5s, 30s).
- After 3 crashes within 10 minutes, move to ERROR and notify user.
- User can manually restart from ERROR at any time.

---

## 3. Setup & Installation Flow

### Phase 1: App Download & First Launch

1. User downloads `.dmg` from WeChat link (or a CDN link provided by Aura).
2. User drags app to Applications folder (standard macOS).
3. On first launch, macOS Gatekeeper warning appears — the app includes a guide in the UI to handle this.
4. App starts → detects no config → shows Welcome screen.

### Phase 2: Welcome Screen

Two paths presented with equal visual prominence:

**Path A: "我已经在微信上填过信息了" (I already set up on WeChat)**
- User selects the onboarding JSON file downloaded from Aura's mini-program.
- App validates JSON schema, extracts: profession, tier, skill pack selections, API key hint (partial).
- Progress: skips directly to API key setup (Phase 4).

**Path B: "我是第一次使用" (I'm new, guide me through)**
- Multi-step wizard mirrors the mini-program onboarding.
- Steps: profession → pain points → tier recommendation → skill pack selection → computer type.
- At the end, generates the same JSON that the mini-program would produce.
- User can save this JSON and also send it to their phone.

### Phase 3: Environment Check (Rust backend)

After onboarding data is loaded, Rust runs pre-flight checks:

| Check | Pass Condition | Failure Handling |
|-------|---------------|------------------|
| OS version | macOS ≥ 12 (Monterey) | Show error with next steps |
| Architecture | arm64 or x86_64 | Adjust agent binary download |
| Disk space | > 500 MB free | Warn user, offer to locate temp dir on external drive |
| Python 3 | `python3 --version` ≥ 3.10 | Offer to install via `brew` or official installer |
| Git | `git --version` | Offer to install via Xcode CLI tools |
| Network | Can reach registry / GitHub | Allow offline mode with cached skills |
| Rosetta 2 (if Intel binary on Apple Silicon) | `arch -x86_64 true` | Offer to install Rosetta 2 |

Each check shows a green checkmark or a red X with a "Fix it" button. Progress persists across app restarts.

### Phase 4: API Key Setup

1. UI shows: "需要一个大模型API密钥才能使用。推荐使用 DeepSeek（国内可用，性价比高）。"
2. User clicks "如何获取密钥？" (How to get a key?) → in-app guide with screenshots walks through DeepSeek signup → create API key → copy key.
3. User pastes key → Rust stores it encrypted in macOS Keychain.
4. Rust runs a test: sends a simple request (e.g., "请回复'连接成功'") to the API.
5. If test passes: green checkmark, proceed.
6. If test fails: show error message with troubleshooting steps (check balance, check key permissions, try different endpoint).

### Phase 5: Hermes Installation

Rust backend handles all of this. UI shows a progress stepper with status messages in Chinese.

1. **Create workspace:** `~/lingxi/agent/`
2. **Clone/fetch Hermes:** If `~/lingxi/agent/` exists and is valid, run `git pull`. If not, `git clone` from the registry mirror (Gitee preferred for China, GitHub fallback with proxy).
3. **Create venv:** `python3 -m venv venv`
4. **Install dependencies:** `venv/bin/pip install -r requirements.txt` (with `--no-index --find-links ./vendor` if vendor directory exists, to avoid GFW issues).
5. **Write config:** Rust generates `config.yaml` from onboarding data + API key reference. Agent-specific configurations (skill pack selections, model settings, Chinese interface flag).
6. **Install skill packs:** Download packs from registry, unpack to `~/lingxi/skills/`, verify checksums, generate manifest.
7. **Verify installation:** Run `python3 -c "from hermes import core; print('OK')"` (or equivalent smoke test). If this fails, show error log and offer to retry.

Each step shows: a spinner (in progress), green checkmark (done), or red X with retry button (failed). User cannot proceed until all steps pass.

### Phase 6: First Launch

1. Rust spawns Hermes agent as a child process.
2. Sends an init message: `{ "type": "init", "config": "..." }` via stdin.
3. Agent responds with `{ "type": "ready", "version": "0.1.0" }`.
4. UI transitions from wizard to Chat interface.
5. Agent sends a welcome message: "你好！我是你的Hermes智能助手。有什么可以帮你的？"
6. Auto-start prompt appears: "是否希望开机自动启动Hermes？" (Would you like Hermes to start automatically when your computer starts?) — Yes / Not now.

### Phase 7: Setup Complete

- Wizard hides permanently (config flag `setup_completed: true`).
- App launches into Dashboard by default on subsequent starts.
- User can revisit wizard settings via Settings → Re-run setup.

---

## 4. GUI Pages / Screens

### 4.1 Welcome / Setup Wizard

A multi-step, linear wizard. No sidebar or navigation chrome — full-screen focus.

Visual style: Clean cards, large Chinese text, progress dots at top. Warm brand colors. Encouraging tone in all copy.

**Steps:**

1. **Welcome** — App logo, "欢迎使用Hermes智能助手", two buttons (Import / New setup).
2. **Profession** (if new) — Icon-based profession selector (教师, 律师, 市场营销, 程序员, 其他).
3. **Details** (if new) — Free-text questions: "你平时花时间最多的三项工作是什么？" "你使用什么电脑？" "你之前用过AI工具吗？"
4. **Tier** (if new) — Tier cards with pricing, features comparison. Selected tier highlights.
5. **API Key** — Paste field + "如何获取密钥？" collapsible guide + Test button.
6. **Environment Check** — Animated progress list (see Phase 3 above). Each check animates in sequentially.
7. **Installing** — Progress bar with status updates (Cloning... Installing dependencies... Configuring skills...).
8. **Ready** — Success animation, "一切就绪！", button to open chat.

State persistence: Wizard state saved to `~/.lingxi/wizard_state.json`. If app crashes mid-setup, it resumes from the last completed step on next launch.

### 4.2 Dashboard

Main landing page after setup. Layout: sidebar (compact navigation) + main content area.

**Sidebar navigation:**
- Dashboard icon
- Chat icon (with notification badge for unread)
- Skills icon
- Settings icon
- Log viewer toggle (small icon in bottom-left corner)

**Dashboard content:**
- **Agent status card:** Large indicator dot (green = running, red = stopped, yellow = starting). "运行中" / "已停止" text. Start/Stop button. Uptime display.
- **Quick stats row:** "今日消息数" (Today's messages), "本月使用量" (Monthly usage), "技能包数" (Installed skills).
- **Recent interactions panel:** Last 5 chat sessions with timestamps and first few words. Click to open in Chat.
- **Update notification banner** (if available): "Hermes有新版本可用，点击更新" with update button.
- **Quick action buttons:** "开始对话" (Start chat), "管理技能" (Manage skills), "检查更新" (Check for updates).

### 4.3 Chat

Primary interaction surface. Full-height, no scroll on page level — only the message list scrolls.

**Layout:**
- **Header:** Agent name "Hermes智能助手" with status dot + model info dropdown (current model, e.g., "DeepSeek V3").
- **Message list:** Vertically scrollable. Messages alternate: user (right-aligned, brand color bubble) / agent (left-aligned, gray bubble). Timestamps on hover.
  - Agent messages support Markdown rendering (code blocks with copy button, tables, links, bullet lists).
  - Loading indicator (three dots animation) while agent is generating.
  - Streaming incremental updates — text appears as agent generates it.
- **Input area:** Bottom-fixed. Textarea (auto-grows to 4 lines max) + Send button (keyboard shortcut: Enter). File attachment button (attachments sent to agent for processing — documents, images if model supports vision).
- **Context panel (collapsible):** Right-side drawer showing current conversation metadata — conversation ID, token count, attached skills, system prompt summary.

**Conversation management:**
- Chat sidebar (toggleable): list of past conversations with search.
- New conversation button: clears context, starts fresh.
- Conversation export button: saves as Markdown or JSON.

**Technical note on streaming:** Rust reads agent stdout line by line. Each line is a JSON object with `type: "token"` for streaming tokens or `type: "message"` for complete messages. The Rust backend emits Tauri events for each token. React accumulates tokens into the current message bubble. This avoids blocking the IPC channel on long responses.

### 4.4 Settings

**Tabs:**

1. **General** — Theme (浅色 / 深色 / 跟随系统), Language (中文 / English), Font size (小 / 中 / 大).
2. **API Keys** — List of configured keys with provider name, masked key preview, test button, delete button. "添加密钥" button to add a new key. Usage stats per key (tokens used this month).
3. **Model** — Default model selection (dropdown), temperature slider, max tokens slider. Advanced: custom API endpoint URL.
4. **Startup** — Toggle "开机自动启动Hermes" (Launch at login). Toggle "启动时自动运行Agent" (Start agent on app launch). Toggle "后台运行时保持Agent运行" (Keep agent running when window closed).
5. **Agent** — Agent version display with "检查更新" button. Agent configuration path (read-only, copy button). Reset agent data button (destructive, double-confirm).
6. **About** — App version, build number, licenses, "检查更新" button, feedback link.

### 4.5 Skill Manager

**Installed skills view:**
- Grid of skill pack cards. Each card shows: pack icon, name (Chinese), version, description (one line), status (active / update available / error).
- Click card → detail panel: full description, included skills list (with trigger keywords), version history, update channel, "卸载" (Uninstall) button.
- "检查更新" button at top — checks registry, shows update count badge.

**Install new pack:**
- "浏览技能商店" button → opens modal with pack registry browser.
- Packs listed with name, author, rating (hypothetical), size, price (if paid).
- "安装" button → downloads, verifies, installs, shows confirmation toast.
- Search bar filters packs by name/description.

**Update flow:**
- If updates available, badge appears on Skill Manager nav icon.
- "全部更新" (Update All) button or per-pack update.
- Progress modal: downloading → verifying → installing → restarting agent.
- After update, agent restart is automatic (Rust sends SIGTERM, waits for agent to acknowledge, relaunches).

### 4.6 Log Viewer

Hidden behind a small icon in the sidebar bottom corner. Not visible in normal operation — the user should never need it. But when they do, it's one click away.

- Scrollable, monospace, timestamps, log levels (color-coded: INFO green, WARN yellow, ERROR red, DEBUG gray).
- Filter by level: dropdown (All / INFO / WARN / ERROR / DEBUG).
- Search bar: filter log lines by text.
- Copy button: copy entire log to clipboard.
- Auto-scroll toggle: follow new logs.
- Log retention: last 10,000 lines in memory, rotated to `~/.lingxi/logs/app.log` (max 10 MB, rotated daily).
- Clear button: clear log display and rotate log file.

Log source: Rust backend stdout/stderr, agent process stdout/stderr merged. Timestamps added by Rust before emitting to UI.

---

## 5. Agent Process Management

### Process Spawning

```rust
// Conceptual architecture, not implementation
// HermesAgentManager is a long-lived singleton in Tauri's managed state

HermesAgentManager {
    process: Option<Child>,
    stdin: Option<ChildStdin>,
    status: AgentStatus,        // Stopped | Starting | Running | Crashing | Error
    crash_count: u8,            // resets after 10 minutes of stable uptime
    last_crash_time: Instant,
    heartbeat_timer: Timer,
    stdout_reader: JoinHandle<()>,
}
```

Spawn strategy:
- Working directory: `~/lingxi/agent/`
- Command: `./venv/bin/python3 -m hermes.agent --stdio`
- Environment: `PATH`, `PYTHONPATH`, `HERMES_CONFIG_DIR=~/lingxi/`, `HERMES_LOG_LEVEL=info`
- Stdio: piped (stdin for commands, stdout for responses, stderr merged with stdout for logging)
- Process group: set process group ID so killing the group kills all children.

### Communication Protocol

JSON-line protocol over stdin/stdout:

**App → Agent (stdin):**
```json
{ "type": "chat", "text": "你好", "conversation_id": "uuid" }
{ "type": "system", "command": "reload_skills" }
{ "type": "system", "command": "status" }
{ "type": "system", "command": "shutdown", "reason": "user_quit" }
```

**Agent → App (stdout):**
```json
{ "type": "token", "text": "你", "done": false }
{ "type": "token", "text": "好", "done": false }
{ "type": "message", "text": "你好！有什么可以帮你的？", "done": true }
{ "type": "status", "status": "ready", "version": "0.1.0" }
{ "type": "error", "code": "API_ERROR", "message": "..." }
{ "type": "heartbeat", "timestamp": 1234567890 }
```

### Heartbeat & Health Check

- Agent sends heartbeat every 30 seconds over stdout.
- Rust enforces a 90-second timeout. If no heartbeat received:
  1. Send SIGTERM to process.
  2. Wait 5 seconds.
  3. If still alive, send SIGKILL.
  4. Increment crash counter.
  5. If crash counter < 3, restart with exponential backoff (1s, 5s, 30s).
  6. If crash counter ≥ 3 within 10 minutes, set status to ERROR, notify user.
- Crash counter resets to 0 after 10 minutes of continuous uptime.

### Shutdown Sequence

1. User quits app (or closes window if "keep running in background" is off).
2. Rust sends `{ "type": "system", "command": "shutdown" }` to agent via stdin.
3. Rust sends SIGTERM.
4. Rust waits up to 5 seconds for process to exit.
5. If process still alive, sends SIGKILL.
6. Rust writes final state to config: `last_agent_status: running | stopped`.
7. App exits.

### Crash Recovery

- Auto-restart with backoff as described above.
- When agent restarts after crash, Rust sends a system message to reinitialize: `{ "type": "system", "command": "load_skills" }` and `{ "type": "system", "command": "restore_conversation", "id": "..." }`.
- UI shows a notification: "Agent已重新启动" (Agent has restarted) with a dismiss button.
- If crash happened during chat, the conversation is preserved up to the last complete message pair.

### Architecture Decision: Why Not Systemd / Launchd

We deliberately manage the agent process inside the Tauri Rust backend rather than installing it as a system service (launchd on Mac, systemd on Linux). Reasons:
- The user should be able to start/stop the agent from the GUI without touching system preferences.
- The agent lifecycle is tied to the app lifecycle in a way that system services cannot express (auto-start on app launch, stop on app quit, keep running in background toggle).
- Crash recovery with exponential backoff and user notification is simpler in Rust's process manager than in launchd.
- No need for sudo/admin privileges for process management.

---

## 6. File Structure

### Desktop App Project

```
desktop/
├── src-tauri/                      # Rust backend (Tauri core)
│   ├── src/
│   │   ├── main.rs                 # Entry point, Tauri builder, plugin registration
│   │   ├── commands.rs             # Tauri command handlers (IPC surface)
│   │   ├── agent/
│   │   │   ├── mod.rs
│   │   │   ├── manager.rs          # HermesAgentManager — spawn, kill, health check
│   │   │   ├── protocol.rs         # JSON-line message types, serialization
│   │   │   └── stdio_bridge.rs     # Async stdin/stdout reader/writer tasks
│   │   ├── config/
│   │   │   ├── mod.rs
│   │   │   ├── store.rs            # Config read/write, keychain integration
│   │   │   └── migration.rs        # Config schema migration between versions
│   │   ├── installer/
│   │   │   ├── mod.rs
│   │   │   ├── env_check.rs        # Pre-flight environment validation
│   │   │   ├── python.rs           # Python detection, venv management
│   │   │   ├── clone.rs            # Git clone / pull Hermes source
│   │   │   └── verify.rs           # Post-install smoke test
│   │   ├── update/
│   │   │   ├── mod.rs
│   │   │   ├── agent_updater.rs    # Agent version updates
│   │   │   ├── skill_updater.rs    # Skill pack diff downloads
│   │   │   └── registry_client.rs  # HTTP client for pack/version registry
│   │   ├── autostart/
│   │   │   ├── mod.rs
│   │   │   ├── macos.rs            # launchd plist management
│   │   │   └── windows.rs          # Task Scheduler management (future)
│   │   ├── logger.rs               # Log buffering, rotation, Tauri event emission
│   │   └── error.rs                # Unified error types (displayed in Chinese via UI)
│   ├── Cargo.toml
│   ├── tauri.conf.json             # Window config, updater config, permissions
│   ├── capabilities/               # Tauri v2 permission model
│   │   └── main.json
│   └── icons/                      # App icons (all required sizes)
│       ├── icon.icns               # macOS
│       ├── icon.ico                # Windows
│       └── *.png                   # Fallback sizes
│
├── src/                            # React frontend
│   ├── main.tsx                    # React entry, router setup
│   ├── App.tsx                     # Layout, sidebar, page routing
│   ├── index.css                   # Tailwind base + custom styles
│   ├── pages/
│   │   ├── Welcome.tsx             # Setup wizard (multi-step)
│   │   ├── Dashboard.tsx           # Agent status, stats, recent chats
│   │   ├── Chat.tsx                # Chat interface + conversation sidebar
│   │   ├── Settings.tsx            # Settings tabs
│   │   └── SkillManager.tsx        # Installed skills + pack store
│   ├── components/
│   │   ├── Sidebar.tsx
│   │   ├── AgentStatusIndicator.tsx
│   │   ├── MessageBubble.tsx
│   │   ├── MessageList.tsx
│   │   ├── ChatInput.tsx
│   │   ├── WizardStep.tsx
│   │   ├── SkillCard.tsx
│   │   ├── LogViewer.tsx
│   │   ├── MarkdownRenderer.tsx
│   │   └── UpdateBanner.tsx
│   ├── stores/
│   │   ├── agentStore.ts           # Zustand — agent status, process state
│   │   ├── chatStore.ts            # Zustand — conversations, messages, streaming
│   │   ├── settingsStore.ts        # Zustand — preferences, API keys (masked)
│   │   └── updateStore.ts          # Zustand — update availability, progress
│   ├── hooks/
│   │   ├── useAgent.ts             # Tauri event listeners for agent status
│   │   ├── useChat.ts              # Tauri invoke + event for chat
│   │   └── useAutoStart.ts         # Tauri invoke for auto-start toggle
│   ├── lib/
│   │   ├── tauri.ts                # Typed Tauri invoke wrappers
│   │   ├── types.ts                # Shared TypeScript types
│   │   └── utils.ts                # Formatting, date helpers
│   └── styles/
│       └── themes.css              # Light/dark theme CSS variables
│
├── public/
│   └── favicon.svg
│
├── package.json
├── tsconfig.json
├── vite.config.ts
├── tailwind.config.js
├── postcss.config.js
└── README.md
```

### User Data Directory (Runtime)

```
~/.lingxi/                          # All user-local data (XCOM_DATA standard)
├── config.toml                     # App preferences (auto-start, theme, window state)
├── secrets.toml                    # Encrypted API keys (keychain-backed on macOS)
├── wizard_state.json               # Setup wizard progress (deleted after completion)
├── agent/
│   ├── venv/                       # Python virtual environment (created by installer)
│   ├── src/                        # Hermes agent source (cloned from registry)
│   │   ├── hermes/
│   │   │   ├── __init__.py
│   │   │   ├── agent.py            # Main entry point (--stdio mode)
│   │   │   ├── protocol.py         # JSON-line protocol handler
│   │   │   └── ...
│   │   └── requirements.txt
│   └── config.yaml                 # Hermes agent config (generated by installer)
├── skills/                         # Skill packs (downloaded and installed)
│   ├── registry.json               # Local pack manifest index
│   ├── teacher-general/
│   │   ├── pack.json
│   │   └── prompts/
│   └── ...
├── conversations/                  # Chat history (JSON lines, one file per session)
│   ├── 2026-05-26_abc123.json
│   └── ...
└── logs/
    ├── app.log                     # Desktop app logs (Rust → file)
    └── agent.log                   # Hermes agent logs (stdout/stderr capture)
```

---

## 7. Update System

### Update Channels

- **stable** — Default. Auto-update on app launch.
- **beta** — Optional, opt-in from Settings. Weekly updates.
- **nightly** — Founders/developers only. Daily builds.

### App Updates (Desktop App Version)

Powered by Tauri's updater plugin. App version checked against `https://update.lingxi.ai/manifest.json` (or Gitee mirror).

Manifest format:
```json
{
  "version": "1.2.0",
  "pub_date": "2026-06-15T10:00:00+08:00",
  "url": "https://cdn.lingxi.ai/updates/v1.2.0/lingxi-desktop-x86_64.dmg",
  "signature": "...",
  "notes": "新增技能商店、优化聊天性能、修复多个错误"
}
```

Update flow:
1. On app launch + every 24 hours, Rust checks manifest.
2. If newer version, emit `update-available` event.
3. UI shows UpdateBanner with release notes.
4. User clicks "立即更新" → download starts, progress bar shown.
5. Download complete → Tauri updater applies update → app restarts.
6. On restart, post-update screen: "更新完成！Hermes桌面版已升级到v1.2.0" with changelog.

### Agent Updates (Hermes Version)

- Rust checks Hermes version against registry every 7 days (configurable).
- If newer: download diff, verify checksum, stop agent, apply to `~/lingxi/agent/src/`, reinstall pip deps if `requirements.txt` changed, restart agent.
- Major version changes show a confirmation dialog. Minor/patch updates are silent.
- After update, agent sends `{ "type": "status", "version": "1.2.0" }` on next heartbeat.
- UI shows "Agent已更新到v1.2.0" toast notification.

### Skill Pack Updates

- Checked on the same 7-day cadence as agent updates.
- Registry returns diff URL (changed files only) to minimize download size.
- Applied while agent is running (Rust sends `reload_skills` command after unpacking).
- If agent does not support hot-reload, brief restart (SIGTERM + relaunch, ~2 second interruption).
- Minor/patch updates are applied silently. Major updates require user confirmation.
- Confirmation dialog shows: "教师技能包有重大更新（v2.0），新增了教案自动批改功能。是否更新？"

### Offline/No-Network Mode

- If network is unavailable, updates are skipped silently.
- Next successful network check will apply all pending updates.
- Stale version warning appears after 30 days without update: "当前版本已超过30天未更新，建议连接到网络检查更新。"

---

## 8. Security Considerations

### API Key Handling

- Keys are stored in the operating system's secure credential store (macOS Keychain, Windows Credential Manager), NOT in config files.
- Rust accesses keys only at agent spawn time and test-key time.
- Keys are never exposed to the WebView (React never sees the raw key).
- The UI shows only a masked preview: "sk-****-abcd".
- On app quit, the in-memory key reference is dropped.

### File Permissions

- `~/.lingxi/` is created with `700` permissions (owner-only read/write/execute).
- Log files are rotated and never contain unredacted API keys (Rust scrubs keys from logs before writing).

### Process Isolation

- Hermes agent runs as a child process of the desktop app, not as a system service.
- The agent has no network listening ports (it communicates only via stdin/stdout to the parent process).
- If the desktop app is not running, the agent is not running (unless user explicitly configured background mode).

### Update Security

- Update manifests and packages are signed with a private key.
- Signature is verified by Tauri's updater before applying.
- Agent updates are verified by checksum SHA-256 from the registry (over HTTPS).

### WebView Security

- Tauri's default CSP (Content Security Policy) blocks inline scripts and restricts resource loading.
- No external network requests from the WebView — all data fetching goes through Rust.
- No arbitrary file access from the WebView — file operations are mediated by Rust commands.
- Open external links in the system browser (not in the WebView) to prevent UI redressing.
