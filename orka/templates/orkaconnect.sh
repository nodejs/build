#!/bin/bash
# Check if a VM name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <vm-name>"
    exit 1
fi

# Construct the SSH command
SSH_COMMAND=$(orka3 vm list -o wide | grep "$1" | awk '{split($7, part, "-");printf "ssh admin@%s -o StrictHostKeyChecking=no -p %s -i ~/.ssh/nodejs_build_%s",$2,$3,part[4]}')

# Check if the command was successfully generated
if [ -z "$SSH_COMMAND" ]; then
    echo "No VM found with name matching '$1'"
    exit 1
fi

# Execute the SSH command
echo "Executing: $SSH_COMMAND"
eval "$SSH_COMMAND"