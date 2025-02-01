//
//  ThankYou.swift
//  RapApp
//
//  Created by yuta kodama on 2024/06/19.
//

import SwiftUI

struct Battle: View {
    
    @State var isplaying = false
    @State var nextview = false
    
    let musicplayer = SoundPlayer()
    var body: some View {
        VStack {
            Text("先攻")
                .font(
                    .system(
                        size: 50,
                        weight: .black,
                        design: .rounded
                    )
                )
            
            Image(systemName: "person.circle")
                .font(.system(size: 120))
            
            Text("Yuta Kodama")
                .font(.system(size: 30, weight: .medium, design: .rounded))
        }
        .onAppear() {
            Task {
                try? await Task.sleep(for: .seconds(4))
                await musicplayer.musicPlayer()
                isplaying = true
            }
            Task {
                try? await Task.sleep(for: .seconds(140))
                nextview = true
            }
        }
        .fullScreenCover(isPresented: $nextview) {
           ThankYou()
        }
        
        Spacer().frame(height: 140)
        
        VStack {
            Text("後攻")
                .font(.system(size: 50, weight: .black, design: .rounded))
            
            Image(systemName: "person.circle")
                .font(.system(size: 120))
            
            Text("Kai Kodama")
                .font(.system(size: 30, weight: .medium, design: .rounded))
        }
    }
}


#Preview {
    Battle()
}
