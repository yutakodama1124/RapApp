//
//  RapAppApp.swift
//  RapApp
//
//  Created by yuta kodama on 2024/06/12.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import AppleSignInFirebase
import FirebaseStorage
import Foundation
import CoreLocation
import Geohash
import MapKit
import UIKit
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        
        return true
    }
    
    private static let COLLECTION = Firestore.firestore().collection("users")
    
    func applicationWillTerminate(_ application: UIApplication) {
        func updateUserInfo(user: User) async -> Bool {
            do {
                try await AppDelegate.COLLECTION.document(user.id!).setData([
                    "latitude": 0,
                    "longitude": 0
                ], merge: true)
                print("User information successfully updated: \(user)")
                return true
            } catch {
                print("Error updating user information: \(error.localizedDescription)")
                return false
            }
        }
        
    }
}


@main
struct RapAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthViewModel()
    @State var showAcceptView = false
    @State var MatchMapView = false
    
    @State var matchLatitude: Double = 0.0
    @State var matchLongitude: Double = 0.0
    @State var opponentId: String = ""
    @State var isPlaying = false
    
    let musicplayer = SoundPlayer()
    
    @State var opponentUser: User?
    
    var body: some Scene {
        WindowGroup {
            if viewModel.isAuthenticated {
                Group {
                    if showAcceptView {
                        if let opponentUser {
                            AcceptView (user: opponentUser, musicplayer: musicplayer, showAcceptView: $showAcceptView, MatchMapView: $MatchMapView, isPlaying: $isPlaying)
                        }
                    } else {
                        ContentView(viewModel: viewModel)
                            .environment(AuthManager.shared)
                            .onDisappear {
                                
                            }
                    }
                }
                .fullScreenCover(isPresented: $MatchMapView) {
                    RapApp.MatchMapView(latitude: matchLatitude, longitude: matchLongitude)
                }
                .onAppear {
                    Task {
                        while true {
                            try? await Task.sleep(for: .seconds(5))
                            
                            let db = Firestore.firestore()
                            guard let userId = Auth.auth().currentUser?.uid else { return }
                            
                            print(userId)
                            let a = try! await db.collection("matches").document(userId).getDocument().data()
                            if let match = try? await db.collection("matches").document(userId).getDocument().data(as: Match.self) {
                                print("found match requests")
                                
                                showAcceptView = true
                                
                                if let data = try? await db.collection("matches").document(userId).getDocument() {
                                    matchLatitude = data["latitude"] as? Double ?? 0.0
                                    matchLongitude = data["longitude"] as? Double ?? 0.0
                                    opponentId = data["userAId"] as? String ?? ""
                                }
                                
                                Task {
                                    opponentUser = await UserGateway().fetchUser(userId: opponentId)
                                }
                                
                                
                            } else {
                                print("no match requests")
                            }
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
    let musicplayer: SoundPlayer
    @Binding var showAcceptView: Bool
    @Binding var MatchMapView: Bool
    @Binding var isPlaying: Bool
//
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    Text("バトルの招待が来ました")
                        .foregroundStyle(.black)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .padding(.top, 60)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
//                
                VStack(spacing: 25) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("対戦相手")
                            .foregroundStyle(.black)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        
                        HStack(spacing: 15) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: user.imageURL)
                                        .font(.system(size: 35))
                                        .foregroundColor(.white)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
//                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(user.name)
                                    .foregroundStyle(.black)
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                
                                HStack(spacing: 5) {
                                    Text("職業:")
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 16, weight: .medium))
                                    Text(user.job)
                                        .foregroundStyle(.black)
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                
                                HStack(spacing: 5) {
                                    Text("趣味:")
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 16, weight: .medium))
                                    Text(user.hobby)
                                        .foregroundStyle(.black)
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .frame(maxWidth: .infinity, minHeight: 100)
                    
                    VStack(spacing: 15) {
                        Text("バトル詳細")
                            .foregroundStyle(.black)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        
                        Text("８小節　２本")
                            .foregroundStyle(.black)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
//                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("ビート")
                            .foregroundStyle(.black)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        
                        HStack(spacing: 15) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("バトルビートを再生")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                Text(isPlaying ? "再生中..." : "タップして再生")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 14))
                            }
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    if isPlaying {
                                        Task { musicplayer.stopAllMusic() }
                                        isPlaying = false
                                    } else {
                                        Task { musicplayer.musicPlayer() }
                                        isPlaying = true
                                    }
                                }
                            } label: {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: isPlaying ? [Color.red, Color.orange] : [Color.black, Color.gray.opacity(0.8)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                                    .scaleEffect(isPlaying ? 1.1 : 1.0)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
//                    
                    HStack(spacing: 15) {
//                        // Reject Button
                        Button {
                            Task {
                                let db = Firestore.firestore()
                                guard let userId = Auth.auth().currentUser?.uid else { return }

                                try? db.collection("matches").document(userId).delete()
                                
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
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.red, Color.red.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .shadow(color: .red.opacity(0.4), radius: 10, x: 0, y: 5)
                        }
//                        
                        // Accept Button
                        Button {
                            Task {
                                let db = Firestore.firestore()
                                guard let userId = Auth.auth().currentUser?.uid else { return }
                                
                                try? db.collection("matches").document(userId).setData([
                                    "accepted": true], merge: true)

                                MatchMapView = true
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
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .shadow(color: .green.opacity(0.4), radius: 10, x: 0, y: 5)
                        }
                        
                    }
                    .padding(.top, 10)
                    
                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .background(Color.white)
        .ignoresSafeArea(.all, edges: .top)
    }
}
