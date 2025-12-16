# Runtime container for asctool
# The binary is pre-built on macOS using x86_64-swift-linux-musl cross-compilation
# This Containerfile only sets up the runtime environment

FROM alpine:latest

# Install runtime dependencies
RUN apk add --no-cache \
    libssl3 \
    ca-certificates \
    tzdata

# Set up the application directory
WORKDIR /app

# Copy the pre-built binary from the build context (expected to be named `asctool`)
# The build script places the pre-built binary into the build context before invoking `container build`.
COPY asctool /app/asctool

# Make the binary executable
RUN chmod +x /app/asctool

# Default command
ENTRYPOINT ["/app/asctool"]
CMD ["--help"]
