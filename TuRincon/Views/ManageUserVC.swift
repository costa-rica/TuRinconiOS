//
//  ManageUserVC.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 12/08/2023.
//

import UIKit

class ManageUserVC:DefaultViewController{
    
    var rinconStore:RinconStore!
    var userStore:UserStore!
    var yourRinconsVcDelegate: YourRinconsVCDelegate!
    var urlStore:URLStore!
    
    let vwVCHeaderOrange = UIView()
    let lblTitle = UILabel()
    var stckVwManageUser=UIStackView()
    
    var tblRincons = UITableView()
//    let backgroundColor = UIColor(named: "gray-300")?.cgColor
    let vwBackgroundCard = UIView()
    let cardInteriorPadding = Float(5.0)
    var txtDeleteConfirm = UITextField()
    let btnDeleteUser=UIButton()
    
//    var arryRincons: [Rincon]!
    
//    var isPublic: Bool = true // the checkbox state, default is checked
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("-Entered ManageUserVC")

        
        setup_vwVCHeaderOrange()
        setup_vwBackgroundCard()
        setup_stckVwManageUser()
        setup_lblTitle()
        setup_deleteUserUI()
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
    func setup_vwBackgroundCard(){
        vwBackgroundCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vwBackgroundCard)
        vwBackgroundCard.accessibilityIdentifier="vwBackgroundCard"
        vwBackgroundCard.backgroundColor = UIColor(named: "gray-500")
        vwBackgroundCard.topAnchor.constraint(equalTo: vwVCHeaderOrange.bottomAnchor, constant: heightFromPct(percent: 5)).isActive=true
        vwBackgroundCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: 5)).isActive=true
        vwBackgroundCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: -5)).isActive=true
        vwBackgroundCard.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: heightFromPct(percent: -10)).isActive=true
        vwBackgroundCard.layer.cornerRadius = 10
    }
    
    func setup_stckVwManageUser(){
        stckVwManageUser.translatesAutoresizingMaskIntoConstraints = false
        stckVwManageUser.spacing = 10
        stckVwManageUser.axis = .vertical
        view.addSubview(stckVwManageUser)
        stckVwManageUser.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor,constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
        stckVwManageUser.trailingAnchor.constraint(equalTo: vwBackgroundCard.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)).isActive=true
        
        stckVwManageUser.topAnchor.constraint(equalTo: vwBackgroundCard.topAnchor, constant: heightFromPct(percent: 1)).isActive=true
        view.layoutIfNeeded()
    }
    
    func setup_lblTitle(){
        lblTitle.text = "Manage User"
        lblTitle.font = UIFont(name: "Rockwell_tu", size: 30)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.accessibilityIdentifier="lblTitle"
        stckVwManageUser.addArrangedSubview(lblTitle)
    }
    
    func setup_deleteUserUI(){
        let imgVwLine02 = createDividerLine(thicknessOfLine: 2)
        imgVwLine02.translatesAutoresizingMaskIntoConstraints=false
        stckVwManageUser.addArrangedSubview(imgVwLine02)
        
        let lblUsername = UILabel()
        lblUsername.text = "Username: \(userStore.user.username ?? "uknonw")"
        lblUsername.translatesAutoresizingMaskIntoConstraints=false
        stckVwManageUser.addArrangedSubview(lblUsername)
        
        let lblEmail = UILabel()
        lblEmail.text = "User Email: \(userStore.user.email!)"
        lblEmail.translatesAutoresizingMaskIntoConstraints=false
        stckVwManageUser.addArrangedSubview(lblEmail)

        txtDeleteConfirm.placeholder = "Enter email to verify"
        txtDeleteConfirm.translatesAutoresizingMaskIntoConstraints=false
        txtDeleteConfirm.layer.borderWidth = 2
        txtDeleteConfirm.layer.borderColor = CGColor(gray: 0.8, alpha: 1.0)
        txtDeleteConfirm.layer.cornerRadius = 2
        stckVwManageUser.addArrangedSubview(txtDeleteConfirm)
        
        btnDeleteUser.setTitle("Delete User", for: .normal)
        btnDeleteUser.translatesAutoresizingMaskIntoConstraints=false
        btnDeleteUser.layer.borderColor = UIColor(named: "redDelete")?.cgColor
        btnDeleteUser.layer.borderWidth = 2
        btnDeleteUser.layer.cornerRadius=10
        btnDeleteUser.setTitleColor(UIColor(named: "redDelete"), for: .normal)
                
        btnDeleteUser.addTarget(self, action: #selector(touchDownBtnDeleteUser(_:)), for: .touchDown)
        btnDeleteUser.addTarget(self, action: #selector(touchUpInsideBtnDeleteUser(_:)), for: .touchUpInside)
                
        stckVwManageUser.addArrangedSubview(btnDeleteUser)
    }
    
    
    @objc func touchDownBtnDeleteUser(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)

    }

    @objc func touchUpInsideBtnDeleteUser(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        
        if txtDeleteConfirm.text ==  userStore.user.email{
            areYouSureAlert()
        }
        else {
            manageUserDeleteAlert(message:"Incorrectly entered user email", dismissParent:false)
        }
    }
    
    func areYouSureAlert(){
        print("- in areYouSureAlert")
        let alertController = UIAlertController(title: "Are you sure?", message: "This will delete all data associated with your account", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            // Do something when the user clicks OK
            self.rinconStore.deleteUser { resultDeleteUser in
                switch resultDeleteUser{
                case let .success(dictDeleteUser):
                    self.manageUserDeleteAlert(message: "Successfully removed user id: \(dictDeleteUser["deleted_user_id"]!)", dismissParent: true)
                case let .failure(error):
                    self.manageUserDeleteAlert(message: "Failed to delete due to \(error.localizedDescription)", dismissParent: false)
                }
            }
            alertController.dismiss(animated: true, completion: nil)//dismiss alert
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            // Do something when the user clicks Cancel
            alertController.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
    
    
    func manageUserDeleteAlert(message:String, dismissParent:Bool) {
        print("- in manageUserDeleteAlert")
        // Create an alert
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        // Create an OK button
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Dismiss the alert when the OK button is tapped
            alert.dismiss(animated: true, completion: nil)
            if dismissParent {
                self.navigationController?.popViewController(animated: true) // dimiss ManageUserVC
                self.yourRinconsVcDelegate.goBackToLogin()
            }
        }
        
        // Add the OK button to the alert
        alert.addAction(okAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addTapGestureRecognizer() {
        // Create a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))

        // Add the gesture recognizer to the view
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        let tapLocationInView = view.convert(tapLocation, to: stckVwManageUser)
        
        if let activeTextField = findActiveTextField(uiStackView: stckVwManageUser),
           activeTextField.isFirstResponder {
            // If a text field is active and the keyboard is visible, dismiss the keyboard
            activeTextField.resignFirstResponder()
        } else {
            // If no text field is active or the keyboard is not visible, dismiss the VC
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
}
