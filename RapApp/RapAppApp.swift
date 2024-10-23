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
