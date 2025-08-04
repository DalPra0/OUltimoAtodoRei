import AVFoundation
import SwiftUI

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var narratorPlayer: AVAudioPlayer?
    private var sfxPlayer: AVAudioPlayer?
    
    @Published var isMusicEnabled = true
    @Published var isSFXEnabled = true
    @Published var isNarratorEnabled = true
    @Published var masterVolume: Float = 0.7
    
    private var currentMusicTrack: String?
    
    init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("❌ Erro ao configurar sessão de áudio: \(error)")
        }
    }
    
    func playBackgroundMusic(_ trackName: String, loop: Bool = true) {
        guard isMusicEnabled, currentMusicTrack != trackName else { return }
        
        backgroundMusicPlayer?.stop()
        
        guard let url = Bundle.main.url(forResource: trackName, withExtension: "mp3", subdirectory: "Audio/Music") ??
                        Bundle.main.url(forResource: trackName, withExtension: "wav", subdirectory: "Audio/Music") ??
                        Bundle.main.url(forResource: trackName, withExtension: "mp3") ??
                        Bundle.main.url(forResource: trackName, withExtension: "wav") else {
            print("❌ Música não encontrada: \(trackName)")
            return
        }
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = loop ? -1 : 0
            backgroundMusicPlayer?.volume = masterVolume * 0.6
            backgroundMusicPlayer?.play()
            currentMusicTrack = trackName
            
            print("🎵 Tocando música: \(trackName)")
        } catch {
            print("❌ Erro ao tocar música: \(error)")
        }
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        currentMusicTrack = nil
    }
    
    func playNarration(_ fileName: String, completion: (() -> Void)? = nil) {
        guard isNarratorEnabled else {
            completion?()
            return
        }
        
        narratorPlayer?.stop()
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3", subdirectory: "Audio/Narration") ??
                        Bundle.main.url(forResource: fileName, withExtension: "wav", subdirectory: "Audio/Narration") ??
                        Bundle.main.url(forResource: fileName, withExtension: "m4a", subdirectory: "Audio/Narration") ??
                        Bundle.main.url(forResource: fileName, withExtension: "mp3") ??
                        Bundle.main.url(forResource: fileName, withExtension: "wav") else {
            print("❌ Narração não encontrada: \(fileName)")
            completion?()
            return
        }
        
        do {
            narratorPlayer = try AVAudioPlayer(contentsOf: url)
            narratorPlayer?.volume = masterVolume * 0.8
            narratorPlayer?.play()
            
            print("🎙️ Tocando narração: \(fileName)")
            
            if let completion = completion {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                    if let player = self.narratorPlayer, !player.isPlaying {
                        timer.invalidate()
                        completion()
                    }
                }
            }
        } catch {
            print("❌ Erro ao tocar narração: \(error)")
            completion?()
        }
    }
    
    func stopNarration() {
        narratorPlayer?.stop()
    }
    
    func playSFX(_ soundName: String, volume: Float = 1.0) {
        guard isSFXEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3", subdirectory: "Audio/SFX") ??
                        Bundle.main.url(forResource: soundName, withExtension: "wav", subdirectory: "Audio/SFX") ??
                        Bundle.main.url(forResource: soundName, withExtension: "mp3") ??
                        Bundle.main.url(forResource: soundName, withExtension: "wav") else {
            print("❌ SFX não encontrado: \(soundName)")
            return
        }
        
        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: url)
            sfxPlayer?.volume = masterVolume * volume
            sfxPlayer?.play()
            
            print("🎲 Tocando SFX: \(soundName)")
        } catch {
            print("❌ Erro ao tocar SFX: \(error)")
        }
    }
    
    
    func playDiceRoll() {
        playSFX("dice_roll", volume: 0.8)
    }
    
    func playDiceResult(success: Bool) {
        playSFX(success ? "success_chime" : "failure_drone", volume: 0.9)
    }
    
    func playSanityLoss() {
        playSFX("sanity_loss", volume: 0.7)
    }
    
    func playClueFound() {
        playSFX("clue_found", volume: 0.6)
    }
    
    func playSceneTransition() {
        playSFX("scene_transition", volume: 0.5)
    }
    
    func playHorrorStinger() {
        playSFX("horror_stinger", volume: 1.0)
    }
    
    func stopAllAudio() {
        stopBackgroundMusic()
        stopNarration()
    }
}
