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
