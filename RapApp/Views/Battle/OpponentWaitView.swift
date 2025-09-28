import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct OpponentWaitView: View {
    @State private var isAnimating = false
    @State var home = false
    @State var DetailView = false
    
    
    
    let opponentUser: User
    let beatindex: Int
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            ProgressView()
                .scaleEffect(1.5)
            
            Text("相手を待っています")
                .font(.title2)
                .foregroundColor(.secondary)

            Button("キャンセル") {
                Task {
                    let db = Firestore.firestore()
                    guard let userId = Auth.auth().currentUser?.uid else { return }
                    
                    try? db.collection("matches").document(userId).delete()
                }
                home = true
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(8)
            
            Spacer()
        }
        .fullScreenCover(isPresented: $home) {
            ContentView()
        }
        .fullScreenCover(isPresented: $DetailView) {
            Detail(beatindex: beatindex, opponentUser: opponentUser)
        }
        .onAppear {
            startMatchPolling()
        }
    }
    
    private func startMatchPolling() {
         Task {
             let db = Firestore.firestore()
             guard let opponentId = opponentUser.id else { return }
             
             while true {
                 do {
                     let document = try await db.collection("matches").document(opponentId).getDocument()
                     
                     if document.exists {
                         let boolvalue = document.data()?["accepted"] as? Bool ?? false
                         
                         if boolvalue {
                             print("accepted")
                             DetailView = true
                             break
                         } else {
                             print("pending")
                         }
                     } else {
                         print("declined")
                         home = true
                         break
                     }
                 } catch {
                     print("Error: \(error)")
                 }
                 
                 try? await Task.sleep(for: .seconds(1))
             }
         }
     }
}
