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

struct Profile: View {
    @State var user: User = .Empty()
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var imageURL = ""
    @State private var name = ""
    @State private var school = ""
    @State private var hobby = ""
    @State private var job = ""
    @State private var birthday = Date()
    @State private var favrapper = ""
    private let repository: UserGateway = UserGateway()
    
    var body: some View {
        VStack {
            KFImage(URL(string: user.imageURL))
                .placeholder { _ in Image(uiImage: UIColor.tertiarySystemFill.image())}
                .resizable()
                .edgesIgnoringSafeArea(.top)
                .aspectRatio(contentMode: .fill)
                .clipped()
            
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(maxWidth: .infinity)
                    .shadow(color: .gray, radius: 10)
                
                VStack(spacing: 30) {
                    HStack {
                        Text(user.name)
                            .font(.system(size: 35, weight:
                                    .heavy, design: .rounded))
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
                            .frame(width: 2, height: 33)
                        
                        VStack {
                            Text("バトル数")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                            
                            Text("30")
                                .font(.system(size: 20, weight: .heavy, design: .rounded))
                        }
                        Rectangle()
                            .frame(width: 2, height: 33)
                        
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
                        
                        Text(user.school)
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                    }
                    .frame(maxWidth: 310, minHeight: 43, alignment: .center)
                    
                    VStack {
                        Text("職業")
                            .foregroundStyle(.gray)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                        
                        Text(user.job)
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                    }
                    .frame(maxWidth: 310, minHeight: 43, alignment: .center)
                    
                    VStack {
                        Text("趣味")
                            .foregroundStyle(.gray)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                        
                        Text(user.hobby)
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                    }
                    .frame(maxWidth: 310, minHeight: 43, alignment: .center)
                    
                    VStack {
                        Text("好きなラッパー")
                            .foregroundStyle(.gray)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                        
                        Text(user.favrapper)
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                    }
                    .frame(maxWidth: 310, minHeight: 43, alignment: .center)
                }
                .padding()
            }
            .task {
                guard let uid = Auth.auth().currentUser?.uid else {
                    print("ログインしているユーザーが見つかりません")
                    return
                }
                
                guard let user = await repository.fetchUser(userId: uid) else {
                    print("ユーザー情報が取得できませんでした")
                    return
                }
                
                self.user = user
                self.name = user.name
                self.imageURL = user.imageURL
                self.school = user.school
                self.hobby = user.hobby
                self.favrapper = user.favrapper
            }
        }
    }
}
#Preview {
    Profile(user: .Empty())
}
