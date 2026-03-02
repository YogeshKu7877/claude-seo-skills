#!/usr/bin/env python3
"""
validate-yaml.py — Validate YAML frontmatter in SKILL.md files.

Usage:
    python3 validate-yaml.py [file1.md] [file2.md] ...
    python3 validate-yaml.py  # finds all SKILL.md under ./skills/

Exits 0 if all files pass, 1 if any fail.
"""

import sys
import os
import glob

try:
    import yaml
except ImportError:
    print("ERROR: PyYAML not installed. Run: pip install PyYAML>=6.0", file=sys.stderr)
    sys.exit(1)


def extract_frontmatter(filepath: str) -> tuple[str | None, str]:
    """Extract YAML frontmatter from a markdown file between --- delimiters.
    Returns (yaml_content, error_message). yaml_content is None on error."""
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            content = f.read()
    except OSError as e:
        return None, f"Cannot read file: {e}"

    lines = content.splitlines()
    if not lines or lines[0].strip() != "---":
        return None, "File does not start with '---' frontmatter delimiter"

    end_idx = None
    for i, line in enumerate(lines[1:], start=1):
        if line.strip() == "---":
            end_idx = i
            break

    if end_idx is None:
        return None, "Frontmatter closing '---' delimiter not found"

    yaml_content = "\n".join(lines[1:end_idx])
    return yaml_content, ""


def validate_skill_md(filepath: str) -> list[str]:
    """Validate a SKILL.md file. Returns list of error messages (empty = pass)."""
    errors = []

    yaml_content, err = extract_frontmatter(filepath)
    if yaml_content is None:
        return [f"Frontmatter parse error: {err}"]

    try:
        data = yaml.safe_load(yaml_content)
    except yaml.YAMLError as e:
        return [f"YAML parse error: {e}"]

    if not isinstance(data, dict):
        return ["Frontmatter must be a YAML mapping (key: value pairs)"]

    # Validate required field: name
    if "name" not in data:
        errors.append("Missing required field: 'name'")
    elif not isinstance(data["name"], str):
        errors.append("Field 'name' must be a string")
    elif not data["name"].strip():
        errors.append("Field 'name' must not be empty")
    else:
        # Validate name matches directory name
        dir_name = os.path.basename(os.path.dirname(os.path.abspath(filepath)))
        skill_name = data["name"].strip()
        if skill_name != dir_name:
            errors.append(
                f"Field 'name' value '{skill_name}' does not match directory name '{dir_name}'"
            )

    # Validate required field: description
    if "description" not in data:
        errors.append("Missing required field: 'description'")
    elif not isinstance(data["description"], str):
        errors.append("Field 'description' must be a string")
    elif not data["description"].strip():
        errors.append("Field 'description' must not be empty")
    elif len(data["description"].strip()) > 1000:
        errors.append(
            f"Field 'description' exceeds 1000 characters "
            f"(got {len(data['description'].strip())})"
        )

    # Validate optional field: allowed-tools
    if "allowed-tools" in data:
        allowed = data["allowed-tools"]
        if allowed is not None:
            if not isinstance(allowed, list):
                errors.append("Field 'allowed-tools' must be a list of strings")
            else:
                for i, tool in enumerate(allowed):
                    if not isinstance(tool, str):
                        errors.append(
                            f"Field 'allowed-tools[{i}]' must be a string, got {type(tool).__name__}"
                        )

    return errors


def find_skill_mds(root: str) -> list[str]:
    """Find all SKILL.md files under root directory."""
    pattern = os.path.join(root, "**", "SKILL.md")
    return sorted(glob.glob(pattern, recursive=True))


def main() -> int:
    args = sys.argv[1:]

    if args:
        filepaths = args
    else:
        # Default: find all SKILL.md under ./skills/
        default_root = os.path.join(os.getcwd(), "skills")
        if not os.path.isdir(default_root):
            # Fallback to current directory
            default_root = os.getcwd()
        filepaths = find_skill_mds(default_root)
        if not filepaths:
            print(f"No SKILL.md files found under: {default_root}", file=sys.stderr)
            return 1

    total = len(filepaths)
    passed = 0
    failed = 0

    for filepath in filepaths:
        errors = validate_skill_md(filepath)
        if errors:
            print(f"FAIL  {filepath}")
            for err in errors:
                print(f"      - {err}")
            failed += 1
        else:
            print(f"PASS  {filepath}")
            passed += 1

    print(f"\nResults: {passed}/{total} passed, {failed} failed")

    return 0 if failed == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
