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
        commandName: "\(Self.self)".lowercased()
    )
}
