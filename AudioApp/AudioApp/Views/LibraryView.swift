//
//  LibraryView.swift
//  AudioApp
//
//  Music library view with track listing
//

import SwiftUI
import UniformTypeIdentifiers

struct LibraryView: View {
    @ObservedObject var libraryViewModel: LibraryViewModel
    @ObservedObject var playerViewModel: PlayerViewModel
    @State private var selectedTrack: Track?
    @State private var showingImportDialog = false

    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            HStack {
                // Import button
                Button(action: {
                    showingImportDialog = true
                }) {
                    Label("Import", systemImage: "plus.circle")
                }

                Spacer()

                // Search field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)

                    TextField("Search tracks...", text: $libraryViewModel.searchQuery)
                        .textFieldStyle(.plain)
                        .frame(width: 200)
                }
                .padding(6)
                .background(Color(nsColor: .controlBackgroundColor))
                .cornerRadius(6)

                // Refresh button
                Button(action: {
                    Task {
                        await libraryViewModel.refreshLibrary()
                    }
                }) {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
                .disabled(libraryViewModel.isLoading)
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))

            // Stats bar
            if let stats = libraryViewModel.stats {
                HStack(spacing: 20) {
                    StatView(label: "Tracks", value: "\(stats.totalTracks)")
                    Divider().frame(height: 20)
                    StatView(label: "Artists", value: "\(stats.uniqueArtists)")
                    Divider().frame(height: 20)
                    StatView(label: "Albums", value: "\(stats.uniqueAlbums)")
                    Divider().frame(height: 20)
                    StatView(label: "Duration", value: stats.formattedDuration)
                    Divider().frame(height: 20)
                    StatView(label: "Size", value: stats.formattedSize)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
            }

            Divider()

            // Track list
            if libraryViewModel.isLoading {
                ProgressView("Loading library...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if libraryViewModel.filteredTracks.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "music.note.list")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)

                    Text("No tracks in library")
                        .font(.title3)
                        .foregroundColor(.secondary)

                    Button("Import Music") {
                        showingImportDialog = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(libraryViewModel.filteredTracks) { track in
                    TrackRow(track: track)
                        .onTapGesture(count: 2) {
                            playTrack(track)
                        }
                        .contextMenu {
                            Button("Play") {
                                playTrack(track)
                            }

                            Button("Play Next") {
                                // TODO: Implement
                            }

                            Divider()

                            Button("Show in Finder") {
                                if let url = URL(string: "file://\(track.filePath)") {
                                    NSWorkspace.shared.selectFile(track.filePath, inFileViewerRootedAtPath: "")
                                }
                            }

                            Button("Delete from Library", role: .destructive) {
                                Task {
                                    if let id = track.id {
                                        await libraryViewModel.deleteTrack(id: id)
                                    }
                                }
                            }
                        }
                }
                .listStyle(.inset)
            }
        }
        .fileImporter(
            isPresented: $showingImportDialog,
            allowedContentTypes: [.audio, .folder],
            allowsMultipleSelection: false
        ) { result in
            handleImport(result: result)
        }
    }

    private func playTrack(_ track: Track) {
        guard let trackId = track.id else { return }

        Task {
            // Set queue to all filtered tracks
            let trackIds = libraryViewModel.filteredTracks.compactMap { $0.id }
            let startIndex = libraryViewModel.filteredTracks.firstIndex(where: { $0.id == trackId }) ?? 0

            await playerViewModel.setQueue(trackIds: trackIds, startIndex: startIndex)
            await playerViewModel.play(trackId: trackId)
        }
    }

    private func handleImport(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }

            Task {
                var isDirectory: ObjCBool = false
                FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)

                if isDirectory.boolValue {
                    await libraryViewModel.importDirectory(path: url.path)
                } else {
                    await libraryViewModel.importFile(path: url.path)
                }
            }

        case .failure(let error):
            print("Import error: \(error)")
        }
    }
}

struct TrackRow: View {
    let track: Track

    var body: some View {
        HStack {
            // Track number or icon
            if let trackNum = track.trackNumber {
                Text("\(trackNum)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 30, alignment: .trailing)
            } else {
                Image(systemName: "music.note")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 30, alignment: .center)
            }

            // Track info
            VStack(alignment: .leading, spacing: 2) {
                Text(track.displayTitle)
                    .font(.body)
                    .lineLimit(1)

                Text(track.displayArtist)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            // Album
            Text(track.displayAlbum)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 150, alignment: .leading)
                .lineLimit(1)

            // Duration
            Text(track.formattedDuration)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 50, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }
}

struct StatView: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
