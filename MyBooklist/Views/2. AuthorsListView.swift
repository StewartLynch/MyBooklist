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

import SwiftData
import SwiftUI

struct AuthorsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var authors: [Author]
    
    var body: some View {
        NavigationStack {
            List {
                if !authors.isEmpty {
                    ForEach(authors) { author in
                        VStack(alignment: .leading) {
                            Text(author.fullName)
                                .font(.headline)
                            if let bookCount = author.books?.count, bookCount > 0 {
                                Text("\(bookCount) book\(bookCount == 1 ? "" : "s")")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: deleteAuthors)
                } else {
                    ContentUnavailableView("No Authors", systemImage: "person.slash")
                }
            }
            .navigationTitle("Authors")
        }
    }
    
    private func deleteAuthors(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(authors[index])
        }
    }
}

#Preview(traits: .mockData) {
    AuthorsListView()
}
