//
//  Collection+.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2025/12/17.
//

import Foundation

extension Collection {
    var nilIfEmpty: Self? { isEmpty ? nil : self }
}
