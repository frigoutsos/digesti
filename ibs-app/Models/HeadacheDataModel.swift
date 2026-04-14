//
//  HeadacheDataModel.swift
//  AheadAche
//
//  This is the SwiftUI data model that represents all headache objects.
//
//  Created by Franklin Rigoutsos on 1/27/26.
//
import SwiftUI
import SwiftData

@Model
final class Headache {
    // Fields of a headache
    var onsetDateAndTime: Date
    var intensity: Int
    var locations: [HeadacheLocation]
    var triggers: [HeadacheTrigger]
    
    // Assign data to each field in the initializer
    init(
        onsetDateAndTime: Date,
        intensity: Int,
        locations: [HeadacheLocation],
        triggers: [HeadacheTrigger]
    ) {
        self.onsetDateAndTime = onsetDateAndTime
        self.intensity = intensity
        self.locations = locations
        self.triggers = triggers
    }
}
