//
//  UserDetailsView.swift
//  TravelDiscovery
//
//  Created by Duong Nguyen on 25/09/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserDetails: Decodable {
    let username, firstName, lastName, profileImage: String
    let followers, following: Int
    let posts: [Post]
}

struct Post: Decodable, Hashable {
    let title, imageUrl, views: String
    let hashtags: [String]
}

class UserDetailsViewModel: ObservableObject {
    
    @Published var userDetails: UserDetails?
    
    init(userId: Int) {
        // network code
        
        guard let url = URL(string: "https://travel.letsbuildthatapp.com/travel_discovery/user?id=\(userId)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                
                do {
                    self.userDetails = try JSONDecoder().decode(UserDetails.self, from: data)
                } catch let jsonError {
                    print("Decoding failed for UserDetails:", jsonError)
                }
                print(data)
            }
            
        }.resume()
    }
    
}


struct UserDetailsView: View {
    @ObservedObject var vm: UserDetailsViewModel
    
    let user: User
    
    init(user: User) {
        self.user = user
        self.vm = .init(userId: user.id)
    }
    
    var body: some View {
            
        ScrollView {
            VStack(spacing: 12) {
                Image(user.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .shadow(radius: 10)
                    .padding(.horizontal)
                    .padding(.top)
                
                Text("\(self.vm.userDetails?.firstName ?? "") \(self.vm.userDetails?.lastName ?? "")")
                    .font(.system(size: 14, weight: .semibold))
                
                HStack {
                    Text("@\(self.vm.userDetails?.username ?? "") •")
                    
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 10, weight: .semibold))

                    Text("2541")
                }
                .font(.system(size: 12, weight: .regular))
                
                Text("Youtuber, Vlogger, Travel Creator")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(.lightGray))
                
                HStack(spacing: 12) {
                    VStack {
                   
                        Text("\(vm.userDetails?.followers ?? 0)")
                            .font(.system(size: 13, weight: .semibold))
                        
                        Text("Followers")
                            .font(.system(size: 9, weight: .regular))
                    }
                    
                    Spacer().frame(width: 1, height: 12).background(Color(.lightGray))
                    
                    VStack {
                        Text("\(vm.userDetails?.following ?? 0)")
                            .font(.system(size: 13, weight: .semibold))
                            
                        Text("Following")
                            .font(.system(size: 9, weight: .regular))
                    }
                    
                }//end HStack
                
                HStack(spacing: 12) {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        HStack {
                            Spacer()
                            Text("Follow")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                        }.padding(.vertical, 8)
                        .background(Color.orange)
                        .cornerRadius(100)
                    })
                    
                    Spacer()
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        HStack {
                            Spacer()
                            Text("Contact")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black)
                            Spacer()
                        }.padding(.vertical, 8)
                        .background(Color(white: 0.9))
                        .cornerRadius(100)
                    })
                }.font(.system(size: 11, weight: .semibold))
               
                
                ForEach(vm.userDetails?.posts ?? [], id: \.self) { post in
                    VStack(alignment: .leading, spacing: 12) {
                        WebImage(url: URL(string: post.imageUrl))
                            .resizable()
                            .indicator(.activity) // Activity Indicator
                               .transition(.fade(duration: 0.5)) // Fade Transition with duration
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                        
                        HStack {
                            Image(user.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 34)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .font(.system(size: 13, weight: .semibold))
                                
                                Text("\(post.views) views")
                                    .font(.system(size: 12, weight: .regular))
                            }.padding(.horizontal, 8)
                            
                        }.padding(.horizontal, 12)
                        
                        HStack {
                            ForEach(post.hashtags, id: \.self) { hashtag in
                                Text("#\(hashtag)")
                                    .foregroundColor(Color(#colorLiteral(red: 0.07797152549, green: 0.513774395, blue: 0.9998757243, alpha: 1)))
                                    .font(.system(size: 13, weight: .semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color(#colorLiteral(red: 0.9057956338, green: 0.9333867431, blue: 0.9763537049, alpha: 1)))
                                    .cornerRadius(20)
                            }//end ForEach
                        }.padding(.bottom)
                            .padding(.horizontal, 12)
                       
                        
                    }
                    .background(Color(white: 0.9))
                    .cornerRadius(12)
                    .shadow(color: .init(white: 0.8), radius: 5, x: 0, y: 4)
                }
                
                
            }//end VStack
            .padding(.horizontal)
        }.navigationBarTitle(user.name, displayMode: .inline)
    }
}


struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            UserDetailsView(user: .init(id: 0, name: "Akira Duong", imageName: "amy"))
        }
        
       
    }
}
