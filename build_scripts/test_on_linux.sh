#!/bin/bash

echo "Testing Library Management System on Linux..."

# Build for Linux
cargo build

# Run tests
echo "Running tests..."
cargo test

# Run the application
echo "Starting application for testing..."
echo "Press Ctrl+C to stop"
cargo run
