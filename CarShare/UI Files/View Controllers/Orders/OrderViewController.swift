//
//  OrderViewController.swift
//  CarShare
//
//  Created by nicholas on 3/26/23.
//

import UIKit

class OrderViewController: BaseViewController {
    
    var orders: [CSOrderDetail]?
    var cars: [CSCarDetail]?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Orders"
        // Do any additional setup after loading the view.
        prepare(for: tableView)
        fetchCars()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if orders == nil {
            fetchOrders()
        }
    }
    
    @objc
    func fetchOrders() {
        self.dismissWorker()
        let worker = CSAPIWorker(with: CSEndPoints.transactions())?
            .prepare()
            .when(success: { [weak self] (result) in
                self?.fetchComplete()
                let orders: [CSOrderDetail] = result["data"].csModelArray()
                self?.update(orders: orders)
                self?.dismissWorker()
            })
            .when(failure: { [weak self] (error) in
                self?.fetchComplete()
                self?.dismissWorker()
            })
            .fire()
        
        self.apiWorker = worker

    }
    
    func fetchCars(showLoading: Bool = false) {
        self.dismissWorker()
        let worker = CSAPIWorker(with: CSEndPoints.cars())?
            .prepare(indicator: showLoading)
            .when(success: { [weak self] (result) in
                self?.fetchComplete()
                let cars: [CSCarDetail] = result["data"].csModelArray()
                self?.update(cars: cars)
                self?.dismissWorker()
            })
            .when(failure: { [weak self] (error) in
                self?.fetchComplete()
                self?.dismissWorker()
            })
            .fire()
        
        self.apiWorker = worker
    }
    
    func update(orders: [CSOrderDetail]) {
        self.orders = orders
        self.tableView.reloadData()
    }
    
    func update(cars: [CSCarDetail]) {
        self.cars = cars
    }
    
    func fetchComplete()
    {
        self.tableView.refreshControl?.endRefreshing()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
