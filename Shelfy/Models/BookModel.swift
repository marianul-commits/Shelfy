//
//  BookModel.swift
//  Shelfy
//
//  Created by Marian Nasturica on 16.06.2023.
//

import Foundation

struct Results: Decodable {
    let items: [Items]?
}

struct Items: Decodable{
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Decodable{
    
    let title: String?
    let authors: [String]?
    let description: String?
    let industryIdentifiers: [ISBN]
    let pageCount: String
    let categories: [Categories]
    let averageRating: Int
    let ratingCount: Int
    let maturityRating: String
    let imageLinks: ImageLink?
    let language: String
    let previewLinks: String?
}

struct ISBN: Decodable {
    let type: String
    let identifier: String
}

struct Categories: Decodable{
    let category: String
}

struct ImageLink: Decodable {
    let smallThumbnail: String
    let thumbnail: String
}

