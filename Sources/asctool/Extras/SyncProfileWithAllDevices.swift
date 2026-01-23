//
//  SyncProfileWithAllDevices.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2026/01/24.
//

import AppStoreConnectTool
import ArgumentParser
import Foundation

extension ASCTool.Extra {
    struct SyncProfileWithAllDevices: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            usage: """
                asctool extra sync-profile-with-all-devices --name <name> [--include-mac-devices] [--output-directory-path <output-directory-path>] [--pretty-printed] --issuer-id <issuer-id> --private-key-id <private-key-id> --private-key <private-key> [--expiration-duration <expiration-duration>]
                asctool extra sync-profile-with-all-devices --name <name> [--include-mac-devices] [--output-directory-path <output-directory-path>] [--pretty-printed] --individual-private-key-id <individual-private-key-id> --individual-private-key <individual-private-key> [--expiration-duration <expiration-duration>]
                """
        )

        @Option(help: "The name of the provisioning profile to sync with all devices.")
        var name: String

        @Flag
        var includeMacDevices: Bool = false

        @Option(transform: URL.init(fileURLWithPath:))
        var outputDirectoryPath: URL?

        @Flag
        var prettyPrinted: Bool = false

        @OptionGroup
        var arguments: ASCTool.Arguments

        private var payload: AppStoreConnectTool.Payload?

        mutating func validate() throws {
            payload = try AppStoreConnectTool.Payload(from: arguments)
            try outputDirectoryPath.map(FileManager.default.validateDirectoryWritable(at:))
        }

        mutating func run() async throws {
            guard let payload else {
                throw CleanExit.helpRequest(self)
            }
            let syncProfileWithAllDevices = AppStoreConnectTool.Extra.SyncProfileWithAllDevices()
            let response = try await syncProfileWithAllDevices.run(
                name: name,
                includeMacDevices: includeMacDevices,
                payload: payload
            )
            try printWithJSONEncoder(response, prettyPrinted: prettyPrinted)
            if let outputDirectoryPath {
                guard let content = response.data.attributes?.profileContent else { throw CocoaError(.formatting) }
                let name = response.data.attributes?.name ?? "modified"
                let fileName = "\(name).mobileprovision"
                try content.writeAsBase64EncodedData(to: outputDirectoryPath, as: fileName)
            }
        }
    }
}
