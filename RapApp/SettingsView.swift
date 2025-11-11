//
//  SettingsView.swift
//  RapApp
//
//  Created by yuta kodama on 2025/08/26.
//

import SwiftUI
import FirebaseAuth
import WebKit

struct SettingsView: View {
    
    private let gateway = UserGateway()
    @State private var showingDeleteAlert = false
    
    var body: some View {
        List {
            NavigationLink(destination: WebView(url: URL(string: "https://docs.google.com/document/d/1dvEd1Wij5y-YvMtiNNcOnFkyw0UfQrEZ_TcMizj3hPg/edit?usp=sharing")!)) {
                Text("プライバシーポリシー")
                    .foregroundColor(.black)
            }
            .listRowBackground(Color.white)
            
            NavigationLink(destination: WebView(url: URL(string: "https://docs.google.com/document/d/12Wa4f8OpUkRmANVYBHm7FddElwwuyOkBoSkPjiDGHQk/edit?usp=sharing")!)) {
                Text("利用規約")
                    .foregroundColor(.black)
            }
            .listRowBackground(Color.white)
            
            Button(action: {
                do {
                    try Auth.auth().signOut()
                    print("ログアウト成功")
                } catch {
                    print("ログアウトエラー: \(error)")
                }
            }) {
                Text("ログアウト")
                    .foregroundColor(.blue)
            }
            .listRowBackground(Color.white)
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                Text("アカウント削除")
                    .foregroundColor(.red)
            }
            .listRowBackground(Color.white)
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("アカウント削除"),
                    message: Text("本当にアカウントを削除しますか？この操作は取り消せません。"),
                    primaryButton: .destructive(Text("削除")) {
                        gateway.deleteAccount()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(red: 0.97, green: 0.97, blue: 0.97))
        .navigationTitle("設定")
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

#Preview {
    SettingsView()
}
