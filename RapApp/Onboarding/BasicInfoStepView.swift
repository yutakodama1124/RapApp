import SwiftUI

struct BasicInfoStepView: View {
    @Binding var name: String
    @Binding var school: String
    @Binding var job: String
    @Binding var selectedImage: UIImage?
    @Binding var showImagePicker: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("プロフィール設定")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.top, 20)

                ZStack(alignment: .bottomTrailing) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 290, height: 350)
                            .clipShape(Rectangle())
                            .cornerRadius(25)
                            .onTapGesture { showImagePicker = true }
                    } else {
                        Rectangle()
                            .fill(Color.black.opacity(0.1))
                            .frame(width: 290, height: 350)
                            .cornerRadius(25)
                            .overlay(
                                Text("写真を選択")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, design: .rounded))
                            )
                            .onTapGesture { showImagePicker = true }
                    }
                    
                    Button(action: { showImagePicker = true }) {
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

                profileField(title: "名前 *", text: $name)
                profileField(title: "学校 *", text: $school)
                profileField(title: "仕事 *", text: $job)
                
                Spacer()
            }
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
