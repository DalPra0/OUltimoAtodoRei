//
//  DiaryView.swift
//  FebreAmarela
//
//  Created by Lucas Dal Pra Brascher on 03/08/25.
//

import SwiftUI
import AVKit

struct DiaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: configuration.isPressed)
    }
}

struct DiaryView: View {
    @ObservedObject var manager: GameManager
    let nextSceneId: String

    @State private var page = 1
    @State private var isPlayingVideo = false
    @State private var player: AVPlayer?
    @State private var onVideoCompletion: (() -> Void)?

    var body: some View {
        ZStack {
            if isPlayingVideo, let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .onAppear {
                        player.play()
                        NotificationCenter.default.addObserver(
                            forName: .AVPlayerItemDidPlayToEndTime,
                            object: player.currentItem,
                            queue: .main
                        ) { _ in
                            player.pause()
                            isPlayingVideo = false
                            onVideoCompletion?()
                        }
                    }
            } else {
                Image("diario\(page)")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()

                VStack {
                    HStack {
                        Button("VOLTAR") {
                            if page == 2 {
                                playVideo(named: "DiariosPassandoPaginas2-1") {
                                    page = 1
                                }
                            } else if page > 2 {
                                page -= 1
                            }
                        }
                        .buttonStyle(DiaryButtonStyle())

                        Button("AVANÇAR") {
                            if page == 1 {
                                playVideo(named: "DiariosPassandoPagina1-2") {
                                    page = 2
                                }
                            } else if page == 2 {
                                page = 3
                            } else {
                                manager.goToScene(nextSceneId)
                            }
                        }
                        .buttonStyle(DiaryButtonStyle())
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                }
                .padding(.top, 50)
                .background(Color("OverlayGreen").opacity(0.4))
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }

    private func playVideo(named name: String, completion: @escaping () -> Void) {
        let videoURL = Bundle.main.url(
            forResource: name,
            withExtension: "mp4",
            subdirectory: "VideosPassandoPaginas"
        ) ?? Bundle.main.url(
            forResource: name,
            withExtension: "mp4"
        )

        guard let url = videoURL else {
            print("❌ Vídeo \(name).mp4 não encontrado no bundle")
            completion()
            return
        }

        player = AVPlayer(url: url)
        onVideoCompletion = completion
        isPlayingVideo = true
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        let gm = GameManager()
        return DiaryView(manager: gm, nextSceneId: "cenaAfterDiary")
            .previewDevice("iPhone 16 Pro")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
