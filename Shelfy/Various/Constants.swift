//
//  Constants.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit

struct K {
    
    static let loginIdentifier = "loginSuccess"
    static let registerIdentifier = "accCreated"
    static let createAccIdentifier = "registerAcc"
    static let guestModeIdentifier = "guestMode"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "SearchCell"
    static let cellIdentifier2 = "MyBooksCell"
    static let cellNibName2 = "MyBooksCell"
    static let cellSegue = "MyBookTransition"
    static let searchSegue = "SearchTransition"
    static let topGenres = [
                            "Fiction",
                            "Mystery",
                            "Thriller",
                            "Romance",
                            "Science Fiction",
                            "Fantasy",
                            "Biography",
                            "Self Help",
                            "Young Adult" ]
    static let errorLbl = "Well, this is awkward. The data seems to have vanished into the digital abyss. We'll keep an eye out for its return. 👀"
    static let addPagesError = "Oops! Looks like you're trying to read more pages than this book even has! It's like asking for seconds when the plate's empty. 📚🤔 Let's stick to what's available between the covers!"
    static let placeholder = """
                                      
                                  
                             """
    
    static let bookCategories = [
        "🖋️ Fiction",
        "🔍 Thriller",
        "🧚 Fantasy",
        "💖 Romance",
        "👽 Science Fiction",
        "✨ Young Adult",
        "🧘‍♂️ Self-Help",
        "💵 Finance",
        "🏥 Health"
    ]
    
    static let levels = ["Novice Reader 📖", //5k
                         "Page Turner 📚", //10,5k
                         "Bookworm 🐛", // 16k
                         "Bibliophile 📜", // 21,5k
                         "Literary Connoisseur 🎩", //27k
                         "Word Wizard 🧙‍♂️", // 32,5k
                         "Story Enthusiast 📝", // 38k
                         "Chapter Champion 🏆", // 43,5k
                         "Literature Lover ❤️‍🔥", // 49k
                         "Reading Maestro 🎓", // 54,5k
                         "Genre Guru ☸️", // 60k
                         "Page-turning Dragon 🐉", //65,5k
                         "Tome Titan 🔱", // 71k
                         "Reading Royalty 💎", // 76,5k
                         "God Emperor of Books 👑" ] //80k
    
    
//    static func pagesToNextLevel(pagesRead: Int) -> Int? {
//        switch pagesRead {
//        case 0..<5000:
//            return 5000 - pagesRead
//        case 5000..<10500:
//            return 10500 - pagesRead
//        case 10500..<16000:
//            return 16000 - pagesRead
//        case 16000..<21500:
//            return 21500 - pagesRead
//        case 21500..<27000:
//            return 27000 - pagesRead
//        case 27000..<32500:
//            return 32500 - pagesRead
//        case 32500..<38000:
//            return 38000 - pagesRead
//        case 38000..<43500:
//            return 43500 - pagesRead
//        case 43500..<49000:
//            return 49000 - pagesRead
//        case 49000..<54500:
//            return 54500 - pagesRead
//        case 54500..<60000:
//            return 60000 - pagesRead
//        case 60000..<65500:
//            return 65500 - pagesRead
//        case 65500..<71000:
//            return 71000 - pagesRead
//        case 71000..<76500:
//            return 76500 - pagesRead
//        case 76500..<80000:
//            return 80000 - pagesRead
//        default:
//            return nil
//        }
//    }
    
    static func determineLevel(pagesRead: Int) -> String {
        switch pagesRead {
        case 0..<5000:
            return "Novice Reader 📖"
        case 5000..<10500:
            return "Page Turner 📚"
        case 10500..<16000:
            return "Bookworm 🐛"
        case 16000..<21500:
            return "Bibliophile 📜"
        case 21500..<27000:
            return "Literary Connoisseur 🎩"
        case 27000..<32500:
            return "Word Wizard 🧙‍♂️"
        case 32500..<38000:
            return "Story Enthusiast 📝"
        case 38000..<43500:
            return "Chapter Champion 🏆"
        case 43500..<49000:
            return "Literature Lover ❤️‍🔥"
        case 49000..<54500:
            return "Reading Maestro 🎓"
        case 54500..<60000:
            return "Genre Guru ☸️"
        case 60000..<65500:
            return "Page-turning Dragon 🐉"
        case 65500..<71000:
            return "Tome Titan 🔱"
        case 71000..<76500:
            return "Reading Royalty 💎"
        case 76500..<80000:
            return "God Emperor of Books 👑"
        default:
            return "Novice Reader 📖"
        }
    }
    
    
    static func pagesToNextLevel(pagesRead: Int) -> Int? {
        let currentLevel = determineLevel(pagesRead: pagesRead)
        let nextPageThreshold = nextPageThresholdForCurrentLevel(pagesRead: pagesRead)
        
        guard let nextPageThreshold = nextPageThreshold else {
            return nil // Reached the maximum level
        }
        
        return nextPageThreshold - pagesRead
    }

    static func nextPageThresholdForCurrentLevel(pagesRead: Int) -> Int? {
        let currentLevel = determineLevel(pagesRead: pagesRead)
        var nextLevelThreshold = 0
        
        switch currentLevel {
        case "Novice Reader 📖":
            nextLevelThreshold = 10500
        case "Page Turner 📚":
            nextLevelThreshold = 16000
        case "Bookworm 🐛":
            nextLevelThreshold = 21500
        case "Bibliophile 📜":
            nextLevelThreshold = 27000
        case "Literary Connoisseur 🎩":
            nextLevelThreshold = 32500
        case "Word Wizard 🧙‍♂️":
            nextLevelThreshold = 38000
        case "Story Enthusiast 📝":
            nextLevelThreshold = 43500
        case "Chapter Champion 🏆":
            nextLevelThreshold = 49000
        case "Literature Lover ❤️‍🔥":
            nextLevelThreshold = 54500
        case "Reading Maestro 🎓":
            nextLevelThreshold = 60000
        case "Genre Guru ☸️":
            nextLevelThreshold = 65500
        case "Page-turning Dragon 🐉":
            nextLevelThreshold = 71000
        case "Tome Titan 🔱":
            nextLevelThreshold = 76500
        case "Reading Royalty 💎":
            nextLevelThreshold = 80000
        default:
            return nil
        }
        
        let previousLevelThreshold = previousLevelThresholdFor(currentLevel: currentLevel)
        
        return nextLevelThreshold - previousLevelThreshold
    }

    static func previousLevelThresholdFor(currentLevel: String) -> Int {
        switch currentLevel {
        case "Novice Reader 📖":
            return 0
        case "Page Turner 📚":
            return 5000
        case "Bookworm 🐛":
            return 10500
        case "Bibliophile 📜":
            return 16000
        case "Literary Connoisseur 🎩":
            return 21500
        case "Word Wizard 🧙‍♂️":
            return 27000
        case "Story Enthusiast 📝":
            return 32500
        case "Chapter Champion 🏆":
            return 38000
        case "Literature Lover ❤️‍🔥":
            return 43500
        case "Reading Maestro 🎓":
            return 49000
        case "Genre Guru ☸️":
            return 54500
        case "Page-turning Dragon 🐉":
            return 60000
        case "Tome Titan 🔱":
            return 65500
        case "Reading Royalty 💎":
            return 71000
        default:
            return 0
        }
    }



    
    static func greetUser(user: String) -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        var greeting = ""
        var emoji = ""
        
        switch hour {
        case 7..<12:
            greeting = "Good morning"
            emoji = "☀️"
        case 12..<19:
            greeting = "Good afternoon"
            emoji = "🌤️"
        default:
            greeting = "Good evening"
            emoji = "🌙"
        }
        
        var result = "\(greeting), \(user)! \(emoji)"
        
        return result
    }
    
    
    static func setGradientBackground(view: UIView, colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.startPoint = CGPoint(x:  0.0, y:  0.5)
        gradientLayer.endPoint = CGPoint(x:  2.0, y:  0.5)
        gradientLayer.locations = [0,  1]
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at:  0)
    }
}

struct EmptyTable {
    static let shelfMsg = [
                            "😱 Oh no, your shelfy is empty. It seems you're experiencing a \"bookworm drought.\"",
                            "🤗 Don't worry, your books are safe here, feel free to add one when you see it.",
                            "📖 Brace yourself! Your bookshelf is looking rather barren, but fret not. The bookish storm shall pass, and your collection will flourish once again",
                            "😄 Fear not, book lover! Your literary treasures are in good hands here.",
                            "😮 Uh-oh! Your shelf is feeling a bit lonely, like a deserted island for books.",
                            "📚 Psst! Guess what? Your books have found a sanctuary here, where they'll be cherished and protected.",
                            "🌈 Don't despair, dear bookworm! Your bookshelf may look empty now, but it's a blank canvas waiting for masterpieces.",
                            "🌟 Your bookshelf may seem bare, but that's just an invitation for new literary treasures.",
                            "😌 Rest assured, dear reader! Your bookshelf might be craving more stories, but its appetite will soon be satisfied.",
                            "✨ Keep calm and trust in the magic of books! ✨" ]
    
    static let collectionMsg = [
                                "Uh-oh! This category is as barren as a bookshelf in a ghost town! 👻📚 Time to summon some literary spirits!",
                                "Looks like this category is feeling rather bookish... empty! 📚🔍 Let's fill it with stories that sparkle like literary diamonds!",
                                "Whoops-a-daisy! This category seems to have lost its plot... and its books! 📖🌪️ Let's script a new chapter together!",
                                "Houston, we have a problem! This category is as empty as the vastness of space! 🌌📚 Time to launch some intergalactic reads!",
                                "Yikes! This category feels as empty as a library during a zombie apocalypse! 🧟‍♂️📚 Let's revive it with some undead reads!",
                                "Oh dear! This category is as bare as a bookshop in a parallel universe! 🌌📚 Let's warp into action and stock it up!",
                                "Well, butter my book biscuit! This category is as empty as a cookbook in a vegan cafe! 🥦📚 Time to add some flavor!",
                                "Egads! This category is as desolate as a bookshelf in a haunted house! 👻📚 Let's bring in some spectral stories!",
                                "Oh no, Sherlock! This category seems to have lost its clues... and its books! 🔍📚 Let's solve this mystery with a literary twist!",
                                "Drat! This category is as vacant as a library without a librarian! 📚🕵️‍♂️ Time to don the reading glasses and fill it up!" ]
    
    static let searchMsg = [
                            "🐛 Looks like our bookworms are napping. No matches found!",
                            "📚 Well, this is awkward... No literary love at the moment!",
                            "☕️ Seems like the book universe is on a coffee break. No matches for you!",
                            "🧹 Oops! Our shelves seem a bit too tidy today. No matches in sight!",
                            "📖 No matches found, but don't worry, we won't judge your eclectic taste!",
                            "🔮 Did you out-quirk our algorithm? No matches detected!",
                            "🎉 Eureka! We found... oh wait, nope. False alarm. No matches found!",
                            "📚 Looks like even our bookish elves are puzzled. No matches to uncover!",
                            "🦄 Well, this is like looking for a unicorn in a library. No matches!",
                            "🚀 Houston, we have a... non-match situation. No cosmic connections found!"]
    
}


struct SetFont {
    
    enum FontStyle {
        case regular
        case mono
        case medium
        case bold
        case ultra
        
    }
    
    static func setFontStyle(_ style: FontStyle, _ size: CGFloat) -> UIFont  {
        switch style {
        case .regular: return UIFont(name:"TripSans-Regular", size: size)!
        case .mono: return UIFont(name: "TripSansMono-Regular", size: size)!
        case .medium: return UIFont(name: "TripSans-Medium", size: size)!
        case .bold: return UIFont(name: "TripSans-Bold", size: size)!
        case .ultra: return UIFont(name: "TripSans-Ultra", size: size)!
            
        }
    }
}


