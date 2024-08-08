//
//  CSVParser.swift
//
//
//  Created by Mizuki Inaba on 2024/8/9.
//

import Foundation
import RegexBuilder


extension MZArbeit {
    
    public struct CSVParser {
        
        public init(csvContent: String) {
            self._csvContent = csvContent
        }
        
        public func itemsByLine() -> [[String]] {
            _csvContent
                .components(separatedBy: "\r\n")
                .map { _parseLine($0) }
        }
        
        
        // MARK: Private
        private var _csvContent: String
        
        private func _parseLine(_ lineString: String) -> [String] {
            func next(remove range: Range<String.Index>) -> String {
                var text = lineString
                text.removeSubrange(range)
                
                return text
            }
            
            let matchFunctions: [(String) -> RegExResult?] = [
                _firstMatch3,
                _firstMatch2,
                _firstMatch1
            ]
            
            let result: RegExResult? = matchFunctions.reduce(nil) { result, matchFunc in
                guard result == nil else { return result! }
                return matchFunc(lineString)
            }
            
            if let result = result {
                return [result.string] + _parseLine(next(remove: result.range))
            }
                
            return [_clearText(lineString)]
        }

        private func _firstMatch1(_ text: String) -> RegExResult? {
            guard text.first != #"""# else { return nil }
            
            guard let match = text.firstMatch(
                of: Regex {
                    Capture {
                        ZeroOrMore(.any, .reluctant)
                    } transform: {
                        _clearText($0)
                    }
                    ","
                }
            ) else {
                return nil
            }
            
            return .init(string: match.output.1, range: match.range)
        }

        private func _firstMatch2(_ text: String) -> RegExResult? {
            guard text.count > 3 else { return nil }
            
            let quote = Character(#"""#)
            
            guard text.first == quote &&
                  text[text.index(after: text.startIndex)] != quote
            else { return nil }
            
            guard let match = text.firstMatch(
                of: Regex {
                    Capture {
                        One(quote)
                        ZeroOrMore(.any, .reluctant)
                        One(quote)
                    } transform: {
                        _clearText($0)
                    }
                    ","
                }
            ) else {
                return nil
            }
            
            return .init(string: match.output.1, range: match.range)
        }

        private func _firstMatch3(_ text: String) -> RegExResult? {
            guard text.count > 6 else { return nil }
            
            let threeQuote = #"""""#
            guard text.hasPrefix(threeQuote) else { return nil }
            guard text[text.index(text.startIndex, offsetBy: 3)] != #"""# else { return nil }
            
            guard let match = text.firstMatch(
                of: Regex {
                    Capture {
                        One(threeQuote)
                        ZeroOrMore(.any, .reluctant)
                        One(threeQuote)
                    } transform: {
                        _clearText($0)
                    }
                    ","
                }
            ) else {
                return nil
            }
            
            return .init(string: match.output.1, range: match.range)
        }

        private func _clearText(_ text: Substring) -> String {
            _clearText(String(text))
        }

        private func _clearText(_ text: String) -> String {
            var text = text
            
            if text.first == #"""# && text.last == #"""# && text.count >= 2 {
                text.removeLast()
                text.removeFirst()
            }
            text = text.replacingOccurrences(of: #""""#, with: #"""#)
            
            return text
        }
        
        private struct RegExResult {
            var string: String
            var range: Range<String.Index>
        }
    }
}
