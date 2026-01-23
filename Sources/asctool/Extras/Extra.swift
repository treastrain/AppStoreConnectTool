//
//  Extra.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2026/01/24.
//

import AppStoreConnectTool
import ArgumentParser
import Foundation

extension ASCTool {
    struct Extra: ParsableCommand {
        static let configuration = CommandConfiguration(
            usage: """
                asctool extra <subcommand> --issuer-id <issuer-id> --private-key-id <private-key-id> --private-key <private-key> [--expiration-duration <expiration-duration>]
                asctool extra <subcommand> --individual-private-key-id <individual-private-key-id> --individual-private-key <individual-private-key> [--expiration-duration <expiration-duration>]
                """,
            subcommands: [
                SyncProfileWithAllDevices.self
            ]
        )
    }
}
