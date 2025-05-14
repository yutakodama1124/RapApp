//
//  RapperCellView.swift
//  RapApp
//
//  Created by yuta kodama on 2025/05/14.
//

import SwiftUI

struct UserForRapperCell {
    var name: String
    var title: String
    var win: String
    
    static let sample = UserForRapperCell(name: "Yuta", title: "仕事: サッカー選手", win: "13勝 11敗")
    
    static let sample2 = UserForRapperCell(name: "Kai", title: "仕事: 高校生", win: "０勝 23敗")
    
    static let sample3 = UserForRapperCell(name: "Authority", title: "仕事: ラッパー", win: "100勝 0敗")
}

struct RapperCellView: View {
    
    let rapper: UserForRapperCell
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle")
                .font(.system(size: 70))
            
            VStack {
                HStack {
                    Text(rapper.name)
                        .font(.system(size: 23, weight: .heavy, design: .rounded))
                }
                .frame(alignment: .leading)
                
                Text(rapper.title)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                
                Text(rapper.win)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
            }
            Spacer()
            
            Image(systemName: "chevron.forward")
                .font(.system(size: 35))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        
    }
}

#Preview {
    RapperCellView(rapper: .sample)
}
