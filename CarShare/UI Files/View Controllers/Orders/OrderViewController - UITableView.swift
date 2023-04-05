//
//  OrderViewController - UITableView.swift
//  CarShare
//
//  Created by nicholas on 3/26/23.
//

import UIKit

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal
    func prepare(for tableView: UITableView) {
        let refresh:UIRefreshControl = UIRefreshControl()
        refresh.addTarget(self, action: #selector(fetchOrders), for: .valueChanged)
        tableView.refreshControl = refresh
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "OrderListTableViewCell", bundle: .main), forCellReuseIdentifier: OrderListCellIdentifier)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderListTableViewCell = tableView.dequeueReusableCell(withIdentifier: OrderListCellIdentifier, for: indexPath) as! OrderListTableViewCell
        if let orders = orders, indexPath.row < orders.count {
            let order = orders[indexPath.row]
            cell.renderCell(with: order)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
