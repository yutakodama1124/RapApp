

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct RapperCellView: View {
    
    let user: User
    @StateObject private var locationManager = LocationManager()
    @State private var isPressed = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            AsyncImage(url: URL(string: user.imageURL)) { image in
                 image
                     .resizable()
                     .scaledToFill()
                     .frame(width: 50, height: 50)
                     .clipShape(Circle())
             } placeholder: {
                 Image(systemName: "person.circle.fill")
                     .resizable()
                     .scaledToFit()
                     .frame(width: 50, height: 50)
                     .foregroundColor(.black)
                     .clipShape(Circle())
             }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(user.name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary) 
                    .lineLimit(1)
                
                Button(action: {
                    Task {
                        guard let userId = Auth.auth().currentUser?.uid else { return }
                        
                        let db = Firestore.firestore()
                        let location = locationManager.lastLocation
                        
                        let m = Match(
                            id: user.id,
                            userAId: userId,
                            latitude: location?.coordinate.latitude ?? 0,
                            longitude: location?.coordinate.longitude ?? 0,
                            accepted: false,
                            selectedBeatIndex: BeatsGateway.generateRandomBeatIndex()
                        )
                        
                        try? db.collection("matches").document(user.id ?? "").setData(from: m)
                        
                        Task {
                            let db = Firestore.firestore()
                            
                            while true {
                                do {
                                    let document = try await db.collection("matches").document(user.id!).getDocument()
                                    
                                    if document.exists {
                                        let boolvalue = document.data()?["accepted"] as? Bool ?? false
                                        
                                        if boolvalue {
                                            print("accepted")
                                        } else {
                                            print("pending")
                                        }
                                    } else {
                                        print("declined")
                                    }
                                } catch {
                                    print("Error: \(error)")
                                }
                                
                                try? await Task.sleep(for: .seconds(1))
                            }
                        }
                    }
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
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                        .opacity(isPressed ? 0.6 : 1.0)
                        .animation(.spring(response: 0.2, dampingFraction: 0.5),
                                   value: isPressed)
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isPressed = true }
                        .onEnded { _ in isPressed = false }
                )
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
            longitude: 1,
            battleCount: 0
        )
    )
}
