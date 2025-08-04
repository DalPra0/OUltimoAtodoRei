//
//  NotebookView.swift
//  FebreAmarela
//
//  Created by Lucas Dal Pra Brascher on 03/08/25.
//

import SwiftUI

struct Clue: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let imageName: String?
}

struct NotebookButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct FloatingParticles: View {
    @State private var positions: [CGPoint] = []
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color("PrimaryYellow").opacity(0.15),
                                Color("PrimaryYellow").opacity(0.05),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 1,
                            endRadius: 3
                        )
                    )
                    .frame(width: CGFloat.random(in: 2...6))
                    .position(animate ? randomPosition() : initialPosition())
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 12...20))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...8)),
                        value: animate
                    )
                    .opacity(animate ? Double.random(in: 0.3...0.8) : 0)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animate = true
            }
        }
    }
    
    private func randomPosition() -> CGPoint {
        CGPoint(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
        )
    }
    
    private func initialPosition() -> CGPoint {
        CGPoint(
            x: CGFloat.random(in: 50...UIScreen.main.bounds.width - 50),
            y: CGFloat.random(in: 100...UIScreen.main.bounds.height - 100)
        )
    }
}

struct ClueDetailView: View {
    let clue: Clue
    @Environment(\.dismiss) private var dismiss
    @State private var showContent = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black.opacity(0.95),
                    Color("OverlayGreen").opacity(0.3),
                    Color.black.opacity(0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            FloatingParticles()
                .opacity(0.3)

            VStack(spacing: 24) {
                Text(clue.title)
                    .font(.custom("PlayfairDisplay-Black", size: 32))
                    .foregroundColor(Color("PrimaryYellow"))
                    .multilineTextAlignment(.center)
                    .shadow(color: Color("PrimaryYellow").opacity(0.3), radius: 8, x: 0, y: 0)
                    .overlay(
                        Text(clue.title)
                            .font(.custom("PlayfairDisplay-Black", size: 32))
                            .foregroundColor(.clear)
                            .multilineTextAlignment(.center)
                            .background(
                                LinearGradient(
                                    colors: [Color("PrimaryYellow").opacity(0.8), Color.clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .mask(
                                Text(clue.title)
                                    .font(.custom("PlayfairDisplay-Black", size: 32))
                                    .multilineTextAlignment(.center)
                            )
                    )

                if let imageName = clue.imageName {
                    VStack {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color("PrimaryYellow").opacity(0.6), Color.clear],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(color: Color("PrimaryYellow").opacity(0.2), radius: 15, x: 0, y: 5)
                    }
                    .padding(.horizontal, 8)
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(clue.content)
                            .font(.custom("CourierNewPSMT", size: 18))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.leading)
                            .lineSpacing(4)
                            .opacity(showContent ? 1 : 0)
                            .animation(.easeInOut(duration: 1.2), value: showContent)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.4))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color("OverlayGreen").opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                .frame(maxHeight: 200)

                Button("Fechar") {
                    dismiss()
                }
                .buttonStyle(NotebookButtonStyle())
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [Color("PrimaryYellow"), Color("PrimaryYellow").opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .foregroundColor(.black)
                .fontWeight(.bold)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color("PrimaryYellow").opacity(0.6), lineWidth: 1)
                )
                .shadow(color: Color("PrimaryYellow").opacity(0.4), radius: 10, x: 0, y: 4)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("OverlayGreen").opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [Color("PrimaryYellow").opacity(0.3), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .padding(.horizontal, 20)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                showContent = true
            }
        }
    }
}

struct NotebookView: View {
    let clues: [Clue]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedClue: Clue?
    @State private var showClues = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color("OverlayGreen").opacity(0.8),
                    Color.black.opacity(0.6),
                    Color("OverlayGreen").opacity(0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            FloatingParticles()
                .opacity(0.4)

            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Caderno de")
                            .font(.custom("PlayfairDisplay-Regular", size: 24))
                            .foregroundColor(.white.opacity(0.8))
                        Text("Pistas")
                            .font(.custom("PlayfairDisplay-Black", size: 36))
                            .foregroundColor(Color("PrimaryYellow"))
                            .shadow(color: Color("PrimaryYellow").opacity(0.3), radius: 6, x: 0, y: 0)
                    }
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.6))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle()
                                        .stroke(Color("PrimaryYellow").opacity(0.4), lineWidth: 1)
                                )
                            
                            Image(systemName: "xmark")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(NotebookButtonStyle())
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(Array(clues.enumerated()), id: \.element.id) { index, clue in
                            Button(action: {
                                selectedClue = clue
                            }) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(Color("PrimaryYellow").opacity(0.2))
                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: "book.closed.fill")
                                            .font(.title2)
                                            .foregroundColor(Color("PrimaryYellow"))
                                            .shadow(color: Color("PrimaryYellow").opacity(0.6), radius: 4, x: 0, y: 0)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(clue.title)
                                            .font(.custom("CourierNewPSMT", size: 18))
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.leading)
                                        
                                        Text("Toque para investigar...")
                                            .font(.custom("CourierNewPSMT", size: 12))
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(Color("PrimaryYellow").opacity(0.7))
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.black.opacity(0.4))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [
                                                            Color("PrimaryYellow").opacity(0.3),
                                                            Color("OverlayGreen").opacity(0.2)
                                                        ],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 1
                                                )
                                        )
                                )
                                .shadow(color: Color("PrimaryYellow").opacity(0.1), radius: 8, x: 0, y: 4)
                                .padding(.horizontal, 20)
                            }
                            .buttonStyle(NotebookButtonStyle())
                            .opacity(showClues ? 1 : 0)
                            .offset(y: showClues ? 0 : 30)
                            .animation(
                                .easeOut(duration: 0.6)
                                .delay(Double(index) * 0.1),
                                value: showClues
                            )
                        }
                    }
                    .padding(.vertical, 12)
                }

                Spacer()
            }
            .sheet(item: $selectedClue) { clue in
                ClueDetailView(clue: clue)
            }
        }
        .onAppear {
            withAnimation {
                showClues = true
            }
        }
    }
}

struct NotebookView_Previews: PreviewProvider {
    static var sampleClues: [Clue] = [
        .init(title: "Símbolo Misterioso", content: "Uma inscrição amarelada descoberta na parede do apartamento. Os símbolos parecem pulsar com uma energia sinistra, como se estivessem vivos. Cada linha e curva parece sussurrar segredos ancestrais que a mente humana não deveria conhecer...", imageName: nil),
        .init(title: "Pedaço de Jornal", content: "Recorte de jornal antigo falando sobre desaparecimentos misteriosos na região. As páginas amareladas pelo tempo contam histórias de pessoas que simplesmente se desvaneceram, deixando apenas rastros de uma presença sobrenatural...", imageName: "diario2"),
        .init(title: "Rascunho do Culto", content: "Anotações que mencionam rituais proibidos e nomes que não deveriam ser pronunciados. A tinta parece ter sido escrita com algo que não é sangue comum, e as palavras parecem se mover quando observadas por muito tempo...", imageName: "camarim")
    ]

    static var previews: some View {
        NotebookView(clues: sampleClues)
            .previewDevice("iPhone 16 Pro")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
