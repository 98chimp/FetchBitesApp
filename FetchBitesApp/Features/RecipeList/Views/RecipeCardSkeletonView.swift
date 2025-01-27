//
//  RecipeCardSkeletonView.swift
//  FetchBitesApp
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import SwiftUI

struct RecipeCardSkeletonView: View {
    @State private var isShimmering = false

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Padding.small) {
            // Cuisine type skeleton
            Capsule()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 80, height: 24)
                .shimmer(isActive: isShimmering)

            // Image skeleton
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
                .shimmer(isActive: isShimmering)

            // Recipe info skeleton
            VStack(alignment: .leading, spacing: Theme.Padding.small) {
                // Title
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 24)
                    .shimmer(isActive: isShimmering)

                // Action buttons skeleton
                HStack(spacing: Theme.Padding.medium) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 100, height: 20)
                        .shimmer(isActive: isShimmering)

                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 120, height: 20)
                        .shimmer(isActive: isShimmering)
                }
            }
            .padding(.horizontal, Theme.Padding.small)
        }
        .padding(Theme.Padding.small)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.large))
        .shadow(
            color: Theme.Colors.primary.opacity(0.1),
            radius: 10,
            x: 0,
            y: 2
        )
        .onAppear {
            isShimmering = true
        }
    }
}

// MARK: - Shimmer Effect Modifier
struct ShimmerEffect: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    if isActive {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .clear,
                                Color.white.opacity(0.2),
                                .clear
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: geometry.size.width * 2)
                        .offset(x: -geometry.size.width)
                        .animation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: isActive
                        )
                    }
                }
            )
            .clipped()
    }
}

// MARK: - View Extension
extension View {
    func shimmer(isActive: Bool) -> some View {
        modifier(ShimmerEffect(isActive: isActive))
    }
}

// MARK: - Loading Recipe List View
struct LoadingRecipeListView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Padding.medium) {
                ForEach(0..<5, id: \.self) { _ in
                    RecipeCardSkeletonView()
                }
            }
            .padding()
        }
    }
}

// MARK: - Preview
struct RecipeCardSkeletonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RecipeCardSkeletonView()
                .padding()

            LoadingRecipeListView()
                .background(Color(.systemGroupedBackground))
        }
    }
}
