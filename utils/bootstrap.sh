#!/bin/bash

# Usage: ./bootstrap.sh "project-name"

PROJECT_NAME=$1

# 1. Resolve Paths
# Get the absolute path of the directory where this script resides (utils/)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Go up one level to get the auto-archy root
ARCHY_ROOT="$(dirname "$SCRIPT_DIR")"
PROTOCOL_PATH="$ARCHY_ROOT/PROTOCOL.md"

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: new-project <project_name>"
  exit 1
fi

# 2. Create Project Structure
TARGET_DIR="$(pwd)/$PROJECT_NAME"

if [ -d "$TARGET_DIR" ]; then
  echo "Error: Directory '$PROJECT_NAME' already exists."
  exit 1
fi

mkdir -p "$TARGET_DIR/.archy"
cp "$ARCHY_ROOT/templates/project_brief.md" "$TARGET_DIR/"
cp "$ARCHY_ROOT/templates/skeleton_state.json" "$TARGET_DIR/.archy/state.json"

# 3. Generate the Prompt for the User
echo "---------------------------------------------------------"
echo "✅ Project '$PROJECT_NAME' initialized at:"
echo "   $TARGET_DIR"
echo ""
echo "👉 STEP 1: Edit the Brief"
echo "   vim $PROJECT_NAME/project_brief.md"
echo ""
echo "👉 STEP 2: Copy & Paste this into Gemini CLI:"
echo "---------------------------------------------------------"
echo "I am starting a new project. Here is the PROTOCOL and the BRIEF."
echo "Please perform Phase 1: Blueprinting."
echo ""
echo "Reference Files:"
echo "1. Protocol: $PROTOCOL_PATH"
echo "2. Brief:    $TARGET_DIR/project_brief.md"
echo "3. State:    $TARGET_DIR/.archy/state.json"
echo "---------------------------------------------------------"