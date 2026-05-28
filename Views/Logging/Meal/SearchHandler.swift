//
//  SearchHandler.swift
//
//  Extension for String data structure to do fuzzy normalization of strings.
//
import SwiftUI

extension String {
    var fuzzyNormalized: String {
        self
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
            .replacingOccurrences(of: "[^a-z0-9 ]",
                                  with: "",
                                  options: .regularExpression)
            .replacingOccurrences(of: "\\s+",
                                  with: " ",
                                  options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

func score(_ query: String, _ text: String) -> Int {
    let q = query.fuzzyNormalized
    let t = text.fuzzyNormalized
    
    let qWords = q.split(separator: " ")
    let tWords = t.split(separator: " ")
    
    var score = 0
    
    // exact match (best)
    if t == q {
        score += 100
    }
    
    // prefix match (very important for typing)
    if t.hasPrefix(q) {
        score += 50
    }
    
    // full containment
    if t.contains(q) {
        score += 30
    }
    
    // token matching ("root bee" → "root beer")
    for qw in qWords {
        if tWords.contains(where: { $0.hasPrefix(qw) }) {
            score += 10
        }
    }
    
    return score
}
