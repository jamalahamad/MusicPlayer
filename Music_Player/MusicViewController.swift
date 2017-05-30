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
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        SongsNameLabel.text = songsArray[songsId]
        
        let path = Bundle.main.path(forResource:"\(songsArray[songsId])", ofType: ".mp3")
        
        if let songspath = path{
            
            let songsPathUrl = NSURL(fileURLWithPath: songspath)
            
                  do{
                    
                    player = try AVAudioPlayer(contentsOf: songsPathUrl as URL)
                    let session = AVAudioSession.sharedInstance()
                    try session.setCategory(AVAudioSessionCategoryPlayback)
                    try session.setActive(true)
                    player.prepareToPlay()
                    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
                                    
                    
                    let titleStr = songsArray[songsId]
                    let artwork = MPMediaItemArtwork(image : #imageLiteral(resourceName: "music_bg3.jpg"))

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
                      let titleStr = songsArray[songsId]

                      let artwork = MPMediaItemArtwork(image : #imageLiteral(resourceName: "music_bg3.jpg"))
                       MPNowPlayingInfoCenter.default().nowPlayingInfo=[MPMediaItemPropertyArtwork :artwork,MPMediaItemPropertyTitle : "\(titleStr)"]
                      player.play()

                     print("play match")

                case .remoteControlPause:
                      player.pause()
                      print("pause match")

                case .remoteControlNextTrack:
                    
                    
                    let artwork = MPMediaItemArtwork(image : #imageLiteral(resourceName: "music_bg3.jpg"))
                    
                    let titleStr = songsArray[songsId]
                    
                    MPNowPlayingInfoCenter.default().nowPlayingInfo=[MPMediaItemPropertyArtwork :artwork,MPMediaItemPropertyTitle : "\(titleStr)"]

                      self.nextButton(self)
                      
                    
                case .remoteControlPreviousTrack:
                    
                    let artwork = MPMediaItemArtwork(image : #imageLiteral(resourceName: "music_bg3.jpg"))
                    
                    let titleStr = songsArray[songsId]
                    
                    MPNowPlayingInfoCenter.default().nowPlayingInfo=[MPMediaItemPropertyArtwork :artwork,MPMediaItemPropertyTitle : "\(titleStr)"]
                    self.prevButton(self)
                  
                default:
                    print("no match")
                }
                
            }
        }
    }

    func updateProgress(timer:Timer)  {
        slider.value = Float(player.currentTime)
        
        let remainingTime = (player.duration-player.currentTime)
        let currentTime = (player.currentTime)
        
         let roundedLeftTime = String(format: "%.2f", remainingTime)
         let roundedCurrentTime = String(format: "%.2f", currentTime)
        currentLabel.text = "-\(roundedLeftTime)"
        remainingLabel.text = "+\(roundedCurrentTime)"

    
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
                    play.setImage( UIImage.init(named: "pause.png"), for: .normal)

                    player.play()
                    slider.maximumValue = Float(player.duration)
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

                    play.setImage( UIImage.init(named: "pause.png"), for: .normal)
                    player.play()
                    slider.maximumValue = Float(player.duration)

                  }
                catch{
                    print("error=\(error.localizedDescription)")
                    
                }
            }
        
        
        }
    
    @IBAction func SliderAction(_ sender: Any) {
        
        player.pause()
        
        
        player.currentTime = TimeInterval(slider.value)
        PlayButton(self)
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        player.stop()
        
    }
}
