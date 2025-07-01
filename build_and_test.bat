@echo off
echo ========================================
echo Building Library Management System
echo ========================================

echo Step 1: Cleaning previous builds...
cargo clean

echo Step 2: Running tests...
cargo test

echo Step 3: Building debug version for testing...
cargo build

echo Step 4: Running the application for testing...
echo Starting Library Management System...
cargo run

echo Step 5: Building release version...
cargo build --release

echo Step 6: Optimizing executable...
upx --best target\release\library_management.exe

echo ========================================
echo Build Complete!
echo ========================================
echo Debug executable: target\debug\library_management.exe
echo Release executable: target\release\library_management.exe
echo.
echo To test the application:
echo 1. Run: cargo run
echo 2. Or execute: target\debug\library_management.exe
echo.
pause
