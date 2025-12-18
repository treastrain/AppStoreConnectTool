//
//  AppStoreConnect_Swift_SDK+.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2025/12/19.
//

import AppStoreConnect_Swift_SDK
import Foundation

// - MARK: DevicesResponse

public protocol DevicesResponse: Codable, Sendable {
    associatedtype DeviceType: Device
    var data: [DeviceType] { get }
}

extension AppStoreConnect_Swift_SDK.DevicesResponse: @retroactive @unchecked Sendable {}
extension AppStoreConnect_Swift_SDK.DevicesResponse: DevicesResponse {}

// - MARK: Device

public protocol Device: Identifiable, Codable, Sendable {
    var id: String { get }
}

extension AppStoreConnect_Swift_SDK.Device: @retroactive @unchecked Sendable {}
extension AppStoreConnect_Swift_SDK.Device: Device {}
