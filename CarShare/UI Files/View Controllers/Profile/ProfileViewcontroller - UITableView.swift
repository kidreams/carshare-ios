//
//  ProfileViewcontroller - UITableView.swift
//  CarShare
//
//  Created by nicholas on 3/29/23.
//

import UIKit


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Delegate and DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemToDisplay().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CSUserTableViewCell = tableView.dequeueReusableCell(withIdentifier: UserProfileCellIdentifier, for: indexPath) as! CSUserTableViewCell
     
        if let _user = user, indexPath.row < itemToDisplay().count
        {
            cell.user = _user
            cell.render(for: itemToDisplay()[indexPath.row])
        }
        
        return cell
    }
    
    // MARK: - Custom
    func prepare(for tableView: UITableView) {
        let refresh:UIRefreshControl = UIRefreshControl()
        refresh.addTarget(self, action: #selector(fetchProfile), for: .valueChanged)
        tableView.refreshControl = refresh
        
        tableView.register(UINib(nibName: "CSUserTableViewCell", bundle: .main), forCellReuseIdentifier: UserProfileCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}
