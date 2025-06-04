import SwiftUI


struct RapperListView: View {
    @State private var nearbyUsers: [User] = []
    @State private var isLoading = true
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading nearby users...")
                } else if nearbyUsers.isEmpty {
                    Text("No nearby users found.")
                        .foregroundColor(.gray)
                } else {
                    List(nearbyUsers) { user in
                        NavigationLink(destination: RapperDetailView(user: user)) {
                            RapperCellView(user: user)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Nearby Users")
            .task {
                guard viewModel.isAuthenticated else {
                    print("User not authenticated, skipping fetch")
                    isLoading = false
                    return
                }
                isLoading = true
                if let currentUser = await UserGateway().getSelf() {
                    let filtered = await UserGateway().getNearUser(user: currentUser)
                    print("Nearby users: \(filtered.map { $0.name })")
                    self.nearbyUsers = filtered
                } else {
                    print("No authenticated user")
                }
                isLoading = false
            }
        }
    }
}
