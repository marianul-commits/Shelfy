//
//  Extensions.swift
//  Shelfy
//
//  Created by Marian Nasturica on 24.07.2023.
//

import UIKit

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.textColor = .label
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = SetFont.setFontStyle(.medium, 16)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
        
        // Add the messageLabel as a subview
        addSubview(messageLabel)
        
        // Apply constraints
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10)
        ])
        
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

extension UserDefaults {
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: "isLoggedIn")
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: "isLoggedIn")
    }
}
