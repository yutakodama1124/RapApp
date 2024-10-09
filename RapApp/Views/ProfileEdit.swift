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
    
    @State var user: User?
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var imageURL: URL?
    @State private var name = ""
    @State private var school = ""
    @State private var hobby = ""
    @State private var job = ""
    
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
                            Profilepic(sourceType: .photoLibrary, selectedImage: $selectedImage)
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
                            Profilepic(sourceType: .photoLibrary, selectedImage: $selectedImage)
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
                        user!.imageURL = imageURL
                        user!.name = name
                        user!.school = school
                        user!.job = job
                        user!.hobby = hobby
                        await AppDelegate.setUser(user: user!)
                    }
                    uploadImage()
                }
                .frame(width: 100, height: 70)
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(25)
                .padding()
            }
        }
        .task {
            self.user = await AppDelegate.getUser()
            self.name = self.user!.name
            self.school = self.user!.school
            self.job = self.user!.job
            self.hobby = self.user!.hobby
        }
    }
    func uploadImage() {
        guard let image = selectedImage else { return }
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    return
                }
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        return
                    }
                    guard let url = url else { return }
                    imageURL
                    saveImageUrlToFirestore(url: url)
                }
            }
        }
    }
    
    func saveImageUrlToFirestore(url: URL) {
        let db = Firestore.firestore()
        db.collection("images").addDocument(data: ["url": url.absoluteString]) { error in
            if let error = error {
                print("Error saving image URL to Firestore: \(error.localizedDescription)")
            } else {
                fetchImageUrl()
            }
        }
    }
    
    func fetchImageUrl() {
        let db = Firestore.firestore()
        db.collection("images").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching image URLs: \(error.localizedDescription)")
                return
            }
            if let documents = snapshot?.documents, let urlString = documents.last?.data()["url"] as? String, let url = URL(string: urlString) {
                imageURL = url
                downloadImage(from: url)
            }
        }
    }
    
    func downloadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    selectedImage = downloadedImage
                }
            }
        }
        task.resume()
    }
}

#Preview {
    ProfileEdit()
}
