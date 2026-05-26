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
| Code editor (config) | CodeMirror 6 (lightweight, ~50 KB) | Monaco is 5 MB — too heavy for occasional config editing |
| Audio processing | Tauri plugin + whisper.cpp (Rust bindings) | Local voice I/O without cloud dependency |

---

### Cross-Cutting Design Principles

These principles apply to every screen, every interaction, and every piece of UI text in the application.

**Bilingual (CN Primary + EN Subtitles):**
All UI text is displayed in Chinese as the primary language, with English subtitles in smaller gray text beneath every label, button, message, and instruction. Example:
- Button: "开始使用" with gray subtitle "Start Using"
- Error: "网络连接失败" with gray subtitle "Network connection failed"
- Setting: "语言" with gray subtitle "Language"

The application supports switching between CN-only and EN-only modes in Settings → General → Language. Until switched, the default display is always Chinese primary + English subtitle. Every UI element — every label, button, message, tooltip, toast, and dialog — follows this pattern from day one.

**Security-First Messaging:**
Every permission request (terminal access, file access, network access, microphone, screen recording) is accompanied by a contextual security note displayed at the point of the request. These are user-friendly explanations, not legal disclaimers:

- "灵犀在本地运行。你的数据不会离开你的电脑。"
- "你的API密钥仅存储在你的设备上。"
- "我们无法访问你的文件。所有操作都在你的控制之下。"
- "Hermes是开源软件，代码公开可审查。"
- "灵犀仅在需要时连接网络。所有通信是加密的。"

Security notes are shown at the moment the permission is requested, never buried in a settings page. The note appears as a subtle colored banner or inline text, not a blocking modal.

**Conversational Setup:**
The setup wizard is not a dashboard with fields — it is a step-by-step conversation. Each step explains WHY the user is doing something before showing HOW. Every permission request includes a security explanation. Progress is celebrated with encouraging Chinese copy at each step. The user is shown exactly one question or action per screen, with a clear path forward.

---

## 2. Application Structure

### High-Level Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                         Tauri Window                              │
│  ┌──────────────────────────────────────────────────────────────┐│
│  │                 WebView (React UI)                            ││
│  │  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐     ││
│  │  │Dashboard│ Chat  │Skills │Profiles│ MCP   │Gateway│ ...  ││
│  │  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘     ││
│  │  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐     ││
│  │  │Tasks │Memory │Plugins│Files │Voice  │Settings│          ││
│  │  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘     ││
│  │         Zustand stores (shared state across pages)            ││
│  └──────────────────────────────────────────────────────────────┘│
│                         │ IPC (invoke / events)                    │
│  ┌──────────────────────────────────────────────────────────────┐│
│  │                   Rust Backend (Tauri)                        ││
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐   ││
│  │  │ Process  │ │  Config  │ │Update/   │ │  Scheduler   │   ││
│  │  │ Manager  │ │  Store   │ │Install   │ │  (cron)      │   ││
│  │  └────┬─────┘ └──────────┘ └──────────┘ └──────┬───────┘   ││
│  │       │                                         │           ││
│  │  ┌────┴─────────────────────────────────────────┴───────┐   ││
│  │  │              Stdio Bridge (JSON-line IPC)              │   ││
│  │  └────────────────────────┬──────────────────────────────┘   ││
│  │                           │ stdin/stdout                       ││
│  │  ┌────────────────────────▼──────────────────────────────┐   ││
│  │  │              Hermes Agent (Python child process)        │   ││
│  │  │  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐       │   ││
│  │  │  │ Chat  │ Tools │ MCP   │Memory │ Voice │ ...      │   ││
│  │  │  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘       │   ││
│  │  └──────────────────────────────────────────────────────┘   ││
│  └──────────────────────────────────────────────────────────────┘│
└──────────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

**WebView (React UI) — Presentation only.**
- Renders all screens (wizard, dashboard, chat, settings, profiles, MCP, gateways, tasks, memory, plugins, files, voice, logs).
- Maintains transient UI state (which page is open, scroll position, form input state, which panels are collapsed).
- Sends commands to Rust via `invoke()` (blocking request-response).
- Listens for events from Rust via `listen()` (streaming data, agent status changes, tool calls, heartbeat).
- Never directly touches the filesystem, spawns processes, or reads agent state.
- Stores no secrets — API keys live in Rust's encrypted config store, never in the DOM.

**Rust Backend — Trusted controller.**
- **Process Manager:** Spawns, monitors, restarts, kills the Hermes Python process. Sends heartbeat pings. Emits `agent-status-changed` events. Holds a `HashMap<Pid, ProcessState>`.
- **Stdio Bridge:** Writes JSON messages to Hermes stdin; reads JSON messages from Hermes stdout. Handles line buffering, backpressure, and pipe errors. Maps agent responses to Tauri events (`agent-message`, `tool-call`, `tool-result`, `memory-update`, `agent-status`, etc.).
- **Config Store:** Reads/writes `~/.lingxi/config.toml` (encrypted API keys, user preferences, window state, profiles, gateways, MCP servers, tasks, plugins). Encryption uses platform keychain (macOS Keychain via `security` framework, Windows Credential Manager via winapi).
- **Scheduler (Cron Engine):** Lightweight in-process scheduler. Reads tasks from `~/.lingxi/tasks.json`. Uses a timer wheel to trigger tasks at their next scheduled time. Sends task execution messages through the Stdio Bridge. Logs results.
- **Gateway Bridge:** For each configured gateway (Telegram, Discord, Email), maintains a lightweight connection thread. Relays messages between gateways and the Hermes agent via the Stdio Bridge. Emits gateway status events.
- **Voice Engine:** Manages microphone capture (via Tauri plugin or CPAL) and audio playback. Interfaces with whisper.cpp (local STT) or cloud speech API. Sends transcribed text to agent; receives TTS audio from agent or generates locally.
- **File System Access:** Mediates all file reads/writes/searches for the UI. Provides directory tree listing, file content reading (with size limits), file search (by name and content), and native file picker dialogs.
- **Update Engine:** Checks registry for new agent versions, skill pack updates, and plugin updates. Downloads diffs, verifies checksums, applies updates. Emits `update-available` and `update-progress` events.
- **Auto-Start Service:** Manages launchd plist (macOS) / Task Scheduler (Windows) entries. Toggle on/off from settings.

### Data Flow — Chat Interaction with Tool Calls

```
User types message in chat input
  → React state updates (optimistic UI, show "sending...")
  → invoke("send_message", { text: "帮我查一下天气", profile: "cicero" })
    → Rust serializes { type: "chat", text: "...", profile: "cicero", conversation_id: "..." }\n
    → Writes to Hermes agent stdin (non-blocking)
      → Agent decides to use tool: calls get_weather()
      → Agent writes { type: "tool_call", tool: "get_weather", args: {...}, id: "call_1" }\n
    → Rust reads line from agent stdout (async reader task)
    → Parses JSON, emits event("tool-call", { tool: "get_weather", args: {...}, id: "call_1" })
      → React shows tool call card in chat (collapsed: "🔧 正在查询天气..." expand for details)
    → Agent completes tool, writes { type: "tool_result", id: "call_1", result: "25°C, 晴" }\n
    → Rust emits event("tool-result", { id: "call_1", result: "25°C, 晴" })
      → React updates tool call card with result
    → Agent generates final response with streaming tokens
    → Rust emits event("agent-token", { text: "当前", done: false }) ... repeat
      → React accumulates tokens into message bubble
    → Final: event("agent-message", { text: "...", done: true })
```

### Data Flow — Agent Lifecycle

```
App launches
  → Rust reads config, checks if agent was running on last quit
  → If auto-start enabled: Process Manager spawns agent
  → Emits "agent-status-changed" { status: "starting" | "running" | "stopped" | "error", pid?, uptime? }
  → UI updates dashboard indicator and all status-sensitive UI elements

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

### IPC Event Catalog (UI ← Rust)

| Event | Payload | Trigger |
|-------|---------|---------|
| `agent-status-changed` | `{ status, pid?, uptime? }` | Process lifecycle change |
| `agent-token` | `{ text, done }` | Streaming chat response |
| `agent-message` | `{ text, done }` | Complete chat message |
| `tool-call` | `{ tool, args, id }` | Agent invokes a tool |
| `tool-result` | `{ id, result, error? }` | Tool execution completes |
| `memory-update` | `{ entries[], delta }` | Agent memory changed |
| `scheduler-tick` | `{ tasks_due[] }` | Cron engine fires |
| `gateway-status` | `{ gateway, status, error? }` | Gateway connection change |
| `gateway-message` | `{ gateway, from, text }` | Incoming gateway message |
| `update-available` | `{ component, version, notes }` | New update found |
| `update-progress` | `{ component, percent, stage }` | Download/install progress |
| `voice-input` | `{ text, confidence }` | Speech recognition result |
| `voice-state` | `{ listening: bool }` | Microphone status |
| `log-line` | `{ level, text, timestamp }` | New log entry |
| `file-transfer-progress` | `{ name, percent }` | File upload/download progress |

---

## 3. Setup & Installation Flow

### Phase 1: App Download & First Launch

1. User downloads `.dmg` from WeChat link (or a CDN link provided by Aura).
2. User drags app to Applications folder (standard macOS).
3. On first launch, macOS Gatekeeper warning appears — the app includes a guide in the UI to handle this.
4. App starts → detects no config → shows Welcome screen.

### Phase 2: Conversational Setup Wizard (Steps 1-8)

The wizard is not a dashboard dump. It walks the user through every step one at a time, like a friendly guide. Each screen shows exactly one question or action. Progress is indicated by step dots at the top and encouraging Chinese copy throughout.

---

**Step 1: 欢迎使用灵犀！**

Full-screen welcome with the Lingxi logo and warm greeting — no navigation chrome, no sidebar, no fields:

```
👋 欢迎使用灵犀！让我帮你设置你的AI助手。
灵犀是一款本地运行的AI助手。你的数据不会离开你的电脑。
没有任何信息会被上传到云端。

              [大号蓝色按钮]  开始设置 →
```

A single large friendly button. The user clicks → transitions to Step 2 with a slide animation.

---

**Step 2: 导入或全新设置**

Two paths with equal visual prominence:

**Path A: "我已经在微信上填过信息了" (I already set up on WeChat)**
- User selects the onboarding JSON file downloaded from Aura's mini-program.
- App validates JSON schema, extracts: profession, tier, skill pack selections, API key hint (partial).
- Shows a confirmation: "我已从你的微信信息中识别到以下内容，请确认是否正确：" with a summary card.
- User confirms → jumps to Step 4 (Obsidian install, since environment checks and API key info may be embedded).

**Path B: "我是第一次使用，引导我设置" (I'm new, guide me through)**
- "太好了！我需要了解一些信息，为你推荐最合适的配置。只需要几分钟。"
- Step-by-step questions (exactly one per screen):
  - Profession selector (icon-based: 教师, 律师, 市场营销, 程序员, 其他)
  - Pain points: "你平时花时间最多的三项工作是什么？" (free text, single textarea)
  - Computer type: "你使用什么电脑？" (Mac / Windows / Linux — radio buttons)
  - AI experience: "你之前用过AI工具吗？" (Never / A few times / Regularly — radio buttons)
- At the end, generates the same JSON that Aura's mini-program would produce.
- User can save this JSON and also send it to their phone via QR code.

---

**Step 3: 环境检测与安全说明**

Rust runs pre-flight checks. Before any permission-sensitive check, a security explanation card slides in:

```
🔒 安全说明
灵犀在本地运行。你的数据不会离开你的电脑。
我需要访问你的终端才能安装软件。这是目前最安全的AI架构之一。
Hermes是开源软件，代码公开可审查。
```

Each check displays in sequence with its own security note where applicable:

| Check | Pass Condition | Security Note |
|-------|---------------|---------------|
| OS version | macOS ≥ 12 (Monterey) | — |
| Architecture | arm64 or x86_64 | — |
| Disk space | > 500 MB free | "灵犀的所有文件存储在本地。我们无法访问其他文件。" |
| Python 3 | `python3 --version` ≥ 3.10 | "Python是Hermes的运行环境。仅用于本地执行。" |
| Git | `git --version` | — |
| Network | Can reach registry / GitHub | "灵犀仅在需要时连接网络。所有通信是加密的。" |
| Audio device | Microphone available | "语音功能仅在您点击麦克风按钮时激活。" |
| Screen recording | Available (for screenshot) | "屏幕截图仅在您手动触发时拍摄。" |

Each check shows a spinner → green checkmark or red X with "Fix it" button. Security notes appear as subtle gray text beneath each row. Progress persists across app restarts.

---

**Step 4: 自动安装Obsidian**

After environment checks pass, the wizard checks for Obsidian:

"Obsidian将用于存储你的AI记忆和知识库。所有数据保存在你的电脑上。"

**If Obsidian is already installed:**
```
✅ 已检测到Obsidian (/Applications/Obsidian.app)
将为你配置一个名为"灵犀"的专属资料库。
```
Rust creates a vault at `~/Documents/灵犀/` with initial configuration for Hermes memory integration.

**If Obsidian is not installed:**
```
⏳ Obsidian未安装在你的电脑上。我将自动为你下载并安装。
下载完成后会自动安装到你的 Applications 文件夹。
只需几分钟。
```
- Rust backend downloads the macOS `.dmg` from obsidian.com (with China-mirror fallback).
- Shows a download progress bar with status text in Chinese:
  ```
  正在下载Obsidian...
  ████████░░░░ 65% | 下载中...
  ```
- Once downloaded, mounts the `.dmg` and copies `Obsidian.app` to `/Applications/`.
- Verifies: checks `/Applications/Obsidian.app` exists and is valid.
- Creates vault at `~/Documents/灵犀/`.

Security note displayed during this step:
```
🔒 安全说明
Obsidian是一款本地笔记应用。你的笔记存储在
~/Documents/灵犀/ 目录中。我们无法访问你的其他笔记。
所有AI记忆数据与你自己的笔记是分开的。
```

---

**Step 5: API密钥设置**

```
🔑 为什么需要API密钥？
灵犀通过API密钥连接大模型（如DeepSeek）来回答问题。
你的API密钥仅保存在你的电脑上，我们永远不会看到它。
所有对话数据均在你的本地电脑处理，不会上传到云端。
```

1. "推荐使用DeepSeek（国内可用，性价比高）。" Click "如何获取密钥？" → in-app guide with screenshots walks through DeepSeek signup → create API key → copy key.

2. User pastes key into the input field.

   Security note next to the paste field:
   ```
   🔒 安全说明
   你的API密钥仅存储在你的设备上（macOS Keychain加密）。
   即使灵犀开发者也无法读取你的密钥。
   ```

3. Rust stores it encrypted in macOS Keychain.

4. Rust runs a test: sends a simple request ("请回复'连接成功'") to the API.

5. If test passes: green checkmark with "✅ 连接成功！你的API密钥工作正常。"
   If test fails: error message with troubleshooting (check balance, check key permissions, try different endpoint).

---

**Step 6: 安装Hermes引擎 (with progress bar)**

Rust backend handles all installation. UI shows a single animated progress bar with Chinese status messages updating in real time:

```
灵犀AI引擎安装中...
████████░░░░░░░░ 40% | 正在安装依赖...

安装步骤：
✅ 环境检测通过
⏳ 正在安装Hermes引擎...
⏳ 正在配置Python环境...
⏳ 正在安装依赖包...
```

**Sequential steps (spinner → checkmark):**
1. **创建工作空间:** `~/lingxi/agent/`
2. **克隆Hermes引擎:** If `~/lingxi/agent/` exists and is valid, `git pull`. If not, `git clone` from registry mirror (Gitee preferred for China, GitHub fallback with proxy).
3. **创建虚拟环境:** `python3 -m venv venv`
4. **安装依赖:** `venv/bin/pip install -r requirements.txt` (with `--no-index --find-links ./vendor` if vendor directory exists, to avoid GFW issues).
5. **写入配置:** Rust generates `config.yaml` from onboarding data + API key reference.
6. **配置默认档案:** Write the six Roman Cohort profiles to `~/.lingxi/profiles.json`.
7. **验证安装:** Run smoke test. If it fails, show error log and offer retry.

Security note during installation:
```
🔒 安全说明
Hermes是开源软件，代码公开可审查。
安装的Python包来自官方源，校验码已验证。
```

User cannot proceed until all steps pass. Each completed step shows a green checkmark. Failed steps show a red X with retry button.

---

**Step 7: 加载技能包**

Based on the user's profession (identified in Step 2), the wizard loads skill packs:

```
📦 正在根据你的职业加载技能包

根据你的职业（教师），已为你安装以下技能包：
✅ 教师通用包 — 教案编写、作业批改、家校沟通
✅ 文件操作包 — 文档阅读、格式转换、文件搜索
```

Each pack shows its icon, name, and one-line description. User can toggle individual packs on/off below the list before proceeding.

Security note:
```
🔒 安全说明
技能包仅包含提示词模板和配置。它们不会自动访问你的
文件或数据，除非你在对话中主动要求。
```

---

**Step 8: 最终确认画面**

All installation steps complete. The wizard shows a comprehensive summary:

```
🎉 一切都设置好了。灵犀AI助手已准备就绪。

检查下面列出的每一项，确认是否符合你的期望。

  ✅ 灵犀应用已安装                  → /Applications/灵犀.app
  ✅ Obsidian已安装并配置             → /Applications/Obsidian.app
  ✅ 灵犀资料库已创建                 → ~/Documents/灵犀/
  ✅ Hermes引擎已安装                 → ~/lingxi/agent/
  ✅ Python环境已配置                 → Python 3.12
  ✅ API密钥已配置                    → DeepSeek (macOS Keychain加密存储)
  ✅ 技能包已加载                     → 教师通用包 / 文件操作包
  ✅ 六个默认助手档案已配置            → Cicero / Marcus / Augustus / Seneca / Enobarbus / Turbo-Coder

              [大号绿色按钮]  一切就绪，开始使用！ / All set, start using!
```

Each item has a green checkmark. The layout is clean, one item per line. Below in smaller gray text:
```
所有配置数据存储在本地 (~/.lingxi/)。你的数据不会离开你的电脑。
```

When the user clicks "一切就绪，开始使用！":
1. Rust spawns Hermes agent as a child process.
2. Sends init message via stdin.
3. Agent responds with `{ "type": "ready", "version": "0.1.0" }`.
4. UI transitions from wizard to Dashboard.
5. Auto-start prompt appears: "是否希望开机自动启动灵犀？" — Yes / Not now.

### Phase 3: Setup Complete

- Wizard hides permanently (config flag `setup_completed: true`).
- App launches into Dashboard by default on subsequent starts.
- User can revisit wizard settings via Settings → Re-run setup.

---

## 4. GUI Pages / Screens

### 4.1 Welcome / Setup Wizard

A multi-step, linear wizard. No sidebar or navigation chrome — full-screen focus.

Visual style: Clean cards, large Chinese text, progress dots at top. Warm brand colors. Encouraging tone in all copy.

**Steps (conversational, one per screen):**

1. **欢迎** — Full-screen welcome: "欢迎使用灵犀！让我帮你设置你的AI助手。" Single large button. English subtitle: "Welcome to Lingxi! Let me help you set up your AI assistant."
2. **导入或全新设置** — Two paths: Import onboarding JSON from WeChat mini-program, or full wizard (profession → pain points → computer type → AI experience). Each question is one screen with Chinese label + English subtitle.
3. **环境检测与安全说明** — Pre-flight checks with contextual security notes. Before every permission check, a security explanation card explains WHY the access is needed. "灵犀在本地运行。你的数据不会离开你的电脑。"
4. **自动安装Obsidian** — Detects Obsidian. If absent, auto-downloads from obsidian.com with progress bar. Creates "灵犀" vault at `~/Documents/灵犀/`. Security note: "Obsidian用于存储你的AI记忆和知识库。所有数据保存在你的电脑上。"
5. **API密钥设置** — Guide user to DeepSeek, paste key, test connection. Security note next to input: "你的API密钥仅保存在你的电脑上，我们永远不会看到它。"
6. **安装Hermes引擎** — Progress bar with real-time Chinese status: cloning, venv, pip install, config write. Security note: "Hermes是开源软件，代码公开可审查。"
7. **加载技能包** — Profession-matched skill packs with per-pack toggle. Each shows icon, name, description. Security note: "技能包仅包含提示词模板，不会自动访问你的文件。"
8. **最终确认** — Full summary with green checkmarks for every configured item. "一切都设置好了。灵犀AI助手已准备就绪。" Button: "一切就绪，开始使用！" / "All set, start using!"

State persistence: Wizard state saved to `~/.lingxi/wizard_state.json`. If app crashes mid-setup, it resumes from the last completed step on next launch.

---

### 4.2 Dashboard

Main landing page after setup. Layout: sidebar (compact navigation) + main content area.

**Sidebar navigation (all items):**
- Dashboard icon (home)
- Chat icon (with notification badge for unread messages)
- Profiles icon (Roman Cohort)
- Skills icon (with update badge)
- Plugins icon
- MCP icon
- Gateways icon
- Tasks icon (scheduled)
- Memory icon
- Files icon
- Settings icon
- Log viewer toggle (small icon in bottom-left corner)

**Dashboard content:**
- **Agent status card:** Large indicator dot (green = running, red = stopped, yellow = starting). "运行中" / "已停止" text. Start/Stop button. Uptime display. Current profile badge.
- **Quick stats row:** "今日消息数" (Today's messages), "本月使用量" (Monthly usage), "技能包数" (Installed skills), "记忆条目" (Memory entries), "活跃网关" (Active gateways).
- **Active profile card:** Shows currently active Roman Cohort profile with avatar, name, brief description. Click to switch profiles.
- **Recent interactions panel:** Last 5 chat sessions with timestamps and first few words. Click to open in Chat.
- **Scheduled tasks widget:** Next 3 upcoming tasks with time and status.
- **Gateway status bar:** Compact row of gateway icons with connection indicators.
- **Update notification banner** (if available): "Hermes有新版本可用，点击更新" with update button.
- **Quick action buttons:** "开始对话" (Start chat), "管理技能" (Manage skills), "查看日程" (View tasks), "检查更新" (Check for updates).

---

### 4.3 Chat

Primary interaction surface. Full-height, no scroll on page level — only the message list scrolls.

**Layout:**
- **Header:** Agent name with current profile avatar/name + status dot. Profile dropdown to switch on-the-fly. Model selector dropdown (grouped by provider). Context panel toggle button.
- **Message list:** Vertically scrollable. Messages alternate: user (right-aligned, brand color bubble) / agent (left-aligned, gray bubble, profile avatar). Timestamps on hover.
  - Agent messages support Markdown rendering (code blocks with copy button, tables, links, bullet lists).
  - **Tool call cards** appear inline in message stream. Collapsed by default showing "🔧 正在使用 [tool_name]..." Expand to see full arguments, status, return value.
  - **Web search results** appear as collapsible cards with title, snippet, source URL, favicon.
  - **Image messages** rendered inline (generated or uploaded). Download button on generated images.
  - **Voice messages** show waveform visualization with play button.
  - Loading indicator (three dots animation) while agent is generating.
  - Streaming incremental updates — text appears as agent generates it.
- **Toolbar (above input):** Microphone button (voice input), Image generation button, Screenshot button, File attachment button, Web search toggle (globe icon, turns blue when active), Cancel button (appears during tool execution).
- **Input area:** Bottom-fixed. Textarea (auto-grows to 4 lines max) + Send button (keyboard shortcut: Enter). Drag-and-drop zone for file uploads.

**Conversation management:**
- **Chat sidebar (toggleable):** List of past conversations with full-text search. Each entry shows: title (first message), date, message count, profile used. Right-click → rename, export, delete.
- **New conversation button:** clears context, starts fresh. Profile selector modal appears.
- **Conversation export button:** saves as Markdown or JSON.
- **Per-conversation model override** in the context panel (collapsible right-side drawer).

**Context panel (collapsible right-side drawer):**
- Conversation metadata: ID, token count, created date
- Current profile
- Current model override (if any)
- Attached skills
- System prompt summary
- Web search toggle

**Technical note on streaming:** Rust reads agent stdout line by line. Each line is a JSON object with `type: "token"` for streaming tokens, `type: "message"` for complete messages, `type: "tool_call"` for tool invocations, `type: "tool_result"` for tool results, `type: "web_result"` for search results. The Rust backend emits Tauri events for each line. React accumulates tokens into the current message bubble and renders tool cards as structured UI elements.

---

### 4.4 Settings

**Tabs:**

1. **General** — Theme (浅色 / 深色 / 跟随系统), Language (中文 / English), Font size (小 / 中 / 大), Accent color picker.
2. **API Keys** — List of configured keys with provider name, masked key preview, test button, delete button. "添加密钥" button to add a new key (supports DeepSeek, OpenAI, Anthropic, Ollama, Custom). Usage stats per key (tokens used this month).
3. **Model** — Provider-first model configuration:
   - Provider cards (DeepSeek, OpenAI, Anthropic, Ollama, Custom) with enable/disable toggle.
   - Each provider expands to show: API key selector, base URL override, available models list (with refresh button), default model selector.
   - Provider-specific parameters (e.g., `reasoning_effort` for DeepSeek, `max_tokens`, `temperature` defaults).
   - **Local Model tab:** Download manager for GGUF models. Integration with Ollama (auto-detect running instance, show available models, pull new models from UI).
   - **Model routing rules:** Table of rules (e.g., "Use Claude for coding, DeepSeek for general chat"). Route by conversation topic, profile, or keyword.
4. **Startup** — Toggle "开机自动启动Hermes" (Launch at login). Toggle "启动时自动运行Agent" (Start agent on app launch). Toggle "后台运行时保持Agent运行" (Keep agent running when window closed). Toggle "启动时恢复上次会话" (Restore last conversation on launch).
5. **Voice** — Speech recognition engine (系统默认 / whisper.cpp 本地 / 云端API). TTS voice selection and speed slider. Push-to-talk keybinding. Input device selector. Output device selector. Test microphone button.
6. **Web Search** — Default search provider (Google / Bing / Baidu / 自定义). API key for search service (SerpAPI, Bing, etc.). Default behavior toggle (search always enabled / ask each time).
7. **Gateways** — Router-level gateway defaults. Which profile handles which gateway by default. Global enable/disable all gateways toggle.
8. **Advanced** — 
   - **"Edit config.yaml"** button → opens CodeMirror editor with YAML syntax highlighting and validation.
   - **"Edit .env"** button → similar editor for environment variables.
   - **"View Effective Config"** → merged read-only view of all config sources.
   - **Config backups** — list of timestamped backups with restore button.
   - **Custom CSS injector** — textarea for power user theme overrides.
   - **Developer mode** — toggle raw terminal view, show tool console.
9. **Agent** — Agent version display with "检查更新" button. Agent configuration path (read-only, copy button). Reset agent data button (destructive, double-confirm). Restart agent button.
10. **About** — App version, build number, licenses, "检查更新" button, feedback link. "Export All Config" and "Import Config" buttons.

---

### 4.5 Skill Manager

**Navigation:** Sidebar icon + Dashboard quick action.

**Layout:** Left panel = category/status filter. Right panel = grid/list of skill packs.

**Installed skills view:**
- Grid of skill pack cards. Each card shows: pack icon, name (Chinese + English), version, description (one line), status badge (active / paused / update available / error).
- **Enable/disable toggle** per skill (hot-swop via `reload_skills` command to agent).
- Click card → detail panel: full description, included skills list (with trigger keywords), version history, update channel, "卸载" (Uninstall) button, "编辑" (Edit) button.
- "检查更新" button at top — checks registry, shows update count badge.
- **Enable All / Disable All** bulk actions.

**Skill editing:**
- "编辑" opens a code editor modal (CodeMirror) for the skill's prompt files and YAML/JSON manifest.
- Users can edit system prompts, trigger keywords, model overrides per skill.
- Changes saved to `~/lingxi/skills/<pack>/` directory. Hot-reload sent to agent.

**Creating new skills:**
- "新建技能" button → scaffold wizard: name, description, trigger keywords, prompt template, model override (optional).
- Creates skill pack directory with template files.
- Opens editor immediately for customization.

**Skill store (browse/install):**
- "浏览技能商店" button → opens full-page store browser.
- Packs listed with name, author, rating, size, price, screenshots.
- Search bar filters by name/description/category.
- "安装" button → downloads, verifies, installs, shows confirmation toast.
- "导入" button → select `.zip` or directory → validate manifest → install.

**Skill testing (debug panel):**
- "测试" button on skill detail → opens inline test panel.
- Single text input: "向这个技能发送一条测试消息"
- Shows the skill's raw response below (isolated from other skills/context).
- Useful for prompt debugging.

**Update flow:**
- If updates available, badge appears on Skills nav icon.
- "全部更新" (Update All) button or per-pack update.
- Progress modal: downloading → verifying → installing → reloading skills.
- After update, `reload_skills` command sent to agent (no restart needed if agent supports hot-reload).

---

### 4.6 Agent Profiles (Roman Cohort)

**Navigation:** Dedicated sidebar icon. Also accessible from Chat header dropdown.

**Layout:** Profile cards grid (2×3 or similar). Each card is visually distinct with Roman-themed styling.

**The Six Default Profiles:**

| Profile | Archetype | Model Preference | Temperature | Best For |
|---------|-----------|-----------------|-------------|----------|
| Cicero | Strategist / Analyst | DeepSeek (reasoning) | 0.3 | Analysis, strategy, planning |
| Marcus | Executor / Operator | Claude (precise) | 0.2 | Task execution, code, workflows |
| Augustus | Commander / Orchestrator | GPT-4 (balanced) | 0.5 | Multi-step orchestration, delegation |
| Seneca | Tutor / Philosopher | DeepSeek (general) | 0.7 | Learning, explanation, reflection |
| Enobarbus | Critic / Red Team | Claude (critical) | 0.9 | Code review, debugging, testing |
| Turbo-Coder | Coding Specialist | Any fast model | 0.4 | Rapid code generation, scripting |

**Profile card shows:**
- Roman-inspired avatar (unique illustration per profile)
- Name (Latin + Chinese translation)
- Brief personality/role description (one line)
- Current model assignment
- Temperature setting
- Status indicator (active / inactive)
- "Activate" button (one-click switch)

**Profile detail panel (click card):**
- Full profile configuration:
  - **System prompt** (editable, CodeMirror editor)
  - **Model** selector (override from global model config)
  - **Temperature** slider
  - **Max tokens** input
  - **Allowed tools** — checkboxes for which tools this profile can use (shell, file read/write, web search, code execution, image generation, MCP tools)
  - **Skill overrides** — which skill packs are active for this profile
  - **Gateways** — which gateways this profile handles
- "Reset to Default" button (restore original Roman Cohort settings)
- "Duplicate" button (create a custom profile from this template)
- "Delete" button (only for custom profiles, not default six)

**Creating custom profiles:**
- "新建档案" (New Profile) button
- Name, avatar selection (icon set), system prompt editor, model/temperature/tools config
- Saved to `~/.lingxi/profiles.json`

**Profile assignment:**
- **Per-conversation:** Chat header dropdown lets user pick profile for the current conversation.
- **Default profile:** Set in Settings → General.
- **Routing rules:** Gateways and scheduled tasks can specify which profile handles them.

---

### 4.7 MCP Server Management

**Navigation:** Dedicated sidebar icon.

**Layout:** Server list table + detail panel.

**Server list table:**
| Server Name | Status | Transport | Tools Count | Last Heartbeat | Actions |
|-------------|--------|-----------|-------------|----------------|---------|
| filesystem | 🟢 Connected | stdio | 12 | 2s ago | Configure | Disconnect |
| brave-search | 🟡 Starting | SSE | 0 | — | View Logs |
| custom-tools | 🔴 Error | stdio | — | Failed | Edit | Retry |

- Status indicators: 🟢 Connected / 🟡 Starting / 🔴 Error / ⚫ Disconnected
- Click row → expand to show server details and available tools

**Server detail panel:**
- Server metadata: name, transport type, command/args (for stdio), URL (for SSE), environment variables
- **Tool browser:** Expandable list of available tools from this MCP server. Each tool shows:
  - Name and description
  - Input schema (JSON Schema format, rendered as readable fields)
  - Example usage
  - "Test" button (invoke tool directly from UI)
- **Connection log:** Timestamped events (connected, disconnected, error, tool call count)
- **Edit / Delete / Reconnect / Disconnect** buttons

**Add Server modal:**
- Fields: Server name, Transport type (stdio / SSE)
- If stdio: Command, Arguments (array), Working directory, Environment variables (key-value pairs)
- If SSE: URL, Headers (optional)
- Auto-connect toggle
- Test connection button → attempts to start server and list tools

**Data flow:** MCP server configurations stored in `~/.lingxi/mcp_servers.toml`. On agent spawn, Rust passes MCP config to agent via init message. Agent manages actual MCP connections. Rust monitors server status through agent status messages. UI shows status based on agent-reported MCP state.

---

### 4.8 Scheduled Tasks (Cron Jobs)

**Navigation:** Dedicated sidebar icon (clock). Dashboard widget shows next 3 tasks.

**Layout:** Task list + creation form modal + execution log.

**Task list:**
| Task Name | Schedule | Next Run | Last Run | Status | Profile |
|-----------|----------|----------|----------|--------|---------|
| 每日工作总结 | Every weekday 18:00 | Today 18:00 | Yesterday 18:00 ✅ | Active | Cicero |
| 周报生成 | Every Mon 09:00 | Mon 09:00 | — | Active | Marcus |
| 代码审查提醒 | Every 4h | 14:00 | 10:00 ✅ | Paused | Turbo-Coder |

- Each row: name, friendly schedule description, next run time, last run (time + success/fail), active/paused toggle, profile badge
- Click → expand detail: full task config, execution history

**Task creation form (modal or page):**
- **Name** — free text
- **Description** — optional
- **Schedule** — two modes:
  - **Friendly mode:** Preset dropdown + time picker ("每天上午9点", "每星期一", "每个工作日", "每4小时", "自定义")
  - **Expert mode:** Cron expression input with preview of next 5 run times
- **Prompt/task** — textarea for what the agent should do (e.g., "总结今天的工作内容并生成明日计划")
- **Profile assignment** — which Roman Cohort profile executes this task
- **Model override** — optional, per-task model
- **Skill overrides** — optional, which skills to enable for this task
- **Notification** — toggle: show system notification when task completes
- **Enable/disable** toggle

**Execution log (per task):**
- Table: timestamp, status (✅ / ❌), output snippet (first 200 chars), duration
- "View Full Output" button → expand full agent response
- "Retry" button on failed executions
- "Run Now" button → immediately execute task regardless of schedule

**Data flow:** Tasks stored in `~/.lingxi/tasks.json`. Rust Scheduler module runs a timer wheel in a background thread. At each scheduled time, it constructs a chat message `{ type: "chat", text: <task prompt>, profile: <assigned>, conversation_id: <task-specific> }` and sends it via the Stdio Bridge. Result is logged and notification emitted. UI receives `task-executed` event.

---

### 4.9 Gateway Management

**Navigation:** Dedicated sidebar icon.

**Layout:** Gateway cards grid + message log panel.

**Gateway cards:**
| Gateway | Status | Last Activity | Messages Today | Profile | Actions |
|---------|--------|---------------|----------------|---------|---------|
| Telegram | 🟢 Connected | 2 min ago | 15 | Cicero | Configure | Disconnect |
| WeChat | 🟡 Connecting | — | — | — | Configure |
| Discord | 🔴 Error | 1 hour ago | 3 | Marcus | View Log | Retry |
| Email | ⚫ Disabled | — | — | — | Configure |
| WhatsApp | ⚫ Not configured | — | — | — | Setup |

- Each card: gateway icon/logo, name, large status indicator, last message timestamp, today's message count, assigned profile badge
- "Configure" button → gateway-specific configuration form
- "Connect/Disconnect" toggle
- "View Log" → per-gateway message log

**Gateway configuration forms (modal per gateway):**

**Telegram:**
- Bot Token (from BotFather)
- Webhook URL (auto-generated if not using polling)
- Allowed user IDs (whitelist, optional)
- Polling interval

**WeChat:**
- Connection via Aura mini-program bridge
- QR code display for linking
- Auto-reconnect toggle

**Discord:**
- Bot Token
- Channel IDs (comma-separated)
- Command prefix (e.g., "/hermes")

**Email:**
- IMAP/SMTP credentials (OAuth2 recommended)
- Polling interval
- Signature detection
- Auto-reply template

**Gateway message log (panel or drawer):**
- Real-time feed of messages flowing through this gateway
- Each entry: timestamp, direction (incoming/outgoing), sender, message preview
- Filter by direction, search by text
- Useful for debugging gateway issues

**Gateway routing settings:**
- Table: Gateway → Profile mapping
- "Use default profile" option
- Per-gateway model override (optional)

**Data flow:** Gateway configs stored in `~/.lingxi/gateways.toml`. Rust Gateway Bridge module maintains connection threads. Incoming messages from gateways are relayed to agent via Stdio Bridge as `{ type: "gateway_message", gateway: "telegram", from: "...", text: "..." }`. Agent responses are relayed back to the gateway by Rust. Status changes emitted as `gateway-status` events.

---

### 4.10 Voice I/O

**Navigation:** Microphone button in Chat toolbar. Settings → Voice tab for configuration. No dedicated page — integrated into Chat.

**Voice Input (Microphone):**
- Microphone icon next to chat input area.
- **Click to record:** Button turns red, waveform visualization appears above input area. Click again to stop.
- **Push-to-talk:** Configurable hotkey (e.g., Cmd+Shift+M) in Settings → Voice.
- **Processing:** Audio captured via Tauri plugin → sent to speech recognition engine.
  - **Local mode (default):** whisper.cpp via Rust bindings. No internet required. ~1-2s processing time.
  - **Cloud mode:** Uses configured speech API (e.g., OpenAI Whisper API). Requires internet.
- **Result:** Transcribed text appears in chat input area. User can edit before sending.
- **Confidence indicator:** Low-confidence transcriptions highlighted in yellow for user review.

**Voice Output (Text-to-Speech):**
- Speaker icon on each agent message bubble → click to play message aloud.
- **Auto-play toggle** in Settings → Voice: automatically play new agent messages.
- **Voice selection:** Multiple TTS voices available (system voices, cloud TTS voices).
- **Speed control:** Playback speed slider (0.5x – 2.0x).
- **Visualization:** Audio waveform or animated speaker icon during playback.
- **Stop button** to interrupt playback.

**Settings → Voice tab:**
- **Speech recognition engine:** dropdown (System Default, Whisper.cpp Local, Cloud API)
- **Whisper model:** model size selector (tiny ~75MB, base ~150MB, small ~500MB) with download status
- **Cloud STT:** API provider selector + key
- **TTS engine:** dropdown (System TTS, Edge TTS API, OpenAI TTS)
- **Default voice:** voice name selector
- **Speech speed:** slider
- **Push-to-talk keybinding:** record button + key capture
- **Input device:** system audio device selector
- **Output device:** system audio device selector
- **Test microphone** button → records 3 seconds, plays back

**Implementation note:** Voice processing happens entirely in Rust backend (no Python dependency for STT/TTS). whisper.cpp compiled as a Rust library via `whisper-rs` crate. Audio capture uses `cpal` crate. TTS uses `tts` crate or HTTP calls to cloud TTS APIs.

---

### 4.11 Image Generation & Analysis

**Navigation:** Image palette/brush icon in Chat toolbar. Generated images appear inline in chat.

**Image Generation:**
- Click brush/palette icon in chat toolbar → inline prompt builder appears.
- Prompt textarea: "生成图片: [prompt]" (pre-filled shorthand).
- Style dropdown: realistic, anime, oil painting, 3D render, pixel art, etc.
- Size dropdown: 1024×1024, 1792×1024, 1024×1792 (or model-specific sizes).
- Steps slider (for local diffusion models).
- "生成" button → agent processes → image appears as message bubble.
- Image bubble shows: image (rendered inline), "下载" (Download) button, "重新生成" (Regenerate) button, model/size metadata badge.
- User can copy prompt to clipboard.

**Image Upload & Analysis:**
- Upload via file attachment button, drag-and-drop, or screenshot capture.
- **Screenshot capture:** Camera icon in toolbar → uses Tauri screenshot plugin → captures selected region → uploads to chat automatically.
- Uploaded images appear as message bubbles (thumbnail, expand to full size).
- Image sent to agent with vision analysis prompt (if model supports vision) or to dedicated image analysis model.
- Analysis results shown as structured text below the image (detected objects, text extraction, scene description).

**Image Gallery (future, accessible from Dashboard quick action):**
- Grid of all generated and uploaded images across conversations.
- Search by date, prompt keywords.
- Click → full-size view with metadata (generation parameters, source conversation).
- Delete / export selected images.

**Settings (indirect):** Image generation model configured per profile or in Settings → Model → Image Generation section.

**Data flow:** Image generation request sent to agent as `{ type: "image_generate", prompt: "...", style: "...", size: "..." }`. Agent returns `{ type: "image_result", url: "data:image/png;base64,...", parameters: {...} }` or a reference URL. For local models, Rust may run the image generation model directly (ComfyUI integration) or relay to agent. Screenshots captured by Rust (Tauri plugin), base64-encoded, sent to agent.

---

### 4.12 Memory Management

**Navigation:** Dedicated sidebar icon (brain). Dashboard widget shows memory count.

**Layout:** Search bar + filter bar + entry list + stats header.

**Header stats:**
- Total memory entries
- Last updated timestamp
- Memory size estimate
- "Clear All" button (destructive, double-confirm: "确定清除所有记忆？这个操作不可撤销。")

**Entry list:**
- Searchable by text (full-text across all keys and values).
- Filterable by source (from which conversation), date range, category (user preference, fact, task, etc.).
- Each entry shows:
  - **Key** — identifier (e.g., `user.name`, `user.preferred_language`)
  - **Value/summary** — truncated text, click to expand
  - **Source** — link to originating conversation (if available)
  - **Confidence** — bar indicator (high/medium/low)
  - **Last accessed** — relative timestamp
  - **Created** — absolute timestamp
- Actions per entry: "编辑" (inline edit), "删除" (delete), "跳转到来源" (jump to source conversation).

**Entry editing:**
- Click "编辑" → inline editor opens: key (read-only or editable), value (textarea), category dropdown.
- Save → Rust sends `{ "type": "system", "command": "update_memory", "key": "...", "value": "..." }` to agent.
- Delete → confirmation → Rust sends `{ "type": "system", "command": "delete_memory", "key": "..." }`.

**Adding memory manually:**
- "添加记忆" button → form: key, value, category, source (optional).
- Useful for explicitly teaching the agent facts about the user.

**Data flow:** Rust requests full memory dump from agent via `{ "type": "system", "command": "get_memory" }`. Agent responds with `{ "type": "memory_dump", "entries": [...] }`. On each change (agent adds a memory during conversation), agent emits `{ "type": "memory_update", "entry": {...} }` which Rust forwards as a `memory-update` event. UI updates the list reactively.

---

### 4.13 Plugin System

**Navigation:** Dedicated sidebar icon (puzzle piece). Distinct from Skills.

**Layout:** Tabs: "已安装" (Installed) | "商店" (Store) | "开发" (Develop).

**Installed plugins tab:**
- List/card view of installed plugins.
- Each card shows: plugin icon, name, version, author, description, status badge (active / inactive / update available / error).
- **Enable/disable toggle** — activates/deactivates plugin without uninstalling.
- Click card → detail panel:
  - Full description, version history, permissions (what the plugin can access)
  - **Configuration** section — plugin-specific settings (rendered from plugin's config schema)
  - "卸载" (Uninstall) button
  - "检查更新" button

**Plugin store tab:**
- Browse available plugins from registry.
- Search bar + category filters.
- Each listing: name, author, rating, downloads, size, price, screenshots.
- "安装" button → download → verify signature → install.
- Auto-update toggle per plugin.

**Plugin development tab (for creators):**
- "新建插件" (New Plugin) button → scaffold wizard:
  - Plugin name, description, author, version
  - Template selection (simple command plugin, tool plugin, event handler plugin, etc.)
  - Generates directory in `~/lingxi/plugins/dev/<name>/` with template files
- **Code editor** (CodeMirror) for editing plugin source files directly in the app.
- **Test button** — runs plugin in isolated environment, shows output.
- **Package button** — bundles plugin for distribution.
- **Documentation** — link to plugin API docs.

**Plugin vs Skill distinction (UI clarity):**
- **Skills** = prompt/context packs (passive, modify agent behavior)
- **Plugins** = executable code extensions (active, add new capabilities)
- Both use the store/install/update pattern, but plugins need permission management and code editing tools.

**Data flow:** Plugins run inside the Hermes agent's Python process, not in the desktop app. Desktop app manages plugin lifecycle by sending commands to agent (`enable_plugin`, `disable_plugin`, `install_plugin`, `uninstall_plugin`). Plugin configuration is passed to agent on spawn via init message. Plugin registry requests go through Rust → registry HTTP client → agent.

---

### 4.14 File Browser & Operations

**Navigation:** Dedicated sidebar icon (folder). Accessible from Chat file attachment as well.

**Layout:** Native file explorer feel: path bar + sidebar (quick locations) + file/directory grid + preview panel.

**File browser:**
- **Path bar:** Breadcrumb navigation with clickable segments. Shows current directory path.
- **Quick locations sidebar:**
  - Recent files
  - `~/lingxi/` (workspace root)
  - `~/Documents/`
  - `~/Desktop/`
  - `~/Downloads/`
  - User's home directory
  - "添加位置" (Add custom location)
- **Main area:** Grid or list view (toggleable). Shows files and directories with: icon (file type), name, size, modified date.
  - Click directory → navigate into it.
  - Click file → preview (text files: inline code viewer; images: thumbnail; PDFs: summary; code: syntax highlighted).
- **Search bar:** Search by filename within current directory and all subdirectories. Results appear in a dropdown overlay.
- **Content search:** "搜索文件内容" toggle → enters content search mode. Uses ripgrep (via Rust) to search file contents. Results show file name, line number, matching snippet.
- **Drag and drop:** Files can be dragged from the file browser into the Chat page to attach them.

**File operations:**
- Right-click context menu: Open in system app, Open in Finder, Copy path, Delete, Rename, Move to...
- "上传到对话" (Upload to chat) button → sends selected file to agent.
- "新建文件" / "新建文件夹" buttons.
- Workspace files are opened in the code editor (CodeMirror) for editing.

**Workspace tree:**
- Collapsible tree view of `~/lingxi/` directory:
  - agent/ (Hermes source)
  - skills/ (installed skill packs)
  - plugins/ (installed plugins)
  - conversations/ (chat history files)
  - config.yaml (quick edit link)
  - .env (quick edit link)
- Useful for power users who want direct access to configuration files.

**Security:** File browser respects OS permissions. Cannot browse outside user's home directory by default. User can grant access to specific directories. Tauri's file system scope is configured in `tauri.conf.json`.

**Data flow:** All file operations go through Rust commands. `invoke("list_directory", { path })`, `invoke("read_file", { path })`, `invoke("write_file", { path, content })`, `invoke("search_files", { query, root })`, `invoke("search_file_content", { query, root })`. Rust enforces path safety (prevents directory traversal, respects Tauri's FS scope).

---

### 4.15 Web Search & Browsing

**Navigation:** Toggle in Chat toolbar (globe icon). Settings → Web Search tab for configuration.

**Chat integration:**
- **Globe toggle** in chat input toolbar: click to enable/disable web search for the next message. Blue = enabled, gray = disabled.
- **Per-message toggle:** User can enable search for a single query, and it auto-disables after.
- **Search results display:** When agent performs a web search, results appear as structured inline cards in the message stream.
  - Each card shows: title (clickable link), snippet (2-3 lines of text), source domain with favicon, timestamp.
  - Cards are collapsible (show summary by default, expand for full snippet).
  - Cards can be clicked to open the page in the system browser.
- **Source citations:** Agent responses that use web search results include numbered citations like `[1]` that link to the source cards.

**Settings → Web Search tab:**
- **Default search provider:** dropdown (Google, Bing, Baidu, DuckDuckGo, 自定义)
- **Custom search endpoint:** URL template with `{query}` placeholder
- **API Key:** for providers that require one (SerpAPI, Bing Search API, etc.)
- **Default behavior:** "每次询问" (Ask each time) / "始终开启" (Always on) / "始终关闭" (Always off)
- **Max results:** slider (3 / 5 / 10)
- **Search scope:** "全网" (Web-wide) / "指定站点" (Specific sites, comma-separated)

**Advanced: Web page preview (future):**
- Agent responses that contain URLs show a "预览" (Preview) button.
- Click opens a lightweight WebView preview within the app (not a full browser, just a rendered snapshot).
- Useful for quickly checking link content without leaving the app.

**Data flow:** Web search toggle state sent with each chat message: `{ type: "chat", text: "...", web_search: true }`. Agent performs search using its configured web search tool. Search results returned as `{ type: "web_results", results: [...], query: "..." }`. Agent's final response includes citations referencing these results.

---

### 4.16 Export / Import

**Navigation:** Settings → About tab (full config). Chat page (per-conversation). Context menus.

**Export options:**

**Per-conversation export:**
- Chat sidebar right-click → Export
- Formats: Markdown (.md), JSON (.json), Plain Text (.txt)
- Options: Include timestamps, Include metadata (profile, model, token count), Include tool call details
- Save dialog (Tauri native save dialog)

**Bulk conversation export:**
- Chat sidebar → "导出全部" button at top
- Select conversations (checkboxes) → "导出选中"
- Output: single `.zip` containing individual files
- Naming: `conversation-YYYY-MM-DD_HHMMSS-title.md`

**Full config export:**
- Settings → About → "导出全部配置"
- Exports to a single `.zip` file:
  - `profiles.json` (profile definitions, no API keys)
  - `settings.toml` (app preferences)
  - `gateways.toml` (gateway configs, no tokens — exported as placeholders: `BOT_TOKEN = "<EXPORTED_MASKED>"`)
  - `mcp_servers.toml` (MCP server configs)
  - `tasks.json` (scheduled tasks)
  - `skills_manifest.json` (list of installed skills, versions)
  - `plugins_manifest.json` (list of installed plugins, versions)
- **API keys are NEVER exported** — placeholder tokens only
- User is warned: "API密钥不会包含在导出文件中。导入后需要重新配置API密钥。"

**Profile export:**
- Profile detail panel → "导出此档案"
- Single `.json` file with full profile configuration (no API keys)
- Useful for sharing profiles between machines

**Skill/Plugin export:**
- Skill/Plugin detail → "导出" button
- Packages the skill/plugin into a transferable `.zip` file
- Includes manifest + all files

**Import options:**

**Full config import:**
- Settings → About → "导入配置"
- File picker → select previously exported `.zip`
- Validation: check format version, schema validity
- Merge strategy options: "替换全部" (Replace all) / "合并" (Merge, keep existing on conflict)
- User is prompted to re-enter API keys for any masked placeholders
- Summary screen: "将导入 3 个档案、2 个网关配置、5 个定时任务。确认？"

**Conversation import:**
- Drag-and-drop a `.json` or `.md` file onto the chat sidebar
- Or: Chat sidebar → "导入对话" button → file picker
- Imported conversation appears in the sidebar with an "(导入)" tag

**Skill/Plugin import:**
- Skill Manager → "导入" button → select `.zip` or directory
- Validation, confirmation, installation

---

### 4.17 Error Logs & Debugging

**Navigation:** Small icon in sidebar bottom corner (bug or terminal icon). Not visible in normal operation — one click away.

**Layout:** Full-height log viewer panel (slides up from bottom or opens as overlay).

**Log viewer:**
- Scrollable, monospace font, line-wrapped (toggleable).
- Each line: timestamp (ISO 8601) + log level badge + message.
- Log levels color-coded: DEBUG gray, INFO green, WARN yellow, ERROR red, FATAL white-on-red.
- **Filter bar:**
  - Level dropdown: All / DEBUG / INFO / WARN / ERROR / FATAL
  - Search input: filter by text (case-insensitive)
  - Date range picker (optional, for browsing rotated logs)
- **Controls:**
  - Auto-scroll toggle (follow new logs, default on)
  - Pause button (stop auto-scroll to examine historical logs)
  - Copy button: "复制全部可见" (Copy all visible) / "复制选中行"
  - Save button: export current filtered view to file
  - Clear button: clear display and rotate log file
- **Log source tabs:**
  - "全部" (All) — merged app + agent logs
  - "应用" (App) — Rust backend logs only
  - "Agent" — Hermes agent stdout/stderr only
  - "网络" (Network) — filtered HTTP/API call logs
  - "工具" (Tools) — tool execution logs only

**Crash report:**
- When agent crashes unexpectedly, a "发送崩溃报告" (Submit crash report) button appears.
- Includes: recent log lines (last 500), agent version, OS version, crash counter.
- User can add description before sending.
- Sent to crash reporting endpoint (with user consent).

**Health metrics (Dashboard widget):**
- Agent response time (average, last 24h)
- Token usage per day (chart)
- Error rate (percentage of requests that failed)
- Tool execution count (per tool type)
- Memory usage trend

**Data flow:** Rust backend maintains a ring buffer of the last 10,000 log lines in memory. Logs are also written to `~/.lingxi/logs/app.log` (rotated daily, max 10 MB). Log lines are emitted to UI via `log-line` events for real-time display. On startup, Rust replays the last 500 log lines to populate the viewer.

---

### 4.18 Configuration Editor

**Navigation:** Settings → Advanced tab. Quick access from File browser → workspace tree → click config.yaml/.env.

**Layout:** Code editor with sidebar for file navigation.

**Editable files:**
- `config.yaml` — Hermes agent configuration
- `.env` — environment variables
- `profiles.json` — agent profiles
- `gateways.toml` — gateway configurations
- `mcp_servers.toml` — MCP server configurations
- `tasks.json` — scheduled tasks
- Any file in `~/lingxi/` via File browser → right-click → "编辑"

**Code editor features (CodeMirror 6):**
- Syntax highlighting for YAML, TOML, JSON, Markdown, Python, Shell
- Line numbers
- YAML/JSON validation (schema-aware for config files)
- Schema-aware autocomplete for `config.yaml` (field names, valid values)
- Find and replace
- Undo/redo (in-memory, no auto-save)
- **Save** button (Ctrl+S) → validation check before writing
- **Discard changes** warning if unsaved edits

**Configuration validation:**
- On save, Rust validates:
  - YAML/TOML/JSON syntax correctness
  - Schema conformance (known fields, types)
  - Deprecated key warnings
  - Conflicting settings detection
- Validation errors shown inline (red underline) and in a summary panel
- Invalid configs are NOT saved — user must fix errors first

**Config backups:**
- Every time a config file is saved, Rust creates a timestamped backup: `config.yaml.2026-05-26T10:00:00Z.bak`
- Backups stored in `~/.lingxi/config-backups/`
- Settings → Advanced → "配置备份" section shows list of backups with restore button
- Automatic cleanup: keep last 30 backups, delete older ones

**Theme/Skin editor:**
- Settings → General → Accent color picker (preset palette + custom color input)
- Font family selector (system fonts, with CJK font recommendations: "霞鹜文楷", "思源黑体", "Noto Sans CJK")
- Font size slider
- Border radius slider (UI corner roundness)
- Dark mode / Light mode / Follow system
- **Custom CSS** textarea in Advanced tab (power users; injected into WebView at runtime)

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
    // Extended state
    current_profile: String,
    mcp_servers: HashMap<String, McpServerState>,
    gateway_connections: HashMap<String, GatewayState>,
    scheduler: SchedulerEngine,
}
```

Spawn strategy:
- Working directory: `~/lingxi/agent/`
- Command: `./venv/bin/python3 -m hermes.agent --stdio`
- Environment: `PATH`, `PYTHONPATH`, `HERMES_CONFIG_DIR=~/lingxi/`, `HERMES_LOG_LEVEL=info`
- Stdio: piped (stdin for commands, stdout for responses, stderr merged with stdout for logging)
- Process group: set process group ID so killing the group kills all children.
- Pass configuration on init: profiles, MCP servers, gateways, plugin list, memory state.

### Communication Protocol

JSON-line protocol over stdin/stdout:

**App → Agent (stdin):**
```json
{ "type": "chat", "text": "你好", "conversation_id": "uuid", "profile": "cicero", "web_search": true }
{ "type": "system", "command": "reload_skills" }
{ "type": "system", "command": "get_memory" }
{ "type": "system", "command": "update_memory", "key": "user.name", "value": "张三" }
{ "type": "system", "command": "delete_memory", "key": "user.temp_preference" }
{ "type": "system", "command": "enable_plugin", "name": "code_analyzer" }
{ "type": "system", "command": "disable_plugin", "name": "code_analyzer" }
{ "type": "system", "command": "status" }
{ "type": "system", "command": "shutdown", "reason": "user_quit" }
{ "type": "gateway_message", "gateway": "telegram", "from": "user123", "text": "你好", "conversation_id": "uuid" }
{ "type": "task_execute", "task_id": "daily_summary", "text": "总结今天的工作内容" }
{ "type": "image_generate", "prompt": "一只猫", "style": "anime", "size": "1024x1024" }
```

**Agent → App (stdout):**
```json
{ "type": "token", "text": "你", "done": false }
{ "type": "token", "text": "好", "done": false }
{ "type": "message", "text": "你好！有什么可以帮你的？", "done": true }
{ "type": "tool_call", "tool": "get_weather", "args": {"city": "北京"}, "id": "call_1" }
{ "type": "tool_result", "id": "call_1", "result": "25°C, 晴" }
{ "type": "web_results", "query": "北京天气", "results": [{"title": "...", "snippet": "...", "url": "..."}] }
{ "type": "memory_dump", "entries": [{"key": "user.name", "value": "张三", "source": "...", "confidence": "high"}] }
{ "type": "memory_update", "entry": {"key": "user.city", "value": "北京", "source": "chat_abc"} }
{ "type": "image_result", "url": "data:image/png;base64,...", "parameters": {"model": "stable-diffusion", "style": "anime"} }
{ "type": "gateway_ready", "gateway": "telegram", "status": "connected" }
{ "type": "gateway_error", "gateway": "discord", "error": "Invalid token" }
{ "type": "task_result", "task_id": "daily_summary", "status": "success", "output": "..." }
{ "type": "mcp_status", "server": "filesystem", "status": "connected", "tools_count": 12 }
{ "type": "status", "status": "ready", "version": "0.1.0", "profile": "cicero" }
{ "type": "error", "code": "API_ERROR", "message": "..." }
{ "type": "heartbeat", "timestamp": 1234567890, "uptime_seconds": 3600 }
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
- Heartbeat includes agent health metrics (memory usage, response time average, active gateway count).

### Shutdown Sequence

1. User quits app (or closes window if "keep running in background" is off).
2. Rust sends `{ "type": "system", "command": "shutdown" }` to agent via stdin.
3. Rust saves scheduler state (pause/resume tasks).
4. Rust sends SIGTERM.
5. Rust waits up to 5 seconds for process to exit.
6. If process still alive, sends SIGKILL.
7. Rust writes final state to config: `last_agent_status: running | stopped`.
8. App exits.

### Crash Recovery

- Auto-restart with backoff as described above.
- When agent restarts after crash, Rust sends system messages to reinitialize:
  - `{ "type": "system", "command": "load_skills" }`
  - `{ "type": "system", "command": "restore_conversation", "id": "..." }`
  - `{ "type": "system", "command": "init_mcp" }` (reconnect MCP servers)
  - `{ "type": "system", "command": "init_gateways" }` (reconnect gateways)
  - `{ "type": "system", "command": "resume_tasks" }` (resume scheduler)
- UI shows a notification: "Agent已重新启动" (Agent has restarted) with a dismiss button.
- If crash happened during chat, the conversation is preserved up to the last complete message pair.
- Gateway connections are restored automatically (Rust re-sends gateway config after agent restart).

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
│   │   │   ├── migration.rs        # Config schema migration between versions
│   │   │   ├── profiles.rs         # Profile CRUD (Roman Cohort + custom)
│   │   │   └── gateway.rs          # Gateway configuration management
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
│   │   ├── scheduler/
│   │   │   ├── mod.rs
│   │   │   ├── engine.rs           # Timer wheel for cron task scheduling
│   │   │   ├── task_store.rs       # Task CRUD, persistence in tasks.json
│   │   │   └── executor.rs         # Builds chat messages from tasks, sends to agent
│   │   ├── gateway/
│   │   │   ├── mod.rs
│   │   │   ├── telegram.rs         # Telegram bot client (polling or webhook)
│   │   │   ├── discord.rs          # Discord bot client
│   │   │   ├── email.rs            # IMAP/SMTP client
│   │   │   └── bridge.rs           # Routes gateway messages to/from agent
│   │   ├── voice/
│   │   │   ├── mod.rs
│   │   │   ├── stt.rs              # Speech-to-text (whisper.cpp, cloud API)
│   │   │   ├── tts.rs              # Text-to-speech (system, cloud API)
│   │   │   └── capture.rs          # Microphone capture (cpal)
│   │   ├── filesystem/
│   │   │   ├── mod.rs
│   │   │   ├── browser.rs          # Directory listing, file metadata
│   │   │   ├── search.rs           # File name + content search (ripgrep)
│   │   │   └── watcher.rs          # File system change notifications
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
│   │   ├── Settings.tsx            # Settings tabs (general, api keys, model, voice, web search, gateways, advanced, agent, about)
│   │   ├── SkillManager.tsx        # Installed skills + pack store + editor + test panel
│   │   ├── Profiles.tsx            # Roman Cohort profiles grid + detail editor
│   │   ├── McpManager.tsx          # MCP server list + detail + add/edit modal
│   │   ├── Tasks.tsx               # Scheduled tasks list + creation form + execution log
│   │   ├── Gateways.tsx            # Gateway cards + configuration + message log
│   │   ├── Memory.tsx              # Memory viewer, search, edit, add
│   │   ├── Plugins.tsx             # Plugin manager (installed, store, develop)
│   │   ├── FileBrowser.tsx         # File explorer, search, preview
│   │   └── LogViewer.tsx           # Log viewer overlay
│   ├── components/
│   │   ├── Sidebar.tsx
│   │   ├── AgentStatusIndicator.tsx
│   │   ├── MessageBubble.tsx
│   │   ├── MessageList.tsx
│   │   ├── ChatInput.tsx
│   │   ├── ToolCallCard.tsx        # Inline tool invocation display
│   │   ├── WebSearchCard.tsx       # Inline web search result card
│   │   ├── ImageMessage.tsx        # Image display in chat (generated/uploaded)
│   │   ├── VoiceMessage.tsx        # Voice message with waveform and play button
│   │   ├── ProfileBadge.tsx        # Profile avatar + name badge
│   │   ├── ModelSelector.tsx       # Provider-grouped model dropdown
│   │   ├── WizardStep.tsx
│   │   ├── SkillCard.tsx
│   │   ├── ProfileCard.tsx         # Roman Cohort profile card
│   │   ├── McpServerRow.tsx
│   │   ├── TaskRow.tsx
│   │   ├── GatewayCard.tsx
│   │   ├── MemoryEntry.tsx
│   │   ├── PluginCard.tsx
│   │   ├── FileExplorer.tsx
│   │   ├── CodeEditor.tsx          # CodeMirror wrapper for config/skill editing
│   │   ├── MarkdownRenderer.tsx
│   │   ├── UpdateBanner.tsx
│   │   └── ConfirmDialog.tsx       # Reusable destructive action confirmation
│   ├── stores/
│   │   ├── agentStore.ts           # Zustand — agent status, process state
│   │   ├── chatStore.ts            # Zustand — conversations, messages, streaming, tool calls
│   │   ├── profileStore.ts         # Zustand — profiles list, active profile
│   │   ├── settingsStore.ts        # Zustand — preferences, API keys (masked)
│   │   ├── updateStore.ts          # Zustand — update availability, progress
│   │   ├── gatewayStore.ts         # Zustand — gateway connections, messages
│   │   ├── taskStore.ts            # Zustand — scheduled tasks, execution log
│   │   ├── memoryStore.ts          # Zustand — memory entries, search
│   │   ├── mcpStore.ts             # Zustand — MCP server states, tool lists
│   │   ├── pluginStore.ts          # Zustand — plugin list, store catalog
│   │   └── fileStore.ts            # Zustand — file browser state, current directory
│   ├── hooks/
│   │   ├── useAgent.ts             # Tauri event listeners for agent status
│   │   ├── useChat.ts              # Tauri invoke + event for chat, tool calls
│   │   ├── useProfiles.ts          # Profile CRUD via Tauri invoke
│   │   ├── useGateways.ts          # Gateway connect/disconnect, message feed
│   │   ├── useTasks.ts             # Task CRUD, scheduler events
│   │   ├── useMemory.ts            # Memory dump, update, delete
│   │   ├── useMcp.ts               # MCP server status, tool listing
│   │   ├── usePlugins.ts           # Plugin lifecycle management
│   │   ├── useFileBrowser.ts       # File operations, directory listing
│   │   ├── useVoice.ts             # Microphone, speech recognition events
│   │   ├── useLogger.ts            # Log line events, filter state
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
~/.lingxi/                          # All user-local data (XDG_DATA standard)
├── config.toml                     # App preferences (auto-start, theme, window state)
├── secrets.toml                    # Encrypted API keys (keychain-backed on macOS)
├── wizard_state.json               # Setup wizard progress (deleted after completion)
├── profiles.json                   # Agent profiles (Roman Cohort + custom)
├── gateways.toml                   # Gateway configurations
├── mcp_servers.toml                # MCP server configurations
├── tasks.json                      # Scheduled tasks
├── plugins.json                    # Plugin manifest (installed versions, enabled state)
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
├── plugins/                        # Installed executable plugins
│   ├── registry.json
│   ├── code_analyzer/
│   │   ├── manifest.json
│   │   └── main.py
│   └── ...
├── conversations/                  # Chat history (JSON lines, one file per session)
│   ├── 2026-05-26_abc123.json
│   └── ...
├── config-backups/                 # Timestamped config file backups
│   ├── config.yaml.2026-05-26T10:00:00Z.bak
│   └── ...
└── logs/
    ├── app.log                     # Desktop app logs (Rust → file)
    ├── agent.log                   # Hermes agent logs (stdout/stderr capture)
    └── scheduler.log               # Task execution logs
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

### Skill Pack & Plugin Updates

- Checked on the same 7-day cadence as agent updates.
- Registry returns diff URL (changed files only) to minimize download size.
- Applied while agent is running (Rust sends `reload_skills` command after unpacking).
- If agent does not support hot-reload for skills, brief restart (~2 second interruption).
- Minor/patch updates applied silently. Major updates require user confirmation.
- Plugin updates follow the same pattern: download, verify, stop plugin, update files, restart plugin.

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
- Export/Import functions NEVER include raw keys — only masked placeholders.

### File Permissions

- `~/.lingxi/` is created with `700` permissions (owner-only read/write/execute).
- Log files are rotated and never contain unredacted API keys (Rust scrubs keys from logs before writing).
- Conversation files are `600` (owner-only read/write).

### Process Isolation

- Hermes agent runs as a child process of the desktop app, not as a system service.
- The agent has no network listening ports (it communicates only via stdin/stdout to the parent process).
- If the desktop app is not running, the agent is not running (unless user explicitly configured background mode).
- Gateway connections are maintained by Rust (not the agent) for isolation.

### Update Security

- Update manifests and packages are signed with a private key.
- Signature is verified by Tauri's updater before applying.
- Agent updates are verified by checksum SHA-256 from the registry (over HTTPS).
- Plugin downloads are verified by signature or checksum.

### WebView Security

- Tauri's default CSP (Content Security Policy) blocks inline scripts and restricts resource loading.
- No external network requests from the WebView — all data fetching goes through Rust.
- No arbitrary file access from the WebView — file operations are mediated by Rust commands.
- Open external links in the system browser (not in the WebView) to prevent UI redressing.

### Gateway Security

- Bot tokens for Telegram/Discord stored in encrypted secrets store, never in config files.
- Email credentials stored in keychain.
- Gateway tokens masked in UI and excluded from exports.
- Rate limiting on outgoing gateway messages to prevent abuse.
