//
//  ExtendedOneOfEventTrigger.swift
//  CopilotAPIAccess
//
//  Created by Elad on 25/04/2021.
//  Copyright © 2021 Zemingo. All rights reserved.
//

import Foundation

struct ExtendedOneOfEventTrigger {
    //MARK: - Consts
    private struct Keys {
        static let events = "events"
    }
    
    //MARK: - Properties
    let events: [EventTriggerWithProperties]
    
    // MARK: - Init
    init?(withDictionary dictionary: [String: Any]) {
        guard let events = dictionary[Keys.events] as? [[String: Any]] else { return nil }
        self.events = events.compactMap({ EventTriggerWithProperties(withDictionary: $0) })
    }
}

extension ExtendedOneOfEventTrigger: InAppMessageTrigger {
    func analyticsEventLogged(_ analyticsEvent: AnalyticsEvent) -> Bool {
        var match = false
        outerLoop: for event in events {
            if analyticsEvent.eventName.caseInsensitiveCompare(event.name) == .orderedSame {
                switch event.conditionType {
                case .and:
                    match = event.propertyTriggers.allSatisfy({$0.match(firedEventParameters: analyticsEvent.customParams) })
                    if match { break outerLoop }
                case .or:
                    guard !event.propertyTriggers.isEmpty else {
                        // in case of empty array we don't want to perform the "contains" logic because in this case the matching is true.
                        match = true
                        break outerLoop
                    }
                    match = event.propertyTriggers.contains(where: { (propertyTrigger) -> Bool in
                        propertyTrigger.match(firedEventParameters: analyticsEvent.customParams)
                    })
                    if match { break outerLoop }
                }
            }
        }
        return match
    }
    
    func getInitialState() -> InAppStatus { return .pending }
}
