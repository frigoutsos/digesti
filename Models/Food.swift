//
//  Food.swift
//  ibsapp
//
//  This creates food objects based on the present JSON data.
//
import Foundation

struct Food: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let category: [String]
    let highFodmap: Bool
}

func getFoods() -> [Food] {
    guard let url = Bundle.main.url(forResource: "foods", withExtension: "json") else {
        print("Error: foods.json not found! Check your Build Phases.")
        return []
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let foods = try decoder.decode([Food].self, from: data)
        print("Success: Loaded \(foods.count) foods successfully.")
        return foods
    } catch {
        print("Error decoding food data: \(error.localizedDescription)")
        return []
    }
}
