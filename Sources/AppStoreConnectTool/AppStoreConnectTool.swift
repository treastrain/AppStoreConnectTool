//
//  AppStoreConnectTool.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2025/12/16.
//

import Foundation

public enum AppStoreConnectTool {
}

extension AppStoreConnectTool {
    public enum Payload: Codable, Sendable {
        case team(Team)
        case individual(Individual)
    }
}

extension AppStoreConnectTool.Payload {
    public struct Team: Codable, Sendable {
        public var issuerID: String
        public var privateKeyID: String
        public var privateKey: String
        public var expirationDuration: TimeInterval?

        public init(
            issuerID: String,
            privateKeyID: String,
            privateKey: String,
            expirationDuration: TimeInterval? = nil
        ) {
            self.issuerID = issuerID
            self.privateKeyID = privateKeyID
            self.privateKey = privateKey
            self.expirationDuration = expirationDuration
        }
    }

    public struct Individual: Codable, Sendable {
        public var individualPrivateKeyID: String
        public var individualPrivateKey: String
        public var expirationDuration: TimeInterval?

        public init(
            individualPrivateKeyID: String,
            individualPrivateKey: String,
            expirationDuration: TimeInterval? = nil
        ) {
            self.individualPrivateKeyID = individualPrivateKeyID
            self.individualPrivateKey = individualPrivateKey
            self.expirationDuration = expirationDuration
        }
    }
}
