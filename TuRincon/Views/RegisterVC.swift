//
//  RegisterVC.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 17/07/2023.
//

import UIKit

class RegisterVC: DefaultViewController{
    
    let vwVCHeaderOrange = UIView()
    let vwVCHeaderOrangeTitle = UIView()
    let imgVwIconNoName = UIImageView()
    let lblHeaderTitle = UILabel()
    let vwBackgroundCard = UIView()
    
    let lblTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_vwVCHeaderOrange()
        setup_vwVCHeaderOrangeTitle()
        setup_vwBackgroundCard()
        setup_lblTitle()
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
    func setup_vwVCHeaderOrangeTitle(){
        view.addSubview(vwVCHeaderOrangeTitle)
        vwVCHeaderOrangeTitle.backgroundColor = UIColor(named: "orangePrimary")
        vwVCHeaderOrangeTitle.translatesAutoresizingMaskIntoConstraints = false
        vwVCHeaderOrangeTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        vwVCHeaderOrangeTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        vwVCHeaderOrangeTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        
        if let unwrapped_image = UIImage(named: "android-chrome-192x192") {
            imgVwIconNoName.image = unwrapped_image.scaleImage(toSize: CGSize(width: 20, height: 20))
            print("imgVwIconNoName size: \(imgVwIconNoName.image!.size)")
            print("imgVwIconNoName size: \(unwrapped_image.size)")
            vwVCHeaderOrangeTitle.heightAnchor.constraint(equalToConstant: imgVwIconNoName.image!.size.height + 10).isActive=true
        }
        imgVwIconNoName.translatesAutoresizingMaskIntoConstraints = false
        vwVCHeaderOrangeTitle.addSubview(imgVwIconNoName)
        imgVwIconNoName.topAnchor.constraint(equalTo: vwVCHeaderOrangeTitle.topAnchor).isActive=true
        imgVwIconNoName.leadingAnchor.constraint(equalTo: vwVCHeaderOrangeTitle.centerXAnchor, constant: widthFromPct(percent: -35) ).isActive = true
        
        lblHeaderTitle.text = "Tu Rincón"
        lblHeaderTitle.font = UIFont(name: "Rockwell_tu", size: 35)
        vwVCHeaderOrangeTitle.addSubview(lblHeaderTitle)
        lblHeaderTitle.translatesAutoresizingMaskIntoConstraints=false
        lblHeaderTitle.leadingAnchor.constraint(equalTo: imgVwIconNoName.trailingAnchor, constant: widthFromPct(percent: 2.5)).isActive=true
        lblHeaderTitle.centerYAnchor.constraint(equalTo: vwVCHeaderOrangeTitle.centerYAnchor).isActive=true
        
    }
    func setup_vwBackgroundCard(){
        vwBackgroundCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vwBackgroundCard)
        vwBackgroundCard.backgroundColor = UIColor(named: "gray-500")
        vwBackgroundCard.topAnchor.constraint(equalTo: vwVCHeaderOrangeTitle.bottomAnchor, constant: heightFromPct(percent: 5)).isActive=true
        vwBackgroundCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: 5)).isActive=true
        vwBackgroundCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: -5)).isActive=true
        vwBackgroundCard.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 50)).isActive=true
        vwBackgroundCard.layer.cornerRadius = 10
    }
    func setup_lblTitle(){
        lblTitle.text = "Register"
        lblTitle.font = UIFont(name: "Rockwell_tu", size: 30)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lblTitle)
        lblTitle.topAnchor.constraint(equalTo: vwBackgroundCard.topAnchor, constant: heightFromPct(percent: 5)).isActive=true
        lblTitle.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor, constant: widthFromPct(percent: 2.5)).isActive=true
    }
}

