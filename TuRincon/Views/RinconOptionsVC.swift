//
//  RinconOptionsVC.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 08/08/2023.
//

import UIKit

class RinconOptionsVC: UIViewController {
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
