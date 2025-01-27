//
//  ImageLoader.swift
//  FetchBitesApp
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import UIKit

@MainActor
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false

    private var url: URL?
    private var task: Task<Void, Never>?
    private let cache: ImageCache

    init(cache: ImageCache) {
        self.cache = cache
    }

    func load(_ url: URL) {
        guard self.url != url else { return }
        cancel()

        self.url = url
        isLoading = true

        task = Task { [weak self] in
            guard let self = self else { return }

            if let cached = await cache.get(for: url) {
                self.isLoading = false
                self.image = cached
                return
            }

            guard let (data, _) = try? await URLSession.shared.data(from: url),
                  let image = UIImage(data: data) else {
                self.isLoading = false
                return
            }

            await cache.insert(image, for: url)

            if !Task.isCancelled && self.url == url {
                self.isLoading = false
                self.image = image
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
        url = nil
    }
}
