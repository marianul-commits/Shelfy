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
    static let searchItem = ""
    static let baseUrl = "https://www.googleapis.com/books/v1/volumes?q=orderBy=averageRating&key=\(K.apiKey)"
    static let searchUrl = "https://www.googleapis.com/books/v1/volumes?q=\(K.searchItem)&key=\(K.apiKey)"
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
    static let message = ["😱 Oh no, your shelfy is empty. It seems you're experiencing a \"bookworm drought.\"","🤗 Don't worry, your books are safe here, feel free to add one when you see it.", "📖 Brace yourself! Your bookshelf is looking rather barren, but fret not. The bookish storm shall pass, and your collection will flourish once again", "😄 Fear not, book lover! Your literary treasures are in good hands here.", "😮 Uh-oh! Your shelf is feeling a bit lonely, like a deserted island for books.", "📚 Psst! Guess what? Your books have found a sanctuary here, where they'll be cherished and protected.", "🌈 Don't despair, dear bookworm! Your bookshelf may look empty now, but it's a blank canvas waiting for masterpieces.", "🌟 Your bookshelf may seem bare, but that's just an invitation for new literary treasures.", "😌 Rest assured, dear reader! Your bookshelf might be craving more stories, but its appetite will soon be satisfied.", "✨ Keep calm and trust in the magic of books! ✨"]
    
    static let bookTitle = [
        "The Secret Garden",
        "The Catcher in the Rye",
        "Harry Potter and the Sorcerer's Stone",
        "To Kill a Mockingbird",
        "1984",
        "Pride and Prejudice",
        "The Great Gatsby",
        "The Hobbit",
        "The Da Vinci Code",
        "The Lord of the Rings"
    ]
    
    static let bookAuthors = [
        "Frances Hodgson Burnett",
        "J.D. Salinger",
        "J.K. Rowling",
        "Harper Lee",
        "George Orwell",
        "Jane Austen",
        "F. Scott Fitzgerald",
        "J.R.R. Tolkien",
        "Dan Brown",
        "J.R.R. Tolkien"
    ]
    
    static let bookDescriptions = [
        "The Secret Garden - A captivating children's novel about a young girl who discovers a hidden garden and the transformative power of nature.",
        "The Catcher in the Rye - A classic coming-of-age tale that follows the rebellious Holden Caulfield as he navigates the challenges of adolescence.",
        "Harry Potter and the Sorcerer's Stone - The first book in the magical series, where young Harry Potter embarks on an unforgettable journey at Hogwarts School of Witchcraft and Wizardry.",
        "To Kill a Mockingbird - A powerful story of racial injustice and moral growth seen through the eyes of young Scout Finch in the American South.",
        "1984 - A dystopian novel that paints a grim picture of a totalitarian society, where Big Brother is always watching.",
        "Pride and Prejudice - Jane Austen's timeless tale of love, societal norms, and misunderstandings among the British landed gentry.",
        "The Great Gatsby - F. Scott Fitzgerald's masterpiece that delves into the world of wealth, love, and the American Dream in the 1920s.",
        "The Hobbit - Join Bilbo Baggins on an epic adventure filled with dwarves, dragons, and treasure in J.R.R. Tolkien's fantasy classic.",
        "The Da Vinci Code - A gripping thriller that follows Robert Langdon as he unravels ancient mysteries and uncovers secret societies.",
        "The Lord of the Rings - Tolkien's epic high-fantasy trilogy follows the journey of the hobbit Frodo Baggins as he seeks to destroy the One Ring and save Middle-earth."
    ]
    
    static let bookTitles2 = [
        "The Midnight Library",
        "The Alchemist",
        "Gone Girl",
        "The Hunger Games",
        "The Martian",
        "The Night Circus",
        "The Girl on the Train",
        "The Name of the Wind",
        "Brave New World",
        "The Book Thief"
    ]

    static let bookAuthors2 = [
        "Matt Haig",
        "Paulo Coelho",
        "Gillian Flynn",
        "Suzanne Collins",
        "Andy Weir",
        "Erin Morgenstern",
        "Paula Hawkins",
        "Patrick Rothfuss",
        "Aldous Huxley",
        "Markus Zusak"
    ]

    static let bookDescriptions2 = [
        "The Midnight Library - Nora Seed finds herself in a magical library that allows her to explore alternative lives she could have lived.",
        "The Alchemist - Santiago embarks on a journey in search of a hidden treasure, learning valuable life lessons along the way.",
        "Gone Girl - A gripping psychological thriller that explores the dark complexities of a troubled marriage.",
        "The Hunger Games - In a dystopian future, Katniss Everdeen must fight for her life in a televised battle to the death.",
        "The Martian - Astronaut Mark Watney fights for survival on Mars after being left behind by his crew.",
        "The Night Circus - Le Cirque des Rêves is a mysterious circus that comes alive at night, captivating visitors with its wonders.",
        "The Girl on the Train - Rachel becomes entangled in a missing person's investigation and uncovers dark secrets.",
        "The Name of the Wind - Kvothe, a gifted musician and magician, tells his life story as a legendary figure.",
        "Brave New World - In a futuristic society, individuals are engineered for specific roles, and personal freedom comes at a cost.",
        "The Book Thief - Liesel Meminger steals books to share with others during the horrors of World War II."
    ]
}


struct SetFont {
    
    enum FontStyle {
        case regular
        case light
        case medium
        case semiBold
        case bold
        case extraBold
        case black
    }
    
    static func setFontStyle(_ style: FontStyle, _ size: CGFloat) -> UIFont  {
        switch style {
        case .regular: return UIFont(name:"MicroPremium-Regular", size: size)!
        case .light: return UIFont(name: "MicroPremium-Light", size: size)!
        case .medium: return UIFont(name: "MicroPremium-Medium", size: size)!
        case .semiBold: return UIFont(name: "MicroPremium-SemiBold", size: size)!
        case .bold: return UIFont(name: "MicroPremium-Bold", size: size)!
        case .extraBold: return UIFont(name: "MicroPremium-ExtraBold", size: size)!
        case .black: return UIFont(name: "MicroPremium-Black", size: size)!
        }
    }
}
