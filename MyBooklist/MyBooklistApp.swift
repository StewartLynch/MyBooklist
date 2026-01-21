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

@main
struct MyBooklistApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Book.self)
        } catch {
            fatalError("Failed to create modelContainer: \(error)")
        }
    }
    var body: some Scene {
        WindowGroup {
            StartTab()
                .onAppear {
                    print(URL.applicationSupportDirectory.path())
                }
                .onOpenURL { url in
                    if url.pathExtension == "bkls" {
                        ShareManager.shared.handleIncomingBKLSFile(url: url, modelContext: container.mainContext)
                    }
                }
        }
        .modelContainer(container)
    }
}
