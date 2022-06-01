//
//  DeepLinkCtaActionType.swift
//  CopilotAPIAccess
//
//  Created by Elad on 24/05/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

struct AppNavigationCtaActionType: CtaAction {
    
    //MARK: - Consts
    private struct Keys {
        static let appNavigationCommand = "appNavigationCommandIOS"
    }
    
    //MARK: - Properties
    let appNavigationCommand: String
    
    // MARK: - Init
    init?(withDictionary dictionary: [String: Any]) {
        guard let action = dictionary[Keys.appNavigationCommand] as? String else {
            return nil
        }
        self.appNavigationCommand = action
    }
}
