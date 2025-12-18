//
//  ModifyRegisteredDevice.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2025/12/19.
//

import AppStoreConnectTool
import ArgumentParser
import Foundation

extension ASCTool {
    struct ModifyRegisteredDevice: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            usage: """
                asctool modify-registered-device --id <id> [--name <name>] [--status <status>] [--pretty-printed] --issuer-id <issuer-id> --private-key-id <private-key-id> --private-key <private-key> [--expiration-duration <expiration-duration>]
                asctool modify-registered-device --udid <udid> [--name <name>] [--status <status>] [--pretty-printed] --issuer-id <issuer-id> --private-key-id <private-key-id> --private-key <private-key> [--expiration-duration <expiration-duration>]
                asctool modify-registered-device --id <id> [--name <name>] [--status <status>] [--pretty-printed] --individual-private-key-id <individual-private-key-id> --individual-private-key <individual-private-key> [--expiration-duration <expiration-duration>]
                asctool modify-registered-device --udid <udid> [--name <name>] [--status <status>] [--pretty-printed] --individual-private-key-id <individual-private-key-id> --individual-private-key <individual-private-key> [--expiration-duration <expiration-duration>]
                """
        )

        @Option(help: "The opaque resource ID that uniquely identifies the resource. (Either ID or UDID is required.)")
        var id: String?

        @Option(help: "Device Identifier (UDID). (Either ID or UDID is required.)")
        var udid: String?

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
            if id == nil, let udid {
                let listDevices = AppStoreConnectTool.ListDevices()
                let response = try await listDevices.run(
                    filterUDID: [udid],
                    payload: payload
                )
                guard let id = response.data.first?.id else {
                    print("Error:", "There is no resource of type 'devices' with UDID '\(udid)'.")
                    throw ExitCode.failure
                }
                self.id = id
            }
            guard let id else {
                print("Error:", "You must specify either --id or --udid.")
                throw ExitCode.validationFailure
            }
            let modifyRegisteredDevice = AppStoreConnectTool.ModifyRegisteredDevice()
            let response = try await modifyRegisteredDevice.run(
                id: id,
                name: bodyProperties.name,
                status: bodyProperties.status,
                payload: payload
            )
            try printWithJSONEncoder(response, prettyPrinted: prettyPrinted)
        }
    }
}

extension ASCTool.ModifyRegisteredDevice {
    struct BodyProperties: ParsableArguments {
        @Option
        var name: String?

        @Option
        var status: AppStoreConnectTool.ModifyRegisteredDevice.BodyProperties.Status?
    }
}

extension AppStoreConnectTool.ModifyRegisteredDevice.BodyProperties.Status: ExpressibleByArgument {
    private enum Key: String, CaseIterable, ExpressibleByArgument {
        case ENABLED, DISABLED
    }

    public init?(argument: String) {
        switch Key(argument: argument) {
        case .ENABLED: self = .enabled
        case .DISABLED: self = .disabled
        case nil: return nil
        }
    }

    public static var allValueStrings: [String] { Key.allValueStrings }
    public static var allValueDescriptions: [String: String] { Key.allValueDescriptions }
    public static var defaultCompletionKind: CompletionKind { Key.defaultCompletionKind }
}
