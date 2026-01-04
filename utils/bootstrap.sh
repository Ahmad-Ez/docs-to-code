#!/bin/bash

# Usage: ./bootstrap.sh "Project Name"

PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: bootstrap.sh <project_name>"
  exit 1
fi

mkdir -p "$PROJECT_NAME/.archy"
cp ../templates/project_brief.md "$PROJECT_NAME/"
cp ../templates/skeleton_state.json "$PROJECT_NAME/.archy/state.json"

echo "Project '$PROJECT_NAME' initialized."
echo "1. Edit '$PROJECT_NAME/project_brief.md'"
echo "2. Start Gemini CLI and feed it PROTOCOL.md + project_brief.md"