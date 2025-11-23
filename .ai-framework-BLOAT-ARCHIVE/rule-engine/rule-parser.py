#!/usr/bin/env python3
"""
Natural Language Rule Parser
Converts user statements into structured framework rules
"""

import re
import json
from datetime import datetime
from typing import Dict, List, Optional, Tuple

class RuleParser:
    """Parse natural language statements into structured rules"""

    # Rule pattern definitions
    RULE_PATTERNS = {
        "file_limits": {
            "patterns": [
                r"(.*?)\s+files?\s+should be limited to\s+(\d+)\s+lines",
                r"maximum\s+(\d+)\s+lines?\s+for\s+(.*?)\s+files?",
                r"file size limit\s+of\s+(\d+)\s+lines?\s+for\s+(.*?)",
                r"limit\s+(.*?)\s+files?\s+to\s+(\d+)\s+lines?"
            ],
            "parameter_extractor": "extract_file_limit_params"
        },
        "workflow_requirements": {
            "patterns": [
                r"requires?\s+(.*?)\s+before\s+(.*?)$",
                r"must\s+(.*?)\s+before\s+(.*?)$",
                r"always\s+(.*?)$",
                r"(.*?)\s+required\s+for\s+(.*?)$"
            ],
            "parameter_extractor": "extract_workflow_params"
        },
        "notification_preferences": {
            "patterns": [
                r"updates?\s+every\s+(\d+)\s+(minutes?|hours?|seconds?)",
                r"notify\s+when\s+(.*?)$",
                r"progress reports?\s+(.*?)$"
            ],
            "parameter_extractor": "extract_notification_params"
        },
        "collaboration_roles": {
            "patterns": [
                r"(TCC|OCC)\s+should\s+(.*?)$",
                r"framework should\s+(.*?)$"
            ],
            "parameter_extractor": "extract_role_params"
        }
    }

    # File type mappings
    FILE_TYPE_ALIASES = {
        "python": "py",
        "javascript": "js",
        "typescript": "ts",
        "shell": "sh",
        "bash": "sh",
        "markdown": "md"
    }

    def __init__(self):
        self.parsed_rules = []

    def parse_natural_language(self, user_statement: str) -> Optional[Dict]:
        """
        Parse a natural language statement into a structured rule

        Args:
            user_statement: The user's rule statement

        Returns:
            Parsed rule dictionary or None if parsing fails
        """
        user_statement = user_statement.strip()

        # Try to match against each category
        for category, config in self.RULE_PATTERNS.items():
            for pattern in config["patterns"]:
                match = re.search(pattern, user_statement, re.IGNORECASE)
                if match:
                    # Extract parameters using the appropriate method
                    extractor_method = getattr(self, config["parameter_extractor"])
                    parameters = extractor_method(user_statement, match)

                    if parameters:
                        return self.create_rule(category, user_statement, parameters)

        return None

    def extract_file_limit_params(self, statement: str, match) -> Dict:
        """Extract parameters for file limit rules"""
        groups = match.groups()

        # Determine file type and limit
        file_type = None
        limit = None

        for group in groups:
            if group and group.isdigit():
                limit = int(group)
            elif group:
                # Try to extract file type
                file_type_match = re.search(r'\b(python|javascript|typescript|shell|bash|py|js|ts|sh|md)\b',
                                           group.lower())
                if file_type_match:
                    file_type_raw = file_type_match.group(1)
                    file_type = self.FILE_TYPE_ALIASES.get(file_type_raw, file_type_raw)

        if not limit:
            return {}

        params = {
            "line_limit": limit,
            "scope": "all_repositories"
        }

        if file_type:
            params["file_type"] = file_type

        return params

    def extract_workflow_params(self, statement: str, match) -> Dict:
        """Extract parameters for workflow requirement rules"""
        groups = match.groups()

        params = {
            "scope": "all_operations"
        }

        if len(groups) >= 2:
            params["required_action"] = groups[0].strip()
            params["trigger_condition"] = groups[1].strip()
        elif len(groups) == 1:
            params["required_action"] = groups[0].strip()

        return params

    def extract_notification_params(self, statement: str, match) -> Dict:
        """Extract parameters for notification preference rules"""
        groups = match.groups()

        params = {}

        if len(groups) >= 2 and groups[0].isdigit():
            # Time-based update
            frequency = int(groups[0])
            unit = groups[1].lower()

            # Convert to seconds
            if "minute" in unit:
                params["frequency_seconds"] = frequency * 60
            elif "hour" in unit:
                params["frequency_seconds"] = frequency * 3600
            else:
                params["frequency_seconds"] = frequency

            params["frequency"] = f"{frequency} {unit}"
        elif len(groups) >= 1:
            params["conditions"] = groups[0].strip()

        return params

    def extract_role_params(self, statement: str, match) -> Dict:
        """Extract parameters for collaboration role rules"""
        groups = match.groups()

        params = {}

        if len(groups) >= 2:
            params["role"] = groups[0].strip()
            params["responsibility"] = groups[1].strip()
        elif len(groups) == 1:
            params["responsibility"] = groups[0].strip()
            params["role"] = "framework"

        return params

    def create_rule(self, category: str, description: str, parameters: Dict) -> Dict:
        """Create a structured rule object"""
        rule_id = f"UR-{datetime.now().strftime('%Y%m%d%H%M%S')}"

        rule = {
            "rule_id": rule_id,
            "category": category,
            "description": description,
            "created_date": datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"),
            "created_by": "user",
            "status": "pending",
            "parameters": parameters,
            "conflicts": [],
            "priority": "medium"
        }

        return rule

    def validate_rule(self, rule: Dict, existing_rules: List[Dict] = None) -> Tuple[bool, List[str]]:
        """
        Validate a rule and check for conflicts

        Args:
            rule: The rule to validate
            existing_rules: List of existing rules to check against

        Returns:
            Tuple of (is_valid, list_of_issues)
        """
        issues = []

        # Check required fields
        required_fields = ["rule_id", "category", "description", "parameters"]
        for field in required_fields:
            if field not in rule:
                issues.append(f"Missing required field: {field}")

        # Check for conflicts with existing rules
        if existing_rules:
            conflicts = self.detect_conflicts(rule, existing_rules)
            if conflicts:
                issues.extend([f"Conflict with rule {c}" for c in conflicts])

        return len(issues) == 0, issues

    def detect_conflicts(self, new_rule: Dict, existing_rules: List[Dict]) -> List[str]:
        """Detect conflicts between new rule and existing rules"""
        conflicts = []

        # Check for overlapping file limits
        if new_rule["category"] == "file_limits":
            new_file_type = new_rule["parameters"].get("file_type")

            for existing in existing_rules:
                if existing["category"] == "file_limits":
                    existing_file_type = existing["parameters"].get("file_type")

                    # Check if they apply to the same file type
                    if new_file_type == existing_file_type or (
                        new_file_type is None or existing_file_type is None
                    ):
                        conflicts.append(existing["rule_id"])

        return conflicts


def main():
    """Example usage"""
    parser = RuleParser()

    # Test statements
    test_statements = [
        "All Python files should be limited to 200 lines instead of 250",
        "Add a rule that requires code review for any file over 100 lines",
        "Framework should automatically run tests before any merge",
        "OCC should always provide progress updates every 10 minutes",
        "TCC analysis documents should include cost estimates"
    ]

    print("Natural Language Rule Parser - Test Mode\n")

    for statement in test_statements:
        print(f"Input: {statement}")
        rule = parser.parse_natural_language(statement)

        if rule:
            print(f"✅ Parsed successfully:")
            print(json.dumps(rule, indent=2))
        else:
            print(f"❌ Failed to parse")

        print()


if __name__ == "__main__":
    main()
