import SwiftUI
import MapKit
import Kingfisher

struct MatchMapView: View {
    let latitude: Double
    let longitude: Double
    let opponentuser: User
    
    @State private var currentUser: User? = nil
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var battleview = false
    
    private let gateway = UserGateway()
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            if isLoading {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("ユーザーデータを読み込み中...")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = errorMessage {
                VStack(spacing: 20) {
                    Text("エラー")
                        .font(.title)
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    Button("再試行") {
                        Task { await loadCurrentUser() }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding()
            } else if let user = currentUser {
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        Text("バトル")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundStyle(Color.black)
                        
                        Text("相手を探そう！")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black.opacity(0.8))
                            .tracking(2)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                    
                    Map {
                        UserAnnotation()
                        
                        Annotation(opponentuser.name.isEmpty ? "不明な相手" : opponentuser.name,
                                 coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.black, .gray],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 60, height: 60)
                                    .shadow(color: .cyan.opacity(0.6), radius: 8, x: 0, y: 0)
                                
                                KFImage(URL(string: opponentuser.imageURL))
                                    .placeholder {
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 24, weight: .bold))
                                    }
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            .scaleEffect(1.1)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: true)
                        }
                    }
                    .mapStyle(.standard(elevation: .realistic))
                    .frame(height: 520)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 15)
                    
                    VStack(spacing: 12) {
                        HStack(spacing: 16) {
                            Text(user.name.isEmpty ? "不明" : user.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.cyan)
                            
                            Text("VS")
                                .font(.title2)
                                .fontWeight(.black)
                                .foregroundColor(.gray)
                            
                            Text(opponentuser.name.isEmpty ? "不明な相手" : opponentuser.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        .padding(.horizontal, 32)
                        
                        Button(action: {
                            battleview = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 18, weight: .bold))
                                Text("バトル開始！")
                                    .font(.headline)
                                    .fontWeight(.black)
                                    .tracking(1)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.black)
                            .cornerRadius(28)
                            .shadow(color: .cyan.opacity(0.4), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
                .fullScreenCover(isPresented: $battleview) {
                    Battle()
                }
            } else {
                VStack {
                    Text("ユーザーデータが見つかりませんでした")
                        .font(.title)
                        .foregroundColor(.gray)
                    Button("再試行") {
                        Task { await loadCurrentUser() }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
        }
        .task {
            await loadCurrentUser()
        }
    }
    
    private func loadCurrentUser() async {
        isLoading = true
        errorMessage = nil
        do {
            if let user = await gateway.getSelf() {
                currentUser = user
            } else {
                errorMessage = "ユーザーデータが見つかりませんでした。"
            }
        } catch {
            errorMessage = "データの取得に失敗しました: \(error.localizedDescription)"
            print("Error fetching currentUser: \(error.localizedDescription)")
        }
        isLoading = false
    }
}

#Preview {
    MatchMapView(
        latitude: 35.0,
        longitude: 135.0,
        opponentuser: .Empty()
    )
}
