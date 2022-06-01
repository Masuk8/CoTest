//
//  MessagePresentationMapper.swift
//  CopilotAPIAccess
//
//  Created by Elad on 27/01/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import Foundation

struct MessagePresentationMapper {
    
    private enum MessagePresentationType: String {
        //The case value need to be exact name like we recieved from the server
        case simpleInappModel = "SimpleInappModel"
        case htmlInappModel = "HtmlInappModel"
        case npsInappModel = "NpsInappModel"
    }
    
    //MARK: - Consts
    private struct Keys {
        static let type = "_type"
    }

    //MARK: - Factory
    static func map(withDictionary dictionary: [String: Any]) -> InAppMessagePresentation? {
        let typeResponse = dictionary[Keys.type] as? String
        if let imageUrl = dictionary["imageUrl"] as? String {
			ImageCacher(dataManager: DataFileManager()).loadImage(forUrl: imageUrl)
        }
        var type: InAppMessagePresentation?
          switch typeResponse {
          case MessagePresentationType.simpleInappModel.rawValue:
            type = SimpleInappPresentationModel(withDictionary: dictionary)
//          case MessagePresentationType.npsInappModel.rawValue:
//            type = NpsInappPresentationModel(withDictionary: dictionary)
          case MessagePresentationType.htmlInappModel.rawValue:
            if validateHtmlContentAndCtas(htmlType: HtmlInappPresentationModel(withDictionary: dictionary)) {
                type = HtmlInappPresentationModel(withDictionary: dictionary)
            }
            
          default:
              type = nil
          }
        return type
    }
    
    //For every cta that we presented in tht html popup, there must to be equivalent cta on the cta array.
    
    private static func validateHtmlContentAndCtas(htmlType: HtmlInappPresentationModel?) -> Bool {

        guard let htmlType = htmlType else { return false }
        
        let matchedCtaEntries = htmlType.content.matches(for: "\"cplt:.+?\"")

        //html content need to contain at least one button to present
        guard matchedCtaEntries.count > 0 else { return false }
        
        let htmlCtaEntries = Set(matchedCtaEntries.map {
            $0.deletingPrefix("\"cplt://").deletingSuffix("\"")
        })

        let ctasRedirectIds = Set(htmlType.ctas.compactMap {
            ($0 as? CtaHtmlType?)??.redirectId
        })
        return htmlCtaEntries.isSubset(of: ctasRedirectIds)
    }
}
