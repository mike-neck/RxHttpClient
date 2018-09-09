#!/usr/bin/env bash

echo "running tests"
swift test > test-report.txt 2>&1

echo

echo "show results"
cat test-report.txt
