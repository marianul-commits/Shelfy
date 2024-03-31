//
//  PageStyleManager.swift
//  Shelfy
//
//  Created by Marian Nasturica on 31.03.2024.
//

import Foundation
import UIKit

class PageStyleManager {
    
    static let shared = PageStyleManager()
    
    var isPercentageDisplay = false
    
    func updateProgressLabel(pagesRead: Int?, totalPages: Int?, progressLbl: UILabel) -> String {
        if let pagesRead = pagesRead {
            if isPercentageDisplay == true {
                let percentage = Int(Double(pagesRead) / Double(totalPages!) * 100)
                return "\(percentage)%"
            } else {
                return "\(pagesRead) / \(totalPages!) pages"
            }
        } else {
            // Handle the case where pagesRead is nil
            return "N/A"
        }
    }
    
}

extension Notification.Name {
    static let bookChanged = Notification.Name("BookChanged")
}
