//
//  BristolStoolType.swift
//
//  Enum to act as a translation layer between numbers and Bristol stool type objects.
//

enum BristolStoolType: Int, CaseIterable {
    case type1 = 1
    case type2 = 2
    case type3 = 3
    case type4 = 4
    case type5 = 5
    case type6 = 6
    case type7 = 7
    
    var title: String { "Type \(rawValue)" }

    var description: String {
        switch self {
        case .type1: return "Hard Pellets"
        case .type2: return "Lumpy Sausage"
        case .type3: return "Cracked Sausage"
        case .type4: return "Smooth Log"
        case .type5: return "Soft Chunks"
        case .type6: return "Mushy Stool"
        case .type7: return "Watery Diarrhea"
        }
    }
    
    static func from(consistency: Double) -> BristolStoolType {
        switch consistency {
        case 0...1:
            return .type1   // very hard
        case 1...2:
            return .type2
        case 2...3:
            return .type3
        case 3...4:
            return .type4   // ideal zone
        case 4...5:
            return .type5
        case 5...6:
            return .type6
        case 6...7:
            return .type7   // liquid
        default:
            return .type4
        }
    }
}
