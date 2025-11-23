//
//  LibraryViewModel.swift
//  AudioApp
//
//  ViewModel for managing music library
//

import Foundation

@MainActor
class LibraryViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    @Published var filteredTracks: [Track] = []
    @Published var artists: [String] = []
    @Published var albums: [String] = []
    @Published var stats: LibraryStats?
    @Published var searchQuery = "" {
        didSet {
            filterTracks()
        }
    }
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let api = AudioAppAPI.shared

    // MARK: - Library Loading

    func loadLibrary() async {
        isLoading = true
        defer { isLoading = false }

        do {
            async let tracksTask = api.getAllTracks()
            async let artistsTask = api.getArtists()
            async let albumsTask = api.getAlbums()
            async let statsTask = api.getLibraryStats()

            tracks = try await tracksTask
            artists = try await artistsTask
            albums = try await albumsTask
            stats = try await statsTask

            filteredTracks = tracks
            errorMessage = nil

        } catch {
            handleError(error)
        }
    }

    func refreshLibrary() async {
        await loadLibrary()
    }

    // MARK: - Search & Filter

    private func filterTracks() {
        if searchQuery.isEmpty {
            filteredTracks = tracks
        } else {
            filteredTracks = tracks.filter { track in
                track.displayTitle.localizedCaseInsensitiveContains(searchQuery) ||
                track.displayArtist.localizedCaseInsensitiveContains(searchQuery) ||
                track.displayAlbum.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }

    func search(query: String) async {
        guard !query.isEmpty else {
            filteredTracks = tracks
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let results = try await api.searchTracks(query: query)
            filteredTracks = results
        } catch {
            handleError(error)
        }
    }

    // MARK: - Import

    func importFile(path: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await api.importFile(path: path)
            await loadLibrary()
        } catch {
            handleError(error)
        }
    }

    func importDirectory(path: String, recursive: Bool = true) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await api.importDirectory(path: path, recursive: recursive)
            print("Import result: \(result)")
            await loadLibrary()
        } catch {
            handleError(error)
        }
    }

    // MARK: - Track Management

    func deleteTrack(id: Int) async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await api.deleteTrack(id: id)
            await loadLibrary()
        } catch {
            handleError(error)
        }
    }

    func getTracksByArtist(_ artist: String) async -> [Track] {
        do {
            return try await api.getTracksByArtist(artist)
        } catch {
            handleError(error)
            return []
        }
    }

    func getTracksByAlbum(_ album: String) async -> [Track] {
        do {
            return try await api.getTracksByAlbum(album)
        } catch {
            handleError(error)
            return []
        }
    }

    func cleanupMissingFiles() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await api.cleanupLibrary()
            print("Cleanup result: \(result)")
            await loadLibrary()
        } catch {
            handleError(error)
        }
    }

    // MARK: - Error Handling

    private func handleError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .invalidURL:
                errorMessage = "Invalid API URL"
            case .networkError(let err):
                errorMessage = "Network error: \(err.localizedDescription)"
            case .decodingError(let err):
                errorMessage = "Data error: \(err.localizedDescription)"
            case .serverError(let msg):
                errorMessage = "Server error: \(msg)"
            case .invalidResponse:
                errorMessage = "Invalid server response"
            }
        } else {
            errorMessage = error.localizedDescription
        }
    }
}
