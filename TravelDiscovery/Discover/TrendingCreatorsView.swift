//
//  TrendingCreatorsView.swift
//  TravelDiscovery
//
//  Created by Duong Nguyen on 24/09/2021.
//

import SwiftUI

struct TrendingCreatorsView: View {
    
    let users: [User] = [
        .init(id: 0, name: "Amy Adams", imageName: "amy"),
        .init(id: 1, name: "Billy", imageName: "billy"),
        .init(id: 2, name: "Sam Smith", imageName: "sam"),
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Trending creators")
                    .font(.system(size: 14, weight: .semibold))
                
                Spacer()
                
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
                
            }.padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top,spacing: 12) {
                    ForEach(users, id: \.self) { entity in
                        
                        NavigationLink(
                            destination: UserDetailsView(user: entity),
                            label: {
                                DiscoverUserView(user: entity)
                            })
                    }//end ForEach
                }.padding(.horizontal)
            }
            
        }
        
    }
}//end TrendingCreatorsView


struct DiscoverUserView: View {
    let user: User
    
    var body: some View {
        VStack {
            Image(user.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(60)
            
            Text(user.name).font(.system(size: 11, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.label))
        }
        .frame(width: 60)
        
        .shadow(color: .gray, radius: 4, x: 0.0, y: 2 )
        .padding(.bottom)
    }
}

struct TrendingCreatorsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingCreatorsView()
        DiscoverView()
    }
}
