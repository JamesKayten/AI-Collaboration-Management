import json

class ContextManager:
    def __init__(self):
        self.summary = "# Project Context (auto-updated)\n"

    def update(self, diff: str, feedback: str = "") -> str:
        new_part = f"Diff: {diff[-1800:]}\nFeedback: {feedback.strip()}"
        self.summary = (self.summary + "\n---\n" + new_part + "\n")[-4000:]
        return self.summary

    def get_context(self) -> str:
        return self.summary

    def parse_feedback(self, raw: str) -> dict:
        try:
            start = raw.find("{")
            end = raw.rfind("}") + 1
            return json.loads(raw[start:end]) if start != -1 else {"issues": [raw], "action": "revise"}
        except:
            return {"issues": [raw], "action": "revise"}
          
