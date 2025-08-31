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
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        await fetchNearbyUsers()
                    }
                }
            }
            .navigationTitle("Nearby Users")
            .task {
                await fetchNearbyUsers()
            }
        }
    }
    
    private func fetchNearbyUsers() async {
        guard viewModel.isAuthenticated else {
            print("User not authenticated, skipping fetch")
            isLoading = false
            return
        }
        isLoading = true
        defer { isLoading = false }
        
        if let currentUser = await UserGateway().getSelf() {
            let filtered = await UserGateway().getNearUser(user: currentUser)
            print("Nearby users: \(filtered.map { $0.name })")
            nearbyUsers = filtered
        } else {
            print("No authenticated user")
        }
    }
}
