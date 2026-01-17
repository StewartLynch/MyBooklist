//
//----------------------------------------------
// Original project: MyBooklist
//
// Follow me on Mastodon: https://iosdev.space/@StewartLynch
// Follow me on Threads: https://www.threads.net/@stewartlynch
// Follow me on Bluesky: https://bsky.app/profile/stewartlynch.bsky.social
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Email: slynch@createchsol.com
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2026 CreaTECH Solutions (Stewart Lynch). All rights reserved.


import Foundation
import SwiftData

@Model
final class Book {
    var title: String
    var author: Author?
    var genres: [Genre]
    
    init(title: String, author: Author? = nil, genres: [Genre] = []) {
        self.title = title
        self.author = author
        self.genres = genres
    }
}

@Model
final class Author {
    var firstName: String
    var lastName: String
    @Relationship(deleteRule: .nullify, inverse: \Book.author)
    var books: [Book]?
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

@Model
final class Genre {
    var name: String
    var colorHex: String
    @Relationship(deleteRule: .nullify, inverse: \Book.genres)
    var books: [Book]?
    
    init(name: String, colorHex: String) {
        self.name = name
        self.colorHex = colorHex
    }
}
