import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Kingfisher

struct RapBattleEvaluationView: View {
    let user: User
    let rate: Rate
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("バトル評価")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                VStack(spacing: 0) {
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
                            Text(user.name)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            
                            Text("からの評価")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(24)
                }
                .background(Color.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )

                VStack(spacing: 32) {
                    Text("評価スコア")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    HStack(spacing: 24) {
                        VStack(spacing: 12) {
                            Text("韻")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                            
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text("\(rate.rhyme)")
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("/ 5")
                                    .font(.title)
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                        }

                        VStack(spacing: 12) {
                            Text("フロー")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                            
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text("\(rate.flow)")
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("/ 5")
                                    .font(.title)
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                        }

                        VStack(spacing: 12) {
                            Text("バース")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                            
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text("\(rate.verse)")
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("/ 5")
                                    .font(.title)
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                        }
                    }

                    VStack(spacing: 8) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                        
                        Text("総合スコア")
                            .font(.body)
                            .foregroundColor(.gray)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            let averageScore = Double(rate.rhyme + rate.flow + rate.verse) / 3.0
                            Text("\(averageScore, specifier: "%.1f")")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("/5.0")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(32)
                .background(Color.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )

                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 8) {
                        Image(systemName: "message.circle")
                            .foregroundColor(.blue)
                            .font(.title2)
                        
                        Text("コメント")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    
                    Text(rate.comment)
                        .font(.body)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color.gray.opacity(0.05))
    }
}

struct RapBattleEvaluationView_Previews: PreviewProvider {
    static var previews: some View {
        RapBattleEvaluationView(user: .Empty(), rate: .Empty())
    }
}
