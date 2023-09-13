//
//  CommentView.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 18/07/2023.
//

import UIKit


class CommentView:UIView {
    var post = Post(){
        didSet{
            if let unwrapped_comments = post.comments {
                lblCommentCount.text = String(unwrapped_comments.count)
            } else {
                lblCommentCount.text = "0"
            }
        }
    }
    var lblCommentCount=UILabel()
    var btnComment=UIButton()
    var viewHeight = 0.0
    var postCellDelegate: PostCellDelegate!
    var configSfSymbolSizeUserInteraction:UIImage.SymbolConfiguration!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup_view(){
        btnComment.setImage(UIImage(systemName: "bubble.left", withConfiguration: configSfSymbolSizeUserInteraction), for: .normal)
        btnComment.addTarget(self, action: #selector(btnCommentPressed), for: .touchUpInside)
        
        
        btnComment.translatesAutoresizingMaskIntoConstraints = false
        lblCommentCount.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lblCommentCount)
        self.addSubview(btnComment)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        btnComment.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive=true
        btnComment.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        lblCommentCount.leadingAnchor.constraint(equalTo: btnComment.trailingAnchor).isActive=true
        lblCommentCount.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive=true
        
        
        // Size lbl
        let _ = sizeLabel(lbl: lblCommentCount)
//        print("post: \(post.post_id!)")
//        print("lblCommentCount size: \(lblCommentCount.frame.size)")
//        print("btnComment.imageView.image.frame.size size: \(btnComment.imageView!.image!.size)")
        viewHeight = max(lblCommentCount.frame.size.height, btnComment.imageView!.image!.size.height)
//        btnComment.heightAnchor.constraint(equalToConstant: viewHeight + 10).isActive=true
        //        viewHeight = 25.0
    }
    
    @objc private func btnCommentPressed() {
        print("Comment button pressed for post: \(post.post_id!)")
        postCellDelegate.expandNewComment()
    }
}



class CommentsView:UIView {
    
    var rinconVCDelegate: RinconVCDelegate!
    var indexPath: IndexPath!
    var post = Post() {
        didSet{
            setup_view()
        }
    }
    //comments stack
    var stckVwComments: UIStackView?
    var dictCommentsDate: [String:UILabel]?
    let lblDateFontSize = 15.0
    var dictCommentsUsername: [String:UILabel]?
    let lblUsernameFontSize = 13.0
    var dictCommentsText: [String:UILabel]?
    var dictCommentsVw: [String:UIView]?
    var dictCommentsDeleteBtn: [String:DeleteCommentButton]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        setup_view()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        /* This function runs after all the ui objects have been set (i.e you can get sizes here */
    }
    
    override var intrinsicContentSize: CGSize {

        return CGSize(width: stckVwComments!.frame.size.width, height: stckVwComments!.frame.size.height) // This sets the preferred height to 300
    }
    
    func setup_view(){
        stckVwComments =  UIStackView()
        stckVwComments!.translatesAutoresizingMaskIntoConstraints = false
        stckVwComments!.axis = .vertical
        self.addSubview(stckVwComments!)
        stckVwComments!.accessibilityIdentifier = "stckVwComments"
        dictCommentsDate = [String:UILabel]()
        dictCommentsUsername = [String:UILabel]()
        dictCommentsText = [String:UILabel]()
        dictCommentsVw = [String:UIView]()
        dictCommentsDeleteBtn = [String:DeleteCommentButton]()
        
        if let unwrapped_comments = post.comments {
            stckVwComments?.spacing = heightFromPct(percent: 0.5)
            for comment_element in unwrapped_comments{
                dictCommentsDate!["\(post.post_id!), \(comment_element.comment_id!)"] = UILabel()
                dictCommentsUsername!["\(post.post_id!), \(comment_element.comment_id!)"] = UILabel()
                dictCommentsText!["\(post.post_id!), \(comment_element.comment_id!)"] = UILabel()
                dictCommentsVw!["\(post.post_id!), \(comment_element.comment_id!)"] = UIView()
                
                
                if let unwp_lblDate = dictCommentsDate!["\(post.post_id!), \(comment_element.comment_id!)"],
                   let unwp_lblUsername = dictCommentsUsername!["\(post.post_id!), \(comment_element.comment_id!)"],
                   let unwp_lblText = dictCommentsText!["\(post.post_id!), \(comment_element.comment_id!)"],
                   let unwp_vw = dictCommentsVw!["\(post.post_id!), \(comment_element.comment_id!)"] {
                    
                    unwp_vw.backgroundColor = .gray
                    unwp_vw.layer.cornerRadius = 10
                    
                    unwp_lblDate.text = comment_element.date
                    
                    unwp_lblDate.semanticContentAttribute = .forceRightToLeft
                    unwp_lblDate.translatesAutoresizingMaskIntoConstraints = false
                    let _ = sizeLabel(lbl: unwp_lblDate)
                    unwp_lblDate.font = unwp_lblDate.font.withSize(lblDateFontSize)
                    unwp_vw.addSubview(unwp_lblDate)
                    unwp_lblDate.accessibilityIdentifier = "unwp_lblDate: \(post.post_id!), \(comment_element.comment_id!)"
                    unwp_lblDate.topAnchor.constraint(equalTo: unwp_vw.topAnchor, constant: heightFromPct(percent: 1)).isActive=true
                    unwp_lblDate.trailingAnchor.constraint(equalTo: unwp_vw.trailingAnchor).isActive=true
                    unwp_lblDate.leadingAnchor.constraint(equalTo: unwp_vw.leadingAnchor).isActive=true
                    
                    unwp_lblUsername.text = comment_element.username
                    unwp_lblUsername.translatesAutoresizingMaskIntoConstraints=false
                    let _ = sizeLabel(lbl: unwp_lblUsername)
                    unwp_lblUsername.font = unwp_lblUsername.font.withSize(lblUsernameFontSize)
                    unwp_vw.addSubview(unwp_lblUsername)
                    unwp_lblUsername.topAnchor.constraint(equalTo: unwp_lblDate.bottomAnchor, constant: heightFromPct(percent: 1)).isActive=true
                    unwp_lblUsername.leadingAnchor.constraint(equalTo: unwp_vw.leadingAnchor, constant: widthFromPct(percent: 2)).isActive=true
                    unwp_lblUsername.trailingAnchor.constraint(equalTo: unwp_vw.trailingAnchor).isActive=true
                    
                    unwp_lblText.text = comment_element.comment_text
                    unwp_lblText.numberOfLines = 0
                    unwp_lblText.translatesAutoresizingMaskIntoConstraints=false
                    let _ = sizeLabel(lbl: unwp_lblText)
                    unwp_vw.addSubview(unwp_lblText)
                    unwp_lblText.topAnchor.constraint(equalTo: unwp_lblUsername.topAnchor, constant: heightFromPct(percent: 2)).isActive=true
                    unwp_lblText.trailingAnchor.constraint(equalTo: unwp_vw.trailingAnchor, constant: widthFromPct(percent: -2)).isActive=true
                    //                        unwp_lblText.bottomAnchor.constraint(equalTo: unwp_vw.bottomAnchor, constant: heightFromPct(percent: -2)).isActive=true
                    unwp_lblText.leadingAnchor.constraint(equalTo: unwp_vw.leadingAnchor, constant: widthFromPct(percent: 2)).isActive=true
                    
                    
                    if comment_element.delete_comment_permission{
                        dictCommentsDeleteBtn!["\(post.post_id!), \(comment_element.comment_id!)"] = DeleteCommentButton()
                        if let unwp_btnDelete = dictCommentsDeleteBtn?["\(post.post_id!), \(comment_element.comment_id!)"] as? DeleteCommentButton {
//                            unwp_btnDelete.setTitle("delete", for: .normal)
                            let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large) // create a large configuration
                            unwp_btnDelete.setImage(UIImage(systemName: "trash", withConfiguration: largeConfig), for: .normal)
                            unwp_btnDelete.tintColor = UIColor(named: "redDelete")
                            unwp_btnDelete.layer.borderColor = UIColor(named: "redDelete")?.cgColor

                            
//                            unwp_btnDelete.layer.borderWidth = 2
//                            unwp_btnDelete.setTitleColor(.black, for: .normal)
//                            unwp_btnDelete.layer.cornerRadius = 10
//                            unwp_btnDelete.backgroundColor = UIColor(named: "gray-500")
                            
                            unwp_btnDelete.translatesAutoresizingMaskIntoConstraints = false
                            //                                unwp_btnDelete.configuration?.contentInsets = .zero
                            unwp_vw.addSubview(unwp_btnDelete)
                            unwp_btnDelete.topAnchor.constraint(equalTo: unwp_lblText.bottomAnchor).isActive=true
                            unwp_btnDelete.trailingAnchor.constraint(equalTo: unwp_vw.trailingAnchor, constant: heightFromPct(percent: -2)).isActive = true
                            unwp_btnDelete.bottomAnchor.constraint(equalTo: unwp_vw.bottomAnchor, constant: heightFromPct(percent: -2)).isActive=true
                            unwp_btnDelete.widthAnchor.constraint(equalToConstant: widthFromPct(percent: 25) ).isActive=true
                            
                            unwp_btnDelete.comment_id = comment_element.comment_id
                            unwp_btnDelete.addTarget(self, action: #selector(deleteCommentTouchDown(_:)), for: .touchUpInside)
                            unwp_btnDelete.addTarget(self, action: #selector(deleteCommentTouchUpInside(_:)), for: .touchUpInside)

                        }
                    } else {
                        unwp_lblText.bottomAnchor.constraint(equalTo: unwp_vw.bottomAnchor, constant: heightFromPct(percent: -2)).isActive=true
                    }
                    
                    stckVwComments!.addArrangedSubview(unwp_vw)
                    unwp_vw.accessibilityIdentifier = "unwp_vw: \(post.post_id!), \(comment_element.comment_id!)"
                    unwp_vw.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive=true
                    
                }
            }
        }
        
        stckVwComments!.layoutIfNeeded()
        
    }
    

    @objc func deleteCommentTouchDown(_ sender: DeleteCommentButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }

    @objc func deleteCommentTouchUpInside(_ sender: DeleteCommentButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        rinconVCDelegate.deleteCommentAreYouSure(sender:sender, indexPath:indexPath)
    }
    
    
    
}



class DeleteCommentButton: UIButton {
    var comment_id: String = ""

}
