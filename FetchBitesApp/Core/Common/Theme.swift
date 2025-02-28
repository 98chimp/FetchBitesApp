//
//  Theme.swift
//  FetchBitesApp
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import SwiftUI

/// FetchBites theme colors and styling constants based on the app icon colour pellet 
enum Theme {
    enum Colors {
        // Brand Colors
        static let primary = Color(hex: "2B2B49")  // Fetch's dark blue/purple
        static let primaryDark = Color(hex: "1E1E33")
        static let secondary = Color(hex: "FFB800")  // Fetch's gold
        static let secondaryDark = Color(hex: "DDA000")

        // Text Colors
        static let text = primary
        static let textSecondary = Color(hex: "666666")
        static let textOnPrimary = Color.white

        // UI Colors
        static let background = Color(.systemGroupedBackground)
        static let cardBackground = Color.white
        static let error = Color(hex: "E06666")
        static let success = Color(hex: "4CAF50")

        // Overlay Colors
        static let overlay = Color.black.opacity(0.4)
        static let shimmer = Color.white.opacity(0.3)
    }

    enum Gradients {
        static let primary = LinearGradient(
            colors: [Colors.primary, Colors.primaryDark],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let secondary = LinearGradient(
            colors: [Colors.secondary, Colors.secondaryDark],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }

    enum Padding {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
    }

    enum Animation {
        static let standard = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.8)
        static let slow = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.8)
    }
}
