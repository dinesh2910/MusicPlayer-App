//
//  Album.swift
//  MusicPlayer-App
//
//  Created by Dinesh Danda on 2/20/21.
//  Copyright © 2021 Dinesh Danda. All rights reserved.
//

import Foundation

struct Album {
    var name: String
    var image: String
    var songs: [Song]
}

extension Album {
    static func getAlbum() -> [Album] {
        return [Album(name: "Upanna", image: "music1", songs: [Song(name: "Ishq Sefhaya", image: "music1", artist: "DSP", fileName: "song1"),
                                                               Song(name: "Dhichuku", image: "music2", artist: "DSP", fileName: "song2"),
                                                               Song(name: "Love Story", image: "music3", artist: "DSP", fileName: "song3")]),
                Album(name: "Red", image: "music2", songs: [Song(name: "Ishq Sefhaya", image: "music1", artist: "DSP", fileName: "song1"),
                                                            Song(name: "Dhichuku", image: "music2", artist: "DSP", fileName: "song2"),
                                                            Song(name: "Love Story", image: "music3", artist: "DSP", fileName: "song3")]),
                Album(name: "Love Story", image: "music3", songs: [Song(name: "Love Story", image: "music1", artist: "DSP", fileName: "song1"),
                                                                   Song(name: "Dhichuku", image: "music2", artist: "DSP", fileName: "song2"),
                                                                   Song(name: "Love Story", image: "music3", artist: "DSP", fileName: "song3")])
        ]
    }
}
