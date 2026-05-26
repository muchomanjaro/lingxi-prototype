# Gap Analysis: Desktop App Plan vs. Full Hermes Agent Capabilities

> **Context:** The desktop app must not be a downgrade from running Hermes directly in the terminal. Every capability users have today must be accessible (or at least manageable) from the GUI.

---

## 1. Terminal / Tool Execution

**Status:** ⚠️ PARTIAL

**What the plan covers:** Hermes runs as a child process; chat messages can trigger agent tool use. File attachment button exists.

**What's missing:**
- No **dedicated terminal panel** showing raw command execution output
- No **command approval workflow** (approve/reject/audit tool calls before they run)
- No way to see **which tool the agent is invoking** in real-time (shell vs. code vs. file read)
- No **interrupt/cancel** button for a running tool invocation

**Recommendation:**
- Add a collapsible **"Tool Call Log"** drawer in the Chat page that shows each tool invocation (tool name, arguments, status, return value) as a structured log
- Show an **inline tool call card** in the message stream (collapsed by default, expand to see details)
- Add a **"Cancel" button** next to the input area when the agent is executing a tool
- Allow power users to open a **raw terminal view** (Settings → Developer → Show Tool Console)

---

## 2. File Operations

**Status:** ⚠️ PARTIAL

**What the plan covers:** File attachment in chat; files are sent to the agent for processing.

**What's missing:**
- No **file browser/explorer** to navigate the user's filesystem from the GUI
- No **file search UI** (find by name, content, type)
- No **drag-and-drop** file upload from the desktop into chat
- No **recent files** list or file manager panel

**Recommendation:**
- Add a **file picker** dialog (Tauri's native dialog) that allows selecting multiple files for upload
- Implement drag-and-drop onto the chat input area (Tauri drag-drop plugin)
- Consider a **File Explorer sidebar** panel showing a tree of recently accessed or workspace files
- Add a `/search` type command or UI for file content search across `~/lingxi/` or user-specified directories

---

## 3. Web Search & Browsing

**Status:** ❌ MISSING

**What the plan covers:** Nothing. Network checks exist only for update/registry access.

**What's missing:**
- No **web search toggle** ("enable web search for this query")
- No **search result preview** in chat
- No **browser view** for rendered web pages
- No way to **configure search sources** (Google, Bing, Baidu, custom)

**Recommendation:**
- Add a **globe icon toggle** in the chat input area to enable/disable web search per message
- Show web search results as **collapsible inline cards** with title, snippet, source
- Add a **Settings → Web Search** tab to configure search provider, API keys (e.g., SerpAPI, Bing Search), and default behavior
- For future: integrate a **lightweight WebView preview** for link-rich agent responses

---

## 4. Session Management

**Status:** ✅ COVERED

**What the plan covers:**
- Chat sidebar with conversation list and search
- New conversation / clear context
- Conversation export (Markdown / JSON)
- Persistent storage: `~/.lingxi/conversations/`

**Notes:** Well-designed. Ensure the conversation search is full-text search (not just title), and that export includes timestamps and metadata.

---

## 5. Skill Management

**Status:** ⚠️ PARTIAL

**What the plan covers:**
- 4.5 Skill Manager: grid of installed packs, detail panel, install/uninstall, update flow
- Skill store browser
- Auto-update with `reload_skills` command

**What's missing:**
- No **skill creation/editing** UI
- No **skill loading/unloading** (hot-swap toggle)
- No **per-skill configuration** (e.g., customizing a skill's system prompt or trigger keywords)
- No **local skill import** from a file or directory
- No **skill debugging** (test a skill in isolation)

**Recommendation:**
- Add an **"Edit Skill"** modal (code editor for prompt files, YAML/JSON manifest editing)
- Add a **"New Skill"** button that scaffolds a skill pack from a template
- Add **enable/disable toggle** per skill (hot-reload via `reload_skills`)
- Add **"Import Skill"** button (select a `.zip` or directory, validate manifest, install)
- Add a **skill test panel** where users can send a test message to a single skill in isolation

---

## 6. MCP Server Management

**Status:** ❌ MISSING

**What the plan covers:** Nothing. No mention of MCP (Model Context Protocol) anywhere.

**What's missing:**
- No **MCP server list** (connected, disconnected, errored)
- No **add/configure MCP server** UI (command, args, env vars, transport type)
- No **MCP tool browser** (see available tools from connected servers)
- No **per-server status** (health check, last used)
- No **MCP log/tracing**

**Recommendation:**
- Add a **"MCP Servers"** page or tab under Settings / a new sidebar icon
- Show a table: server name, status indicator, transport (stdio/SSE), tools count, last heartbeat
- "Add Server" button → modal with fields: name, command, args, environment variables, transport type
- "Tools" button → expandable list of available tools with their schemas
- MCP connection status should be reflected in the agent status indicator
- Store MCP config in `~/.lingxi/config.toml`, pass to Hermes on spawn

---

## 7. Model / Provider Switching

**Status:** ⚠️ PARTIAL

**What the plan covers:**
- Chat header: model dropdown showing current model
- Settings → Model: default model, temperature, max tokens
- Settings → API Keys: list of configured keys with test/delete

**What's missing:**
- No **provider-level switching** (DeepSeek ↔ Claude ↔ Local ↔ OpenAI)
- No **multi-model comparison** (send same message to two models)
- No **local model management** (download/load GGUF models, configure Ollama/LM Studio)
- No **model routing rules** (use Claude for coding, DeepSeek for general chat)
- No **per-conversation model override**
- No **provider-specific parameters** (e.g., `reasoning_effort` for DeepSeek, `max_thinking_tokens`)

**Recommendation:**
- **Redesign Model Settings** as a provider-first UI:
  - Provider cards (DeepSeek, OpenAI, Anthropic, Ollama, Custom) with enable/disable toggle
  - Each provider expands to show: API key, base URL, available models, default model
  - Button to fetch available models from the provider
- Add **local inference** support:
  - "Local Model" tab with download manager for GGUF models
  - Integration with Ollama (auto-detect if running, show available models)
- Add **model selector** in Chat header as a dropdown categorized by provider
- Add **per-conversation model override** in the context panel
- Add **model routing rules** under Settings → Advanced

---

## 8. Multiple Agent Profiles (The Roman Cohort)

**Status:** ❌ MISSING

**What the plan covers:** Nothing. Only "Hermes智能助手" is mentioned as the agent identity.

**What's missing:**
- No **profile selector** (Cicero, Marcus, Augustus, Seneca, Enobarbus, Turbo-Coder)
- No **profile configuration** (system prompt, temperature, model, allowed tools per profile)
- No **profile creation/editing**
- No **per-conversation profile assignment**
- No visual distinction between profiles in chat (avatar, color theme)

**Recommendation:**
- Add a **"Profiles"** page or management panel
- Each profile is a card showing: name, avatar, description, current model, brief personality summary
- Pre-populate with the six Roman Cohort profiles; allow editing and custom creation
- Add a **profile selector dropdown** in the Chat header (next to or replacing model selector)
- Profile settings include: system prompt, default model, temperature, max tokens, allowed tools, skill overrides
- Store profiles in `~/.lingxi/profiles.json`
- When the user starts a new conversation, they pick (or are assigned) a profile
- Profile badge/name shown in each message bubble for clarity

---

## 9. Cron Jobs / Scheduled Tasks

**Status:** ❌ MISSING

**What the plan covers:** Nothing.

**What's missing:**
- No **scheduled task list** (view, create, edit, delete)
- No **cron expression editor** or friendly scheduling UI
- No **task execution log** (success/failure, output, next run)
- No **notification on task completion**

**Recommendation:**
- Add a **"Scheduled Tasks"** page (accessible from dashboard or settings)
- Task creation form: name, cron expression (with friendly presets: "每天上午9点", "每星期一"), prompt/task description, profile assignment
- Show a calendar or timeline view of upcoming executions
- Task log: timestamp, status, output snippet, retry button on failure
- Store tasks in `~/.lingxi/tasks.json`; a lightweight Rust scheduler (or a dedicated thread) triggers executions via the agent stdin protocol
- Notifications via system tray or in-app toast

---

## 10. Gateway Management

**Status:** ❌ MISSING

**What the plan covers:** Nothing.

**What's missing:**
- No **gateway list** (Telegram, WeChat, Discord, Email, WhatsApp)
- No **connect/disconnect** controls per gateway
- No **gateway configuration** (bot tokens, channel IDs, webhook URLs)
- No **gateway message log**
- No **command routing** (which profile handles which gateway)

**Recommendation:**
- Add a **"Gateways"** page (new sidebar icon)
- List available gateways as cards: Telegram, WeChat (via Aura mini-program?), Discord, Email
- Each gateway card shows: connection status (connected/disconnected/error), last message timestamp, incoming message count
- "Configure" button → modal/bottom sheet with gateway-specific fields (bot token, channel ID, etc.)
- "Gateway Log" panel showing recent messages routed through each gateway
- Add gateway routing settings: which profile responds to which gateway
- Store gateway config in `~/.lingxi/gateways.toml`
- Gateway processes could run as lightweight threads in Rust that relay messages to/from the Hermes agent

---

## 11. Voice I/O

**Status:** ❌ MISSING

**What the plan covers:** Nothing.

**What's missing:**
- No **microphone button** for voice input
- No **text-to-speech** playback of agent responses
- No **voice activity detection** (push-to-talk or always-on)
- No **voice settings** (input device, output device, speech recognition model, TTS voice)

**Recommendation:**
- Add a **microphone icon** next to the chat input area (click to record, click again to stop → send transcribed text)
- Use the **Web Speech API** or Tauri plugin for speech recognition / TTS
- Add a **speaker icon** on agent messages to play them aloud (TTS)
- Add a **Voice settings tab** under Settings:
  - Speech recognition engine (system default, whisper.cpp local, cloud API)
  - TTS voice selection and speed
  - Push-to-talk keybinding
- For local speech recognition, integrate whisper.cpp as a Rust plugin

---

## 12. Image Generation & Analysis

**Status:** ⚠️ PARTIAL

**What the plan covers:**
- Chat: file attachment includes images (for vision-capable models)

**What's missing:**
- No **image generation UI** (prompt → generate → display)
- No **image gallery** (history of generated/analyzed images)
- No **screenshot tool** (capture screen region and send to agent)
- No **image editor** (crop, annotate before sending)
- No **image generation settings** (model, size, style, steps)

**Recommendation:**
- Add an **image generation shortcut** in the chat input toolbar (palette/brush icon)
- Clicking it opens an inline prompt builder: "生成图片: [prompt]" with optional size/style dropdowns
- Generated images appear as message bubbles with download and regenerate buttons
- Add a **screenshot capture** button that uses Tauri's screenshot capabilities or a platform API
- Add **image analysis results** in structured format within the message bubble (detected objects, text, captions)
- Future: **Gallery page** showing all generated/analyzed images with search

---

## 13. Memory Management

**Status:** ❌ MISSING

**What the plan covers:** Nothing.

**What's missing:**
- No **memory viewer** (see stored facts, preferences, user profile data)
- No **memory search** (find specific stored information)
- No **memory editor** (add, edit, delete memory entries)
- No **memory stats** (total entries, last updated, size)
- No **memory privacy controls** (clear all, exclude specific patterns)

**Recommendation:**
- Add a **"Memory"** page (new sidebar icon or accessible from Settings)
- Show memory entries in a searchable, filterable list with timestamps
- Each entry shows: key, value/summary, source (from which conversation), confidence, last accessed
- Allow users to edit or delete individual entries
- "Clear All Memory" button (destructive, double-confirm)
- Add a **memory stats card** on Dashboard (entries count, last update)
- Memory is managed by the Hermes agent; Rust requests memory dump via `{ "type": "system", "command": "get_memory" }` and displays results

---

## 14. Plugin System

**Status:** ❌ MISSING

**What the plan covers:** Skill packs exist, but they are not equivalent to a general plugin system (skills are prompt/context packs, plugins are executable extensions).

**What's missing:**
- No **plugin list** (installed / available / outdated)
- No **plugin install/uninstall** UI (beyond skill packs)
- No **plugin configuration** (per-plugin settings)
- No **plugin store/browser**
- No **plugin development tools** (scaffold, test, package)

**Recommendation:**
- Distinguish clearly between **Skill Packs** (prompt/context/data) and **Plugins** (executable code extensions)
- Add a **"Plugins"** tab (alongside Skills in the sidebar or as a separate page)
- Plugin store with install/uninstall, version management, update checks
- Per-plugin configuration panel (exposed settings, enable/disable, permissions)
- Plugin development tools: scaffold from template, local test, package for distribution
- Plugin system architecture note: Plugins likely run inside the Hermes agent's Python process, not in the desktop app. The desktop app manages the plugin lifecycle by sending commands to the agent.

---

## 15. Export / Import

**Status:** ⚠️ PARTIAL

**What the plan covers:**
- Conversation export (Markdown / JSON)
- Import onboarding JSON during setup
- Skill pack import/install

**What's missing:**
- No **full config export/import** (all settings, profiles, API key placeholders, gateways, tasks)
- No **conversation import** (re-import a previously exported conversation)
- No **bulk export** (all conversations at once)
- No **portable profile export** (share a profile between machines)

**Recommendation:**
- Add **"Export All Config"** button in Settings → About or a new "Data" tab:
  - Exports: profiles, settings (without raw API keys), gateways, scheduled tasks, skill list
  - Output: a single `.zip` or `.json` package
- Add **"Import Config"** button that validates and applies the config
- Add **bulk conversation export** (select conversations → export as zip)
- Add **conversation import** (drag-and-drop a previously exported `.json` or `.md` file onto the chat sidebar)
- Mask API keys during export (export placeholder references, not raw keys)

---

## 16. Error Logs & Debugging

**Status:** ✅ COVERED

**What the plan covers:**
- 4.6 Log Viewer: scrollable, monospace, colored log levels, filter, search, copy, auto-scroll, rotate
- Log source: Rust backend + agent stdout/stderr merged
- Crash recovery state machine with error reporting
- Environment check with failure handling

**Notes:** Well-designed. Consider adding:
- **Log export** (save current log view to a file)
- **Crash report** submission button (with user consent)
- **Agent health metrics** (response time, token usage, error rate) on the Dashboard

---

## 17. Configuration (config.yaml, .env, skin)

**Status:** ⚠️ PARTIAL

**What the plan covers:**
- Settings page with 6 tabs covering theme, API keys, model, startup, agent, about
- Rust generates `config.yaml` during installation

**What's missing:**
- No **direct config.yaml editor** (for power users)
- No **.env file viewer/editor**
- No **skin/theme editor** (beyond light/dark toggle)
- No **config validation** (detect stale or conflicting settings)
- No **config version control** (previous versions backup/restore)

**Recommendation:**
- Add a **"Advanced" tab** in Settings with:
  - **"Edit config.yaml"** button → opens a code editor (Monaco or CodeMirror) with YAML syntax highlighting and validation
  - **"Edit .env"** button → similar editor for environment variables
  - **"View Effective Config"** → merged view of all config sources
- Add a **"Themes"** tab with:
  - Preset themes (light, dark, high-contrast)
  - Custom accent color picker
  - Font family selector (for CJK users)
  - Custom CSS injector (power users)
- Add **config backup** on every save (timestamped copies in `~/.lingxi/config-backups/`)
- Add **config validation** on save (check YAML syntax, deprecated keys, type mismatches)

---

## Summary

| # | Capability | Status |
|---|-----------|--------|
| 1 | Terminal / Tool execution | ⚠️ PARTIAL |
| 2 | File operations | ⚠️ PARTIAL |
| 3 | Web search & browsing | ❌ MISSING |
| 4 | Session management | ✅ COVERED |
| 5 | Skill management | ⚠️ PARTIAL |
| 6 | MCP server management | ❌ MISSING |
| 7 | Model / Provider switching | ⚠️ PARTIAL |
| 8 | Multiple agent profiles | ❌ MISSING |
| 9 | Cron jobs / scheduled tasks | ❌ MISSING |
| 10 | Gateway management | ❌ MISSING |
| 11 | Voice I/O | ❌ MISSING |
| 12 | Image generation & analysis | ⚠️ PARTIAL |
| 13 | Memory management | ❌ MISSING |
| 14 | Plugin system | ❌ MISSING |
| 15 | Export / Import | ⚠️ PARTIAL |
| 16 | Error logs & debugging | ✅ COVERED |
| 17 | Configuration | ⚠️ PARTIAL |

**Count:** ✅ 2 covered | ⚠️ 7 partial | ❌ 8 missing

---

## Critical Path Recommendations (Top Priority)

These features represent the biggest downgrade risk — capabilities that heavy Hermes users rely on daily that have zero support in the current plan:

1. **Multiple Agent Profiles** (#8) — This is a core differentiator. Without it, the desktop app is a generic chatbot wrapper. The Roman Cohort profiles are central to the Hermes identity and value proposition.

2. **MCP Server Management** (#6) — MCP is the extensibility backbone. Users connecting custom tools via MCP will be unable to configure or manage them from the GUI.

3. **Web Search & Browsing** (#3) — One of the most frequently used agent capabilities. Users expect to toggle search on/off and see results inline.

4. **Memory Management** (#13) — Agent memory is a key selling point. If users can't see or edit what the agent remembers about them, they lose trust and control.

5. **Voice I/O** (#11) — A hard requirement for accessibility and convenience. Many users (especially non-technical) prefer voice interaction.

6. **Gateway Management** (#10) — Users who connect Hermes to Telegram/WeChat/Discord need to manage those connections from the desktop app.
