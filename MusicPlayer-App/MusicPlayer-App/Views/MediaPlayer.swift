//
//  MediaPlayer.swift
//  MusicPlayer-App
//
//  Created by Dinesh Danda on 2/20/21.
//  Copyright © 2021 Dinesh Danda. All rights reserved.
//

import Foundation
import AVKit

final class MediaPlayer: UIView {
    
    var album: Album
    private var player = AVAudioPlayer()
    private var timer: Timer?
    private var playingIndex = 0
    
    init(album: Album) {
        self.album = album
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        albumName.text = album.name
        albumImage.image = UIImage(named: album.image)
        setupPlayer(song: album.songs[playingIndex])
        [albumName, albumImage, songLabel, artistLabel, totalTimeLabel, remainingTimeLabel, controlStackView, progressBar].forEach { (view) in
            addSubview(view)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([albumName.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     albumName.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     albumName.topAnchor.constraint(equalTo: topAnchor, constant: 16)])
        
        NSLayoutConstraint.activate([albumImage.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     albumImage.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     albumImage.topAnchor.constraint(equalTo: albumName.bottomAnchor, constant: 16),
                                     albumImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5)])
        
        NSLayoutConstraint.activate([songLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                                     songLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                                     songLabel.topAnchor.constraint(equalTo: albumImage.bottomAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([artistLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                                     artistLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                                     artistLabel.topAnchor.constraint(equalTo: songLabel.bottomAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                                     progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                                     progressBar.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([totalTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                                     totalTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([remainingTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                                     remainingTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8)])
        
        NSLayoutConstraint.activate([controlStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
                                     controlStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
                                     controlStackView.topAnchor.constraint(equalTo: remainingTimeLabel.bottomAnchor, constant: 8)])
        
        
    }
    
    private func setupPlayer(song: Song) {
        guard let url = Bundle.main.url(forResource: song.fileName, withExtension: "mp3") else { return }
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
        }
        albumName.text = song.name
        artistLabel.text = song.artist
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    private lazy var albumName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private lazy var albumImage: UIImageView = {
        let coverImage = UIImageView()
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        coverImage.contentMode = .scaleToFill
        coverImage.layer.cornerRadius = 100
        coverImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        return coverImage
    }()
    
    private lazy var progressBar: UISlider = {
        let progressBar = UISlider()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.addTarget(self, action: #selector(didSlideProgressBar), for: .valueChanged)
        progressBar.minimumTrackTintColor = UIColor.init(named: "subtitleColor")
        return progressBar
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapOnPreviousButton), for: .touchUpInside)
        let configure = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "backward.end.fill" , withConfiguration: configure), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var pauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapOnPauseButton), for: .touchUpInside)
        let configure = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "play.circle.fill" , withConfiguration: configure), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapOnNextButton), for: .touchUpInside)
        let configure = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "forward.end.fill" , withConfiguration: configure), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var controlStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [previousButton, pauseButton, nextButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.spacing = 20
        return sv
    }()
    
    private lazy var totalTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.text = "00:00"
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.text = "00:00"
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var songLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    func play() {
        progressBar.value = 0.0
        progressBar.maximumValue = Float(player.duration)
        player.play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    func stop() {
        player.stop()
        timer?.invalidate()
        timer = nil
    }
    
    func setPlayPauseIcon(isPlaying: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 100)
        pauseButton.setImage(UIImage(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill", withConfiguration: config), for: .normal)
    }
    
    @objc
    private func didSlideProgressBar(_ sender: UISlider) {
        player.currentTime = Float64(sender.value)
    }
    
    @objc
    private func didTapOnPreviousButton(_ sender: UIButton) {
        playingIndex -= 1
        if playingIndex < 0 {
            playingIndex = album.songs.count - 1
        }
        setupPlayer(song: album.songs[playingIndex])
        play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    @objc
    private func didTapOnPauseButton(_ sender: UIButton) {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    @objc
    private func didTapOnNextButton(_ sender: UIButton) {
        playingIndex += 1
        if playingIndex >= album.songs.count {
            playingIndex = 0
        }
        setupPlayer(song: album.songs[playingIndex])
        play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    @objc
    private func updateProgressBar() {
        progressBar.value = Float(player.currentTime)
        let remainingTime = player.duration - player.currentTime
        remainingTimeLabel.text = getTimeFormatted(timeInterval: remainingTime)
    }
    
    private func getTimeFormatted(timeInterval: TimeInterval) -> String {
        let mins = timeInterval / 60
        let sec = timeInterval.truncatingRemainder(dividingBy: 60)
        let timeFormatter = NumberFormatter()
        timeFormatter.minimumIntegerDigits = 2
        timeFormatter.minimumFractionDigits = 0
        timeFormatter.roundingMode = .down
        
        guard let minsString = timeFormatter.string(from: NSNumber(value: mins)), let secString = timeFormatter.string(from: NSNumber(value: sec)) else { return "00:00"}
        return "\(minsString):\(secString)"
    }
    
}


extension MediaPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        didTapOnNextButton(nextButton)
    }
}
