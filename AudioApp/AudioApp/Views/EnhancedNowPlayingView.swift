//
//  EnhancedNowPlayingView.swift
//  AudioApp
//
//  Enhanced now playing view with artwork and animations
//

import SwiftUI

struct EnhancedNowPlayingView: View {
    @ObservedObject var viewModel: PlayerViewModel
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 20) {
            if let track = viewModel.playbackState?.currentTrack {
                // Album artwork with animation
                ZStack {
                    // Background glow effect
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.3),
                                    Color.purple.opacity(0.3),
                                    Color.pink.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 220, height: 220)
                        .blur(radius: 20)
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .animation(
                            .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                            value: isAnimating
                        )

                    // Artwork or placeholder
                    ArtworkView(trackId: track.id)
                        .frame(width: 200, height: 200)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)

                    // Playing indicator
                    if viewModel.playbackState?.isPlaying == true && viewModel.playbackState?.isPaused == false {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                PlayingIndicator()
                                    .padding(8)
                            }
                        }
                    }
                }
                .frame(width: 220, height: 220)
                .onAppear {
                    isAnimating = true
                }

                // Track information with styling
                VStack(spacing: 8) {
                    Text(track.displayTitle)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.primary, .secondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text(track.displayArtist)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(1)

                    if let album = track.album {
                        HStack(spacing: 4) {
                            Image(systemName: "music.note.list")
                                .font(.caption)
                            Text(album)
                                .font(.system(size: 14))
                        }
                        .foregroundColor(.secondary.opacity(0.8))
                        .lineLimit(1)
                    }

                    // Additional metadata
                    HStack(spacing: 12) {
                        if let year = track.year {
                            Label("\(year)", systemImage: "calendar")
                                .font(.caption)
                        }

                        if let genre = track.genre {
                            Label(genre, systemImage: "tag")
                                .font(.caption)
                        }
                    }
                    .foregroundColor(.secondary.opacity(0.6))
                }
                .frame(maxWidth: 350)
                .padding(.horizontal)

            } else {
                // Empty state with better design
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(Color.secondary.opacity(0.1))
                            .frame(width: 180, height: 180)

                        Image(systemName: "music.note")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(.secondary.opacity(0.5))
                    }

                    VStack(spacing: 8) {
                        Text("No Music Playing")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Select a track from your library to start")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(height: 300)
            }
        }
        .padding()
        .animation(.smooth, value: viewModel.playbackState?.currentTrack?.id)
    }
}

// MARK: - Artwork View

struct ArtworkView: View {
    let trackId: Int?
    @State private var artworkImage: NSImage?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            if let image = artworkImage {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .transition(.opacity)
            } else {
                // Placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.blue.opacity(0.4),
                                Color.purple.opacity(0.4),
                                Color.pink.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.6))
                    )

                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
        }
        .task(id: trackId) {
            await loadArtwork()
        }
    }

    private func loadArtwork() async {
        guard let trackId = trackId else { return }

        isLoading = true
        defer { isLoading = false }

        // TODO: Load artwork from backend API
        // For now, use placeholder
        try? await Task.sleep(nanoseconds: 500_000_000)
    }
}

// MARK: - Playing Indicator

struct PlayingIndicator: View {
    @State private var animationValues: [CGFloat] = [0.3, 0.5, 0.3]

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<3, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.accentColor)
                    .frame(width: 3, height: 12)
                    .scaleEffect(y: animationValues[index])
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever()
                        .delay(Double(index) * 0.15),
                        value: animationValues[index]
                    )
            }
        }
        .padding(6)
        .background(Color.black.opacity(0.6))
        .cornerRadius(6)
        .onAppear {
            animationValues = [1.0, 0.6, 1.0]
        }
    }
}

#Preview {
    EnhancedNowPlayingView(viewModel: PlayerViewModel())
}
