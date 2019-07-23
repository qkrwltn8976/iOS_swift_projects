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

    
    @IBAction func playBtnAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.player?.play()
            self.startTimer()
        } else {
            self.player?.pause()
            self.stopTimer()
        }
    } //플레이버튼을 클릭했을 때 이벤트 처리 함수
    
    @IBAction func progressSliderAction(_ sender: UISlider) {
        self.updateTimeLabel(time: TimeInterval(sender.value))
        if sender.isTracking { return }
        self.player.currentTime = TimeInterval(sender.value)
    } //슬라이더가 움직일 때마다 타임레이블을 업데이트하고 플레이어 상태를 조절하는 함수
    
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
            print("플래이어 초기화를 실패했습니다")
            print("코드: \(err.code), 메세지: \(err.localizedDescription)")
        }
        progressSlider.maximumValue = Float(self.player.duration)
        progressSlider.minimumValue = 0
        progressSlider.value = Float(self.player.currentTime)
    } //음악 플레이어를 초기화 설정하는 함수
    
    func updateTimeLabel(time: TimeInterval) {
        
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)

        let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond)

        self.timeLabel.text = timeText
    } //타임레이블을 시간 형식에 맞게 출력하고 업데이트하는 함수
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in

            
            if self.progressSlider.isTracking { return }
            
            self.updateTimeLabel(time: self.player.currentTime)
            self.progressSlider.value = Float(self.player.currentTime)
            
        })
        
        self.timer.fire()
    } //타이머를 시작하는 함수
    
    func stopTimer() {
        self.timer.invalidate()
        self.timer = nil
    } //타이머를 멈추는 함수
    
    func playBtnCustom() {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(button)
        button.setImage(UIImage(named: "button_play"), for: UIControl.State.normal)
        button.setImage(UIImage(named: "button_pause"), for: UIControl.State.selected)
        button.addTarget(self, action: #selector(self.playBtnAction(_:)), for: UIControl.Event.touchUpInside)
        self.playBtn = button
    } //플레이버튼의 아이콘을 커스텀하고 동작을 설정하는 함수
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playBtn.isSelected = false
        self.progressSlider.value = 0
        self.updateTimeLabel(time: 0)
        self.stopTimer()
    } //음악 재생이 종료되었을 때 다시 초기화하는 함수
}
