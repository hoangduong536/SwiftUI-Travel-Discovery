//
//  TileModifier.swift
//  TravelDiscovery
//
//  Created by Duong Nguyen on 24/09/2021.
//

import SwiftUI

extension View {
    func asTile() -> some View {
        modifier(TileModifier())
    }
}

struct TileModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(Color.white)
            .cornerRadius(5)
            .shadow(color: .gray, radius: 4, x: 0.0, y: 2 )
    }
}
