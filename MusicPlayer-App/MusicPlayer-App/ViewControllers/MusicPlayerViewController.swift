//
//  MusicPlayerViewController.swift
//  MusicPlayer-App
//
//  Created by Dinesh Danda on 2/21/21.
//  Copyright © 2021 Dinesh Danda. All rights reserved.
//

import UIKit

final class MusicPlayerViewController: UIViewController {
    var album: Album
    
    private lazy var mediaPlayer: MediaPlayer = {
        let player = MediaPlayer(album: album)
        player.translatesAutoresizingMaskIntoConstraints = false
        return player
    }()
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func addBlurredView() {
        if !UIAccessibility.isReduceMotionEnabled {
            self.view.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            view.addSubview(blurEffectView)
        } else {
            view.backgroundColor = UIColor.black
        }
    }
    
    private func setupView() {
        addBlurredView()
        view.addSubview(mediaPlayer)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([mediaPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     mediaPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     mediaPlayer.topAnchor.constraint(equalTo: view.topAnchor),
                                     mediaPlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mediaPlayer.play()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mediaPlayer.stop()
        UIApplication.shared.isIdleTimerDisabled = false
    }
}
