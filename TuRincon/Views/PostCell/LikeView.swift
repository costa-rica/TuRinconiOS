//
//  LikeView.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 18/07/2023.
//

import UIKit

class LikeView:UIView {
    var viewHeight = 0.0
    let screenWidth = UIScreen.main.bounds.width
    let stackViewUserInteractionPadding = 10.0
    var configSfSymbolSizeUserInteraction:UIImage.SymbolConfiguration!
    var btnThumbsUp = UIButton()
    var post = Post(){
        didSet{
            setLikeCountAndButton()
        }
    }
    var lblLikeCount=UILabel()
    var rinconStore: RinconStore!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setup_view()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup_view(){
//        self.backgroundColor = .cyan
        lblLikeCount.text = "None"
        btnThumbsUp.setImage(UIImage(systemName: "hand.thumbsup", withConfiguration: configSfSymbolSizeUserInteraction), for: .normal)
        btnThumbsUp.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
        btnThumbsUp.translatesAutoresizingMaskIntoConstraints = false
        lblLikeCount.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lblLikeCount)
        self.addSubview(btnThumbsUp)

        btnThumbsUp.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
//        btnThumbsUp.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive=true
        btnThumbsUp.topAnchor.constraint(equalTo: self.topAnchor).isActive=true
        btnThumbsUp.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive=true
        lblLikeCount.leadingAnchor.constraint(equalTo: btnThumbsUp.trailingAnchor).isActive=true
        lblLikeCount.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive=true

        
        // Size lbl
        let _ = sizeLabel(lbl: lblLikeCount)

        viewHeight = max(lblLikeCount.frame.size.height, btnThumbsUp.imageView!.image!.size.height)
    }
    func setLikeCountAndButton(){
        lblLikeCount.text = String(post.like_count)
//        lblLikeCount.backgroundColor = .cyan
        lblLikeCount.font = lblLikeCount.font.withSize(15.0)
        if post.liked{
            btnThumbsUp.setImage(UIImage(systemName: "hand.thumbsup.fill", withConfiguration: configSfSymbolSizeUserInteraction), for: .normal)
        } else {
            btnThumbsUp.setImage(UIImage(systemName: "hand.thumbsup", withConfiguration: configSfSymbolSizeUserInteraction), for: .normal)
        }
//        print("-------------------------")
//        print("likeView for post: \(post.post_id!)")
//        print("lblLikeCount size: \(lblLikeCount.frame.size)")
//        print("btnThumbsUp size: \(btnThumbsUp.imageView!.image!.size)")
//        print("-----------")
    }
    
    @objc private func thumbsUpButtonPressed() {
        print("Thumbs-up button pressed")
        print(post.username!)
        if post.liked{ // now user will unlike
            btnThumbsUp.setImage(UIImage(systemName: "hand.thumbsup", withConfiguration: configSfSymbolSizeUserInteraction), for: .normal)
            post.like_count -= 1

        } else { // was previously not liked, but user has liked
            btnThumbsUp.setImage(UIImage(systemName: "hand.thumbsup.fill", withConfiguration: configSfSymbolSizeUserInteraction), for: .normal)
            post.like_count += 1
        }
        post.liked.toggle()
        lblLikeCount.text = String(post.like_count)
//        print("post: \(post)")
//        print("rinconStore: \(rinconStore!)")
        rinconStore.likePost(rincon_id: post.rincon_id, post_id: post.post_id)
//        rinconStore.likePost(post_id: post.post_id)
            
    }

}
