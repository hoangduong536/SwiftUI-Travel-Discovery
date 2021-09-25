//
//  ContentView.swift
//  TravelDiscovery
//
//  Created by Duong Nguyen on 24/09/2021.
//

import SwiftUI

extension Color {
    static let discorverBackground = Color(.init(white: 0.95, alpha: 1))
}


struct DiscoverView: View {
    
    
    init () {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9882352941, green: 0.6823529412, blue: 0.2509803922, alpha: 1)), Color(#colorLiteral(red: 0.9960784314, green: 0.4470588235, blue: 0.2705882353, alpha: 1))]), startPoint: .top, endPoint: .center)
                    .ignoresSafeArea()
                
                
                Color.discorverBackground.offset(y: 400)
                
                ScrollView {
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Where do you want to go?")
                        Spacer()
                            
                    }.font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.init(white: 1, alpha: 0.3)))
                    .cornerRadius(10)
                    .padding(16)
                    
                    DiscoveryCategoriesView()
                    
                    VStack {
                   
                        PopularDestinationsView()
                        
                        PopularRestaurantsView()
                        
                        TrendingCreatorsView()
                    }.background(Color.discorverBackground)
                    .cornerRadius(16)
                    .padding(.top, 32)
                    
                }
                
            }//end ZStack
            .navigationTitle("Discover")
           
        }//end NavigationView
    }//end body
}//end ContentView



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}//end ContentView_Previews

















