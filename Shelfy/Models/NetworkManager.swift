//
//  NetworkManagerv2.swift
//  Shelfy
//
//  Created by Marian Nasturica on 16.11.2023.
//

import Foundation
import UIKit

func fetchPagination(page: Int, completion: @escaping ([OLBook]?) -> Void) {
    let urlString = "https://openlibrary.org/trending/weekly.json?limit=20&page=\(page)&offset=1"
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    Task {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let booksResponse = try decoder.decode(BooksResponse.self, from: data)
            completion(booksResponse.books)
        } catch {
            print("Error fetching pagination: \(error)")
            completion(nil)
        }
    }
}

func getRecommendations(author: String, completion: @escaping ([OLBook]?) -> Void) {
    let baseUrl = "https://openlibrary.org/search.json?limit=10"
    let query = "author=\(author)"
    let urlString = "\(baseUrl)&\(query)"
    
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    Task {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let searchResponse = try decoder.decode(BooksResponse.self, from: data)
            completion(searchResponse.books)
        } catch {
            print("Error fetching recommendations: \(error)")
            completion(nil)
        }
    }
}

func searchBooks(search: String, page: Int, completion: @escaping ([OLBook]?) -> Void) {
    let formattedSearch = search.replacingOccurrences(of: " ", with: "+")
    let urlString = "https://openlibrary.org/search.json?q=\(formattedSearch)&limit=20&page=\(page)&offset=1"
    
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    Task {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            var booksResponse = try decoder.decode(BooksResponse.self, from: data)
            booksResponse.books = booksResponse.books.filter { book in
                let title = book.title.lowercased()
                return !(title.contains("set") || title.contains("bundle") || title.contains("summary") || title.contains("collection") || title.contains("movie"))
            }
            completion(booksResponse.books)
        } catch {
            print("Error searching books: \(error)")
            completion(nil)
        }
    }
}

func fetchBookDescription(forKey key: String, completion: @escaping (String?) -> Void) {
    let urlString = "https://openlibrary.org\(key).json"
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }
    
    Task {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let bookDetails = try decoder.decode(BookDescription.self, from: data)
            completion(bookDetails.description)
        } catch {
            print("Error fetching book description: \(error)")
            completion(nil)
        }
    }
}

func fetchBookRatings(forKey key: String, completion: @escaping (OLBookRatings?) -> Void) {
    let urlString = "https://openlibrary.org\(key)/ratings.json"
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }

    Task {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let shelves = try decoder.decode(OLBookRatings.self, from: data)
            completion(shelves)
        } catch {
            print("Error fetching book ratings: \(error)")
            completion(nil)
        }
    }
}

func fetchBookShelves(forKey key: String, completion: @escaping (OLBookShelves?) -> Void) {
    let urlString = "https://openlibrary.org\(key)/bookshelves.json"
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }

    Task {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let shelves = try decoder.decode(OLBookShelves.self, from: data)
            completion(shelves)
        } catch {
            print("Error fetching book shelves: \(error)")
            completion(nil)
        }
    }
}

func downloadCoverImage(coverImageID: String, targetImageView: UIImageView, placeholderImage: UIImage? = nil) {
    let imageURLString = "https://covers.openlibrary.org/b/id/\(coverImageID)-M.jpg"
    
    guard let imageURL = URL(string: imageURLString) else {
        // Invalid URL
        if let placeholderImage = placeholderImage {
            DispatchQueue.main.async {
                targetImageView.image = placeholderImage
                targetImageView.clipsToBounds = true
                targetImageView.layer.cornerRadius = 4
            }
        }
        return
    }
    
    Task {
        do {
            let (data, response) = try await URLSession.shared.data(from: imageURL)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                // Error in response
                if let placeholderImage = placeholderImage {
                    DispatchQueue.main.async {
                        targetImageView.image = placeholderImage
                        targetImageView.clipsToBounds = true
                        targetImageView.layer.cornerRadius = 4
                    }
                }
                return
            }
            
            if let image = UIImage(data: data) {
                // Successfully downloaded image
                DispatchQueue.main.async {
                    targetImageView.image = image
                    targetImageView.clipsToBounds = true
                    targetImageView.layer.cornerRadius = 6
                    // Save the downloaded image data to CacheManager
                    CacheManager.saveData(imageURLString, data)
                }
            } else {
                // Failed to convert data to image
                if let placeholderImage = placeholderImage {
                    DispatchQueue.main.async {
                        targetImageView.image = placeholderImage
                        targetImageView.clipsToBounds = true
                        targetImageView.layer.cornerRadius = 6
                    }
                }
            }
        } catch {
            // Error in URLSession data task
            print("Error downloading cover image: \(error)")
            if let placeholderImage = placeholderImage {
                DispatchQueue.main.async {
                    targetImageView.image = placeholderImage
                    targetImageView.clipsToBounds = true
                    targetImageView.layer.cornerRadius = 6
                }
            }
        }
    }
}

func fetchNumberOfPages(forTitle title: String, completion: @escaping (Int?) -> Void) {
    let formattedTitle = title.replacingOccurrences(of: " ", with: "+")
    let urlString = "https://openlibrary.org/search.json?title=\(formattedTitle)"
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }
    
    Task {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let bookDetailsResponse = try decoder.decode(BookPages.self, from: data)
            if let firstBookDetail = bookDetailsResponse.docs.first {
                completion(firstBookDetail.numberOfPagesMedian)
            } else {
                completion(nil)
            }
        } catch {
            print("Error fetching number of pages: \(error)")
            completion(nil)
        }
    }
}

func pickRandomBook(fromGenre genre: String, retryCount: Int = 3, completion: @escaping (String?, String?, String?, String?) -> Void) {
    guard retryCount > 0 else {
        print("Maximum retry count reached. Unable to fetch a random book.")
        completion(nil, nil, nil, nil)
        return
    }
    
    let formattedGenre = genre.replacingOccurrences(of: " ", with: "+")
    let searchURL = URL(string: "https://openlibrary.org/search.json?q=\(formattedGenre)&sort=random&limit=5&random=true&lang=en")!
    
    Task {
        do {
            let (data, _) = try await URLSession.shared.data(from: searchURL)
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let books = json["docs"] as? [[String: Any]], !books.isEmpty,
               let firstBook = books.randomElement(),
               let title = firstBook["title"] as? String,
               let coverID = firstBook["cover_i"] as? Int,
               let author = firstBook["author_name"] as? [String],
               let bookKey = firstBook["key"] as? String,
               let authorName = author.first {
                completion(title, "\(coverID)", "\(authorName)", bookKey)
            } else {
                print("Error: No books found in the response or failed to extract data, retrying...")
                // Retry with decremented retry count
                pickRandomBook(fromGenre: genre, retryCount: retryCount - 1, completion: completion)
            }
        } catch {
            print("Error fetching random book: \(error)")
            // Retry with decremented retry count
             pickRandomBook(fromGenre: genre, retryCount: retryCount - 1, completion: completion)
        }
    }
}
