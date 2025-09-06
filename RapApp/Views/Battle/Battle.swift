//
//  Battle.swift
//  RapApp
//
//  Created by yuta kodama on 2024/06/19.
//

import SwiftUI
import AVKit
import AVFoundation

struct Battle: View {
    
    @State var isplaying = false
    @State var nextview = false
    @State private var showCountdown = true
    @State private var currentCount = 3
    @State private var countdownScale: CGFloat = 0.5
    @State private var countdownOpacity: Double = 0
    @State private var isPlaying = false
    @State private var intensity: CGFloat = 0.3
    @State private var beatPulse: Bool = false
    
    let timer = Timer.publish(every: 0.08, on: .main, in: .common).autoconnect()
    
    let musicplayer = SoundPlayer()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if showCountdown {
                battleCountdown
            } else {
                battleStage
            }
        }
        .onAppear {
            
            UIApplication.shared.isIdleTimerDisabled = true
            
            startCountdown()

            Task {
                try? await Task.sleep(for: .seconds(4))
                await musicplayer.musicPlayer()
                isplaying = true
            }
            Task {
                try? await Task.sleep(for: .seconds(140))
                nextview = true
            }
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .onReceive(timer) { _ in
            if !showCountdown && isPlaying {
                updateIntensity()
                triggerBeatPulse()
            }
        }
        .fullScreenCover(isPresented: $nextview) {
            ThankYou()
        }
    }
    
    
    private var battleCountdown: some View {
        ZStack {
            Circle()
                .stroke(Color.red, lineWidth: 6)
                .frame(width: 200, height: 200)
                .scaleEffect(countdownScale)
                .shadow(color: .red, radius: 20)
            
            Text(currentCount == 0 ? "BATTLE!" : "\(currentCount)")
                .font(.system(size: currentCount == 0 ? 50 : 80, weight: .black))
                .foregroundColor(.white)
                .opacity(countdownOpacity)
                .scaleEffect(countdownScale)
        }
    }
    
    private var battleStage: some View {
        ZStack {
            VStack {
                Text("VS")
                    .font(.system(size: 48, weight: .black))
                    .foregroundColor(.red)
                    .scaleEffect(beatPulse ? 1.4 : 1.0)
                    .shadow(color: .red, radius: beatPulse ? 25 : 8)
                    .padding(.top, 80)
                
                Spacer()
            }
            
            ZStack {
                ForEach(0..<3, id: \.self) { ring in
                    Circle()
                        .stroke(Color.red, lineWidth: 2)
                        .frame(width: 120 + CGFloat(ring * 40))
                        .scaleEffect(beatPulse ? 1.8 : 1.0)
                        .opacity(beatPulse ? 0.0 : 0.6 - Double(ring) * 0.2)
                        .animation(
                            .easeOut(duration: 1.0).delay(Double(ring) * 0.1),
                            value: beatPulse
                        )
                }
                
                ZStack {
                    ForEach(0..<4, id: \.self) { wave in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.7))
                            .frame(width: 3, height: 8 + CGFloat(wave * 4))
                            .offset(x: 80 + CGFloat(wave * 15))
                            .scaleEffect(y: 1.0 + intensity * CGFloat(wave + 1) * 0.5)
                            .opacity(intensity > 0.2 ? 1.0 : 0.3)
                            .animation(
                                .easeInOut(duration: 0.1).delay(Double(wave) * 0.05),
                                value: intensity
                            )
                    }
                    
                    ForEach(0..<4, id: \.self) { wave in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.7))
                            .frame(width: 3, height: 8 + CGFloat(wave * 4))
                            .offset(x: -(80 + CGFloat(wave * 15)))
                            .scaleEffect(y: 1.0 + intensity * CGFloat(wave + 1) * 0.5)
                            .opacity(intensity > 0.2 ? 1.0 : 0.3)
                            .animation(
                                .easeInOut(duration: 0.1).delay(Double(wave) * 0.05),
                                value: intensity
                            )
                    }
                    
                    Image(systemName: "mic.fill")
                        .font(.system(size: 90))
                        .foregroundColor(.white)
                        .scaleEffect(1.0 + intensity * 0.3)
                        .shadow(color: .white, radius: intensity * 20)
                }
            }
        }
    }
    
    
    private func startCountdown() {
        countdownOpacity = 1
        countdownScale = 1.2
        
        let countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            withAnimation(.spring()) {
                countdownScale = 0.7
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring()) {
                    countdownScale = 1.4
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if currentCount > 0 {
                    currentCount -= 1
                } else {
                    timer.invalidate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showCountdown = false
                            isPlaying = true
                        }
                    }
                }
            }
        }
        countdownTimer.fire()
    }
    
    private func updateIntensity() {
        let time = Date().timeIntervalSince1970
        let baseIntensity = (sin(time * 2) + 1) / 2
        let variation = (sin(time * 8) + 1) / 4
        intensity = CGFloat(baseIntensity * 0.7 + variation + 0.3)
    }
    
    private func triggerBeatPulse() {
        if intensity > 0.8 && !beatPulse {
            withAnimation {
                beatPulse = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                beatPulse = false
            }
        }
    }
}

#Preview {
    Battle()
}
