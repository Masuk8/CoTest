//
//  NumericPropertyTrigger.swift
//  CopilotAPIAccess
//
//  Created by Elad on 25/04/2021.
//  Copyright © 2021 Zemingo. All rights reserved.
//

import Foundation

struct NumericPropertyTrigger: PropertyTrigger {
    
    var filterType: FilterType
    
    //MARK: - Keys
    private struct Keys {
        static let filterType = "filterType"
        static let propertyName = "propertyName"
        static let value = "value"
    }
        
    let propertyName: String
    
    let value: Double
    
    func match(firedEventParameters: [String : String]) -> Bool {
        guard let currentValue = firedEventParameters[propertyName], let doubleValue = Double(currentValue), let filter = filterType as? NumericFilterType  else { return false }
        switch filter {
        case .greaterThen:
            return doubleValue > value
        case .equals:
            return doubleValue == value
        case .greaterThanOrEquals:
            return doubleValue >= value
        case .lowerThan:
            return doubleValue < value
        case .lowerThanOrEquals:
            return doubleValue <= value
        }
    }
    
    init?(withDictionary dictionary: [String: Any]) {
        guard let propertyName = dictionary[Keys.propertyName] as? String,
              let filterTypeValue = dictionary[Keys.filterType] as? String,
              let filterType = NumericPropertyTrigger.filterTypeValidator(for: filterTypeValue),
              let value = dictionary[Keys.value] as? NSNumber
              else { return nil }
        self.propertyName = propertyName
        self.filterType = filterType
        self.value = Double(truncating: value)
    }
    
    //MARK: - Private
    static func filterTypeValidator(for value: String) -> NumericFilterType? {
        return NumericFilterType(rawValue: value)
    }
}

