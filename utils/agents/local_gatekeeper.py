import json
from utils.context_manager import ContextManager

class LocalGatekeeper:
    def __init__(self):
        self.cm = ContextManager()

    def review(self, code: str, filename: str, previous_feedback: str = "") -> str:
        issues = []
        suggestions = []

        # Example checks – replace/expand with your real rules
        if len(code) > 5000:
            issues.append("file_too_large")
            suggestions.append("Split into multiple smaller modules")
        if "global " in code.lower() or "window." in code:
            issues.append("global_state")
            suggestions.append("Use dependency injection or config instead")
        if "console.log" in code and "debug" not in filename:
            issues.append("debug_left_in")
            suggestions.append("Remove console.log statements")

        action = "revise" if issues else "approve"

        feedback = {
            "action": action,
            "issues": issues,
            "suggestions": suggestions,
            "context_update": self.cm.update(code, previous_feedback)
        }

        return json.dumps(feedback, indent=2)

# Quick test
if __name__ == "__main__":
    gate = LocalGatekeeper()
    test_code = "global user = null;\nconsole.log('hello');"
    print(gate.review(test_code, "utils/temp.js"))
