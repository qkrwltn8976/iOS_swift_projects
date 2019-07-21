//
//  ViewController.swift
//  MusicPlayer
//
//  Created by 박지수 on 15/07/2019.
//  Copyright © 2019 박지수. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var player: AVAudioPlayer!
    var timer: Timer!
    
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePlayer()
        
    }


}

extension ViewController: AVAudioPlayerDelegate {
    func initializePlayer(){
        guard let sound = NSDataAsset(name: "sound")
            else {print("음원 파일이 존재하지 않습니다")
            return
        }
        do {
            try self.player = AVAudioPlayer(data: sound.data)
            self.player.delegate = self
        } catch let err as NSError {
            print("플래이어 초기화를 실패했습ㄴ디ㅏ")
            print("Code: \(err.code), message: \(err.localizedDescription)")
        }
        progressSlider.maximumValue = Float(self.player.duration)
        progressSlider.minimumValue = 0
    }
}

