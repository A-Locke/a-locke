# Chatbot with Manual Memory Management using n8n and Supabase

## Project
This project implements a memory-aware chatbot backend using **n8n** as the orchestration layer and **Supabase (PostgreSQL)** as a structured chat memory store. Instead of using n8n's built-in memory nodes, we use manual SQL inserts and selects to achieve full control over how messages and sessions are stored, retrieved, and used for context.

Key technologies:
- **n8n** (self-hosted, Docker)
- **Supabase** (PostgreSQL database)
- **OpenAI / OpenRouter** for LLM responses

---

## ✨ Current Setup

Default chat AI Agent setup:
![Screenshot_1](https://github.com/user-attachments/assets/61c85449-587a-42af-ba50-c1815473367f)

---
## ⚡ The Challenge

n8n provides a simple built-in Postgres memory node for the AI Agent, but it's limited:
- No support for custom fields like `user_id` or `session_id`
- Tied to the current workflow execution/session only
- Not scalable for multi-user or persistent memory

Our goal is to build a ChatGPT-style memory structure:
- Persistent message history across sessions
- Messages stored with `user_id`, `session_id`, `role`, and `timestamp`
- Support for listing past sessions and resuming them

---

## ✅ Step-by-Step Plan

### 1. **Manual Message Logging**
Use **PostgreSQL Insert nodes** to write messages to Supabase. Each row includes:
- `user_id`
- `session_id`
- `role` ('user' or 'assistant')
- `content`
- `created_at` (timestamp)

### 2. **Memory Retrieval**
Use **PostgreSQL Select nodes** to fetch chat history:
```sql
SELECT role, content FROM n8n_chat_histories
WHERE session_id = 'abc123'
ORDER BY created_at ASC;
```

### 3. **Building Prompts Manually**
Inject fetched memory into a custom AI prompt:
```
History:
User: Hi
Assistant: Hello!
User: What’s the weather?

Now user says:
Where should I go next weekend?
```

### 4. **Session Handling Logic**
- If `session_id` is missing or marked as `"new"`, generate a new UUID in n8n
- Else use provided `session_id` to fetch full context

### 5. **Unified Workflow**
Single n8n workflow handles both new and continuing conversations based on `session_id` logic.

---

## 🧠 Final Flow

```
[Webhook Trigger]
   ↓
[Normalize Session ID (Function)]
   ↓
[IF Node] → [UUID Generator] (if new session)
   ↓
[Insert User Message into Supabase]
   ↓
[Fetch Past Memory by session_id]
   ↓
[Build Prompt] → [AI Agent Node (OpenAI/OpenRouter)]
   ↓
[Insert Assistant Message into Supabase]
```

---

## ✨ Optional Enhancements

- ✏️ **Session Listing**: Use `DISTINCT session_id` per user to show history
- 🌟 **Titles for Conversations**: Use first message or summarization to label sessions
- 🤔 **Memory Trimming**: Limit to last N messages for long conversations
- 🔐 **Supabase Auth**: Protect memory per-user with JWT

---

## 💡 Skills Obtained

- Working with **Supabase** as a structured memory store
- Using **n8n PostgreSQL Insert and Select nodes** to manage memory
- Implementing **custom prompt engineering** with historical context
- Creating **dynamic session logic** for new vs. old chat sessions
- Building scalable chatbot workflows with **persistent memory**

---
