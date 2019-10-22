//
//  TrackListViewController.swift
//  MusicApp
//
//  Created by hw on 07/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit
/// - track model 만들기
/// - track list 만들기
/// - tableViewDelegate, TableViewDataSource
/// - custom TableViewCell
/// - view 구성
class TrackListViewController: UIViewController{
    @IBOutlet weak var trackTableView: UITableView!
    var musicTrackList: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTrackList()
        trackTableView.delegate = self
        trackTableView.dataSource = self
    }
    
    func loadTrackList(){
        musicTrackList = [
            Track.init(title: "Swish", thumbnail: #imageLiteral(resourceName: "Swish") , artist: "Tyga"),
            Track.init(title: "Dip", thumbnail: #imageLiteral(resourceName: "Dip") , artist: "Tyga"),
            Track.init(title: "The Harlem Barber Swing", thumbnail: #imageLiteral(resourceName: "The Harlem Barber Swing") , artist: "Jazzinuf"),
            Track.init(title: "Believer", thumbnail: #imageLiteral(resourceName: "Believer") , artist: "Imagine Dragon"),
            Track.init(title: "Blue Birds", thumbnail: #imageLiteral(resourceName: "Blue Birds") , artist: "Eevee"),
            Track.init(title: "Best Mistake", thumbnail: #imageLiteral(resourceName: "Best Mistake") , artist: "Ariana Grande"),
            Track.init(title: "thank u, next", thumbnail: #imageLiteral(resourceName: "thank u, next") , artist: "Ariana Grande"),
            Track.init(title: "7 rings", thumbnail: #imageLiteral(resourceName: "7 rings") , artist: "Ariana Grande"),
        ]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPlayer" {
            if let playVC = segue.destination as? PlayerViewController, let index = sender as? Int {
                playVC.track = musicTrackList[index]
            }
        }
    }
}

extension TrackListViewController:  UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicTrackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TrackCell else{
            return UITableViewCell()
        }
        let track = musicTrackList[indexPath.row]
        cell.thumbnail.image = track.thumbnail
        cell.artist.text = track.artist
        cell.title.text = track.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowPlayer", sender: indexPath.row)
    }
    
}
