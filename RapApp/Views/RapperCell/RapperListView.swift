//
//  RapperListView.swift
//  RapApp
//
//  Created by yuta kodama on 2025/05/14.
//

import SwiftUI
import FirebaseAuth

struct RapperListView: View {
    
    @State private var nearbyUsers: [User] = []

    var body: some View {
        NavigationView {
            List(nearbyUsers) { user in
                NavigationLink(destination: RapperDetailView(user: user)) {
                    RapperCellView(user: user)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Nearby Users")
            .task {
                let currentUser = Auth.auth().currentUser?
                // Fetch nearby users when view loads
                let filtered = await UserGateway().getNearUser(user: currentUser)
                self.nearbyUsers = filtered
            }
        }
    }
}

#Preview {
    RapperListView()
}
