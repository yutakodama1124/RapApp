//
//  UserNearCell.swift
//  RapApp
//
//  Created by yuta kodama on 2025/01/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct UserNearCell: View {
    let user: User
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user.imageURL)) { image in
                image.resizable()
                     .aspectRatio(contentMode: .fill)
                     .frame(width: 100, height: 100)
                     .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            
            Text(user.name)
                .font(.headline)
                .lineLimit(1)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    }

#Preview {
    UserNearCell(user: .Empty())
}
