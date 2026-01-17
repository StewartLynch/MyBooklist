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