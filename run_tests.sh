#!/bin/bash

echo "Starting complete Library Management System test..."

# Make scripts executable
chmod +x setup_dev_environment.sh
chmod +x test_build.sh

# Run setup if needed
if ! command -v cargo &> /dev/null; then
    echo "Setting up development environment..."
    ./setup_dev_environment.sh
    source ~/.cargo/env
fi

# Create missing directories
mkdir -p build_scripts
mkdir -p installer
mkdir -p src

# Run the build test
echo "Running build tests..."
./test_build.sh

echo ""
echo "=========================================="
echo "All tests completed!"
echo "=========================================="
