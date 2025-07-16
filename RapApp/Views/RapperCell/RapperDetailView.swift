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
    
    @State var isMapShown = false

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
                    
                    let m = Match(id: user.id, userAId: userId, latitude: location?.coordinate.latitude ?? 0, longitude: location?.coordinate.longitude ?? 0, accepted: false)
                    
                    try? db.collection("matches").document(user.id ?? "").setData(from: m)
                    
                    
                    
                    Task {
                        let db = Firestore.firestore()
                        
                        while true {
                            do {
                                let document = try await db.collection("matches").document(user.id!).getDocument()
                                
                                if document.exists {
                                    let boolvalue = document.data()?["accepted"] as? Bool ?? false
                                    
                                    if boolvalue {
                                        
                                        print("accepted")
                                    } else {
                                        print("pending")
                                    }
                                } else {
                                    print("declined")
                                }
                            } catch {
                                print("Error: \(error)")
                            }
                            
                            try? await Task.sleep(for: .seconds(1))
                        }
                    }
                }
            }

            Spacer()
        }
        .navigationTitle("詳細")
        .padding()
        .fullScreenCover(isPresented: $isMapShown) {
            OpponentWaitView()
        }
    }
}
#Preview("Authority") {
    RapperDetailView(user: .Empty())
}
