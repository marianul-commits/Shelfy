//
//  NetworkManager.swift
//  Shelfy
//
//  Created by Marian Nasturica on 23.07.2023.
//

import UIKit

struct BooksResponse: Decodable {
    let docs: [OLBook]
}

func fetchBooks(completion: @escaping ([OLBook]?) -> Void) {
    let urlString = "https://openlibrary.org/search.json?q=Nicola+Yoon"
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
            completion(booksResponse.docs)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }

    task.resume()
}
