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
    
    var body: some Scene {
        WindowGroup {
            if viewModel.isAuthenticated {
                Group {
                    if showAcceptView {
                        Text("request")
                        
                        Button("accept") {
                            Task {
                                let db = Firestore.firestore()
                                guard let userId = Auth.auth().currentUser?.uid else { return }
                                
                                try? db.collection("matches").document(userId).setData([
                                    "accepted": true], merge: true)
                                
                                showAcceptView = false
                                MatchMapView = true
                            }
                        }
                        
                        Button("reject") {
                            Task {
                                let db = Firestore.firestore()
                                guard let userId = Auth.auth().currentUser?.uid else { return }
                                
                                try? db.collection("matches").document(userId).delete()
                                
                                showAcceptView = false
                            }
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
