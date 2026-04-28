//
//  Food.swift
//  ibs-app
//
//  This creates food objects based on the present JSON data.
//
import Foundation

struct Food: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let category: String
    let highFodmap: Bool
}

func getFoods() -> [Food] {
    guard let url = Bundle.main.url(forResource: "foods", withExtension: "json") else {
        return []
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let foods = try decoder.decode([Food].self, from: data)
        return foods
    } catch {
        return []
    }
}
