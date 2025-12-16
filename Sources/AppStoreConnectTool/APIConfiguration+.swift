//
//  APIConfiguration+.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2025/12/16.
//

import AppStoreConnect_Swift_SDK
import Foundation

extension APIConfiguration {
    init(from payload: AppStoreConnectTool.Payload) throws {
        switch payload {
        case .team(let team):
            if let expirationDuration = team.expirationDuration {
                self = try APIConfiguration(issuerID: team.issuerID, privateKeyID: team.privateKeyID, privateKey: team.privateKey, expirationDuration: expirationDuration)
            } else {
                self = try APIConfiguration(issuerID: team.issuerID, privateKeyID: team.privateKeyID, privateKey: team.privateKey)
            }
        case .individual(let individual):
            if let expirationDuration = individual.expirationDuration {
                self = try APIConfiguration(individualPrivateKeyID: individual.individualPrivateKeyID, individualPrivateKey: individual.individualPrivateKey, expirationDuration: expirationDuration)
            } else {
                self = try APIConfiguration(individualPrivateKeyID: individual.individualPrivateKeyID, individualPrivateKey: individual.individualPrivateKey)
            }
        }
    }
}
