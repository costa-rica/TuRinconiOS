//
//  RinconOptionsVC.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 08/08/2023.
//

import UIKit

class RinconOptionsVC: UIViewController {
    var vwCreateRincon = UIView()
    var stckVwCreateRincon:UIStackView!
    var lblTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's frame to take up most of the screen except for 5 percent all sides
        self.view.frame = UIScreen.main.bounds.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        setupView()
    }
    
    func setupView() {
        // The semi-transparent background
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
        
        // The white alert view
//        let alertView = UIView()
//        vwCreateRincon.backgroundColor = UIColor(named: "gray-500")
        vwCreateRincon.backgroundColor = UIColor.systemBackground
        vwCreateRincon.layer.cornerRadius = 12
        vwCreateRincon.layer.borderColor = UIColor(named: "gray-500")?.cgColor
        vwCreateRincon.layer.borderWidth = 2
        vwCreateRincon.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(vwCreateRincon)
        
        NSLayoutConstraint.activate([
            vwCreateRincon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vwCreateRincon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            vwCreateRincon.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
//            vwCreateRincon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        
        setupInputsInView()
    }
    
    func setupInputsInView() {
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
//        txtNewRinconName.translatesAutoresizingMaskIntoConstraints = false
//        btnPublic.translatesAutoresizingMaskIntoConstraints = false

        lblTitle.text = "Create a new rincón"
        lblTitle.font = UIFont(name: "Rockwell_tu", size: 20)
        
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
        
        stckVwCreateRincon = UIStackView(arrangedSubviews: [lblTitle, stckVwButtons])
        stckVwCreateRincon.axis = .vertical
        stckVwCreateRincon.spacing = 10

        vwCreateRincon.addSubview(stckVwCreateRincon)

        stckVwCreateRincon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stckVwCreateRincon.topAnchor.constraint(equalTo: vwCreateRincon.topAnchor, constant: heightFromPct(percent: 2)),
            stckVwCreateRincon.leadingAnchor.constraint(equalTo: vwCreateRincon.leadingAnchor, constant: widthFromPct(percent: 2)),
            stckVwCreateRincon.trailingAnchor.constraint(equalTo: vwCreateRincon.trailingAnchor, constant: widthFromPct(percent: -2)),
            stckVwCreateRincon.bottomAnchor.constraint(lessThanOrEqualTo: vwCreateRincon.bottomAnchor, constant: heightFromPct(percent: -2))
        ])
    }
}
