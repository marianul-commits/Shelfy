//
//  LevelManager.swift
//  Shelfy
//
//  Created by Marian Nasturica on 31.03.2024.
//

import Foundation
import UIKit

class LevelManager {
    var currentValue: Float = 0.0
    var maxProgressValues: [Int] = [5000, 10500, 16000, 21500, 27000, 32500, 38000, 43500, 49000, 54500, 60000, 65500, 71000, 76500, 80000] // Values at which the progress reaches 100%
    var currentLevel: Int = 1 // Start at level 1
    var startOfLevel: Int = 0 // Start of progress for each level
    var previousPagesRead: Int?
    
    func updateProgressIfNeeded(pagesRead: Int) -> Float{
        // Check if pagesRead has changed
        guard previousPagesRead != pagesRead else {
            // PagesRead has not changed, no need to update progress
            return currentValue
        }
        
        // Update progress only if pagesRead has changed
        updateProgress(pagesRead: pagesRead)
        
        // Update previousPagesRead to the new value
        previousPagesRead = pagesRead
        
        return currentValue
    }
    
    // Function to update progress based on pagesRead
    func updateProgress(pagesRead: Int) {
        // Find the current level based on pagesRead
        while currentLevel <= maxProgressValues.count && pagesRead >= maxProgressValues[currentLevel - 1] {
            currentLevel += 1
        }
        
        // Set startOfLevel to the maxProgressValue of the previous level
        if currentLevel > 1 {
            startOfLevel = maxProgressValues[currentLevel - 2]
        }
        
        // Set progress to 1.0 if pagesRead reaches or exceeds any maxProgressValue
        if currentLevel > maxProgressValues.count {
            currentValue = 1.0
        } else {
            // Otherwise, calculate progress within the current level
            let currentMaxValue = maxProgressValues[currentLevel - 1]
            let progressWithinLevel = Float(pagesRead - startOfLevel) / Float(currentMaxValue - startOfLevel)
            currentValue = max(0.0, min(1.0, progressWithinLevel)) // Clamp progress between 0.0 and 1.0
        }
        
        print("Current Level: \(currentLevel), Progress: \(currentValue)")
    }

    
    // Function to get the title of the current level
    var currentLevelTitle: String {
        guard currentLevel >= 1 && currentLevel <= maxProgressValues.count else {
            return "God Emperor of Books 👑"
        }
        
        let levelTitles = [
            "Novice Reader 📖",
            "Page Turner 📚",
            "Bookworm 🐛",
            "Bibliophile 📜",
            "Literary Connoisseur 🎩",
            "Word Wizard 🧙‍♂️",
            "Story Enthusiast 📝",
            "Chapter Champion 🏆",
            "Literature Lover ❤️‍🔥",
            "Reading Maestro 🎓",
            "Genre Guru ☸️",
            "Page-turning Dragon 🐉",
            "Tome Titan 🔱",
            "Reading Royalty 💎",
            "God Emperor of Books 👑"
        ]
        
        return levelTitles[currentLevel - 1]
    }
}
