//
//  CreateProfile.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2026/01/23.
//

import AppStoreConnect_Swift_SDK
import Foundation

extension AppStoreConnectTool {
    public struct CreateProfile {
        public init() {}
    }
}

extension AppStoreConnectTool.CreateProfile {
    public func run(
        name: String,
        profileType: BodyProperties.ProfileType,
        bundleID: String,
        deviceIDs: [String]? = nil,
        certificateIDs: [String],
        payload: AppStoreConnectTool.Payload
    ) async throws -> some ProfileResponse {
        let configuration = try APIConfiguration(from: payload)
        let endpoint = APIEndpoint.v1.profiles.post(
            ProfileCreateRequest(
                data: ProfileCreateRequest.Data(
                    type: .profiles,
                    attributes: ProfileCreateRequest.Data.Attributes(
                        name: name,
                        profileType: profileType.data
                    ),
                    relationships: ProfileCreateRequest.Data.Relationships(
                        bundleID: ProfileCreateRequest.Data.Relationships.BundleID(
                            data: ProfileCreateRequest.Data.Relationships.BundleID.Data(
                                type: .bundleIDs,
                                id: bundleID
                            )
                        ),
                        devices: deviceIDs.map {
                            ProfileCreateRequest.Data.Relationships.Devices(
                                data: $0.map {
                                    ProfileCreateRequest.Data.Relationships.Devices.Datum(
                                        type: .devices,
                                        id: $0
                                    )
                                }
                            )
                        },
                        certificates: ProfileCreateRequest.Data.Relationships.Certificates(
                            data: certificateIDs.map {
                                ProfileCreateRequest.Data.Relationships.Certificates.Datum(
                                    type: .certificates,
                                    id: $0
                                )
                            }
                        )
                    )
                )
            )
        )
        let provider = APIProvider(configuration: configuration)
        let response = try await provider.request(endpoint)
        return response
    }
}

extension AppStoreConnectTool.CreateProfile {
    public enum BodyProperties: Sendable {}
}

extension AppStoreConnectTool.CreateProfile.BodyProperties {
    public enum ProfileType: String, CaseIterable {
        case iOSAppDevelopment, iOSAppStore, iOSAppAdhoc, iOSAppInhouse
        case macAppDevelopment, macAppStore, macAppDirect
        case tvOSAppDevelopment, tvOSAppStore, tvOSAppAdhoc, tvOSAppInhouse
        case macCatalystAppDevelopment, macCatalystAppStore, macCatalystAppDirect
    }
}

extension AppStoreConnectTool.CreateProfile.BodyProperties.ProfileType {
    fileprivate var data: ProfileCreateRequest.Data.Attributes.ProfileType {
        switch self {
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
