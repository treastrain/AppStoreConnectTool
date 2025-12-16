#!/bin/bash
# Build script — build linux-musl binaries and create container image
# This script cross-compiles for linux-musl on macOS (x86_64 or aarch64) and builds a container image using Containerfile

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_NAME="AppStoreConnectTool"
IMAGE_NAME="${IMAGE_NAME:-asctool}"
IMAGE_TAG="${IMAGE_TAG:-latest}"

# Build message: indicate linux-musl target
echo "🏗️  Building $PROJECT_NAME for linux-musl (x86_64 / aarch64)..."

# Check if swiftly is available and configured for x86_64-swift-linux-musl
if ! command -v swift &> /dev/null; then
    echo "❌ Swift toolchain not found. Please install it with swiftly."
    exit 1
fi

# Select SDK based on host architecture (x86_64 vs aarch64)
cd "$SCRIPT_DIR"
ARCH="$(uname -m)"
if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
    SDK="aarch64-swift-linux-musl"
else
    SDK="x86_64-swift-linux-musl"
fi
echo "🔧 Using SDK: $SDK"

swift build -c release --swift-sdk "$SDK"

BINARY_PATH=".build/release/asctool"

if [ ! -f "$BINARY_PATH" ]; then
    echo "❌ Build failed: Binary not found at $BINARY_PATH"
    exit 1
fi

echo "✅ Binary built successfully at $BINARY_PATH"

# Check which container tool is available
if ! command -v container &> /dev/null; then
    echo "❌ Container tool not found. Please install a container tool (apple/container)."
    exit 1
fi

echo "📦 Using container tool to build image..."

# Build container image using the Containerfile
echo "📦 Building container image: $IMAGE_NAME:$IMAGE_TAG"

# Prepare minimal build context so the pre-built binary is included reliably
CTX_DIR="$SCRIPT_DIR/.container_context"
rm -rf "$CTX_DIR"
mkdir -p "$CTX_DIR"

# Copy Containerfile and binary into context
cp Containerfile "$CTX_DIR/Containerfile"
cp "$BINARY_PATH" "$CTX_DIR/asctool"

# Build from the temporary context
pushd "$CTX_DIR" >/dev/null
container build -t "$IMAGE_NAME:$IMAGE_TAG" -f Containerfile .
popd >/dev/null

# Clean up
rm -rf "$CTX_DIR"

echo "✅ Container image built successfully: $IMAGE_NAME:$IMAGE_TAG"
echo ""
echo "📝 To run the container:"
echo "  container run --rm $IMAGE_NAME:$IMAGE_TAG"
echo ""
echo "📝 To run with custom command:"
echo "  container run --rm $IMAGE_NAME:$IMAGE_TAG <command>"
