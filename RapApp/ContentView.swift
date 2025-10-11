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
                
                RapEvaluationList()
                    .tabItem{
                        Label("評価", systemImage: "list.bullet")
                    }
                
                AudioMap()
                    .tabItem{
                        Label("マップ", systemImage: "map.circle")
                    }

                Profile()
                    .tabItem {
                        Label("プロフィール", systemImage: "person.circle")
                    }
            }
            .environmentObject(viewModel)
        } else {
            SignUp(viewModel: viewModel, onboardingManager: OnboardingManager())
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
