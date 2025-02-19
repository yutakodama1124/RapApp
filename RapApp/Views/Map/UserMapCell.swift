//
//  UserMapCell.swift
//  RapApp
//
//  Created by yuta kodama on 2025/02/19.
//

import SwiftUI

struct UserMapCell: View {
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Text("Yuta")
                    .font(.system(size: 35, weight:
                            .medium, design: .rounded))
                    .lineLimit(1)
                
                Rectangle()
                    .frame(width:80, height: 4)
                    .cornerRadius(25)
                    .offset(y:-15)
            }
            .frame(width: 300, alignment: .leading)
            
                HStack {
                    Text("Instagram:")
                        .font(.system(size: 25, weight:
                                .medium, design: .rounded))
                    
                    Text("@yuta_111124")
                        .font(.system(size: 25, weight:
                                .medium, design: .rounded))
                        .lineLimit(1)
                }
                .frame(width: 300, alignment: .leading)
                
                HStack {
                    Text("年齢:")
                        .font(.system(size: 25, weight:
                                .medium, design: .rounded))
                    
                    Text("１６歳")
                        .font(.system(size: 25, weight:
                                .medium, design: .rounded))
                        .lineLimit(1)
                }
                .frame(width: 300, alignment: .leading)
            }
            .frame(width: 300, height: 400)
            .padding(30)
            .border(.black)
            .cornerRadius(25)
        }
    }

#Preview {
    UserMapCell()
}
