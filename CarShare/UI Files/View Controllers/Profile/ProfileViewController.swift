//
//  ProfileViewController.swift
//  CarShare
//
//  Created by nicholas on 3/26/23.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var user: CSUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepare(for: tableView)
        if (user == nil) {
            fetchProfile()
        }
        
    }
    
    func update(user: CSUser)
    {
        CSAuthenticator.manager.user    = user
        self.user                       = user
        
        self.tableView.reloadData()
    }
    
    @objc
    func fetchProfile() {
        self.dismissWorker()
        let worker = CSAPIWorker(with: CSEndPoints.me())?
            .prepare()
            .when(success: { [weak self] (result) in
                self?.fetchComplete()
                if let user: CSUser = CSUser(json: result) {
                    self?.update(user: user)
                }
                self?.dismissWorker()
            })
            .when(failure: { [weak self] (error) in
                self?.fetchComplete()
                self?.dismissWorker()
            })
            .fire()
        
        self.apiWorker = worker

    }

    func fetchComplete()
    {
        self.tableView.refreshControl?.endRefreshing()
    }
    
    @IBAction func signOut(_ sender: Any) {
        CSAuthenticator.manager.SignOut()
    }
    
    internal
    func itemToDisplay() -> [ProfileCellItem] {
        return
            [
                .userName,
                .email,
                .contactNumber,
            ]
    }

}

enum ProfileCellItem {
    case unknown
    case email
    case userName
    case contactNumber
}
