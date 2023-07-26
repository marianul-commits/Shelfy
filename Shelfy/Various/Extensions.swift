//
//  Extensions.swift
//  Shelfy
//
//  Created by Marian Nasturica on 24.07.2023.
//

import UIKit

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 30)
        let container = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        let messageLabel = UILabel(frame: container)
        messageLabel.frame = container.inset(by: padding)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = SetFont.setFontStyle(.medium, 16)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}

extension UILabel {
    func setDynamicFontColor() {
        if #available(iOS 13.0, *) {
            // Use traitCollection.userInterfaceStyle to check the current user interface style.
            if self.traitCollection.userInterfaceStyle == .dark {
                // Set the font color for dark mode.
                self.textColor = UIColor(named: "Color")
            } else {
                // Set the font color for light mode.
                self.textColor = UIColor.black
            }
        } else {
            // Fallback for earlier iOS versions where dark mode is not supported.
            self.textColor = UIColor(named: "Color1")
        }
    }
    
    // Override traitCollectionDidChange to call setDynamicFontColor when the trait collection changes.
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setDynamicFontColor()
    }
}
