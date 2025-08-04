import SwiftUI

struct VintageTVFilter: View {
    @State private var scanlineOffset: CGFloat = 0
    @State private var noiseAnimation: Double = 0.0

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                .opacity(0.15)
                .ignoresSafeArea()
            
            Rectangle()
                .fill(Color("OverlayGreen"))
                .blendMode(.multiply)
                .opacity(0.2)
                .ignoresSafeArea()
            
            RadialGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(0.3),
                    Color.black.opacity(0.6)
                ],
                center: .center,
                startRadius: 150,
                endRadius: 500
            )
            .ignoresSafeArea()
            
            VStack(spacing: 3) {
                ForEach(0..<120, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: 0.5)
                        .opacity(0.08)
                }
            }
            .offset(y: scanlineOffset)
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
                    scanlineOffset = 10
                }
            }
            
            Canvas { context, size in
                for x in stride(from: 0, to: size.width, by: 8) {
                    for y in stride(from: 0, to: size.height, by: 8) {
                        if Bool.random() && Double.random(in: 0...1) < 0.05 {
                            let rect = CGRect(x: x, y: y, width: 1, height: 1)
                            context.fill(Path(rect), with: .color(.white.opacity(0.03)))
                        }
                    }
                }
            }
            .ignoresSafeArea()
            
            ZStack {
                Rectangle()
                    .fill(Color.red)
                    .blendMode(.screen)
                    .opacity(0.02)
                    .offset(x: -0.5)
                    .ignoresSafeArea()

                Rectangle()
                    .fill(Color.blue)
                    .blendMode(.screen)
                    .opacity(0.02)
                    .offset(x: 0.5)
                    .ignoresSafeArea()
            }
        }
        .allowsHitTesting(false)
    }
}


@main
struct FebreAmarelaApp: App {
    @StateObject private var manager = GameManager()
    @State private var screen: Screen = .title

    enum Screen {
        case title, archetype, game, diceTest
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch screen {
                case .title:
                    TitleView(
                        onStart: {
                            screen = .archetype
                        },
                        onDebug: {
                            screen = .diceTest
                        }
                    )

                case .archetype:
                    ArchetypeSelectionView { selected in
                        manager.selectedArchetype = selected
                        screen = .game
                    }

                case .game:
                    GameView(manager: manager)

                case .diceTest:
                    DiceTestView()
                }

                VintageTVFilter()
            }
        }
    }
}
