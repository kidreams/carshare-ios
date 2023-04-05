//
//  PaymentMethodViewController.swift
//  CarShare
//
//  Created by nicholas on 3/23/23.
//

import UIKit

class PaymentMethodViewController: BaseViewController {
    var instructionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var carReservation: CSReservation?
    
    var paymentCompletionHandler: PaymentCompletetion?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let barItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        self.navigationItem.rightBarButtonItem = barItem
        prepare(for: tableView)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc
    func close() {
        self.dismiss(animated: true)
    }
    
    func confirmPaypalPayment() {
        guard
            let carReservation = carReservation,
            let paypalInfo: CSPaypalLink = carReservation.paypalLinks.filter({ $0.rel == .approve }).first,
            let paymentLink: URL = URL(string: paypalInfo.link) else { return }
        
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        let paymentPage: PaypalPaymentViewController = storyboard.instantiateViewController(identifier: "PaypalPaymentViewController")
        
        paymentPage.paymentLink = paymentLink
        paymentPage.paymentCompletionHandler = paymentCompletionHandler
        paymentPage.isModalInPresentation = true
        self.navigationController?.present(paymentPage, animated: true)
    }
    
    
    func fetchComplete() {
        
    }
}
