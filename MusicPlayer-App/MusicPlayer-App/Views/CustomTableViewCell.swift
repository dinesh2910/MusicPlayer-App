//
//  CustomTableViewCell.swift
//  MusicPlayer-App
//
//  Created by Dinesh Danda on 2/20/21.
//  Copyright © 2021 Dinesh Danda. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var album: Album? {
        didSet {
            if let album = album {
                albumCover.image = UIImage(named: album.image)
                albumName.text = album.name
                songsCount.text = "\(album.songs.count) Songs"
            }
        }
    }
    private lazy var albumCover: UIImageView = {
        let coverImage = UIImageView()
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        coverImage.contentMode = .scaleToFill
        coverImage.layer.cornerRadius = 25
        coverImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        return coverImage
    }()
    
    private lazy var albumName: UILabel = {
        let albumTitle = UILabel()
        albumTitle.translatesAutoresizingMaskIntoConstraints = false
        albumTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        albumTitle.textColor = UIColor(named: "titleColor")
        return albumTitle
    }()
    
    private lazy var songsCount: UILabel = {
        let songsCount = UILabel()
        songsCount.translatesAutoresizingMaskIntoConstraints = false
        songsCount.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        songsCount.textColor = UIColor(named: "subtitleColor")
        songsCount.numberOfLines = 0
        return songsCount
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [albumCover, albumName, songsCount].forEach { (view) in
            contentView.addSubview(view)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([albumCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                                     albumCover.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                                     albumCover.widthAnchor.constraint(equalToConstant: 100),
                                     albumCover.heightAnchor.constraint(equalToConstant: 100),
                                     albumCover.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([albumName.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 16),
                                     albumName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                                     albumName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([songsCount.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 16),
                                     songsCount.topAnchor.constraint(equalTo: albumName.bottomAnchor, constant: 8),
                                     songsCount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                                     songsCount.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
