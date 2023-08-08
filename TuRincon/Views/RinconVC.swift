//
//  RinconVC.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 18/07/2023.
//

import UIKit
import PhotosUI

class RinconVC: DefaultViewController, RinconVCDelegate, PHPickerViewControllerDelegate {
    
    var userStore: UserStore!
    var rinconStore: RinconStore!
    var imageStore: ImageStore!
    var rincon:Rincon!
    var posts: [Post]!
    let vwVCHeaderOrange = UIView()
    var stckVwRincon=UIStackView()
    var tblRincon = UITableView()
    //    var backgroundColor: CGColor!
    
    var stckVwSubmitPostTxtAndBtn = UIStackView()
    var stckVwSubmitBtns = UIStackView()
    
    var txtPost = UITextView()
    var btnSubmitPost = UIButton()
    var btnAddPhotos = UIButton()
    var vwPostSpacer = UIView()
    var btnHidePostPrompt = UIButton()
    //    var selectedImageURLs: [URL] = []
    var arryNewPostImages = [UIImage]()
    var arryNewPostImageFilenames: [String]?
    var dictNewImages:[String:UIImage]?
    
    var btnRinconOptions: UIBarButtonItem?
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
        tblRincon.estimatedRowHeight = 100 // Provide an estimate here
        
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
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("txtPost size: \(txtPost.frame.size)")
        print("btnAddPhotos.size.frame: \(btnAddPhotos.frame.size)")
        print("btnSubmitPost: \(btnSubmitPost.frame.size)")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("-keyboardWillShow")
        if let unwp_array = self.arryNewPostImageFilenames{
            print("* --- arryNewPostImageFilenames ----*")
            print(unwp_array)
        }
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
        print("-keyboardWillHide")
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setup_vwVCHeaderOrange(){
        view.addSubview(vwVCHeaderOrange)
        vwVCHeaderOrange.backgroundColor = UIColor(named: "orangePrimary")
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
        stckVwRincon.addArrangedSubview(tblRincon)
    }
    
    
    func setup_btnRinconOptions() {
        // If the user has permission to post or admin then create the button
        if rincon.permission_post! || rincon.permission_admin! {
            btnRinconOptions = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onRinconOptions))
        }

        // If the button exists then add it to the navigation bar
        if let btnRinconOptions = btnRinconOptions {
            navigationItem.rightBarButtonItem = btnRinconOptions
        }
    }

    @objc func onRinconOptions() {
        // Create an action sheet
        let actionSheet = UIAlertController(title: "Rincon Options", message: nil, preferredStyle: .actionSheet)

        // Add the "Post to Rincon" action if the user has permission
        if rincon.permission_post! {
            actionSheet.addAction(UIAlertAction(title: "Post to Rincon", style: .default, handler: { action in
                // Call the postToRincon() function
                self.postToRincon()
            }))
        }

        // Add the "Rincon Options" action if the user has permission
        if rincon.permission_admin! {
            actionSheet.addAction(UIAlertAction(title: "Rincon Options", style: .default, handler: { action in
                // Create a new RinconOptionsVC
                let rinconOptionsVC = RinconOptionsVC()

                // Set the modal presentation style
                rinconOptionsVC.modalPresentationStyle = .overCurrentContext
                rinconOptionsVC.modalTransitionStyle = .crossDissolve

                // Present the RinconOptionsVC
                self.present(rinconOptionsVC, animated: true, completion: nil)
                
                
//                let createRinconVC = CreateRinconVC()
//                createRinconVC.modalPresentationStyle = .overCurrentContext
//                createRinconVC.modalTransitionStyle = .crossDissolve
//                createRinconVC.rinconStore = self.rinconStore
//                createRinconVC.searchRinconVcDelegate = self
//                present(createRinconVC, animated: true, completion: nil)
                
                
            }))
        }

        // Add the "Cancel" action
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Show the action sheet
        self.present(actionSheet, animated: true, completion: nil)
    }

//    @objc func postToRinconNew() {
//        // Print the name of the postToRincon() function to the console
//        print("postToRincon()")
//    }
    
    
    
    
    
    
    
//    func setupRightBarButtonItem(){
//        // Set up the action sheet
//        let actionSheet = UIAlertController(title: "Rincon Options", message: nil, preferredStyle: .actionSheet)
//
//        if rincon.permission_post! {
//            // Add the "Post to Rincon" action
//            actionSheet.addAction(UIAlertAction(title: "Post to Rincon", style: .default, handler: { action in
//                // Call the postToRincon() function
//                self.postToRincon()
//            }))
//        }
//
//        if rincon.permission_admin! {
//            // Add the "Rincon Options" action
//            actionSheet.addAction(UIAlertAction(title: "Rincon Options", style: .default, handler: { action in
//                // Create a new RinconOptionsVC
//                let rinconOptionsVC = RinconOptionsVC()
//
//                // Set the modal presentation style
//                rinconOptionsVC.modalPresentationStyle = .overCurrentContext
//
//                // Present the RinconOptionsVC
//                self.present(rinconOptionsVC, animated: true, completion: nil)
//            }))
//        }
//
//        // Add the "Cancel" action
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        // Only show the action sheet if the user has permission to do something
//        if rincon.permission_post! || rincon.permission_admin! {
//            self.present(actionSheet, animated: true, completion: nil)
//        } else {
//            btnRinconOptions = nil
//        }
//    }
    
//    func setupRightBarButtonItem() {
//
//        if (rincon.permission_post!) {
//            btnRinconOptions  = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(postToRincon))
//        } else {
//            rinconVcAlertMessage = "\(userStore.user.username!) does not have post privileges for \(rincon.name)"
//            btnRinconOptions  = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rinconAlert))
//        }
//
//        if (rincon.permission_admin!) {
//            // Set up the action sheet
//            let actionSheet = UIAlertController(title: "Rincon Options", message: nil, preferredStyle: .actionSheet)
//            // Add the "Post to Rincon" action
//            actionSheet.addAction(UIAlertAction(title: "Post to Rincon", style: .default, handler: { action in
//                // Call the postToRincon() function
//                self.postToRincon()
//            }))
//        }
//        self.navigationItem.rightBarButtonItem = btnRinconOptions
//    }
    
    
    
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
        
        btnHidePostPrompt.setTitle("Hide", for: .normal)
        btnHidePostPrompt.translatesAutoresizingMaskIntoConstraints=false
        vwPostSpacer.addSubview(btnHidePostPrompt)
        stckVwRincon.addArrangedSubview(vwPostSpacer)
        btnHidePostPrompt.leadingAnchor.constraint(equalTo: vwPostSpacer.leadingAnchor, constant: widthFromPct(percent: 25)).isActive=true
        btnHidePostPrompt.topAnchor.constraint(equalTo: vwPostSpacer.topAnchor, constant: heightFromPct(percent: 1)).isActive=true
        btnHidePostPrompt.addTarget(self, action: #selector(hideStckVwSubmitPostTxtAndBtn), for: .touchUpInside)
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
                self.posts.append(self.newPost)
                
                if self.arryNewPostImageFilenames != nil  {
                    self.sendNewPostImages(post_id: jsonResponse["new_post_id"]!)
                }
                
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
    
    @objc func btnAddPhotosTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    @objc func btnAddPhotosTouchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        self.arryNewPostImageFilenames = []
        self.arryNewPostImages = []
        openPhotoGallery()
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
        
        print("- end picker ---")
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
    
    /* Delegat functions */
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
    
    
}


extension RinconVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell is tapped")
        // Hide keyboard
        self.view.endEditing(true)
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
        
        return cell
    }
    
}

protocol RinconVCDelegate{
    func customReloadCell(indexPath:IndexPath)
    func customUpdatePostsAndReloadCell(posts:[Post], indexPath:IndexPath)
    func deleteCommentAreYouSure(sender:DeleteCommentButton, indexPath:IndexPath)
    func deletePostAreYouSure(indexPath:IndexPath)
}
