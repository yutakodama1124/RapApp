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
        VStack(spacing: 30) {
            Text("バトル情報")
                .foregroundStyle(.black)
                .font(.system(size: 30, weight:
                        .bold, design: .rounded))
            
            VStack {
                Text("対戦相手")
                    .foregroundStyle(.gray)
                    .font(.system(size: 20, weight:
                            .heavy, design: .rounded))
                HStack {
                    Image(systemName: "person.circle")
                        .font(.system(size: 30))
                    
                    Text("児玉勇太")
                        .foregroundStyle(.black)
                        .font(.system(size: 25, weight:
                                .heavy, design: .rounded))
                }
            }
            
            VStack {
                Text("バトル詳細")
                    .foregroundStyle(.gray)
                    .font(.system(size: 20, weight:
                            .heavy, design: .rounded))
                
                Text("８小節　２本")
                    .foregroundStyle(.black)
                    .font(.system(size: 25, weight:
                            .heavy, design: .rounded))
            }
            VStack {
                Text("ビート")
                    .foregroundStyle(.gray)
                    .font(.system(size: 20, weight:
                            .heavy, design: .rounded))
                
                HStack {
                    Text("バトルビートを再生")
                        .foregroundStyle(.black)
                        .font(.system(size: 25, weight:
                                .heavy, design: .rounded))
                    
                    Button
                    {
                        if isPlaying {
                            Task { musicplayer.stopAllMusic()
                            }
                            isPlaying = false
                        } else {
                            Task{
                                musicplayer.musicPlayer()
                            }
                            isPlaying = true
                        }
                        
                    } label: {
                        if isPlaying {
                            Image(systemName: "pause.circle")
                                .font(.system(size: 30))
                        } else {
                            Image(systemName: "play.circle")
                                .font(.system(size: 30))
                        }
                    }
                    .accentColor(Color.white)
                    .background(Color.black)
                    .cornerRadius(60)
                    .fullScreenCover(isPresented: $nextView) {
                        Battle()
                    }
                }
            }
            
            Button
            {
                Task{
                    nextView = true
                }
                
            } label: {
                Text("Battle!")
                    .font(.system(size: 25, weight:
                            .medium, design: .rounded))
                    .frame(width: 120, height: 60)
            }
            .accentColor(Color.white)
            .background(Color.black)
            .cornerRadius(60)
            .padding(15)
            .fullScreenCover(isPresented: $nextView) {
                Battle()
            }
        }
    }
}
#Preview {
    Detail()
}
