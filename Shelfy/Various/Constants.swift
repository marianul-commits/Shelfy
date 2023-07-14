//
//  Constants.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import Foundation

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
