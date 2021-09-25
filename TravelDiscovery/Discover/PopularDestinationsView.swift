//
//  PopularDestinationsView.swift
//  TravelDiscovery
//
//  Created by Duong Nguyen on 24/09/2021.
//

import SwiftUI
import MapKit

class DestinationDetailsViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var destinationDetails: DestinationDetails?
    @Published var errorMessage = ""
    
    init(name: String) {
        let fixedUrlString = "https://travel.letsbuildthatapp.com/travel_discovery/destination?name=\(name.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        
        guard let url = URL(string: fixedUrlString) else {
            self.isLoading = false
            return
        }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            // make sure to check your err & resp
            
            // you want to check resp statusCode and err
            if let statusCode = (resp as? HTTPURLResponse)?.statusCode, statusCode >= 400 {
                self.isLoading = false
                self.errorMessage = "Bad status: \(statusCode)"
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let data = data else { return }
                
                do {
                    
                    self.destinationDetails = try JSONDecoder().decode(DestinationDetails.self, from: data)
                    
                } catch {
                    print("Failed to decode JSON,", error)
                }
                
                self.isLoading = false
            }
        }.resume()
    }
    
}


struct PopularDestinationsView: View {
    
    let destinations: [Destination] = [
        .init(name: "Paris", country: "France", imageName: "eiffel_tower", latitude: 48.855014, longitude: 2.341231),
        .init(name: "Tokyo", country: "Japan", imageName: "japan", latitude: 35.67988, longitude: 139.7695),
        .init(name: "New York", country: "US", imageName: "new_york", latitude: 40.71592, longitude: -74.0055),
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Popular Destinations")
                    .font(.system(size: 14, weight: .semibold))
                
                Spacer()
                
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
                
            }.padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal,showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(destinations, id: \.self) { entity in
                        NavigationLink(
                            destination: NavigationLazyView(PopularDestinationDetailsView(destination: entity)),
                            label: {
                                PopularDestinationTile(destination: entity).padding(.bottom)
                            })
                        
                    }//end ForEach
                }.padding(.horizontal)
            }//end ScrollView
        }
    }//end body
}//end PopularDestinationsView

struct PopularDestinationTile: View {
    
    let destination: Destination
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Image(destination.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 125, height: 125)
                .cornerRadius(4)
                .padding(.horizontal, 6)
                .padding(.vertical, 6)
            
            Text(destination.name)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .foregroundColor(Color(.label))
            
            Text(destination.country)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
                .foregroundColor(.gray)
        }
        .asTile()
    }
}

struct PopularDestinationDetailsView: View {
    let destination: Destination
    
    @ObservedObject var vm: DestinationDetailsViewModel
    
    //    @State var region = MKCoordinateRegion(center: .init(latitude: 48.859565, longitude: 2.353235), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State var region: MKCoordinateRegion
    @State var isShowAttractions = true
    
    let imageUrlStrings = [
        "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/2240d474-2237-4cd3-9919-562cd1bb439e",
        "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/b1642068-5624-41cf-83f1-3f6dff8c1702",
        "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/6982cc9d-3104-4a54-98d7-45ee5d117531"
    ]
    
    init(destination: Destination) {
        print("Hitting network unnecessarily")
        self.destination = destination
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: destination.latitude, longitude: destination.longitude), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        
        self.vm = .init(name: destination.name)
    }
    
    var body: some View {
        
        ZStack {
            if vm.isLoading {
                VStack {
                    ActivityIndicatorView()
                    Text("Loading..")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding()
                .background(Color.black)
                .cornerRadius(8)
                
            }else {
                ZStack {
                    
                    if !vm.errorMessage.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "xmark.octagon.fill")
                                .font(.system(size: 64, weight: .semibold))
                                .foregroundColor(.red)
                            Text(vm.errorMessage)
                        }
                    }
                    
                    ScrollView {
                        //            Image(destination.imageName)
                        //                .resizable()
                        //                .scaledToFill()
                        //                .frame(height: 200)
                        //                .clipped()
                        if let photos = vm.destinationDetails?.photos {
                            DestinationHeaderContainer(imageUrlStrings: photos)
                                .frame(height: 350)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(destination.name)
                                .font(.system(size: 18, weight: .bold))
                            
                            Text(destination.country)
                            
                            HStack {
                                ForEach(0..<5, id: \.self) { num in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.orange)
                                }
                            }.padding(.top, 2)
                            
                            Text(vm.destinationDetails?.description ?? "")
                                .padding(.top, 4)
                                .font(.system(size: 14))
                            
                            HStack { Spacer() }
                        }.padding(.horizontal)
                        
                        HStack {
                            Text("Location").font(.system(size: 18, weight: .semibold))
                            Spacer()
                            
                            Button(action: { isShowAttractions.toggle()}, label: {
                                Text("\(isShowAttractions ? "Hide" : "Show") Attractions")
                                    .font(.system(size: 12, weight: .semibold))
                            })
                            
                            // UIKit: UISwitch
                            Toggle("", isOn: $isShowAttractions).labelsHidden()
                            
                        }.padding(.horizontal)
                        
                        Map(coordinateRegion: $region, annotationItems: isShowAttractions ? attractions : []) { (attraction) in
                            //                return MapMarker(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude))
                            MapAnnotation(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude)) {
                                CustomMapAnnotation(attraction: attraction)
                            }
                        }.frame(height: 300)
                        
                    }//end ScrollView
                }
            }
        }
        .navigationBarTitle(destination.name, displayMode: .inline)
    }//end body
    
    let attractions: [Attraction] = [
        .init(name: "Eiffel Tower", imageName: "eiffel_tower", latitude: 48.858605, longitude: 2.2946),
        .init(name: "Champs-Elysees", imageName: "new_york", latitude: 48.866867, longitude: 2.311780),
        .init(name: "Louvre Museum", imageName: "art2", latitude: 48.860288, longitude: 2.337789)
    ]
    
}

struct Attraction: Identifiable {
    let id = UUID().uuidString
    
    let name, imageName: String
    let latitude, longitude: Double
}

struct CustomMapAnnotation: View {
    
    let attraction: Attraction
    
    var body: some View {
        VStack {
            Image(attraction.imageName)
                .resizable()
                .frame(width: 80, height: 60)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(.init(white: 0, alpha: 0.5)))
                )
            Text(attraction.name)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(LinearGradient(gradient: /*@START_MENU_TOKEN@*/Gradient(colors: [Color.red, Color.blue])/*@END_MENU_TOKEN@*/, startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                .foregroundColor(.white)
                //                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(.init(white: 0, alpha: 0.5)))
                )
            
        }.shadow(radius: 5)
    }
}



struct PopularDestinationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PopularDestinationDetailsView(destination: .init(name: "Paris", country: "France", imageName: "eiffel_tower", latitude: 48.859565, longitude: 2.353235))
        }
        PopularDestinationsView()
        DiscoverView()
    }
}
