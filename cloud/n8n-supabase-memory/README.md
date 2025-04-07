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
## ✅ New Workflow

![Screenshot_4](https://github.com/user-attachments/assets/eba53369-b2e0-48ff-ad77-133770dd029a)


### 1. **Webhook Trigger**
- Accepts `POST` JSON from frontend:
```json
{
  "user_id": "demo-user-1",
  "session_id": "new", // or existing UUID
  "message": "Hello!"
}
```

---

### 2. **Check Session ID (Function Node)**
Parses `body` of request, and sets `session_id = null` if `"new"` or missing.

```javascript
const body = $json.body;

const session_id = (!body.session_id || body.session_id === "new")
  ? null
  : body.session_id;

return [{
  json: {
    user_id: body.user_id,
    message: body.message,
    session_id
  }
}];
```

---

### 3. **IF Node: Session ID Provided?**
Routes:
- True: go to existing session
- False: create new session via UUID

---

### 4. **Generate UUID**
Outputs:
```json
{ "uuid": "..." }
```

---

### 5. **Edit Fields Nodes**
- Merge correct `user_id`, `message`, and final `session_id`
- Reconstructed manually to ensure unified schema:
```json
{
  "user_id": "...",
  "message": "...",
  "session_id": "..." // original or generated UUID
}
```

---

### 6. **Insert User Message (Postgres Insert)**
- Inserts `user`, `session_id`, `message`, `role='user'`
- Must use expression mode for dynamic values

---

### 7. **Fetch Memory (Postgres Query)**
SQL:
```sql
SELECT role, content
FROM n8n_chat_messages
WHERE session_id = '{{ $json["session_id"] }}'
ORDER BY created_at ASC
LIMIT 100;
```

---

### 8. **Aggregate**

Fetch Memory node is returning multiple objects, we want to aggregate them into one. Use All Item Data (Into a single list)

---

### 9. **Format Memory**

In this node we'll format our memory into the most suitable format for our prompt.
Set "memory" array and use the following:
```json
{{ 
  $json.content.map(entry => ({
    role: entry.role,
    content: entry.content
  })) 
}}
```
### 10. **AI Agent (OpenRouter/OpenAI)**
Builds prompt from memory:
```text
{{ $json.memory }}
```
System message is set separately for future convenience
```text
You are a helpful assistant. Use provided chat history to construct a response.
```

---

### 9. **Insert Assistant Message**
Like Insert User Message but with:
- `role = assistant`
- `content = {{ $node["AI Agent"].json["message"] }}`

---

### 10. **Respond to Webhook**
Returns:
```json
{
  "reply": "AI response text"
}
```

---

## Testing Workflow

As we don't currently have the frontend set, we'll be using https://hoppscotch.io/ 
Set the Method to POST
Set the address to your workflow test address
Set the body to RAW and paste the following:

``` json
{
  "user_id": "demo-user-1",
  "session_id": "new",
  "message": "Hello assistant!"
}
```
In N8N press Test Worlflow
In Hoppscotch press Send
Observe the execution
![Screenshot_11](https://github.com/user-attachments/assets/1b1925cd-ff46-4f52-92cb-dea27e96841b)
Observe the table in Supabase
![Screenshot_9](https://github.com/user-attachments/assets/14524cec-11bb-4aa0-b9fa-a29fb112ba1d)
Consequitive messages can be tested with a simple html+js frontend that we'll be implementing in the next project.
![Screenshot_1](https://github.com/user-attachments/assets/92d9774b-217b-44ea-82bb-947db32f44c9)


---

## 💡 Skills Obtained

- Working with **Supabase** as a structured memory store
- Using **n8n PostgreSQL Insert and Select nodes** to manage memory
- Implementing **custom prompt engineering** with historical context
- Creating **dynamic session logic** for new vs. old chat sessions
- Building scalable chatbot workflows with **persistent memory**

---
