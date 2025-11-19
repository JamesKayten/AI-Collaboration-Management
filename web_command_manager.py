#!/usr/bin/env python3
"""
===================================================================================
AI Framework Command Manager - Web Interface
===================================================================================

PURPOSE:
    Provides a browser-based GUI for creating custom voice commands for Claude AI.
    Non-technical users can create commands without touching code or terminals.

USAGE:
    Run: python3 web_command_manager.py
    Then open browser to: http://localhost:5555

HOW IT WORKS:
    1. Runs a simple web server (Flask) on your computer
    2. Serves an HTML page with forms for creating commands
    3. When you submit the form, it creates a .md file in .claude/commands/
    4. Claude reads these .md files and responds to the phrases you define

REQUIREMENTS:
    - Python 3.6+
    - Flask (install with: pip3 install flask)

CREATED BY: AI collaboration between OCC and TCC
DATE: 2025-11-19
===================================================================================
"""

# Import required libraries
from flask import Flask, render_template_string, request, jsonify  # Web framework
from pathlib import Path  # Modern file path handling (better than os.path)
import json  # For reading/writing JSON data

# Create the Flask web application instance
# Flask is a lightweight web framework - it handles HTTP requests and responses
app = Flask(__name__)

# ============================================================================
# CONFIGURATION: Where command files are stored
# ============================================================================

# Define where command files live on the filesystem
# Path.home() gets the user's home directory (e.g., /home/username or C:\Users\username)
# We then append the subdirectories to create the full path
COMMANDS_DIR = Path.home() / "AI-Collaboration-Management" / ".claude" / "commands"

# Create the directory if it doesn't exist yet
# parents=True means "create parent directories if needed"
# exist_ok=True means "don't error if directory already exists"
COMMANDS_DIR.mkdir(parents=True, exist_ok=True)

# ============================================================================
# HTML TEMPLATE: The user interface (what you see in browser)
# ============================================================================

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>AI Command Manager</title>
    <style>
        /* CSS STYLING: Makes the page look pretty and professional */

        /* Reset default browser styles for consistency */
        * { margin: 0; padding: 0; box-sizing: border-box; }

        /* Body: Full-screen purple gradient background */
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;  /* Full viewport height */
            padding: 20px;
        }

        /* Main container: White card in center of screen */
        .container {
            max-width: 1200px;  /* Don't get too wide on large screens */
            margin: 0 auto;  /* Center horizontally */
            background: white;
            border-radius: 20px;  /* Rounded corners */
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);  /* Drop shadow */
            overflow: hidden;  /* Clip children to rounded corners */
        }

        /* Header: Purple bar at top */
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .header h1 { font-size: 2em; margin-bottom: 10px; }
        .header p { opacity: 0.9; font-size: 1.1em; }

        /* Content: Two-column layout (create form on left, command list on right) */
        .content { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; padding: 30px; }

        /* Panel: Gray boxes containing form and list */
        .panel {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .panel h2 {
            color: #667eea;
            margin-bottom: 20px;
            font-size: 1.5em;
        }

        /* Form elements: Input fields and text areas */
        .form-group { margin-bottom: 20px; }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        input, textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s;  /* Smooth color change on focus */
        }
        input:focus, textarea:focus {
            outline: none;  /* Remove default browser outline */
            border-color: #667eea;  /* Purple border when focused */
        }
        textarea { resize: vertical; min-height: 120px; font-family: monospace; }

        /* Button: Large purple gradient button */
        button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            transition: transform 0.2s, box-shadow 0.2s;  /* Smooth hover animation */
        }
        button:hover {
            transform: translateY(-2px);  /* Lift up slightly */
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);  /* Add shadow */
        }
        button:active { transform: translateY(0); }  /* Press down when clicked */

        /* Command list: Scrollable area showing existing commands */
        .command-list {
            max-height: 400px;
            overflow-y: auto;  /* Scroll if list gets long */
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 10px;
        }

        /* Individual command items in the list */
        .command-item {
            padding: 15px;
            margin-bottom: 10px;
            background: white;
            border-radius: 8px;
            border-left: 4px solid #667eea;  /* Purple accent bar */
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .command-item:hover {
            transform: translateX(5px);  /* Slide right on hover */
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .command-item h3 { color: #667eea; margin-bottom: 5px; }
        .command-item p { color: #666; font-size: 0.9em; }

        /* Delete button: Red button inside command items */
        .delete-btn {
            background: #ef4444;
            padding: 8px 15px;
            font-size: 0.9em;
            width: auto;
            margin-top: 10px;
        }
        .delete-btn:hover { background: #dc2626; }

        /* Success notification: Green popup in top-right corner */
        .success {
            position: fixed;
            top: 20px;
            right: 20px;
            background: #10b981;
            color: white;
            padding: 15px 25px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            display: none;  /* Hidden by default */
            animation: slideIn 0.3s;  /* Slide in from right */
        }

        /* Animation: Slide notification in from right */
        @keyframes slideIn {
            from { transform: translateX(400px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        /* Responsive: Stack columns on small screens (phones/tablets) */
        @media (max-width: 768px) {
            .content { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <!-- MAIN CONTAINER -->
    <div class="container">
        <!-- HEADER: Title and description -->
        <div class="header">
            <h1>🎯 AI Command Manager</h1>
            <p>Create voice commands - no code, no terminal required</p>
        </div>

        <!-- CONTENT: Two-panel layout -->
        <div class="content">
            <!-- LEFT PANEL: Form for creating new commands -->
            <div class="panel">
                <h2>Create New Command</h2>
                <form id="commandForm">
                    <!-- Field 1: The phrase you want to say -->
                    <div class="form-group">
                        <label>What phrase to say:</label>
                        <input type="text" id="phrase" placeholder="e.g., shit's ready" required>
                    </div>

                    <!-- Field 2: What the command should do (script or instructions) -->
                    <div class="form-group">
                        <label>What it should do:</label>
                        <textarea id="action" placeholder="e.g., ./verify_test.sh&#10;&#10;or&#10;&#10;Run all tests and report results" required></textarea>
                    </div>

                    <!-- Field 3: Description (optional) -->
                    <div class="form-group">
                        <label>Description (optional):</label>
                        <input type="text" id="description" placeholder="e.g., Verify framework test">
                    </div>

                    <!-- Field 4: Alternative phrases that trigger same command -->
                    <div class="form-group">
                        <label>Additional phrases (comma separated):</label>
                        <input type="text" id="aliases" placeholder="e.g., check it, verify this, test ready">
                    </div>

                    <!-- Submit button -->
                    <button type="submit">CREATE COMMAND</button>
                </form>
            </div>

            <!-- RIGHT PANEL: List of existing commands -->
            <div class="panel">
                <h2>Your Commands</h2>
                <div class="command-list" id="commandList">
                    <p style="text-align: center; color: #999;">Loading...</p>
                </div>
            </div>
        </div>
    </div>

    <!-- SUCCESS NOTIFICATION: Appears in top-right when command created/deleted -->
    <div class="success" id="successMsg"></div>

    <script>
        /* ===================================================================
           JAVASCRIPT: Makes the page interactive
           =================================================================== */

        /**
         * Show success notification in top-right corner
         * @param {string} msg - Message to display
         */
        function showSuccess(msg) {
            const el = document.getElementById('successMsg');
            el.textContent = msg;
            el.style.display = 'block';  // Make visible
            // Auto-hide after 3 seconds
            setTimeout(() => el.style.display = 'none', 3000);
        }

        /**
         * Load all existing commands from server and display them
         * This function:
         * 1. Calls the /api/commands endpoint
         * 2. Gets back a JSON array of commands
         * 3. Builds HTML for each command
         * 4. Inserts into the command list
         */
        function loadCommands() {
            // Fetch data from server API endpoint
            fetch('/api/commands')
                .then(r => r.json())  // Parse JSON response
                .then(commands => {
                    const list = document.getElementById('commandList');

                    // If no commands exist, show helpful message
                    if (commands.length === 0) {
                        list.innerHTML = '<p style="text-align: center; color: #999;">No commands yet. Create one!</p>';
                        return;
                    }

                    // Build HTML for each command using template literals
                    // .map() transforms array into HTML strings
                    // .join('') combines into single HTML string
                    list.innerHTML = commands.map(cmd => `
                        <div class="command-item">
                            <h3>"${cmd.phrase}"</h3>
                            <p>${cmd.description}</p>
                            <button class="delete-btn" onclick="deleteCommand('${cmd.filename}')">Delete</button>
                        </div>
                    `).join('');
                });
        }

        /**
         * Handle form submission (create new command)
         * This prevents default form behavior and instead sends data via AJAX
         */
        document.getElementById('commandForm').addEventListener('submit', (e) => {
            e.preventDefault();  // Stop form from reloading page

            // Collect form data into object
            const data = {
                phrase: document.getElementById('phrase').value,
                action: document.getElementById('action').value,
                description: document.getElementById('description').value,
                aliases: document.getElementById('aliases').value
            };

            // Send POST request to server with JSON data
            fetch('/api/commands', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(data)
            })
            .then(r => r.json())  // Parse response
            .then(result => {
                // Success! Show notification and refresh
                showSuccess(`Command created! Say: "${data.phrase}"`);
                document.getElementById('commandForm').reset();  // Clear form
                loadCommands();  // Reload command list
            })
            .catch(err => alert('Error creating command'));
        });

        /**
         * Delete a command
         * @param {string} filename - Name of command file (without .md extension)
         */
        function deleteCommand(filename) {
            // Confirm before deleting
            if (!confirm('Delete this command?')) return;

            // Send DELETE request to server
            fetch(`/api/commands/${filename}`, {method: 'DELETE'})
                .then(() => {
                    showSuccess('Command deleted');
                    loadCommands();  // Refresh list
                });
        }

        // On page load, immediately load existing commands
        loadCommands();
    </script>
</body>
</html>
"""

# ============================================================================
# API ROUTES: These functions handle HTTP requests from the browser
# ============================================================================

@app.route('/')
def index():
    """
    HOME PAGE: Serves the main HTML interface

    When you visit http://localhost:5555, this function runs and returns
    the HTML template defined above.
    """
    return render_template_string(HTML_TEMPLATE)


@app.route('/api/commands', methods=['GET'])
def get_commands():
    """
    GET ALL COMMANDS: Returns list of existing commands as JSON

    This function:
    1. Reads all .md files from the commands directory
    2. Parses each file to extract the phrase and description
    3. Returns them as JSON array

    RESPONSE FORMAT:
    [
        {
            "filename": "shits-ready",
            "phrase": "shit's ready",
            "description": "Verify framework test"
        },
        ...
    ]
    """
    commands = []

    # Loop through all .md files in commands directory
    # .glob("*.md") finds all files ending in .md
    for filepath in COMMANDS_DIR.glob("*.md"):
        # Read entire file contents as string
        content = filepath.read_text()
        lines = content.split('\n')  # Split into individual lines

        # Default values if we can't parse the file
        desc = "Custom command"
        phrase = filepath.stem.replace('-', ' ')  # Convert filename to phrase

        # Parse the YAML frontmatter (lines between --- and ---)
        for line in lines:
            # Look for description field
            if line.startswith('description:'):
                desc = line.split(':', 1)[1].strip()  # Get everything after ':'

            # Look for aliases field (JSON array)
            elif line.startswith('aliases:'):
                try:
                    # Extract JSON array and parse it
                    aliases = json.loads(line.split(':', 1)[1].strip())
                    # Use first alias as the main phrase
                    if aliases:
                        phrase = aliases[0]
                except:
                    # If parsing fails, just use filename
                    pass

        # Add this command to the list
        commands.append({
            'filename': filepath.stem,  # Filename without extension
            'phrase': phrase,
            'description': desc
        })

    # Return as JSON (Flask converts Python dict/list to JSON automatically)
    return jsonify(commands)


@app.route('/api/commands', methods=['POST'])
def create_command():
    """
    CREATE COMMAND: Handles command creation requests

    This function:
    1. Receives JSON data from the form
    2. Validates and processes the data
    3. Creates a .md file with the command definition
    4. Returns success response

    REQUEST FORMAT:
    {
        "phrase": "shit's ready",
        "action": "./verify_test.sh",
        "description": "Verify framework test",
        "aliases": "check it, verify this"
    }
    """
    # Get JSON data sent from browser
    data = request.json

    # Extract fields and remove whitespace
    phrase = data['phrase'].strip()
    action = data['action'].strip()
    desc = data.get('description', 'Custom command').strip()
    aliases = data.get('aliases', '').strip()

    # Build list of all phrases (main phrase + additional aliases)
    all_phrases = [phrase]
    if aliases:
        # Split by comma, strip whitespace, filter empty strings
        all_phrases.extend([a.strip() for a in aliases.split(',') if a.strip()])

    # Generate filename from phrase:
    # 1. Convert to lowercase
    # 2. Remove apostrophes
    # 3. Replace spaces with hyphens
    # 4. Keep only letters, numbers, and hyphens
    filename = phrase.lower().replace("'", "").replace(" ", "-")
    filename = ''.join(c for c in filename if c.isalnum() or c == '-')

    # Build full filepath
    filepath = COMMANDS_DIR / f"{filename}.md"

    # Create command file contents in YAML frontmatter + markdown format
    # This is the format Claude expects
    content = f"""---
description: {desc}
aliases: {json.dumps(all_phrases)}
---

{action}
"""

    # Write file to disk
    filepath.write_text(content)

    # Return success response
    return jsonify({'success': True, 'filename': filename})


@app.route('/api/commands/<filename>', methods=['DELETE'])
def delete_command(filename):
    """
    DELETE COMMAND: Removes a command file

    This function:
    1. Receives filename from URL (e.g., /api/commands/shits-ready)
    2. Checks if file exists
    3. Deletes the file
    4. Returns success/failure response

    Args:
        filename: Name of command file (without .md extension)

    Returns:
        JSON response indicating success or failure
    """
    # Build filepath
    filepath = COMMANDS_DIR / f"{filename}.md"

    # Check if file exists
    if filepath.exists():
        # Delete the file
        filepath.unlink()
        return jsonify({'success': True})

    # File doesn't exist - return 404 error
    return jsonify({'success': False}), 404


# ============================================================================
# MAIN: Start the web server
# ============================================================================

if __name__ == '__main__':
    """
    This runs when you execute: python3 web_command_manager.py

    It starts the Flask web server on port 5555 and makes it accessible
    from your browser at http://localhost:5555
    """
    # Print startup message
    print("\n🎯 AI Command Manager")
    print("=" * 50)
    print("Open your browser to: http://localhost:5555")
    print("=" * 50)
    print("\nPress Ctrl+C to stop\n")

    # Start Flask server
    # host='0.0.0.0' means accessible from other devices on network
    # port=5555 is the port number
    # debug=False turns off debug mode (safer for production)
    app.run(host='0.0.0.0', port=5555, debug=False)
