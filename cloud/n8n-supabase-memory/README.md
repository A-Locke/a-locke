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

🧠 New Architecture (Textual Plan)
```
[Webhook Trigger]
   ↓
[Check if session_id is valid]
   ↓                ↓
[Use Provided]   [Generate UUID (new session)]
   ↓                ↓
     ↘            ↙
     [Insert User Message] → log new/old in Supabase (with user_id, session_id)
         ↓
[Fetch Memory if session exists]
         ↓
[Build Prompt] → format memory + current message
         ↓
[Insert Assistant Message] → store reply in Supabase
```
## ✅ Step-by-Step Plan

### 1. **Manual Message Logging**
Use **PostgreSQL Insert nodes** to store messages with fields like:
- `user_id`
- `session_id`
- `role` ('user' or 'assistant')
- `content`
- `created_at` (timestamp)

### 2. **Session Management**
- If `session_id` is `"new"` or missing → generate UUID
- Otherwise, reuse session to maintain chat continuity

### 3. **Memory Retrieval**
Use **PostgreSQL Select** nodes to pull past messages by session or user:
```sql
SELECT role, content, image_url FROM n8n_chat_histories
WHERE session_id = 'abc123'
ORDER BY created_at ASC;
```

### 4. **Build Prompt for AI**
Format retrieved messages into structured prompts:
```json
[
  { "role": "user", "content": [
    { "type": "text", "text": "What is this?" },
    { "type": "image_url", "image_url": { "url": "https://..." } }
  ]}
]
```

---

## 💡 Skills Obtained

- Working with **Supabase** as a structured memory store
- Using **n8n PostgreSQL Insert and Select nodes** to manage memory
- Implementing **custom prompt engineering** with historical context
- Creating **dynamic session logic** for new vs. old chat sessions
- Building scalable chatbot workflows with **persistent memory**

---
