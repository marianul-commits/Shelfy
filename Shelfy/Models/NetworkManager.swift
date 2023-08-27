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
    let urlString = "https://www.googleapis.com/books/v1/volumes?q=orderBy=averageRating&ratingCount&key=\(K.apiKey)"
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


func getRecommandations(for bookTitle: String, completion: @escaping ([Items]?) -> Void) {
    let baseUrl = "https://www.googleapis.com/books/v1/volumes"
    
    guard let encodedTitle = bookTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        print("Error encoding book title")
        return
    }
    
    let querry = "q=\(encodedTitle)&key=\(K.apiKey)"
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
                    title!.contains(keyword)} && !title!.contains(encodedTitle)
                }
            completion(booksResponse.items)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }

    task.resume()
}
