# AI Agent with RAG Capabilities

## What is RAG?

**Retrieval-Augmented Generation (RAG)** is a powerful AI framework that combines two core techniques:

- **Retrieval**: Fetching relevant information from an external knowledge base or documents at query time.
- **Generation**: Using a language model to generate a final, coherent response, leveraging both its own training and the retrieved information.

RAG significantly boosts the accuracy, freshness, and reliability of AI responses, especially when answers depend on large or dynamic datasets.

---

## Two Parts of Our RAG Implementation

Our updated AI Agent architecture consists of two major enhancements:

1. **RAG Vector Store**
2. **RAG Vector Tool**

These components work together to enable the agent to retrieve document data and generate higher-quality, more informed outputs.

![Screenshot_2](https://github.com/user-attachments/assets/f93ac261-d44b-45ff-83c8-1d4289221091)
![Screenshot_3](https://github.com/user-attachments/assets/896356e7-9be6-4afe-9465-21af41297be5)


---

## RAG Vector Store

The **RAG Vector Store** is implemented using **Supabase** as the backend database for storing document embeddings.

Main Features:
- Documents are ingested from Google Drive automatically when created or updated.
- Each document is processed by splitting it into chunks using a **Recursive Character Text Splitter**.
- Text chunks are then converted into embeddings using **OpenAI's Embeddings model**.
- The resulting vectorized data is stored in the Supabase database under the `documents` table.

Nodes Involved:
- Google Drive Triggers (File Created, File Updated)
- Google Drive File Download
- Recursive Text Splitter
- OpenAI Embeddings
- Supabase Vector Store (Insert Mode)

This process ensures that the knowledge base stays up-to-date dynamically without manual intervention.

---

## RAG Vector Tool

The **RAG Vector Tool** is an n8n integration that makes the stored documents accessible to the AI Agent during conversations.

Main Features:
- Configured in "Retrieve-as-tool" mode.
- Registered under the tool name `n8n_knowledge_base`.
- During chat, the AI agent can query the knowledge base for relevant documents.
- Results from vector search are injected into the prompt context to help formulate a more accurate and relevant answer.

Nodes Involved:
- Supabase Vector Store (Retrieve-as-tool Mode)
- OpenAI Embeddings (for vector retrieval comparison)

This makes the AI truly context-aware beyond its initial training data.

---

## Testing

- Upload [fake data](fake_meeting_notes.txt) to the google drive folder selected in the Upload tool
- Observe that supabase documents table was updated with our chunks
![Screenshot_4](https://github.com/user-attachments/assets/28dd34fd-a191-428c-ab3b-2aaa94ad9f28)

- Query the chatbot for some information contailed in the fake data and observe

![Screenshot_1](https://github.com/user-attachments/assets/acaaa182-2926-4141-9178-352d0fba8ef3)

---


## Skills Obtained

With the new RAG upgrades, our AI Agent now possesses:

- **Document Ingestion Pipeline**: Auto-loads and processes new files from Google Drive.
- **Dynamic Knowledge Retrieval**: Retrieves real-time information at inference time.
- **Vector Search and Ranking**: Finds the most semantically similar document chunks.
- **Prompt Augmentation**: Uses retrieved knowledge to inform and improve responses.
- **Improved Response Accuracy**: Reduces hallucinations and enables grounded responses.
- **Persistent Memory Storage**: Continues using PostgreSQL to manage conversational history per session.

---

> This RAG implementation takes our AI Agent from a simple chatbot to a true intelligent assistant with evolving knowledge and memory!
