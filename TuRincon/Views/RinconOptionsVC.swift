//
//  RinconOptionsVC.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 08/08/2023.
//

import UIKit

class RinconOptionsInviteVC: UIViewController {
    var rincon:Rincon!
    var rinconStore:RinconStore!
    var vwRinconOptions = UIView()
    var stckVwRinconOptions:UIStackView!
    var lblTitle = UILabel()
    var lblInvite = UILabel()
    var txtEmail = UITextField()
    var btnInviteEmail = UIButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's frame to take up most of the screen except for 5 percent all sides
        self.view.frame = UIScreen.main.bounds.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        setup_vwRinconOptions()
        setup_stckVwRinconOptions()
        
        // Add a gesture recognizer to the view that dismisses the view controller when the user taps outside of the UIStackView
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
//        view.addGestureRecognizer(tapGestureRecognizer)
        addTapGestureRecognizer()
    }
    
    func setup_vwRinconOptions() {
        // The semi-transparent background
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
//        view.backgroundColor = .systemBlue
        vwRinconOptions .backgroundColor = UIColor.systemBackground
        vwRinconOptions .layer.cornerRadius = 12
        vwRinconOptions .layer.borderColor = UIColor(named: "gray-500")?.cgColor
        vwRinconOptions .layer.borderWidth = 2
        vwRinconOptions .translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vwRinconOptions )
        vwRinconOptions .centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        vwRinconOptions .centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        vwRinconOptions.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90).isActive=true

    }
    
    func setup_stckVwRinconOptions() {
        
        stckVwRinconOptions  = UIStackView()
        stckVwRinconOptions.axis = .vertical
        stckVwRinconOptions.spacing = 10
        vwRinconOptions.addSubview(stckVwRinconOptions)
        stckVwRinconOptions .translatesAutoresizingMaskIntoConstraints = false
        stckVwRinconOptions .topAnchor.constraint(equalTo: vwRinconOptions .topAnchor, constant: heightFromPct(percent: 2)).isActive=true
        stckVwRinconOptions .leadingAnchor.constraint(equalTo: vwRinconOptions .leadingAnchor, constant: widthFromPct(percent: 2)).isActive=true
        stckVwRinconOptions .trailingAnchor.constraint(equalTo: vwRinconOptions .trailingAnchor, constant: widthFromPct(percent: -2)).isActive=true
        stckVwRinconOptions .bottomAnchor.constraint(lessThanOrEqualTo: vwRinconOptions .bottomAnchor, constant: heightFromPct(percent: -2)).isActive=true
        
        
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
//        txtNewRinconName.translatesAutoresizingMaskIntoConstraints = false
//        btnPublic.translatesAutoresizingMaskIntoConstraints = false

        lblTitle.text = "Rincón Options"
        lblTitle.font = UIFont(name: "Rockwell_tu", size: 20)
        stckVwRinconOptions.addArrangedSubview(lblTitle)
        
        let imgVwLine01 = createDividerLine(thicknessOfLine: 2)
        imgVwLine01.translatesAutoresizingMaskIntoConstraints=false
        stckVwRinconOptions.addArrangedSubview(imgVwLine01)
        
        lblInvite.text = "Email to invite:"
        lblInvite.translatesAutoresizingMaskIntoConstraints=false
        stckVwRinconOptions.addArrangedSubview(lblInvite)
        
        txtEmail.translatesAutoresizingMaskIntoConstraints=false
        txtEmail.layer.borderWidth = 2
        txtEmail.layer.borderColor = CGColor(gray: 0.8, alpha: 1.0)
        txtEmail.layer.cornerRadius = 2
        txtEmail.placeholder = "your_friend@email.com"
        
        stckVwRinconOptions.addArrangedSubview(txtEmail)
        
        btnInviteEmail.translatesAutoresizingMaskIntoConstraints=false
        btnInviteEmail.setTitle("Send Invite", for: .normal)
        btnInviteEmail.layer.borderColor = UIColor.systemBlue.cgColor
        btnInviteEmail.layer.borderWidth = 2
        btnInviteEmail.layer.cornerRadius=10
//        btnInviteEmail.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        btnInviteEmail.setTitleColor(.systemBlue, for: .normal)
        btnInviteEmail.addTarget(self, action: #selector(touchDownBtnInviteEmail(_:)), for: .touchDown)
        btnInviteEmail.addTarget(self, action: #selector(touchUpInsideBtnInviteEmail(_:)), for: .touchUpInside)
        stckVwRinconOptions.addArrangedSubview(btnInviteEmail)
        
        

//        let submitButton = UIButton(type: .system)
//        submitButton.setTitle("Submit", for: .normal)
////        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
//
//        let cancelButton = UIButton(type: .system)
//        cancelButton.setTitle("Cancel", for: .normal)
////        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
//
//
//        let stckVwButtons = UIStackView(arrangedSubviews: [submitButton,cancelButton])
//        stckVwButtons.translatesAutoresizingMaskIntoConstraints=false
        

//        preferredContentSize = stckVwRinconOptions.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        // Update the view's preferredContentSize to match the content's intrinsic size
//       preferredContentSize = stckVwRinconOptions.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("-- viewDidLayoutSubviews--")
        print("stckVwRinconOptions (minX,maxY): \(stckVwRinconOptions.frame.minX),\(stckVwRinconOptions.frame.maxY)")
        print("stckVwRinconOptions (maxX,maxY): \(stckVwRinconOptions.frame.maxX),\(stckVwRinconOptions.frame.maxY)")
        print("stckVwRinconOptions (maxX,minY): \(stckVwRinconOptions.frame.maxX),\(stckVwRinconOptions.frame.minY)")
        print("stckVwRinconOptions (minxX,minY): \(stckVwRinconOptions.frame.minX),\(stckVwRinconOptions.frame.minY)")
        print("uistackview: \(stckVwRinconOptions.frame.size)")
        print("---- ENd ----")
    }
    
    private func addTapGestureRecognizer() {
        // Create a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))

        // Add the gesture recognizer to the view
        view.addGestureRecognizer(tapGesture)
    }
    
//    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
//        let tapLocation = sender.location(in: view)
//        let tapLocationInView = view.convert(tapLocation, to: stckVwRinconOptions)
//        print("tapLocation: \(tapLocation)")
//        if !stckVwRinconOptions.bounds.contains(tapLocationInView) {
//            dismiss(animated: true, completion: nil)
//        } else {
//
//        }
//    }
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        let tapLocationInView = view.convert(tapLocation, to: stckVwRinconOptions)
        
        if let activeTextField = findActiveTextField(),
           activeTextField.isFirstResponder {
            // If a text field is active and the keyboard is visible, dismiss the keyboard
            activeTextField.resignFirstResponder()
        } else {
            // If no text field is active or the keyboard is not visible, dismiss the VC
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func touchDownBtnInviteEmail(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)

    }

    @objc func touchUpInsideBtnInviteEmail(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        print("- inviting user")
        
        if isValidEmail(txtEmail){
            print("- email is valid -")
            
            rinconStore.requestInviteToRincon(rincon: rincon, email: txtEmail.text!) { resultInvite in
                print("- rinconStore.requestInviteToRincon request sent")
                switch resultInvite{
                case let .success(jsonDictInvite):
                    print(jsonDictInvite)
                    if jsonDictInvite["status"]=="existing user"{
                        let messageSuccess = "\(self.txtEmail.text!) was successfully added to \(self.rincon.name)"
                        self.rinconOptionsInviteAlert(message: messageSuccess,dismissParent: true)

                    } else if jsonDictInvite["status"]=="added email to invite.json file" {
                        let messageSuccess = "\(self.txtEmail.text!) is not yet a user. When they sign up will have access to \(self.rincon.name)"
                        self.rinconOptionsInviteAlert(message: messageSuccess,dismissParent: true)

                    } else {

                        self.rinconOptionsInviteAlert(message: RinconStoreError.unknownServerResponse.localizedDescription,dismissParent: false)
                    }
                case let .failure(error):
                    print("Error: \(error)")
                    self.rinconOptionsInviteAlert(message: error.localizedDescription,dismissParent: false)
                }
            }
            
            print("- finished rinconStore.requestInviteToRincon")
        }
        else {
            rinconOptionsInviteAlert(message:"Email not valid.", dismissParent:false)
        }
    }
    
    func rinconOptionsInviteAlert(message:String, dismissParent:Bool) {
        // Create an alert
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        print("rinconVcAlertMessage: \(rinconVcAlertMessage)")
        // Create an OK button
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Dismiss the alert when the OK button is tapped
            alert.dismiss(animated: true, completion: nil)
            if dismissParent {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        // Add the OK button to the alert
        alert.addAction(okAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    private func findActiveTextField() -> UITextField? {
        // Iterate through your UIStackView's subviews to find the active text field
        for subview in stckVwRinconOptions.subviews {
            if let textField = subview as? UITextField, textField.isFirstResponder {
                return textField
            }
        }
        return nil
    }
    
}


class RinconOptionsDeleteVC: UIViewController {
    var rincon:Rincon!
    var rinconStore:RinconStore!
    var vwRinconOptions = UIView()
    var stckVwRinconOptions:UIStackView!
    var lblTitle = UILabel()
    var lblInvite = UILabel()
    var txtEmail = UITextField()
    var btnInviteEmail = UIButton()
    var lblDelete: UILabel?
    var txtDeleteConfirm:UITextField?
    var btnDeleteRincon:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's frame to take up most of the screen except for 5 percent all sides
        self.view.frame = UIScreen.main.bounds.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        setup_vwRinconOptions()
        setup_stckVwRinconOptions()
        
        if rincon.permission_admin!{
            setup_deleteRincon()
        }
    }
    
    func setup_vwRinconOptions() {
        // The semi-transparent background
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
        vwRinconOptions .backgroundColor = UIColor.systemBackground
        vwRinconOptions .layer.cornerRadius = 12
        vwRinconOptions .layer.borderColor = UIColor(named: "gray-500")?.cgColor
        vwRinconOptions .layer.borderWidth = 2
        vwRinconOptions .translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vwRinconOptions )
        vwRinconOptions .centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        vwRinconOptions .centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        vwRinconOptions.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90).isActive=true

    }
    
    func setup_stckVwRinconOptions() {
        
        stckVwRinconOptions  = UIStackView()
        stckVwRinconOptions.axis = .vertical
        stckVwRinconOptions.spacing = 10
        vwRinconOptions.addSubview(stckVwRinconOptions)
        stckVwRinconOptions .translatesAutoresizingMaskIntoConstraints = false
        stckVwRinconOptions .topAnchor.constraint(equalTo: vwRinconOptions .topAnchor, constant: heightFromPct(percent: 2)).isActive=true
        stckVwRinconOptions .leadingAnchor.constraint(equalTo: vwRinconOptions .leadingAnchor, constant: widthFromPct(percent: 2)).isActive=true
        stckVwRinconOptions .trailingAnchor.constraint(equalTo: vwRinconOptions .trailingAnchor, constant: widthFromPct(percent: -2)).isActive=true
        stckVwRinconOptions .bottomAnchor.constraint(lessThanOrEqualTo: vwRinconOptions .bottomAnchor, constant: heightFromPct(percent: -2)).isActive=true
        
        
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
//        txtNewRinconName.translatesAutoresizingMaskIntoConstraints = false
//        btnPublic.translatesAutoresizingMaskIntoConstraints = false

        lblTitle.text = "Delete Rincón"
        lblTitle.font = UIFont(name: "Rockwell_tu", size: 20)
        stckVwRinconOptions.addArrangedSubview(lblTitle)
        
        let imgVwLine01 = createDividerLine(thicknessOfLine: 2)
        imgVwLine01.translatesAutoresizingMaskIntoConstraints=false
        stckVwRinconOptions.addArrangedSubview(imgVwLine01)
        
        lblInvite.text = "Email to invite:"
        lblInvite.translatesAutoresizingMaskIntoConstraints=false
        stckVwRinconOptions.addArrangedSubview(lblInvite)
        
        txtEmail.translatesAutoresizingMaskIntoConstraints=false
        txtEmail.layer.borderWidth = 2
        txtEmail.layer.borderColor = CGColor(gray: 0.8, alpha: 1.0)
        txtEmail.layer.cornerRadius = 2
        txtEmail.placeholder = "your_friend@email.com"
        stckVwRinconOptions.addArrangedSubview(txtEmail)
        
        btnInviteEmail.translatesAutoresizingMaskIntoConstraints=false
        btnInviteEmail.setTitle("Send Invite", for: .normal)
        btnInviteEmail.layer.borderColor = UIColor.systemBlue.cgColor
        btnInviteEmail.layer.borderWidth = 2
        btnInviteEmail.layer.cornerRadius=10
        btnInviteEmail.setTitleColor(.systemBlue, for: .normal)
        stckVwRinconOptions.addArrangedSubview(btnInviteEmail)
        

        
        
        
        
        
//        txtNewRinconName.placeholder = " Enter Rincon Name"
//
//        txtNewRinconName.layer.borderWidth = 2
//        txtNewRinconName.layer.borderColor = CGColor(gray: 0.5, alpha: 1.0)
//        txtNewRinconName.layer.cornerRadius = 2
//        txtNewRinconName.widthAnchor.constraint(equalToConstant: widthFromPct(percent: 80)).isActive=true
//
//        btnPublic.setTitle(" Make public", for: .normal)
//        btnPublic.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
//        btnPublic.contentHorizontalAlignment = .left
//        btnPublic.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)

        

        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
//        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
//        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        
        let stckVwButtons = UIStackView(arrangedSubviews: [submitButton,cancelButton])
        stckVwButtons.translatesAutoresizingMaskIntoConstraints=false
        


    }
    
    func setup_deleteRincon(){
        
        let imgVwLine02 = createDividerLine(thicknessOfLine: 2)
        imgVwLine02.translatesAutoresizingMaskIntoConstraints=false
        stckVwRinconOptions.addArrangedSubview(imgVwLine02)
        
        lblDelete=UILabel()
        lblDelete?.text = "Delete Rincon"
        lblDelete?.translatesAutoresizingMaskIntoConstraints=false
        stckVwRinconOptions.addArrangedSubview(lblDelete!)
        
        txtDeleteConfirm=UITextField()
        txtDeleteConfirm?.placeholder = "Enter Rincón Name"
        txtDeleteConfirm?.translatesAutoresizingMaskIntoConstraints=false
        txtDeleteConfirm?.layer.borderWidth = 2
        txtDeleteConfirm?.layer.borderColor = CGColor(gray: 0.8, alpha: 1.0)
        txtDeleteConfirm?.layer.cornerRadius = 2
        stckVwRinconOptions.addArrangedSubview(txtDeleteConfirm!)
        
        btnDeleteRincon=UIButton()
        btnDeleteRincon?.setTitle("Delete Rincón", for: .normal)
        btnDeleteRincon?.translatesAutoresizingMaskIntoConstraints=false
        btnDeleteRincon?.layer.borderColor = UIColor(named: "redDelete")?.cgColor
        btnDeleteRincon?.layer.borderWidth = 2
        btnDeleteRincon?.layer.cornerRadius=10
        btnDeleteRincon?.setTitleColor(UIColor(named: "redDelete"), for: .normal)
        stckVwRinconOptions.addArrangedSubview(btnDeleteRincon!)
        
        
    }
}
