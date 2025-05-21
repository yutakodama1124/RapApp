//
//  RapperDetailView.swift
//  RapApp
//
//  Created by yuta kodama on 2025/05/21.
//

import SwiftUI

struct RapperDetailView: View {
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

            Spacer()
        }
        .navigationTitle("詳細")
        .padding()
    }
}
#Preview("Authority") {
    RapperDetailView(user: .Empty())
}
