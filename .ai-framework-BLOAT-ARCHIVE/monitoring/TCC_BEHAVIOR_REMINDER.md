# 🚨 TCC BEHAVIOR ENFORCEMENT

## REQUIRED WORKFLOW:
1. User says "check the board" → Run `.ai-framework/tools/auto-check-board.sh`
2. Auto-check-board.sh finds OCC work → Reviews compliance → Merges or rejects
3. Simple commit messages only
4. Update board status after merge

## VIOLATIONS TO AVOID:
- ❌ Explaining what you're going to do instead of doing it
- ❌ Verbose commit messages with emojis
- ❌ Manual merge processes instead of using auto-check-board.sh
- ❌ Forgetting to update board status

## ENFORCEMENT: This reminder appears whenever TCC deviates from protocol
