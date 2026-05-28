//
//  MealDTO.swift
//
//  Data transfer object to transfer meals logged from the watch companion to the iOS app's SwiftData stores.
//
import SwiftUI

struct MealDTO: Codable {
    let date: Date
    let foods: [Food]
}
