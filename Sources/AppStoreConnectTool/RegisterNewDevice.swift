//
//  RegisterNewDevice.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2025/12/18.
//

import AppStoreConnect_Swift_SDK
import Foundation

extension AppStoreConnectTool {
    public struct RegisterNewDevice {
        public init() {}
    }
}

extension AppStoreConnectTool.RegisterNewDevice {
    public func run(
        name: String,
        platform: BodyProperties.BundleIDPlatform,
        udid: String,
        payload: AppStoreConnectTool.Payload
    ) async throws -> some Codable {
        let configuration = try APIConfiguration(from: payload)
        let endpoint = APIEndpoint.v1.devices.post(
            DeviceCreateRequest(
                data: DeviceCreateRequest.Data(
                    type: .devices,
                    attributes: DeviceCreateRequest.Data.Attributes(
                        name: name,
                        platform: platform.data,
                        udid: udid
                    )
                )
            )
        )
        let provider = APIProvider(configuration: configuration)
        let response = try await provider.request(endpoint)
        return response
    }
}

extension AppStoreConnectTool.RegisterNewDevice {
    public enum BodyProperties: Sendable {}
}

extension AppStoreConnectTool.RegisterNewDevice.BodyProperties {
    public enum BundleIDPlatform: String, CaseIterable {
        case iOS, macOS, universal
    }
}

extension AppStoreConnectTool.RegisterNewDevice.BodyProperties.BundleIDPlatform {
    fileprivate var data: BundleIDPlatform {
        switch self {
        case .iOS: .ios
        case .macOS: .macOs
        case .universal: .universal
        }
    }
}
