//
//  ThankYou.swift
//  RapApp
//
//  Created by yuta kodama on 2024/06/19.
//

import SwiftUI

struct ThankYou: View {
    @State var homeView = false
    
    var body: some View {
        
        VStack(spacing: 60) {
            Text("バトル終了")
                .foregroundStyle(.black)
                .font(.system(size: 30, weight: .black, design: .rounded))
            
            Text("23回目のバトル終了おめでとうございます！！")
                .frame(width: 300)
                .foregroundStyle(.black)
                .font(.system(size: 20, weight: .black, design: .rounded))
            
            Button(action: {
                
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
}
#Preview {
    ThankYou()
}
