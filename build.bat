@echo off
echo Building high-performance application...

REM Build in release mode with optimizations
cargo build --release

REM Strip debug symbols and compress
upx --best target\release\high_performance_app.exe

REM Create installer
makensis installer\setup.nsi

echo Build complete! Installer created as HighPerformanceApp_Setup.exe
