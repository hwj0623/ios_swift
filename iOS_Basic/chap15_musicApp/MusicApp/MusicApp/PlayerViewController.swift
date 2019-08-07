//
//  PlayerViewController.swift
//  MusicApp
//
//  Created by hw on 07/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit
import AVFoundation


///Todo
/// - segue연결하기
/// - segue 데이터 받기
/// - segue 받은 데이터 정보 표시하기
/// - 플레이어 준비하기
/// - 시간업데이트하기
/// - currentTime
/// - totalDurationTime
/// - 플레이 함수
/// - 정지 함수
/// - seeking
/// 플레이 버튼 탭 (IBAction 연결)
/// 슬라이더 밸류 변경 > Drag 시점
/// 드래깅 엔드 > Drag end 시점 (IBAction으로 seek 호출하는 부분)
/// 닫기
class PlayerViewController: UIViewController {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalDurationTimeLabel: UILabel!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    
    var track: Track?
    var avplayer: AVPlayer?
    var timeObserver: Any?
    
    var currentTime: Double{
        return avplayer?.currentItem?.currentTime().seconds ?? 0
    }
    var totalDurationTime: Double{
        return avplayer?.currentItem?.duration.seconds ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        prepareToPlay()
        /// 시간 업데이트
        timeObserver = avplayer?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 10), queue: DispatchQueue.main) { time in
            self.updateTime(time: time)
        }
    }
    
    func updateUI(){
        guard let currentTrack = track else { return }
        thumbnail.image = currentTrack.thumbnail
        trackTitle.text = currentTrack.title
        artistName.text = currentTrack.artist
        playPauseButton.setImage(#imageLiteral(resourceName: "icPlay"), for: .normal)
    }
    
    func prepareToPlay(){
        guard let currentTrack = track else {return}
        let asset = currentTrack.asset
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        avplayer = player
        
    }
    
    func updateTime(time: CMTime){
        currentTimeLabel.text = secondsToString(sec: currentTime)
        totalDurationTimeLabel.text = secondsToString(sec: totalDurationTime)
        if isSeeking == false {
            timeSlider.value = Float(currentTime/totalDurationTime)
        }
    }
    
    func secondsToString(sec: Double) -> String{
        guard sec.isNaN == false else { return "00:00"}
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", min, seconds)
    }
    
    func play(){
        avplayer?.play()
    }
    
    func pause(){
       avplayer?.pause()
    }
    
    func seek(to: Double){ ///to 는 0~1사이의 비율
        let timescale: CMTimeScale = 10 /// Int32. 1초를 10분할
        /// to: 0~1, ex; 0.5*60초 = 30초 (timescale 1 기준)
        let targetTime: CMTimeValue = CMTimeValue(to * totalDurationTime) * CMTimeValue(timescale)    /// Int64
        let time = CMTime(value: targetTime, timescale: 10)
        avplayer?.seek(to: time)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton){
        let isPlaying = avplayer?.rate == 1
        if isPlaying {
            avplayer?.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "icPlay"), for: .normal)
        }else{
            avplayer?.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "icPause"), for: .normal)
        }
    }
    var isSeeking = false
    @IBAction func dragging(_ sender: UISlider){
        isSeeking = true
    }
    
    @IBAction func endDragging(_ sender: UISlider){
        isSeeking = false
        seek(to: Double(sender.value))
    }
    private func clearAVPlayer(){
        avplayer?.replaceCurrentItem(with: nil)
        avplayer = nil
    }
    @IBAction func close(){
        pause()
        clearAVPlayer()
        dismiss(animated: true, completion: nil)
    }
}
