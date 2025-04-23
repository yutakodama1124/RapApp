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
            // User image
            AsyncImage(url: URL(string: user.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            
            // User name
            Text(user.name)
                .font(.subheadline)
                .lineLimit(1)
                .frame(width: 90)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

#Preview {
    UserNearCell(user: .Empty())
}
