//
//  CreateProfile.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2026/01/23.
//

import AppStoreConnectTool
import ArgumentParser
import Foundation

extension ASCTool {
    struct CreateProfile: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            usage: """
                asctool create-profile --name <name> --profile-type <profile-type> --bundle-id <bundle-id> [--device-ids <device-ids> ...] --certificate-ids <certificate-ids> ... [--output-directory-path <output-directory-path>] [--pretty-printed] --issuer-id <issuer-id> --private-key-id <private-key-id> --private-key <private-key> [--expiration-duration <expiration-duration>]
                asctool create-profile --name <name> --profile-type <profile-type> --bundle-id <bundle-id> [--device-ids <device-ids> ...] --certificate-ids <certificate-ids> ... [--output-directory-path <output-directory-path>] [--pretty-printed] --individual-private-key-id <individual-private-key-id> --individual-private-key <individual-private-key> [--expiration-duration <expiration-duration>]
                """
        )

        @OptionGroup
        var bodyProperties: BodyProperties

        @Option(transform: URL.init(fileURLWithPath:))
        var outputDirectoryPath: URL?

        @Flag
        var prettyPrinted: Bool = false

        @OptionGroup
        var arguments: Arguments

        private var payload: AppStoreConnectTool.Payload?

        mutating func validate() throws {
            payload = try AppStoreConnectTool.Payload(from: arguments)
            try outputDirectoryPath.map(FileManager.default.validateDirectoryWritable(at:))
        }

        mutating func run() async throws {
            guard let payload else {
                throw CleanExit.helpRequest(self)
            }
            let createProfile = AppStoreConnectTool.CreateProfile()
            let response = try await createProfile.run(
                name: bodyProperties.name,
                profileType: bodyProperties.profileType,
                bundleID: bodyProperties.bundleID,
                deviceIDs: bodyProperties.deviceIDs.nilIfEmpty,
                certificateIDs: bodyProperties.certificateIDs,
                payload: payload
            )
            try printWithJSONEncoder(response, prettyPrinted: prettyPrinted)
            if let outputDirectoryPath {
                guard let content = response.data.attributes?.profileContent else { throw CocoaError(.formatting) }
                let name = response.data.attributes?.name ?? "created"
                let fileName = "\(name).mobileprovision"
                try content.writeAsBase64EncodedData(to: outputDirectoryPath, as: fileName)
            }
        }
    }
}

extension ASCTool.CreateProfile {
    struct BodyProperties: ParsableArguments {
        @Option
        var name: String

        @Option
        var profileType: AppStoreConnectTool.CreateProfile.BodyProperties.ProfileType

        @Option
        var bundleID: String

        @Option(name: .customLong("device-ids"))
        var deviceIDs: [String] = []

        @Option(name: .customLong("certificate-ids"))
        var certificateIDs: [String]
    }
}

extension AppStoreConnectTool.CreateProfile.BodyProperties.ProfileType: ExpressibleByArgument {
    private enum Key: String, CaseIterable, ExpressibleByArgument {
        case IOS_APP_DEVELOPMENT, IOS_APP_STORE, IOS_APP_ADHOC, IOS_APP_INHOUSE
        case MAC_APP_DEVELOPMENT, MAC_APP_STORE, MAC_APP_DIRECT
        case TVOS_APP_DEVELOPMENT, TVOS_APP_STORE, TVOS_APP_ADHOC, TVOS_APP_INHOUSE
        case MAC_CATALYST_APP_DEVELOPMENT, MAC_CATALYST_APP_STORE, MAC_CATALYST_APP_DIRECT
    }

    public init?(argument: String) {
        switch Key(argument: argument) {
        case .IOS_APP_DEVELOPMENT: self = .iOSAppDevelopment
        case .IOS_APP_STORE: self = .iOSAppStore
        case .IOS_APP_ADHOC: self = .iOSAppAdhoc
        case .IOS_APP_INHOUSE: self = .iOSAppInhouse
        case .MAC_APP_DEVELOPMENT: self = .macAppDevelopment
        case .MAC_APP_STORE: self = .macAppStore
        case .MAC_APP_DIRECT: self = .macAppDirect
        case .TVOS_APP_DEVELOPMENT: self = .tvOSAppDevelopment
        case .TVOS_APP_STORE: self = .tvOSAppStore
        case .TVOS_APP_ADHOC: self = .tvOSAppAdhoc
        case .TVOS_APP_INHOUSE: self = .tvOSAppInhouse
        case .MAC_CATALYST_APP_DEVELOPMENT: self = .macCatalystAppDevelopment
        case .MAC_CATALYST_APP_STORE: self = .macCatalystAppStore
        case .MAC_CATALYST_APP_DIRECT: self = .macCatalystAppDirect
        case nil: return nil
        }
    }

    public static var allValueStrings: [String] { Key.allValueStrings }
    public static var allValueDescriptions: [String: String] { Key.allValueDescriptions }
    public static var defaultCompletionKind: CompletionKind { Key.defaultCompletionKind }
}
