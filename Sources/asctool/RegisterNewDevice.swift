//
//  RegisterNewDevice.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2025/12/18.
//

import AppStoreConnectTool
import ArgumentParser
import Foundation

extension ASCTool {
    struct RegisterNewDevice: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            usage: """
                asctool register-new-device --name <name> --platform <platform> --udid <udid> [--pretty-printed] --issuer-id <issuer-id> --private-key-id <private-key-id> --private-key <private-key> [--expiration-duration <expiration-duration>]
                asctool register-new-device --name <name> --platform <platform> --udid <udid> [--pretty-printed] --individual-private-key-id <individual-private-key-id> --individual-private-key <individual-private-key> [--expiration-duration <expiration-duration>]
                """
        )

        @OptionGroup
        var bodyProperties: BodyProperties

        @Flag
        var prettyPrinted: Bool = false

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
            let registerNewDevice = AppStoreConnectTool.RegisterNewDevice()
            let response = try await registerNewDevice.run(
                name: bodyProperties.name,
                platform: bodyProperties.platform,
                udid: bodyProperties.udid,
                payload: payload
            )
            try printWithJSONEncoder(response, prettyPrinted: prettyPrinted)
        }
    }
}

extension ASCTool.RegisterNewDevice {
    struct BodyProperties: ParsableArguments {
        @Option
        var name: String

        @Option
        var platform: AppStoreConnectTool.RegisterNewDevice.BodyProperties.BundleIDPlatform

        @Option
        var udid: String
    }
}

extension AppStoreConnectTool.RegisterNewDevice.BodyProperties.BundleIDPlatform: ExpressibleByArgument {
    private enum Key: String, CaseIterable, ExpressibleByArgument {
        case IOS, MAC_OS, UNIVERSAL
    }

    public init?(argument: String) {
        switch Key(argument: argument) {
        case .IOS: self = .iOS
        case .MAC_OS: self = .macOS
        case .UNIVERSAL: self = .universal
        case nil: return nil
        }
    }

    public static var allValueStrings: [String] { Key.allValueStrings }
    public static var allValueDescriptions: [String: String] { Key.allValueDescriptions }
    public static var defaultCompletionKind: CompletionKind { Key.defaultCompletionKind }
}
