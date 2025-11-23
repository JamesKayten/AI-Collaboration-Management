//
//  PlayerViewModel.swift
//  AudioApp
//
//  ViewModel for managing player state and controls
//

import Foundation
import Combine

@MainActor
class PlayerViewModel: ObservableObject {
    @Published var playbackState: PlaybackState?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var updateTimer: Timer?
    private let api = AudioAppAPI.shared

    init() {
        startPeriodicUpdate()
    }

    deinit {
        stopPeriodicUpdate()
    }

    // MARK: - State Management

    func refreshState() async {
        do {
            playbackState = try await api.getPlayerState()
            errorMessage = nil
        } catch {
            handleError(error)
        }
    }

    private func startPeriodicUpdate() {
        // Update playback state every second
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.refreshState()
            }
        }
    }

    private func stopPeriodicUpdate() {
        updateTimer?.invalidate()
        updateTimer = nil
    }

    // MARK: - Playback Controls

    func play(trackId: Int? = nil) async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await api.play(trackId: trackId)
            await refreshState()
        } catch {
            handleError(error)
        }
    }

    func pause() async {
        do {
            try await api.pause()
            await refreshState()
        } catch {
            handleError(error)
        }
    }

    func stop() async {
        do {
            try await api.stop()
            await refreshState()
        } catch {
            handleError(error)
        }
    }

    func next() async {
        do {
            try await api.next()
            await refreshState()
        } catch {
            handleError(error)
        }
    }

    func previous() async {
        do {
            try await api.previous()
            await refreshState()
        } catch {
            handleError(error)
        }
    }

    func seek(to position: Double) async {
        do {
            try await api.seek(position: position)
            await refreshState()
        } catch {
            handleError(error)
        }
    }

    func setVolume(_ volume: Double) async {
        do {
            try await api.setVolume(volume)
            await refreshState()
        } catch {
            handleError(error)
        }
    }

    func togglePlayPause() async {
        guard let state = playbackState else {
            return
        }

        if state.isPlaying && !state.isPaused {
            await pause()
        } else {
            await play()
        }
    }

    // MARK: - Queue Management

    func setQueue(trackIds: [Int], startIndex: Int = 0) async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await api.setQueue(trackIds: trackIds, startIndex: startIndex)
            await refreshState()
        } catch {
            handleError(error)
        }
    }

    func setShuffle(_ enabled: Bool) async {
        do {
            try await api.setShuffle(enabled)
            await refreshState()
        } catch {
            handleError(error)
        }
    }

    func setRepeat(_ mode: String) async {
        do {
            try await api.setRepeat(mode)
            await refreshState()
        } catch {
            handleError(error)
        }
    }

    func toggleShuffle() async {
        guard let state = playbackState else { return }
        await setShuffle(!state.isShuffled)
    }

    func cycleRepeatMode() async {
        guard let state = playbackState else { return }

        let nextMode: String
        switch state.repeatMode {
        case "none":
            nextMode = "all"
        case "all":
            nextMode = "one"
        default:
            nextMode = "none"
        }

        await setRepeat(nextMode)
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
