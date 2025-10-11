import SwiftUI

struct InterestsStepView: View {
    @Binding var hobby: String
    @Binding var favrapper: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Image(systemName: "music.note.list")
                    .font(.system(size: 80))
                    .foregroundColor(.black)
                    .padding(.top, 40)
                
                Text("あなたの趣味・好きなラッパー")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
 
                profileField(title: "趣味 *", text: $hobby)
                profileField(title: "好きなラッパー *", text: $favrapper)
                
                Spacer()
            }
        }
    }
    
    private func profileField(title: String, text: Binding<String>) -> some View {
        VStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .offset(x: 30)
            
            TextField(title, text: text)
                .font(.system(size: 20, design: .rounded))
                .foregroundColor(.black)
                .offset(x: 30)
            
            Rectangle()
                .frame(width: 305, height: 1)
        }
        .padding()
    }
}
