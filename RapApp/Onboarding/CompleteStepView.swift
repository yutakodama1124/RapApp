import SwiftUI

struct CompleteStepView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.green)
            
            Text("準備完了！")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.black)
            
            Text("RapAppへようこそ\nバトルを楽しみましょう！")
                .font(.system(size: 18))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
    }
}
