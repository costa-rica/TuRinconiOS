//
//  ViewController.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 17/07/2023.
//
// For github
import UIKit

class HomeVC: DefaultViewController {
    
    let vwVCHeaderOrange = UIView()
    let vwVCHeaderOrangeTitle = UIView()
    let imgVwIconNoName = UIImageView()
    let lblHeaderTitle = UILabel()
    
    let vwEtymologyBackground = UIView()
    let btnToLogin = UIButton()
    let btnToRegister = UIButton()
    
    let cardInteriorPadding = Float(5.0)
    let cardTopSpacing = Float(2.5)
    
    let safeAreaTopAdjustment = 40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_vwVCHeaderOrange()
        setup_vwVCHeaderOrangeTitle()
        setup_vwEtymology()
        setup_btnToRegister()
        setup_btnToLogin()
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        print("finished loading HomeVC")
        let computerName = ProcessInfo.processInfo.hostName
        print("Computer name: \(computerName)")
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
    }

    func setup_vwVCHeaderOrange(){
        view.addSubview(vwVCHeaderOrange)
        vwVCHeaderOrange.accessibilityIdentifier = "vwVCHeaderOrange"
        
        vwVCHeaderOrange.backgroundColor = UIColor(named: "orangePrimary")
        vwVCHeaderOrange.translatesAutoresizingMaskIntoConstraints = false
        vwVCHeaderOrange.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        vwVCHeaderOrange.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -safeAreaTopAdjustment).isActive = true
        vwVCHeaderOrange.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        vwVCHeaderOrange.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        vwVCHeaderOrange.heightAnchor.constraint(equalToConstant: safeAreaTopAdjustment).isActive=true
    }
    
    func setup_vwVCHeaderOrangeTitle(){
        view.addSubview(vwVCHeaderOrangeTitle)
        vwVCHeaderOrangeTitle.accessibilityIdentifier = "vwVCHeaderOrangeTitle"
        vwVCHeaderOrangeTitle.backgroundColor = UIColor(named: "orangePrimary")
//        vwVCHeaderOrangeTitle.backgroundColor = .purple
        vwVCHeaderOrangeTitle.translatesAutoresizingMaskIntoConstraints = false
//        vwVCHeaderOrangeTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -safeAreaTopAdjustment).isActive = true
        vwVCHeaderOrangeTitle.topAnchor.constraint(equalTo: vwVCHeaderOrange.bottomAnchor).isActive=true
        vwVCHeaderOrangeTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        vwVCHeaderOrangeTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        
        if let unwrapped_image = UIImage(named: "android-chrome-192x192") {
            imgVwIconNoName.image = unwrapped_image.scaleImage(toSize: CGSize(width: 20, height: 20))

            vwVCHeaderOrangeTitle.heightAnchor.constraint(equalToConstant: imgVwIconNoName.image!.size.height + 10).isActive=true
        }
        imgVwIconNoName.translatesAutoresizingMaskIntoConstraints = false
        vwVCHeaderOrangeTitle.addSubview(imgVwIconNoName)
        imgVwIconNoName.accessibilityIdentifier = "imgVwIconNoName"
        imgVwIconNoName.topAnchor.constraint(equalTo: vwVCHeaderOrangeTitle.topAnchor).isActive=true
        imgVwIconNoName.leadingAnchor.constraint(equalTo: vwVCHeaderOrangeTitle.centerXAnchor, constant: widthFromPct(percent: -35) ).isActive = true
        
        lblHeaderTitle.text = "Tu Rincón"
        lblHeaderTitle.font = UIFont(name: "Rockwell_tu", size: 35)
        vwVCHeaderOrangeTitle.addSubview(lblHeaderTitle)
        lblHeaderTitle.accessibilityIdentifier = "lblHeaderTitle"
        lblHeaderTitle.translatesAutoresizingMaskIntoConstraints=false
        lblHeaderTitle.leadingAnchor.constraint(equalTo: imgVwIconNoName.trailingAnchor, constant: widthFromPct(percent: 2.5)).isActive=true
        lblHeaderTitle.centerYAnchor.constraint(equalTo: vwVCHeaderOrangeTitle.centerYAnchor).isActive=true
        
    }
    
    func setup_vwEtymology(){
        
        vwEtymologyBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vwEtymologyBackground)
        vwEtymologyBackground.accessibilityIdentifier = "vwEtymologyBackground"
        vwEtymologyBackground.backgroundColor = UIColor(named: "gray-500")
        vwEtymologyBackground.topAnchor.constraint(equalTo: vwVCHeaderOrangeTitle.bottomAnchor, constant: heightFromPct(percent: cardTopSpacing)).isActive=true
        vwEtymologyBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
        vwEtymologyBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)).isActive=true
        vwEtymologyBackground.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 55)).isActive=true
        vwEtymologyBackground.layer.cornerRadius = 10
        
        let lblEtymologyTitle = UILabel()
        lblEtymologyTitle.text = "Rincón"
        lblEtymologyTitle.font = UIFont(name: "Rockwell_tu", size: 20)
        vwEtymologyBackground.addSubview(lblEtymologyTitle)
        lblEtymologyTitle.accessibilityIdentifier = "lblEtymologyTitle"
        lblEtymologyTitle.translatesAutoresizingMaskIntoConstraints=false
        lblEtymologyTitle.topAnchor.constraint(equalTo: vwEtymologyBackground.topAnchor, constant: heightFromPct(percent: 5)).isActive=true
        lblEtymologyTitle.leadingAnchor.constraint(equalTo: vwEtymologyBackground.leadingAnchor, constant: widthFromPct(percent: 5)).isActive=true
        
        let lblEtymology = UILabel()
        lblEtymology.text = "Etymology"
        lblEtymology.font = UIFont(name: "Rockwell-Bold_tu", size: 20)
        vwEtymologyBackground.addSubview(lblEtymology)
        lblEtymology.accessibilityIdentifier = "lblEtymology"
        lblEtymology.translatesAutoresizingMaskIntoConstraints=false
        lblEtymology.topAnchor.constraint(equalTo: lblEtymologyTitle.bottomAnchor, constant: heightFromPct(percent: 2.5)).isActive=true
        lblEtymology.leadingAnchor.constraint(equalTo: vwEtymologyBackground.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
        
        let imgVwLine01 = createDividerLine(thicknessOfLine: 2)
        vwEtymologyBackground.addSubview(imgVwLine01)
        imgVwLine01.translatesAutoresizingMaskIntoConstraints=false
        imgVwLine01.topAnchor.constraint(equalTo: lblEtymology.bottomAnchor, constant: heightFromPct(percent: 2.5)).isActive=true
        imgVwLine01.leadingAnchor.constraint(equalTo: vwEtymologyBackground.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
        imgVwLine01.trailingAnchor.constraint(equalTo: vwEtymologyBackground.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)).isActive=true
        
        
        let lblEtymologyDef = UILabel()
        lblEtymologyDef.text = "Spanish rincón, literally, corner, nook, alteration of recón, rencón from Arabic dialect (Spain) rukun (Arabic rukn)"
        lblEtymologyDef.numberOfLines=0
        lblEtymologyDef.lineBreakMode = .byWordWrapping
        lblEtymologyDef.font = UIFont(name: "Rockwell_tu", size: 20)
        vwEtymologyBackground.addSubview(lblEtymologyDef)
        lblEtymologyDef.translatesAutoresizingMaskIntoConstraints=false
        lblEtymologyDef.topAnchor.constraint(equalTo: imgVwLine01.bottomAnchor, constant: heightFromPct(percent: 2.5)).isActive=true
        lblEtymologyDef.leadingAnchor.constraint(equalTo: vwEtymologyBackground.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
        lblEtymologyDef.trailingAnchor.constraint(equalTo: vwEtymologyBackground.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)).isActive=true
        
        
        let lblFirstKnown = UILabel()
        lblFirstKnown.text = "First Known Use"
        lblFirstKnown.font = UIFont(name: "Rockwell-Bold_tu", size: 20)
        vwEtymologyBackground.addSubview(lblFirstKnown)
        lblFirstKnown.translatesAutoresizingMaskIntoConstraints=false
        lblFirstKnown.topAnchor.constraint(equalTo: lblEtymologyDef.bottomAnchor, constant: heightFromPct(percent: 5)).isActive=true
        lblFirstKnown.leadingAnchor.constraint(equalTo: vwEtymologyBackground.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
        
        let imgVwLine02 = createDividerLine(thicknessOfLine: 2)
        vwEtymologyBackground.addSubview(imgVwLine02)
        imgVwLine02.translatesAutoresizingMaskIntoConstraints=false
        imgVwLine02.topAnchor.constraint(equalTo: lblFirstKnown.bottomAnchor, constant: heightFromPct(percent: 2.5)).isActive=true
        imgVwLine02.leadingAnchor.constraint(equalTo: vwEtymologyBackground.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
        imgVwLine02.trailingAnchor.constraint(equalTo: vwEtymologyBackground.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)).isActive=true
        
        let lblDate = UILabel()
        lblDate.text = "1589"
        lblDate.font = UIFont(name: "Rockwell_tu", size: 20)
        vwEtymologyBackground.addSubview(lblDate)
        lblDate.translatesAutoresizingMaskIntoConstraints=false
        lblDate.topAnchor.constraint(equalTo: imgVwLine02.topAnchor, constant: heightFromPct(percent: 2.5)).isActive=true
        lblDate.leadingAnchor.constraint(equalTo: vwEtymologyBackground.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
    }
    
    func setup_btnToRegister(){
        
        btnToRegister.setTitle("Register", for: .normal)
        btnToRegister.titleLabel?.font = UIFont(name: "Rockwell_tu", size: 20)
        btnToRegister.backgroundColor = UIColor(named: "orangePrimary")
        

        
        btnToRegister.layer.cornerRadius = 10
        
        btnToRegister.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(btnToRegister)
        btnToRegister.topAnchor.constraint(equalTo: vwEtymologyBackground.bottomAnchor, constant: widthFromPct(percent: 5)).isActive=true
        btnToRegister.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: 5)).isActive=true
        btnToRegister.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: -5)).isActive=true
        
//        btnToRegister.addTarget(self, action: #selector(goToRegisterVC), for: .touchUpInside)
        
        btnToRegister.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btnToRegister.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
//        btnLogin.addTarget(self, action: #selector(touchDragExit(_:)), for: .touchDragExit)
//        btnLogin.addTarget(self, action: #selector(touchDragEnter(_:)), for: .touchDragEnter)

        
    }
//    @objc func goToRegisterVC(){
////        print("-goTo RegisterVC")
//        performSegue(withIdentifier: "goToRegisterVC", sender: self)
//
//    }
    
    func setup_btnToLogin(){
        btnToLogin.setTitle("Login", for: .normal)
        btnToLogin.titleLabel?.font = UIFont(name: "Rockwell_tu", size: 20)
//        btnToLogin.backgroundColor = UIColor(named: "orangePrimary")
        btnToLogin.setTitleColor(UIColor(named: "orangePrimary"), for: .normal)
        btnToLogin.layer.borderColor = UIColor(named: "orangePrimary")?.cgColor
        btnToLogin.layer.cornerRadius = 10
        btnToLogin.layer.borderWidth = 2
        btnToLogin.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(btnToLogin)
        btnToLogin.topAnchor.constraint(equalTo: btnToRegister.bottomAnchor, constant: widthFromPct(percent: 5)).isActive=true
        btnToLogin.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: 5)).isActive=true
        btnToLogin.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: -5)).isActive=true
        
//        btnToLogin.addTarget(self, action: #selector(goToLoginVC), for: .touchUpInside)
        
        btnToLogin.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btnToLogin.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
//        btnLogin.addTarget(self, action: #selector(touchDragExit(_:)), for: .touchDragExit)
//        btnLogin.addTarget(self, action: #selector(touchDragEnter(_:)), for: .touchDragEnter)

        
    }
    
    @objc func touchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)

    }

    @objc func touchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        if sender === btnToRegister {
            print("btnToRegister")
            performSegue(withIdentifier: "goToRegisterVC", sender: self)
        } else if sender === btnToLogin {
            print("btnToLogin")
            performSegue(withIdentifier: "goToLoginVC", sender: self)
        }
    }

    
    
//    @objc func goToLoginVC(){
//
//        print("-goTo LoginVC")
//        performSegue(withIdentifier: "goToLoginVC", sender: self)
//
//    }
    


}

