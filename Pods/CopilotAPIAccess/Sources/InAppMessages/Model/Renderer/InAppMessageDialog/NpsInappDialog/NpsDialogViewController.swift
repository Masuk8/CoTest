//
//  NpsDialogViewController.swift
//  CopilotAPIAccess
//
//  Created by Elad on 17/05/2020.
//  Copyright © 2020 Zemingo. All rights reserved.
//

import UIKit

class NpsDialogViewController: DialogViewControllerBase {

    var dialogView = NpsDialogView(frame: .zero)

    var completion: ((String?) -> Void)?
    
    override func loadView() {
        super.loadView()
        dialogView.dismissDelegate = dismissDelegate
        dialogView.completion = {[weak self] (str) in
            self?.completion?(str)
        }
        view = dialogView
    }
}

extension NpsDialogViewController {
    // MARK: - Setter / Getter
    
    // MARK: Content
    
    var labelQuestionText: String {
        get {
            return dialogView.labelQuestionText ?? ""
        }
        set {
            dialogView.labelQuestionText = newValue
        }
    }
    
    var ctaBackgroundColor: UIColor {
        get { return dialogView.ctaBackgroundColor ?? UIColor.white }
        set {
            dialogView.ctaBackgroundColor = newValue
        }
    }
    
    var ctaTextColor: UIColor {
        get { return dialogView.ctaTextColor ?? UIColor.black }
        set {
            dialogView.ctaTextColor = newValue
        }
    }
    
    var bgColor: UIColor {
        get { return dialogView.bgColor ?? UIColor.white }
        set {
            dialogView.bgColor = newValue
        }
    }
    
    var textColorHex: UIColor {
        get { return dialogView.textColorHex ?? UIColor.white }
        set {
            dialogView.textColorHex = newValue
        }
    }
    
    var labelNotLikely: String {
        get {
            return dialogView.labelNotLikely ?? ""
        }
        set {
            dialogView.labelNotLikely = newValue
        }
    }
    
    var labelExtremelyLikely: String {
        get {
            return dialogView.labelExtremelyLikely ?? ""
        }
        set {
            dialogView.labelExtremelyLikely = newValue
        }
    }
    
    var labelAskMeAnotherTime: String {
        get {
            return dialogView.labelAskMeAnotherTime ?? ""
        }
        set {
            dialogView.labelAskMeAnotherTime = newValue
        }
    }
    
    var labelDone: String {
        get {
            return dialogView.labelDone ?? ""
        }
        set {
            dialogView.labelDone = newValue
        }
    }
    
    var labelThankYou: String {
        get {
            return dialogView.labelThankYou ?? ""
        }
        set {
            dialogView.labelThankYou = newValue
        }
    }
    
    var image: UIImage? {
        get { return dialogView.image }
        set {
            dialogView.image = newValue
        }
    }

}
