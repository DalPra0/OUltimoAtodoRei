import SwiftUI

struct ChoiceItem: Identifiable {
    let id = UUID()
    let text: String
    let goto: String
    let isHighlighted: Bool

    init(text: String, goto: String, isHighlighted: Bool = false) {
        self.text = text
        self.goto = goto
        self.isHighlighted = isHighlighted
    }
}

struct ChoicesView: View {
    let choices: [ChoiceItem]
    let onSelect: (ChoiceItem) -> Void

    @State private var selectedID: UUID?
    @State private var hoverEffect: UUID?

    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer(minLength: geo.safeAreaInsets.top + 20)

                ZStack {
                    ForEach(0..<6, id: \.self) { _ in
                        Circle()
                            .fill(Color.yellow.opacity(0.05))
                            .frame(width: CGFloat.random(in: 2...4))
                            .position(
                                x: CGFloat.random(in: 0...geo.size.width),
                                y: CGFloat.random(in: 0...geo.size.height)
                            )
                            .animation(
                                .easeInOut(duration: Double.random(in: 8...15))
                                .repeatForever(autoreverses: true),
                                value: CGFloat.random(in: 0...100)
                            )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(0)

                VStack(spacing: 18) {
                    ForEach(choices) { choice in
                        Button(action: {
                            selectedID = choice.id
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                onSelect(choice)
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(getIconColor(for: choice))
                                    .opacity(0.8)
                                
                                Text(choice.text)
                                    .font(.custom("CourierNewPSMT", size: 16))
                                    .fontWeight(.medium)
                                    .foregroundColor(getTextColor(for: choice))
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(getBackgroundGradient(for: choice))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        Color.black.opacity(0.6),
                                                        Color.clear,
                                                        Color.black.opacity(0.6)
                                                    ],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                lineWidth: 1
                                            )
                                            .padding(1)
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(getBorderColor(for: choice), lineWidth: 2)
                            )
                            .shadow(color: getShadowColor(for: choice), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .scaleEffect(selectedID == choice.id ? 0.96 : (hoverEffect == choice.id ? 1.02 : 1.0))
                        .animation(.easeInOut(duration: 0.15), value: selectedID)
                        .animation(.easeInOut(duration: 0.2), value: hoverEffect)
                        .onTapGesture {
                            hoverEffect = choice.id
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                hoverEffect = nil
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .zIndex(1)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }

    private func getBackgroundGradient(for choice: ChoiceItem) -> LinearGradient {
        if selectedID == choice.id {
            return LinearGradient(
                colors: [
                    Color.black.opacity(0.9),
                    Color.gray.opacity(0.8),
                    Color.black.opacity(0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else if choice.isHighlighted {
            return LinearGradient(
                colors: [
                    Color.blue.opacity(0.6),
                    Color.black.opacity(0.8),
                    Color.blue.opacity(0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [
                    Color.black.opacity(0.85),
                    Color.gray.opacity(0.4),
                    Color.black.opacity(0.85)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private func getBorderColor(for choice: ChoiceItem) -> Color {
        if selectedID == choice.id {
            return Color.white.opacity(0.8)
        } else if choice.isHighlighted {
            return Color.cyan.opacity(0.7)
        } else {
            return Color.yellow.opacity(0.6)
        }
    }
    
    private func getTextColor(for choice: ChoiceItem) -> Color {
        if selectedID == choice.id {
            return Color.white
        } else if choice.isHighlighted {
            return Color.white.opacity(0.95)
        } else {
            return Color.white.opacity(0.88)
        }
    }
    
    private func getIconColor(for choice: ChoiceItem) -> Color {
        if selectedID == choice.id {
            return Color.white
        } else if choice.isHighlighted {
            return Color.cyan.opacity(0.8)
        } else {
            return Color.yellow.opacity(0.7)
        }
    }
    
    private func getShadowColor(for choice: ChoiceItem) -> Color {
        if selectedID == choice.id {
            return Color.white.opacity(0.2)
        } else if choice.isHighlighted {
            return Color.cyan.opacity(0.3)
        } else {
            return Color.black.opacity(0.8)
        }
    }
}

struct ChoicesView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Image("apartamento")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            ChoicesView(
                choices: [
                    .init(text: "Examinar o corpo e o símbolo", goto: "próximaCena"),
                    .init(text: "Abordar a testemunha de forma direta", goto: "próximaCena"),
                    .init(text: "Acalmar a testemunha", goto: "próximaCena"),
                    .init(text: "Avançar para o Ato 2", goto: "próximaCena", isHighlighted: true)
                ],
                onSelect: { choice in
                    print("Selecionou: \(choice.text)")
                }
            )
        }
        .previewDevice("iPhone 16 Pro")
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
