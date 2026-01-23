//
//  DeleteProfile.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2026/01/23.
//

import AppStoreConnect_Swift_SDK
import Foundation

extension AppStoreConnectTool {
    public struct DeleteProfile {
        public init() {}
    }
}

extension AppStoreConnectTool.DeleteProfile {
    public func run(
        id: String,
        payload: AppStoreConnectTool.Payload
    ) async throws {
        let configuration = try APIConfiguration(from: payload)
        let endpoint = APIEndpoint.v1.profiles.id(id).delete
        let provider = APIProvider(configuration: configuration)
        try await provider.request(endpoint)
    }
}
