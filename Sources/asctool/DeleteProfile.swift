//
//  DeleteProfile.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2026/01/23.
//

import AppStoreConnectTool
import ArgumentParser
import Foundation

extension ASCTool {
    struct DeleteProfile: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            usage: """
                asctool delete-profile --id <id> --issuer-id <issuer-id> --private-key-id <private-key-id> --private-key <private-key> [--expiration-duration <expiration-duration>]
                asctool delete-profile --id <id> --individual-private-key-id <individual-private-key-id> --individual-private-key <individual-private-key> [--expiration-duration <expiration-duration>]
                """
        )

        @Option
        var id: String

        @OptionGroup
        var arguments: Arguments

        private var payload: AppStoreConnectTool.Payload?

        mutating func validate() throws {
            payload = try AppStoreConnectTool.Payload(from: arguments)
        }

        mutating func run() async throws {
            guard let payload else {
                throw CleanExit.helpRequest(self)
            }
            let deleteProfile = AppStoreConnectTool.DeleteProfile()
            try await deleteProfile.run(
                id: id,
                payload: payload
            )
        }
    }
}
