//
//  ListPropertyTrigger.swift
//  CopilotAPIAccess
//
//  Created by Elad on 25/04/2021.
//  Copyright © 2021 Zemingo. All rights reserved.
//

import Foundation

struct ListPropertyTrigger: PropertyTrigger {
        
    //MARK: - Keys
    private struct Keys {
        static let filterType = "filterType"
        static let propertyName = "propertyName"
        static let values = "values"
    }
    
    //MARK: - Property Trigger
    let filterType: FilterType
    let propertyName: String
    
    let values: [String]
    
    //MARK: - Init
    init?(withDictionary dictionary: [String: Any]) {
        guard let propertyName = dictionary[Keys.propertyName] as? String,
              let filterTypeValue = dictionary[Keys.filterType] as? String,
              let filterType = ListPropertyTrigger.filterTypeValidator(for: filterTypeValue),
              let values = dictionary[Keys.values] as? [String],
              !values.isEmpty
        else { return nil }
        self.propertyName = propertyName
        self.filterType = filterType
        self.values = values
    }
    
    
    func match(firedEventParameters: [String : String]) -> Bool {
        guard let filter = filterType as? ListFilterType  else { return false }
        switch filter {
        case .includes:
            var returnValue = false
            firedEventParameters.forEach { eventParameter in
                if eventParameter.key.caseInsensitiveCompare(propertyName) == .orderedSame {
                    returnValue = values.contains {
                        $0 == eventParameter.value
                    }
                }
            }
            return returnValue
        case .excludes:
            var returnValue = false
            firedEventParameters.forEach { eventParameter in
                if eventParameter.key.caseInsensitiveCompare(propertyName) == .orderedSame {
                    returnValue = !values.contains {
                        $0 == eventParameter.value
                    }
                }
            }
            return returnValue
        }
    }
    
    
    //MARK: - Private
    static func filterTypeValidator(for value: String) -> ListFilterType? {
        return ListFilterType(rawValue: value)
    }
}
