//
//  HomeView.swift
//  RapApp
//
//  Created by yuta kodama on 2025/05/14.
//

import SwiftUI

// MARK: - Models
struct User1: Identifiable {
    let id = UUID()
    let username: String
    let tagline: String
    let avatar: String
    let rank: Rank
    let status: UserStatus
    let wins: Int
    let losses: Int
    let rating: Int
    let distance: Double // in miles
    let isOnline: Bool
}

enum Rank: String, CaseIterable {
    case rookie = "Rookie"
    case rising = "Rising"
    case pro = "Pro"
    case master = "Master"
    case legend = "Legend"
    
    var color: Color {
        switch self {
        case .rookie: return .gray
        case .rising: return .green
        case .pro: return .blue
        case .master: return .purple
        case .legend: return .orange
        }
    }
    
    var icon: String {
        switch self {
        case .rookie: return "star"
        case .rising: return "bolt"
        case .pro: return "crown"
        case .master: return "flame"
        case .legend: return "trophy"
        }
    }
}

enum UserStatus: String {
    case available = "Available"
    case inBattle = "In Battle"
    case away = "Away"
    
    var color: Color {
        switch self {
        case .available: return .green
        case .inBattle: return .red
        case .away: return .yellow
        }
    }
}

// MARK: - User Cell Component
struct UserCell: View {
    let user: User1
    let onChallenge: (User1) -> Void
    let onMessage: (User1) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Avatar with status indicator
                ZStack {
                    AsyncImage(url: URL(string: "https://api.dicebear.com/7.x/avataaars/svg?seed=\(user.username)")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                            )
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(user.rank.color, lineWidth: 2)
                    )
                    
                    // Status indicator
                    Circle()
                        .fill(user.status.color)
                        .frame(width: 14, height: 14)
                        .offset(x: 18, y: 18)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 2)
                                .frame(width: 14, height: 14)
                                .offset(x: 18, y: 18)
                        )
                }
                
                // User info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(user.username)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        // Distance
                        HStack(spacing: 4) {
                            Image(systemName: "location")
                                .foregroundColor(.secondary)
                                .font(.caption)
                            Text(String(format: "%.1f mi", user.distance))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text(user.tagline)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    // Rank and stats
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: user.rank.icon)
                                .foregroundColor(user.rank.color)
                                .font(.caption)
                            Text(user.rank.rawValue)
                                .font(.caption)
                                .foregroundColor(user.rank.color)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(user.rank.color.opacity(0.1))
                        .cornerRadius(12)
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Text("\(user.wins)W")
                                .font(.caption)
                                .foregroundColor(.green)
                                .fontWeight(.medium)
                            Text("\(user.losses)L")
                                .font(.caption)
                                .foregroundColor(.red)
                                .fontWeight(.medium)
                            Text("\(user.rating)")
                                .font(.caption)
                                .foregroundColor(.purple)
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // Action buttons
            HStack(spacing: 12) {
                Button(action: { onMessage(user) }) {
                    HStack {
                        Image(systemName: "message")
                        Text("Message")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(8)
                }
                
                Button(action: { onChallenge(user) }) {
                    HStack {
                        Image(systemName: "bolt")
                        Text(user.status == .inBattle ? "Busy" : "Battle")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(user.status == .inBattle ? Color.gray.opacity(0.3) : Color.red)
                    .foregroundColor(user.status == .inBattle ? .gray : .white)
                    .cornerRadius(8)
                }
                .disabled(user.status == .inBattle)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Main App View
struct HomeView: View {
    @State private var users: [User1] = []
    @State private var selectedFilter: String = "All"
    @State private var searchText: String = ""
    
    let filters = ["All", "Available", "Rookie", "Rising", "Pro", "Master", "Legend"]
    
    var filteredUsers: [User1] {
        let filtered = users.filter { user in
            let matchesSearch = searchText.isEmpty ||
                               user.username.localizedCaseInsensitiveContains(searchText) ||
                               user.tagline.localizedCaseInsensitiveContains(searchText)
            
            let matchesFilter = selectedFilter == "All" ||
                               selectedFilter == "Available" && user.status == .available ||
                               selectedFilter == user.rank.rawValue
            
            return matchesSearch && matchesFilter
        }
        
        return filtered.sorted { $0.distance < $1.distance }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header stats
                HStack {
                    StatCard(title: "Total", value: "\(users.count)", color: .blue)
                    StatCard(title: "Online", value: "\(users.filter { $0.isOnline }.count)", color: .green)
                    StatCard(title: "Available", value: "\(users.filter { $0.status == .available }.count)", color: .orange)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search nearby rappers...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Filter pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(filters, id: \.self) { filter in
                            Button(action: { selectedFilter = filter }) {
                                Text(filter)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedFilter == filter ? Color.purple : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedFilter == filter ? .white : .primary)
                                    .cornerRadius(16)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
                
                // User list
                if filteredUsers.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "person.3")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No rappers found nearby")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Button("Reset Filters") {
                            selectedFilter = "All"
                            searchText = ""
                        }
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredUsers) { user in
                                UserCell(
                                    user: user,
                                    onChallenge: { challengeUser($0) },
                                    onMessage: { messageUser($0) }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Battle Arena")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
        }
        .onAppear {
            loadMockUsers()
        }
    }
    
    // MARK: - Actions
    private func challengeUser(_ user: User1) {
        print("Challenge sent to \(user.username)")
        // Handle challenge logic here
    }
    
    private func messageUser(_ user: User1) {
        print("Opening chat with \(user.username)")
        // Handle message logic here
    }
    
    private func loadMockUsers() {
        users = [
            User1(username: "FlowMaster", tagline: "Spitting fire since 2020", avatar: "", rank: .legend, status: .available, wins: 142, losses: 23, rating: 2847, distance: 0.3, isOnline: true),
            User1(username: "VerseDemon", tagline: "Bars hotter than hell", avatar: "", rank: .master, status: .inBattle, wins: 89, losses: 34, rating: 2156, distance: 0.8, isOnline: true),
            User1(username: "RhymeTime", tagline: "Wordplay wizard", avatar: "", rank: .pro, status: .available, wins: 67, losses: 41, rating: 1892, distance: 1.2, isOnline: true),
            User1(username: "BeatDropper", tagline: "New to the scene", avatar: "", rank: .rising, status: .away, wins: 23, losses: 18, rating: 1234, distance: 1.5, isOnline: false),
            User1(username: "LyricLegend", tagline: "Storyteller supreme", avatar: "", rank: .master, status: .available, wins: 156, losses: 67, rating: 2398, distance: 2.1, isOnline: true),
            User1(username: "MicKiller", tagline: "Destroying beats daily", avatar: "", rank: .pro, status: .available, wins: 78, losses: 45, rating: 1756, distance: 2.8, isOnline: true),
            User1(username: "FreestyleKing", tagline: "Improv master", avatar: "", rank: .rookie, status: .available, wins: 12, losses: 8, rating: 856, distance: 3.2, isOnline: true)
        ]
    }
}

// MARK: - Helper Views
struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

#Preview {
    HomeView()
}
