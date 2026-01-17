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
        let container = try ModelContainer(for: Book.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        // Create Authors
        MockContent.authors.forEach { container.mainContext.insert($0) }
        
        // Create Genres
        MockContent.genres.forEach { container.mainContext.insert($0) }
        
        // Create Books
        MockContent.books.forEach { container.mainContext.insert($0) }
        return container
    }
}


extension PreviewTrait where T == Preview.ViewTraits {
    static var mockData: Self = .modifier(MockSwiftDataTrait())
}


enum MockContent {
    static let authors = [
        Author(firstName: "Jane", lastName: "Austen"),
        Author(firstName: "George", lastName: "Orwell"),
        Author(firstName: "J.K.", lastName: "Rowling"),
        Author(firstName: "F. Scott", lastName: "Fitzgerald"),
        Author(firstName: "Harper", lastName: "Lee"),
        Author(firstName: "J.R.R.", lastName: "Tolkien"),
        Author(firstName: "Agatha", lastName: "Christie"),
        Author(firstName: "Isaac", lastName: "Asimov"),
        Author(firstName: "Margaret", lastName: "Atwood"),
        Author(firstName: "Gabriel García", lastName: "Márquez")
    ]
    
    static let genres = [
        Genre(name: "Fiction", colorHex: "#3498db"),
        Genre(name: "Classic", colorHex: "#9b59b6"),
        Genre(name: "Dystopian", colorHex: "#e74c3c"),
        Genre(name: "Fantasy", colorHex: "#2ecc71"),
        Genre(name: "Mystery", colorHex: "#f39c12"),
        Genre(name: "Science Fiction", colorHex: "#1abc9c"),
        Genre(name: "Romance", colorHex: "#e91e63"),
        Genre(name: "Adventure", colorHex: "#ff9800")
    ]
    
    static let books = [
        Book(title: "Pride and Prejudice", author: authors[0], genres: [genres[0], genres[1], genres[6]]),
        Book(title: "1984", author: authors[1], genres: [genres[0], genres[2], genres[5]]),
        Book(title: "Harry Potter and the Philosopher's Stone", author: authors[2], genres: [genres[3], genres[7]]),
        Book(title: "The Great Gatsby", author: authors[3], genres: [genres[0], genres[1]]),
        Book(title: "To Kill a Mockingbird", author: authors[4], genres: [genres[0], genres[1]]),
        Book(title: "The Hobbit", author: authors[5], genres: [genres[3], genres[7]]),
        Book(title: "Murder on the Orient Express", author: authors[6], genres: [genres[4], genres[0]]),
        Book(title: "Foundation", author: authors[7], genres: [genres[5], genres[0]]),
        Book(title: "The Handmaid's Tale", author: authors[8], genres: [genres[2], genres[5], genres[0]]),
        Book(title: "One Hundred Years of Solitude", author: authors[9], genres: [genres[0], genres[1]]),
        Book(title: "Animal Farm", author: authors[1], genres: [genres[0], genres[2], genres[1]]),
        Book(title: "Harry Potter and the Chamber of Secrets", author: authors[2], genres: [genres[3], genres[7]]),
        Book(title: "The Lord of the Rings", author: authors[5], genres: [genres[3], genres[7], genres[1]]),
        Book(title: "And Then There Were None", author: authors[6], genres: [genres[4], genres[0]]),
        Book(title: "I, Robot", author: authors[7], genres: [genres[5], genres[0]]),
        Book(title: "Sense and Sensibility", author: authors[0], genres: [genres[0], genres[1], genres[6]]),
        Book(title: "Oryx and Crake", author: authors[8], genres: [genres[5], genres[2], genres[0]]),
        Book(title: "Love in the Time of Cholera", author: authors[9], genres: [genres[0], genres[6]]),
        Book(title: "The Fellowship of the Ring", author: authors[5], genres: [genres[3], genres[7]]),
        Book(title: "Death on the Nile", author: authors[6], genres: [genres[4], genres[0]])
    ]
    
    static func seedDatabase(modelContext: ModelContext) {
        // Clear database
        do {
            try modelContext.delete(model: Author.self)
            try modelContext.delete(model: Genre.self)
            try modelContext.delete(model: Book.self)
            try modelContext.save()
        } catch {
            print("Failed to clear store: \(error)")
        }
        // Create Authors
        MockContent.authors.forEach { modelContext.insert($0) }
        
        // Create Genres
        MockContent.genres.forEach { modelContext.insert($0) }
        
        // Create Books
        MockContent.books.forEach { modelContext.insert($0) }
        
        // Save
        try? modelContext.save()
        print("Database seeded with mock data successfully!")
    }
}
