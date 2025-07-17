

import SwiftUI

struct RapperCellView: View {
    let user: User
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 40))
                .padding(.trailing, 4)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(user.name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary) 
                    .lineLimit(1)
                
                Button(action: {
                   
                }) {
                    Text("Match")
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .foregroundColor(.white)
                        .background(
                            Capsule()
                                .fill(Color.black)
                                .shadow(radius: 2, x: 1, y: 1)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        
    }
}

#Preview {
    RapperCellView(
        user: User(
            id: "",
            imageURL: "",
            name: "児玉勇太",
            school: "",
            hobby: "",
            job: "高校生",
            favrapper: "晋平太",
            latitude: 1,
            longitude: 1
        )
    )
}
