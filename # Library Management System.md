# Library Management System

A complete, professional-grade library management system with cross-platform support and professional installation packages.

## Features

### Core Features
- **Book Management**: Add, view, search, update, and delete books
- **User Management**: Multi-role user system (Admin, Librarian, Member)
- **Borrowing System**: Book borrowing and returning with due date tracking
- **Fine Calculations**: Automatic fine calculation for overdue books
- **Search System**: Advanced search by title, author, ISBN, or year
- **Reports**: Comprehensive reporting system

### Cross-Platform Support
- **Windows**: Native .exe executable with NSIS installer
- **Linux**: DEB and RPM packages
- **macOS**: Application bundle

## Installation

### Windows (.exe Installation)

#### Method 1: Using Pre-built Installer
1. Download `LibraryManagement-1.0.0-Setup.exe`
2. Run as administrator
3. Follow installation wizard
4. Launch from Start Menu or Desktop shortcut

#### Method 2: Build from Source
```cmd
# Prerequisites: Install CMake, MinGW-w64 or Visual Studio

# Clone repository
git clone <repository-url>
cd library_management

# Run build script
build.bat

# Install the generated .exe
build\LibraryManagement-1.0.0-win64.exe
```

### Linux (Package Installation)
```bash
# Ubuntu/Debian
sudo dpkg -i LibraryManagement-1.0.0-Linux.deb
sudo apt-get install -f  # Fix dependencies if needed

# CentOS/RHEL/Fedora
sudo rpm -i LibraryManagement-1.0.0-Linux.rpm

# Or build from source
mkdir build && cd build
cmake ..
make
sudo make install
```

### Manual Build (All Platforms)
```bash
# Using CMake (Recommended)
mkdir build && cd build
cmake ..
cmake --build . --config Release
cpack  # Create installer package

# Using Make (Linux/macOS)
make
sudo make install

# Using GCC directly
gcc -Wall -Wextra -std=c99 -O2 *.c -o library_mgmt -lm
```

## Quick Start

### First Run
1. Launch the application:
   - **Windows**: Double-click desktop icon or run from Start Menu
   - **Linux**: Run `library_mgmt` from terminal or applications menu
   - **Command Line**: `library_mgmt` (if added to PATH)

2. Default admin login:
   - Username: `admin`
   - Password: `admin123`
   - **Important**: Change password immediately!

### File Locations

#### Windows
- **Executable**: `C:\Program Files\Library Management System\library_mgmt.exe`
- **Data Files**: `%APPDATA%\Library Management System\`
- **Configuration**: `%APPDATA%\Library Management System\library.conf`

#### Linux
- **Executable**: `/usr/local/bin/library_mgmt`
- **Data Files**: `/var/lib/library_mgmt/`
- **Configuration**: `/etc/library_mgmt/library.conf`

#### Portable Mode
- Place executable in any folder
- Data files will be created in the same directory
- Perfect for USB drives or shared folders

## Building Executable Packages

### Windows Executable and Installer
```cmd
# Install dependencies
# - CMake: https://cmake.org/download/
# - MinGW-w64: https://mingw-w64.org/
# - NSIS (for installer): https://nsis.sourceforge.io/

# Build
build.bat

# Output files:
# - build\Release\library_mgmt.exe (standalone executable)
# - build\LibraryManagement-1.0.0-win64.exe (installer)
```

### Linux Packages
```bash
# Install dependencies
sudo apt-get install cmake build-essential

# Build DEB package
mkdir build && cd build
cmake ..
make
cpack -G DEB

# Build RPM package
cpack -G RPM

# Build AppImage (portable)
cpack -G External
```

### Distribution Package
```bash
# Create complete distribution
make dist

# Output: library_mgmt-1.0.0.tar.gz
# Contains source code, documentation, and build scripts
```

## Advanced Usage

### Command Line Arguments
```bash
# Run with specific data directory
library_mgmt --data-dir /path/to/data

# Run in server mode (multi-user)
library_mgmt --server --port 8080

# Run with specific config file
library_mgmt --config /path/to/config.conf

# Show version information
library_mgmt --version

# Show help
library_mgmt --help
```

### Configuration Options
Edit configuration file for advanced settings:

```ini
[Library]
name=City Public Library
admin_email=admin@library.com
max_borrow_days=14
fine_per_day=0.50
max_books_per_user=5

[Database]
path=./data/
backup_enabled=true
backup_interval=24
auto_backup=true

[Interface]
theme=default
language=en
date_format=%Y-%m-%d
currency_symbol=$

[Security]
password_min_length=6
session_timeout=30
max_login_attempts=3
```

## Deployment

### Enterprise Deployment
```bash
# Silent installation (Windows)
LibraryManagement-Setup.exe /S /D=C:\LibraryMgmt

# Network installation (Linux)
sudo apt-get install library-management-server
systemctl enable library-management
systemctl start library-management
```

### Multi-User Setup
1. Install on server machine
2. Configure network access in `library.conf`
3. Install client on user machines
4. Connect to server using IP address

## Development

### Project Structure
```
library_management/
├── src/                    # Source code
├── build/                  # Build output
├── packaging/             # Installer scripts
├── resources/             # Icons, assets
├── configs/               # Configuration files
├── docs/                  # Documentation
├── tests/                 # Test files
├── CMakeLists.txt         # CMake build file
├── Makefile               # Make build file
├── build.bat              # Windows build script
└── README.md              # This file
```

### Creating Custom Builds
```bash
# Debug build
cmake -DCMAKE_BUILD_TYPE=Debug ..

# Release with debug info
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..

# Static linking
cmake -DSTATIC_BUILD=ON ..

# Custom install prefix
cmake -DCMAKE_INSTALL_PREFIX=/opt/library-mgmt ..
```

## Troubleshooting

### Windows Issues
- **MSVCR140.dll missing**: Install Visual C++ Redistributable
- **Permission denied**: Run as administrator
- **Antivirus blocking**: Add to exceptions list

### Linux Issues
- **Command not found**: Check PATH or use full path
- **Permission denied**: Check file permissions with `ls -la`
- **Missing libraries**: Install development packages

### Common Solutions
```bash
# Reset to defaults
library_mgmt --reset-config

# Repair database
library_mgmt --repair-db

# Export/Import data
library_mgmt --export data_backup.json
library_mgmt --import data_backup.json
```

## Support and Distribution

### Creating Your Own Distribution
1. Fork the repository
2. Customize branding in `resources/`
3. Update configuration defaults
4. Build packages using provided scripts
5. Distribute via your preferred method

### Commercial Use
- This software is MIT licensed
- Free for commercial use
- Attribution required
- No warranty provided

For technical support, documentation, and updates, visit the project repository.
