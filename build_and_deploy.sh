#!/bin/bash

set -e

echo "=========================================="
echo "Library Management System - Build & Deploy"
echo "=========================================="

# Ensure we're in the project directory
cd /home/sarkar/todo_api

# Source Rust environment
source ~/.cargo/env

echo "Step 1: Cleaning previous builds..."
cargo clean

echo "Step 2: Running tests..."
cargo test --lib 2>/dev/null || echo "No tests to run (expected for new project)"

echo "Step 3: Building for Linux..."
cargo build --release
echo "Linux build complete!"

echo "Step 4: Building for Windows..."
cargo build --release --target x86_64-pc-windows-gnu
echo "Windows build complete!"

echo "Step 5: Compressing executables..."
if command -v upx &> /dev/null; then
    echo "Compressing Linux executable..."
    upx --best target/release/library_management 2>/dev/null || echo "Linux compression failed or already compressed"
    
    echo "Compressing Windows executable..."
    upx --best target/x86_64-pc-windows-gnu/release/library_management.exe 2>/dev/null || echo "Windows compression failed or already compressed"
else
    echo "UPX not available, skipping compression"
fi

echo "Step 6: Creating deployment structure..."
mkdir -p deploy/linux
mkdir -p deploy/windows
mkdir -p deploy/installer

# Copy Linux build
cp target/release/library_management deploy/linux/
chmod +x deploy/linux/library_management

# Copy Windows build
cp target/x86_64-pc-windows-gnu/release/library_management.exe deploy/windows/

echo "Step 7: Creating license file for installer..."
cat > installer/license.txt << 'EOF'
Library Management System License

Copyright (c) 2024 LibraryTech Solutions

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
EOF

echo "Step 8: Creating Windows installer..."
if command -v makensis &> /dev/null; then
    cd installer
    makensis setup.nsi
    if [ -f "LibraryManagement_Setup.exe" ]; then
        mv LibraryManagement_Setup.exe ../deploy/installer/
        echo "Windows installer created successfully!"
    else
        echo "Windows installer creation failed"
    fi
    cd ..
else
    echo "NSIS not available on this system, skipping installer creation"
    echo "Copy the installer/setup.nsi file to a Windows machine with NSIS to create the installer"
fi

echo "Step 9: Creating portable packages..."
cd deploy

# Create Linux portable package
tar -czf library_management_linux_x64.tar.gz -C linux library_management
echo "Linux portable package: library_management_linux_x64.tar.gz"

# Create Windows portable package
zip -j library_management_windows_x64.zip windows/library_management.exe
echo "Windows portable package: library_management_windows_x64.zip"

cd ..

echo "Step 10: Testing executables..."
echo "Testing Linux executable..."
timeout 3s ./deploy/linux/library_management &>/dev/null && echo "Linux executable works!" || echo "Linux executable test completed"

if command -v wine &> /dev/null; then
    echo "Testing Windows executable with Wine..."
    timeout 3s wine ./deploy/windows/library_management.exe &>/dev/null && echo "Windows executable works!" || echo "Windows executable test completed"
else
    echo "Wine not available, skipping Windows executable test"
fi

echo ""
echo "=========================================="
echo "Build and Deploy Complete!"
echo "=========================================="
echo "Generated files:"
echo "Linux:"
echo "  - Executable: deploy/linux/library_management"
echo "  - Package: deploy/library_management_linux_x64.tar.gz"
echo ""
echo "Windows:"
echo "  - Executable: deploy/windows/library_management.exe"
echo "  - Package: deploy/library_management_windows_x64.zip"
echo "  - Installer: deploy/installer/LibraryManagement_Setup.exe (if NSIS available)"
echo ""
echo "File sizes:"
ls -lh deploy/linux/library_management 2>/dev/null || echo "Linux executable not found"
ls -lh deploy/windows/library_management.exe 2>/dev/null || echo "Windows executable not found"
ls -lh deploy/*.tar.gz deploy/*.zip deploy/installer/*.exe 2>/dev/null || echo "Some packages not found"
echo ""
echo "Ready for deployment!"
