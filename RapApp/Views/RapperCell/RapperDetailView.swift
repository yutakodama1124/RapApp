import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Kingfisher

struct RapperDetailView: View {
    
    @StateObject private var locationManager = LocationManager()
    let user: User
    @State var isMapShown = false
    
    var body: some View {
        ScrollView {
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
                }

                VStack(spacing: 0) {
                    Button {
                        Task {
                            guard let userId = Auth.auth().currentUser?.uid else { return }
                            
                            let db = Firestore.firestore()
                            
                            
                            let location = locationManager.lastLocation
                            
                            let m = Match(id: user.id, userAId: userId, latitude: location?.coordinate.latitude ?? 0, longitude: location?.coordinate.longitude ?? 0, accepted: false)
                            
                            try? db.collection("matches").document(user.id ?? "").setData(from: m)
                            
                            
                            
                            Task {
                                let db = Firestore.firestore()
                                
                                while true {
                                    do {
                                        let document = try await db.collection("matches").document(user.id!).getDocument()
                                        
                                        if document.exists {
                                            let boolvalue = document.data()?["accepted"] as? Bool ?? false
                                            
                                            if boolvalue {
                                                
                                                print("accepted")
                                            } else {
                                                print("pending")
                                            }
                                        } else {
                                            print("declined")
                                        }
                                    } catch {
                                        print("Error: \(error)")
                                    }
                                    
                                    try? await Task.sleep(for: .seconds(1))
                                }
                            }
                        }
                    } label: {
                        Text("マッチ！")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 65)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                            .shadow(color: .black.opacity(0.4), radius: 15, x: 0, y: 8)
                    }
                    .padding(.horizontal, 20)
                    .zIndex(1)
                    
                }
                .background(Color.gray.opacity(0.05))
        }
        .ignoresSafeArea(.all, edges: .top)
        .navigationTitle("")
            .fullScreenCover(isPresented: $isMapShown) {
                Detail(opponentUser: user)
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
    RapperDetailView(user: .Empty())
}
