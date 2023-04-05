//
//  PaymentMethodTableViewCell.swift
//  CarShare
//
//  Created by nicholas on 3/26/23.
//

import UIKit
let PaymentMethodCellIdentifier: String = "kPaymentMethodCellIdentifier"
class PaymentMethodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    var cellViewModel: CSPaymentMethodCellObject?
    
    var enabled: Bool = false
    {
        didSet { updateAvailablity() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetUIs()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(with paymentMethod: CSPaymentMethod) {
        guard paymentMethod != .unknown else { return }
        
        switch paymentMethod {
        case .paypal:
            setupPaypalUIs()
        case .creditCard:
            setupCreditCardUIs()
        case .applePay:
            setupApplePayUIs()
        case .payme:
            setupPaymeUIs()
        default: break
        }
    }
    
    fileprivate
    func updateAvailablity() {
        self.contentView.alpha = enabled ? 1.0 : 0.4
    }
    
    
    private func setupPaypalUIs() {
        let viewModel = CSPaymentMethodCellObject(paymentMethod: .paypal,
                                                  icon: UIImage(named: "paypal-logo"),
                                                  enabled: true,
                                                  title: "Paypal")
        updateUIs(with: viewModel)
        self.cellViewModel = viewModel
    }
    
    private func setupCreditCardUIs() {
        let viewModel = CSPaymentMethodCellObject(paymentMethod: .creditCard,
                                                  icon: UIImage(named: "credit-cards-logo"),
                                                  enabled: false,
                                                  title: "Credit or Debit Card",
                                                  subTitle: "Stay tuned, coming soon")
        
        updateUIs(with: viewModel)
        self.cellViewModel = viewModel
    }
    
    private func setupApplePayUIs() {
        let viewModel = CSPaymentMethodCellObject(paymentMethod: .applePay,
                                                  icon: UIImage(named: "apple-pay-logo"),
                                                  enabled: false,
                                                  title: "Apple Pay",
                                                  subTitle: "Stay tuned, coming soon")
        
        updateUIs(with: viewModel)
        self.cellViewModel = viewModel
    }
    
    private func setupPaymeUIs() {
        let viewModel = CSPaymentMethodCellObject(paymentMethod: .payme,
                                                  icon: UIImage(named: "payme-logo"),
                                                  enabled: false,
                                                  title: "Payme",
                                                  subTitle: "Stay tuned, coming soon")
        
        updateUIs(with: viewModel)
        self.cellViewModel = viewModel
    }
    
    private
    func updateUIs(with viewModel: CSPaymentMethodCellObject) {
        self.iconView.image = viewModel.icon
        self.titleLabel.text = viewModel.title
        self.subTitleLabel.text = viewModel.subTitle
        self.enabled = viewModel.enabled
        self.selectionStyle = self.enabled ? .default : .none
    }
    
    private
    func resetUIs() {
        // TODO: -
        iconView.image = nil
        titleLabel.text = "-"
        subTitleLabel.text = "-"
        enabled = false
    }
}


struct CSPaymentMethodCellObject {
    let paymentMethod: CSPaymentMethod
    let icon: UIImage?
    let enabled: Bool
    let title: String
    let subTitle: String?
    
    init(paymentMethod: CSPaymentMethod,
         icon: UIImage? = UIImage(named: "payment-method-default"),
         enabled: Bool,
         title: String,
         subTitle: String? = nil) {
        self.paymentMethod = paymentMethod
        self.icon = icon
        self.enabled = enabled
        self.title = title
        self.subTitle = subTitle
    }
}
