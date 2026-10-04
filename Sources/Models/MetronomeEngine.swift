import Foundation
import WatchKit
import SwiftUI

class MetronomeEngine: NSObject, ObservableObject, WKExtendedRuntimeSessionDelegate {
    static let shared = MetronomeEngine()
    
    @Published var bpm: Double = 120.0 {
        didSet {
            // If playing, restart timer with new interval immediately!
            if isPlaying {
                restartTimer()
            }
        }
    }
    
    @Published var timeSignature: Int = 4 // 4 for 4/4, 3 for 3/4, 6 for 6/8
    @Published var currentBeat: Int = 1
    @Published var isPlaying: Bool = false
    
    private var session: WKExtendedRuntimeSession?
    private var timer: Timer?
    
    private override init() {
        super.init()
    }
    
    func togglePlay() {
        if isPlaying {
            stop()
        } else {
            start()
        }
    }
    
    private func start() {
        isPlaying = true
        currentBeat = 1
        
        // 1. Start the WKExtendedRuntimeSession (watchOS background session)
        // This keeps the watch app thread alive and vibrating for up to 1 hour even when wrist is lowered!
        session = WKExtendedRuntimeSession()
        session?.delegate = self
        session?.start()
        
        // 2. Start the Timer
        startTimer()
        
        // Trigger the very first beat haptic immediately
        triggerBeatHaptic()
    }
    
    private func stop() {
        isPlaying = false
        
        // Stop timer
        timer?.invalidate()
        timer = nil
        
        // Invalidate background session
        session?.invalidate()
        session = nil
    }
    
    private func startTimer() {
        let interval = 60.0 / bpm
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    private func restartTimer() {
        timer?.invalidate()
        startTimer()
    }
    
    private func tick() {
        // Increment beat count
        if currentBeat >= timeSignature {
            currentBeat = 1
        } else {
            currentBeat += 1
        }
        
        // Trigger haptic beat
        triggerBeatHaptic()
    }
    
    private func triggerBeatHaptic() {
        let device = WKInterfaceDevice.current()
        
        if currentBeat == 1 {
            // First Beat: Strong accent beat!
            device.play(.success)
        } else {
            // Remaining Beats: Sleek tick/click beat!
            device.play(.click)
        }
    }
    
    // MARK: - WKExtendedRuntimeSessionDelegate Methods
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("AuraMetronome background session successfully started.")
    }
    
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        print("AuraMetronome background session invalidated. Reason: \(reason). App will continue playing in foreground.")
        // Clean up session reference but do NOT call stop() so foreground playback remains active!
        session = nil
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("AuraMetronome session will expire soon.")
    }
}
