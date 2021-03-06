#!/bin/bash
#
# Calling commands:
#
#     runner.sh incidents # <= Runs the user command
#
#     COG_OPT_LIMIT=25 runner.sh users # <= Runs the user command, setting a limit of 25 users
#

export COG_ARGC=$(env | grep -c COG_OPT)

export COG_COMMAND=$1

if [ -f ".env" ]; then
  source .env
fi

if [ -z "$COG_COMMAND" ]; then
  echo "No command set"
  exit 1
fi

./cog-command
