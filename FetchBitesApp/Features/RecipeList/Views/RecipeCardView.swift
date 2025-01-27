//
//  RecipeCardView.swift
//  FetchBitesApp
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    let onTapImage: (String) -> Void
    let onTapVideo: (String) -> Void
    let onTapSource: (String) -> Void
    let imageCache: ImageCache

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Padding.small) {
            // Cuisine Tag
            Text(recipe.cuisine)
                .font(.caption.bold())
                .foregroundColor(Theme.Colors.primary)
                .padding(.horizontal, Theme.Padding.small)
                .padding(.vertical, 4)
                .background(Theme.Colors.secondary.opacity(0.2))
                .clipShape(Capsule())

            // Recipe Image
            if let imageURLString = recipe.photoURLSmall,
               let imageURL = URL(string: imageURLString) {
                CachedAsyncImageView(url: imageURL, cache: imageCache)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                            .stroke(Theme.Colors.secondary.opacity(0.3), lineWidth: 1)
                    )
                    .onTapGesture {
                        onTapImage(recipe.photoURLLarge ?? imageURLString)
                    }
            }

            // Recipe Info
            VStack(alignment: .leading, spacing: Theme.Padding.small) {
                Text(recipe.name)
                    .font(.title3.bold())
                    .foregroundColor(Theme.Colors.text)

                // Action Buttons Row
                HStack(spacing: Theme.Padding.medium) {
                    if let sourceURL = recipe.sourceURL {
                        Button {
                            onTapSource(sourceURL)
                        } label: {
                            Label("View Recipe", systemImage: "link")
                                .font(.subheadline)
                                .foregroundColor(Theme.Colors.primary)
                        }
                    }

                    Spacer()
                    if let videoURL = recipe.youtubeURL {
                        Button {
                            onTapVideo(videoURL)
                        } label: {
                            Label("Watch Video", systemImage: "play.circle.fill")
                                .font(.subheadline)
                                .foregroundColor(Theme.Colors.primary)
                        }
                    }

                }
            }
            .padding(.horizontal, Theme.Padding.small)
        }
        .padding(Theme.Padding.medium)
        .background(Theme.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.large))
        .shadow(
            color: Theme.Colors.primary.opacity(0.1),
            radius: 10,
            x: 0,
            y: 2
        )
    }
}

// MARK: - Preview Provider
struct RecipeCardView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: Theme.Padding.medium) {
                RecipeCardView(
                    recipe: Recipe.preview,
                    onTapImage: { _ in },
                    onTapVideo: { _ in },
                    onTapSource: { _ in },
                    imageCache: .init()
                )

                RecipeCardView(
                    recipe: Recipe.previewNoVideo,
                    onTapImage: { _ in },
                    onTapVideo: { _ in },
                    onTapSource: { _ in },
                    imageCache: .init()
                )
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Preview Helper
extension Recipe {
    static var preview: Recipe {
        Recipe(
            id: UUID().uuidString,
            name: "British Fish & Chips",
            cuisine: "British",
            photoURLSmall: "https://example.com/small.jpg",
            photoURLLarge: "https://example.com/large.jpg",
            sourceURL: "https://example.com/recipe",
            youtubeURL: "https://youtube.com/watch?v=123"
        )
    }

    static var previewNoVideo: Recipe {
        Recipe(
            id: UUID().uuidString,
            name: "Classic Scones",
            cuisine: "British",
            photoURLSmall: "https://example.com/small.jpg",
            photoURLLarge: "https://example.com/large.jpg",
            sourceURL: "https://example.com/recipe",
            youtubeURL: nil
        )
    }
}
