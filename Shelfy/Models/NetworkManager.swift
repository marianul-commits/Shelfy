//
//  NetworkManager.swift
//  Shelfy
//
//  Created by Marian Nasturica on 23.07.2023.
//

import UIKit

struct GoogleBooksResponse: Decodable {
    var items: [Items]
}

func fetchBooks(completion: @escaping ([Items]?) -> Void) {
    let urlString = "https://www.googleapis.com/books/v1/volumes?q=orderBy=newest&rating&key=\(K.apiKey)"
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
            var booksResponse = try decoder.decode(GoogleBooksResponse.self, from: data)
            booksResponse.items =  booksResponse.items.filter{ book in
                let title = book.volumeInfo.title?.lowercased()
                return !(title!.contains("set") || title!.contains("bundle") || title!.contains("collection") || title!.contains("movie"))
                }
            completion(booksResponse.items)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }

    task.resume()
}

func fetchSearch(_ search: String, completion: @escaping ([Items]?) -> Void) {
    let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(search)"
    guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
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
            var booksResponse = try decoder.decode(GoogleBooksResponse.self, from: data)
            booksResponse.items =  booksResponse.items.filter{ book in
                let title = book.volumeInfo.title?.lowercased()
                return !(title!.contains("set") || title!.contains("bundle") || title!.contains("collection") || title!.contains("movie"))
                }
            completion(booksResponse.items)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }

    task.resume()
}

func fetchISBN(_ isbn: String, completion: @escaping ([Items]?) -> Void) {
    let urlString = "https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbn)"
    guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
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
            var booksResponse = try decoder.decode(GoogleBooksResponse.self, from: data)
            booksResponse.items =  booksResponse.items.filter{ book in
                let title = book.volumeInfo.title?.lowercased()
                return !(title!.contains("set") || title!.contains("bundle") || title!.contains("collection") || title!.contains("movie"))
                }
            completion(booksResponse.items)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }

    task.resume()
}


func getRecommandations(_ author: String, completion: @escaping ([Items]?) -> Void) {
    let baseUrl = "https://www.googleapis.com/books/v1/volumes"
    
    let querry = "q=inauthor:\(author)&key=\(K.apiKey)"
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
            var booksResponse = try decoder.decode(GoogleBooksResponse.self, from: data)
            booksResponse.items =  booksResponse.items.filter{ book in
                let title = book.volumeInfo.title?.lowercased()
                let filters = ["set", "bundle", "collection", "movie", "audiobook"]
                return !filters.contains { keyword in
                    title!.contains(keyword)}
                }
            completion(booksResponse.items)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }

    task.resume()
}


func addToShelf(bookID: String, shelfID: String, completion: @escaping (Error?) -> Void) {
    let urlString = "https://www.googleapis.com/books/v1/mylibrary/bookshelves/\(shelfID)/addVolume?volumeId=\(bookID)&key=\(K.apiKey)"
    
    guard let url = URL(string: urlString) else {
        completion(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(error)
            return
        }
        
        // Check the response status code and handle success/failure accordingly
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                completion(nil) // Success
            } else {
                completion(NSError(domain: "Error adding book to shelf", code: httpResponse.statusCode, userInfo: nil))
            }
        } else {
            completion(NSError(domain: "Unexpected response", code: 0, userInfo: nil))
        }
    }
    
    task.resume()
}


//func fetchBookshelf(bookshelfID: String, completion: @escaping (Error?) -> Void) {
//    let urlString = "https://www.googleapis.com/books/v1/mylibrary/bookshelves/\(bookshelfID)?key=\(K.apiKey)"
//
//    guard let url = URL(string: urlString) else {
//        completion(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
//        return
//    }
//
//    let task = URLSession.shared.dataTask(with: url) { data, response, error in
//        if let error = error {
//            completion(nil, error)
//            return
//        }
//
//        guard let data = data else {
//            completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
//            return
//        }
//
//        do {
//            let decoder = JSONDecoder()
//            let bookshelf = try decoder.decode(Bookshelf.self, from: data)
//            completion(bookshelf, nil)
//        } catch {
//            completion(nil, error)
//        }
//    }
//
//    task.resume()
//}
