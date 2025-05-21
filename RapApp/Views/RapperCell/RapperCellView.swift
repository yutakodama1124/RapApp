

import SwiftUI

struct RapperCellView: View {
    let user: User
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle")
                .font(.system(size: 70))
            
            VStack {
                HStack {
                    Text(user.name)
                        .font(.system(size: 23, weight: .heavy, design: .rounded))
                }
                .frame(alignment: .leading)
                
                Text(user.job)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                
                Text(user.favrapper)
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
    RapperCellView(
        user: User(
            id: "",
            imageURL: "",
            name: "",
            school: "",
            hobby: "",
            job: "",
            favrapper: "",
            latitude: 1,
            longitude: 1
        )
    )
}
