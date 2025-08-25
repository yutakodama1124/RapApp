//
//  BattleView.swift
//  RapApp
//
//  Created by yuta kodama on 2025/08/22.
//

import SwiftUI

struct BattleView: View {
    @State private var barHeights: [CGFloat] = []
     @State private var showCountdown = true
     @State private var currentCount = 3
     @State private var countdownScale: CGFloat = 0.5
     @State private var countdownOpacity: Double = 0
     
     let numBars = 32
     let innerRadius: CGFloat = 60
     let maxBarLength: CGFloat = 40
     let timer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
     
     var body: some View {
         ZStack {
             Color.black.ignoresSafeArea()
             
             if showCountdown {
                 // Countdown View
                 ZStack {
                     // Background pulse
                     Circle()
                         .fill(currentCount == 0 ? Color.red.opacity(0.3) : Color.blue.opacity(0.2))
                         .frame(width: 200, height: 200)
                         .scaleEffect(countdownScale)
                         .animation(.easeOut(duration: 0.8), value: countdownScale)
                     
                     // Countdown text
                     Text(currentCount == 0 ? "FIGHT!" : "\(currentCount)")
                         .font(.system(size: 80, weight: .black, design: .rounded))
                         .foregroundColor(currentCount == 0 ? .red : .white)
                         .opacity(countdownOpacity)
                         .scaleEffect(countdownScale)
                         .animation(.easeOut(duration: 0.8), value: countdownScale)
                         .shadow(color: currentCount == 0 ? .red : .blue, radius: 20, x: 0, y: 0)
                 }
             } else {
                 // Music Bars View
                 ZStack {
                     // Background circle
                     Circle()
                         .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                         .frame(width: innerRadius * 2, height: innerRadius * 2)
                     
                     // Music bars
                     ForEach(0..<numBars, id: \.self) { index in
                         let angle = Angle.degrees(Double(index) * 360.0 / Double(numBars))
                         let barHeight = barHeights.isEmpty ? 10 : barHeights[index]
                         let intensity = barHeight / maxBarLength
                         
                         MusicBar(
                             angle: angle,
                             innerRadius: innerRadius,
                             length: barHeight,
                             color: Color(
                                 hue: 0.6 + Double(intensity) * 0.2,
                                 saturation: 0.8,
                                 brightness: 0.6 + Double(intensity) * 0.3
                             )
                         )
                     }
                     
                     // Center play button
                     Button(action: {
                         // Handle play action
                     }) {
                         ZStack {
                             Circle()
                                 .fill(Color.blue)
                                 .frame(width: 50, height: 50)
                                 .shadow(color: .blue, radius: 10, x: 0, y: 0)
                             
                             Image(systemName: "play.fill")
                                 .font(.title2)
                                 .foregroundColor(.white)
                                 .offset(x: 2)
                         }
                     }
                 }
                 .transition(.scale.combined(with: .opacity))
             }
         }
         .onAppear {
             startCountdown()
         }
         .onReceive(timer) { _ in
             if !showCountdown {
                 animateBars()
             }
         }
     }
     
     private func startCountdown() {
         countdownOpacity = 1
         countdownScale = 1.2
         
         // Animate each count
         let countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
             withAnimation(.easeOut(duration: 0.3)) {
                 countdownScale = 0.8
                 countdownOpacity = 0.7
             }
             
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                 withAnimation(.easeOut(duration: 0.7)) {
                     countdownScale = 1.2
                     countdownOpacity = 1
                 }
             }
             
             DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                 if currentCount > 0 {
                     currentCount -= 1
                 } else {
                     // Show "FIGHT!" then transition to music bars
                     timer.invalidate()
                     
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                         withAnimation(.easeInOut(duration: 0.5)) {
                             showCountdown = false
                         }
                         initializeBars()
                     }
                 }
             }
         }
         
         // Start immediately for first count
         countdownTimer.fire()
     }
     
     private func initializeBars() {
         barHeights = (0..<numBars).map { _ in
             CGFloat.random(in: 10...maxBarLength)
         }
     }
     
     private func animateBars() {
         withAnimation(.easeOut(duration: 0.15)) {
             for i in 0..<numBars {
                 barHeights[i] = CGFloat.random(in: 10...maxBarLength)
             }
         }
     }
 }

 struct MusicBar: View {
     let angle: Angle
     let innerRadius: CGFloat
     let length: CGFloat
     let color: Color
     
     var body: some View {
         Rectangle()
             .fill(color)
             .frame(width: 3, height: length)
             .shadow(color: color, radius: length / 8, x: 0, y: 0)
             .offset(y: -(innerRadius + length / 2))
             .rotationEffect(angle)
     }
 }
#Preview {
    BattleView()
}
