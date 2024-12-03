//
//  Extension.swift
//  CVSAssessment
//
//  Created by jiaxing liu on 12/2/24.
//

import Foundation

extension String {
    func matchingFirstGroup(using regex: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: regex) else { return nil }
        let range = NSRange(startIndex..<endIndex, in: self)
        let match = regex.firstMatch(in: self, options: [], range: range)
        if let range = match?.range(at: 1), let swiftRange = Range(range, in: self) {
            return String(self[swiftRange])
        }
        return nil
    }
}
