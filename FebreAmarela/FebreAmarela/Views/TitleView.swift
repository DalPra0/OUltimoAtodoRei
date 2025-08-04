import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: configuration.isPressed)
    }
}

struct CosmicHorrorButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .shadow(color: Color("PrimaryYellow").opacity(0.4), radius: configuration.isPressed ? 4 : 8)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct TitleView: View {
    let onStart: () -> Void
    let onDebug: () -> Void // NOVO

    @State private var flickerOpacity = 1.0
    @State private var glowPulse = false

    var body: some View {
        ZStack {
            Image("title_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            Color.black.opacity(0.5)
                .ignoresSafeArea()

            HStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("O ÚLTIMO")
                        .font(.custom("Copperplate-Bold", size: 60))
                        .foregroundColor(Color("PrimaryYellow"))
                        .opacity(flickerOpacity)
                        .shadow(color: Color("PrimaryYellow").opacity(0.6), radius: glowPulse ? 12 : 6)
                        .shadow(color: Color.black, radius: 4, x: 2, y: 2)

                    Text("ATO DO REI")
                        .font(.custom("Copperplate-Bold", size: 60))
                        .foregroundColor(Color("PrimaryYellow"))
                        .opacity(flickerOpacity)
                        .shadow(color: Color("PrimaryYellow").opacity(0.6), radius: glowPulse ? 12 : 6)
                        .shadow(color: Color.black, radius: 4, x: 2, y: 2)
                        .offset(x: 20)

                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color("PrimaryYellow"),
                                    Color("PrimaryYellow").opacity(0.3),
                                    Color.clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 200, height: 2)
                        .shadow(color: Color("PrimaryYellow").opacity(0.8), radius: 4)
                        .padding(.top, 8)
                }
                .kerning(4.0)

                Spacer()

                VStack(spacing: 16) {
                    Text("Entre na escuridão...")
                        .font(.system(size: 16, weight: .medium, design: .serif))
                        .foregroundColor(Color("PrimaryYellow").opacity(0.8))
                        .italic()

                    Button(action: onStart) {
                        VStack(spacing: 4) {
                            Text("INICIAR")
                                .font(.system(size: 20, weight: .heavy))
                                .kerning(2.0)

                            Rectangle()
                                .fill(Color.black.opacity(0.3))
                                .frame(height: 1)
                                .padding(.horizontal, 8)

                            Text("JOGO")
                                .font(.system(size: 20, weight: .heavy))
                                .kerning(2.0)
                        }
                        .frame(width: 160, height: 80)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("PrimaryYellow"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.black.opacity(0.4), lineWidth: 2)
                                )
                        )
                        .foregroundColor(.black)
                    }
                    .buttonStyle(CosmicHorrorButtonStyle())
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("PrimaryYellow").opacity(0.3), lineWidth: 1)
                        )
                )
                .shadow(color: Color.black.opacity(0.6), radius: 12, x: -2, y: 2)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 20)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button("🎲") {
                        onDebug()
                    }
                    .font(.caption)
                    .padding(8)
                    .background(Color.black.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    .padding(.trailing, 24)
                    .padding(.bottom, 24)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                flickerOpacity = 0.85
            }

            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                glowPulse.toggle()
            }
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(
            onStart: {},
            onDebug: {}
        )
        .previewDevice("iPhone 16 Pro")
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
