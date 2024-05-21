#!/bin/bash

# Usage:
#   ./test_target_script.sh

# Function to test TABLER script
test_target_script() {
    local input="$1"

    output=$(../TABLER.sh "$input")
    echo "$output"
}

# Run tests
# Each test case provides an input and output.png for that input
test_target_script input1.txt
test_target_script input2.txt
test_target_script input3.txt

