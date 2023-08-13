//
//  RinconsDirectoriesVC.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 30/07/2023.
//

import UIKit

class RinconsDirectoriesVC:DefaultViewController{
    var urlStore:URLStore!
    let vwVCHeaderOrange = UIView()
    let lblTitle = UILabel()
    var stckVwYourRincons=UIStackView()
    
    var tblRinconDirs = UITableView()
    let backgroundColor = UIColor(named: "gray-300")?.cgColor
    let vwBackgroundCard = UIView()
    let cardInteriorPadding = Float(5.0)
    
    var arryRinconDirs=[String](){
        didSet{// populates when the screen shows up, otherwise not necessary.
            if arryRinconDirs.count > 0{
                arryFilenames = listFilesInDirectory(directoryName: arryRinconDirs[0])
                print(arryFilenames)
            }
        }
    }
    var stckVwRinconsDir=UIStackView()
    var arryFilenames: [String] = []
    // UIPickerView to show directories
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_vwVCHeaderOrange()
        tblRinconDirs.delegate = self
        tblRinconDirs.dataSource = self
        // Setup pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        // Register a UITableViewCell
        tblRinconDirs.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")

        setup_vwBackgroundCard()
        setup_lblTitle()
        setup_stckVwWithPicker()
        setup_table()
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
    func setup_lblTitle(){
        lblTitle.text = "Choose a Rincón:"
        lblTitle.font = UIFont(name: "Rockwell_tu", size: 30)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.accessibilityIdentifier="lblTitle"
        vwBackgroundCard.addSubview(lblTitle)
        lblTitle.topAnchor.constraint(equalTo: vwBackgroundCard.topAnchor, constant: heightFromPct(percent: cardInteriorPadding)).isActive=true
        lblTitle.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor, constant: widthFromPct(percent: 2.5)).isActive=true
    }
    
    func setup_stckVwWithPicker(){
        stckVwRinconsDir.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(stckVwRinconsDir)
        stckVwRinconsDir.axis = .vertical
        stckVwRinconsDir.topAnchor.constraint(equalTo: lblTitle.bottomAnchor).isActive=true
        stckVwRinconsDir.trailingAnchor.constraint(equalTo: vwBackgroundCard.trailingAnchor).isActive=true
        stckVwRinconsDir.bottomAnchor.constraint(equalTo: vwBackgroundCard.bottomAnchor).isActive=true
        stckVwRinconsDir.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor).isActive=true
        stckVwRinconsDir.distribution = .fill
        
        pickerView.translatesAutoresizingMaskIntoConstraints=false
        stckVwRinconsDir.addArrangedSubview(pickerView)
        pickerView.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 8)).isActive=true
    }
    
    func setup_table(){
        let lineDivider01 = createDividerLine(thicknessOfLine: 2.0)
        lineDivider01.translatesAutoresizingMaskIntoConstraints=false
        stckVwRinconsDir.addArrangedSubview(lineDivider01)

        let stckSpacer01 = UIView()
        stckSpacer01.backgroundColor = .clear
        stckSpacer01.translatesAutoresizingMaskIntoConstraints=false
        stckSpacer01.accessibilityIdentifier="stckSpacer01"
        stckVwRinconsDir.addArrangedSubview(stckSpacer01)
        stckSpacer01.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 1)).isActive=true
        
        let lblDirList = UILabel()
        lblDirList.text = "List of files found in rincón:"
        lblDirList.font = UIFont(name: "Rockwell_tu", size: 20)
        lblDirList.translatesAutoresizingMaskIntoConstraints = false
        lblDirList.accessibilityIdentifier="lblDirList"
        stckVwRinconsDir.addArrangedSubview(lblDirList)
       
        
        let vwTblView = UIView()
        vwTblView.backgroundColor = UIColor(named: "gray-500")
        vwTblView.translatesAutoresizingMaskIntoConstraints=false
        vwTblView.accessibilityIdentifier = "vwTblView"
        stckVwRinconsDir.addArrangedSubview(vwTblView)
        
        // set Table of files
        tblRinconDirs.translatesAutoresizingMaskIntoConstraints=false
        vwTblView.addSubview(tblRinconDirs)
        tblRinconDirs.topAnchor.constraint(equalTo: vwTblView.topAnchor,constant: heightFromPct(percent: 1)).isActive=true
        tblRinconDirs.leadingAnchor.constraint(equalTo: vwTblView.leadingAnchor, constant: widthFromPct(percent: 3)).isActive=true
        tblRinconDirs.trailingAnchor.constraint(equalTo: vwTblView.trailingAnchor, constant: -widthFromPct(percent: 3)).isActive=true
        tblRinconDirs.bottomAnchor.constraint(equalTo: vwTblView.bottomAnchor).isActive=true
        tblRinconDirs.backgroundColor = UIColor(named: "gray-300")
        
        let stckSpacer02 = UIView()
        stckSpacer02.backgroundColor = .clear
        stckSpacer02.translatesAutoresizingMaskIntoConstraints=false
        tblRinconDirs.setContentHuggingPriority(.defaultLow, for: .vertical)
        stckVwRinconsDir.addArrangedSubview(stckSpacer02)
        stckSpacer02.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 2)).isActive=true
        

    }
    
    
}

extension RinconsDirectoriesVC: UITableViewDelegate{

}
extension RinconsDirectoriesVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arryFilenames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        cell.textLabel?.text = arryFilenames[indexPath.row]
        cell.backgroundColor = UIColor(named: "gray-300")
//            cell.detailTextLabel?.text = unwrapped_rincons[indexPath.row][0]
        return cell
    }
    
    
}

extension RinconsDirectoriesVC: UIPickerViewDelegate, UIPickerViewDataSource {
    // UIPickerView DataSource and Delegate methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arryRinconDirs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arryRinconDirs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedDirectory = arryRinconDirs[row]
        arryFilenames = listFilesInDirectory(directoryName: selectedDirectory)
        print(arryFilenames)
        tblRinconDirs.reloadData()
    }
    
    func listFilesInDirectory(directoryName: String) -> [String] {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }
        
        let directoryURL = documentsDirectory.appendingPathComponent(directoryName)
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            let fileNames = contents.map { $0.lastPathComponent }
            return fileNames
        } catch {
            print("Error getting contents of directory: \(directoryURL)")
            return []
        }
    }
}
