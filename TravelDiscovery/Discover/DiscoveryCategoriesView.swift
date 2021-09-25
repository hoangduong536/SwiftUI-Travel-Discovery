//
//  DiscoveryCategoriesView.swift
//  TravelDiscovery
//
//  Created by Duong Nguyen on 24/09/2021.
//

import SwiftUI

import SDWebImageSwiftUI

struct NavigationLazyView<Content: View>: View {
    
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}

struct DiscoveryCategoriesView: View {
    
    let categories: [Category] = [
        .init(name: "Art", imageName: "paintpalette.fill"),
        .init(name: "Sports", imageName: "sportscourt.fill"),
        .init(name: "Live Events", imageName: "music.mic"),
        .init(name: "Food", imageName: "tray.fill"),
        .init(name: "History", imageName: "books.vertical.fill")
    ]
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 14) {
                ForEach(categories, id: \.self) { entity in
                    NavigationLink (
                        destination: NavigationLazyView(CategoryDetailsView(name: entity.name)),
                        label: {
                         
                            VStack(spacing: 8) {
                                Image(systemName: entity.imageName)
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(#colorLiteral(red: 1, green: 0.5059075952, blue: 0.2313886285, alpha: 1)))
                                    .frame(width: 64, height: 64)
                                    .background(Color.white)
                                    .cornerRadius(64)
                                    .shadow(color: .gray, radius: 4, x: 0.0, y: 2 )
                                Text(entity.name)
                                    .font(.system(size: 12, weight: .semibold))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                
                            }.frame(width: 68)
                        })
                    
                    
                }//end ForEach
                
            }//end HStack
        }.padding(.horizontal)
    }
}//end DiscoveryCategoriesView

struct DiscoveryCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
//        NavigationView {
//            CategroryDetailsView()
//        }
        DiscoverView()
    }
}
