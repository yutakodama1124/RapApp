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
    var body: some Scene {
        WindowGroup {
            if viewModel.isAuthenticated {
                ContentView(viewModel: viewModel)
                    .environment(AuthManager.shared)
                    .onDisappear {
                        
                    }
                    .onAppear {
                        Task {
                            while true {
                                try? await Task.sleep(for: .seconds(5))
                                
                                let db = Firestore.firestore()
                                guard let userId = Auth.auth().currentUser?.uid else { return }
                                
                                if let opponentUser = try? await db.collection("matches").document(userId).getDocument().data(as: User.self) {
                                    print("found match requests")
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
