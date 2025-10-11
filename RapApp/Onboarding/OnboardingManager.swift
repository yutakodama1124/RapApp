import Foundation
import SwiftUI
import FirebaseAuth

class OnboardingManager: ObservableObject {
    @Published var needsOnboarding = false
    @Published var isCheckingStatus = true
    private let userGateway = UserGateway()
    
    @MainActor
    func checkOnboardingStatus() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            needsOnboarding = false
            isCheckingStatus = false
            return
        }
        
        if let user = await userGateway.fetchUser(userId: userId) {
            needsOnboarding = user.name.isEmpty
        } else {
            needsOnboarding = true
        }
        
        isCheckingStatus = false
    }
    
    func completeOnboarding() {
        needsOnboarding = false
    }
}
