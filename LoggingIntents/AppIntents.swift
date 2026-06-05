//
//  intents.swift
//  intents
//
//  Created by Franklin Rigoutsos on 5/30/26.
//

import AppIntents

struct intents: AppIntent {
    static var title: LocalizedStringResource { "intents" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
