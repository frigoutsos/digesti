//
//  MealInput.swift
//
//  Contains a temporary object to hold user input, which will be turned into a Meal object.
//
import SwiftUI

struct MealInput: Codable {
    var date: Date = Date()
    var foods: [Food] = []
}
