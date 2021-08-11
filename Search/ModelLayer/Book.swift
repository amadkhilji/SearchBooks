//
//  Book.swift
//  Search
//
//  Created by Amaduddin Ayub on 8/8/21.
//

import Foundation

/* sample book data

 {
 "start": 0,
 "num_found": 629,
 "docs": [
 {...},
 {...},
 ...
 {...}]
 }

 where each doc

 {
 "cover_i": 258027,
 "has_fulltext": true,
 "edition_count": 120,
 "title": "The Lord of the Rings",
 "author_name": [
 "J. R. R. Tolkien"
 ],
 "first_publish_year": 1954,
 "key": "OL27448W",
 "ia": [
 "returnofking00tolk_1",
 "lordofrings00tolk_1",
 "lordofrings00tolk_0",
 ],
 "author_key": [
 "OL26320A"
 ],
 "public_scan_b": true
 }

 */

enum BookStatus: String {
    case onSale = "on_sale", soldOut = "sold_out"
}

struct MyObj: Decodable {
    enum MyKeys: String, CodingKey {
        case now
    }

    var now: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyKeys.self)
        now = try container.decode(String.self, forKey: .now)
    }

}

class Book: Decodable {

    enum DataKeys: String, CodingKey {
        case title, firstPublishYear = "first_publish_year", authors = "author_name", publishers = "publisher"
    }

    var title: String?
    var firstPublishYear: Int?
    var authors: [String]?
    var publishers: [String]?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataKeys.self)
        title = try? container.decode(String.self, forKey: .title)
        firstPublishYear = try? container.decode(Int.self, forKey: .firstPublishYear)
        authors = try? container.decode([String].self, forKey: .authors)
        publishers = try? container.decode([String].self, forKey: .publishers)
    }

    var description: String {// This is just for debugging.
        return "title: \(title ?? "nil"), first_publish_year: \(firstPublishYear ?? -1), authors: \(authors ?? []), publishers: \(publishers ?? [])"
    }
}

struct JsonResponse: Decodable {

    enum RootKeys: String, CodingKey {
        case numberOfBooksFound = "numFound", books = "docs"
    }

    let numberOfBooksFound: Int
    let books: [Book]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        numberOfBooksFound = try container.decode(Int.self, forKey: .numberOfBooksFound)
        books = try container.decode([Book].self, forKey: .books)
    }
}
