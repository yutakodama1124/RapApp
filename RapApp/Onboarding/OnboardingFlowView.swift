import SwiftUI
import FirebaseAuth

struct OnboardingFlowView: View {
    @ObservedObject var onboardingManager: OnboardingManager
    @State private var currentStep = 0
    @State private var name = ""
    @State private var school = ""
    @State private var job = ""
    @State private var hobby = ""
    @State private var favrapper = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var isSaving = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    private let userGateway = UserGateway()
    
    var body: some View {
        VStack {
            ProgressView(value: Double(currentStep + 1), total: 3)
                .padding()
                .tint(.black)
            
            TabView(selection: $currentStep) {
                BasicInfoStepView(
                    name: $name,
                    school: $school,
                    job: $job,
                    selectedImage: $selectedImage,
                    showImagePicker: $showImagePicker
                )
                .tag(0)

                InterestsStepView(
                    hobby: $hobby,
                    favrapper: $favrapper
                )
                .tag(1)

                CompleteStepView()
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            HStack(spacing: 20) {
                if currentStep > 0 {
                    Button(action: { currentStep -= 1 }) {
                        Text("戻る")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .foregroundColor(.black)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(25)
                    }
                }
                
                Button(action: handleNext) {
                    if isSaving {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                    } else {
                        Text(currentStep < 2 ? "次へ" : "完了")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                    }
                }
                .foregroundColor(.white)
                .background(canProceed ? Color.black : Color.gray)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                .disabled(!canProceed || isSaving)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
        .sheet(isPresented: $showImagePicker) {
            LibraryPickerView(selectedImage: $selectedImage)
        }
        .alert("エラー", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
    
    var canProceed: Bool {
        switch currentStep {
        case 0: return !name.isEmpty && !job.isEmpty
        case 1: return !hobby.isEmpty && !favrapper.isEmpty
        case 2: return true
        default: return false
        }
    }
    
    func handleNext() {
        if currentStep < 2 {
            currentStep += 1
        } else {
            saveProfile()
        }
    }
    
    func saveProfile() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        isSaving = true
        
        Task {
            var user = User(
                id: userId,
                imageURL: "https://example.com/default-profile.png",
                name: name,
                school: school,
                hobby: hobby,
                job: job,
                favrapper: favrapper,
                latitude: 0,
                longitude: 0,
                battleCount: 0
            )

            print("Saving user info...")
            let success = await userGateway.updateUserInfo(user: user)
            
            await MainActor.run {
                isSaving = false
                if success {
                    print("User info saved! Completing onboarding...")
                    onboardingManager.completeOnboarding()
                } else {
                    errorMessage = "プロフィールの保存に失敗しました"
                    showError = true
                    return
                }
            }

            if let image = selectedImage {
                print("Uploading image in background...")
                Task.detached {
                    let result = await userGateway.uploadImage(user: user, image: image)
                    if result.success {
                        print("Image uploaded successfully!")
                    } else {
                        print("Image upload failed, but user is already onboarded")
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingFlowView(onboardingManager: OnboardingManager())
}
