
# 🧠 AI Agent Frontend

A sleek, modern frontend built with **Next.js** and **Supabase** to interface with the [AI Agent backend](./) powered by `n8n`. Users can chat with the AI via a fully authenticated interface.

---

## 📌 Project Overview

This frontend complements a backend AI agent that handles memory and responses via PostgreSQL within n8n. Users authenticate through Supabase and are assigned sessions tied to their messages. This setup enables a persistent, personalized, and secure chat experience.

---

## 🛠 Tech Stack – Why Next.js + Supabase?

| Tech         | Purpose |
|--------------|---------|
| **Next.js**  | Server-side rendering, file-based routing, API support |
| **Supabase** | Authentication, session management, and easy integration with Postgres |
| **shadcn/ui** | Beautiful and customizable UI components – [ui.shadcn.com](https://ui.shadcn.com/) |
| **TailwindCSS** | Utility-first styling |
| **Vercel**   | Easy deployment and serverless support |

We chose **Next.js** for its developer-friendly features and **Supabase** for instant, secure auth that plays well with Postgres—the same DB backing our n8n chat flow.

---

## ⚙️ Setting Up the Frontend

1. **Clone the repo**  
   ```bash
   git clone https://github.com/A-Locke/nextjs-chatapp.git
   cd nextjs-chatapp
   ```
Currently repo is set to private

2. **Install dependencies**  
   ```bash
   npm install
   ```

3. **Add environment variables**  
   Create a `.env.local` file with the following:
   ```
   NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
   BACKEND_API_URL=https://your-n8n-endpoint.com/webhook/chat
   ```

---

## 🔐 Connecting to Supabase Auth

Supabase makes it easy to add:
- Email/password signups
- Magic link logins
- OAuth (Google, GitHub, etc.)

We use Supabase client libraries in Next.js like this:

```ts
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
)
```

You’ll use Supabase hooks to get the logged-in user and session.

---

## 🔄 Authentication Flow

1. User signs up or logs in through Supabase UI components or custom forms.
2. Upon login, Supabase provides a `user.id` token.
3. On each message send:
   - The frontend sends `user_id`, `message`, and optional `session_id` to the AI agent endpoint.
   - A `session_id` is created if none is provided, and responses are tied to this session.

---

## 🔗 Connecting to the AI Agent Backend

The backend expects:
```json
{
  "user_id": "user-uuid-from-supabase",
  "session_id": "optional-session-id",
  "message": "Hello world!"
}
```

Use `fetch` or `axios` in your Next.js API calls or components to hit the `BACKEND_API_URL` (from `.env`).

---

## 🚀 Deploying to Vercel

1. Connect your GitHub repo to [vercel.com](https://vercel.com).
2. Add your environment variables via Vercel’s dashboard.
3. Deploy!

That’s it — your fullstack AI chat app is live!
It contains modern UI for login and sign in

![Screenshot_13](https://github.com/user-attachments/assets/40adf441-0b14-4998-b4b2-8792b1a48cc2)

Main chat UI

![Screenshot_14](https://github.com/user-attachments/assets/a49758a7-c00b-48d0-8ea4-7f89cdc80a43)

Collapsible sidebar containing session_ids of previous chats of the same user, sorted chronologically. Session_ids are interactible and load that session's history and allow continuation of that chat.

![Screenshot_15](https://github.com/user-attachments/assets/0d225219-8b66-4dcc-b76d-0c37de4a2f04)



---

## 💡 Skills Obtained

- Fullstack project setup using **Next.js**, **Supabase**, and **n8n**
- Implementing **secure user authentication**
- Managing **session-based memory** for AI agents
- Connecting a **frontend to a PostgreSQL-powered backend**
- Working with **PostgreSQL** via Supabase
- Building with beautiful UI using **[shadcn/ui](https://ui.shadcn.com/)**
- **Deploying serverless apps** using Vercel

## 🛠 Future Enchancements

- Secure next.js and supabase connection using RLS set within the database and correct policies, only allow access to own data
- Secure next.js and n8n connection using AWS API Gateway and JWS verification
- Add Google OAuth option
