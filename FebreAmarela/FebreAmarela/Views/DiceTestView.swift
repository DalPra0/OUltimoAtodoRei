import SwiftUI

struct DiceTestView: View {
    @State private var showing = true

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if showing {
                DiceRollOverlayView(
                    skillName: "percepção",
                    bonus: 2,
                    difficulty: 12
                ) { success, total in
                    print("Resultado: \(total) – Sucesso? \(success)")
                    showing = false
                }
            }
        }
    }
}
