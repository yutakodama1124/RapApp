//
//  Profile.swift
//  RapApp
//
//  Created by yuta kodama on 2024/06/12.
//

import SwiftUI

struct Profile: View {
    var body: some View {
        ScrollView {
            VStack {
                Rectangle()
                    .fill(Color.gray)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.black, lineWidth: 5))
                    .frame(width: 350, height: 350)
                    .cornerRadius(30)
                
                HStack(spacing: 35) {
                    
                    VStack {
                        Text("歴")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                        
                        Text("3年")
                            .font(.system(size: 30, weight: .heavy, design: .rounded))
                    }
                    
                    VStack {
                        Text("バトル数")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                        
                        Text("30")
                            .font(.system(size: 30, weight: .heavy, design: .rounded))
                    }
                    
                    
                    VStack {
                        Text("年齢")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                        
                        Text("15")
                            .font(.system(size: 30, weight: .heavy, design: .rounded))
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.black, lineWidth: 7))
                .background(.white)
                .cornerRadius(16)
                .offset(y: -60)
            }
            
            VStack {
                
                Text("Yuta Kodama")
                    .font(.system(size: 36, weight:
                            .heavy, design: .rounded))
                
                Spacer(minLength: 30)
                
                HStack {
                    Text("職業：")
                        .font(.system(size: 30, weight: .medium, design: .rounded))
                    
                    Text("teacher")
                        .font(.system(size: 30, weight: .medium, design: .rounded))
                }
                Spacer(minLength: 30)
                
                HStack {
                    Text("学校：")
                        .font(.system(size: 30, weight: .medium, design: .rounded))
                    
                    Text("広尾小石川")
                        .font(.system(size: 30, weight: .medium, design: .rounded))
                }
                Spacer(minLength: 30)
                
                HStack {
                    Text("趣味：")
                        .font(.system(size: 30, weight: .medium, design: .rounded))
                    
                    Text("ラップバトル")
                        .font(.system(size: 30, weight: .medium, design: .rounded))
                }
                Spacer(minLength: 30)
                
                HStack {
                    Text("好きなラッパー：")
                        .font(.system(size: 30, weight: .medium, design: .rounded))
                    
                    Text("晋平太")
                        .font(.system(size: 30, weight: .medium, design: .rounded))
                }
            }
            .offset(y: -20)
        }
    }
}
#Preview {
    Profile()
}
