//
//  Constants.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import Foundation

struct K {
    static let emptyTableMessage = ["😱 Oh no, your shelfy is empty. It seems you're experiencing a \"bookworm drought.\"","🤗 Don't worry, your books are safe here, feel free to add one when you see it.", "📖 Brace yourself! Your bookshelf is looking rather barren, but fret not. The bookish storm shall pass, and your collection will flourish once again", "😄 Fear not, book lover! Your literary treasures are in good hands here.", "😮 Uh-oh! Your shelf is feeling a bit lonely, like a deserted island for books.", "📚 Psst! Guess what? Your books have found a sanctuary here, where they'll be cherished and protected.", "🌈 Don't despair, dear bookworm! Your bookshelf may look empty now, but it's a blank canvas waiting for masterpieces.", "🌟 Your bookshelf may seem bare, but that's just an invitation for new literary treasures.", "😌 Rest assured, dear reader! Your bookshelf might be craving more stories, but its appetite will soon be satisfied.", "✨ Keep calm and trust in the magic of books! ✨"]
    static let loginIdentifier = "loginSuccess"
    static let registerIdentifier = "accCreated"
    static let createAccIdentifier = "registerAcc"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "SearchCell"
    static let cellIdentifier2 = "MyBooksCell"
    static let cellNibName2 = "MyBooksCell"
    static let cellSegue = "MyBookTransition"
    static let searchSegue = "SearchTransition"
//    static let cellIdentifier3 = "ReusableCell"
//    static let cellNibName3 = "SearchCell"
//    static let cellIdentifier4 = "ReusableCell"
//    static let cellNibName4 = "SearchCell"
    static let searchItem = ""
    static let url = "https://www.googleapis.com/books/v1/volumes?q=\(K.searchItem)&key=\(K.apiKey)"
    static let apiKey = "AIzaSyB1oX9pSTe6WX_l86TUnvCV0MF6CqhBp04"
}

/*
 Bookshelf ID
 Favorites: 0
 Purchased: 1
 To Read: 2
 Reading Now: 3
 Have Read: 4
 Reviewed: 5
 Recently Viewed: 6
 Books For You: 8
 */
