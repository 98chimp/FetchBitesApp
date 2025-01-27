//
//  WebView.swift
//  FetchBitesApp
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import SwiftUI
import WebKit
import AVKit

// MARK: - WebView UIKit Wrapper
struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.backgroundColor = .black
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

// MARK: - VideoPlayerView
struct VideoPlayerView: View {
    let url: URL

    var body: some View {
        if url.absoluteString.contains("youtube") {
            // For YouTube URLs, we'll use WebView with embedded player
            let embedURL = url.absoluteString.replacingOccurrences(
                of: "youtube.com/watch?v=",
                with: "youtube.com/embed/"
            )
            WebView(urlString: embedURL)
        } else {
            VideoPlayer(player: AVPlayer(url: url))
        }
    }
}

// MARK: - VideoPreviewView
struct VideoPreviewView: View {
    @Environment(\.dismiss) private var dismiss
    let videoURL: URL

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VideoPlayerView(url: videoURL)
                .edgesIgnoringSafeArea(.all)
        }
        .overlay(alignment: .topTrailing) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
}

// MARK: - ImagePreviewView
struct ImagePreviewView: View {
    let imageURL: URL
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            CachedAsyncImageView(url: imageURL, cache: .init())
                .aspectRatio(contentMode: .fit)

            VStack {
                HStack {
                    Spacer()
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
    }
}
