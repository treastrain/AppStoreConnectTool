//
//  ListProfiles.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2026/01/24.
//

import AppStoreConnectTool
import ArgumentParser
import Foundation

extension ASCTool {
    struct ListProfiles: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            usage: """
                asctool list-profiles [--fields-certificates <fields-certificates> ...] [--fields-devices <fields-devices> ...] [--fields-profiles <fields-profiles> ...] [--filter-id <filter-id> ...] [--filter-name <filter-name> ...] [--include <include> ...] [--limit <limit>] [--limit-certificates <limit-certificates>] [--limit-devices <limit-devices>] [--sort <sort> ...] [--fields-bundle-ids <fields-bundle-ids> ...] [--filter-profile-state <filter-profile-state> ...] [--filter-profile-type <filter-profile-type> ...] [--pretty-printed] --issuer-id <issuer-id> --private-key-id <private-key-id> --private-key <private-key> [--expiration-duration <expiration-duration>]
                asctool list-profiles [--fields-certificates <fields-certificates> ...] [--fields-devices <fields-devices> ...] [--fields-profiles <fields-profiles> ...] [--filter-id <filter-id> ...] [--filter-name <filter-name> ...] [--include <include> ...] [--limit <limit>] [--limit-certificates <limit-certificates>] [--limit-devices <limit-devices>] [--sort <sort> ...] [--fields-bundle-ids <fields-bundle-ids> ...] [--filter-profile-state <filter-profile-state> ...] [--filter-profile-type <filter-profile-type> ...] [--pretty-printed] --individual-private-key-id <individual-private-key-id> --individual-private-key <individual-private-key> [--expiration-duration <expiration-duration>]
                """
        )

        @OptionGroup
        var queryParameters: QueryParameters

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
            let listProfiles = AppStoreConnectTool.ListProfiles()
            let response = try await listProfiles.run(
                fieldsCertificates: queryParameters.fieldsCertificates.nilIfEmpty,
                fieldsDevices: queryParameters.fieldsDevices.nilIfEmpty,
                fieldsProfiles: queryParameters.fieldsProfiles.nilIfEmpty,
                filterID: queryParameters.filterID.nilIfEmpty,
                filterName: queryParameters.filterName.nilIfEmpty,
                include: queryParameters.include.nilIfEmpty,
                limit: queryParameters.limit,
                limitCertificates: queryParameters.limitCertificates,
                limitDevices: queryParameters.limitDevices,
                sort: queryParameters.sort.nilIfEmpty,
                fieldsBundleIDs: queryParameters.fieldsBundleIDs.nilIfEmpty,
                filterProfileState: queryParameters.filterProfileState.nilIfEmpty,
                filterProfileType: queryParameters.filterProfileType.nilIfEmpty,
                payload: payload
            )
            try printWithJSONEncoder(response, prettyPrinted: prettyPrinted)
        }
    }
}

extension ASCTool.ListProfiles {
    struct QueryParameters: ParsableArguments {
        @Option
        var fieldsCertificates: [AppStoreConnectTool.ListProfiles.QueryParameters.FieldsCertificates] = []

        @Option
        var fieldsDevices: [AppStoreConnectTool.ListProfiles.QueryParameters.FieldsDevices] = []

        @Option
        var fieldsProfiles: [AppStoreConnectTool.ListProfiles.QueryParameters.FieldsProfiles] = []

        @Option
        var filterID: [String] = []

        @Option
        var filterName: [String] = []

        @Option
        var include: [AppStoreConnectTool.ListProfiles.QueryParameters.Include] = []

        @Option(help: "(maximum: 200)")
        var limit: UInt?

        @Option(help: "(maximum: 50)")
        var limitCertificates: UInt?

        @Option(help: "(maximum: 50)")
        var limitDevices: UInt?

        @Option
        var sort: [AppStoreConnectTool.ListProfiles.QueryParameters.Sort] = []

        @Option(name: .customLong("fields-bundle-ids"))
        var fieldsBundleIDs: [AppStoreConnectTool.ListProfiles.QueryParameters.FieldsBundleIDs] = []

        @Option
        var filterProfileState: [AppStoreConnectTool.ListProfiles.QueryParameters.FilterProfileState] = []

        @Option
        var filterProfileType: [AppStoreConnectTool.ListProfiles.QueryParameters.FilterProfileType] = []
    }
}

extension AppStoreConnectTool.ListProfiles.QueryParameters.FieldsCertificates: ExpressibleByArgument {
    private enum Key: String, CaseIterable, ExpressibleByArgument {
        case name
        case certificateType
        case displayName
        case serialNumber
        case platform
        case expirationDate
        case certificateContent
        case activated
        case passTypeID = "passTypeId"
    }

    public init?(argument: String) {
        switch Key(argument: argument) {
        case .name: self = .name
        case .certificateType: self = .certificateType
        case .displayName: self = .displayName
        case .serialNumber: self = .serialNumber
        case .platform: self = .platform
        case .expirationDate: self = .expirationDate
        case .certificateContent: self = .certificateContent
        case .activated: self = .activated
        case .passTypeID: self = .passTypeID
        case nil: return nil
        }
    }

    public static var allValueStrings: [String] { Key.allValueStrings }
    public static var allValueDescriptions: [String: String] { Key.allValueDescriptions }
    public static var defaultCompletionKind: CompletionKind { Key.defaultCompletionKind }
}

extension AppStoreConnectTool.ListProfiles.QueryParameters.FieldsDevices: ExpressibleByArgument {
    private enum Key: String, CaseIterable, ExpressibleByArgument {
        case name
        case platform
        case udid
        case deviceClass
        case status
        case model
        case addedDate
    }

    public init?(argument: String) {
        switch Key(argument: argument) {
        case .name: self = .name
        case .platform: self = .platform
        case .udid: self = .udid
        case .deviceClass: self = .deviceClass
        case .status: self = .status
        case .model: self = .model
        case .addedDate: self = .addedDate
        case nil: return nil
        }
    }

    public static var allValueStrings: [String] { Key.allValueStrings }
    public static var allValueDescriptions: [String: String] { Key.allValueDescriptions }
    public static var defaultCompletionKind: CompletionKind { Key.defaultCompletionKind }
}

extension AppStoreConnectTool.ListProfiles.QueryParameters.FieldsProfiles: ExpressibleByArgument {
    private enum Key: String, CaseIterable, ExpressibleByArgument {
        case name
        case platform
        case profileType
        case profileState
        case profileContent
        case uuid
        case createdDate
        case expirationDate
        case bundleID = "bundleId"
        case devices
        case certificates
    }

    public init?(argument: String) {
        switch Key(argument: argument) {
        case .name: self = .name
        case .platform: self = .platform
        case .profileType: self = .profileType
        case .profileState: self = .profileState
        case .profileContent: self = .profileContent
        case .uuid: self = .uuid
        case .createdDate: self = .createdDate
        case .expirationDate: self = .expirationDate
        case .bundleID: self = .bundleID
        case .devices: self = .devices
        case .certificates: self = .certificates
        case nil: return nil
        }
    }

    public static var allValueStrings: [String] { Key.allValueStrings }
    public static var allValueDescriptions: [String: String] { Key.allValueDescriptions }
    public static var defaultCompletionKind: CompletionKind { Key.defaultCompletionKind }
}

extension AppStoreConnectTool.ListProfiles.QueryParameters.Include: ExpressibleByArgument {
    private enum Key: String, CaseIterable, ExpressibleByArgument {
        case bundleID = "bundleId"
        case devices
        case certificates
    }

    public init?(argument: String) {
        switch Key(argument: argument) {
        case .bundleID: self = .bundleID
        case .devices: self = .devices
        case .certificates: self = .certificates
        case nil: return nil
        }
    }

    public static var allValueStrings: [String] { Key.allValueStrings }
    public static var allValueDescriptions: [String: String] { Key.allValueDescriptions }
    public static var defaultCompletionKind: CompletionKind { Key.defaultCompletionKind }
}

extension AppStoreConnectTool.ListProfiles.QueryParameters.Sort: ExpressibleByArgument {
    private enum Key: String, CaseIterable, ExpressibleByArgument {
        case name
        case `-name`
        case profileType
        case `-profileType`
        case profileState
        case `-profileState`
        case id
        case `-id`
    }

    public init?(argument: String) {
        switch Key(argument: argument) {
        case .name: self = .name
        case .`-name`: self = .`-name`
        case .profileType: self = .profileType
        case .`-profileType`: self = .`-profileType`
        case .profileState: self = .profileState
        case .`-profileState`: self = .`-profileState`
        case .id: self = .id
        case .`-id`: self = .`-id`
        case nil: return nil
        }
    }

    public static var allValueStrings: [String] { Key.allValueStrings }
    public static var allValueDescriptions: [String: String] { Key.allValueDescriptions }
    public static var defaultCompletionKind: CompletionKind { Key.defaultCompletionKind }
}

extension AppStoreConnectTool.ListProfiles.QueryParameters.FieldsBundleIDs: ExpressibleByArgument {
    private enum Key: String, CaseIterable, ExpressibleByArgument {
        case name
        case platform
        case identifier
        case seedID = "seedId"
        case profiles
        case bundleIDCapabilities = "bundleIdCapabilities"
        case app
    }

    public init?(argument: String) {
        switch Key(argument: argument) {
        case .name: self = .name
        case .platform: self = .platform
        case .identifier: self = .identifier
        case .seedID: self = .seedID
        case .profiles: self = .profiles
        case .bundleIDCapabilities: self = .bundleIDCapabilities
        case .app: self = .app
        case nil: return nil
        }
    }

    public static var allValueStrings: [String] { Key.allValueStrings }
    public static var allValueDescriptions: [String: String] { Key.allValueDescriptions }
    public static var defaultCompletionKind: CompletionKind { Key.defaultCompletionKind }
}

extension AppStoreConnectTool.ListProfiles.QueryParameters.FilterProfileState: ExpressibleByArgument {
    private enum Key: String, CaseIterable, ExpressibleByArgument {
        case active = "ACTIVE"
        case invalid = "INVALID"
    }

    public init?(argument: String) {
        switch Key(argument: argument) {
        case .active: self = .active
        case .invalid: self = .invalid
        case nil: return nil
        }
    }

    public static var allValueStrings: [String] { Key.allValueStrings }
    public static var allValueDescriptions: [String: String] { Key.allValueDescriptions }
    public static var defaultCompletionKind: CompletionKind { Key.defaultCompletionKind }
}

extension AppStoreConnectTool.ListProfiles.QueryParameters.FilterProfileType: ExpressibleByArgument {
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
