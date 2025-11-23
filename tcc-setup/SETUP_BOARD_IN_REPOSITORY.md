# Setup TCC Board Check in Any Repository

**Add BOARD.md to any repository with AI Collaboration Framework so TCC can naturally discover it.**

---

## 🎯 Quick Setup

In any repository with the AI Collaboration Framework:

```bash
# Download and run the setup script
curl -sSL https://raw.githubusercontent.com/JamesKayten/AI-Collaboration-Management/main/tcc-setup/add-board-file.sh | bash

# Commit the new BOARD.md file
git add BOARD.md
git commit -m "Add TCC board check file"
git push
```

**Done!** TCC can now run "check the board" and will naturally find the BOARD.md file.

---

## 🔄 How It Works

1. **TCC gets "check the board" command**
2. **TCC naturally looks for BOARD.md** (as shown in your example)
3. **TCC clones repository and finds BOARD.md**
4. **BOARD.md contains the automated command**
5. **TCC executes command and gets complete status**

---

## 📋 Manual Setup (Alternative)

If you prefer manual setup:

```bash
# In your repository with .ai-framework/
curl -o BOARD.md https://raw.githubusercontent.com/JamesKayten/AI-Collaboration-Management/main/templates/BOARD_TEMPLATE.md

# Replace placeholder with actual repository URL
sed -i 's|REPOSITORY_URL_PLACEHOLDER|https://github.com/YOUR_ORG/YOUR_REPO|g' BOARD.md

# Commit
git add BOARD.md
git commit -m "Add TCC board check file"
git push
```

---

## ✅ Test It

After setup, test with fresh TCC session:

```
TCC: Check the board for https://github.com/YOUR_ORG/YOUR_REPO
```

**TCC will:**
1. Clone the repository
2. Find BOARD.md
3. Execute the automated command
4. Return complete collaboration status

---

## 🎯 Which Repositories Need This

Add BOARD.md to any repository that has:
- `.ai-framework/` directory
- AI Collaboration Framework installed
- OCC/TCC workflows

**Examples:**
- SimpleCP
- AudioApp
- Any project using the collaboration framework

---

## 🚀 Benefits

- **Natural Discovery**: Works with TCC's natural behavior
- **Zero Training**: TCC automatically understands what to do
- **Self-Contained**: All instructions embedded in the repository
- **Universal**: Works across all repositories with the framework

---

**After adding BOARD.md, "check the board" becomes a natural TCC command.**