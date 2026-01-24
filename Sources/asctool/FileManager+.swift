//
//  FileManager+.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2026/01/23.
//

import Foundation

extension FileManager {
    func validateDirectoryWritable(at path: URL) throws {
        let path =
            if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
                path.path()
            } else {
                path.path
            }
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) else {
            throw POSIXError(.ENOENT, userInfo: [NSFilePathErrorKey: path])
        }
        guard isDirectory.boolValue else {
            throw POSIXError(.ENOTDIR, userInfo: [NSFilePathErrorKey: path])
        }
        guard FileManager.default.isWritableFile(atPath: path) else {
            throw POSIXError(.EACCES, userInfo: [NSFilePathErrorKey: path])
        }
    }
}
