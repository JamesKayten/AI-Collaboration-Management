# Frequently Asked Questions

## General

**Q: What AI tools does this work with?**
A: Any combination! Local AI (Claude Code, Cursor, Windsurf) + Online AI (Claude, ChatGPT, Gemini) or even just one type. The framework is AI-agnostic.

**Q: How long does setup take?**
A: 5 minutes for installation, 15-30 minutes for customization (depending on how much you want to configure).

**Q: Can I use this with existing projects?**
A: Yes! The framework installs into a `docs/` folder and doesn't modify your existing code.

**Q: Does this require cloud services or API keys?**
A: No. It's purely file-based communication. The AIs read/write markdown files in your repository.

**Q: Is this production-ready?**
A: Yes. It's been tested on React, Python, and Java projects in production use.

## Installation

**Q: What if I don't have a git repository yet?**
A: Run `git init` in your project directory first, then install the framework.

**Q: Can I install on Windows?**
A: Yes, but you'll need WSL (Windows Subsystem for Linux) or Git Bash. Native Windows support coming soon.

**Q: What if installation fails?**
A: Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md). Most common issue is not being in a git repository.

## Usage

**Q: Do I need both Local AI and Online AI?**
A: No. You can use just one, but the collaboration works best with both (Local for validation, Online for implementation).

**Q: How do I customize validation rules?**
A: Edit `docs/ai_communication/VALIDATION_RULES.md` in your project. You can set file size limits, test coverage, and more.

**Q: What languages are supported?**
A: All of them! The framework is language-agnostic. You just need to configure validation commands for your specific tools.

**Q: Can I use this for multiple projects?**
A: Yes. Install separately in each project and customize rules per project.

## TCC (Terminal Control Center)

**Q: What is TCC and do I need it?**
A: TCC is a persistent configuration system for terminal-based AI agents (like Claude Code). You need it if:
- You're using Claude Code or another terminal AI
- You want your AI to have automatic access to framework rules
- You work across multiple projects and want consistent AI behavior

If you only use browser-based AI or don't use terminal AI, you don't need TCC.

**Q: How do I install TCC?**
A: Tell your terminal AI: "Please install the TCC configuration system on my local machine. Follow the instructions in tcc-setup/INSTRUCTIONS_FOR_TCC.md"

Or run directly:
```bash
curl -sSL https://raw.githubusercontent.com/JamesKayten/AI-Collaboration-Management/main/tcc-setup/install-tcc.sh | bash
```

**Q: What does TCC install on my machine?**
A: TCC installs:
- `~/.tccrc` - Environment variables and configuration
- `~/tcc-init.sh` - Session initialization script
- `~/AI-Collaboration-Management/` - Framework repository clone
- Updates to `~/.bashrc` to auto-load TCC configuration

**Q: How does TCC work?**
A: After installation, run `source ~/tcc-init.sh` at the start of each terminal session. This gives your AI access to all framework rules, protocols, and helper commands.

**Q: What are the TCC helper commands?**
A: After TCC installation, you have:
- `tcc-status` - Display framework and project status
- `tcc-board` - View current project's BOARD.md
- `tcc-rules` - Display GENERAL_AI_RULES.md
- `tcc-startup` - Display STARTUP_PROTOCOL.md
- `tcc-setup` - Configure TCC for current project
- `tcc-sync` - Update framework with latest changes

**Q: Does TCC work with the standard project installation?**
A: Yes! TCC is complementary. Use standard installation for project-specific setup, and TCC for terminal AI persistent access to the framework. They work together perfectly.

**Q: Can I uninstall TCC?**
A: Yes. Remove the TCC configuration:
```bash
rm ~/.tccrc ~/tcc-init.sh
# Remove the TCC lines from ~/.bashrc
# Optionally remove ~/AI-Collaboration-Management/ if not needed
```

**Q: Do I need to install TCC for each project?**
A: No! TCC is a one-time installation on your machine. Once installed, it works across all your projects automatically.

## Technical

**Q: How does AI-to-AI communication work?**
A: AIs read and write markdown files in `docs/ai_communication/`. Local AI creates reports, Online AI reads them and responds.

**Q: Does this integrate with CI/CD?**
A: Yes. You can run validation commands in GitHub Actions, GitLab CI, or any CI/CD platform. See examples/.

**Q: Can I add custom validation scripts?**
A: Yes! Add any scripts to your validation rules. Examples: security scanners, performance tests, custom linters.

**Q: Is this open source?**
A: Yes, MIT licensed. Free to use in personal and commercial projects.

## Contributing

**Q: How can I contribute?**
A: See [CONTRIBUTING.md](CONTRIBUTING.md). We welcome validation templates, integration examples, docs improvements, and bug fixes.

**Q: I found a bug, what do I do?**
A: Open an issue on GitHub with reproduction steps. We typically respond within 24 hours.

**Q: Can I suggest features?**
A: Absolutely! Open a feature request issue or start a Discussion.

## Still have questions?

- [GitHub Discussions](https://github.com/JamesKayten/Averys-AI-Collaboration-Hack/discussions) - Ask the community
- [GitHub Issues](https://github.com/JamesKayten/Averys-AI-Collaboration-Hack/issues) - Report bugs
- [Documentation](https://github.com/JamesKayten/Averys-AI-Collaboration-Hack/wiki) - Full guides and examples