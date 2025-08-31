
import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct HomeView: View {
    @State private var currentUser: User? = nil
    private let gateway = UserGateway()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        if let user = currentUser {
                            HStack(spacing: 12) {
                                AsyncImage(url: URL(string: user.imageURL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipShape(Circle())
                                } placeholder: {
                                            Image(systemName: "person.fill")
                                                .foregroundColor(.white)
                                                .font(.system(size: 20))
                                }
                                
                                Text(user.name)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        } else {
                            ProgressView()
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: SettingsView()) {
                            Circle()
                                .fill(Color.gray.opacity(0.15))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "gearshape.fill")
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    if let user = currentUser {
                        VStack {
                            VStack(spacing: 8) {
                                Text("総バトル数")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text("\(user.battleCount)")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            .frame(width: 160, height: 160)
                            .background(
                                Circle()
                                    .fill(Color.gray.opacity(0.1))
                            )
                        }
                        .padding(.vertical, 20)
                    } else {
                        ProgressView("Loading user...")
                            .padding(.vertical, 20)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: RapperListView()) {
                        VStack(spacing: 20) {
                            Image(systemName: "mic.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 52))
                            
                            VStack(spacing: 6) {
                                Text("クイックバトル")
                                    .font(.system(size: 26, weight: .black))
                                    .foregroundColor(.white)
                                
                                Text("タップして対戦開始")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.black)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .shadow(color: Color.black.opacity(0.12), radius: 24, x: 0, y: 16)
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 60)
                }
            }
            .task {
                currentUser = await gateway.getSelf()
            }
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
