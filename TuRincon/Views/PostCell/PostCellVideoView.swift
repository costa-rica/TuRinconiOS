//
//  PostCellVideoView.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 18/07/2023.
//


import UIKit
import AVKit

class VideoView: UIView{

    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var post: Post!
    
    init(frame: CGRect, post:Post) {
        super.init(frame: frame)
        self.post = post
        setupPlayer()
        setupTapGesture()
    }
        
    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
        setupTapGesture()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update the frame of the playerLayer to match the view's bounds
        playerLayer?.frame = bounds
    }
    

    private func setupPlayer() {
        
//        SentrySDK.capture(message: "- Nick custom message from inside HomeVC viewDidLoad() -")
        if let unwp_video_file_name = post.video_file_name{
            if let videoURL = post.rincon_dir_path?.appendingPathComponent(unwp_video_file_name){
                
                player = AVPlayer(url: videoURL)
                playerLayer = AVPlayerLayer(player: player)
                playerLayer!.frame = bounds
                self.layer.addSublayer(playerLayer!)
                playerLayer!.frame.size.height = 200
            }
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewTapped() {
        if player?.rate == 0 {
            player?.play()
        } else {
            player?.pause()
        }
    }
    
}

