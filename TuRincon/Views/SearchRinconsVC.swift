//
//  SearchRinconsVC.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 03/08/2023.
//

import UIKit

class SearchRinconsVC:DefaultViewController, SearchRinconVCDelegate{
    
    var rinconStore:RinconStore!
    
    let vwVCHeaderOrange = UIView()
    let lblTitle = UILabel()
    var stckVwYourRincons=UIStackView()
    
    var tblRincons = UITableView()
    let backgroundColor = UIColor(named: "gray-300")?.cgColor
    let vwBackgroundCard = UIView()
    let cardInteriorPadding = Float(5.0)
    
    var arryRincons: [Rincon]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("-Entered SearchRinconsVC")
        print("arrayRinons.coount: \(arryRincons.count)")
        
        tblRincons.delegate = self
        tblRincons.dataSource = self
        // Register a UITableViewCell
        tblRincons.register(RinconRow.self, forCellReuseIdentifier: "RinconRow")
//        tblRincons.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tblRincons.rowHeight = UITableView.automaticDimension
        tblRincons.estimatedRowHeight = 30 // Provide an estimate here
        
        setup_vwVCHeaderOrange()
        setup_vwBackgroundCard()
        setup_stckVwYourRincons()
        setup_lblTitle()
        setup_tblRincons()
//        setup_testLabel()
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
    
    func setup_stckVwYourRincons(){
        stckVwYourRincons.translatesAutoresizingMaskIntoConstraints = false
        stckVwYourRincons.spacing = 10
        stckVwYourRincons.axis = .vertical
        view.addSubview(stckVwYourRincons)
        stckVwYourRincons.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor,constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
        stckVwYourRincons.trailingAnchor.constraint(equalTo: vwBackgroundCard.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)).isActive=true

        stckVwYourRincons.topAnchor.constraint(equalTo: vwBackgroundCard.topAnchor, constant: heightFromPct(percent: 1)).isActive=true
        view.layoutIfNeeded()
    }
    
    func setup_lblTitle(){
        lblTitle.text = "Find a Rincón:"
        lblTitle.font = UIFont(name: "Rockwell_tu", size: 30)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.accessibilityIdentifier="lblTitle"
        stckVwYourRincons.addArrangedSubview(lblTitle)

    }
    func setup_tblRincons(){
        print("* steup tblRincons")
        tblRincons.translatesAutoresizingMaskIntoConstraints=false
        tblRincons.widthAnchor.constraint(equalToConstant: stckVwYourRincons.frame.size.width).isActive=true
        tblRincons.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 50)).isActive=true
//        tblRincons.backgroundColor = UIColor(named: "gray-400")
        stckVwYourRincons.addArrangedSubview(tblRincons)
    }
    
    func setup_testLabel(){
        let lblTest = UILabel()
        lblTest.text = "Testing this out"
        lblTest.translatesAutoresizingMaskIntoConstraints=false
        stckVwYourRincons.addArrangedSubview(lblTest)
    }
    
//    func alertUpdate(message: String){
//
//    }
    
    @objc func rinconAlert(message: String) {
        // Create an alert
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        // Create an OK button
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Dismiss the alert when the OK button is tapped
            alert.dismiss(animated: true, completion: nil)
        }
        
        // Add the OK button to the alert
        alert.addAction(okAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension SearchRinconsVC: UITableViewDelegate{
    
}

extension SearchRinconsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("arryRincons.count: \(arryRincons.count)")
        return arryRincons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("** cellForRowAt ")
        let cell = tableView.dequeueReusableCell(withIdentifier: "RinconRow", for: indexPath) as! RinconRow
        
        let current_rincon = arryRincons[indexPath.row]
        cell.lblRinconName.text = current_rincon.name
        cell.membershipStatus = current_rincon.member!
        cell.configure()
        cell.rinconStore = self.rinconStore
        cell.rincon = current_rincon
        cell.searchRinconVcDelegate = self

        return cell
    }
    
}

protocol SearchRinconVCDelegate {
    func rinconAlert(message: String)
}


class RinconRow: UITableViewCell {
    var rinconStore:RinconStore!
    var rincon:Rincon!
    var searchRinconVcDelegate: SearchRinconVCDelegate!
    var stckVwRinconRow = UIStackView()
    var lblRinconName = UILabel()
    var serachRinconVcAlertMessage:String!
    var membershipStatus:Bool! {
        didSet{
            setup_btnMembership()
        }
    }
    var btnMembership = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure() {
        stckVwRinconRow.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stckVwRinconRow)
        stckVwRinconRow.topAnchor.constraint(equalTo: contentView.topAnchor).isActive=true
        stckVwRinconRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: widthFromPct(percent: -1)).isActive=true
        stckVwRinconRow.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive=true
        stckVwRinconRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: widthFromPct(percent: 1)).isActive=true
        stckVwRinconRow.spacing = 10
        stckVwRinconRow.distribution = .fill
        
        lblRinconName.translatesAutoresizingMaskIntoConstraints=false
        stckVwRinconRow.insertArrangedSubview(lblRinconName, at: 0)
    }
    
    private func setup_btnMembership(){
        btnMembership.translatesAutoresizingMaskIntoConstraints=false
        stckVwRinconRow.addArrangedSubview(btnMembership)
        
        btnMembership.addTarget(self, action: #selector(btnMembershipTouchDown), for: .touchDown)
        btnMembership.addTarget(self, action: #selector(btnMembershipTouchUpInside), for: .touchUpInside)
        btnMembership.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        if membershipStatus {
            setup_btnMembership_leave()
        } else {
            setup_btnMembership_join()
        }
        
    }
    
    private func setup_btnMembership_join(){
        btnMembership.setTitle(" Join ", for: .normal)
        btnMembership.setTitleColor(.green, for: .normal)
        btnMembership.layer.borderColor = UIColor.green.cgColor
        btnMembership.layer.borderWidth = 2
        btnMembership.layer.cornerRadius = 10
    }
    private func setup_btnMembership_leave(){
        btnMembership.setTitle(" Leave ", for: .normal)
        btnMembership.setTitleColor(UIColor(named: "redDelete"), for: .normal)
        btnMembership.layer.borderColor = UIColor(named: "redDelete")?.cgColor
        btnMembership.layer.borderWidth = 2
        btnMembership.layer.cornerRadius = 10
    }
    
    
    // Button action
    @objc func btnMembershipTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    @objc func btnMembershipTouchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        let buttonTitle = btnMembership.title(for: .normal) ?? "No Title"
        print("btnMembership pressed, title: \(buttonTitle)")
        self.rinconStore.requestRinconMembership(rincon: rincon) { jsonDict in
            if jsonDict["status"] == "removed user"{
//                self.btnMembership.removeFromSuperview()
                self.setup_btnMembership_join()
//                self.layoutIfNeeded()
                self.serachRinconVcAlertMessage = "You have left \(self.rincon.name)"
            }
            else if jsonDict["status"] == "added user"{
//                self.btnMembership.removeFromSuperview()
                self.setup_btnMembership_leave()
//                self.layoutIfNeeded()
                self.serachRinconVcAlertMessage = "You have been added to \(self.rincon.name)"
            } else {
                self.serachRinconVcAlertMessage = "Failed to communicate with main server"
            }
            self.searchRinconVcDelegate.rinconAlert(message: self.serachRinconVcAlertMessage)
        }
    }
    
}


