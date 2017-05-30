//
//  MusicViewController.swift
//  Music_Player
//
//  Created by imran naseem on 28/05/17.
//  Copyright © 2017 imran naseem. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer


class MusicViewController: UIViewController {
    
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var SongsNameLabel: UILabel!
    
    @IBOutlet weak var play: UIButton!
    var songsArray = library().songsName
    var songsId :Int = 0
    var player : AVAudioPlayer = AVAudioPlayer()
    
    var isplaying = false
    
    @IBOutlet weak var slider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SongsNameLabel.text = songsArray[songsId]
        
        let path = Bundle.main.path(forResource:"\(songsArray[songsId])", ofType: ".mp3")
        
        if let songspath = path{
            
            let songsPathUrl = NSURL(fileURLWithPath: songspath)
            
                  do{
                    
                    player = try AVAudioPlayer(contentsOf: songsPathUrl as URL)
                    let session = AVAudioSession.sharedInstance()
                    try session.setCategory(AVAudioSessionCategoryPlayback)
                    try session.setActive(true)
                    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
                                    
                    
                    let artwork = MPMediaItemArtwork(image : #imageLiteral(resourceName: "music_bg3.jpg"))
                    
                    let titleStr = songsArray[songsId]

                    MPNowPlayingInfoCenter.default().nowPlayingInfo=[MPMediaItemPropertyArtwork :artwork,MPMediaItemPropertyTitle : "\(titleStr)"]
                   
                    UIApplication.shared.beginReceivingRemoteControlEvents()
                    let commandCenter = MPRemoteCommandCenter.shared()
                     commandCenter.nextTrackCommand.isEnabled = true
                    becomeFirstResponder()
                    
                    }
                   
                
                  catch{
        
                    print("error=\(error.localizedDescription)")
                    
                      }
                
            }
        
        currentLabel.text = "\(player.currentTime)"
        remainingLabel.text = "\(player.duration)"
        
       
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        
        if let event = event {
            
            if event.type == .remoteControl
            {
                switch event.subtype {
                case .remoteControlPlay:
                      player.play()
                      print("play match")

                case .remoteControlPause:
                      player.pause()
                      print("pause match")

                case .remoteControlNextTrack:
                      self.nextButton(self)
                      print("next match")

                case .remoteControlPreviousTrack:
                    self.prevButton(self)
                    print("prev match")

                default:
                    print("no match")
                }
                
            }
        }
    }

    func updateProgress(timer:Timer)  {
        slider.value = Float(player.currentTime)
        
        let remainingTime : Int = Int(player.duration-player.currentTime)
        let currentTime : Int = Int(player.currentTime)
        
        
        currentLabel.text = "-\(remainingTime)"
        remainingLabel.text = "+\(currentTime)"

    
    }
    
    @IBAction func PlayButton(_ sender: Any) {
        
        
        if (!isplaying){
            
            isplaying = true
        player.prepareToPlay()
       slider.maximumValue = Float(player.duration)
        
           play.setImage( UIImage.init(named: "pause.png"), for: .normal)
            player.play()
        }else{
            isplaying = false

            play.setImage( UIImage.init(named: "play.png"), for: .normal)
            player.pause()
            slider.value=Float(player.currentTime)

            }
        
    }
    

    @IBAction func prevButton(_ sender: Any) {
        
     
        
        if songsId != 0 || songsId > 0{
            
            
            songsId -= 1
            
            SongsNameLabel.text = songsArray[songsId]
        }
        
            let path = Bundle.main.path(forResource:"\(songsArray[songsId])", ofType: ".mp3")
            
            if let songspath = path{
                
                let songsPathUrl = NSURL(fileURLWithPath: songspath)
                
                do{
                    player = try AVAudioPlayer(contentsOf: songsPathUrl as URL)
                    player.play()
                }
                catch{
                    print("error=\(error.localizedDescription)")
                    
                }
            
            }

            
        
                          }
    @IBAction func nextButton(_ sender: Any) {
        
        if songsId < songsArray.count-1 || songsId == 0 {
            
            songsId += 1
            
            
            SongsNameLabel.text = songsArray[songsId]
            
        }
        
            let path = Bundle.main.path(forResource:"\(songsArray[songsId])", ofType: ".mp3")
            
            if let songspath = path{
                
                let songsPathUrl = NSURL(fileURLWithPath: songspath)
                
                do{
                    player = try AVAudioPlayer(contentsOf: songsPathUrl as URL)
                   player.play()
                  }
                catch{
                    print("error=\(error.localizedDescription)")
                    
                }
                
            }
        
        
        }
    
    @IBAction func SliderAction(_ sender: Any) {
        
        player.pause()
        
        
        player.currentTime = TimeInterval(slider.value)
        player.play()
    
    }
}
