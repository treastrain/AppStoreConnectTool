//
//  Validate.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2025/12/16.
//

import AppStoreConnectTool
import ArgumentParser
import Foundation

extension ASCTool {
    struct Validate: ParsableCommand {
        static let configuration = CommandConfiguration(
            usage: """
                asctool validate --issuer-id <issuer-id> --private-key-id <private-key-id> --private-key <private-key> [--expiration-duration <expiration-duration>]
                asctool validate --individual-private-key-id <individual-private-key-id> --individual-private-key <individual-private-key> [--expiration-duration <expiration-duration>]
                """
        )

        @OptionGroup
        var arguments: Arguments

        private var payload: AppStoreConnectTool.Payload?

        mutating func validate() throws {
            payload = try AppStoreConnectTool.Payload(from: arguments)
        }

        mutating func run() throws {
            guard let payload else {
                throw CleanExit.helpRequest(self)
            }
            let validate = AppStoreConnectTool.Validate()
            do {
                try validate.run(payload: payload)
                print("✅ The credential is valid.")
            } catch {
                print("❌ The credential is invalid:", error)
                throw ExitCode.failure
            }
        }
    }
}
