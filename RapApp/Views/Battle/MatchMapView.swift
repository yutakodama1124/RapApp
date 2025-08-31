import SwiftUI
import MapKit
import Kingfisher

struct MatchMapView: View {
    let latitude: Double
    let longitude: Double
    
    @State var battleview = false
    
    @State private var currentUser: User? = nil
    private let gateway = UserGateway()
    let opponentuser: User
    
    var body: some View {
        if let user = currentUser {
            ZStack {
                
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        Text("バトル")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundStyle(Color.black)
                        
                        Text("相手を探そう！")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black.opacity(0.8))
                            .tracking(2)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                    
                    Map {
                        UserAnnotation()
                        
                        Annotation(opponentuser.name, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.black, .gray],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 60, height: 60)
                                    .shadow(color: .cyan.opacity(0.6), radius: 8, x: 0, y: 0)
                                
                                KFImage(URL(string: opponentuser.imageURL))
                                                          .placeholder {
                                                              Image(systemName: "person.fill")
                                                                  .foregroundColor(.white)
                                                                  .font(.system(size: 24, weight: .bold))
                                                          }
                                                          .resizable()
                                                          .aspectRatio(contentMode: .fill)
                                                          .frame(width: 50, height: 50)
                                                          .clipShape(Circle())
                            }
                            .scaleEffect(1.1)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: true)
                        }
                    }
                    .mapStyle(.standard(elevation: .realistic))
                    .frame(height: 520)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 15)
                    
                    
                    VStack(spacing: 12) {
                        HStack(spacing: 16) {
                            Text(user.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.cyan)
                            
                            Text("VS")
                                .font(.title2)
                                .fontWeight(.black)
                                .foregroundColor(.gray)
                            
                            Text(opponentuser.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        .padding(.horizontal, 32)
                        
                        
                        Button(action: {
                            battleview = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 18, weight: .bold))
                                Text("バトル開始！")
                                    .font(.headline)
                                    .fontWeight(.black)
                                    .tracking(1)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.black)
                            .cornerRadius(28)
                            .shadow(color: .cyan.opacity(0.4), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .fullScreenCover(isPresented: $battleview) {
                Battle()
            }
            .task {
                currentUser = await gateway.getSelf()
            }
        }
    }
}
#Preview {
    MatchMapView(
        latitude: 35.0,
        longitude: 135.0, opponentuser: .Empty()
    )
}
