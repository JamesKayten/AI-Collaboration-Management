//
//  AudioAppAPI.swift
//  AudioApp
//
//  API client for communicating with Python backend
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(String)
    case invalidResponse
}

class AudioAppAPI {
    static let shared = AudioAppAPI()

    private let baseURL = "http://127.0.0.1:8765/api/v1"
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        self.session = URLSession(configuration: config)
    }

    // MARK: - Generic Request Method

    private func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw APIError.serverError(errorMsg)
            }

            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)

        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }

    // MARK: - Player Endpoints

    func getPlayerState() async throws -> PlaybackState {
        return try await request(endpoint: "/player/state")
    }

    func play(trackId: Int? = nil, position: Double = 0.0) async throws {
        struct PlayRequest: Codable {
            let track_id: Int?
            let position: Double
        }

        let _: [String: String] = try await request(
            endpoint: "/player/play",
            method: "POST",
            body: PlayRequest(track_id: trackId, position: position)
        )
    }

    func pause() async throws {
        let _: [String: String] = try await request(endpoint: "/player/pause", method: "POST")
    }

    func stop() async throws {
        let _: [String: String] = try await request(endpoint: "/player/stop", method: "POST")
    }

    func next() async throws {
        let _: [String: String] = try await request(endpoint: "/player/next", method: "POST")
    }

    func previous() async throws {
        let _: [String: String] = try await request(endpoint: "/player/previous", method: "POST")
    }

    func seek(position: Double) async throws {
        struct SeekRequest: Codable {
            let position: Double
        }

        let _: [String: String] = try await request(
            endpoint: "/player/seek",
            method: "POST",
            body: SeekRequest(position: position)
        )
    }

    func setVolume(_ volume: Double) async throws {
        struct VolumeRequest: Codable {
            let volume: Double
        }

        let _: [String: Any] = try await request(
            endpoint: "/player/volume",
            method: "POST",
            body: VolumeRequest(volume: volume)
        )
    }

    func setQueue(trackIds: [Int], startIndex: Int = 0) async throws {
        struct QueueRequest: Codable {
            let track_ids: [Int]
            let start_index: Int
        }

        let _: [String: Any] = try await request(
            endpoint: "/player/queue",
            method: "POST",
            body: QueueRequest(track_ids: trackIds, start_index: startIndex)
        )
    }

    func setShuffle(_ enabled: Bool) async throws {
        struct ShuffleRequest: Codable {
            let enabled: Bool
        }

        let _: [String: Any] = try await request(
            endpoint: "/player/shuffle",
            method: "POST",
            body: ShuffleRequest(enabled: enabled)
        )
    }

    func setRepeat(_ mode: String) async throws {
        struct RepeatRequest: Codable {
            let mode: String
        }

        let _: [String: Any] = try await request(
            endpoint: "/player/repeat",
            method: "POST",
            body: RepeatRequest(mode: mode)
        )
    }

    // MARK: - Library Endpoints

    func getAllTracks(limit: Int? = nil, offset: Int = 0) async throws -> [Track] {
        var endpoint = "/library/tracks?offset=\(offset)"
        if let limit = limit {
            endpoint += "&limit=\(limit)"
        }
        return try await request(endpoint: endpoint)
    }

    func getTrack(id: Int) async throws -> Track {
        return try await request(endpoint: "/library/tracks/\(id)")
    }

    func searchTracks(query: String) async throws -> [Track] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        return try await request(endpoint: "/library/search?q=\(encodedQuery)")
    }

    func importFile(path: String) async throws {
        struct ImportRequest: Codable {
            let file_path: String
        }

        let _: [String: Any] = try await request(
            endpoint: "/library/import/file",
            method: "POST",
            body: ImportRequest(file_path: path)
        )
    }

    func importDirectory(path: String, recursive: Bool = true) async throws -> [String: Any] {
        struct ImportRequest: Codable {
            let directory_path: String
            let recursive: Bool
        }

        return try await request(
            endpoint: "/library/import/directory",
            method: "POST",
            body: ImportRequest(directory_path: path, recursive: recursive)
        )
    }

    func getLibraryStats() async throws -> LibraryStats {
        return try await request(endpoint: "/library/stats")
    }

    func getArtists() async throws -> [String] {
        return try await request(endpoint: "/library/artists")
    }

    func getAlbums(artist: String? = nil) async throws -> [String] {
        if let artist = artist {
            let encoded = artist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? artist
            return try await request(endpoint: "/library/albums?artist=\(encoded)")
        }
        return try await request(endpoint: "/library/albums")
    }

    func getTracksByArtist(_ artist: String) async throws -> [Track] {
        let encoded = artist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? artist
        return try await request(endpoint: "/library/artists/\(encoded)/tracks")
    }

    func getTracksByAlbum(_ album: String) async throws -> [Track] {
        let encoded = album.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? album
        return try await request(endpoint: "/library/albums/\(encoded)/tracks")
    }

    func deleteTrack(id: Int) async throws {
        let _: [String: String] = try await request(endpoint: "/library/tracks/\(id)", method: "DELETE")
    }

    func cleanupLibrary() async throws -> [String: Any] {
        return try await request(endpoint: "/library/cleanup", method: "POST")
    }

    // MARK: - Health Check

    func healthCheck() async throws -> [String: String] {
        return try await request(endpoint: "/health")
    }
}

// Extension to handle dictionary responses
extension Dictionary: @retroactive Decodable where Key == String, Value == Any {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dict = try container.decode([String: AnyCodable].self)
        self = dict.mapValues { $0.value }
    }
}

struct AnyCodable: Codable {
    let value: Any

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map { $0.value }
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            value = dict.mapValues { $0.value }
        } else {
            value = NSNull()
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        default:
            try container.encodeNil()
        }
    }
}
