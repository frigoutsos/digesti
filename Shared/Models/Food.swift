//
//  Food.swift
//
//  This creates food objects based on the present JSON data.
//
import Foundation

struct Food: Codable, Hashable, Identifiable {
    let name: String
    let description: String
    let highFodmap: Bool

    // The dataset does not provide an ID, and each long description is unique.
    var id: String { description }

    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case highFodmap
        case legacyID = "id"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        highFodmap = try container.decode(Bool.self, forKey: .highFodmap)
        description = try container.decodeIfPresent(String.self, forKey: .description)
            ?? container.decodeIfPresent(String.self, forKey: .legacyID)
            ?? name
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(highFodmap, forKey: .highFodmap)
    }
}

func getFoods() -> [Food] {
    guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
        print("Error: data.json not found.")
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
