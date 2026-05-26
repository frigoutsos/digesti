//
//  MealInput.swift
//  ibsapp
//
//  This is the SwiftUI data model that represents all meal objects.
//
import SwiftUI
import SwiftData

@Model
final class Meal {
    // Fields of a meal
    var date: Date
    var foods: [Food]
    
    // Initialize fields
    init(
        date: Date,
        foods: [Food]
    ) {
        self.date = date
        self.foods = foods
    }
}

