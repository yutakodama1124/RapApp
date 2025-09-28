import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Kingfisher

struct InputView: View {
    @State var rhyme: Int = 1
    @State var flow: Int = 1
    @State var verse: Int = 1
    @State var comment: String = ""
    
    @State var ThankYouView = false
    
    
    @State var opponentUser: User
    
    
    private var averageScore: Double {
        Double(rhyme + flow + verse) / 3.0
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    opponentSection
                    evaluationSection
                    overallScoreSection
                    commentInputSection
                    submitButtonSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .background(Color.white)
            .navigationTitle("評価を入力")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $ThankYouView) {
                ThankYou()
            }
        }
    }
    
    private var opponentSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("対戦相手")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
            }
            
            opponentCard
        }
    }
    
    private var opponentCard: some View {
        HStack(spacing: 16) {
            opponentImage
            
            VStack(alignment: .leading, spacing: 4) {
                Text(opponentUser.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var opponentImage: some View {
        KFImage(URL(string: opponentUser.imageURL))
            .placeholder {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 64, height: 64)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 35))
                            .foregroundColor(.white.opacity(0.7))
                    )
            }
            .resizable()
            .scaledToFill()
            .frame(width: 64, height: 64)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.2), radius: 5)
    }
    
    private var evaluationSection: some View {
        VStack(spacing: 24) {
            HStack {
                Text("評価スコア")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
            }
            
            evaluationContent
        }
    }
    
    private var evaluationContent: some View {
        VStack(spacing: 40) {
            EvaluationBarWithLabel(title: "韻", value: $rhyme)
            EvaluationBarWithLabel(title: "フロー", value: $flow)
            EvaluationBarWithLabel(title: "バース", value: $verse)
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var overallScoreSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("総合スコア")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
            }
            
            overallScoreCard
        }
    }
    
    private var overallScoreCard: some View {
        VStack(spacing: 8) {
            Text(String(format: "%.1f", averageScore))
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.black)
            
            Text("/ 5.0")
                .font(.title)
                .foregroundColor(.gray)
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var commentInputSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("コメント")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Text("(必須)")
                    .font(.body)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            commentTextEditor
        }
    }
    
    private var commentTextEditor: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topLeading) {
                if comment.isEmpty {
                    Text("相手のパフォーマンスについて詳しくコメントを残してください...")
                        .font(.body)
                        .foregroundColor(.gray.opacity(0.6))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
                
                TextEditor(text: $comment)
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(height: 120)
                    .onChange(of: comment) { newValue in
                        if newValue.count > 300 {
                            comment = String(newValue.prefix(300))
                        }
                    }
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            
            HStack {
                Spacer()
                Text("\(comment.count) / 300")
                    .font(.caption)
                    .foregroundColor(comment.count > 270 ? .orange : .gray)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var submitButtonSection: some View {
        Button(action: submitRating) {
            Text("評価を送信")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.black)
                .cornerRadius(12)
        }
    }
    
    private func submitRating() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let r = Rate(senderId: userId, rhyme: rhyme, flow: flow, verse: verse, comment: comment)
        
        Task {
            do {
                try await db.collection("rate").document(opponentUser.id ?? "").setData(from: r)
                
                await MainActor.run {
                    ThankYouView = true
                }
                
            } catch {
                print("Error saving rate: \(error)")
            }
        }
    }
}

struct EvaluationBar: View {
    @Binding var value: Int
    
    private var cgFloatBinding: Binding<CGFloat> {
        Binding<CGFloat>(
            get: { CGFloat(value) },
            set: { value = Int($0.rounded()) }
        )
    }
    
    var body: some View {
        VStack {
            Text("\(value)")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.black)
            
            sliderSection
        }
    }
    
    private var sliderSection: some View {
        VStack(spacing: 0) {
            Slider(
                value: cgFloatBinding,
                in: 1...5,
                step: 1)
            .accentColor(.black)
            
            SliderLabels()
        }
    }
    
    private func SliderLabels() -> some View {
        HStack(spacing: 0) {
            ForEach(1...5, id: \.self) { number in
                VStack {
                    Text("I")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(number)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .offset(x: offsetForIndex(number - 1))
                if number != 5 {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 8)
    }
    
    private func offsetForIndex(_ index: Int) -> CGFloat {
        switch index {
        case 1: return 5
        case 2: return 4
        default: return 0
        }
    }
}

struct EvaluationBarWithLabel: View {
    let title: String
    @Binding var value: Int
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                Spacer()
            }
            
            EvaluationBar(value: $value)
        }
    }
}

#Preview {
    InputView(opponentUser: .Empty())
}
