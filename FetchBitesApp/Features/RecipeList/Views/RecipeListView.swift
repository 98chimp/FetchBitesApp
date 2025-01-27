//
//  RecipeListView.swift
//  FetchBitesApp
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import SwiftUI
import SafariServices

// MARK: - Sort Options
enum RecipeSortOption: String, CaseIterable {
    case alphabetical = "Alphabetical"
    case byCuisine = "By Cuisine"

    var icon: String {
        switch self {
        case .alphabetical: return "textformat.abc"
        case .byCuisine: return "fork.knife"
        }
    }
}

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    @State private var selectedImageURL: IdentifiableURL?
    @State private var selectedVideoURL: IdentifiableURL?
    @State private var selectedSourceURL: IdentifiableURL?
    @State private var sortOption: RecipeSortOption = .alphabetical
    private let imageCache: ImageCache

    init(viewModel: RecipeListViewModel = .init(), imageCache: ImageCache = ImageCache()) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.imageCache = imageCache
    }

    var body: some View {
        NavigationView {
            ZStack {
                Theme.Colors.background
                    .ignoresSafeArea()

                Group {
                    switch viewModel.state {
                    case .loading:
                        LoadingRecipeListView()

                    case .loaded:
                        recipeList

                    case .empty:
                        emptyState

                    case .error(let error):
                        errorView(error)
                    }
                }
            }
            
            .navigationTitle("FetchBites")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Theme.Colors.primary, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    sortingMenu
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    refreshButton
                }
            }
            .refreshable {
                await viewModel.fetchRecipes()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: Theme.Padding.medium) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 64))
                .foregroundColor(Theme.Colors.secondary)

            Text("No Recipes Found")
                .font(.title2.bold())
                .foregroundColor(Theme.Colors.text)

            Text("Pull to refresh and try again")
                .font(.subheadline)
                .foregroundColor(Theme.Colors.textSecondary)
        }
    }

    private func errorView(_ error: Error) -> some View {
        VStack(spacing: Theme.Padding.medium) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 64))
                .foregroundColor(Theme.Colors.error)

            Text("Something went wrong")
                .font(.title2.bold())
                .foregroundColor(Theme.Colors.text)

            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                Task {
                    await viewModel.fetchRecipes()
                }
            } label: {
                Text("Try Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, Theme.Padding.large)
                    .padding(.vertical, Theme.Padding.small)
                    .background(Theme.Colors.primary)
                    .cornerRadius(Theme.CornerRadius.medium)
            }
        }
    }

    private var sortingMenu: some View {
        Menu {
            ForEach(RecipeSortOption.allCases, id: \.self) { option in
                Button {
                    withAnimation {
                        sortOption = option
                    }
                } label: {
                    Label(option.rawValue, systemImage: option.icon)
                        .foregroundColor(sortOption == option ? Theme.Colors.secondary : .white)
                }
            }
        } label: {
            Label(sortOption.rawValue, systemImage: sortOption.icon)
                .foregroundColor(.white)
        }
    }

    private var refreshButton: some View {
        Button {
            Task {
                await viewModel.fetchRecipes()
            }
        } label: {
            Image(systemName: "arrow.clockwise")
                .foregroundColor(.white)
        }
    }

    private var recipeList: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Padding.medium) {
                if sortOption == .byCuisine {
                    cuisineGroupedList
                } else {
                    alphabeticalList
                }
            }
            .padding(.vertical, Theme.Padding.small)
        }
        .sheet(item: $selectedImageURL) { identifiableURL in
            ImagePreviewView(imageURL: identifiableURL.url, onDismiss: {
                selectedImageURL = nil
            })
        }
        .sheet(item: $selectedVideoURL) { identifiableURL in
            VideoPreviewView(videoURL: identifiableURL.url)
        }
        .sheet(item: $selectedSourceURL) { identifiableURL in
            SafariView(url: identifiableURL.url)
        }
    }

    private var alphabeticalList: some View {
        ForEach(viewModel.recipes.sorted { $0.name < $1.name }) { recipe in
            RecipeCardView(
                recipe: recipe,
                onTapImage: handleImageTap,
                onTapVideo: handleVideoTap,
                onTapSource: handleSourceTap,
                imageCache: .init()
            )
            .padding(.horizontal, Theme.Padding.medium)
        }
    }

    private var cuisineGroupedList: some View {
        ForEach(groupedRecipes.keys.sorted(), id: \.self) { cuisine in
            VStack(alignment: .leading) {
                CuisineSectionHeader(title: cuisine)

                ForEach(groupedRecipes[cuisine] ?? []) { recipe in
                    RecipeCardView(
                        recipe: recipe,
                        onTapImage: handleImageTap,
                        onTapVideo: handleVideoTap,
                        onTapSource: handleSourceTap,
                        imageCache: imageCache
                    )
                    .padding(.horizontal, Theme.Padding.medium)
                }
            }
        }
    }

    private var groupedRecipes: [String: [Recipe]] {
        Dictionary(grouping: viewModel.recipes) { $0.cuisine }
    }

    private func handleImageTap(_ urlString: String) {
        if let url = URL(string: urlString) {
            selectedImageURL = IdentifiableURL(url: url)
        }
    }

    private func handleVideoTap(_ urlString: String) {
        if let url = URL(string: urlString) {
            selectedVideoURL = IdentifiableURL(url: url)
        }
    }

    private func handleSourceTap(_ urlString: String) {
        if let url = URL(string: urlString) {
            selectedSourceURL = IdentifiableURL(url: url)
        }
    }
}

// MARK: - Helper Types
struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}

// MARK: - Preview
struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}

struct CuisineSectionHeader: View {
    let title: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Text(title)
            .font(.title3.bold())
        // We use a ternary operator to switch colors based on the color scheme
            .foregroundColor(colorScheme == .dark ? Theme.Colors.secondary : Theme.Colors.primary)
            .padding(.horizontal, Theme.Padding.medium)
            .padding(.vertical, Theme.Padding.small)
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = false
        configuration.barCollapsingEnabled = true

        let safariViewController = SFSafariViewController(url: url, configuration: configuration)
        safariViewController.preferredControlTintColor = UIColor(Theme.Colors.primary)
        safariViewController.dismissButtonStyle = .close

        return safariViewController
    }

    func updateUIViewController(_ controller: SFSafariViewController, context: Context) {
        // No update needed
    }
}

// Add this extension for the title color
extension View {
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithDefaultBackground()
        coloredAppearance.backgroundColor = UIColor(Theme.Colors.primary)
        coloredAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(color)
        ]
        coloredAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(color)
        ]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance

        return self
    }
}
