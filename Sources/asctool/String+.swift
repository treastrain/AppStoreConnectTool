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
        let fileURL = directoryURL.appending(path: fileName, directoryHint: .notDirectory)
        try data.write(to: fileURL, options: .atomic)
    }
}
