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

struct GenresListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var genres: [Genre]
    
    var body: some View {
        NavigationStack {
            List {
                if !genres.isEmpty {
                    ForEach(genres) { genre in
                        HStack {
                            Circle()
                                .fill(Color(hex: genre.colorHex))
                                .frame(width: 20, height: 20)
                            
                            VStack(alignment: .leading) {
                                Text(genre.name)
                                    .font(.headline)
                                if let bookCount = genre.books?.count, bookCount > 0 {
                                    Text("\(bookCount) book\(bookCount == 1 ? "" : "s")")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteGenres)
                } else {
                    ContentUnavailableView("No Genres", systemImage: "tag.slash")
                }
            }
            .navigationTitle("Genres")
        }
    }
    
    private func deleteGenres(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(genres[index])
        }
    }
}

#Preview(traits: .mockData) {
    GenresListView()
}
