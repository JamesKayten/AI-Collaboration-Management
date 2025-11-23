//
//  PlayerControlsView.swift
//  AudioApp
//
//  Playback controls view
//

import SwiftUI

struct PlayerControlsView: View {
    @ObservedObject var viewModel: PlayerViewModel

    var body: some View {
        VStack(spacing: 16) {
            // Progress bar
            if let state = viewModel.playbackState,
               let track = state.currentTrack,
               let duration = track.duration {

                VStack(spacing: 4) {
                    Slider(
                        value: Binding(
                            get: { state.position },
                            set: { newValue in
                                Task {
                                    await viewModel.seek(to: newValue)
                                }
                            }
                        ),
                        in: 0...duration
                    )

                    HStack {
                        Text(formatTime(state.position))
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Spacer()

                        Text(track.formattedDuration)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
            }

            // Playback controls
            HStack(spacing: 20) {
                // Shuffle button
                Button(action: {
                    Task {
                        await viewModel.toggleShuffle()
                    }
                }) {
                    Image(systemName: "shuffle")
                        .font(.title3)
                        .foregroundColor(viewModel.playbackState?.isShuffled == true ? .accentColor : .secondary)
                }
                .buttonStyle(.plain)

                // Previous button
                Button(action: {
                    Task {
                        await viewModel.previous()
                    }
                }) {
                    Image(systemName: "backward.fill")
                        .font(.title2)
                }
                .buttonStyle(.plain)

                // Play/Pause button
                Button(action: {
                    Task {
                        await viewModel.togglePlayPause()
                    }
                }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 44))
                }
                .buttonStyle(.plain)
                .disabled(viewModel.playbackState?.currentTrack == nil)

                // Next button
                Button(action: {
                    Task {
                        await viewModel.next()
                    }
                }) {
                    Image(systemName: "forward.fill")
                        .font(.title2)
                }
                .buttonStyle(.plain)

                // Repeat button
                Button(action: {
                    Task {
                        await viewModel.cycleRepeatMode()
                    }
                }) {
                    Image(systemName: repeatIcon)
                        .font(.title3)
                        .foregroundColor(repeatColor)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)

            // Volume control
            HStack {
                Image(systemName: "speaker.fill")
                    .foregroundColor(.secondary)

                Slider(
                    value: Binding(
                        get: { viewModel.playbackState?.volume ?? 0.7 },
                        set: { newValue in
                            Task {
                                await viewModel.setVolume(newValue)
                            }
                        }
                    ),
                    in: 0...1
                )
                .frame(maxWidth: 150)

                Image(systemName: "speaker.wave.3.fill")
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
        }
        .padding()
    }

    private var isPlaying: Bool {
        guard let state = viewModel.playbackState else { return false }
        return state.isPlaying && !state.isPaused
    }

    private var repeatIcon: String {
        guard let mode = viewModel.playbackState?.repeatMode else { return "repeat" }
        switch mode {
        case "one":
            return "repeat.1"
        default:
            return "repeat"
        }
    }

    private var repeatColor: Color {
        guard let mode = viewModel.playbackState?.repeatMode else { return .secondary }
        return mode == "none" ? .secondary : .accentColor
    }

    private func formatTime(_ seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, secs)
    }
}
