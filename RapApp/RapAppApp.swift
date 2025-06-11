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


class AppDelegate: NSObject, UIApplicationDelegate {
    
    private let COLLECTION = Firestore.firestore().collection("users")
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
        func updateUserInfo(user: User) async -> Bool {
            do {
                try await COLLECTION.document(user.id!).setData([
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
            } else {
                SignUp(viewModel: viewModel)
                    .environment(AuthManager.shared)
            }
        }
    }
}
