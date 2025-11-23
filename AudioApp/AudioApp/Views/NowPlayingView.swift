//
//  NowPlayingView.swift
//  AudioApp
//
//  Now playing display view
//

import SwiftUI

struct NowPlayingView: View {
    @ObservedObject var viewModel: PlayerViewModel

    var body: some View {
        VStack(spacing: 12) {
            if let track = viewModel.playbackState?.currentTrack {
                // Album art placeholder
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(
                        colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 200, height: 200)
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.5))
                    )

                // Track info
                VStack(spacing: 4) {
                    Text(track.displayTitle)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .lineLimit(1)

                    Text(track.displayArtist)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .lineLimit(1)

                    if let album = track.album {
                        Text(album)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: 300)

            } else {
                // No track playing
                VStack(spacing: 16) {
                    Image(systemName: "music.note.list")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)

                    Text("No track playing")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .frame(height: 250)
            }
        }
        .padding()
    }
}
