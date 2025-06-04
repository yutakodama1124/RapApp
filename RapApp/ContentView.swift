//
//  ContentView.swift
//  RapApp
//
//  Created by yuta kodama on 2024/06/12.
//

import SwiftUI
import AppleSignInFirebase

struct ContentView: View {
    @StateObject var viewModel = AuthViewModel() // Create AuthViewModel here

    var body: some View {
        if viewModel.isAuthenticated {
            TabView {
                RapperListView()
                    .tabItem {
                        Label("Nearby Users", systemImage: "person.3.fill")
                    }
                MapView()
                    .tabItem {
                        Label("Map", systemImage: "map.circle.fill")
                    }
                ProfileEdit()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
            }
            .environmentObject(viewModel) // Inject AuthViewModel
        } else {
            SignUp(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
