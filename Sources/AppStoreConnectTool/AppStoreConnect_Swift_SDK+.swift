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

// - MARK: ProfileResponse

public protocol ProfileResponse: Codable, Sendable {
    associatedtype ProfileType: Profile
    var data: ProfileType { get }
}

extension AppStoreConnect_Swift_SDK.ProfileResponse: @retroactive @unchecked Sendable {}
extension AppStoreConnect_Swift_SDK.ProfileResponse: ProfileResponse {}

// - MARK: Profile

public protocol Profile: Identifiable, Codable, Sendable {
    associatedtype AttributesType: ProfileAttributes
    var id: String { get }
    var attributes: AttributesType? { get }
}

extension AppStoreConnect_Swift_SDK.Profile: @retroactive @unchecked Sendable {}
extension AppStoreConnect_Swift_SDK.Profile: Profile {}

public protocol ProfileAttributes: Codable, Sendable {
    var name: String? { get }
    var profileContent: String? { get }
}

extension AppStoreConnect_Swift_SDK.Profile.Attributes: @retroactive @unchecked Sendable {}
extension AppStoreConnect_Swift_SDK.Profile.Attributes: ProfileAttributes {}
