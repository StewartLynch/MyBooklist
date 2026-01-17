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

struct StartTab: View {
    var body: some View {
        TabView {
            Tab("Books", systemImage: "book") {
                BooksListView()
            }
            Tab("Authors", systemImage: "person") {
               AuthorsListView()
            }
            Tab("Genres", systemImage: "tag") {
               GenresListView()
            }
        }
    }
}

#Preview(traits: .mockData) {
    StartTab()
}
