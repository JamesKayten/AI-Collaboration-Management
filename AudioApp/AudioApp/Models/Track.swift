//
//  Track.swift
//  AudioApp
//
//  Music track model matching Python backend API
//

import Foundation

struct Track: Codable, Identifiable {
    let id: Int?
    let filePath: String
    let title: String?
    let artist: String?
    let album: String?
    let genre: String?
    let year: Int?
    let duration: Double?
    let trackNumber: Int?
    let bitrate: Int?
    let sampleRate: Int?
    let fileSize: Int?
    let dateAdded: String?
    let lastPlayed: String?
    let playCount: Int
    let favorite: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case filePath = "file_path"
        case title
        case artist
        case album
        case genre
        case year
        case duration
        case trackNumber = "track_number"
        case bitrate
        case sampleRate = "sample_rate"
        case fileSize = "file_size"
        case dateAdded = "date_added"
        case lastPlayed = "last_played"
        case playCount = "play_count"
        case favorite
    }

    var displayTitle: String {
        title ?? "Unknown Track"
    }

    var displayArtist: String {
        artist ?? "Unknown Artist"
    }

    var displayAlbum: String {
        album ?? "Unknown Album"
    }

    var formattedDuration: String {
        guard let duration = duration else { return "--:--" }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct PlaybackState: Codable {
    let isPlaying: Bool
    let isPaused: Bool
    let currentTrack: Track?
    let position: Double
    let volume: Double
    let isShuffled: Bool
    let repeatMode: String
    let queueLength: Int
    let queuePosition: Int

    enum CodingKeys: String, CodingKey {
        case isPlaying = "is_playing"
        case isPaused = "is_paused"
        case currentTrack = "current_track"
        case position
        case volume
        case isShuffled = "is_shuffled"
        case repeatMode = "repeat_mode"
        case queueLength = "queue_length"
        case queuePosition = "queue_position"
    }
}

struct LibraryStats: Codable {
    let totalTracks: Int
    let totalDurationSeconds: Double
    let totalSizeBytes: Int
    let uniqueArtists: Int
    let uniqueAlbums: Int

    enum CodingKeys: String, CodingKey {
        case totalTracks = "total_tracks"
        case totalDurationSeconds = "total_duration_seconds"
        case totalSizeBytes = "total_size_bytes"
        case uniqueArtists = "unique_artists"
        case uniqueAlbums = "unique_albums"
    }

    var formattedDuration: String {
        let hours = Int(totalDurationSeconds) / 3600
        let minutes = (Int(totalDurationSeconds) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }

    var formattedSize: String {
        let gb = Double(totalSizeBytes) / 1_073_741_824
        return String(format: "%.2f GB", gb)
    }
}
