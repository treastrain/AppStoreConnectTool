//
//  String+.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2026/01/23.
//

import Foundation

extension String {
    func writeAsBase64EncodedData(to directoryURL: URL, as fileName: String) throws {
        guard let data = Data(base64Encoded: self) else { throw CocoaError(.fileReadCorruptFile) }
        let fileName = fileName.replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "/", with: "")
            .replacingOccurrences(of: ":", with: "")
        let fileURL =
            if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
                directoryURL.appending(path: fileName, directoryHint: .notDirectory)
            } else {
                directoryURL.appendingPathComponent(fileName, isDirectory: false)
            }
        try data.write(to: fileURL, options: .atomic)
    }
}
