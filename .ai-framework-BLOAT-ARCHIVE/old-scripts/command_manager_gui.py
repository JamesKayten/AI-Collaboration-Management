#!/usr/bin/env python3
"""
AI Framework Command Manager - GUI
Create and manage custom Claude commands without touching code.
"""

import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext
import os
import json
from pathlib import Path

class CommandManagerGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("AI Framework Command Manager")
        self.root.geometry("900x700")

        # Command directory
        self.commands_dir = Path.home() / "AI-Collaboration-Management" / ".claude" / "commands"
        self.commands_dir.mkdir(parents=True, exist_ok=True)

        # Create UI
        self.create_widgets()
        self.refresh_command_list()

    def create_widgets(self):
        # Main container
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))

        # Title
        title = ttk.Label(main_frame, text="Create Custom Voice Commands",
                         font=('Helvetica', 16, 'bold'))
        title.grid(row=0, column=0, columnspan=2, pady=10)

        # Left side - Create new command
        create_frame = ttk.LabelFrame(main_frame, text="Create New Command", padding="10")
        create_frame.grid(row=1, column=0, sticky=(tk.W, tk.E, tk.N, tk.S), padx=5)

        # Phrase input
        ttk.Label(create_frame, text="What phrase to say:").grid(row=0, column=0, sticky=tk.W, pady=5)
        self.phrase_entry = ttk.Entry(create_frame, width=40)
        self.phrase_entry.grid(row=1, column=0, sticky=(tk.W, tk.E), pady=5)
        self.phrase_entry.insert(0, "Example: shit's ready")

        # Action input
        ttk.Label(create_frame, text="What it should do:").grid(row=2, column=0, sticky=tk.W, pady=5)
        self.action_text = scrolledtext.ScrolledText(create_frame, width=50, height=8)
        self.action_text.grid(row=3, column=0, sticky=(tk.W, tk.E), pady=5)
        self.action_text.insert(1.0, "Example:\n./verify_test.sh\n\nOr:\nRun all tests and report results")

        # Description input
        ttk.Label(create_frame, text="Description (optional):").grid(row=4, column=0, sticky=tk.W, pady=5)
        self.desc_entry = ttk.Entry(create_frame, width=40)
        self.desc_entry.grid(row=5, column=0, sticky=(tk.W, tk.E), pady=5)
        self.desc_entry.insert(0, "Example: Verify framework test")

        # Additional aliases
        ttk.Label(create_frame, text="Additional phrases (comma separated):").grid(row=6, column=0, sticky=tk.W, pady=5)
        self.aliases_entry = ttk.Entry(create_frame, width=40)
        self.aliases_entry.grid(row=7, column=0, sticky=(tk.W, tk.E), pady=5)
        self.aliases_entry.insert(0, "Example: check it, verify this, test ready")

        # Create button
        create_btn = ttk.Button(create_frame, text="CREATE COMMAND",
                               command=self.create_command, style='Accent.TButton')
        create_btn.grid(row=8, column=0, pady=20)

        # Right side - Existing commands
        list_frame = ttk.LabelFrame(main_frame, text="Existing Commands", padding="10")
        list_frame.grid(row=1, column=1, sticky=(tk.W, tk.E, tk.N, tk.S), padx=5)

        # Command listbox
        self.command_listbox = tk.Listbox(list_frame, width=40, height=20)
        self.command_listbox.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        self.command_listbox.bind('<<ListboxSelect>>', self.on_command_select)

        # Buttons for existing commands
        btn_frame = ttk.Frame(list_frame)
        btn_frame.grid(row=1, column=0, pady=10)

        ttk.Button(btn_frame, text="View Details", command=self.view_command).pack(side=tk.LEFT, padx=5)
        ttk.Button(btn_frame, text="Delete", command=self.delete_command).pack(side=tk.LEFT, padx=5)
        ttk.Button(btn_frame, text="Refresh", command=self.refresh_command_list).pack(side=tk.LEFT, padx=5)

        # Status bar
        self.status_label = ttk.Label(main_frame, text="Ready", relief=tk.SUNKEN)
        self.status_label.grid(row=2, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=5)

        # Configure grid weights
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)
        main_frame.rowconfigure(1, weight=1)

    def create_command(self):
        # Get inputs
        phrase = self.phrase_entry.get().strip()
        action = self.action_text.get(1.0, tk.END).strip()
        desc = self.desc_entry.get().strip()
        aliases = self.aliases_entry.get().strip()

        # Clear placeholder text
        if phrase.startswith("Example:"):
            phrase = ""
        if action.startswith("Example:"):
            action = ""
        if desc.startswith("Example:"):
            desc = ""
        if aliases.startswith("Example:"):
            aliases = ""

        # Validate
        if not phrase:
            messagebox.showerror("Error", "Please enter a phrase")
            return
        if not action:
            messagebox.showerror("Error", "Please enter what the command should do")
            return

        # Parse aliases
        all_phrases = [phrase]
        if aliases:
            all_phrases.extend([a.strip() for a in aliases.split(',') if a.strip()])

        # Generate filename
        filename = phrase.lower().replace("'", "").replace(" ", "-")
        filename = ''.join(c for c in filename if c.isalnum() or c == '-')
        filepath = self.commands_dir / f"{filename}.md"

        # Create command file
        content = f"""---
description: {desc or 'Custom command'}
aliases: {json.dumps(all_phrases)}
---

{action}
"""

        try:
            filepath.write_text(content)
            messagebox.showinfo("Success",
                f"Command created!\n\nYou can now say:\n'{phrase}'\n\nAnd Claude will execute it.")
            self.status_label.config(text=f"Created: {phrase}")
            self.refresh_command_list()
            self.clear_form()
        except Exception as e:
            messagebox.showerror("Error", f"Failed to create command:\n{e}")

    def clear_form(self):
        self.phrase_entry.delete(0, tk.END)
        self.action_text.delete(1.0, tk.END)
        self.desc_entry.delete(0, tk.END)
        self.aliases_entry.delete(0, tk.END)

    def refresh_command_list(self):
        self.command_listbox.delete(0, tk.END)

        # List all command files
        for filepath in sorted(self.commands_dir.glob("*.md")):
            self.command_listbox.insert(tk.END, filepath.stem)

        self.status_label.config(text=f"Found {self.command_listbox.size()} commands")

    def on_command_select(self, event):
        selection = self.command_listbox.curselection()
        if selection:
            self.status_label.config(text=f"Selected: {self.command_listbox.get(selection[0])}")

    def view_command(self):
        selection = self.command_listbox.curselection()
        if not selection:
            messagebox.showwarning("Warning", "Please select a command first")
            return

        filename = self.command_listbox.get(selection[0])
        filepath = self.commands_dir / f"{filename}.md"

        # Read and display
        content = filepath.read_text()

        # Show in new window
        viewer = tk.Toplevel(self.root)
        viewer.title(f"Command: {filename}")
        viewer.geometry("600x400")

        text = scrolledtext.ScrolledText(viewer, width=70, height=20)
        text.pack(padx=10, pady=10, fill=tk.BOTH, expand=True)
        text.insert(1.0, content)
        text.config(state=tk.DISABLED)

        ttk.Button(viewer, text="Close", command=viewer.destroy).pack(pady=10)

    def delete_command(self):
        selection = self.command_listbox.curselection()
        if not selection:
            messagebox.showwarning("Warning", "Please select a command first")
            return

        filename = self.command_listbox.get(selection[0])

        if messagebox.askyesno("Confirm Delete",
                              f"Delete command '{filename}'?"):
            filepath = self.commands_dir / f"{filename}.md"
            filepath.unlink()
            self.status_label.config(text=f"Deleted: {filename}")
            self.refresh_command_list()


if __name__ == "__main__":
    root = tk.Tk()
    app = CommandManagerGUI(root)
    root.mainloop()
