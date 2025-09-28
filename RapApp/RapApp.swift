import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import AppleSignInFirebase
import FirebaseStorage
import CoreLocation
import Geohash
import MapKit
import Kingfisher

class AppDelegate: NSObject, UIApplicationDelegate {
    private static let COLLECTION = Firestore.firestore().collection("users")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Task { await resetUserLocation() }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Task { await resetUserLocation() }
    }
    
    private func resetUserLocation() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        do {
            try await AppDelegate.COLLECTION.document(userId).setData([
                "latitude": 0,
                "longitude": 0
            ], merge: true)
            print("User location reset to (0, 0)")
        } catch {
            print("Error resetting user location: \(error.localizedDescription)")
        }
    }
}

@main
struct RapAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var viewModel = AuthViewModel()
    @State private var showAcceptView = false
    @State private var showMatchMapView = false
    @State private var matchLatitude: Double = 0.0
    @State private var matchLongitude: Double = 0.0
    @State private var beatindex: Int = 0
    @State private var opponentId: String = ""
    @State private var isPlaying = false
    @State private var isLoadingOpponent = false
    @State private var opponentUser: User?

    
    var body: some Scene {
        WindowGroup {
            if viewModel.isAuthenticated {
                Group {
                    if showAcceptView {
                        if let opponentUser {
                            AcceptView(
                                user: opponentUser,
                                beatindex: beatindex,
                                showAcceptView: $showAcceptView,
                                showMatchMapView: $showMatchMapView,
                                isPlaying: $isPlaying
                            )
                        } else {
                            VStack(spacing: 20) {
                                ProgressView()
                                    .scaleEffect(1.5)
                                Text("対戦相手の情報を取得中...")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white)
                        }
                    } else {
                        ContentView(viewModel: viewModel)
                            .environment(AuthManager.shared)
                    }
                }
                .fullScreenCover(isPresented: $showMatchMapView) {
                    if let opponentUser {
                        MatchMapView(
                            latitude: matchLatitude,
                            longitude: matchLongitude,
                            opponentuser: opponentUser,
                            beatindex: beatindex
                        )
                        .onAppear {
                            print("MatchMapView appeared with Latitude: \(matchLatitude), Longitude: \(matchLongitude), Opponent: \(opponentUser.name)")
                        }
                    } else {
                        VStack {
                            ProgressView("Loading opponent...")
                                .font(.title2)
                            Text("Debug: opponentUser is nil")
                                .foregroundColor(.red)
                        }
                    }
                }
                .task {
                    while true {
                        do {
                            try await Task.sleep(for: .seconds(5))
                            guard let userId = Auth.auth().currentUser?.uid, !isLoadingOpponent else { continue }
                            
                            isLoadingOpponent = true

                            do {
                                let document = try await Firestore.firestore().collection("matches").document(userId).getDocument()
                                let match = try document.data(as: Match.self)
                                print("Found match request")

                                matchLatitude = match.latitude
                                matchLongitude = match.longitude
                                opponentId = match.userAId
                                beatindex = match.selectedBeatIndex
                                
                                if let fetchedOpponent = await UserGateway().fetchUser(userId: opponentId) {
                                    await MainActor.run {
                                        opponentUser = fetchedOpponent
                                        showAcceptView = true
                                    }
                                }
                            } catch {
                                print("No match requests or error: \(error.localizedDescription)")
                            }
                            
                            isLoadingOpponent = false
                        } catch {
                            print("Task sleep error: \(error.localizedDescription)")
                            isLoadingOpponent = false
                            break
                        }
                    }
                }
            } else {
                SignUp(viewModel: viewModel)
                    .environment(AuthManager.shared)
            }
        }
    }
}

struct AcceptView: View {
    let user: User
    let beatindex: Int
    @Binding var showAcceptView: Bool
    @Binding var showMatchMapView: Bool
    @Binding var isPlaying: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    Text("バトルの招待が来ました")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.black)
                        .padding(.top, 60)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                
                VStack(spacing: 25) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("対戦相手")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(.black)
                        
                        HStack(spacing: 15) {
                            KFImage(URL(string: user.imageURL))
                                .placeholder {
                                    Circle()
                                        .fill(LinearGradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 35))
                                                .foregroundColor(.white.opacity(0.7))
                                        )
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.2), radius: 5)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(user.name)
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundStyle(.black)
                                
                                HStack(spacing: 5) {
                                    Text("職業:")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(.gray)
                                    Text(user.job)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.black)
                                }
                                
                                HStack(spacing: 5) {
                                    Text("趣味:")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(.gray)
                                    Text(user.hobby)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.black)
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("バトル詳細")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(.black)
                        
                        Text("８小節　4本")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.black)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("ビート")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(.black)
                        
                        HStack(spacing: 15) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("バトルビートを再生")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundStyle(.black)
                                Text(isPlaying ? "再生中..." : "タップして再生")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    if BeatsGateway.isPlaying() {
                                        BeatsGateway.stopBeat()
                                        isPlaying = false
                                    } else {
                                        BeatsGateway.playBeat(at: beatindex)
                                        isPlaying = true
                                    }
                                }
                            } label: {
                                Circle()
                                    .fill(LinearGradient(
                                        colors: isPlaying ? [Color.red, Color.orange] : [Color.black, Color.gray.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 5)
                                    .scaleEffect(isPlaying ? 1.1 : 1.0)
                            }
                        }
                        
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8)
                    
                    HStack(spacing: 15) {
                        Button {
                            Task {
                                guard let userId = Auth.auth().currentUser?.uid else { return }
                                try? await Firestore.firestore().collection("matches").document(userId).delete()
                                showAcceptView = false
                            }
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .bold))
                                Text("拒否")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(LinearGradient(colors: [Color.red, Color.red.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .shadow(color: .red.opacity(0.4), radius: 10)
                        }
                        
                        Button {
                            Task {
                                guard let userId = Auth.auth().currentUser?.uid else { return }
                                try? await Firestore.firestore().collection("matches").document(userId).setData(["accepted": true], merge: true)
                                await MainActor.run {
                                    showAcceptView = false
                                    showMatchMapView = true
                                }
                            }
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 18, weight: .bold))
                                Text("受諾")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(LinearGradient(colors: [Color.green, Color.green.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .shadow(color: .green.opacity(0.4), radius: 10)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .background(Color.white)
        .ignoresSafeArea(.all, edges: .top)
    }
    
}
