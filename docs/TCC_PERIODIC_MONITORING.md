# TCC Periodic Monitoring (Subscription-Efficient)

## 🎯 Goal

Have TCC check GitHub periodically for OCC updates **without** burning through your subscription.

---

## 💰 Subscription-Saving Strategies

### Strategy 1: **Manual Trigger** (Recommended - Zero Cost)

**When to use**: You know when OCC finishes work

**How it works**:
```bash
# You tell OCC to implement something
Browser: "Add login component to SimpleCP"

# OCC works, commits, pushes, tells you "Done!"

# You manually trigger TCC
Terminal: "work ready"
```

**Pros**:
- ✅ Zero wasted subscription tokens
- ✅ You control when TCC runs
- ✅ Simple and predictable

**Cons**:
- ⚠️ Requires you to remember to run it

---

### Strategy 2: **Scheduled Check** (Low Cost)

**When to use**: You want automatic checks but only at specific times

**How it works**:
```bash
# Cron job runs every hour during work hours (9am-6pm)
0 9-18 * * * cd /path/to/SimpleCP && claude "work ready"
```

**Pros**:
- ✅ Automatic
- ✅ Controlled frequency (minimal token usage)
- ✅ Only runs during work hours

**Cons**:
- ⚠️ May check when no work is ready
- ⚠️ Uses tokens even if nothing to do

**Cost**: ~9-10 checks per day = minimal tokens

---

### Strategy 3: **GitHub Webhook Trigger** (Best - Zero Cost)

**When to use**: You want instant notification when OCC pushes

**How it works**:
1. Set up GitHub webhook on your repository
2. Webhook calls a local script when code is pushed
3. Script triggers TCC only when actual changes detected

**Setup**:
```bash
# 1. Create webhook receiver script
cat > ~/.local/bin/github-webhook-receiver.sh << 'EOF'
#!/bin/bash
# Receives GitHub webhook and triggers TCC

# Only process push events
if [ "$EVENT" = "push" ]; then
    # Check if push was by OCC (not TCC)
    if echo "$PAYLOAD" | jq -r '.pusher.name' | grep -q "online-claude"; then
        cd /path/to/SimpleCP
        claude "work ready"
    fi
fi
EOF

# 2. Set up simple webhook listener (using webhook npm package)
npm install -g webhook
webhook --hooks hooks.json --port 9000
```

**Pros**:
- ✅ Instant notification
- ✅ Zero cost (only runs when needed)
- ✅ Fully automatic

**Cons**:
- ⚠️ Requires webhook setup
- ⚠️ Need to expose local port OR use GitHub Actions

---

### Strategy 4: **Git Poll with Smart Detection** (Medium Cost)

**When to use**: Simple automation without webhook setup

**How it works**:
```bash
#!/bin/bash
# Smart polling script that only triggers TCC when changes detected

REPO_DIR="/path/to/SimpleCP"
LAST_COMMIT_FILE="$HOME/.tcc-last-commit"

cd "$REPO_DIR"

# Fetch quietly
git fetch --quiet

# Get latest remote commit
REMOTE_COMMIT=$(git rev-parse origin/main)

# Get last processed commit
LAST_COMMIT=$(cat "$LAST_COMMIT_FILE" 2>/dev/null || echo "")

# Only run TCC if there are new commits
if [ "$REMOTE_COMMIT" != "$LAST_COMMIT" ]; then
    echo "New commits detected, running TCC..."
    claude "work ready"
    echo "$REMOTE_COMMIT" > "$LAST_COMMIT_FILE"
else
    echo "No new commits, skipping TCC"
fi
```

**Schedule**:
```bash
# Check every 15 minutes during work hours
*/15 9-18 * * * /path/to/smart-poll.sh
```

**Pros**:
- ✅ Only runs TCC when changes exist
- ✅ Simple to set up
- ✅ No webhook needed

**Cons**:
- ⚠️ Git fetch uses minimal bandwidth
- ⚠️ Slight delay (up to 15 min)

**Cost**: ~40 fetches/day, but TCC only runs when needed

---

## 🎯 Recommended Approach

### **Hybrid: Manual + Smart Polling**

1. **During active development** (you're at computer):
   - Use manual trigger: `"work ready"`
   - Zero cost, instant

2. **During async work** (you step away):
   - Enable smart polling (every 30 min)
   - TCC checks while you're gone
   - You come back to completed validations

---

## 📋 Implementation Examples

### Example 1: Simple Cron Job (Manual Backup)

```bash
# ~/.tcc-monitor.sh
#!/bin/bash
cd /path/to/SimpleCP
git fetch --quiet

# Check if any new commits from OCC
NEW_COMMITS=$(git log HEAD..origin/main --oneline --author="claude" | wc -l)

if [ "$NEW_COMMITS" -gt 0 ]; then
    echo "$(date): New commits found, running validation"
    claude "work ready"
else
    echo "$(date): No new commits, skipping"
fi
```

Schedule:
```bash
crontab -e
# Check every 30 minutes, 9am-6pm, weekdays
*/30 9-18 * * 1-5 /path/to/.tcc-monitor.sh >> /tmp/tcc-monitor.log 2>&1
```

---

### Example 2: GitHub Actions (Cloud-Based)

Create `.github/workflows/tcc-validation.yml`:
```yaml
name: TCC Validation Trigger

on:
  push:
    branches: [ 'feature/*' ]
  # Only when OCC pushes
  # (you can detect this via commit message or author)

jobs:
  notify-tcc:
    runs-on: ubuntu-latest
    steps:
      - name: Check if pushed by OCC
        id: check_author
        run: |
          if [[ "${{ github.event.head_commit.author.name }}" == *"Claude"* ]]; then
            echo "occ_push=true" >> $GITHUB_OUTPUT
          fi

      - name: Trigger TCC (via webhook to your local machine)
        if: steps.check_author.outputs.occ_push == 'true'
        run: |
          curl -X POST https://your-local-webhook-url/tcc-trigger
```

---

### Example 3: File Watcher (Instant, Local Only)

```bash
# Install watchman or fswatch
brew install watchman  # macOS
# or
sudo apt install inotify-tools  # Linux

# Watch for .git/FETCH_HEAD changes
#!/bin/bash
cd /path/to/SimpleCP

inotifywait -m -e modify .git/FETCH_HEAD | while read event; do
    echo "Git fetch detected, checking for new commits..."
    NEW_COMMITS=$(git log HEAD..origin/main --oneline | wc -l)

    if [ "$NEW_COMMITS" -gt 0 ]; then
        claude "work ready"
    fi
done
```

---

## 💡 Token Usage Estimates

### Manual Only
- **Cost**: 0 tokens when idle
- **Use**: Only when you run `"work ready"`
- **Best for**: Active development sessions

### Smart Polling (30 min intervals)
- **Fetches per day**: ~20 (during work hours)
- **TCC runs**: Only when changes detected
- **Cost**: ~5-10 validation runs per day (depends on OCC activity)
- **Best for**: Async collaboration

### Webhook-Based
- **Cost**: 0 tokens when idle
- **TCC runs**: Only when OCC pushes
- **Best for**: Fully automated workflow

---

## 🎯 Recommendation

**Start with Manual, add Smart Polling if needed**:

```bash
# 1. Primarily use manual
Terminal: "work ready"  # When you know OCC finished

# 2. Add safety net (optional)
# Check once an hour during work day
0 9-18 * * * cd /path/to/SimpleCP && git fetch -q && [ $(git log HEAD..origin/main --oneline | wc -l) -gt 0 ] && claude "work ready"
```

**This gives you**:
- Instant validation when you manually trigger
- Automatic catch-up if you forget
- Minimal token usage (only 1-2 extra checks per day)

---

## 🔧 Smart Monitoring Script

Here's a production-ready script:

```bash
#!/bin/bash
# ~/.local/bin/tcc-smart-monitor.sh
# Efficient TCC monitoring with subscription awareness

set -e

REPO_PATH="/path/to/SimpleCP"
STATE_FILE="$HOME/.tcc-monitor-state"
LOG_FILE="$HOME/.tcc-monitor.log"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

cd "$REPO_PATH"

# Fetch quietly
git fetch --quiet 2>&1 | tee -a "$LOG_FILE"

# Get current state
CURRENT_COMMIT=$(git rev-parse origin/main)
LAST_COMMIT=$(cat "$STATE_FILE" 2>/dev/null || echo "")

if [ "$CURRENT_COMMIT" = "$LAST_COMMIT" ]; then
    log "No changes detected - skipping TCC (saving subscription)"
    exit 0
fi

log "New commits detected:"
git log --oneline "$LAST_COMMIT..$CURRENT_COMMIT" 2>/dev/null || git log --oneline -5

# Check if commits are from OCC
OCC_COMMITS=$(git log "$LAST_COMMIT..$CURRENT_COMMIT" --author="Claude" --oneline | wc -l)

if [ "$OCC_COMMITS" -eq 0 ]; then
    log "No commits from OCC - skipping TCC"
    echo "$CURRENT_COMMIT" > "$STATE_FILE"
    exit 0
fi

log "Running TCC validation..."
claude "work ready"

# Update state
echo "$CURRENT_COMMIT" > "$STATE_FILE"
log "TCC completed - state saved"
```

**Schedule it**:
```bash
# Check every 30 minutes during work hours
*/30 9-18 * * * /path/to/.local/bin/tcc-smart-monitor.sh
```

---

## ✅ Best Practice

**The winning combination**:

1. **Primary**: Manual trigger when you're actively working
   ```bash
   "work ready"
   ```

2. **Backup**: Smart poll 2-3 times during work day
   ```bash
   0 10,14,17 * * * /path/to/tcc-smart-monitor.sh
   ```

3. **Result**:
   - Instant when manual
   - Automatic safety net
   - Minimal token usage (~3-5 checks/day)
   - Only runs TCC when OCC actually pushed changes

---

**This keeps your subscription usage minimal while ensuring TCC catches all OCC updates!** 🎯
