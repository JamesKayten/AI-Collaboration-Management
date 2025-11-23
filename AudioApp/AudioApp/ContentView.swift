//
//  ContentView.swift
//  AudioApp
//
//  Main application view
//

import SwiftUI

struct ContentView: View {
    @StateObject private var playerViewModel = PlayerViewModel()
    @StateObject private var libraryViewModel = LibraryViewModel()
    @State private var selectedTab = 0

    var body: some View {
        NavigationSplitView {
            // Sidebar
            List(selection: $selectedTab) {
                Section("Library") {
                    Label("All Tracks", systemImage: "music.note.list")
                        .tag(0)

                    Label("Artists", systemImage: "person.2")
                        .tag(1)

                    Label("Albums", systemImage: "square.stack")
                        .tag(2)
                }

                Section("Playlists") {
                    Label("Favorites", systemImage: "heart")
                        .tag(3)
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {}) {
                        Image(systemName: "sidebar.left")
                    }
                }
            }

        } detail: {
            VStack(spacing: 0) {
                // Main content area
                switch selectedTab {
                case 0:
                    LibraryView(
                        libraryViewModel: libraryViewModel,
                        playerViewModel: playerViewModel
                    )

                case 1:
                    ArtistsView(
                        libraryViewModel: libraryViewModel,
                        playerViewModel: playerViewModel
                    )

                case 2:
                    AlbumsView(
                        libraryViewModel: libraryViewModel,
                        playerViewModel: playerViewModel
                    )

                default:
                    Text("Coming soon...")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                Divider()

                // Player section
                VStack(spacing: 0) {
                    NowPlayingView(viewModel: playerViewModel)

                    Divider()

                    PlayerControlsView(viewModel: playerViewModel)
                }
                .background(Color(nsColor: .controlBackgroundColor).opacity(0.3))
            }
        }
        .task {
            // Load library on startup
            await libraryViewModel.loadLibrary()
            await playerViewModel.refreshState()
        }
        .alert("Error", isPresented: .constant(playerViewModel.errorMessage != nil || libraryViewModel.errorMessage != nil)) {
            Button("OK") {
                playerViewModel.errorMessage = nil
                libraryViewModel.errorMessage = nil
            }
        } message: {
            Text(playerViewModel.errorMessage ?? libraryViewModel.errorMessage ?? "Unknown error")
        }
    }
}

// Placeholder views for artists and albums
struct ArtistsView: View {
    @ObservedObject var libraryViewModel: LibraryViewModel
    @ObservedObject var playerViewModel: PlayerViewModel

    var body: some View {
        List(libraryViewModel.artists, id: \.self) { artist in
            Text(artist)
                .font(.headline)
        }
    }
}

struct AlbumsView: View {
    @ObservedObject var libraryViewModel: LibraryViewModel
    @ObservedObject var playerViewModel: PlayerViewModel

    var body: some View {
        List(libraryViewModel.albums, id: \.self) { album in
            Text(album)
                .font(.headline)
        }
    }
}

#Preview {
    ContentView()
}
