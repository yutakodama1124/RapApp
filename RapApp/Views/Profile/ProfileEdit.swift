//
//  ProfileEdit.swift
//  RapApp
//
//  Created by yuta kodama on 2024/09/04.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct ProfileEdit: View {
    @State var user: User = .Empty()
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var imageURL: URL?
    @State private var name = ""
    @State private var school = ""
    @State private var hobby = ""
    @State private var job = ""
    
    private let repository: UserRepository = UserRepository()
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .frame(width: 290, height: 350)
                            .scaledToFill()
                            .clipShape(Rectangle())
                            .cornerRadius(25)
                        
                        Button("Change Image") {
                            isShowingImagePicker = true
                        }
                        .sheet(isPresented: $isShowingImagePicker) {
                            LibraryPickerView(sourceType: .photoLibrary, selectedImage: $selectedImage)
                        }
                    } else {
                        Button("Choose Photo") {
                            isShowingImagePicker = true
                        }
                        .frame(width: 290, height: 350)
                        .foregroundColor(.white)
                        .background(.black)
                        .cornerRadius(25)
                        .padding()
                        .sheet(isPresented: $isShowingImagePicker) {
                            LibraryPickerView(sourceType: .photoLibrary, selectedImage: $selectedImage)
                        }
                    }
                }
                .padding()
                
                VStack {
                    Text("名前")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 24, weight:
                                .medium, design: .rounded))
                        .offset(x: 30)
                    
                    TextField("名前", text: $name)
                        .font(.system(size: 24, design: .rounded))
                        .foregroundColor(.black)
                        .offset(x: 30)
                    
                    Rectangle()
                        .frame(width: 300, height: 1)
                }
                .padding()
                
                VStack {
                    Text("学校")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 24, weight:
                                .medium, design: .rounded))
                        .offset(x: 30)
                    
                    TextField("学校", text: $school)
                        .font(.system(size: 24, design: .rounded))
                        .foregroundColor(.black)
                        .offset(x: 30)
                    
                    Rectangle()
                        .frame(width: 300, height: 1)
                }
                .padding()
                
                VStack {
                    Text("仕事")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 24, weight:
                                .medium, design: .rounded))
                        .offset(x: 30)
                    
                    TextField("仕事", text: $job)
                        .font(.system(size: 24, design: .rounded))
                        .foregroundColor(.black)
                        .offset(x: 30)
                    
                    Rectangle()
                        .frame(width: 300, height: 1)
                }
                .padding()
                
                VStack {
                    Text("趣味")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 24, weight:
                                .medium, design: .rounded))
                        .offset(x: 30)
                    
                    TextField("趣味", text: $hobby)
                        .font(.system(size: 24, design: .rounded))
                        .foregroundColor(.black)
                        .offset(x: 30)
                    
                    Rectangle()
                        .frame(width: 300, height: 1)
                }
                .padding()
                
                Button("保存") {
                    Task {
                        user.name = name
                        user.hobby = hobby
                        user.school = school
                        user.job = job
                        
                        let storeImage = selectedImage ?? UIImage(systemName: "person.crop.circle")!
                        let storedImageURL = await repository.uploadImage(user: user, image: storeImage)
                        user.imageURL = storedImageURL ?? user.imageURL
                        
                        await repository.storeUser(from: user)
                    }
                }
                .frame(width: 100, height: 70)
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(25)
                .padding()
            }
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
        }
    }
}

#Preview {
    ProfileEdit()
}