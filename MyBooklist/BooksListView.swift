struct BooksListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]
    @Query private var authors: [Author]
    @Query private var genres: [Genre]
    
    @State private var searchText = ""
    @State private var filterAuthor: Author?
    @State private var filterGenre: Genre?
    
    var filteredBooks: [Book] {
        books.filter { book in
            let matchesSearch = searchText.isEmpty || 
                book.title.localizedCaseInsensitiveContains(searchText) ||
                (book.author?.fullName.localizedCaseInsensitiveContains(searchText) ?? false)
            
            let matchesAuthor = filterAuthor == nil || book.author == filterAuthor
            let matchesGenre = filterGenre == nil || book.genres.contains(filterGenre!)
            
            return matchesSearch && matchesAuthor && matchesGenre
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if !filteredBooks.isEmpty {
                    ForEach(filteredBooks) { book in
                        BookRowView(book: book)
                    }
                    .onDelete(perform: deleteBooks)
                } else {
                    ContentUnavailableView("No Books", systemImage: "book.slash")
                }
            }
            .searchable(text: $searchText, prompt: "Search by title or author")
            .navigationTitle("Books")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Seed Data", systemImage: "plus.circle.fill") {
                            seedMockData()
                        }
                        
                        Divider()
                        
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
    
    private func seedMockData() {
        let mockData = MockData.createMockData(context: modelContext)
        try? modelContext.save()
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