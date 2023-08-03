//
//  AdminVC.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 23/07/2023.
//

import UIKit

class AdminVC: DefaultViewController{
    
    var userStore: UserStore!
//    var user: User!
    var urlStore: URLStore!
    var rinconStore: RinconStore!
    
    let vwVCHeaderOrange = UIView()
    let vwVCHeaderOrangeTitle = UIView()
    let imgVwIconNoName = UIImageView()
    let lblHeaderTitle = UILabel()
    
    let vwBackgroundCard = UIView()
    private var scrllVwAdmin: UIScrollView!
    private var stckVwAdmin: UIStackView!
    let lblTitle = UILabel()
    let cardInteriorPadding = Float(5.0)
    let screenWidth = UIScreen.main.bounds.width
    
    var stckVwLatestPostId:UIStackView?
    var lblLatestPostIdTitle:UILabel!
    
    var arryRinconDirs:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_vwVCHeaderOrange()
        setup_vwVCHeaderOrangeTitle()
        setup_vwBackgroundCard()
        setup_lblTitle()
        setup_stckVwAdmin()
        setup_latestPostCall()
        setup_otherBtns()
        
        
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
        vwBackgroundCard.accessibilityIdentifier="vwBackgroundCard"
        vwBackgroundCard.backgroundColor = UIColor(named: "gray-500")
        vwBackgroundCard.topAnchor.constraint(equalTo: vwVCHeaderOrangeTitle.bottomAnchor, constant: heightFromPct(percent: 5)).isActive=true
        vwBackgroundCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: 5)).isActive=true
        vwBackgroundCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: -5)).isActive=true
        vwBackgroundCard.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: heightFromPct(percent: -10)).isActive=true
        vwBackgroundCard.layer.cornerRadius = 10
    }
    func setup_lblTitle(){
        lblTitle.text = "Developer Info"
        lblTitle.font = UIFont(name: "Rockwell_tu", size: 30)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.accessibilityIdentifier="lblTitle"
        vwBackgroundCard.addSubview(lblTitle)
        lblTitle.topAnchor.constraint(equalTo: vwBackgroundCard.topAnchor, constant: heightFromPct(percent: cardInteriorPadding)).isActive=true
        lblTitle.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor, constant: widthFromPct(percent: 2.5)).isActive=true
    }
    
    func setup_stckVwAdmin(){
        scrllVwAdmin = UIScrollView()
        scrllVwAdmin.translatesAutoresizingMaskIntoConstraints = false
        vwBackgroundCard.addSubview(scrllVwAdmin)
        scrllVwAdmin.accessibilityIdentifier="scrllVwAdmin"
        
        scrllVwAdmin.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: heightFromPct(percent: 5)).isActive=true
        scrllVwAdmin.trailingAnchor.constraint(equalTo: vwBackgroundCard.trailingAnchor).isActive=true
        scrllVwAdmin.bottomAnchor.constraint(equalTo: vwBackgroundCard.bottomAnchor).isActive=true
        scrllVwAdmin.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor).isActive=true
        
        stckVwAdmin = UIStackView()
        stckVwAdmin.translatesAutoresizingMaskIntoConstraints=false
        scrllVwAdmin.addSubview(stckVwAdmin)
        scrllVwAdmin.accessibilityIdentifier = "scrllVwAdmin"
        stckVwAdmin.axis = .vertical
        stckVwAdmin.topAnchor.constraint(equalTo: scrllVwAdmin.topAnchor).isActive=true
        stckVwAdmin.leadingAnchor.constraint(equalTo: scrllVwAdmin.leadingAnchor).isActive=true
        stckVwAdmin.trailingAnchor.constraint(equalTo: scrllVwAdmin.trailingAnchor).isActive=true
        stckVwAdmin.bottomAnchor.constraint(equalTo: scrllVwAdmin.bottomAnchor).isActive=true

    }
    
    func setup_latestPostCall(){
        stckVwLatestPostId = UIStackView()
        stckVwLatestPostId!.translatesAutoresizingMaskIntoConstraints=false
        stckVwLatestPostId!.axis = .vertical
        stckVwAdmin.addArrangedSubview(stckVwLatestPostId!)

        
        lblLatestPostIdTitle = UILabel()
        lblLatestPostIdTitle.text = "Latest Post?"
        lblLatestPostIdTitle.translatesAutoresizingMaskIntoConstraints = false
        stckVwLatestPostId!.addArrangedSubview(lblLatestPostIdTitle)
        lblLatestPostIdTitle.widthAnchor.constraint(equalTo: vwBackgroundCard.widthAnchor).isActive=true
        lblLatestPostIdTitle.textAlignment = .center
        
        
        let btnCallLatestPostApi = UIButton()
        btnCallLatestPostApi.setTitle("Call for latest Post ID", for: .normal)
//        btnCallLatestPostApi.layer.borderColor = UIColor(named: "orangePrimary")?.cgColor
        btnCallLatestPostApi.layer.borderColor = .init(gray: 0.5, alpha: 1.0)
        btnCallLatestPostApi.layer.borderWidth = 2
        btnCallLatestPostApi.setTitleColor(.black, for: .normal)
        btnCallLatestPostApi.layer.cornerRadius = 10
        btnCallLatestPostApi.translatesAutoresizingMaskIntoConstraints = false
        stckVwLatestPostId!.addArrangedSubview(btnCallLatestPostApi)
        btnCallLatestPostApi.widthAnchor.constraint(equalTo: stckVwLatestPostId!.widthAnchor).isActive=true

        
        btnCallLatestPostApi.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btnCallLatestPostApi.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
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
        rinconStore.getLastPostId { jsonDict in
            print("-called for last post id")
            print(jsonDict)
            self.lblLatestPostIdTitle.text = jsonDict["last_post_id"]
            self.lblLatestPostIdTitle.backgroundColor = .cyan
            self.lblLatestPostIdTitle.layer.masksToBounds = true
            self.lblLatestPostIdTitle.layer.cornerRadius = 10
            self.lblLatestPostIdTitle.textAlignment = .center
        }
    }
    
    
    func setup_otherBtns(){
        print("- setup_otherBtns -")

        
        
        let stckSpacer01 = UIView()
        stckSpacer01.backgroundColor = UIColor(named: "gray-500")
        stckSpacer01.translatesAutoresizingMaskIntoConstraints=false
        stckSpacer01.accessibilityIdentifier="stckSpacer01"
        stckVwAdmin.addArrangedSubview(stckSpacer01)
        stckSpacer01.widthAnchor.constraint(equalTo: vwBackgroundCard.widthAnchor).isActive=true
        stckSpacer01.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 1)).isActive=true
        
        
        let lineDivider01 = createDividerLine(thicknessOfLine: 2.0)
        lineDivider01.translatesAutoresizingMaskIntoConstraints=false
        stckVwAdmin.addArrangedSubview(lineDivider01)
        
        let stckSpacer02 = UIView()
        stckSpacer02.backgroundColor = UIColor(named: "gray-500")
        stckSpacer02.translatesAutoresizingMaskIntoConstraints=false
        stckVwAdmin.addArrangedSubview(stckSpacer02)
        stckSpacer02.widthAnchor.constraint(equalTo: vwBackgroundCard.widthAnchor).isActive=true
        stckSpacer02.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 1)).isActive=true
        
        let bigLabel = UILabel()
        bigLabel.text = "View Rincon Files"
        bigLabel.font = UIFont(name: "Rockwell_tu", size: 20)
        bigLabel.translatesAutoresizingMaskIntoConstraints=false
        bigLabel.accessibilityIdentifier="bigLabel"
        stckVwAdmin.addArrangedSubview(bigLabel)
        bigLabel.widthAnchor.constraint(equalTo: vwBackgroundCard.widthAnchor).isActive=true
        
        let btnDocumentsDir = UIButton()
        btnDocumentsDir.setTitle("See Documents Dir", for: .normal)
        btnDocumentsDir.layer.borderColor = .init(gray: 0.5, alpha: 1.0)
        btnDocumentsDir.layer.borderWidth = 2
        btnDocumentsDir.setTitleColor(.black, for: .normal)
        btnDocumentsDir.layer.cornerRadius = 10
        
        btnDocumentsDir.translatesAutoresizingMaskIntoConstraints=false
        stckVwAdmin.addArrangedSubview(btnDocumentsDir)

        btnDocumentsDir.addTarget(self, action: #selector(touchDownBtnDocumentsDir(_:)), for: .touchDown)
        btnDocumentsDir.addTarget(self, action: #selector(touchUpInsideBtnDocumentsDir(_:)), for: .touchUpInside)
        
    }
    

    
    @objc func touchDownBtnDocumentsDir(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }

    @objc func touchUpInsideBtnDocumentsDir(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        arryRinconDirs = getDirectoriesInDocumentsDirectory()
        print(arryRinconDirs!)
        performSegue(withIdentifier: "goToRinconsDirectoriesVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToRinconsDirectoriesVC") {
            let rinconsDirectriesVc = segue.destination as! RinconsDirectoriesVC
            rinconsDirectriesVc.arryRinconDirs = arryRinconDirs

        }
    }
}
