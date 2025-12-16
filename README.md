# AppStoreConnectTool (`asctool`)
A CLI tool for managing the App Store Connect API. Works on macOS and Linux.

## Building for Linux (musl) from macOS
1. Set up `swiftly` following the official documentation
   https://www.swift.org/swiftly/documentation/swiftly/getting-started/
2. Install the toolchain
    ```bash
    swiftly install 6.2.3
    ```
3. Configure to use the installed toolchain
    ```bash
    swiftly use 6.2.3
    ```
    > [!TIP]
    > To revert to the Xcode-built toolchain, run `swiftly use xcode`.
3. Install the Static Linux SDK
    ```bash
    swift sdk install https://download.swift.org/swift-6.2.3-release/static-sdk/swift-6.2.3-RELEASE/swift-6.2.3-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz --checksum f30ec724d824ef43b5546e02ca06a8682dafab4b26a99fbb0e858c347e507a2c
    ```
4. Build for Linux (musl)
   - For x86_64
        ```bash
        swift build --swift-sdk x86_64-swift-linux-musl

        # Release build
        swift build -c release --swift-sdk x86_64-swift-linux-musl
        ```
   - For aarch64
        ```bash
        swift build --swift-sdk aarch64-swift-linux-musl

        # Release build
        swift build -c release --swift-sdk aarch64-swift-linux-musl
        ```

## Running in apple/container (or Docker, etc.)
Build and run the container using the provided script:

```bash
# Build the container
./build-container.sh

# Run the container
container run --rm asctool:latest
```
