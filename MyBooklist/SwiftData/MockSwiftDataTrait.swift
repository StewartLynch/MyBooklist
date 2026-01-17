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



import SwiftUI
import SwiftData

struct MockSwiftDataTrait: PreviewModifier {
    func body(content: Content, context: ModelContainer) -> some View {
        content
            .modelContainer(context)
    }
    
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(for: User.self, Book.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let user = MockDataContent.user
        let genres = MockDataContent.genres
        let books = MockDataContent.books
        container.mainContext.insert(user)
        
        for genre in genres {
            container.mainContext.insert(genre)
        }
        
        for book in books {
            container.mainContext.insert(book)
        }
        return container
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    static var mockData: Self = .modifier(MockSwiftDataTrait())
}
