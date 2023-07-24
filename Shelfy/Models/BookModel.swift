//
//  BookModel.swift
//  Shelfy
//
//  Created by Marian Nasturica on 16.06.2023.
//

import Foundation

//struct Items: Decodable{
//    let id: String
//    let volumeInfo: VolumeInfo
//}
//
//struct VolumeInfo: Decodable{
//
//    let title: String?
//    let authors: [String]?
//    let description: String?
//    let industryIdentifiers: [ISBN]
//    let pageCount: Int?
//    let categories: [String]?
//    let averageRating: Double?
//    let ratingCount: Int?
//    let maturityRating: String?
//    let imageLinks: ImageLink?
//    let language: String?
//    let previewLinks: String?
//}
//
//struct ISBN: Decodable {
//    let type: String
//    let identifier: String
//}
//
//struct ImageLink: Decodable {
//    let smallThumbnail: String
//    let thumbnail: String
//}

struct Author: Codable {
    let name: String?
}

struct Book: Codable {
    let title: String?
    let author: Author?
    let publishedDate: String?
    let coverURL: URL?
    let description: String?
    let publishers: [String]?
}

struct OLBook: Decodable {
    let key: String
    let title: String
    let first_publish_year: Int?
    let author_name: [String]?
    let coverURL: URL?
    let descritption: String?
}


