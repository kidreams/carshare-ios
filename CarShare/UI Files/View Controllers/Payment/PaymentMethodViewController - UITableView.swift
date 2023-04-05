//
//  PaymentMethodViewController - UITableView.swift
//  CarShare
//
//  Created by nicholas on 3/26/23.
//

import UIKit

extension PaymentMethodViewController: UITableViewDelegate, UITableViewDataSource {
    var paymentMethod: [CSPaymentMethod] {
        return [.paypal, .creditCard, .applePay, .payme]
    }
    
    internal
    func prepare(for tableView: UITableView) {
        tableView.register(UINib(nibName: "PaymentMethodTableViewCell", bundle: .main), forCellReuseIdentifier: PaymentMethodCellIdentifier)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
        self.instructionLabel = UILabel()
        self.instructionLabel.numberOfLines = 0
        self.instructionLabel.font = UIFont(name: "Roboto-Medium", size: 22)
        instructionLabel.text = "Select your preferred payment method"
        instructionLabel.textColor = UIColor(named: "light-text-color")
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "theme-color-dark")
        headerView.addSubview(instructionLabel)
        
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            instructionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: headerView.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: headerView.trailingAnchor, constant: -20),
            instructionLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            instructionLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            instructionLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        ])
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        paymentMethod.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PaymentMethodTableViewCell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodCellIdentifier, for: indexPath) as! PaymentMethodTableViewCell
        if indexPath.row < paymentMethod.count {
            let paymentMethod = paymentMethod[indexPath.row]
            cell.renderCell(with: paymentMethod)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: PaymentMethodTableViewCell = tableView.cellForRow(at: indexPath) as! PaymentMethodTableViewCell
        
        if let cellViewModel = cell.cellViewModel, cellViewModel.enabled {
            print("\(cellViewModel.title) selected")
            confirmPaypalPayment()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
