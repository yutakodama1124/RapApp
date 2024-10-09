//
//  ProfileNew.swift
//  RapApp
//
//  Created by yuta kodama on 2024/08/13.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import Kingfisher

struct ProfileNew: View {
    
    @State var user: User?
    
    var body: some View {
        ZStack {
            if let user, let im = URL(string: user.imageURL) {
                KFImage(im)
                    .resizable()
                    .placeholder { _ in Image(uiImage: UIColor.tertiarySystemFill.image())}
                    .aspectRatio(contentMode: .fill)
                //                .frame(width: 250, height: 250)
                    .frame(maxHeight: .infinity)
                .cornerRadius(25)}
            
            ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 350, height: 380)
                                .cornerRadius(30)
                                .shadow(color: .gray, radius: 10)
                
                VStack(spacing: 30) {
                    HStack {
                        Image(systemName: "person.circle")
                            .font(.system(size: 35))
                        
                        if let user {
                            Text(user.name)
                                .font(.system(size: 35, weight:
                                        .heavy, design: .rounded))
                        }
                    }
                    .frame(maxWidth: 310, alignment: .center)
                    
                    HStack(spacing: 30) {
                        VStack {
                            Text("歴")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                            
                            Text("2年")
                                .font(.system(size: 20, weight: .heavy, design: .rounded))
                        }
                        Rectangle()
                            .frame(width: 2, height: 30)
                        
                        VStack {
                            Text("バトル数")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                            
                            Text("30")
                                .font(.system(size: 20, weight: .heavy, design: .rounded))
                        }
                        Rectangle()
                            .frame(width: 2, height: 30)
                        
                        VStack {
                            Text("年齢")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                            
                            Text("15")
                                .font(.system(size: 20, weight: .heavy, design: .rounded))
                        }
                    }
                    .frame(maxWidth: 310, alignment: .center)
                    
                    VStack {
                        Text("学校")
                            .foregroundStyle(.gray)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                        
                        if let user {
                            Text(user.school)
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                        }
                    }
                    .frame(maxWidth: 310, minHeight: 43, alignment: .center)
                    
                    VStack {
                        Text("職業")
                            .foregroundStyle(.gray)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                        
                        if let user {
                            Text(user.job)
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                        }
                    }
                    .frame(maxWidth: 310, minHeight: 43, alignment: .center)
                    
                    VStack {
                        Text("趣味")
                            .foregroundStyle(.gray)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                        
                        if let user {
                            
                            Text(user.hobby)
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                        }
                    }
                    .frame(maxWidth: 310, minHeight: 43, alignment: .center)
                }
            }
            .offset(y: 140)
            .task {
                user = await AppDelegate.getUser()
            }
        }
    }
}
#Preview {
    ProfileNew(user: User(imageURL: "", name: "", school: "", hobby: "", job: ""))
}
