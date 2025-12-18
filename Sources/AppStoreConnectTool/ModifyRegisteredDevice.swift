//
//  ModifyRegisteredDevice.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2025/12/19.
//

import AppStoreConnect_Swift_SDK
import Foundation

extension AppStoreConnectTool {
    public struct ModifyRegisteredDevice {
        public init() {}
    }
}

extension AppStoreConnectTool.ModifyRegisteredDevice {
    public func run(
        id: String,
        name: String? = nil,
        status: BodyProperties.Status? = nil,
        payload: AppStoreConnectTool.Payload
    ) async throws -> some Codable {
        let configuration = try APIConfiguration(from: payload)
        let endpoint = APIEndpoint.v1.devices.id(id).patch(
            DeviceUpdateRequest(
                data: DeviceUpdateRequest.Data(
                    type: .devices,
                    id: id,
                    attributes: DeviceUpdateRequest.Data.Attributes(
                        name: name,
                        status: status.map(\.data)
                    )
                )
            )
        )
        let provider = APIProvider(configuration: configuration)
        let response = try await provider.request(endpoint)
        return response
    }
}

extension AppStoreConnectTool.ModifyRegisteredDevice {
    public enum BodyProperties: Sendable {}
}

extension AppStoreConnectTool.ModifyRegisteredDevice.BodyProperties {
    public enum Status: String, CaseIterable {
        case enabled, disabled
    }
}

extension AppStoreConnectTool.ModifyRegisteredDevice.BodyProperties.Status {
    fileprivate var data: DeviceUpdateRequest.Data.Attributes.Status {
        switch self {
        case .enabled: .enabled
        case .disabled: .disabled
        }
    }
}
