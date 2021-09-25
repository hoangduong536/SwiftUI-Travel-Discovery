//
//  ActivityIndicatorView.swift
//  TravelDiscovery
//
//  Created by Duong Nguyen on 24/09/2021.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {

    typealias UIViewType = UIActivityIndicatorView

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .white
        aiv.startAnimating()
        return aiv
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }

}

struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicatorView()
    }
}
