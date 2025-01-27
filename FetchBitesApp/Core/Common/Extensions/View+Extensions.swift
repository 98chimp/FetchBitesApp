//
//  View+Extensions.swift
//  FetchBitesApp
//
//  Created by Shahin Zangenehpour on 2025-01-27.
//

import SwiftUI

extension View {
    func shimmer(isActive: Bool) -> some View {
        modifier(ShimmerEffect(isActive: isActive))
    }
}
