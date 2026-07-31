# Chatbox Context Export Technique

## Problem
LLM context windows are limited. Long conversations get truncated or summarized, losing important context.

## Solution
Export the full conversation, start a new chat, and feed the export back to the model.

## Steps

### 1. Export from Chatbox
- Open the conversation
- Go to Settings → Export
- Select **Markdown** format (best for model comprehension)
- Select **All threads** scope
- Save the file

### 2. Start New Chat
- Create a new conversation in Chatbox
- Upload the exported file (📎 attachment)
- Send this prompt:

```
لطفاً این فایل تاریخچه چت رو بخون.
این مکالمه من و تو در مورد [موضوع] بوده.
ادامه بده از همونجایی که متوقف شدیم.
```

### 3. Continue Conversation
The model now has full context from the previous conversation.

## Why Markdown Format?
- Preserves code blocks and formatting
- Model can distinguish user/assistant messages
- Readable and parseable
- Smaller than HTML, more structured than TXT

## Limitations
- If export is >100K tokens, model may still truncate
- Solution: Summarize first, or split into multiple files
- Tool calls and internal state are NOT preserved in export

## Alternative: Manual Context Injection
If export fails (like Chatbox file parsing errors):
1. Open the .md file in a text editor
2. Copy the relevant sections
3. Paste directly into the chat
4. This bypasses Chatbox's file parser entirely
