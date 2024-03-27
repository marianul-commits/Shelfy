//
//  Book.swift
//  Shelfy
//
//  Created by Marian Nasturica on 27.03.2024.
//

import Foundation


struct BookDescription: Codable {
    let description: String?

    private enum CodingKeys: String, CodingKey {
        case description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Attempt to decode the description as a string
        if let descriptionString = try? container.decode(String.self, forKey: .description) {
            self.description = descriptionString
        } else if let descriptionDictionary = try? container.decode([String: String].self, forKey: .description) {
            // If the description is a dictionary, extract the string value from it
            self.description = descriptionDictionary["value"]
        } else {
            // If decoding fails, set description to nil or handle the error as needed
            self.description = nil
        }
    }
}

struct OLBook: Codable {
    let key: String
    let title: String
    let author_name: [String]?
    let cover_i: Int?
    let ratigns: OLBookRatings?
    let bookshelves: OLBookShelves?
    let availability: Availability?
}

struct Availability: Codable {
    let isbn: String?
}

struct BookPages: Decodable {
    let docs: [BookDocument]

    struct BookDocument: Decodable {
        let numberOfPagesMedian: Int?

        enum CodingKeys: String, CodingKey {
            case numberOfPagesMedian = "number_of_pages_median"
        }
    }
}

struct OLBookRatings: Codable {
    let summary: RatingSummary?
}

struct RatingSummary: Codable {
    let average: Double?
}

struct OLBookShelves: Codable {
    let counts: Bookshelf?
}

struct Bookshelf: Codable {
    let want_to_read: Int?
    let currently_reading: Int?
    let already_read: Int?
}

struct BooksResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case docs, works
    }

    var books: [OLBook]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Check which key is present in the container and decode the array of OLBook accordingly
        if let books = try? container.decode([OLBook].self, forKey: .docs) {
            self.books = books
        } else if let books = try? container.decode([OLBook].self, forKey: .works) {
            self.books = books
        } else {
            // Initialize books with an empty array if decoding fails for both keys
            self.books = []
            throw DecodingError.dataCorrupted(
                .init(codingPath: container.codingPath, debugDescription: "Unable to decode books"))
        }
    }
}
