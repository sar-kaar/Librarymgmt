#!/bin/bash

echo "Building Library Management System for Windows..."

# Ensure we have the Windows target
rustup target add x86_64-pc-windows-gnu

# Build for Windows
echo "Building debug version for Windows..."
cargo build --target x86_64-pc-windows-gnu

echo "Building release version for Windows..."
cargo build --release --target x86_64-pc-windows-gnu

# Check if UPX is available for compression
if command -v upx &> /dev/null; then
    echo "Compressing Windows executable..."
    upx --best target/x86_64-pc-windows-gnu/release/library_management.exe
else
    echo "UPX not found, skipping compression"
fi

echo "Windows build complete!"
echo "Debug: target/x86_64-pc-windows-gnu/debug/library_management.exe"
echo "Release: target/x86_64-pc-windows-gnu/release/library_management.exe"
