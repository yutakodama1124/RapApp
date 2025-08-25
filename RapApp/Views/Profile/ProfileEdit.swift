import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Kingfisher

struct ProfileEdit: View {
    @State var user: User = .Empty()
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var imageURL = ""
    @State private var name = ""
    @State private var school = ""
    @State private var hobby = ""
    @State private var job = ""
    @State private var favrapper = ""
    
    @State private var isPressed = false
    @State var close = false
    
    private let repository: UserGateway = UserGateway()
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 290, height: 350)
                            .clipShape(Rectangle())
                            .cornerRadius(25)
                            .onTapGesture { isShowingImagePicker = true }
                    } else if !imageURL.isEmpty {
                        KFImage(URL(string: imageURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 290, height: 350)
                            .clipShape(Rectangle())
                            .cornerRadius(25)
                            .onTapGesture { isShowingImagePicker = true }
                    } else {
                        Rectangle()
                            .fill(Color.black.opacity(0.1))
                            .frame(width: 290, height: 350)
                            .cornerRadius(25)
                            .overlay(Text("Choose Photo").foregroundColor(.black))
                            .onTapGesture { isShowingImagePicker = true }
                    }

                    Button(action: { isShowingImagePicker = true }) {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    .padding(12)
                }
                .padding()
                .sheet(isPresented: $isShowingImagePicker) {
                    LibraryPickerView(sourceType: .photoLibrary, selectedImage: $selectedImage)
                }

                profileField(title: "名前", text: $name)
                profileField(title: "学校", text: $school)
                profileField(title: "仕事", text: $job)
                profileField(title: "趣味", text: $hobby)
                profileField(title: "好きなラッパー", text: $favrapper)

                Button("保存") {
                    Task {
                        guard let userId = Auth.auth().currentUser?.uid else { return }
                        
                        user.id = userId
                        user.name = name
                        user.hobby = hobby
                        user.school = school
                        user.job = job
                        user.favrapper = favrapper

                        if let newImage = selectedImage {
                            let uploadResult = await repository.uploadImage(user: user, image: newImage)
                            if uploadResult.success, let newURL = uploadResult.url {
                                user.imageURL = newURL
                            }
                        } else {
                            user.imageURL = imageURL
                        }
                        
                        await repository.updateUserInfo(user: user)
                        print("✅ User info saved")
                        close = true
                    }
                }
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .frame(width: 120, height: 60)
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .opacity(isPressed ? 0.7 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.5),
                           value: isPressed)
                .padding()
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isPressed = true }
                        .onEnded { _ in isPressed = false }
                )
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
            self.favrapper = user.favrapper
            self.job = user.job
        }
        .fullScreenCover(isPresented: $close) {
            ContentView()
        }
    }

    private func profileField(title: String, text: Binding<String>) -> some View {
        VStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .offset(x: 30)
            
            TextField(title, text: text)
                .font(.system(size: 20, design: .rounded))
                .foregroundColor(.black)
                .offset(x: 30)
            
            Rectangle()
                .frame(width: 305, height: 1)
        }
        .padding()
    }
}

#Preview {
    ProfileEdit()
}
