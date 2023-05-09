//
//  String+Extension.swift
//  AllergyScanner
//
//  Created by Ahmed Dizdar on 07.05.23.
//

import Foundation

extension String {
	internal func makeTextToUniqueIngridientsTextArray() -> [String] {
		var uniqueItems = Set<String>()

		let separators = CharacterSet(
			charactersIn:
				"\(Self.ingridientSeperators())\(self.wordSeperator())"
		)

		let formatedText = self.trimmingCharacters(in: .whitespacesAndNewlines)
			.replacingOccurrences(of: "\n", with: "")
			.removeExtraWhitespace()
			.removeWhitespaceAroundCommas()

		// Save the unique string in original form, but filter out if it exists
		// in the lowercase form also.
		return formatedText.replaceCommasBetweenWordsWithSeperator()
			.components(separatedBy: separators)
			.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
			.filter { !$0.isEmpty }
			.map { $0.replacingOccurrences(of: self.wordSeperator(), with: ",") }
			.filter { uniqueItems.insert($0.lowercased()).inserted }
	}

	internal static func supportedIngridientSeperators() -> String {
		return "\(Self.ingridientSeperators()),"
	}

	private static func ingridientSeperators() -> String {
		return "\(Self.documentSeperatorForExport()).•"
	}

	internal static func documentSeperatorForExport() -> String {
		return ";"
	}

	private func replaceCommasBetweenWordsWithSeperator() -> String {
		let pattern = "(?<=\\D|\\w\\d),(?=\\D|\\d)|(?<=\\d),(?=\\D)"
		let regex = try! NSRegularExpression(pattern: pattern, options: [])
		let range = NSRange(location: 0, length: self.utf16.count)
		let matches = regex.matches(in: self, options: [], range: range)
		var result: [String] = []
		var start = 0

		for match in matches {
			let matchRange = match.range

			let substring = (self as NSString).substring(
				with: NSRange(
					location: start,
					length: matchRange.location - start
				)
			)

			result.append(substring)
			start = matchRange.location + 1
		}
		result.append((self as NSString).substring(from: start))

		return result.joined(separator: self.wordSeperator())
	}

	private func removeExtraWhitespace() -> String {
		let components = self.components(separatedBy: .whitespacesAndNewlines)
		return components.filter { !$0.isEmpty }.joined(separator: " ")
	}

	private func removeWhitespaceAroundCommas() -> String {
		let components = self.components(separatedBy: ",")
		let trimmedComponents = components.map { $0.trimmingCharacters(in: .whitespaces) }
		return trimmedComponents.joined(separator: ",")
	}

	private func wordSeperator() -> String {
		return "$%$"
	}
}


