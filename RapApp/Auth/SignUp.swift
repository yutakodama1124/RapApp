//
//  SignUp.swift
//  RapApp
//
//  Created by yuta kodama on 2024/08/21.
//

import SwiftUI
import FirebaseAuth
import AuthenticationServices
import CryptoKit

struct SignUp: View {
    
    @State var currentNonce: String?
    @State private var loginError = ""
    @State private var isLoggedIn = false
    @State var isAuthenticated = false
    @ObservedObject var viewModel: AuthViewModel
    private let userGateway = UserGateway()
    
    var body: some View {
        NavigationStack {
            SignInWithAppleButton(.signUp) { request in
                let nonce = randomNonceString()
                currentNonce = nonce
                request.requestedScopes = [.fullName, .email]
                request.nonce = sha256(nonce)
            } onCompletion: { result in
                switch result {
                case .success(let authResults):
                    switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        
                        guard let nonce = currentNonce else {
                            fatalError("Invalid state: A login callback was received, but no login request was sent.")
                        }
                        guard let appleIDToken = appleIDCredential.identityToken else {
                            fatalError("Invalid state: A login callback was received, but no login request was sent.")
                        }
                        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                            return
                        }
                        
                        let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                        Auth.auth().signIn(with: credential) { (authResult, error) in
                            if (error != nil) {
                                // Error. If error.code == .MissingOrInvalidNonce, make sure
                                // you're sending the SHA256-hashed nonce as a hex string with
                                // your request to Apple.
                                print(error?.localizedDescription as Any)
                                return
                            }
                            print("signed in")
                            self.isAuthenticated = true
                            
                            var authUser = User.Empty()
                            authUser.id = (authResult?.user.uid)!
                            
                            Task {
                                await userGateway.storeUser(from: authUser)
                            }
                            
                            
                            print("\(String(describing: Auth.auth().currentUser?.uid))")
                        }
                    default:
                        break
                        
                    }
                default:
                    break
                }
            }
        .frame(height: 50)
        .padding()
            
            if viewModel.isAuthenticated {
                // ログイン後のページに遷移
                ContentView(viewModel: viewModel)
            }
        
        if !loginError.isEmpty{
            Text(loginError)
        }
    }
}
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
    #Preview {
        SignUp(viewModel: AuthViewModel())
    }
