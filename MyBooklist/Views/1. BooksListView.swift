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

struct BooksListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]
    @Query private var authors: [Author]
    @Query private var genres: [Genre]
    
    @State private var filterAuthor: Author?
    @State private var filterGenre: Genre?
    
    var filteredBooks: [Book] {
        books.filter { book in
            let matchesAuthor = filterAuthor == nil || book.author == filterAuthor
            let matchesGenre = filterGenre == nil || book.genres.contains(filterGenre!)
            
            return matchesAuthor && matchesGenre
        }
    }
    
    var hasActiveFilters: Bool {
        filterAuthor != nil || filterGenre != nil
    }
    
    var body: some View {
        NavigationStack {
            List {
                if hasActiveFilters {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            if let author = filterAuthor {
                                HStack {
                                    Text("Author:")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    Text(author.fullName)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Button {
                                        filterAuthor = nil
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.secondary)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            
                            if let genre = filterGenre {
                                HStack {
                                    Text("Genre:")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    HStack(spacing: 4) {
                                        Circle()
                                            .fill(Color(hex: genre.colorHex))
                                            .frame(width: 12, height: 12)
                                        Text(genre.name)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                    Spacer()
                                    Button {
                                        filterGenre = nil
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.secondary)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    } header: {
                        Text("Active Filters")
                    }
                }
                
                Section {
                    if !filteredBooks.isEmpty {
                        ForEach(filteredBooks) { book in
                            BookRowView(book: book)
                        }
                        .onDelete(perform: deleteBooks)
                    } else {
#if DEBUG && targetEnvironment(simulator)
                        if !ProcessInfo.processInfo.isRunningForPreviews {
                            ContentUnavailableView {
                                Image(systemName: "book.badge.plus")
                            } description: {
                                Text("There are no books")
                            } actions: {
                                Button("Seed Data") {
                                    MockContent.seedDatabase(modelContext: modelContext)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
#else
                        ContentUnavailableView("No Books", systemImage: "book.badge.plus")
#endif
                    }   
                }
            }
            .navigationTitle("Books")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Menu("Filter by Author") {
                            Button("All Authors") {
                                filterAuthor = nil
                            }
                            ForEach(authors) { author in
                                Button(author.fullName) {
                                    filterAuthor = author
                                }
                            }
                        }
                        
                        Menu("Filter by Genre") {
                            Button("All Genres") {
                                filterGenre = nil
                            }
                            ForEach(genres) { genre in
                                Button(genre.name) {
                                    filterGenre = genre
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
    
    private func deleteBooks(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredBooks[index])
        }
    }

}

struct BookRowView: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(book.title)
                .font(.headline)
            
            if let author = book.author {
                Text(author.fullName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            if !book.genres.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(book.genres) { genre in
                            Text(genre.name)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: genre.colorHex).opacity(0.3))
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}


#Preview(traits: .mockData) {
    BooksListView()
}
