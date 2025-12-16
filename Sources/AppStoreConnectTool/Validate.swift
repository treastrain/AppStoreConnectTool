//
//  Validate.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2025/12/16.
//

import AppStoreConnect_Swift_SDK
import Foundation

extension AppStoreConnectTool {
    public struct Validate {
        public init() {}
    }
}

extension AppStoreConnectTool.Validate {
    public func run(payload: AppStoreConnectTool.Payload) throws {
        _ = try APIConfiguration(from: payload)
    }
}
