import SwiftUI
import FirebaseAuth
import AuthenticationServices
import CryptoKit
import AppleSignInFirebase

struct SignUp: View {
    
    @State private var currentNonce: String?
    @State private var loginError = ""
    @ObservedObject var viewModel: AuthViewModel
    private let userGateway = UserGateway()
    
    var body: some View {
        NavigationStack {
            VStack {
                SignInWithAppleButton(.signUp) { request in
                    let nonce = randomNonceString()
                    currentNonce = nonce
                    request.requestedScopes = [.fullName, .email]
                    request.nonce = sha256(nonce)
                } onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        handleAppleSignIn(authResults)
                    case .failure(let error):
                        loginError = "Apple sign-in failed: \(error.localizedDescription)"
                    }
                }
                .frame(height: 50)
                .padding()

                if !loginError.isEmpty {
                    Text(loginError)
                        .foregroundColor(.red)
                        .padding()
                }

                if viewModel.isAuthenticated {
                    ContentView(viewModel: viewModel)
                }
            }
        }
    }

    private func handleAppleSignIn(_ authResults: ASAuthorization) {
        guard case let appleIDCredential as ASAuthorizationAppleIDCredential = authResults.credential else {
            loginError = "Invalid Apple ID credential."
            return
        }
        
        guard let nonce = currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            loginError = "Invalid state or token during Apple sign-in."
            return
        }

        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )

        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                loginError = "Firebase sign-in failed: \(error.localizedDescription)"
                return
            }

            guard let user = authResult?.user else {
                loginError = "Failed to retrieve user."
                return
            }


            viewModel.isAuthenticated = true


            var newUser = User.Empty()
            newUser.id = user.uid
            Task {
                _ = await userGateway.updateUserInfo(user: newUser)
            }

            print("Signed in as: \(user.uid)")
        }
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }

        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        return String(randomBytes.map { charset[Int($0) % charset.count] })
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

#Preview {
    SignUp(viewModel: AuthViewModel())
}
