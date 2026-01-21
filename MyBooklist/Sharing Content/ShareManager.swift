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

@Observable
class ShareManager {
    static let shared = ShareManager()
    private init() {}
    static let fileExtension = "bkls"
    var sharedFileURL: URL? = nil
    
    func prepareShare(from books: [Book], with fileName: String) {
        var booksArray: [SharedJSON.ShareBook] = []
        var authorsDict: [String : SharedJSON.ShareAuthor] = [ : ]
        var genresDict: [String : SharedJSON.ShareGenre] = [ : ]
        
        for book in books {
            var authorId: String?
            var genreIds: [String] = []
            
            if let author = book.author {
                authorId = author.id
                if authorsDict[author.id] == nil {
                    let shareAuthor = SharedJSON.ShareAuthor(
                        id: author.id,
                        firstName: author.firstName,
                        lastName: author.lastName
                    )
                    authorsDict[author.id] = shareAuthor
                }
            }
            for genre in book.genres {
                genreIds.append(genre.id)
                if genresDict[genre.id] == nil {
                    let shareGenre = SharedJSON.ShareGenre(
                        id: genre.id,
                        name: genre.name,
                        colorHex: genre.colorHex
                    )
                    genresDict[genre.id] = shareGenre
                }
            }
            let shareBook = SharedJSON.ShareBook(
                id: book.id,
                title: book.title,
                authorId: authorId,
                genreIds: genreIds
            )
            booksArray.append(shareBook)
        }
        
        let authorsArray = Array(authorsDict.values)
        let genresArray = Array(genresDict.values)
        let sharedJSON = SharedJSON(
            books: booksArray,
            authors: authorsArray,
            genres: genresArray
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        do {
            let data = try encoder.encode(sharedJSON)
            let fileName = "\(fileName).\(Self.fileExtension)"
            let fileURL = URL.temporaryDirectory.appendingPathComponent(fileName)
            let fm = FileManager.default
            if fm.fileExists(atPath: fileURL.path()) {
                try fm.removeItem(at: fileURL)
            }
            try data.write(to: fileURL)
            sharedFileURL = fileURL
        } catch {
            print("Failed to encode or write share file", error)
        }
    }
    
    func handleIncomingBKLSFile(url: URL, modelContext: ModelContext) {
        let didAccess = url.startAccessingSecurityScopedResource()
        defer {
            if didAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let shareJSON = try decoder.decode(SharedJSON.self, from: data)
            importNew(shareJSON: shareJSON, modelContext: modelContext)
        } catch {
            print("Failed to import bkls file: \(error)")
        }
    }
    
    func importNew(shareJSON: SharedJSON, modelContext: ModelContext) {
        var bookLookup: [String : Book] = [ : ]
        var authorLookup: [String : Author] = [ : ]
        var genreLookup: [String : Genre] = [ : ]
        
        var shareBookLookup: [String : SharedJSON.ShareBook] = [ : ]
        var shareAuthorLookup: [String : SharedJSON.ShareAuthor] = [ : ]
        var shareGenreLookup: [String : SharedJSON.ShareGenre] = [ : ]
        
        do {
            shareJSON.books.forEach { shareBookLookup[$0.id] = $0}
            shareJSON.authors.forEach { shareAuthorLookup[$0.id] = $0}
            shareJSON.genres.forEach { shareGenreLookup[$0.id] = $0}
            
            let books = try modelContext.fetch(FetchDescriptor<Book>())
            let authors = try modelContext.fetch(FetchDescriptor<Author>())
            let genres = try modelContext.fetch(FetchDescriptor<Genre>())
            
            books.forEach { bookLookup[$0.id] = $0 }
            authors.forEach { authorLookup[$0.id] = $0 }
            genres.forEach { genreLookup[$0.id] = $0 }
            
            try shareJSON.books.forEach { shareBook in
                if bookLookup[shareBook.id] == nil {
                    let book = Book(title: shareBook.title)
                    modelContext.insert(book)
                    if let authorId = shareBook.authorId {
                        if let author = authorLookup[authorId] {
                            book.author = author
                        } else {
                            if let shareAuthor = shareAuthorLookup[authorId] {
                                let author = Author(firstName: shareAuthor.firstName, lastName: shareAuthor.lastName)
                                book.author = author
                                authorLookup[shareAuthor.id] = author
                            }
                        }
                    }
                    shareBook.genreIds.forEach { genreId in
                        if let genre = genreLookup[genreId] {
                            book.genres.append(genre)
                        } else {
                            if let shareGenre = shareGenreLookup[genreId] {
                                let genre = Genre(name: shareGenre.name, colorHex: shareGenre.colorHex)
                                book.genres.append(genre)
                                genreLookup[shareGenre.id] = genre
                            }
                        }
                    }
                }
                try modelContext.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
