//
//  FullScreenVideoView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.07.24.
//

import SwiftUI
import AVKit

struct FullScreenVideoView: UIViewRepresentable {
    var url: URL
    func makeUIView(context: Context) -> UIView {
        PlayerUIView(frame: .zero, url: url)
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let playerView = uiView as? PlayerUIView {
            playerView.updatePlayerLayerFrame()
        }
    }
}

// ui view that uses the avplayer, hides the control elements and runs the video in a loop
class PlayerUIView: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var playerStatusObserver: NSKeyValueObservation? // Holds the observation object


    init(frame: CGRect, url: URL) {
        super.init(frame: frame)
        setupPlayer(url: url)
    }


    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPlayer(url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill // fill whole screen
        playerLayer?.frame = self.bounds

        if let layer = playerLayer {
            self.layer.addSublayer(layer)
        }

        playerStatusObserver = player?.observe(\.status, options: [.old, .new]) { [weak self] _, _ in
            if let status = self?.player?.status {
                print("AVPlayer status: \(status.rawValue)")
            }
        }
        player?.play()
        player?.isMuted = true
        print("should play video")
        NotificationCenter.default.addObserver(self, selector: #selector(restartVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }

    func updatePlayerLayerFrame() {
        playerLayer?.frame = self.bounds
    }

    @objc private func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
