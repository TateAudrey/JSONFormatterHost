//
//  SourceEditorCommand.swift
//  JSONFormatterExtension
//
//  Created by Audrey Chanakira on 1/3/26.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation,
                 completionHandler: @escaping (Error?) -> Void) {

        let selections = invocation.buffer.selections

        for selection in selections {
            guard let range = selection as? XCSourceTextRange else { continue }

            // Grab selected lines as a single string
            let jsonString = (range.start.line...range.end.line).compactMap { idx in
                (invocation.buffer.lines[idx] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
            }.joined(separator: "\n")

            // Try to pretty print JSON
            if let data = jsonString.data(using: .utf8) {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data)
                    let prettyData = try JSONSerialization.data(
                        withJSONObject: jsonObject,
                        options: [.prettyPrinted, .sortedKeys]
                    )
                    if let prettyString = String(data: prettyData, encoding: .utf8) {
                        let newLines = prettyString.components(separatedBy: "\n")

                        // Replace original lines safely
                        var lineIndex = range.start.line
                        for newLine in newLines {
                            if lineIndex <= range.end.line {
                                invocation.buffer.lines[lineIndex] = newLine
                            } else {
                                invocation.buffer.lines.insert(newLine, at: lineIndex)
                            }
                            lineIndex += 1
                        }

                        // If new lines are fewer than original selection, remove extras
                        if lineIndex <= range.end.line {
                            let indexesToRemove = IndexSet(integersIn: lineIndex...range.end.line)
                            invocation.buffer.lines.removeObjects(at: indexesToRemove)
                        }
                    }
                } catch {
                    continue // Invalid JSON → leave unchanged
                }
            }
        }

        completionHandler(nil)
    }
}
