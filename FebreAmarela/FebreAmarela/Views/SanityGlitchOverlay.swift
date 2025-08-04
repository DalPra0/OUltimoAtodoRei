//
//  SanityGlitchOverlay.swift
//  FebreAmarela
//
//  Created by Lucas Dal Pra Brascher on 03/08/25.
//



import SwiftUI

struct SanityGlitchOverlay: View {
    @State private var opacity: Double = 0.0
    @State private var shift: CGFloat = 0.0

    var body: some View {
        ZStack {
            Canvas { context, size in
                for x in stride(from: 0, to: size.width, by: 6) {
                    for y in stride(from: 0, to: size.height, by: 6) {
                        if Bool.random() && Double.random(in: 0...1) < 0.1 {
                            let rect = CGRect(x: x, y: y, width: 1, height: 1)
                            context.fill(Path(rect), with: .color(.white.opacity(Double.random(in: 0.03...0.07))))
                        }
                    }
                }
            }

            Color.red
                .blendMode(.screen)
                .opacity(0.03)
                .offset(x: -shift)

            Color.blue
                .blendMode(.screen)
                .opacity(0.03)
                .offset(x: shift)
        }
        .ignoresSafeArea()
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                opacity = 0.2
                shift = 1.5
            }
        }
    }
}
