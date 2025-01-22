//
//  ThankYou.swift
//  RapApp
//
//  Created by yuta kodama on 2024/06/19.
//

import SwiftUI

struct Battle: View {
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
