#!/usr/bin/env python3
"""
Replace stub sections 10.4, 10.5, 10.6, 10.7 with complete specifications
"""

import sys

def main():
    # Read the main document
    with open(r'C:\work\FactFind-Entities\steering\Target-Model\FactFind-API-Design-v2.md', 'r', encoding='utf-8') as f:
        lines = f.readlines()

    # Read the four complete sections
    with open(r'C:\work\FactFind-Entities\steering\Target-Model\section_10_4_complete.md', 'r', encoding='utf-8') as f:
        section_10_4 = f.read()

    with open(r'C:\work\FactFind-Entities\steering\Target-Model\section_10_5_complete.md', 'r', encoding='utf-8') as f:
        section_10_5 = f.read()

    with open(r'C:\work\FactFind-Entities\steering\Target-Model\section_10_6_complete.md', 'r', encoding='utf-8') as f:
        section_10_6 = f.read()

    with open(r'C:\work\FactFind-Entities\steering\Target-Model\section_10_7_complete.md', 'r', encoding='utf-8') as f:
        section_10_7 = f.read()

    # Combine all four sections
    complete_sections = section_10_4 + '\n' + section_10_5 + '\n' + section_10_6 + '\n' + section_10_7 + '\n\n---\n\n'

    # Find the replacement boundaries
    # Section 10.4 starts at line 5211 (0-indexed: 5210)
    # Section 11 starts at line 5272 (0-indexed: 5271)
    # We want to replace lines 5210-5270 (inclusive, 0-indexed)

    start_line = 5210  # Line 5211 in 1-indexed
    end_line = 5270    # Line 5271 in 1-indexed (exclusive, so we keep line 5271)

    # Build new content
    new_lines = lines[:start_line] + [complete_sections] + lines[end_line:]

    # Write the updated document
    with open(r'C:\work\FactFind-Entities\steering\Target-Model\FactFind-API-Design-v2.md', 'w', encoding='utf-8') as f:
        f.writelines(new_lines)

    print(f"Successfully replaced sections 10.4-10.7")
    print(f"Original line count: {len(lines)}")
    print(f"New line count: {len(new_lines)}")
    print(f"Lines added: {len(new_lines) - len(lines)}")
    print(f"\nReplaced lines {start_line+1} to {end_line} with complete specifications")

if __name__ == '__main__':
    main()
