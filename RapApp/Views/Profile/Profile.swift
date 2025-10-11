import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Kingfisher

struct Profile: View {
    @State private var currentUser: User? = nil
    @State private var isLoading = true
    @State private var nextShown = false
    @State private var isPressed = false
    
    private let gateway = UserGateway()
    
    var body: some View {
        ScrollView {
            if let user = currentUser {
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        KFImage(URL(string: user.imageURL))
                            .placeholder { _ in
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.black.opacity(0.3), Color.gray.opacity(0.3)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 80))
                                            .foregroundColor(.white.opacity(0.7))
                                    )
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: 350)
                            .clipped()
                        
                        LinearGradient(
                            gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]),
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .frame(height: 150)
                    }

                    VStack(spacing: 25) {
                        Text(user.name)
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                        
                        profileDetailCard(title: "学校", value: user.school, icon: "graduationcap.fill")
                        profileDetailCard(title: "職業", value: user.job, icon: "briefcase.fill")
                        profileDetailCard(title: "趣味", value: user.hobby, icon: "heart.fill")
                        profileDetailCard(title: "好きなラッパー", value: user.favrapper, icon: "music.note")
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                    .padding(.bottom, 30)

                    VStack {
                        Button {
                            nextShown = true
                        } label: {
                            Text("編集")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 65)
                                .background(Color.black)
                                .clipShape(RoundedRectangle(cornerRadius: 32))
                                .shadow(color: .black.opacity(0.4), radius: 15, x: 0, y: 8)
                                .scaleEffect(isPressed ? 0.95 : 1.0)
                                .opacity(isPressed ? 0.7 : 1.0)
                                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isPressed)
                        }
                        .padding(.horizontal, 20)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in isPressed = true }
                                .onEnded { _ in isPressed = false }
                        )
                    }
                    .padding(.bottom, 40)
                }
            } else if isLoading {
                VStack(spacing: 20) {
                    ProgressView()
                    Text("プロフィールを読み込み中...")
                        .foregroundColor(.gray)
                }
                .padding(.top, 100)
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "person.fill.questionmark")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("ユーザー情報が見つかりません")
                        .foregroundColor(.gray)
                }
                .padding(.top, 100)
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .fullScreenCover(isPresented: $nextShown) {
            ProfileEdit()
        }
        .task {
            isLoading = true
            currentUser = await gateway.getSelf()
            isLoading = false
        }
    }
    
    private func profileDetailCard(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 20) {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.4), Color.gray.opacity(0.5)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                
                Text(value.isEmpty ? "未設定" : value)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    Profile()
}
