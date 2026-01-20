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
}
