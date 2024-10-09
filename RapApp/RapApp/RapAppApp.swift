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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    static func getUser() async -> User {
        if let user = try? await Firestore
            .firestore()
            .collection("users")
            .document(Auth.auth().currentUser!.uid)
            .getDocument()
            .data(as: User.self) {
            return user
        } else {
            let user: User = .Empty()
            await setUser(
                user: user
            )
            return user
        }
    }
    
    static func setUser(user: User) async {
        let userID = Auth.auth().currentUser!.uid
        try! Firestore.firestore().collection("users").document(userID).setData(from: user)
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
             } else {
                 SignUp(viewModel: viewModel)
             }
        }
    }
}
