//
//  YourRinconsVC.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 01/08/2023.
//


import UIKit

class YourRinconsVC: DefaultViewController{
    
    var userStore: UserStore!
    var rinconStore: RinconStore!
    var urlStore: URLStore!
    var segue_rincon: Rincon!
    var segue_rincon_posts = [Post](){
        didSet{
            if segue_rincon_posts.count > 0{
                print("- segue_rincon_posts set an ready to segue to RinconVC -")
                
                // Does rincon folder exist?
                let rincon_folder_exists = rinconStore.rinconPhotosFolderExists(rincon: segue_rincon)
                if !rincon_folder_exists{
                    rinconStore.createRinconPhotosFolder(rincon: segue_rincon)
                }
    
                // 1) make json posts,
                self.rinconStore.writePostsToJson(rincon: segue_rincon, posts: segue_rincon_posts)
                
                performSegue(withIdentifier: "goToRinconVC", sender: self)
            }
        }
    }
    var segue_rincons_array = [Rincon](){
        didSet{
            if segue_rincons_array.count > 0 {
                print("--- segue_rincons_array.count > 0")
                for rincon in segue_rincons_array{
                    print(rincon.name)
                }
                
                
                performSegue(withIdentifier: "goToSearchRinconsVC", sender: self)
                
            }
        }
    }
    let vwVCHeaderOrange = UIView()
    let lblTitle = UILabel()
    var stckVwYourRincons=UIStackView()
    
    var tblYourRincons = UITableView()
    var btnFindRincon: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup_vwVCHeaderOrange()

        tblYourRincons.delegate = self
        tblYourRincons.dataSource = self
        
        // Register a UITableViewCell
        tblYourRincons.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")

        setup_stckVwYourRincons()
        setup_btnFindRincon()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tblYourRincons.refreshControl = refreshControl
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
    
    func setup_stckVwYourRincons(){
        view.addSubview(stckVwYourRincons)
        stckVwYourRincons.translatesAutoresizingMaskIntoConstraints=false
        stckVwYourRincons.axis = .vertical
        stckVwYourRincons.topAnchor.constraint(equalTo: vwVCHeaderOrange.bottomAnchor).isActive=true
        stckVwYourRincons.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        stckVwYourRincons.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        stckVwYourRincons.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        
        lblTitle.text = "Your Rincons"
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        stckVwYourRincons.addArrangedSubview(lblTitle)
        
        tblYourRincons.translatesAutoresizingMaskIntoConstraints=false
        stckVwYourRincons.addArrangedSubview(tblYourRincons)
                
    }
    
    func setup_btnFindRincon() {
        btnFindRincon = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(findRincon))

        self.navigationItem.rightBarButtonItem = btnFindRincon
    }
    
    @objc func findRincon(){
//        print("- let's go find a Rincon! ")
        self.rinconStore.getRinconsForSearch { jsonRinconArray in
            print("- getting rincons")
//            print(jsonRinconArray)
            self.segue_rincons_array = jsonRinconArray
        }
        print("-- doen getting rincons")
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        
        
//        self.rinconStore.requestRinconPosts(rincon: rincon) { responseForRinconPostsArray in
//            switch responseForRinconPostsArray{
//            case let .success(arryRinconPosts):
//                for p in arryRinconPosts{
//                    p.rincon_dir_path = self.rinconStore.rinconFolderUrl(rincon: self.rincon)
//                }
//                self.posts = arryRinconPosts
//                self.tblRincon.reloadData()
//                sender.endRefreshing()
//            case let .failure(error):
//                print("FAiled to communicate with API for posts: \(error)")
//            }
//        }
    }
    
    
    func alertYourRinconsVC(alertMessage:String) {
        // Create an alert
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToRinconVC") {
            print("- going to a Rincon")
            let rinconVC = segue.destination as! RinconVC
            rinconVC.navigationItem.title = self.segue_rincon.name
            rinconVC.rinconStore = self.rinconStore
            rinconVC.rinconStore.token = self.userStore.user.token!
            rinconVC.posts = self.segue_rincon_posts
//            print("Rincon obj: \(self.segue_rincon.name), \(self.segue_rincon.permission_post)")
            rinconVC.rincon = self.segue_rincon
            rinconVC.userStore = self.userStore
//            print("UserStore.user objec: \(self.userStore.user.username!)")
        }
        else if (segue.identifier == "goToSearchRinconsVC"){
            
            let searchRinconsVC = segue.destination as! SearchRinconsVC
            searchRinconsVC.arryRincons = segue_rincons_array
            searchRinconsVC.rinconStore = rinconStore
            print("- Leaving YourRinconsVC ")
        }
    }
    
}

extension YourRinconsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let unwrapped_rincons = userStore.user.user_rincons {
            self.segue_rincon = unwrapped_rincons[indexPath.row]
            self.rinconStore.requestRinconPosts(rincon: segue_rincon) { responseForRinconPostsArray in
                switch responseForRinconPostsArray{
                case let .success(arryRinconPosts):
                    for p in arryRinconPosts{
                        p.rincon_dir_path = self.rinconStore.rinconFolderUrl(rincon: self.segue_rincon)
                    }
                    self.segue_rincon_posts = arryRinconPosts
                case let .failure(error):
                    print("Rincon posts did not download: \(error)")
                    self.alertYourRinconsVC(alertMessage: "Posts did not update")
                }

            }
        }
    }
}

extension YourRinconsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let unwrapped_rincons = self.userStore.user.user_rincons  {
            return unwrapped_rincons.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        if let unwrapped_rincons = userStore.user.user_rincons {
            cell.textLabel?.text = unwrapped_rincons[indexPath.row].name
//            cell.detailTextLabel?.text = unwrapped_rincons[indexPath.row][0]
//            cell.backgroundColor = UIColor(named: "gray-300")
        }
        return cell
    }
}

