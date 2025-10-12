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
            let nearby = await UserGateway().getNearUser(user: currentUser)
            let available = await filterAvailableUsers(nearby)
            print("Available nearby users: \(available.map { $0.name })")
            nearbyUsers = available
        } else {
            print("No authenticated user")
        }
    }
    
    private func filterAvailableUsers(_ users: [User]) async -> [User] {
        let usersInMatch = await UserGateway().getUsersInActiveMatches()
        return users.filter { user in
            guard let userId = user.id else { return false }
            return !usersInMatch.contains(userId)
        }
    }
}
