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
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "SearchCell"
    static let cellIdentifier2 = "MyBooksCell"
    static let cellNibName2 = "MyBooksCell"
    static let cellSegue = "MyBookTransition"
    static let searchSegue = "SearchTransition"
    static let baseUrl = "https://www.googleapis.com/books/v1/volumes?q=orderBy=averageRating&key=\(K.apiKey)"
    static let apiKey = "AIzaSyB1oX9pSTe6WX_l86TUnvCV0MF6CqhBp04"
}


enum BookshelfID {
    case favorites //0
    case purchased //1
    case to_read //2
    case reading_now //3
    case have_read //4
    case reviewed //5
    case recently_reviewed //6
    case books_for_you //8
}



struct EmptyTable {
    static let shelfMsg = ["😱 Oh no, your shelfy is empty. It seems you're experiencing a \"bookworm drought.\"","🤗 Don't worry, your books are safe here, feel free to add one when you see it.", "📖 Brace yourself! Your bookshelf is looking rather barren, but fret not. The bookish storm shall pass, and your collection will flourish once again", "😄 Fear not, book lover! Your literary treasures are in good hands here.", "😮 Uh-oh! Your shelf is feeling a bit lonely, like a deserted island for books.", "📚 Psst! Guess what? Your books have found a sanctuary here, where they'll be cherished and protected.", "🌈 Don't despair, dear bookworm! Your bookshelf may look empty now, but it's a blank canvas waiting for masterpieces.", "🌟 Your bookshelf may seem bare, but that's just an invitation for new literary treasures.", "😌 Rest assured, dear reader! Your bookshelf might be craving more stories, but its appetite will soon be satisfied.", "✨ Keep calm and trust in the magic of books! ✨"]
    
    static let searchMsg = ["🐛 Looks like our bookworms are napping. No matches found!","📚 Well, this is awkward... No literary love at the moment!","☕️ Seems like the book universe is on a coffee break. No matches for you!","🧹 Oops! Our shelves seem a bit too tidy today. No matches in sight!","📖 No matches found, but don't worry, we won't judge your eclectic taste!","🔮 Did you out-quirk our algorithm? No matches detected!","🎉 Eureka! We found... oh wait, nope. False alarm. No matches found!","📚 Looks like even our bookish elves are puzzled. No matches to uncover!","🦄 Well, this is like looking for a unicorn in a library. No matches!","🚀 Houston, we have a... non-match situation. No cosmic connections found!"]
    
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
