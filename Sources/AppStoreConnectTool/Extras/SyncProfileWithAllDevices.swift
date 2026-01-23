//
//  SyncProfileWithAllDevices.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2026/01/24.
//

import AppStoreConnect_Swift_SDK
import Foundation

extension AppStoreConnectTool.Extra {
    public struct SyncProfileWithAllDevices {
        public init() {}
    }
}

extension AppStoreConnectTool.Extra.SyncProfileWithAllDevices {
    public func run(
        name: String,
        includeMacDevices: Bool = false,
        payload: AppStoreConnectTool.Payload
    ) async throws -> some ProfileResponse {
        let listProfiles = AppStoreConnectTool.ListProfiles()
        let profilesResponse = try await listProfiles.run(
            filterName: [name],
            include: [.bundleID, .certificates],
            payload: payload
        )
        let profiles = profilesResponse.data
        guard let profile = profiles.first(where: { $0.attributes?.name == name }) else { throw Error.profileNotFound(name: name) }
        guard let profileType = profile.attributes?.profileType?.property else { throw Error.profileTypeNotFound(profileName: name) }
        switch profileType {
        case .iOSAppDevelopment, .tvOSAppDevelopment, .macAppDevelopment, .macCatalystAppDevelopment, .iOSAppAdhoc, .tvOSAppAdhoc:
            break
        case .iOSAppStore, .iOSAppInhouse, .tvOSAppStore, .tvOSAppInhouse, .macAppStore, .macCatalystAppStore, .macAppDirect, .macCatalystAppDirect:
            throw Error.noDevicesToSync(profileName: name)
        }
        guard let bundleID = profile.relationships?.bundleID?.data?.id else { throw Error.bundleIDNotFound(profileName: name) }
        guard let certificateIDs = (profile.relationships?.certificates?.data)?.map(\.id), !certificateIDs.isEmpty else { throw Error.certificatesNotFound(profileName: name) }
        let platforms = profile.attributes?.platform.map { [$0.property] }.map { $0.contains(.iOS) && includeMacDevices ? $0 + [.macOS] : $0 }

        let listDevices = AppStoreConnectTool.ListDevices()
        let devicesResponse = try await listDevices.run(
            filterPlatform: platforms,
            filterStatus: [.enabled],
            limit: 200,
            payload: payload
        )
        let deviceIDs = devicesResponse.data.map(\.id)

        let deleteProfile = AppStoreConnectTool.DeleteProfile()
        try await deleteProfile.run(
            id: profile.id,
            payload: payload
        )

        let createProfile = AppStoreConnectTool.CreateProfile()
        let profileResponse = try await createProfile.run(
            name: name,
            profileType: profileType,
            bundleID: bundleID,
            deviceIDs: deviceIDs,
            certificateIDs: certificateIDs,
            payload: payload
        )
        return profileResponse
    }
}

extension AppStoreConnectTool.Extra.SyncProfileWithAllDevices {
    public enum Error: Swift.Error {
        case profileNotFound(name: String)
        case profileTypeNotFound(profileName: String)
        case noDevicesToSync(profileName: String)
        case bundleIDNotFound(profileName: String)
        case certificatesNotFound(profileName: String)
    }
}

extension BundleIDPlatform {
    fileprivate var property: AppStoreConnectTool.ListDevices.QueryParameters.FilterPlatform {
        switch self {
        case .ios: .iOS
        case .macOs: .macOS
        case .universal: .universal
        case .services: fatalError()
        }
    }
}

extension AppStoreConnect_Swift_SDK.Profile.Attributes.ProfileType {
    fileprivate var property: AppStoreConnectTool.CreateProfile.BodyProperties.ProfileType {
        switch self {
        case .iosAppDevelopment: .iOSAppDevelopment
        case .iosAppStore: .iOSAppStore
        case .iosAppAdhoc: .iOSAppAdhoc
        case .iosAppInhouse: .iOSAppInhouse
        case .macAppDevelopment: .macAppDevelopment
        case .macAppStore: .macAppStore
        case .macAppDirect: .macAppDirect
        case .tvosAppDevelopment: .tvOSAppDevelopment
        case .tvosAppStore: .tvOSAppStore
        case .tvosAppAdhoc: .tvOSAppAdhoc
        case .tvosAppInhouse: .tvOSAppInhouse
        case .macCatalystAppDevelopment: .macCatalystAppDevelopment
        case .macCatalystAppStore: .macCatalystAppStore
        case .macCatalystAppDirect: .macCatalystAppDirect
        }
    }
}
