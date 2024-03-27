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


