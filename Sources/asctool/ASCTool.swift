//
//  ASCTool.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2025/12/16.
//

import AppStoreConnectTool
import ArgumentParser
import Foundation

@main
struct ASCTool: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "\(Self.self)".lowercased(),
        usage: """
            asctool <subcommand> --issuer-id <issuer-id> --private-key-id <private-key-id> --private-key <private-key> [--expiration-duration <expiration-duration>]
            asctool <subcommand> --individual-private-key-id <individual-private-key-id> --individual-private-key <individual-private-key> [--expiration-duration <expiration-duration>]
            """,
        subcommands: [
            ListDevices.self,
            RegisterNewDevice.self,
            Validate.self,
        ]
    )
}

extension ASCTool {
    struct Arguments: ParsableArguments {
        @OptionGroup
        var team: Team

        @OptionGroup
        var individual: Individual

        @Option(help: "The token's expiration time in Unix epoch time.")
        var expirationDuration: TimeInterval?
    }
}

extension ASCTool.Arguments {
    struct Team: ParsableArguments {
        @Option(help: "Your issuer ID from the API Keys page in App Store Connect.")
        var issuerID: String?

        @Option(help: "Your private key ID from App Store Connect.")
        var privateKeyID: String?

        @Option(help: "Your private key from App Store Connect.")
        var privateKey: String?

        var isValid: Bool {
            issuerID != nil && privateKeyID != nil && privateKey != nil
        }
    }
}

extension ASCTool.Arguments {
    struct Individual: ParsableArguments {
        @Option(help: "Your private key ID from App Store Connect.")
        var individualPrivateKeyID: String?

        @Option(help: "Your private key from App Store Connect.")
        var individualPrivateKey: String?

        var isValid: Bool {
            individualPrivateKeyID != nil && individualPrivateKey != nil
        }
    }
}

extension AppStoreConnectTool.Payload {
    init?(from arguments: ASCTool.Arguments) throws {
        switch (arguments.team.isValid, arguments.individual.isValid) {
        case (true, true):
            throw ValidationError("Only one of team or individual arguments must be provided.")
        case (true, false):
            self = try .team(Team(from: arguments.team, expirationDuration: arguments.expirationDuration))
        case (false, true):
            self = try .individual(Individual(from: arguments.individual, expirationDuration: arguments.expirationDuration))
        case (false, false):
            return nil
        }
    }
}

extension AppStoreConnectTool.Payload.Team {
    init(from arguments: ASCTool.Arguments.Team, expirationDuration: TimeInterval?) throws {
        guard let issuerID = arguments.issuerID,
            let privateKeyID = arguments.privateKeyID,
            let privateKey = arguments.privateKey,
            !issuerID.isEmpty,
            !privateKeyID.isEmpty,
            !privateKey.isEmpty
        else {
            throw ValidationError("Team arguments are incomplete.")
        }
        self = AppStoreConnectTool.Payload.Team(
            issuerID: issuerID,
            privateKeyID: privateKeyID,
            privateKey: privateKey,
            expirationDuration: expirationDuration
        )
    }
}

extension AppStoreConnectTool.Payload.Individual {
    init(from arguments: ASCTool.Arguments.Individual, expirationDuration: TimeInterval?) throws {
        guard let individualPrivateKeyID = arguments.individualPrivateKeyID,
            let individualPrivateKey = arguments.individualPrivateKey,
            !individualPrivateKeyID.isEmpty,
            !individualPrivateKey.isEmpty
        else {
            throw ValidationError("Individual arguments are incomplete.")
        }
        self = AppStoreConnectTool.Payload.Individual(
            individualPrivateKeyID: individualPrivateKeyID,
            individualPrivateKey: individualPrivateKey,
            expirationDuration: expirationDuration
        )
    }
}
