//
//  UserNearCell.swift
//  RapApp
//
//  Created by yuta kodama on 2025/01/22.
//

import SwiftUI

struct UserNearCell: View {
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.circle")
                .font(.system(size: 70))
                        .scaledToFit()
                        .frame(width: 90, height: 90)

                   
                    Text("Yuta K")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
        .frame(width: 110, height: 140)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 15)
                    .stroke(.black, lineWidth: 3))
    }
}

#Preview {
    UserNearCell()
}
