//
//  PrintWithJSONEncoder.swift
//  AppStoreConnectTool
//
//  Created by treastrain on 2025/12/17.
//

import Foundation

func printWithJSONEncoder(
    _ value: some Encodable,
    prettyPrinted: Bool,
    to output: inout some TextOutputStream
) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
    if prettyPrinted { encoder.outputFormatting.insert(.prettyPrinted) }
    let data = try encoder.encode(value)
    let string = String(data: data, encoding: .utf8)!
    output.write(string)
}

func printWithJSONEncoder(
    _ value: some Encodable,
    prettyPrinted: Bool
) throws {
    var stream = DefaultTextOutputStream()
    try printWithJSONEncoder(value, prettyPrinted: prettyPrinted, to: &stream)
}

private struct DefaultTextOutputStream: TextOutputStream {
    mutating func write(_ string: String) {
        print(string)
    }
}
