//
//  NetworkManager.swift
//  Shelfy
//
//  Created by Marian Nasturica on 23.07.2023.
//

import UIKit

struct GoogleBooksResponse: Decodable {
    let items: [Items]
}

func fetchBooks(completion: @escaping ([Items]?) -> Void) {
    let urlString = "https://www.googleapis.com/books/v1/volumes?q=subject:thriller&key=\(K.apiKey)"
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
            let booksResponse = try decoder.decode(GoogleBooksResponse.self, from: data)
            completion(booksResponse.items)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }

    task.resume()
}
