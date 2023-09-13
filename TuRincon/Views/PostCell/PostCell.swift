//
//  PostCell.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 18/07/2023.
//

import UIKit
//import Sentry

class PostCell: UITableViewCell, PostCellDelegate {
    
    var post:Post!
    var rincon:Rincon!
    var imageStore: ImageStore!
    var rinconStore: RinconStore!
    var currentUser: User!
    
    var rinconVCDelegate: RinconVCDelegate!
    var indexPath: IndexPath!
    
    let screenWidth = UIScreen.main.bounds.width
    var stckVwPostCell = UIStackView()
    
    var lblDate = UILabel()
    var lblUsername = UILabel()
    var lblPostText:UILabel?
    
    var imgViewDict:[String:UIImageView]?
    var imgDict:[String:(image:UIImage,downloaded:Bool)]?
    var spinnerViewDict:[String: UIActivityIndicatorView]?
    var stackViewImages:UIStackView?
    
    var videoView:VideoView?
    
    var lineImageImageView01:UIImageView!
    let configSfSymbolSizeUserInteraction = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold, scale: .large) // create a large configuration
    var stckVwUserInteraction=UIStackView()
    var btnDeletePost:UIButton?
    var likeView:LikeView!
    var commentView:CommentView!
    var lineImageImageView02: UIImageView!
    
    
    var commentsVw:CommentsView?

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        print("- layoutSubviews() post: \(post.post_id!)")
//        print("self.contentView.size: \(self.contentView.frame.size)")
//        print("stckVwPostCell.size: \(stckVwPostCell.frame.size)")
//        print("lblDate.size: \(lblDate.frame.size)")
//        print("lblUsername.size: \(lblUsername.frame.size)")
//        print("lblPostText.size: \(lblPostText?.frame.size)")
//        print("commentsVw.size: \(commentsVw?.frame.size)")
//        print("------------- End post cell \(post.post_id!) ---")
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stckVwPostCell.removeFromSuperview()
        
        lblDate.removeFromSuperview()
        lblUsername.removeFromSuperview()
        lblPostText?.removeFromSuperview()
        
        if let unwrapped_dict = imgViewDict{
            for uiImgVw in unwrapped_dict{
                uiImgVw.value.removeFromSuperview()
            }
        }
        if let unwrapped_dict = spinnerViewDict{
            for spinner in unwrapped_dict{
                spinner.value.removeFromSuperview()
            }
        }
        if let unwrappaed_stackViewImages = stackViewImages{
            unwrappaed_stackViewImages.removeFromSuperview()
        }
        stackViewImages?.removeFromSuperview()
        
        videoView?.removeFromSuperview()

        
        commentsVw?.removeFromSuperview()
    }
    
    func configure(with post: Post) {
        self.post = post
//        print("------------ Start post cell \(post.post_id!) ---")
        self.contentView.accessibilityIdentifier = "PCContVw_post\(post.post_id!)"
//        self.contentView.backgroundColor = .red
        setup_stckVwPostCell()
        setup_lblDate()
        setup_lblUsername()
        setup_lblPostText()
        setup_images()
        setup_video()
        setup_line01()
//        setup_userInteractionStackView()
        setup_line02()
        setup_commentsView()
    }
    
    func setup_stckVwPostCell(){
        stckVwPostCell.axis = .vertical
        stckVwPostCell.translatesAutoresizingMaskIntoConstraints=false
        self.contentView.addSubview(stckVwPostCell)
        stckVwPostCell.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive=true
        stckVwPostCell.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive=true
        stckVwPostCell.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive=true
        stckVwPostCell.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive=true
    }
    
    func setup_lblDate(){
        let date_obj = convertStringToDate(date_string: post.date_for_sorting_ios)
        let formattedDateString = DateFormatter.localizedString(from: date_obj, dateStyle: .medium, timeStyle: .short)
        lblDate.text = formattedDateString
        lblDate.semanticContentAttribute = .forceRightToLeft
        lblDate.translatesAutoresizingMaskIntoConstraints = false
        stckVwPostCell.addArrangedSubview(lblDate)
        lblDate.accessibilityIdentifier = "lblDate"
        lblDate.font = lblDate.font.withSize(13)
    }
    
    func setup_lblUsername(){
        lblUsername.text = post.username
        lblUsername.font = lblUsername.font.withSize(15)
        lblUsername.translatesAutoresizingMaskIntoConstraints=false
        stckVwPostCell.addArrangedSubview(lblUsername)
    }
    
    func setup_lblPostText(){
        if let unwrapped_postText = post.post_text_ios{
            lblPostText = UILabel()
            lblPostText!.translatesAutoresizingMaskIntoConstraints=false
            lblPostText!.text = unwrapped_postText
            lblPostText!.numberOfLines = 0
            let _ = sizeLabel(lbl: lblPostText!)// <-- This correctly sizes lblPostText
            stckVwPostCell.addArrangedSubview(lblPostText!)
            lblPostText!.accessibilityIdentifier = "lblPostText"
        }
    }
    
    func setup_images(){
        if let unwrapped_images = post.image_files_array{
            imgViewDict = [String:UIImageView]()
            imgDict = [String:(image:UIImage,downloaded:Bool)]()
            spinnerViewDict = [String: UIActivityIndicatorView]()
            
            for image_file_string in unwrapped_images{
                if let unwrapped_uiimage = imageStore.image(forKey: image_file_string, rincon:rincon){
                    imgDict![image_file_string] = (unwrapped_uiimage, true)
                    
                } else {
                    /* setup a defualt photo*/
                    imgDict![image_file_string] = (image:UIImage(named: "blackScreen")!, downloaded:false)
                    
                    /* try to replace default photo with downloaded photo */
                    self.rinconStore.requestPostPhoto(rincon_id: post.rincon_id, image_file_name: image_file_string) { result in

                        switch result{
                        case let .success(image):
                            self.imageStore.setImage(image, forKey: image_file_string, rincon: self.rincon)
                            OperationQueue.main.addOperation  {
                                self.imgDict![image_file_string] = (image,true)
                                // Inform the tableView about the changes to update cell's height
                                guard let tblVwRinconVC = self.superview as? UITableView else { return }
                                tblVwRinconVC.reloadRows(at: [self.indexPath], with: UITableView.RowAnimation.none)
                            }

                        case let .failure(error):
                            OperationQueue.main.addOperation  {
                                self.imgDict![image_file_string] = (UIImage(named: "failedToDownload01")!, true)
                            }
                                print("- Failed to download image: \(error)")
                        }
                    }
                }
            } // for image_file_string in
            let imgArraySorted = resizeImagesInDictionary(imgDict!,postId: post.post_id)
            stackViewImages = generateStackViewTwo(from: imgArraySorted)

            stckVwPostCell.addArrangedSubview(stackViewImages!)
            stackViewImages?.accessibilityIdentifier = "stackViewImages"

        } // if let unwrapped_images =

    } // setup_images
    
    func setup_video(){
        if let unwrapped_video_filename =  self.post.video_file_name{
            
            if rinconStore.rinconFileExists(rincon: self.rincon, file_name: unwrapped_video_filename){
                setup_videoPlayer(videoFilename: unwrapped_video_filename)
            } else {
                
                /* setup a defualt photo*/
                imgViewDict = [String:UIImageView]()
                imgDict = [String:(image:UIImage,downloaded:Bool)]()
                spinnerViewDict = [String: UIActivityIndicatorView]()
                
                imgDict![unwrapped_video_filename] = (image:UIImage(named: "blackScreen")!, downloaded:false)
                let spinner = UIActivityIndicatorView(style: .large)
                spinner.translatesAutoresizingMaskIntoConstraints = false
                spinner.color = UIColor.white.withAlphaComponent(1.0) // Make spinner brighter
                spinner.transform = CGAffineTransform(scaleX: 2, y: 2)
                spinner.startAnimating()
                self.spinnerViewDict![unwrapped_video_filename] = spinner
                
                let imgArraySorted = resizeImagesInDictionary(imgDict!,postId:post.post_id)
                let stackViewImagesResult = generateStackView(with: imgArraySorted)
                stackViewImages = stackViewImagesResult.0
                stckVwPostCell.addArrangedSubview(stackViewImages!)
                stackViewImages?.accessibilityIdentifier = "stackViewImages"
                
                /* download video */
                self.rinconStore.requestPostVideo(rincon_id: post.rincon_id, video_file_name: unwrapped_video_filename) { tempLocalURL in
                    do {
                        let fileManager = FileManager.default
                        let rinconFolderPath = self.rinconStore.rinconFolderUrl(rincon: self.rincon)
                        try fileManager.createDirectory(at: rinconFolderPath, withIntermediateDirectories: true, attributes: nil)
                        let destinationURL = rinconFolderPath.appendingPathComponent(unwrapped_video_filename)
                        try fileManager.moveItem(at: tempLocalURL, to: destinationURL)
                        
                        OperationQueue.main.addOperation  {
                            self.stackViewImages?.removeFromSuperview()
//                            self.post.cell_height = self.post.cell_height - stackViewImagesHeight
                            self.setup_videoPlayer(videoFilename: unwrapped_video_filename)
                        }
                    } catch {
                        print("Failed to download video")
                    }
                }
            }
        }
    } // setup_video
    
    func setup_videoPlayer(videoFilename: String){
        videoView = VideoView(frame: CGRect(x: 0, y: 0, width: contentView.bounds.width, height: 300), post: post)
        stckVwPostCell.addArrangedSubview(videoView!)
        videoView?.accessibilityIdentifier = "videoView"
        videoView!.translatesAutoresizingMaskIntoConstraints = false
//        videoView!.heightAnchor.constraint(equalToConstant: 300).isActive = true
        videoView!.widthAnchor.constraint(equalToConstant: screenWidth).isActive=true
    }
    
    func setup_line01(){
        lineImageImageView01 = createDividerLine(thicknessOfLine: 1.0)
        stckVwPostCell.addArrangedSubview(lineImageImageView01)
        lineImageImageView01.accessibilityIdentifier = "lineImageImageView01"
    }
    
    func setup_userInteractionStackView(){
        stckVwUserInteraction.axis = .horizontal
        var userInteractionBtnWidth = screenWidth/2

        if post.user_id == currentUser.id {
//            print("* Should access to make a delete button for post: \(post.post_id!)")
            userInteractionBtnWidth = screenWidth/3
            btnDeletePost = UIButton()
            btnDeletePost!.setImage(UIImage(systemName: "trash", withConfiguration: configSfSymbolSizeUserInteraction), for: .normal)
            btnDeletePost!.translatesAutoresizingMaskIntoConstraints=false
            btnDeletePost!.widthAnchor.constraint(equalToConstant: userInteractionBtnWidth).isActive=true
            stckVwUserInteraction.addArrangedSubview(btnDeletePost!)
            btnDeletePost!.addTarget(self, action: #selector(btnDeletePostTouchDown), for: .touchUpInside)
            btnDeletePost!.addTarget(self, action: #selector(btnDeletePostTouchUpInside), for: .touchUpInside)
        }
        
        likeView = LikeView()
        
        likeView.rinconStore = self.rinconStore
        likeView.configSfSymbolSizeUserInteraction = configSfSymbolSizeUserInteraction
        likeView.setup_view()
        likeView.post = self.post

        commentView = CommentView()
        commentView.post = post
        commentView.configSfSymbolSizeUserInteraction = configSfSymbolSizeUserInteraction
        commentView.setup_view()
        commentView.postCellDelegate = self
        
        commentView.translatesAutoresizingMaskIntoConstraints=false
        likeView.translatesAutoresizingMaskIntoConstraints=false
        commentView.widthAnchor.constraint(equalToConstant: userInteractionBtnWidth).isActive=true
        likeView.widthAnchor.constraint(equalToConstant: userInteractionBtnWidth).isActive=true
//        print("--->likeView size: \(likeView.frame.size)")

        stckVwUserInteraction.addArrangedSubview(commentView)
        commentView.accessibilityIdentifier = "commentView"
        stckVwUserInteraction.addArrangedSubview(likeView)
        likeView.accessibilityIdentifier = "likeView"
        stckVwUserInteraction.translatesAutoresizingMaskIntoConstraints=false
        stckVwPostCell.addArrangedSubview(stckVwUserInteraction)
        stckVwUserInteraction.accessibilityIdentifier = "stckVwUserInteraction"
        
        print("---commentView: \(commentView.frame.size)")
//        print("---->commentView.buttonComment size: \(commentView.btnComment.frame.size)")
        print("---->commentView.viewHeight: \(commentView.viewHeight)")
//        stckVwUserInteraction.heightAnchor.constraint(equalToConstant: commentView.viewHeight + 20).isActive=true
        print("stckVwUserInteraction.size: \(stckVwUserInteraction.frame.size)")
        var newFrame = stckVwUserInteraction.frame
        newFrame.size.height = stckVwUserInteraction.frame.height + commentView.viewHeight + 20
        stckVwUserInteraction.frame = newFrame
        print("stckVwUserInteraction.size (new) : \(stckVwUserInteraction.frame.size)")
    }
    
    func setup_line02(){
        lineImageImageView02 = createDividerLine(thicknessOfLine: 1.5)
        stckVwPostCell.addArrangedSubview(lineImageImageView02)
        lineImageImageView02.accessibilityIdentifier = "lineImageImageView02"
    }
    
    
    
    func setup_commentsView(){
        if  post.comments != nil {
            commentsVw = CommentsView()
            commentsVw!.post = self.post
            commentsVw!.rinconVCDelegate = self.rinconVCDelegate
            commentsVw!.indexPath = self.indexPath
            stckVwPostCell.addArrangedSubview(commentsVw!)
            // verified necessary constraint
//            commentsVw!.heightAnchor.constraint(equalToConstant: commentsVw!.stckVwComments!.frame.size.height).isActive=true
        }
    }
    
    @objc func btnDeletePostTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)

    }
    @objc func btnDeletePostTouchUpInside(_ sender: UIButton){
        print("- btnDeletePostTouchUpInside ")
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        print("request to delete post: \(post.post_id!)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.rinconVCDelegate.deletePostAreYouSure(indexPath: self.indexPath)
        }
    }
    
    
    /* Delegate funcs */
    func expandNewComment(){
        print("- expand comment screen")
    }
    
}


protocol PostCellDelegate{
    func expandNewComment()
}
