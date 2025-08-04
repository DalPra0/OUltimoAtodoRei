////
////  AudioSettingsView.swift
////  FebreAmarela
////
////  Created by Lucas Dal Pra Brascher on 03/08/25.
////
//
//
//import SwiftUI
//
//struct AudioSettingsView: View {
//    @ObservedObject private var audioManager = AudioManager.shared
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        ZStack {
//            // Fundo atmosférico
//            LinearGradient(
//                colors: [
//                    Color.black.opacity(0.95),
//                    Color("OverlayGreen").opacity(0.3),
//                    Color.black.opacity(0.95)
//                ],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
//            
//            VStack(spacing: 30) {
//                // Header
//                HStack {
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("Configurações")
//                            .font(.custom("PlayfairDisplay-Regular", size: 24))
//                            .foregroundColor(.white.opacity(0.8))
//                        Text("de Áudio")
//                            .font(.custom("PlayfairDisplay-Black", size: 36))
//                            .foregroundColor(Color("PrimaryYellow"))
//                            .shadow(color: Color("PrimaryYellow").opacity(0.3), radius: 6)
//                    }
//                    
//                    Spacer()
//                    
//                    Button(action: { dismiss() }) {
//                        ZStack {
//                            Circle()
//                                .fill(Color.black.opacity(0.6))
//                                .frame(width: 44, height: 44)
//                                .overlay(
//                                    Circle()
//                                        .stroke(Color("PrimaryYellow").opacity(0.4), lineWidth: 1)
//                                )
//                            
//                            Image(systemName: "xmark")
//                                .font(.title2)
//                                .fontWeight(.semibold)
//                                .foregroundColor(.white)
//                        }
//                    }
//                }
//                .padding(.horizontal, 20)
//                .padding(.top, 30)
//                
//                // Controles de áudio
//                VStack(spacing: 25) {
//                    
//                    // Volume Master
//                    VStack(alignment: .leading, spacing: 10) {
//                        HStack {
//                            Image(systemName: "speaker.wave.3")
//                                .foregroundColor(Color("PrimaryYellow"))
//                                .font(.title2)
//                            
//                            Text("Volume Geral")
//                                .font(.custom("CourierNewPSMT", size: 18))
//                                .foregroundColor(.white)
//                            
//                            Spacer()
//                            
//                            Text("\(Int(audioManager.masterVolume * 100))%")
//                                .font(.custom("CourierNewPSMT", size: 16))
//                                .foregroundColor(Color("PrimaryYellow"))
//                        }
//                        
//                        Slider(value: Binding(
//                            get: { audioManager.masterVolume },
//                            set: { audioManager.setMasterVolume($0) }
//                        ), in: 0...1)
//                        .accentColor(Color("PrimaryYellow"))
//                    }
//                    .padding(20)
//                    .background(
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(Color.black.opacity(0.4))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 12)
//                                    .stroke(Color("PrimaryYellow").opacity(0.3), lineWidth: 1)
//                            )
//                    )
//                    
//                    // Toggles de áudio
//                    VStack(spacing: 15) {
//                        audioToggle(
//                            title: "Música de Fundo",
//                            icon: "music.note",
//                            isEnabled: audioManager.isMusicEnabled,
//                            action: audioManager.toggleMusic
//                        )
//                        
//                        audioToggle(
//                            title: "Efeitos Sonoros",
//                            icon: "speaker.2",
//                            isEnabled: audioManager.isSFXEnabled,
//                            action: audioManager.toggleSFX
//                        )
//                        
//                        audioToggle(
//                            title: "Narração",
//                            icon: "mic",
//                            isEnabled: audioManager.isNarratorEnabled,
//                            action: audioManager.toggleNarrator
//                        )
//                    }
//                    .padding(20)
//                    .background(
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(Color.black.opacity(0.4))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 12)
//                                    .stroke(Color("PrimaryYellow").opacity(0.3), lineWidth: 1)
//                            )
//                    )
//                    
//                    // Testes de áudio
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Testes de Áudio")
//                            .font(.custom("PlayfairDisplay-Bold", size: 20))
//                            .foregroundColor(Color("PrimaryYellow"))
//                        
//                        HStack(spacing: 10) {
//                            testButton("🎵", "Música") {
//                                AudioManager.shared.playBackgroundMusic("investigation_theme", loop: false)
//                            }
//                            
//                            testButton("🎲", "Dados") {
//                                AudioManager.shared.playDiceRoll()
//                            }
//                            
//                            testButton("👻", "Horror") {
//                                AudioManager.shared.playHorrorStinger()
//                            }
//                            
//                            testButton("🧠", "Sanidade") {
//                                AudioManager.shared.playSanityLoss()
//                            }
//                        }
//                    }
//                    .padding(20)
//                    .background(
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(Color.black.opacity(0.4))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 12)
//                                    .stroke(Color("PrimaryYellow").opacity(0.3), lineWidth: 1)
//                            )
//                    )
//                }
//                .padding(.horizontal, 20)
//                
//                Spacer()
//                
//                // Informações sobre arquivos de áudio
//                VStack(spacing: 8) {
//                    Text("📁 Estrutura de Pastas de Áudio:")
//                        .font(.custom("CourierNewPSMT", size: 14))
//                        .foregroundColor(.white.opacity(0.7))
//                    
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("• Audio/Music/ - Músicas de fundo")
//                        Text("• Audio/Ambient/ - Sons ambiente")
//                        Text("• Audio/Narration/ - Suas dublagens")
//                        Text("• Audio/SFX/ - Efeitos sonoros")
//                    }
//                    .font(.custom("CourierNewPSMT", size: 12))
//                    .foregroundColor(.white.opacity(0.5))
//                }
//                .padding(.bottom, 20)
//            }
//        }
//    }
//    
//    @ViewBuilder
//    private func audioToggle(title: String, icon: String, isEnabled: Bool, action: @escaping () -> Void) -> some View {
//        HStack {
//            Image(systemName: icon)
//                .foregroundColor(Color("PrimaryYellow"))
//                .font(.title3)
//                .frame(width: 30)
//            
//            Text(title)
//                .font(.custom("CourierNewPSMT", size: 16))
//                .foregroundColor(.white)
//            
//            Spacer()
//            
//            Toggle("", isOn: Binding(
//                get: { isEnabled },
//                set: { _ in action() }
//            ))
//            .toggleStyle(SwitchToggleStyle(tint: Color("PrimaryYellow")))
//        }
//    }
//    
//    @ViewBuilder
//    private func testButton(_ emoji: String, _ title: String, action: @escaping () -> Void) -> some View {
//        Button(action: action) {
//            VStack(spacing: 4) {
//                Text(emoji)
//                    .font(.title2)
//                
//                Text(title)
//                    .font(.custom("CourierNewPSMT", size: 10))
//                    .foregroundColor(.white.opacity(0.8))
//            }
//            .frame(width: 60, height: 50)
//            .background(
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(Color.black.opacity(0.6))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color("PrimaryYellow").opacity(0.4), lineWidth: 1)
//                    )
//            )
//        }
//        .buttonStyle(PlainButtonStyle())
//        .scaleEffect(1.0)
//        .onLongPressGesture(minimumDuration: 0) {
//            // Efeito visual quando pressionado
//        }
//    }
//}
//
//struct AudioSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioSettingsView()
//            .previewDevice("iPhone 16 Pro")
//            .previewInterfaceOrientation(.landscapeLeft)
//    }
//}
