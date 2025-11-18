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