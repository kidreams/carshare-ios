//
//  PaypalPaymentViewController.swift
//  CarShare
//
//  Created by nicholas on 3/26/23.
//

import UIKit
import Braintree
import BraintreeDropIn
import WebKit
let btToken = "access_token$sandbox$h73cqnxntqzbwtk3$a4d5e6b10c8cc16b60688612673bb083"

typealias PaymentCompletetion = ((PaymentStatus, PaymentInfo?) -> Void)
typealias PaymentInfo = [AnyHashable : Any]

class PaypalPaymentViewController: BaseViewController {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    var progressObservation: NSKeyValueObservation?
    
    var paymentLink: URL?
    
    var paymentCompletionHandler: PaymentCompletetion?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupWebView()
        processToPaypal()
        
        let button = UIButton(type: .close)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        fetchBraintreeToken()
    }
    
    @objc
    func close() {
        self.dismiss(animated: true)
    }
    
    func processToPaypal() {
        guard let paymentLink = self.paymentLink else { return }
        
        if let request: URLRequest = try? URLRequest(url: paymentLink, method: .get) {
            self.webView.load(request)
        }
        
    }
    
    func fetchBraintreeToken() {
        showDropIn(with: btToken)
    }
    
    func showDropIn(with token: String) {
//        guard let reservation = self.carReservation else { return }
//        let paymentRequest = BTDropInRequest()
//        paymentRequest.applePayDisabled = true
//        let threeDSecureRequest =  BTThreeDSecureRequest()
//        threeDSecureRequest.amount = NSDecimalNumber(decimal: reservation.price)
//        threeDSecureRequest.versionRequested = .version2
//        paymentRequest.threeDSecureRequest = threeDSecureRequest
//
//        guard let dropInController = BTDropInController(authorization: btToken, request: paymentRequest, handler: { (controller, result, error) in
//
//
//        })
//        else { return }
//
//        self.navigationController?.present(dropInController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        progressObservation?.invalidate()
        progressObservation = nil
    }
}


enum PaymentStatus {
    case unknown
    case userCancel
    case success
}
