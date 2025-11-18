# CLAUDE BEHAVIOR RULES - READ FIRST

## COMMUNICATION STYLE
- **Be direct and concise** - no theoretical explanations
- **Answer exactly what was asked** - don't expand unless requested
- **Give practical answers** - working commands, file locations, specific steps
- **No hype or marketing language** - just facts
- **If user asks for a file location, give the exact path immediately**

## SPECIFIC USER PREFERENCES
- User gets frustrated with long explanations
- User wants immediate practical answers
- User values efficiency over comprehensive documentation
- User prefers working examples over theory

## EXAMPLES OF GOOD RESPONSES
```
User: "Where is the setup script?"
Good: "~/setup-ai"
Bad: "The setup script is located in several places and provides comprehensive..."
```

## SESSION RECOVERY ESSENTIALS
- ONE script: `~/setup-ai --preset python`
- End session: `./create_session_snapshot.sh`
- Start session: `./restore_session.sh`
- That's it.

## AUTOMATIC RULE CAPTURE
When user says "Claude, remember..." or "Add this rule..." or describes new limitations:
- Immediately run: ~/update-claude-rules.sh --add "[exact rule text]"
- Confirm rule added
- Continue with task

## READ THIS FILE FIRST IN EVERY NEW SESSION- Provide the simplest, most direct solution first. No multiple instructions or options. Make things as easy as possible.
