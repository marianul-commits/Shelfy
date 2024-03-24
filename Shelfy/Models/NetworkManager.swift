//
//  NetworkManagerv2.swift
//  Shelfy
//
//  Created by Marian Nasturica on 16.11.2023.
//

import Foundation
import UIKit


func fetchBookz(completion: @escaping ([OLBook]?) -> Void) {
    let urlString = "https://openlibrary.org/trending/weekly.json?limit=100"
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            completion(nil)
            return
        }

        do {
            let decoder = JSONDecoder()
            let booksResponse = try decoder.decode(BooksResponse.self, from: data)
            completion(booksResponse.books)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }

    task.resume()
}


func getRecommandationz(_ author: String, completion: @escaping ([OLBook]?) -> Void) {
    let baseUrl = "https://openlibrary.org/search.json"
    
    let querry = "author=\(author)"
    let urlString = "\(baseUrl)?\(querry)"
    
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            completion(nil)
            return
        }

        do {
            let decoder = JSONDecoder()
            let searchResponse = try decoder.decode(BooksResponse.self, from: data)
            completion(searchResponse.books)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }

    task.resume()
}


func searchBookz(_ search: String, completion: @escaping ([OLBook]?) -> Void) {
    let urlString = "https://openlibrary.org/search.json?q=\(search)"
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            completion(nil)
            return
        }

        do {
            let decoder = JSONDecoder()
            var booksResponse = try decoder.decode(BooksResponse.self, from: data)
            booksResponse.books = booksResponse.books.filter{ book in
                let title = book.title.lowercased()
                return !(title.contains("set") || title.contains("bundle") || title.contains("summary") || title.contains("collection") || title.contains("movie"))}
            completion(booksResponse.books)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }

    task.resume()
}

func pickRandomBook(fromGenre genre: String, retryCount: Int = 3, completion: @escaping (String?, String?, String?) -> Void) {
    guard retryCount > 0 else {
        print("Maximum retry count reached. Unable to fetch a random book.")
        completion(nil, nil, nil)
        return
    }
    
    let formattedGenre = genre.replacingOccurrences(of: " ", with: "+")
    let searchURL = URL(string: "https://openlibrary.org/search.json?q=\(formattedGenre)&sort=random&limit=5&random=true&lang=en")!
    
    URLSession.shared.dataTask(with: searchURL) { data, response, error in
        guard let data = data, error == nil else {
            print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let books = json["docs"] as? [[String: Any]], !books.isEmpty,
               let firstBook = books.randomElement(),
               let title = firstBook["title"] as? String,
               let coverID = firstBook["cover_i"] as? Int,
               let author = firstBook["author_name"] as? [String],
               let authorName = author.first {
                completion(title, "\(coverID)", "\(authorName)")
            } else {
                print("Error: No books found in the response or failed to extract data, retrying...")
                // Retry with decremented retry count
                pickRandomBook(fromGenre: genre, retryCount: retryCount - 1, completion: completion)
            }
        } catch {
            print("Error decoding JSON: \(error)")
            // Retry with decremented retry count
        }
    }.resume()
}

func fetchBookDescription(forKey key: String, completion: @escaping (String?) -> Void) {
    let urlString = "https://openlibrary.org\(key).json"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            print("No data received: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let bookDetails = try decoder.decode(BookDescription.self, from: data)
            
            
            completion(bookDetails.description)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }
    
    task.resume()
}


func fetchBookRatings(forKey key: String, completion: @escaping (OLBookRatings?) -> Void) {
    let urlString = "https://openlibrary.org\(key)/ratings.json"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            print("No data received: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }

        do {
            let decoder = JSONDecoder()
            let shelves = try decoder.decode(OLBookRatings.self, from: data)
            completion(shelves)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }

    task.resume()
}

func fetchBookShelves(forKey key: String, completion: @escaping (OLBookShelves?) -> Void) {
    let urlString = "https://openlibrary.org\(key)/bookshelves.json"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            print("No data received: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }

        do {
            let decoder = JSONDecoder()
            let shelves = try decoder.decode(OLBookShelves.self, from: data)
            completion(shelves)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }

    task.resume()
}

func downloadCoverImage(coverImageID: String, targetImageView: UIImageView, placeholderImage: UIImage? = nil) {
    let imageURLString = "https://covers.openlibrary.org/b/id/\(coverImageID)-M.jpg"
    
    guard let imageURL = URL(string: imageURLString) else {
        // Invalid URL
        if let placeholderImage = placeholderImage {
            targetImageView.image = placeholderImage
        }
        return
    }
    
    URLSession.shared.dataTask(with: imageURL) { data, response, error in
        if let data = data, let image = UIImage(data: data) {
            DispatchQueue.main.async {
                targetImageView.image = image
            }
        } else {
            // If the book has no photo or there's an error, set the placeholder image if provided
            if let placeholderImage = placeholderImage {
                DispatchQueue.main.async {
                    targetImageView.image = placeholderImage
                }
            }
        }
    }.resume()
}


func fetchNumberOfPages(forTitle title: String, completion: @escaping (Int?) -> Void) {
    let formattedTitle = title.replacingOccurrences(of: " ", with: "+")
    let urlString = "https://openlibrary.org/search.json?title=\(formattedTitle)"
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            print("No data received: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let bookDetailsResponse = try decoder.decode(BookSearchResponse.self, from: data)
            if let firstBookDetail = bookDetailsResponse.docs.first {
                completion(firstBookDetail.numberOfPagesMedian)
            } else {
                completion(nil)
            }
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }
    task.resume()
}







//MARK: API Structures


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

struct BookSearchResponse: Decodable {
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
