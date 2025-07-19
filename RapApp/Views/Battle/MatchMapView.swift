import SwiftUI
import MapKit

struct MatchMapView: View {
    let latitude: Double
    let longitude: Double
    
    
    var body: some View {
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
                    
                    Annotation("Opponent", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
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
                            
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
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
                        Text("自分")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.cyan)
                        
                        Text("VS")
                            .font(.title2)
                            .fontWeight(.black)
                            .foregroundColor(.gray)
                        
                        Text("相手")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                    .padding(.horizontal, 32)
                    

                    Button(action: {

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
    }
}

#Preview {
    MatchMapView(
        latitude: 35.0,
        longitude: 135.0
    )
}
