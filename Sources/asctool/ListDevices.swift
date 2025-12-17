//
//  ListDevices.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2025/12/17.
//

import AppStoreConnectTool
import ArgumentParser
import Foundation

extension ASCTool {
    struct ListDevices: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            usage: """
                asctool list-devices [--fields-devices <fields-devices> ...] [--filter-id <filter-id> ...] [--filter-name <filter-name> ...] [--filter-platform <filter-platform> ...] [--filter-status <filter-status> ...] [--filter-udid <filter-udid> ...] [--limit <limit>] [--sort <sort> ...] [--pretty-printed] --issuer-id <issuer-id> --private-key-id <private-key-id> --private-key <private-key> [--expiration-duration <expiration-duration>]
                asctool list-devices [--fields-devices <fields-devices> ...] [--filter-id <filter-id> ...] [--filter-name <filter-name> ...] [--filter-platform <filter-platform> ...] [--filter-status <filter-status> ...] [--filter-udid <filter-udid> ...] [--limit <limit>] [--sort <sort> ...] [--pretty-printed] --individual-private-key-id <individual-private-key-id> --individual-private-key <individual-private-key> [--expiration-duration <expiration-duration>]
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
            let listDevices = AppStoreConnectTool.ListDevices()
            let response = try await listDevices.run(
                fieldsDevices: queryParameters.fieldsDevices.nilIfEmpty,
                filterID: queryParameters.filterID.nilIfEmpty,
                filterName: queryParameters.filterName.nilIfEmpty,
                filterPlatform: queryParameters.filterPlatform.nilIfEmpty,
                filterStatus: queryParameters.filterStatus.nilIfEmpty,
                filterUDID: queryParameters.filterUDID.nilIfEmpty,
                limit: queryParameters.limit,
                sort: queryParameters.sort.nilIfEmpty,
                payload: payload
            )
            try printWithJSONEncoder(response, prettyPrinted: prettyPrinted)
        }
    }
}

extension ASCTool.ListDevices {
    struct QueryParameters: ParsableArguments {
        @Option
        var fieldsDevices: [AppStoreConnectTool.ListDevices.QueryParameters.FieldsDevices] = []

        @Option
        var filterID: [String] = []

        @Option
        var filterName: [String] = []

        @Option
        var filterPlatform: [AppStoreConnectTool.ListDevices.QueryParameters.FilterPlatform] = []

        @Option
        var filterStatus: [AppStoreConnectTool.ListDevices.QueryParameters.FilterStatus] = []

        @Option
        var filterUDID: [String] = []

        @Option(help: "(maximum: 200)")
        var limit: UInt?

        @Option
        var sort: [AppStoreConnectTool.ListDevices.QueryParameters.Sort] = []
    }
}

extension AppStoreConnectTool.ListDevices.QueryParameters.FieldsDevices: ExpressibleByArgument {}

extension AppStoreConnectTool.ListDevices.QueryParameters.FilterPlatform: ExpressibleByArgument {
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

extension AppStoreConnectTool.ListDevices.QueryParameters.FilterStatus: ExpressibleByArgument {
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

extension AppStoreConnectTool.ListDevices.QueryParameters.Sort: ExpressibleByArgument {}
