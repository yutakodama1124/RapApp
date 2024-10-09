//
//  AuthViewModel.swift
//  RapApp
//
//  Created by yuta kodama on 2024/08/31.
//

import Foundation
import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    // イニシャライザメソッドを呼び出して、アプリの起動時に認証状態をチェックする
    init() {
        observeAuthChanges()
    }
    
    private func observeAuthChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = user != nil
            }
        }
    }
}
