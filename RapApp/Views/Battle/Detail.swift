//
//  Detail.swift
//  RapApp
//
//  Created by yuta kodama on 2024/06/19.
//

import SwiftUI

struct Detail: View {
    @State var nextView = false
    @State var isPlaying = false
    
    let musicplayer = SoundPlayer()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    Text("バトル情報")
                        .foregroundStyle(.black)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .padding(.top, 60)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                
                VStack(spacing: 25) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("対戦相手")
                            .foregroundStyle(.black)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        
                        HStack(spacing: 15) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 35))
                                        .foregroundColor(.white)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("児玉勇太")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                
                                HStack(spacing: 5) {
                                    Text("職業:")
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 16, weight: .medium))
                                    Text("プロサッカー選手")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                
                                HStack(spacing: 5) {
                                    Text("趣味:")
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 16, weight: .medium))
                                    Text("勉強")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .frame(maxWidth: .infinity, minHeight: 100)

                    VStack(spacing: 15) {
                        Text("バトル詳細")
                            .foregroundStyle(.black)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        
                        Text("８小節　２本")
                            .foregroundStyle(.black)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("ビート")
                            .foregroundStyle(.black)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        
                        HStack(spacing: 15) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("バトルビートを再生")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                Text(isPlaying ? "再生中..." : "タップして再生")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 14))
                            }
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    if isPlaying {
                                        Task { musicplayer.stopAllMusic() }
                                        isPlaying = false
                                    } else {
                                        Task { musicplayer.musicPlayer() }
                                        isPlaying = true
                                    }
                                }
                            } label: {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: isPlaying ? [Color.red, Color.orange] : [Color.black, Color.gray.opacity(0.8)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                                    .scaleEffect(isPlaying ? 1.1 : 1.0)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    
                    Button {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            nextView = true
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 20, weight: .bold))
                            Text("バトル開始!")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .padding(.top, 10)
                    .scaleEffect(nextView ? 0.95 : 1.0)
                    
                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .background(Color.white)
        .ignoresSafeArea(.all, edges: .top)
        .fullScreenCover(isPresented: $nextView) {
            Battle()
        }
    }
}

#Preview {
    Detail()
}
