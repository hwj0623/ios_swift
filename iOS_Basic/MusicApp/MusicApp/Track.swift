//
//  Track.swift
//  MusicApp
//
//  Created by hw on 07/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit
import AVFoundation

class Track{
    var title: String
    var thumbnail: UIImage
    var artist: String
    init(title: String, thumbnail: UIImage, artist: String) {
        self.title = title
        self.thumbnail = thumbnail
        self.artist = artist
    }
    
    /// path로부터 url을 만들어서 해당 Asset을 가져온다.
    var asset: AVAsset{
        let path = Bundle.main.path(forResource: title, ofType: "mov")!
        let url = URL(fileURLWithPath: path)
        let asset = AVAsset(url: url)
        return asset
    }
}
