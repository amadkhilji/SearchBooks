//
//  HTTPRequest.swift
//  Mercari
//
//  Created by Amaduddin Ayub on 5/22/21.
//  Copyright © 2021 Mercari. All rights reserved.
//

import Foundation

final class NetworkService: NSObject {

    static private let searchAPI = "https://openlibrary.org/search.json"

    static func searchBookTitle(_ title: String?, completion: @escaping (_: [Book]?, Error?) -> Void) {
        guard let title = title, var components = URLComponents(string: searchAPI) else {
            completion(nil, nil)
            return
        }

        components.queryItems = [URLQueryItem(name: "q", value: title),
                                 URLQueryItem(name: "fields", value: "title,first_publish_year,author_name,publisher")]

        guard let url = components.url else {
            completion(nil, nil)
            return
        }

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20.0
        let _ = URLSession(configuration: config).dataTask(with: url) { (data, response, error) in

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(JsonResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(jsonData.books, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}
