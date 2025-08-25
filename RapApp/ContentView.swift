//
//  ContentView.swift
//  RapApp
//
//  Created by yuta kodama on 2024/06/12.
//

import SwiftUI
import AppleSignInFirebase

struct ContentView: View {
    @StateObject var viewModel = AuthViewModel()

    var body: some View {
        if viewModel.isAuthenticated {
            TabView {
               HomeView()
                    .tabItem {
                        Label("ホーム", systemImage: "house.fill")
                    }

                Profile()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
            }
            .environmentObject(viewModel)
        } else {
            SignUp(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
