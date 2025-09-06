//
//  ThankYou.swift
//  RapApp
//
//  Created by yuta kodama on 2024/06/19.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct ThankYou: View {
    
    @State var homeView = false
    @State var currentUser: User? = nil
    private let gateway = UserGateway()
    
    var body: some View {
        
        VStack(spacing: 60) {
            if let user = currentUser {
                Text("バトル終了")
                    .foregroundStyle(.black)
                    .font(.system(size: 30, weight: .black, design: .rounded))
                HStack {
                    Text("\(user.battleCount + 1)" + "回目のバトル終了おめでとうございます！")
                        .frame(width: 300)
                        .foregroundStyle(.black)
                        .font(.system(size: 20, weight: .black, design: .rounded))
                }
                Button(action: {
                    Task {
                        let success = await gateway.incrementBattleCount()
                        if success {
                            print("Battle count updated!")
                        } else {
                            print("Failed to update battle count")
                        }
                    }
                    
                    Task {
                        guard let userId = Auth.auth().currentUser?.uid else { return }
                        try? await Firestore.firestore().collection("matches").document(userId).delete()
                    }

                    
                    
                    homeView = true
                    
                }) {
                    Text("ホーム")
                        .frame(width: 150, height: 60)
                }
                .accentColor(Color.white)
                .background(Color.black)
                .cornerRadius(60)
                .fullScreenCover(isPresented: $homeView) {
                    ContentView(viewModel: AuthViewModel())
                }
            }
        }
        .task { currentUser = await gateway.getSelf()}
    }
}
#Preview {
    ThankYou()
}
