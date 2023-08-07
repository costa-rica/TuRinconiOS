//
//  ViewController.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 17/07/2023.
//
// For github
import UIKit

class HomeVC: DefaultViewController {
    
    var userStore: UserStore!
    var user: User?
    var urlStore: URLStore!
    var rinconStore: RinconStore!
    
    let vwVCHeaderOrange = UIView()
    let vwVCHeaderOrangeTitle = UIView()
    let imgVwIconNoName = UIImageView()
    let lblHeaderTitle = UILabel()
    
    let vwEtymologyBackground = UIView()

    
    let cardInteriorPadding = Float(5.0)
    let cardTopSpacing = Float(2.5)
    
    let safeAreaTopAdjustment = 40.0
    
    private var scrllVwHome=UIScrollView()
    private var stckVwHome=UIStackView()
    let btnToLogin = UIButton()
    let btnToRegister = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userStore = UserStore()
        urlStore = URLStore()
        urlStore.baseString = "https://dev.api.tu-rincon.com/"
        userStore.urlStore = self.urlStore
        rinconStore = RinconStore()
        rinconStore.requestStore = RequestStore()
        rinconStore.requestStore.urlStore = self.urlStore
        
        
        setup_vwVCHeaderOrange()
        setup_vwVCHeaderOrangeTitle()
        setup_stckVwHome()
        setup_vwEtymology()
        
//        setup_btnToRegister()
//        setup_btnToLogin()
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
    
    func setup_stckVwHome(){
        print("- setup_stckVwHome")
        scrllVwHome.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(scrllVwHome)
        scrllVwHome.accessibilityIdentifier="scrllVwHome"
        
        scrllVwHome.topAnchor.constraint(equalTo: vwVCHeaderOrangeTitle.bottomAnchor, constant: heightFromPct(percent: cardTopSpacing)).isActive=true
        scrllVwHome.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
        scrllVwHome.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)).isActive=true
//        scrllVwAdmin.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        scrllVwHome.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: heightFromPct(percent: -10)).isActive=true
        
//        scrllVwAdmin.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor).isActive=true
        
        view.layoutIfNeeded()
        print("scrllVwHome width: \(scrllVwHome.frame.size)")
        
        stckVwHome.translatesAutoresizingMaskIntoConstraints=false
        scrllVwHome.addSubview(stckVwHome)
        stckVwHome.accessibilityIdentifier = "stckVwHome"
        stckVwHome.axis = .vertical
        stckVwHome.topAnchor.constraint(equalTo: scrllVwHome.topAnchor).isActive=true
        stckVwHome.widthAnchor.constraint(equalToConstant: scrllVwHome.frame.size.width).isActive=true
//        stckVwHome.leadingAnchor.constraint(equalTo: scrllVwHome.leadingAnchor).isActive=true
//        stckVwHome.trailingAnchor.constraint(equalTo: scrllVwHome.trailingAnchor).isActive=true
        stckVwHome.bottomAnchor.constraint(equalTo: scrllVwHome.bottomAnchor).isActive=true
//        stckVwHome.backgroundColor = .black
        stckVwHome.spacing = 20
        setup_btnToRegister()
        setup_btnToLogin()
        setup_pickerApi()
    }
    
    func setup_vwEtymology(){

        
        vwEtymologyBackground.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(vwEtymologyBackground)
        stckVwHome.insertArrangedSubview(vwEtymologyBackground, at: 0)
        vwEtymologyBackground.accessibilityIdentifier = "vwEtymologyBackground"
        vwEtymologyBackground.backgroundColor = UIColor(named: "gray-500")
//        vwEtymologyBackground.topAnchor.constraint(equalTo: vwVCHeaderOrangeTitle.bottomAnchor, constant: heightFromPct(percent: cardTopSpacing)).isActive=true
//        vwEtymologyBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
//        vwEtymologyBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)).isActive=true
//        vwEtymologyBackground.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 52)).isActive=true
        vwEtymologyBackground.layer.cornerRadius = 10
        
        let stckVwEtymologyBackground = UIStackView()
        stckVwEtymologyBackground.axis = .vertical
        stckVwEtymologyBackground.spacing = 10
        stckVwEtymologyBackground.translatesAutoresizingMaskIntoConstraints = false
        vwEtymologyBackground.addSubview(stckVwEtymologyBackground)
        stckVwEtymologyBackground.topAnchor.constraint(equalTo: vwEtymologyBackground.topAnchor, constant: heightFromPct(percent: 5)).isActive=true
        stckVwEtymologyBackground.leadingAnchor.constraint(equalTo: vwEtymologyBackground.leadingAnchor, constant: widthFromPct(percent: 5)).isActive=true
        stckVwEtymologyBackground.trailingAnchor.constraint(equalTo: vwEtymologyBackground.trailingAnchor, constant: widthFromPct(percent: -5)).isActive=true
        stckVwEtymologyBackground.bottomAnchor.constraint(equalTo: vwEtymologyBackground.bottomAnchor, constant: heightFromPct(percent: -5)).isActive=true
        
        
        let lblEtymologyTitle = UILabel()
        lblEtymologyTitle.text = "Rincón"
        lblEtymologyTitle.font = UIFont(name: "Rockwell_tu", size: 20)
//        vwEtymologyBackground.addSubview(lblEtymologyTitle)
        stckVwEtymologyBackground.addArrangedSubview(lblEtymologyTitle)
        lblEtymologyTitle.accessibilityIdentifier = "lblEtymologyTitle"
        lblEtymologyTitle.translatesAutoresizingMaskIntoConstraints=false
//        lblEtymologyTitle.topAnchor.constraint(equalTo: vwEtymologyBackground.topAnchor, constant: heightFromPct(percent: 2.5)).isActive=true
//        lblEtymologyTitle.leadingAnchor.constraint(equalTo: vwEtymologyBackground.leadingAnchor, constant: widthFromPct(percent: 5)).isActive=true
        
        let lblEtymology = UILabel()
        lblEtymology.text = "Etymology"
        lblEtymology.font = UIFont(name: "Rockwell-Bold_tu", size: 20)
//        vwEtymologyBackground.addSubview(lblEtymology)
        stckVwEtymologyBackground.addArrangedSubview(lblEtymology)
        lblEtymology.accessibilityIdentifier = "lblEtymology"
        lblEtymology.translatesAutoresizingMaskIntoConstraints=false
//        lblEtymology.topAnchor.constraint(equalTo: lblEtymologyTitle.bottomAnchor, constant: heightFromPct(percent: 2.5)).isActive=true
//        lblEtymology.leadingAnchor.constraint(equalTo: vwEtymologyBackground.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
        
        
        let imgVwLine01 = createDividerLine(thicknessOfLine: 2)
//        vwEtymologyBackground.addSubview(imgVwLine01)
        stckVwEtymologyBackground.addArrangedSubview(imgVwLine01)
        imgVwLine01.translatesAutoresizingMaskIntoConstraints=false
        imgVwLine01.topAnchor.constraint(equalTo: lblEtymology.bottomAnchor, constant: heightFromPct(percent: 2.5)).isActive=true
//        imgVwLine01.leadingAnchor.constraint(equalTo: vwEtymologyBackground.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
//        imgVwLine01.trailingAnchor.constraint(equalTo: vwEtymologyBackground.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)).isActive=true
        
        
        let lblEtymologyDef = UILabel()
        lblEtymologyDef.text = "Spanish rincón, literally, corner, nook, alteration of recón, rencón from Arabic dialect (Spain) rukun (Arabic rukn)"
        lblEtymologyDef.numberOfLines=0
        lblEtymologyDef.lineBreakMode = .byWordWrapping
        lblEtymologyDef.font = UIFont(name: "Rockwell_tu", size: 20)
//        vwEtymologyBackground.addSubview(lblEtymologyDef)
        stckVwEtymologyBackground.addArrangedSubview(lblEtymologyDef)
        lblEtymologyDef.translatesAutoresizingMaskIntoConstraints=false
//        lblEtymologyDef.topAnchor.constraint(equalTo: imgVwLine01.bottomAnchor, constant: heightFromPct(percent: 2.5)).isActive=true
//        lblEtymologyDef.leadingAnchor.constraint(equalTo: vwEtymologyBackground.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
//        lblEtymologyDef.trailingAnchor.constraint(equalTo: vwEtymologyBackground.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)).isActive=true
        
        
        let lblFirstKnown = UILabel()
        lblFirstKnown.text = "First Known Use"
        lblFirstKnown.font = UIFont(name: "Rockwell-Bold_tu", size: 20)
//        vwEtymologyBackground.addSubview(lblFirstKnown)
        stckVwEtymologyBackground.addArrangedSubview(lblFirstKnown)
        lblFirstKnown.translatesAutoresizingMaskIntoConstraints=false
//        lblFirstKnown.topAnchor.constraint(equalTo: lblEtymologyDef.bottomAnchor, constant: heightFromPct(percent: 5)).isActive=true
//        lblFirstKnown.leadingAnchor.constraint(equalTo: vwEtymologyBackground.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
        
        let imgVwLine02 = createDividerLine(thicknessOfLine: 2)
//        vwEtymologyBackground.addSubview(imgVwLine02)
        stckVwEtymologyBackground.addArrangedSubview(imgVwLine02)
        imgVwLine02.translatesAutoresizingMaskIntoConstraints=false
//        imgVwLine02.topAnchor.constraint(equalTo: lblFirstKnown.bottomAnchor, constant: heightFromPct(percent: 2.5)).isActive=true
//        imgVwLine02.leadingAnchor.constraint(equalTo: vwEtymologyBackground.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
//        imgVwLine02.trailingAnchor.constraint(equalTo: vwEtymologyBackground.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)).isActive=true
        
        let lblDate = UILabel()
        lblDate.text = "1589"
        lblDate.font = UIFont(name: "Rockwell_tu", size: 20)
//        vwEtymologyBackground.addSubview(lblDate)
        stckVwEtymologyBackground.addArrangedSubview(lblDate)
        lblDate.translatesAutoresizingMaskIntoConstraints=false
//        lblDate.topAnchor.constraint(equalTo: imgVwLine02.topAnchor, constant: heightFromPct(percent: 2.5)).isActive=true
//        lblDate.leadingAnchor.constraint(equalTo: vwEtymologyBackground.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
    }
    
    
    
    func setup_btnToRegister(){
        
        btnToRegister.setTitle("Register", for: .normal)
        btnToRegister.titleLabel?.font = UIFont(name: "Rockwell_tu", size: 20)
        btnToRegister.backgroundColor = UIColor(named: "orangePrimary")
                
        btnToRegister.layer.cornerRadius = 10
        
        btnToRegister.translatesAutoresizingMaskIntoConstraints=false
        stckVwHome.addArrangedSubview(btnToRegister)
        btnToRegister.sizeToFit()

//        print("btnToRegister.size: \(btnToRegister.frame.size)")
        btnToRegister.heightAnchor.constraint(equalToConstant: btnToRegister.frame.size.height + 30).isActive=true
//        view.addSubview(btnToRegister)
//        btnToRegister.topAnchor.constraint(equalTo: vwEtymologyBackground.bottomAnchor, constant: widthFromPct(percent: 5)).isActive=true
//        btnToRegister.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: 5)).isActive=true
//        btnToRegister.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: -5)).isActive=true
                
        btnToRegister.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btnToRegister.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)


        
    }

    func setup_btnToLogin(){
        btnToLogin.setTitle("Login", for: .normal)
        btnToLogin.titleLabel?.font = UIFont(name: "Rockwell_tu", size: 20)
//        btnToLogin.backgroundColor = UIColor(named: "orangePrimary")
        btnToLogin.setTitleColor(UIColor(named: "orangePrimary"), for: .normal)
        btnToLogin.layer.borderColor = UIColor(named: "orangePrimary")?.cgColor
        btnToLogin.layer.cornerRadius = 10
        btnToLogin.layer.borderWidth = 2
        btnToLogin.translatesAutoresizingMaskIntoConstraints=false
        stckVwHome.addArrangedSubview(btnToLogin)
        btnToLogin.sizeToFit()
        btnToLogin.heightAnchor.constraint(equalToConstant: btnToLogin.frame.size.height + 30).isActive=true
//        view.addSubview(btnToLogin)
//        btnToLogin.topAnchor.constraint(equalTo: btnToRegister.bottomAnchor, constant: widthFromPct(percent: 5)).isActive=true
//        btnToLogin.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: 5)).isActive=true
//        btnToLogin.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: -5)).isActive=true
        
//        btnToLogin.addTarget(self, action: #selector(goToLoginVC), for: .touchUpInside)
        
        btnToLogin.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btnToLogin.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)

        
    }
    
    func setup_pickerApi(){
        let btnToWebsite = UIButton(type: .system)
//        btnToWebsite.frame = CGRect(x: 20, y: 100, width: 300, height: 50)
        btnToWebsite.setTitle("Tu Rincón Website", for: .normal)
        btnToWebsite.addTarget(self, action: #selector(goToWebsite), for: .touchUpInside)
//        if let unwp_font = UIFont(name: "Rockwell_tu", size: 20) {
        btnToWebsite.titleLabel?.font = UIFont(name: "Rockwell_tu", size: 20)
//        }
        stckVwHome.addArrangedSubview(btnToWebsite)
        
        
        let stckVwApi = UIStackView()
        stckVwApi.translatesAutoresizingMaskIntoConstraints=false
        stckVwApi.axis = .vertical
        stckVwHome.addArrangedSubview(stckVwApi)
        
        
        let lblApi = UILabel()
        lblApi.text = "Which Api?:"
        lblApi.translatesAutoresizingMaskIntoConstraints=false
        stckVwApi.addArrangedSubview(lblApi)
        lblApi.sizeToFit()
        print("lblApi.frame.size: \(lblApi.frame.size)")
        stckVwApi.heightAnchor.constraint(equalToConstant: lblApi.frame.size.height + 40).isActive=true
//        lblApi.textAlignment = .
        
        
        urlStore.baseString = "http://127.0.0.1:5001/"
        let indexDict = ["http://127.0.0.1:5001/":0,"https://dev.api.tu-rincon.com/":1,"https://api.tu-rincon.com/":2]
        
        let segmentedControl = UISegmentedControl(items: Environment.allCases.map { $0.rawValue })
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        // Set initial selected segment
        segmentedControl.selectedSegmentIndex = indexDict[urlStore.baseString] ?? 0
        stckVwApi.addArrangedSubview(segmentedControl)
        

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
    
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedEnvironment = Environment.allCases[sender.selectedSegmentIndex]
        urlStore.baseString = selectedEnvironment.baseString
    }
    
    @objc func goToWebsite() {
        guard let url = URL(string: "https://tu-rincon.com") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToLoginVC"){
            let loginVC = segue.destination as! LoginVC
            loginVC.userStore = self.userStore
            loginVC.urlStore = self.urlStore
            loginVC.rinconStore = self.rinconStore

            
        }   else if (segue.identifier == "goToRegisterVC"){
            let RegisterVC = segue.destination as! RegisterVC
            RegisterVC.userStore = self.userStore

        }
    }


}

