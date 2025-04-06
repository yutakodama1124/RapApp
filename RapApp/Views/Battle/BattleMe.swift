//
//  BattleMe.swift
//  RapApp
//
//  Created by yuta kodama on 2025/02/26.
//

import SwiftUI

struct BattleMe: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                // Profile Image
                Image("profile_pic") // Replace with actual image name
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.horizontal, 10)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                // Name and Age
                Text("Matylda, 26")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Job Information
                HStack {
                    Image(systemName: "briefcase.fill")
                        .foregroundColor(.gray)
                    Text("Product Designer @ Asos")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Location
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.gray)
                    Text("London, UK")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Distance
                Text("1 mile away")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Additional details
                Text("5'10\"  •  Caucasian  •  Socially  •  Relationship")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                // Spotify Artists Section
                Text("My top Spotify artists")
                    .font(.headline)
                    .padding(.top, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<4) { _ in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 80, height: 100)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(radius: 10)
            .padding(.horizontal, 10)
            
            // Tinder-style buttons
            HStack(spacing: 30) {
                Button(action: {}) {
                    Image(systemName: "xmark")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.red)
                        .padding()
                        .background(Circle().fill(Color.white))
                        .shadow(radius: 5)
                }
                
                Button(action: {}) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.blue)
                        .padding()
                        .background(Circle().fill(Color.white))
                        .shadow(radius: 5)
                }
                
                Button(action: {}) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.green)
                        .padding()
                        .background(Circle().fill(Color.white))
                        .shadow(radius: 5)
                }
            }
            .padding(.bottom, 30)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    BattleMe()
}
