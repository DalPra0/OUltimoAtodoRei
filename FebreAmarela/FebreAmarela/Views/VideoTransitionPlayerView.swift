import SwiftUI
import AVKit

struct VideoTransitionPlayerView: View {
    let videoName: String
    let onFinished: () -> Void

    @State private var player: AVPlayer?

    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        player.play()
                        NotificationCenter.default.addObserver(
                            forName: .AVPlayerItemDidPlayToEndTime,
                            object: player.currentItem,
                            queue: .main
                        ) { _ in
                            onFinished()
                        }
                    }
            } else {
                Color.black.onAppear {
                    if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4", subdirectory: "VideosPassandoPaginas") {
                        player = AVPlayer(url: url)
                    } else {
                        print("❌ Erro: vídeo '\(videoName).mp4' não encontrado no bundle.")
                        onFinished()
                    }
                }
            }
        }
    }
}
