//
//  CachedAsyncImageView.swift
//  FetchBitesApp
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import SwiftUI

struct CachedAsyncImageView: View {
    let url: URL
    let cache: ImageCache

    @StateObject private var loader: ImageLoader

    init(url: URL, cache: ImageCache) {
        self.url = url
        self.cache = cache
        _loader = StateObject(wrappedValue: ImageLoader(cache: cache))
    }

    var body: some View {
        ZStack {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                if loader.isLoading {
                    ProgressView()
                }
            }
        }
        .onAppear {
            loader.load(url)
        }
        .onDisappear {
            loader.cancel()
        }
    }
}
