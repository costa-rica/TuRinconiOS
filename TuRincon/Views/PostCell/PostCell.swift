//
//  PostCell.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 18/07/2023.
//

import UIKit

class PostCell: UITableViewCell, PostCellDelegate {
    
    var post:Post!
    var rincon:Rincon!
    var imageStore: ImageStore!
    var rinconStore: RinconStore!
    
    var rinconVCDelegate: RinconVCDelegate!
    var indexPath: IndexPath!
    
    let screenWidth = UIScreen.main.bounds.width
    var stckVwPostCell = UIStackView()
    var lblDate = UILabel()
    let lblDateFontSize = 15.0
    var lblUsername = UILabel()
    let lblUsernameFontSize = 13.0
    var lblPostText:UILabel?
    
    var imgViewDict: [String:UIImageView]?
    var imgDict: [String:(UIImage, Bool)]?
    var spinnerViewDict:[String: UIActivityIndicatorView]?
    var stackViewImages: UIStackView?
    
    var videoView: VideoView?
    
    var lineImageImageView01: UIImageView!
    
    var stckVwUserInteraction=UIStackView()
    var stckVwUserInteractionHeight:CGFloat!
    var likeView:LikeView!
    var commentView:CommentView!
    var lineImageImageView02: UIImageView!
    
    
//    //comments stack
//    var stckVwComments: UIStackView?
//    var dictCommentsDate: [String:UILabel]?
//    var dictCommentsUsername: [String:UILabel]?
//    var dictCommentsText: [String:UILabel]?
//    var dictCommentsVw: [String:UIView]?
    var commentsVw: CommentsView?
    
    var btnPostDiagnostics: UIButton?
    var btnPostDiagnosticsSize: CGSize?
    
    var lineImageImageView03: UIImageView!
    
//    var stckVwNewCommentSuper: UIStackView!
    var stckVwNewComment: UIStackView!
//    var txtNewComment: UITextField?
    var txtNewComment: UITextView?
    var btnTxtNewComment: UIButton?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.stckVwPostCell.removeFromSuperview()
        self.lblDate.removeFromSuperview()
        self.lblUsername.removeFromSuperview()
        self.lblPostText?.removeFromSuperview()
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
        self.videoView?.removeFromSuperview()
        lineImageImageView01.removeFromSuperview()
        stckVwUserInteraction.removeFromSuperview()
        
        likeView.removeFromSuperview()
        
        commentView.removeFromSuperview()
        lineImageImageView02.removeFromSuperview()

//        if let unwrapped_comments = post.comments {
//            for comment_element in unwrapped_comments{
//                if let commentId = comment_element["comment_id"]{
//                    dictCommentsText?["\(post.post_id!), \(commentId)"]?.removeFromSuperview()
//                    dictCommentsVw!["\(post.post_id!), \(commentId)"]?.removeFromSuperview()
//                }
//            }
//        }
        commentsVw?.removeFromSuperview()
        
//        stckVwComments?.removeFromSuperview()
        lineImageImageView03?.removeFromSuperview()
        txtNewComment?.removeFromSuperview()
        
    }
    func configure(with post: Post) {
        self.post = post
        setup_stckVwPostCell()
        setup_lblDate()
        setup_lblUsername()
        setup_lblPostText()
        setup_images()
        setup_video()
        setup_line01()
        setup_userInteractionStackView()
        setup_line02()
        setup_stckVwNewComment()
        setup_line03()
        setup_commentsView()
        print("--------")
        print("post_id: \(post.post_id!)")
        if post.image_files_array != nil{
            print("post.image names: \(post.image_files_array! )")
        } else {print("post.image names: no post.image_files_array ")}
        print("post.image names: \(post.image_filenames_ios ?? "no image_filenames_ios")")
        

    }
    
    func setup_stckVwPostCell(){
        stckVwPostCell.translatesAutoresizingMaskIntoConstraints = false
        stckVwPostCell.axis = .vertical
        contentView.addSubview(stckVwPostCell)
        stckVwPostCell.accessibilityIdentifier = "stckVwPostCell"
        stckVwPostCell.topAnchor.constraint(equalTo: contentView.topAnchor).isActive=true
        stckVwPostCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive=true
        stckVwPostCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive=true
        stckVwPostCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive=true
    }
    
    func setup_lblDate(){
        let date_obj = convertStringToDate(date_string: post.date_for_sorting_ios)
        let formattedDateString = DateFormatter.localizedString(from: date_obj, dateStyle: .medium, timeStyle: .short)
        lblDate.text = formattedDateString
        lblDate.semanticContentAttribute = .forceRightToLeft
        lblDate.translatesAutoresizingMaskIntoConstraints = false
        stckVwPostCell.addArrangedSubview(lblDate)
        lblDate.accessibilityIdentifier = "lblDate"
        lblDate.sizeToFit()
        lblDate.font = lblDate.font.withSize(lblDateFontSize)
    }
    
    func setup_lblUsername(){
        lblUsername.text = post.username
        lblUsername.translatesAutoresizingMaskIntoConstraints = false
        lblUsername.font = lblUsername.font.withSize(12.0)
        stckVwPostCell.addArrangedSubview(lblUsername)
        lblUsername.accessibilityIdentifier = "lblUsername"
        lblUsername.sizeToFit()
        lblUsername.font = lblUsername.font.withSize(lblUsernameFontSize)
    }
    
    func setup_lblPostText(){
        if let unwrapped_postText = post.post_text_ios{
            lblPostText = UILabel()
            lblPostText!.translatesAutoresizingMaskIntoConstraints=false
            lblPostText!.text = unwrapped_postText
            lblPostText!.numberOfLines = 0
            let _ = sizeLabel(lbl: lblPostText!)// <-- This correctly sizes lblPostText
//            post.cell_height = post.cell_height + lblPostText!.frame.size.height
            
            stckVwPostCell.addArrangedSubview(lblPostText!)
            lblPostText!.accessibilityIdentifier = "lblPostText"
        }
    }
    
    func setup_images(){
        if let unwrapped_images = post.image_files_array{
            print("Post: \(post.post_id!) has images: \(unwrapped_images)")
            imgViewDict = [String:UIImageView]()
            imgDict = [String:(image:UIImage,downloaded:Bool)]()
            spinnerViewDict = [String: UIActivityIndicatorView]()
            
            for image_file_string in unwrapped_images{
                if let unwrapped_uiimage = imageStore.image(forKey: image_file_string, rincon:rincon){
                    print("-succussfully unwrapped got image from image store")
                    
                    imgDict![image_file_string] = (unwrapped_uiimage, true)
                    
                } else {
                    print("* FAiled to unwrap image from imageStore *")
                    /* setup a defualt photo*/
                    imgDict![image_file_string] = (image:UIImage(named: "blackScreen")!, downloaded:false)
                    let spinner = UIActivityIndicatorView(style: .large)
                    spinner.translatesAutoresizingMaskIntoConstraints = false
                    spinner.color = UIColor.white.withAlphaComponent(1.0) // Make spinner brighter
                    spinner.transform = CGAffineTransform(scaleX: 2, y: 2)
                    spinner.startAnimating()
                    self.spinnerViewDict![image_file_string] = spinner
                    
                    /* try to replace default photo with downloaded photo */
                    self.rinconStore.requestPostPhoto(rincon_id: post.rincon_id, image_file_name: image_file_string) { result in
                        if case let .success(image) = result {
                            self.imageStore.setImage(image, forKey: image_file_string, rincon: self.rincon)
                            OperationQueue.main.addOperation  {
                                
                                self.imgDict![image_file_string] = (image,true)
//                                self.rinconVCDelegate?.customReloadCell(indexPath: self.indexPath)
                                // Inform the tableView about the changes to update cell's height
                                guard let tblVwRinconVC = self.superview as? UITableView else { return }
                                tblVwRinconVC.reloadRows(at: [self.indexPath], with: UITableView.RowAnimation.none)
                                
                            }
                        }
                        if case let .failure(failure) = result { // failed photo in place of photo

                                self.imgDict![image_file_string] = (UIImage(named: "failedToDownload01")!, true)
                                
                                print("- Failed to download image: \(failure)")

                        }
                    }
                }
            } // for image_file_string in
            let imgArraySorted = resizeImagesInDictionary(imgDict!)
            let stackViewImagesResult = generateStackView(with: imgArraySorted)
//            let stackViewImagesResult = generateStackViewSimple(with: imgArraySorted)
            stackViewImages = stackViewImagesResult.0

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
                
                let imgArraySorted = resizeImagesInDictionary(imgDict!)
                let stackViewImagesResult = generateStackView(with: imgArraySorted)
                stackViewImages = stackViewImagesResult.0
//                let stackViewImagesHeight = stackViewImagesResult.2
//                print("*** stackViewImagesHeight: \(stackViewImagesHeight)")
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
        videoView!.heightAnchor.constraint(equalToConstant: 300).isActive = true
        videoView!.widthAnchor.constraint(equalToConstant: screenWidth).isActive=true
//        post.cell_height = post.cell_height + 300
    }
    
    func setup_line01(){
        lineImageImageView01 = createDividerLine(thicknessOfLine: 1.0)
        stckVwPostCell.addArrangedSubview(lineImageImageView01)
        lineImageImageView01.accessibilityIdentifier = "lineImageImageView01"
    }
    
    func setup_userInteractionStackView(){
        stckVwUserInteraction.axis = .horizontal
        likeView = LikeView()
        
        likeView.rinconStore = self.rinconStore
        likeView.setup_view()
        likeView.post = self.post
        
        commentView = CommentView()
        commentView.post = post
        commentView.setup_view()
        commentView.postCellDelegate = self
        
        commentView.translatesAutoresizingMaskIntoConstraints=false
        likeView.translatesAutoresizingMaskIntoConstraints=false
        commentView.widthAnchor.constraint(equalToConstant: screenWidth/2).isActive=true
        likeView.widthAnchor.constraint(equalToConstant: screenWidth/2).isActive=true

        stckVwUserInteraction.addArrangedSubview(commentView)
        commentView.accessibilityIdentifier = "commentView"
        stckVwUserInteraction.addArrangedSubview(likeView)
        likeView.accessibilityIdentifier = "likeView"
        stckVwUserInteraction.translatesAutoresizingMaskIntoConstraints=false
        stckVwPostCell.addArrangedSubview(stckVwUserInteraction)
        stckVwUserInteraction.accessibilityIdentifier = "stckVwUserInteraction"
//        layoutIfNeeded()
//        print("stckVwUserInteraction.frame.height : \(stckVwUserInteraction.frame.height )")
//        likeView.viewHeight
//        stckVwUserInteractionHeight = max(likeView.viewHeight, commentView.viewHeight)
//        let stckVwUserInteractionHeight = 25.0
//        post.cell_height = post.cell_height + stckVwUserInteractionHeight
//        commentView.backgroundColor = .cyan
//        likeView.backgroundColor = .gray
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
//            print("commentsVw size: \(commentsVw!.frame.size)")
        
            stckVwPostCell.addArrangedSubview(commentsVw!)
//            layoutIfNeeded()
//            print("commentsVw size (layoutIfNeeded): \(commentsVw!.frame.size)")
            commentsVw!.heightAnchor.constraint(equalToConstant: commentsVw!.stckVwComments!.frame.size.height).isActive=true
//            print("commentsVw size (commentsVw!.heightAnchor.constraint): \(commentsVw!.frame.size)")
        }
        
    }
    

    
    func setup_line03(){
        lineImageImageView03 = createDividerLine(thicknessOfLine: 1.5)
        stckVwPostCell.addArrangedSubview(lineImageImageView02)
        lineImageImageView02.accessibilityIdentifier = "lineImageImageView02"
    }
    
    func setup_stckVwNewComment(){
        stckVwNewComment = UIStackView()
        stckVwNewComment.translatesAutoresizingMaskIntoConstraints=false
        stckVwPostCell.addArrangedSubview(stckVwNewComment)
        stckVwNewComment.accessibilityIdentifier = "stckVwNewComment"
        stckVwNewComment.widthAnchor.constraint(equalToConstant: screenWidth).isActive=true
    }
    
    @objc func btnCommentTestPressed(){
        print("btnCommentTestPressed, post: \(post.post_id!)")
    }
    
//    @objc func btnPostDiagnosticsPressed(){
//        print("btnPostDiagnosticsPressed post: \(post.post_id!)")
//        print("btnPostDiagnostics size: \(btnPostDiagnosticsSize!)")
//        print("stckVwPostCell size: \(stckVwPostCell.frame.size)")
//        print("lblDate size: \(lblDate.frame.size)")
//        print("lblUsername size: \(lblUsername.frame.size)")
//        print("lblPostText size: \(lblPostText!.frame.size)")
//        print("stackViewImages size: \(stackViewImages!.frame.size)")
//        print("lineImageImageView01 size: \(lineImageImageView01.frame.size)")
//        print("stckVwUserInteraction size: \(stckVwUserInteraction.frame.size)")
//        print("likeView size: \(likeView.frame.size)")
//        print("commentView size: \(commentView.frame.size)")
////        print("stckVwComments: \(stckVwComments!.frame.size.height)")
////        print("stckViewCommentsHeight: \(stckVwCommentsHeight!)")
//    }
    
    func expandNewComment(){
        print("- accessed expandNewComment(): post: \(post.post_id!) ")

        if let textField = txtNewComment, let submitButton = btnTxtNewComment {
            textField.removeFromSuperview()
            submitButton.removeFromSuperview()
            self.txtNewComment = nil
            self.btnTxtNewComment = nil
//            layoutIfNeeded()
        } else {
            // Create and add textField and submitButton to the stackView
            setup_txtNewComment()
        }
        // Inform the tableView about the changes to update cell's height
        guard let tblVwRinconVC = self.superview as? UITableView else { return }
        tblVwRinconVC.beginUpdates()
        tblVwRinconVC.endUpdates()
        
    }
    
    func setup_txtNewComment() {
//        txtNewComment = UITextField()
        txtNewComment = UITextView()
        txtNewComment?.backgroundColor = UIColor(named: "gray-400")
        txtNewComment?.translatesAutoresizingMaskIntoConstraints = false
        txtNewComment?.layer.cornerRadius = 10
        txtNewComment?.layer.borderWidth = 1
        txtNewComment?.layer.borderColor = CGColor(gray: 0.5, alpha: 1.0)
        txtNewComment?.font = UIFont(name: "Rockwell_tu", size: 13)
        
        btnTxtNewComment = UIButton()
        btnTxtNewComment?.setTitle("Submit", for: .normal)
        btnTxtNewComment?.setTitleColor(.blue, for: .normal)
        btnTxtNewComment?.layer.cornerRadius = 10
        btnTxtNewComment?.layer.borderWidth = 2
        btnTxtNewComment?.layer.borderColor = UIColor(named: "blueBtn")?.cgColor
        btnTxtNewComment?.translatesAutoresizingMaskIntoConstraints = false
        btnTxtNewComment?.addTarget(self, action: #selector(btnTxtNewCommentTouchDown(_:)), for: .touchDown)
        btnTxtNewComment?.addTarget(self, action: #selector(btnTextNewCommentTouchUpInside(_:)), for: .touchUpInside)
        
        if let textField = txtNewComment, let submitButton = btnTxtNewComment {
            stckVwNewComment!.axis = .horizontal
            stckVwNewComment!.translatesAutoresizingMaskIntoConstraints = false
            stckVwNewComment.addArrangedSubview(textField)
            stckVwNewComment.addArrangedSubview(submitButton)
            
            // Constraints
            NSLayoutConstraint.activate([
                textField.widthAnchor.constraint(equalToConstant: screenWidth * 0.75)
            ])
        }
    }
    @objc func btnTxtNewCommentTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)

    }
    @objc func btnTextNewCommentTouchUpInside(_ sender: UIButton){
        print("- btnTextNewCommentPressed ")
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            print("text: \(self.txtNewComment!.text!)")
            //        txtNewComment?.text = ""
            self.txtNewComment?.removeFromSuperview()
            self.btnTxtNewComment?.removeFromSuperview()
            self.rinconStore.newComment(rincon_id: self.post.rincon_id, post_id: self.post.post_id, new_comment: self.txtNewComment!.text) { post_list in
                //            self.post = post_list[self.indexPath.row]
                self.rinconVCDelegate.customUpdatePostsAndReloadCell(posts: post_list, indexPath: self.indexPath)
            }
        }
    }
    
}


protocol PostCellDelegate{
    func expandNewComment()
}
