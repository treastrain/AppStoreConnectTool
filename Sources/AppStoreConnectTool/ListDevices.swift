//
//  ListDevices.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2025/12/17.
//

import AppStoreConnect_Swift_SDK
import Foundation

extension AppStoreConnectTool {
    public struct ListDevices {
        public init() {}
    }
}

extension AppStoreConnectTool.ListDevices {
    public func run(
        fieldsDevices: [QueryParameters.FieldsDevices]? = nil,
        filterID: [String]? = nil,
        filterName: [String]? = nil,
        filterPlatform: [QueryParameters.FilterPlatform]? = nil,
        filterStatus: [QueryParameters.FilterStatus]? = nil,
        filterUDID: [String]? = nil,
        limit: UInt? = nil,
        sort: [QueryParameters.Sort]? = nil,
        payload: AppStoreConnectTool.Payload
    ) async throws -> some DevicesResponse {
        let configuration = try APIConfiguration(from: payload)
        let endpoint = APIEndpoint.v1.devices.get(
            parameters: APIEndpoint.V1.Devices.GetParameters(
                filterName: filterName,
                filterPlatform: filterPlatform.map(\.parameter),
                filterUdid: filterUDID,
                filterStatus: filterStatus.map(\.parameter),
                filterID: filterID,
                sort: sort.map(\.parameter),
                fieldsDevices: fieldsDevices.map(\.parameter),
                limit: limit.map(Int.init(_:))
            )
        )
        let provider = APIProvider(configuration: configuration)
        let response = try await provider.request(endpoint)
        return response
    }
}

extension AppStoreConnectTool.ListDevices {
    public enum QueryParameters: Sendable {}
}

extension AppStoreConnectTool.ListDevices.QueryParameters {
    public enum FieldsDevices: String, CaseIterable {
        case name, platform, udid, deviceClass, status, model, addedDate
    }

    public enum FilterPlatform: String, CaseIterable {
        case iOS, macOS, universal
    }

    public enum FilterStatus: String, CaseIterable {
        case enabled, disabled
    }

    public enum Sort: String, CaseIterable {
        case name
        case `-name`
        case platform
        case `-platform`
        case udid
        case `-udid`
        case status
        case `-status`
        case id
        case `-id`
    }
}

extension [AppStoreConnectTool.ListDevices.QueryParameters.FieldsDevices] {
    fileprivate var parameter: [APIEndpoint.V1.Devices.GetParameters.FieldsDevices] {
        self.map {
            switch $0 {
            case .name: .name
            case .platform: .platform
            case .udid: .udid
            case .deviceClass: .deviceClass
            case .status: .status
            case .model: .model
            case .addedDate: .addedDate
            }
        }
    }
}

extension [AppStoreConnectTool.ListDevices.QueryParameters.FilterPlatform] {
    fileprivate var parameter: [APIEndpoint.V1.Devices.GetParameters.FilterPlatform] {
        self.map {
            switch $0 {
            case .iOS: .ios
            case .macOS: .macOs
            case .universal: .universal
            }
        }
    }
}

extension [AppStoreConnectTool.ListDevices.QueryParameters.FilterStatus] {
    fileprivate var parameter: [APIEndpoint.V1.Devices.GetParameters.FilterStatus] {
        self.map {
            switch $0 {
            case .enabled: .enabled
            case .disabled: .disabled
            }
        }
    }
}

extension [AppStoreConnectTool.ListDevices.QueryParameters.Sort] {
    fileprivate var parameter: [APIEndpoint.V1.Devices.GetParameters.Sort] {
        self.map {
            switch $0 {
            case .name: .name
            case .`-name`: .minusname
            case .platform: .platform
            case .`-platform`: .minusplatform
            case .udid: .udid
            case .`-udid`: .minusudid
            case .status: .status
            case .`-status`: .minusstatus
            case .id: .id
            case .`-id`: .minusid
            }
        }
    }
}
