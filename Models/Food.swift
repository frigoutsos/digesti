//
//  Trigger.swift
//  ibs-app
//
//  This is an enum to represent possible episode triggers (including foods).
//
enum Trigger: Dictionary, Codable, CaseIterable {
    case beans = {"name": "Beans", "category": "Legumes", highFodmap: false}
    // TODO: ADD MORE FOODS/TRIGGERS TO THE LIST!
}
