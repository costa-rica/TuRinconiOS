//
//  RegisterVC.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 17/07/2023.
//

import UIKit

class RegisterVC: DefaultViewController{
    var userStore:UserStore!
    var rinconStore:RinconStore!
    
    let vwVCHeaderOrange = UIView()
    let vwVCHeaderOrangeTitle = UIView()
    let imgVwIconNoName = UIImageView()
    let lblHeaderTitle = UILabel()
    let vwBackgroundCard = UIView()
    let lblTitle = UILabel()
    
    let stckVwLogin = UIStackView()
    let stckVwEmailRow = UIStackView()
    let stckVwPasswordRow = UIStackView()
    let stckVwAdmin = UIStackView()
    
    let lblEmail = UILabel()
    let txtEmail = UITextField()
    let lblPassword = UILabel()
    let txtPassword = UITextField()
    let btnShowPassword = UIButton()
    
    let cardInteriorPadding = Float(5.0)
    let screenWidth = UIScreen.main.bounds.width
    
    var btnRegister=UIButton()
    var lblWarning: UILabel!
    
    var registerSuccessMessage = "Succesfully Registered!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        userStore=UserStore()
        //        userStore.urlStore = URLStore()
        setup_vwVCHeaderOrange()
        setup_vwVCHeaderOrangeTitle()
        setup_vwBackgroundCard()
        
        setup_stckVwLogin()
        setup_lblWarning()
        setup_lblTitle()
        setup_stckVwLoginContents()
        setup_btnRegister()
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
    
    
    func setup_stckVwLogin(){
        stckVwLogin.translatesAutoresizingMaskIntoConstraints = false
        stckVwLogin.spacing = 10
        view.addSubview(stckVwLogin)
        stckVwLogin.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor,constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
        stckVwLogin.trailingAnchor.constraint(equalTo: vwBackgroundCard.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)).isActive=true
        //        stckVwLogin.topAnchor.constraint(equalTo: vwBackgroundCard.topAnchor, constant: heightFromPct(percent: cardInteriorPadding)).isActive=true
        stckVwLogin.topAnchor.constraint(equalTo: vwBackgroundCard.topAnchor, constant: heightFromPct(percent: 1)).isActive=true
    }
    
    func setup_lblWarning(){
        lblWarning = UILabel()
        lblWarning.text = "Warning"
        lblWarning.textColor = .clear
        lblWarning.font = UIFont(name: "Rockwell_tu", size: 20)
        lblWarning.translatesAutoresizingMaskIntoConstraints = false
        stckVwLogin.addArrangedSubview(lblWarning)
    }
    
    func setup_lblTitle(){
        lblTitle.text = "Register"
        lblTitle.font = UIFont(name: "Rockwell_tu", size: 30)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        stckVwLogin.addArrangedSubview(lblTitle)
        //        lblTitle.topAnchor.constraint(equalTo: vwBackgroundCard.topAnchor, constant: heightFromPct(percent: 5)).isActive=true
        //        lblTitle.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor, constant: widthFromPct(percent: 2.5)).isActive=true
    }
    
    func setup_stckVwLoginContents(){
        lblEmail.text = "Email"
        lblPassword.text = "Password"
        
        stckVwEmailRow.translatesAutoresizingMaskIntoConstraints = false
        stckVwPasswordRow.translatesAutoresizingMaskIntoConstraints = false
        txtEmail.translatesAutoresizingMaskIntoConstraints = false
        txtPassword.translatesAutoresizingMaskIntoConstraints = false
        lblEmail.translatesAutoresizingMaskIntoConstraints = false
        lblPassword.translatesAutoresizingMaskIntoConstraints = false
        
        txtPassword.isSecureTextEntry = true
        btnShowPassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        btnShowPassword.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        stckVwEmailRow.addArrangedSubview(lblEmail)
        stckVwEmailRow.addArrangedSubview(txtEmail)
        
        stckVwPasswordRow.addArrangedSubview(lblPassword)
        stckVwPasswordRow.addArrangedSubview(txtPassword)
        stckVwPasswordRow.addArrangedSubview(btnShowPassword)
        
        stckVwLogin.addArrangedSubview(stckVwEmailRow)
        stckVwLogin.addArrangedSubview(stckVwPasswordRow)
        
        stckVwLogin.axis = .vertical
        stckVwEmailRow.axis = .horizontal
        stckVwPasswordRow.axis = .horizontal
        
        stckVwLogin.spacing = 5
        stckVwEmailRow.spacing = 2
        stckVwPasswordRow.spacing = 2
        
        txtEmail.borderStyle = .roundedRect
        txtPassword.borderStyle = .roundedRect
        
        //        view.addSubview(stckVwLogin)
        //
        //        NSLayoutConstraint.activate([
        //            stckVwLogin.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor,constant: widthFromPct(percent: cardInteriorPadding)),
        //            stckVwLogin.trailingAnchor.constraint(equalTo: vwBackgroundCard.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)),
        //            stckVwLogin.topAnchor.constraint(equalTo: lblTitle.topAnchor, constant: heightFromPct(percent: cardInteriorPadding)),
        //
        lblEmail.widthAnchor.constraint(equalTo: lblPassword.widthAnchor).isActive=true
        //        ])
        
        view.layoutIfNeeded()// <-- Realizes size of lblPassword and stckVwLogin
        
        // This code makes the widths of lblPassword and btnShowPassword take lower precedence than txtPassword.
        lblPassword.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        btnShowPassword.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    
    @objc func togglePasswordVisibility() {
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
        let imageName = txtPassword.isSecureTextEntry ? "eye.slash" : "eye"
        btnShowPassword.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func setup_btnRegister(){
        btnRegister.setTitle("Register", for: .normal)
        btnRegister.layer.borderColor = UIColor(named: "orangePrimary")?.cgColor
        btnRegister.layer.borderWidth = 2
        btnRegister.setTitleColor(.black, for: .normal)
        btnRegister.layer.cornerRadius = 10
        btnRegister.translatesAutoresizingMaskIntoConstraints = false
        stckVwLogin.addArrangedSubview(btnRegister)
        
        btnRegister.addTarget(self, action: #selector(touchDownRegister(_:)), for: .touchDown)
        btnRegister.addTarget(self, action: #selector(touchUpInsideRegister(_:)), for: .touchUpInside)
        
    }
    @objc func touchDownRegister(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    @objc func touchUpInsideRegister(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        requestRegister()
    }
    
    func requestRegister(){
        print("- RegisterVC: requestRegister()")
        
        userStore.registerNewUser(email: txtEmail.text!, password: txtPassword.text!) { userRegDict in
            if let _ = userRegDict["existing_emails"] as? [String]{
                print("--- email already exists ---")
                self.lblWarning.text = "* This email already exists *"
                self.lblWarning.numberOfLines = 0
                self.lblWarning.textColor = .black
                self.lblWarning.textAlignment = .center
                self.lblWarning.backgroundColor = UIColor(named: "redDelete")
                self.lblWarning.layer.cornerRadius = 10
            }
            else if let _ = userRegDict["id"] as? String{
                print("- RegisterVC: successfully added user")
                print("\(userRegDict["username"]!)")
                self.registerSuccessMessage = "Succesfully Registered!"
                self.alertConfirmRegister()
                self.rinconStore.checkInviteJson()

            }
            else {
                print("--- Fail of some sort ---")
            }
        }
    }
    
    func alertConfirmRegister() {
        // Create an alert
        let alert = UIAlertController(title: nil, message: registerSuccessMessage, preferredStyle: .alert)
        
        // Create an OK button
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Dismiss the alert when the OK button is tapped
            alert.dismiss(animated: true, completion: nil)
            // Go back to HomeVC
            self.navigationController?.popViewController(animated: true)
        }
        
        // Add the OK button to the alert
        alert.addAction(okAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}

