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
            Profile()
                .tabItem {
                    Label(
                        "Profile",
                        systemImage: "person.circle"
                    ) 
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
