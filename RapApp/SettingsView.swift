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
            }

            NavigationLink(destination: WebView(url: URL(string: "https://docs.google.com/document/d/12Wa4f8OpUkRmANVYBHm7FddElwwuyOkBoSkPjiDGHQk/edit?usp=sharing")!)) {
                Text("利用規約")
            }

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

            Button(action: {
                showingDeleteAlert = true
            }) {
                Text("アカウント削除")
                    .foregroundColor(.red)
            }
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
