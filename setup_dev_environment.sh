#!/bin/bash

set -e  # Exit on any error

echo "=========================================="
echo "Setting up Rust development environment on Kali Linux for Windows deployment..."
echo "=========================================="

# Check if Rust is already installed
if command -v cargo &> /dev/null; then
    echo "Rust is already installed. Version:"
    rustc --version
    cargo --version
else
    # Install Rust using rustup (recommended way)
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    
    # Source the cargo environment
    source ~/.cargo/env
    
    echo "Rust installation complete!"
    rustc --version
    cargo --version
fi

# Add Windows target for cross-compilation
echo "Adding Windows target for cross-compilation..."
rustup target add x86_64-pc-windows-gnu

# Install cross-compilation tools
echo "Installing cross-compilation tools..."
sudo apt update
sudo apt install -y gcc-mingw-w64-x86-64 wine64

# Install additional tools for Windows deployment
echo "Installing additional deployment tools..."
sudo apt install -y upx-ucl nsis

# Create cargo config for cross-compilation
echo "Configuring cross-compilation..."
mkdir -p ~/.cargo
cat > ~/.cargo/config.toml << 'EOF'
[target.x86_64-pc-windows-gnu]
linker = "x86_64-w64-mingw32-gcc"
ar = "x86_64-w64-mingw32-ar"

[build]
target-dir = "target"
EOF

echo "=========================================="
echo "Setup complete!"
echo "=========================================="
echo "Installed tools:"
echo "- Rust toolchain: $(rustc --version)"
echo "- Cargo: $(cargo --version)"
echo "- Windows target: x86_64-pc-windows-gnu"
echo "- Cross-compiler: $(x86_64-w64-mingw32-gcc --version | head -n1)"
echo "- UPX compressor: $(upx --version | head -n1)"
echo ""
echo "Next steps:"
echo "1. Run 'source ~/.cargo/env' or restart your terminal"
echo "2. Use 'cargo build --target x86_64-pc-windows-gnu' to build for Windows"
echo "3. Use './test_build.sh' to test the complete build process"
