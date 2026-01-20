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

struct SharedJSON: Codable {
    
    struct ShareAuthor: Codable {
        let id: String
        let firstName: String
        let lastName: String
    }
    
    struct ShareGenre: Codable {
        let id: String
        let name: String
        let colorHex: String
    }
    
    struct ShareBook: Codable {
        let id: String
        let title: String
        let authorId: String?
        let genreIds: [String]
    }
    
    let books: [ShareBook]
    let authors: [ShareAuthor]
    let genres: [ShareGenre]
}
