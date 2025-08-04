import SwiftUI

struct ArchetypeSelectionView: View {
    var onSelect: (String) -> Void

    private let archetypes = [
        ("inspetor", "Inspetor", "Bônus em Investigação + Raciocínio"),
        ("intimidador", "Intimidador", "Bônus em Intimidação + Força"),
        ("persuasivo", "Persuasivo", "Bônus em Persuasão + Percepção")
    ]

    var body: some View {
        ZStack {
            Image("archetype_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            Color("OverlayGreen")
                .blendMode(.overlay)
                .ignoresSafeArea()

            HStack(spacing: 32) {
                ForEach(archetypes, id: \.0) { raw, title, description in
                    VStack(spacing: 12) {
                        Text(title)
                            .font(.custom("PlayfairDisplay-Black", size: 28))
                            .foregroundColor(Color("PrimaryYellow"))
                            .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 0)

                        Text(description)
                            .font(.custom("CourierNewPSMT", size: 16))
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)

                        Button(action: { onSelect(raw) }) {
                            Text("Selecionar")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(width: 200, height: 60)
                                .background(Color("PrimaryYellow"))
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                    }
                    .padding(16)
                    .background(Color("OverlayGreen").opacity(0.4))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct ArchetypeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ArchetypeSelectionView { _ in }
            .previewDevice("iPhone 16")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
