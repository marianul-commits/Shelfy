//
//  BookModel.swift
//  Shelfy
//
//  Created by Marian Nasturica on 16.06.2023.
//

import Foundation

struct Book: Decodable{
    
    let id: String
    let volumeInfo: BookInfo
}

struct BookInfo: Decodable{
    
    let title: String?
    let authors: [String]?
    let description: String?
    let imageLinks: String?
    let previewLinks: String?
}

struct BookList: Decodable{
    
    let items: [Book]?
}
