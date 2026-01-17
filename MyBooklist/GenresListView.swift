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