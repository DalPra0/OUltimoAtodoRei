//
//  TransitionView.swift.swift
//  FebreAmarela
//
//  Created by Lucas Dal Pra Brascher on 03/08/25.
//

//
//  TransitionView.swift
//  FebreAmarela
//
//  Created by Lucas Dal Pra Brascher on 03/08/25.
//

import SwiftUI

struct TransitionView: View {
    let onComplete: () -> Void

    @State private var animatePulse = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            Image("symbol_overlay")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .scaleEffect(animatePulse ? 1.2 : 0.8)
                .opacity(animatePulse ? 1.0 : 0.0)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        animatePulse.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        onComplete()
                    }
                }
        }
    }
}

struct TransitionView_Previews: PreviewProvider {
    static var previews: some View {
        TransitionView {
            print("Transição concluída")
        }
    }
}
