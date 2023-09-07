//
//  RinconVC.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 18/07/2023.
//

import UIKit
import PhotosUI
//import MobileCoreServices
import UniformTypeIdentifiers
import Sentry

class RinconVC: DefaultViewController, RinconVCDelegate, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var urlStore:URLStore!
    var userStore: UserStore!
    var rinconStore: RinconStore!
    var imageStore: ImageStore!
    var rincon:Rincon!
    var posts: [Post]!
    let vwVCHeaderOrange = UIView()
    var stckVwRincon=UIStackView()
    var tblRincon = UITableView()
    var stckVwSubmitPostTxtAndBtn = UIStackView()
    var stckVwSubmitBtns = UIStackView()
    var txtPost = UITextView()
    var btnSubmitPost = UIButton()
    var btnAddPhotos = UIButton()
    var vwPostSpacer = UIView()
    var btnHidePostPrompt = UIButton()
    var arryNewPostImages = [UIImage]()
    var arryNewPostImageFilenames: [String]?
    var newPostVideoURL:URL?
    var newPostVideoName:String?
    var dictNewImages:[String:UIImage]?
    var btnRinconOptions: UIBarButtonItem?
    var boolPostDialogueVisible=false
    var newPost:Post!
    /* new post critical path #2 */
    var newPostId = String() {// <-- get's set by @objc func btnSubmitPostTouchUpInside(_ sender: UIButton)
        didSet{
            newPost = Post()
            newPost.post_id = String(newPostId)
            appendToNewPost()
        }
    }
    
    var bottomConstraint: NSLayoutConstraint!
    var rinconVcAlertMessage = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageStore = ImageStore()
        tblRincon.delegate = self
        tblRincon.dataSource = self
        // Register a UITableViewCell
        tblRincon.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        tblRincon.rowHeight = UITableView.automaticDimension
        tblRincon.estimatedRowHeight = 100
        
        setup_vwVCHeaderOrange()
        setup_stckVwRinconPosts()
        setup_btnRinconOptions()
//        setupRightBarButtonItem()
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tblRincon.refreshControl = refreshControl
        print("--- posts ---")
//            print(rinconVC.posts[0].video_file_name!)
        print(posts[0].post_id!)
        print(posts[0].post_text_ios!)
//        if  posts[0].video_file_name! != nil {
//            print(posts[0].video_file_name!)
//        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                bottomConstraint.constant = -keyboardSize.height
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
//        print("-keyboardWillHide")
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setup_vwVCHeaderOrange(){
        view.addSubview(vwVCHeaderOrange)
        vwVCHeaderOrange.backgroundColor = environmentColor(urlStore: urlStore)
        vwVCHeaderOrange.translatesAutoresizingMaskIntoConstraints = false
        vwVCHeaderOrange.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vwVCHeaderOrange.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        vwVCHeaderOrange.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        vwVCHeaderOrange.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
    }
    
    func setup_stckVwRinconPosts(){
        view.addSubview(stckVwRincon)
        stckVwRincon.translatesAutoresizingMaskIntoConstraints=false
        stckVwRincon.axis = .vertical
        stckVwRincon.topAnchor.constraint(equalTo: vwVCHeaderOrange.bottomAnchor).isActive=true
        stckVwRincon.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        stckVwRincon.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        bottomConstraint = stckVwRincon.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.isActive=true
        tblRincon.translatesAutoresizingMaskIntoConstraints=false
        tblRincon.accessibilityIdentifier="tblRincon"
        stckVwRincon.addArrangedSubview(tblRincon)
    }
    
    func setup_btnRinconOptions() {
        btnRinconOptions = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onRinconOptions))
        navigationItem.rightBarButtonItem = btnRinconOptions
    }

    @objc func onRinconOptions() {
        // Create an action sheet
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // Add the "Post to Rincon" action if the user has permission
        if rincon.permission_post! {
            actionSheet.addAction(UIAlertAction(title: "Post to Rincon", style: .default, handler: { action in
                // Call the postToRincon() function
                self.postToRincon()
            }))
        }

        actionSheet.addAction(UIAlertAction(title: "Invite a Friend", style: .default, handler: { action in
            // Create a new RinconOptionsVC
            let rinconOptionsInviteVC = RinconOptionsInviteVC()

            // Set the modal presentation style
            rinconOptionsInviteVC.modalPresentationStyle = .overCurrentContext
            rinconOptionsInviteVC.modalTransitionStyle = .crossDissolve
            rinconOptionsInviteVC.rincon = self.rincon
            rinconOptionsInviteVC.rinconStore = self.rinconStore

            // Present the RinconOptionsVC
            self.present(rinconOptionsInviteVC, animated: true, completion: nil)
            
            
        }))
        if rincon.permission_admin!{
            actionSheet.addAction(UIAlertAction(title: "Delete Rincón", style: .destructive, handler: { action in
                // Create a new RinconOptionsVC
                let rinconOptionsDeleteVC = RinconOptionsDeleteVC()
                
                // Set the modal presentation style
                rinconOptionsDeleteVC.modalPresentationStyle = .overCurrentContext
                rinconOptionsDeleteVC.modalTransitionStyle = .crossDissolve
                rinconOptionsDeleteVC.rincon = self.rincon
                rinconOptionsDeleteVC.rinconStore = self.rinconStore
                rinconOptionsDeleteVC.rinconVcDelegate = self
                
                // Present the RinconOptionsVC
                self.present(rinconOptionsDeleteVC, animated: true, completion: nil)

            }))
        }

        // Add the "Cancel" action
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Show the action sheet
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func postToRincon() {
        
        stckVwSubmitPostTxtAndBtn.translatesAutoresizingMaskIntoConstraints=false
        stckVwRincon.addArrangedSubview(stckVwSubmitPostTxtAndBtn)
        
        txtPost.translatesAutoresizingMaskIntoConstraints=false
        stckVwSubmitPostTxtAndBtn.addArrangedSubview(txtPost)
        txtPost.widthAnchor.constraint(equalToConstant: widthFromPct(percent: 75)).isActive=true
        txtPost.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 15)).isActive=true
        txtPost.backgroundColor = UIColor(named: "gray-400")
        txtPost.layer.cornerRadius = 10
        txtPost.layer.borderWidth = 1
        txtPost.layer.borderColor = CGColor(gray: 0.5, alpha: 1.0)
        txtPost.font = UIFont(name: "Rockwell_tu", size: 13)
        
        stckVwSubmitBtns.translatesAutoresizingMaskIntoConstraints=false
        stckVwSubmitPostTxtAndBtn.addArrangedSubview(stckVwSubmitBtns)
        stckVwSubmitBtns.axis = .vertical
        
        btnSubmitPost.translatesAutoresizingMaskIntoConstraints=false
        stckVwSubmitBtns.addArrangedSubview(btnSubmitPost)
        btnSubmitPost.widthAnchor.constraint(equalToConstant: widthFromPct(percent: 25)).isActive=true
        btnSubmitPost.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        btnSubmitPost.setTitle("Submit Post", for: .normal)
        
        /* Send Post Critical Path: phase 1 */
        btnSubmitPost.addTarget(self, action: #selector(btnSubmitPostTouchDown(_:)), for: .touchDown)
        btnSubmitPost.addTarget(self, action: #selector(btnSubmitPostTouchUpInside(_:)), for: .touchUpInside)
        btnSubmitPost.setTitleColor(.blue, for: .normal)
        btnSubmitPost.layer.cornerRadius = 10
        btnSubmitPost.layer.borderWidth = 2
        btnSubmitPost.layer.borderColor = UIColor(named: "blueBtn")?.cgColor
        
        btnAddPhotos.translatesAutoresizingMaskIntoConstraints=false
        stckVwSubmitBtns.addArrangedSubview(btnAddPhotos)
        btnAddPhotos.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 5)).isActive=true
        let photo_image = UIImage(systemName: "photo")?.withTintColor(UIColor(named: "orangePrimary") ?? .gray, renderingMode: .alwaysOriginal)
        btnAddPhotos.setImage(photo_image, for: .normal)
        
        btnAddPhotos.layer.cornerRadius = 10
        btnAddPhotos.layer.borderWidth = 2
        btnAddPhotos.layer.borderColor = UIColor(named: "orangePrimary")?.cgColor
        btnAddPhotos.addTarget(self, action: #selector(btnAddPhotosTouchDown(_:)), for: .touchDown)
        btnAddPhotos.addTarget(self, action: #selector(btnAddPhotosTouchUpInside(_:)), for: .touchDown)
        
        vwPostSpacer.translatesAutoresizingMaskIntoConstraints=false
        vwPostSpacer.backgroundColor = UIColor(named: "gray-400")
        vwPostSpacer.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 5)).isActive=true
        
        vwPostSpacer.addSubview(btnHidePostPrompt)
        let tgrVwPostSpacer = UITapGestureRecognizer(target: self, action: #selector(hideStckVwSubmitPostTxtAndBtn))
        let tgrTblRincon = UITapGestureRecognizer(target: self, action: #selector(hideStckVwSubmitPostTxtAndBtn))
        vwPostSpacer.addGestureRecognizer(tgrVwPostSpacer)
        tblRincon.addGestureRecognizer(tgrTblRincon)
        stckVwRincon.addArrangedSubview(vwPostSpacer)
        boolPostDialogueVisible=true
    }
    @objc func btnSubmitPostTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    
    /* new post critical path #1 */
    @objc func btnSubmitPostTouchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)

        /* Send Post Critical Path: phase 2 */
        rinconStore.claimAPostId(rincon_id: rincon.id) { resultResponseClaimAPostId in
            switch resultResponseClaimAPostId{
            case let .success(jsonDict):
                self.newPostId = jsonDict["new_post_id"] ?? "no_post_id_found_see:rinconStore.claimAPostId"
            case let .failure(error):
                print("*** failed to make a post")
                print(error)
                print(error.localizedDescription)
//                self.rinconVcAlertMessage = error.localizedDescription
                print("self.rinconVcAlertMessage: \(self.rinconVcAlertMessage)")
                self.rinconAlert(message: error.localizedDescription)
            }
        }
    }

    @objc private func hideStckVwSubmitPostTxtAndBtn(){
        stckVwSubmitPostTxtAndBtn.removeFromSuperview()
        txtPost.removeFromSuperview()
        stckVwSubmitBtns.removeFromSuperview()
        btnSubmitPost.removeFromSuperview()
        btnAddPhotos.removeFromSuperview()
        vwPostSpacer.removeFromSuperview()
        btnHidePostPrompt.removeFromSuperview()
        boolPostDialogueVisible=false
    }
    
    /* new post critical path #3 */
    private func appendToNewPost(){
        
        newPost.user_id = userStore.user.id
        newPost.username = userStore.user.username
        newPost.rincon_id = rincon.id
        newPost.date_for_sorting_ios = getCurrentTimestamp() // format: "2023-07-24 11:14:32.060511"
        newPost.post_text_ios = txtPost.text!
        
        newPost.liked = false
        newPost.like_count = 0
        
        // change image file names from ios stock names to tu rincon format
        if self.arryNewPostImageFilenames != nil {
            print("--- self.arryNewPostImageFilenames old names ---")
            print(self.arryNewPostImageFilenames!)
            
            self.dictNewImages = [String:UIImage]()
            for (index, uiimage) in self.arryNewPostImages.enumerated(){
                self.dictNewImages!["post_\(self.newPostId)_image_\(String(index+1)).jpeg"]=uiimage
            }
            self.arryNewPostImageFilenames = Array(self.dictNewImages!.keys)
            
            self.newPost.image_files_array = self.arryNewPostImageFilenames
            self.newPost.image_filenames_ios = self.arryNewPostImageFilenames?.joined(separator: ",")
            
        }

        
        
        rinconStore.sendPostToApi(post: newPost) { jsonResponse in
            if jsonResponse["post_received_status"] == "success"{
                
                
                if self.arryNewPostImageFilenames != nil  {
                    print("* if self.arryNewPostImageFilenames")
                    self.sendNewPostImages(post_id: jsonResponse["new_post_id"]!)
                }
                else if self.newPostVideoURL != nil {
                    print("***** else if self.newPostVideoURL")
                    self.newPostVideoName = "post_"+self.newPost.post_id+"_video.MOV"
                    self.sendNewPostVideo(post_id: jsonResponse["new_post_id"]!)
                    self.newPost.video_file_name = self.newPostVideoName!
                }
                
                self.posts.append(self.newPost)
                
                self.rinconStore.requestRinconPosts(rincon: self.rincon) { responseForRinconPostsArray in
                    switch responseForRinconPostsArray{
                    case let .success(arryRinconPosts):
                        self.posts = arryRinconPosts
                        self.tblRincon.reloadData()
                        DispatchQueue.main.async {
//                            self.rinconVcAlertMessage = "Post successfully sent"
                            self.rinconAlert(message: "Post successfully sent")
                        }
                        self.hideStckVwSubmitPostTxtAndBtn()
                    case let .failure(error):
                        print("Failed to get posts from api: \(error)")
                        DispatchQueue.main.async {
//                            self.rinconVcAlertMessage = "Didn't send, something went wrong"
                            self.rinconAlert(message: "Didn't send, something went wrong")
                        }
                        
                    }
                }// self.rinconStore.requestRinconPosts
            } // if jsonResponse["post_received_status"]
            
        }
    }
    
    private func sendNewPostImages(post_id:String){
        print("- in RinconVC sendNewPostImages")
        
        if let unwp_dict = self.dictNewImages {
            
            self.rinconStore.sendImagesThree(dictNewImages: unwp_dict) { jsonDict in
                
                //MARK: This needs to change corrected image name
                if jsonDict["image_received_status"] == "Successfully send images and executed /receive_image endpoint " {
                    for (name, img) in unwp_dict {
                        self.imageStore.setImage(img, forKey: name, rincon:self.rincon)
                    }
                }
            }
        }
        arryNewPostImages = []
        arryNewPostImageFilenames = []
    }
    
    private func sendNewPostVideo(post_id:String){
        if let unwp_videoURL = self.newPostVideoURL{
//            let videoName = self.newPostVideoName!
            self.rinconStore.sendVideo(videoName: self.newPostVideoName!, videoURL: unwp_videoURL) { jsonDict in
                if jsonDict["video_received_status"] == "Successfully send images and executed /receive_video endpoint" {
//                    for (name, url) in unwp_videoURL {
                    let fileManager = FileManager.default
                    let rinconFolderPath = self.rinconStore.rinconFolderUrl(rincon: self.rincon)
                    let destinationURL = rinconFolderPath.appendingPathComponent(self.newPostVideoName!)
//                    try fileManager.moveItem(at: unwp_videoURL, to: destinationURL)
                    do {
                        try fileManager.copyItem(at: unwp_videoURL, to: destinationURL)
                    } catch {
                        print("Failed to copy video file")
                    }
                        
                    
                }
            }
        }
    }
    
    @objc func btnAddPhotosTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    @objc func btnAddPhotosTouchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)

//        openPhotoGallery()
        
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title:"Add Photos", style:.default,handler: { _ in
            self.arryNewPostImageFilenames = []
            self.arryNewPostImages = []
            self.openPhotoGallery()
        }))
        actionSheet.addAction(UIAlertAction(title:"Add Video", style: .default,handler: { _ in
            print("Get a video")
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
//            imagePicker.mediaTypes = [UTTypeMovie as String]
            imagePicker.mediaTypes = [UTType.movie.identifier]
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    func openPhotoGallery() {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.selectionLimit = 0 // No limit
        configuration.filter = .images // Only images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print("--- in picker ---")
        
        for result in results {
            
            let resultProvider = result.itemProvider
            resultProvider.loadFileRepresentation(forTypeIdentifier: "public.item") { (url,error) in
                if error != nil {
                    print("error: \(error!)")
                } else {
                    if let url = url {
                        print("url: \(url)")
                        let temp_image = getImageFrom(url: url)
                        if let temp_image = temp_image {
                            self.arryNewPostImageFilenames!.append(url.lastPathComponent)
                            self.arryNewPostImages.append(temp_image)
                        }
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    /* Get videos */
    
    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)

        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
//            uploadVideoToAPI(videoURL: videoURL)
            print("- selected a video: \(videoURL)")
            SentrySDK.capture(message: "- selected a video: \(videoURL)")
//            newPostVideoName = post.post_id+"_video.MOV"
            newPostVideoURL = videoURL
//            let crumb = Breadcrumb()
//            crumb.level = SentryLevel.info
//            crumb.category = "test"
//            crumb.message = "Testing out breadcrumb - video: does Breadcrumb() object provide data that would otherwise be redacted?"
//            SentrySDK.addBreadcrumb(crumb)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        
        
        self.rinconStore.requestRinconPosts(rincon: rincon) { responseForRinconPostsArray in
            switch responseForRinconPostsArray{
            case let .success(arryRinconPosts):
                for p in arryRinconPosts{
                    p.rincon_dir_path = self.rinconStore.rinconFolderUrl(rincon: self.rincon)
                }
                self.posts = arryRinconPosts
                self.tblRincon.reloadData()
                sender.endRefreshing()
            case let .failure(error):
                print("FAiled to communicate with API for posts: \(error)")
            }
        }
    }
    
    @objc func rinconAlert(message:String) {
        // Create an alert
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        print("rinconVcAlertMessage: \(rinconVcAlertMessage)")
        // Create an OK button
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Dismiss the alert when the OK button is tapped
            alert.dismiss(animated: true, completion: nil)
        }
        
        // Add the OK button to the alert
        alert.addAction(okAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    /* Delegate functions */
    func customReloadCell(indexPath:IndexPath){
        tblRincon.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        print("- customReloadCell from RinconVC")
    }
    func customUpdatePostsAndReloadCell(posts:[Post], indexPath:IndexPath){
        self.posts = posts
        tblRincon.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
    }
    func deleteCommentAreYouSure(sender:DeleteCommentButton,indexPath:IndexPath){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        //        alertController.popoverPresentationController?.sourceRect = self.bounds
        alertController.popoverPresentationController?.sourceView = self.stckVwRincon
        
        let current_post = posts[indexPath.row]
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteCommentAction = UIAlertAction(title: "Delete", style: .destructive){_ in
            print("delete this comment from postid:\(current_post.post_id!) for comment: \(sender.comment_id)")
            
            self.rinconStore.deleteComment(rincon_id: current_post.rincon_id, post_id: current_post.post_id, comment_id: sender.comment_id) { post in
                self.posts[indexPath.row] = post
                self.customUpdatePostsAndReloadCell(posts:self.posts, indexPath: indexPath)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteCommentAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func deletePostAreYouSure(indexPath:IndexPath){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        //        alertController.popoverPresentationController?.sourceRect = self.bounds
        alertController.popoverPresentationController?.sourceView = self.stckVwRincon
        
        let current_post = posts[indexPath.row]
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteCommentAction = UIAlertAction(title: "Delete", style: .destructive){_ in
            print("delete  postid:\(current_post.post_id!) ")
            self.rinconStore.deletePost(post: current_post) { jsonDict in
                if jsonDict["deleted_post_id"] == current_post.post_id!{
                    print("--> good: succusfully deleted post (\(current_post.post_id!)) from API")
                    
                    if let unwp_images_array =  current_post.image_files_array {
                        for img_name in unwp_images_array{
                            self.imageStore.deleteImage(forKey: img_name, rincon:self.rincon)
                        }
                    }
                    
                    if let unwp_video = current_post.video_file_name{
                        self.imageStore.deleteImage(forKey: unwp_video, rincon:self.rincon)
                    }
                    
                    self.posts.remove(at: indexPath.row)
                    self.rinconStore.writePostsToJson(rincon: self.rincon, posts: self.posts)
                    
                    self.tblRincon.reloadData()
                    print("successfully removed post from this Phone")
                } else{
                    print("--> bad: failed to delete post:")
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteCommentAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func goBackToYourRincons(){
        if let _ = self.navigationController{
            self.navigationController?.popViewController(animated: true)
        }
    }
}


extension RinconVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = posts[indexPath.row]
        print("cell is tapped for post: \(post.post_id!)")
        // Hide keyboard
        self.view.endEditing(true)
        if let cell = tableView.cellForRow(at: indexPath) as? PostCell {
            // Replace `YourCustomTableViewCellClass` with the actual class of your cell
            
                // Print accessibilityIdentifiers
            if let unwp_stackViewImages = cell.stackViewImages{
                for element in unwp_stackViewImages.arrangedSubviews{
//                    print("element: \(element)")
                    print("\(element.accessibilityIdentifier!): \(element)")
                    if element is UIStackView{
                        if let unwp_stack = element as? UIStackView{
                            for sub_element in unwp_stack.arrangedSubviews{
//                                print("sub_element: \(sub_element.accessibilityIdentifier ?? "no accessibilityIdentifier")")
                                if let sub_element_image = sub_element as? UIImageView{
                                    print("\(sub_element_image.accessibilityIdentifier!): \(sub_element_image)")
                                    print("\(sub_element_image.accessibilityIdentifier!).image: \(sub_element_image.image!)")
                                }
                            }
                        }
                    } else{
                        print("element: \(element.accessibilityIdentifier ?? "no accessibilityIdentifier")")
                    }
                }
            }
        }
        print("---- End Cell Tap -----")
        if boolPostDialogueVisible == true{
            hideStckVwSubmitPostTxtAndBtn()
        }
    }
}

extension RinconVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        
        let this_post = posts[indexPath.row]
        cell.rinconStore = self.rinconStore
        cell.imageStore = self.imageStore
        cell.rinconVCDelegate = self
        cell.indexPath = indexPath
        cell.rincon = self.rincon
        cell.currentUser = self.userStore.user
        if let unwrapped_image_filenames = this_post.image_filenames_ios{
            this_post.image_files_array = imageFileNameParser(unwrapped_image_filenames)
        }
        cell.configure(with: this_post)
        cell.accessibilityIdentifier = "PostCell\(this_post.post_id!)"
        
        return cell
    }
    
}

protocol RinconVCDelegate{
    func customReloadCell(indexPath:IndexPath)
    func customUpdatePostsAndReloadCell(posts:[Post], indexPath:IndexPath)
    func deleteCommentAreYouSure(sender:DeleteCommentButton, indexPath:IndexPath)
    func deletePostAreYouSure(indexPath:IndexPath)
    func goBackToYourRincons()
}
