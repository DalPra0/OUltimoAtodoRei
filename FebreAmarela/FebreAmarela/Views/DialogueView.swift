import SwiftUI

struct DialogueView: View {
    let speaker: String?
    let portrait: String?
    let text: String
    let onContinue: () -> Void
    
    @State private var displayedText: String = ""
    @State private var currentIndex: Int = 0
    @State private var typingTimer: Timer?
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 8) {
                    if let portrait = portrait {
                        Image(portrait)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 140)
                            .shadow(color: .black.opacity(0.6), radius: 10, x: 0, y: 5)
                    }
                    
                    VStack(spacing: 0) {
                        if let speaker = speaker {
                            HStack {
                                Text(speaker)
                                    .font(.custom("PlayfairDisplay-Black", size: 20))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.8), radius: 2, x: 1, y: 1)
                                    .padding(.horizontal, 24)
                                    .padding(.top, 12)
                                Spacer()
                            }
                        }
                        
                        HStack {
                            Text(displayedText)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .lineSpacing(1)
                                .shadow(color: .black.opacity(0.8), radius: 1, x: 1, y: 1)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 14)
                                .lineLimit(nil)
                                .onTapGesture {
                                    if let timer = typingTimer {
                                        timer.invalidate()
                                        typingTimer = nil
                                        displayedText = text
                                    } else {
                                        onContinue()
                                    }
                                }
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                if typingTimer == nil {
                                    onContinue()
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Text(typingTimer == nil ? "Continuar" : "")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    if typingTimer == nil {
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(.trailing, 24)
                            .padding(.bottom, 16)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.black.opacity(0.95),
                                        Color.black.opacity(0.85),
                                        Color.black.opacity(0.95)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.yellow.opacity(0.4),
                                                Color.orange.opacity(0.3),
                                                Color.yellow.opacity(0.4)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(color: .black.opacity(0.9), radius: 20, x: 0, y: 10)
                    )
                    .frame(maxWidth: geo.size.width * 0.95)
                }
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            startTyping()
        }
        .onChange(of: text) {
            startTyping()
        }
    }
    
    private func startTyping() {
        typingTimer?.invalidate()
        displayedText = ""
        currentIndex = 0
        typingTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            if currentIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: currentIndex)
                displayedText.append(text[index])
                currentIndex += 1
            } else {
                timer.invalidate()
                typingTimer = nil
            }
        }
    }
}
