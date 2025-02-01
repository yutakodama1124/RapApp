//
//  ContentView.swift
//  RapApp
//
//  Created by yuta kodama on 2024/06/12.
//

import SwiftUI

struct ContentView: View {
    
    var viewModel: AuthViewModel
    
    var body: some View {
        
        TabView{
            MapView()
                .tabItem {
                    Label(
                        "Map",
                        systemImage: "map.circle.fill"
                    )
                    
                }
            Profile() //2枚目の子ビュー
                .tabItem {
                    Label(
                        "Profile",
                        systemImage: "person.circle"
                    ) //タブバーの②
                }
            ProfileEdit()
                .tabItem {
                    Label(
                        "Map",
                        systemImage: "map.circle.fill"
                    )
                    
                }
        }
    }
}
#Preview {
    ContentView(viewModel: AuthViewModel())
}
