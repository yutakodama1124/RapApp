//
//  EvaluationListCell.swift
//  RapApp
//
//  Created by yuta kodama on 2025/09/22.
//
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Kingfisher


struct EvaluationListCell: View {
    
    let user: User
    let rate: Rate
    
    
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                KFImage(URL(string: user.imageURL))
                    .placeholder {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 64, height: 64)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 35))
                                    .foregroundColor(.white.opacity(0.7))
                            )
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 5)
                
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(user.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                }
                
                Spacer()

                HStack(spacing: 2) {
                    Text("\(Double(rate.rhyme + rate.flow + rate.verse) / 3.0)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text("/5.0")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("韻")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("\(rate.rhyme)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 4) {
                    Text("フロー")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("\(rate.flow)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 4) {
                    Text("バース")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("\(rate.verse)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    EvaluationListCell(user: .Empty(), rate: .Empty())
}
