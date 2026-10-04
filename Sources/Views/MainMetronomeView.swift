import SwiftUI

struct MainMetronomeView: View {
    @StateObject private var engine = MetronomeEngine.shared
    
    // Pulse animation state for every beat
    @State private var pulseScale: CGFloat = 1.0
    @State private var pulseOpacity: Double = 0.5
    
    var body: some View {
        ZStack {
            
            // 1. Sleek Midnight Stage-Friendly Background
            LinearGradient(
                colors: [Color(hex: "#09091E") ?? .black, Color(hex: "#010107") ?? .indigo],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // 2. Dynamic Audio-Reactive Pulsing Ring (Aligned with beats!)
            Circle()
                .stroke(engine.currentBeat == 1 ? Color.pink.opacity(0.4) : Color.indigo.opacity(0.3), lineWidth: 8)
                .scaleEffect(pulseScale)
                .opacity(pulseOpacity)
                .frame(width: 140, height: 140)
            
            // 3. Central Controller Content
            VStack(spacing: 8) {
                
                // Beat Indicator Indicators
                HStack(spacing: 8) {
                    ForEach(1...engine.timeSignature, id: \.self) { beat in
                        Circle()
                            .fill(beat == engine.currentBeat ? (beat == 1 ? Color.pink : Color.indigo) : Color.gray.opacity(0.25))
                            .frame(width: beat == engine.currentBeat ? 10 : 6, height: beat == engine.currentBeat ? 10 : 6)
                            .animation(.spring(response: 0.15), value: engine.currentBeat)
                    }
                }
                .padding(.top, 4)
                
                Spacer()
                
                // Center BPM Digital Crown Target
                VStack(spacing: 0) {
                    Text("\(Int(engine.bpm))")
                        .font(.system(size: 46, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("BPM")
                        .font(.system(.caption2, design: .rounded).bold())
                        .foregroundColor(.secondary)
                }
                // Integrate Apple Watch's Digital Crown scroll to adjust BPM smoothly with haptic ticks!
                .focusable(true)
                .digitalCrownRotation(
                    $engine.bpm,
                    from: 40.0,
                    through: 240.0,
                    by: 1.0,
                    sensitivity: .low,
                    isContinuous: false,
                    isHapticFeedbackEnabled: true
                )
                
                Spacer()
                
                // Time Signature Picker & Play/Pause Buttons
                HStack(spacing: 12) {
                    
                    // Time Signature Cycle Button (Designed for high performance watchOS UX)
                    Button(action: cycleTimeSignature) {
                        Text("\(engine.timeSignature)/\(engine.timeSignature == 6 ? 8 : 4)")
                            .font(.system(.caption, design: .rounded).bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.12))
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 60)
                    
                    // Large Play / Pause button
                    Button(action: togglePlayback) {
                        Image(systemName: engine.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                LinearGradient(
                                    colors: engine.isPlaying ? [.pink, .red] : [.indigo, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(22)
                            .shadow(color: (engine.isPlaying ? Color.pink : Color.indigo).opacity(0.3), radius: 6)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.bottom, 6)
            }
        }
        .onChange(of: engine.currentBeat) { _, _ in
            // Trigger visual pulse ring expansion on every beat tick!
            triggerPulseAnimation()
        }
    }
    
    private func togglePlayback() {
        engine.togglePlay()
        triggerPulseAnimation()
    }
    
    private func triggerPulseAnimation() {
        // Expand ring size immediately, then shrink smoothly
        pulseScale = 1.0
        pulseOpacity = 0.8
        
        withAnimation(.easeOut(duration: 60.0 / engine.bpm * 0.75)) {
            pulseScale = 1.35
            pulseOpacity = 0.0
        }
    }
    
    private func cycleTimeSignature() {
        switch engine.timeSignature {
        case 3:
            engine.timeSignature = 4
        case 4:
            engine.timeSignature = 6
        case 6:
            engine.timeSignature = 3
        default:
            engine.timeSignature = 4
        }
        
        // Soft Haptic feedback for cycling signatures
        WKInterfaceDevice.current().play(.click)
    }
}

// Extension to convert Hex string to SwiftUI Color (Consistency across suite)
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let length = hexSanitized.count
        let r, g, b, a: Double
        if length == 6 {
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
            a = 1.0
        } else if length == 8 {
            r = Double((rgb & 0xFF000000) >> 24) / 255.0
            g = Double((rgb & 0x00FF0000) >> 16) / 255.0
            b = Double((rgb & 0x0000FF00) >> 8) / 255.0
            a = Double(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
