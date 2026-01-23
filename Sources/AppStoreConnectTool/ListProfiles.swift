//
//  ListProfiles.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2026/01/24.
//

import AppStoreConnect_Swift_SDK
import Foundation

extension AppStoreConnectTool {
    public struct ListProfiles {
        public init() {}
    }
}

extension AppStoreConnectTool.ListProfiles {
    public func run(
        fieldsCertificates: [QueryParameters.FieldsCertificates]? = nil,
        fieldsDevices: [QueryParameters.FieldsDevices]? = nil,
        fieldsProfiles: [QueryParameters.FieldsProfiles]? = nil,
        filterID: [String]? = nil,
        filterName: [String]? = nil,
        include: [QueryParameters.Include]? = nil,
        limit: UInt? = nil,
        limitCertificates: UInt? = nil,
        limitDevices: UInt? = nil,
        sort: [QueryParameters.Sort]? = nil,
        fieldsBundleIDs: [QueryParameters.FieldsBundleIDs]? = nil,
        filterProfileState: [QueryParameters.FilterProfileState]? = nil,
        filterProfileType: [QueryParameters.FilterProfileType]? = nil,
        payload: AppStoreConnectTool.Payload
    ) async throws -> some Codable {
        let configuration = try APIConfiguration(from: payload)
        let endpoint = APIEndpoint.v1.profiles.get(
            parameters: APIEndpoint.V1.Profiles.GetParameters(
                filterName: filterName,
                filterProfileType: filterProfileType.map(\.parameter),
                filterProfileState: filterProfileState.map(\.parameter),
                filterID: filterID,
                sort: sort.map(\.parameter),
                fieldsProfiles: fieldsProfiles.map(\.parameter),
                fieldsBundleIDs: fieldsBundleIDs.map(\.parameter),
                fieldsDevices: fieldsDevices.map(\.parameter),
                fieldsCertificates: fieldsCertificates.map(\.parameter),
                limit: limit.map(Int.init(_:)),
                include: include.map(\.parameter),
                limitCertificates: limitCertificates.map(Int.init(_:)),
                limitDevices: limitDevices.map(Int.init(_:))
            )
        )
        let provider = APIProvider(configuration: configuration)
        let response = try await provider.request(endpoint)
        return response
    }
}

extension AppStoreConnectTool.ListProfiles {
    public enum QueryParameters: Sendable {}
}

extension AppStoreConnectTool.ListProfiles.QueryParameters {
    public enum FieldsCertificates: CaseIterable, Sendable {
        case name
        case certificateType
        case displayName
        case serialNumber
        case platform
        case expirationDate
        case certificateContent
        case activated
        case passTypeID
    }

    public enum FieldsDevices: CaseIterable, Sendable {
        case name
        case platform
        case udid
        case deviceClass
        case status
        case model
        case addedDate
    }

    public enum FieldsProfiles: CaseIterable, Sendable {
        case name
        case platform
        case profileType
        case profileState
        case profileContent
        case uuid
        case createdDate
        case expirationDate
        case bundleID
        case devices
        case certificates
    }

    public enum Include: CaseIterable, Sendable {
        case bundleID
        case devices
        case certificates
    }

    public enum Sort: CaseIterable, Sendable {
        case name
        case `-name`
        case profileType
        case `-profileType`
        case profileState
        case `-profileState`
        case id
        case `-id`
    }

    public enum FieldsBundleIDs: CaseIterable, Sendable {
        case name
        case platform
        case identifier
        case seedID
        case profiles
        case bundleIDCapabilities
        case app
    }

    public enum FilterProfileState: CaseIterable, Sendable {
        case active
        case invalid
    }

    public enum FilterProfileType: CaseIterable, Sendable {
        case iOSAppDevelopment, iOSAppStore, iOSAppAdhoc, iOSAppInhouse
        case macAppDevelopment, macAppStore, macAppDirect
        case tvOSAppDevelopment, tvOSAppStore, tvOSAppAdhoc, tvOSAppInhouse
        case macCatalystAppDevelopment, macCatalystAppStore, macCatalystAppDirect
    }
}

extension [AppStoreConnectTool.ListProfiles.QueryParameters.FieldsCertificates] {
    fileprivate var parameter: [APIEndpoint.V1.Profiles.GetParameters.FieldsCertificates] {
        self.map {
            switch $0 {
            case .name: .name
            case .certificateType: .certificateType
            case .displayName: .displayName
            case .serialNumber: .serialNumber
            case .platform: .platform
            case .expirationDate: .expirationDate
            case .certificateContent: .certificateContent
            case .activated: .activated
            case .passTypeID: .passTypeID
            }
        }
    }
}

extension [AppStoreConnectTool.ListProfiles.QueryParameters.FieldsDevices] {
    fileprivate var parameter: [APIEndpoint.V1.Profiles.GetParameters.FieldsDevices] {
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

extension [AppStoreConnectTool.ListProfiles.QueryParameters.FieldsProfiles] {
    fileprivate var parameter: [APIEndpoint.V1.Profiles.GetParameters.FieldsProfiles] {
        self.map {
            switch $0 {
            case .name: .name
            case .platform: .platform
            case .profileType: .profileType
            case .profileState: .profileState
            case .profileContent: .profileContent
            case .uuid: .uuid
            case .createdDate: .createdDate
            case .expirationDate: .expirationDate
            case .bundleID: .bundleID
            case .devices: .devices
            case .certificates: .certificates
            }
        }
    }
}

extension [AppStoreConnectTool.ListProfiles.QueryParameters.Include] {
    fileprivate var parameter: [APIEndpoint.V1.Profiles.GetParameters.Include] {
        self.map {
            switch $0 {
            case .bundleID: .bundleID
            case .devices: .devices
            case .certificates: .certificates
            }
        }
    }
}

extension [AppStoreConnectTool.ListProfiles.QueryParameters.Sort] {
    fileprivate var parameter: [APIEndpoint.V1.Profiles.GetParameters.Sort] {
        self.map {
            switch $0 {
            case .name: .name
            case .`-name`: .minusname
            case .profileType: .profileType
            case .`-profileType`: .minusprofileType
            case .profileState: .profileState
            case .`-profileState`: .minusprofileState
            case .id: .id
            case .`-id`: .minusid
            }
        }
    }
}

extension [AppStoreConnectTool.ListProfiles.QueryParameters.FieldsBundleIDs] {
    fileprivate var parameter: [APIEndpoint.V1.Profiles.GetParameters.FieldsBundleIDs] {
        self.map {
            switch $0 {
            case .name: .name
            case .platform: .platform
            case .identifier: .identifier
            case .seedID: .seedID
            case .profiles: .profiles
            case .bundleIDCapabilities: .bundleIDCapabilities
            case .app: .app
            }
        }
    }
}

extension [AppStoreConnectTool.ListProfiles.QueryParameters.FilterProfileState] {
    fileprivate var parameter: [APIEndpoint.V1.Profiles.GetParameters.FilterProfileState] {
        self.map {
            switch $0 {
            case .active: .active
            case .invalid: .invalid
            }
        }
    }
}

extension [AppStoreConnectTool.ListProfiles.QueryParameters.FilterProfileType] {
    fileprivate var parameter: [APIEndpoint.V1.Profiles.GetParameters.FilterProfileType] {
        self.map {
            switch $0 {
            case .iOSAppDevelopment: .iosAppDevelopment
            case .iOSAppStore: .iosAppStore
            case .iOSAppAdhoc: .iosAppAdhoc
            case .iOSAppInhouse: .iosAppInhouse
            case .macAppDevelopment: .macAppDevelopment
            case .macAppStore: .macAppStore
            case .macAppDirect: .macAppDirect
            case .tvOSAppDevelopment: .tvosAppDevelopment
            case .tvOSAppStore: .tvosAppStore
            case .tvOSAppAdhoc: .tvosAppAdhoc
            case .tvOSAppInhouse: .tvosAppInhouse
            case .macCatalystAppDevelopment: .macCatalystAppDevelopment
            case .macCatalystAppStore: .macCatalystAppStore
            case .macCatalystAppDirect: .macCatalystAppDirect
            }
        }
    }
}
