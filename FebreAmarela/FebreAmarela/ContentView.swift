

import SwiftUI

enum Screen {
    case title
    case archetype
    case game
    case diceTest
}

struct ContentView: View {
    @State private var screen: Screen = .title
    @StateObject private var manager = GameManager()

    var body: some View {
        Group {
            switch screen {
            case .title:
                TitleView(
                    onStart: {
                        print("🛫 Indo para ArchetypeSelectionView")
                        screen = .archetype
                    },
                    onDebug: {
                        print("🎲 Indo para DiceTestView")
                        screen = .diceTest
                    }
                )

            case .archetype:
                ArchetypeSelectionView { archetypeId in
                    print("✅ Arquétipo selecionado:", archetypeId)
                    manager.selectedArchetype = archetypeId
                    manager.goToScene("CENA_1")
                    screen = .game
                }

            case .game:
                GameView(manager: manager)
                    .onAppear {
                        print("🎬 Entrou no GameView com cena =", manager.currentSceneId)
                    }

            case .diceTest:
                DiceTestView()
            }
        }
        .animation(.easeInOut, value: screen)
        .onAppear {
            print("📱 ContentView apareceu com screen =", screen)
        }
    }
}

#Preview {
    ContentView()
        .previewDevice("iPhone 16")
        .previewInterfaceOrientation(.landscapeLeft)
}
