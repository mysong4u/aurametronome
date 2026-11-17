import SwiftUI
import AVFoundation

@main
struct AuraMetronomeiOSApp: App {
    var body: some Scene {
        WindowGroup {
            iOSMetronomeMainView()
                .preferredColorScheme(.dark)
        }
    }
}

struct iOSMetronomeMainView: View {
    @State private var bpm: Double = 120
    @State private var isPlaying: Bool = false
    @State private var currentBeat: Int = 1
    @State private var beatsPerMeasure: Int = 4
    @State private var timer: Timer? = nil
    
    private let audioPlayer: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: "tick", withExtension: "mp3") else { return nil }
        return try? AVAudioPlayer(contentsOf: url)
    }()
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.08)
                .ignoresSafeArea()
            
            VStack(spacing: 28) {
                // Header Title
                VStack(spacing: 6) {
                    HStack {
                        Image(systemName: "metronome.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.indigo)
                        Text("AuraMetronome")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Text("iOS & Apple Watch Standalone Metronome")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Beat Indicator Lights
                HStack(spacing: 16) {
                    ForEach(1...beatsPerMeasure, id: \.self) { beat in
                        Circle()
                            .fill(beat == currentBeat && isPlaying ? Color.indigo : Color.white.opacity(0.15))
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .stroke(beat == currentBeat && isPlaying ? Color.purple : Color.clear, lineWidth: 3)
                            )
                            .scaleEffect(beat == currentBeat && isPlaying ? 1.25 : 1.0)
                            .animation(.spring(response: 0.15, dampingFraction: 0.5), value: currentBeat)
                    }
                }
                .padding(.vertical, 10)
                
                // BPM Large Display
                VStack(spacing: 4) {
                    Text("\(Int(bpm))")
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("BPM")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.indigo)
                }
                
                // BPM Stepper Controls
                HStack(spacing: 30) {
                    Button(action: {
                        if bpm > 40 { bpm -= 1 }
                        restartTimerIfNeeded()
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.gray)
                    }
                    
                    Slider(value: $bpm, in: 40...240, step: 1) { editing in
                        if !editing {
                            restartTimerIfNeeded()
                        }
                    }
                    .accentColor(.indigo)
                    .frame(maxWidth: 240)
                    
                    Button(action: {
                        if bpm < 240 { bpm += 1 }
                        restartTimerIfNeeded()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 20)
                
                // Beats Per Measure Selector
                HStack(spacing: 12) {
                    Text("Time Signature:")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)
                    
                    Picker("Time Signature", selection: $beatsPerMeasure) {
                        Text("2/4").tag(2)
                        Text("3/4").tag(3)
                        Text("4/4").tag(4)
                        Text("6/8").tag(6)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxWidth: 200)
                }
                .padding(.top, 10)
                
                Spacer()
                
                // Start / Stop Main Play Button
                Button(action: togglePlay) {
                    HStack(spacing: 12) {
                        Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                            .font(.system(size: 26))
                        Text(isPlaying ? "STOP" : "START")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(isPlaying ? Color.red : Color.indigo)
                    .cornerRadius(20)
                    .shadow(color: (isPlaying ? Color.red : Color.indigo).opacity(0.4), radius: 12, y: 6)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
            .frame(maxWidth: 550)
            .frame(maxWidth: .infinity)
        }
    }
    
    private func togglePlay() {
        isPlaying.toggle()
        if isPlaying {
            startMetronome()
        } else {
            stopMetronome()
        }
    }
    
    private func startMetronome() {
        stopMetronome()
        currentBeat = 1
        playTickSound()
        
        let interval = 60.0 / bpm
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            currentBeat = (currentBeat % beatsPerMeasure) + 1
            playTickSound()
        }
    }
    
    private func stopMetronome() {
        timer?.invalidate()
        timer = nil
        currentBeat = 1
    }
    
    private func restartTimerIfNeeded() {
        if isPlaying {
            startMetronome()
        }
    }
    
    private func playTickSound() {
        AudioServicesPlaySystemSound(1104) // System click sound
    }
}
