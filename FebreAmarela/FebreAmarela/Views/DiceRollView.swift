import SwiftUI

struct DiceRollView: View {
    let bonus: Int
    let difficulty: Int
    let onResult: (Bool, Int) -> Void

    @State private var rolling = false
    @State private var currentValue = 1
    @State private var finalValue: Int? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Teste de Habilidade")
                .font(.title2)

            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 120)

                Text("\(finalValue ?? currentValue + bonus)")
                    .font(.system(size: 40, weight: .bold))
            }

            Button(action: {
                rollDice()
            }) {
                Text("Rolar D20")
                    .font(.title3)
                    .padding()
                    .background(rolling ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(rolling || finalValue != nil)

            if let result = finalValue {
                Text(result + bonus >= difficulty ? "✅ Sucesso!" : "❌ Falha!")
                    .font(.title2)
                    .foregroundColor(result + bonus >= difficulty ? .green : .red)
            }
        }
        .padding()
    }

    func rollDice() {
        rolling = true
        finalValue = nil
        var ticks = 0

        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            currentValue = Int.random(in: 1...20)
            ticks += 1

            if ticks > 20 {
                timer.invalidate()
                finalValue = currentValue
                rolling = false

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    let success = (currentValue + bonus) >= difficulty
                    onResult(success, currentValue + bonus)
                }
            }
        }
    }
}
