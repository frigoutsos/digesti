//
//  HeadacheTrigger.swift
//  AheadAche
//
//  This is an enum to represent possible headache triggers.
//
//  Created by Franklin Rigoutsos on 1/27/26.
//
enum HeadacheTrigger: String, Codable, CaseIterable {
    case dehydration = "Dehydration"
    case diet = "Diet"
    case caffeine = "Caffiene"
    case alcohol = "Alcohol"
    case nicotine = "Nicotine"
    case sleep = "Sleep"
    case illness = "Illness"
    case hormones = "Hormones"
    case weather = "Weather"
    case allergies = "Allergies"
    case stress = "Stress"
    case exertion = "Exertion"
    case fragrances = "Fragrances"
    case chemicals = "Chemicals"
    case light = "Light"
    case eyestrain = "Eyestrain"
    case unsure = "Unsure"
    case other = "Other"
}
