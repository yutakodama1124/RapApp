//
//  RapperDetailView.swift
//  RapApp
//
//  Created by yuta kodama on 2025/05/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct RapperDetailView: View {
    
    @StateObject private var locationManager = LocationManager()
    let user: User

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()

            Text(user.name)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(user.job)
                .font(.title2)

            Text((user.favrapper))
                .font(.title3)
                .padding(.top)
            
            Button("match") {
                Task {
                    guard let userId = Auth.auth().currentUser?.uid else { return }
                    
                    let db = Firestore.firestore()
                    
                    
                    let location = locationManager.lastLocation
                    
                    let m = match(id: user.id, userAId: userId, latitude: location?.coordinate.latitude ?? 0, longitude: location?.coordinate.longitude ?? 0, accepted: false)
                    
                    try? db.collection("mathces").document(user.id ?? "").setData(from: m)
                }
            }

            Spacer()
        }
        .navigationTitle("詳細")
        .padding()
    }
}
#Preview("Authority") {
    RapperDetailView(user: .Empty())
}
