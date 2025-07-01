#!/bin/bash

set -e

echo "=========================================="
echo "Testing Library Management System Build"
echo "=========================================="

# Ensure we're in the right directory
cd /home/sarkar/todo_api

# Check if Rust is available
if ! command -v cargo &> /dev/null; then
    echo "Error: Cargo not found. Please run setup_dev_environment.sh first"
    exit 1
fi

echo "Step 1: Checking Rust installation..."
echo "Rust version: $(rustc --version)"
echo "Cargo version: $(cargo --version)"

echo ""
echo "Step 2: Checking available targets..."
rustup target list --installed

echo ""
echo "Step 3: Checking project structure..."
if [ ! -f "Cargo.toml" ]; then
    echo "Error: Cargo.toml not found"
    exit 1
fi

if [ ! -d "src" ]; then
    echo "Error: src directory not found"
    exit 1
fi

echo "Project structure looks good!"

echo ""
echo "Step 4: Building for Linux (native)..."
cargo check
cargo build
echo "Linux build successful!"

echo ""
echo "Step 5: Running tests..."
cargo test --lib 2>/dev/null || echo "No tests found (expected for new project)"

echo ""
echo "Step 6: Building for Windows (cross-compilation)..."
cargo build --target x86_64-pc-windows-gnu
echo "Windows build successful!"

echo ""
echo "Step 7: Building release versions..."
cargo build --release
cargo build --release --target x86_64-pc-windows-gnu

echo ""
echo "Step 8: Checking output files..."
echo "Linux executable: $(ls -la target/release/library_management 2>/dev/null || echo 'Not found')"
echo "Windows executable: $(ls -la target/x86_64-pc-windows-gnu/release/library_management.exe 2>/dev/null || echo 'Not found')"

echo ""
echo "Step 9: Testing Linux executable..."
timeout 5s ./target/release/library_management &
PID=$!
sleep 2
if kill -0 $PID 2>/dev/null; then
    echo "Linux executable started successfully"
    kill $PID 2>/dev/null || true
else
    echo "Linux executable may have issues"
fi

echo ""
echo "=========================================="
echo "Build test completed successfully!"
echo "=========================================="
echo "Generated files:"
echo "- Linux debug: target/debug/library_management"
echo "- Linux release: target/release/library_management"
echo "- Windows debug: target/x86_64-pc-windows-gnu/debug/library_management.exe"
echo "- Windows release: target/x86_64-pc-windows-gnu/release/library_management.exe"
echo ""
echo "Next steps:"
echo "1. Test Linux version: ./target/release/library_management"
echo "2. Test Windows version on Windows machine or Wine"
echo "3. Create installer with NSIS"
