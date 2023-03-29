//
//  ReservationViewController.swift
//  CarShare
//
//  Created by nicholas on 3/26/23.
//

import UIKit
import Kingfisher
import DatePicker

class ReservationViewController: BaseViewController {
    
    var carDetail: CSCarDetail?
    
    var reservation: CSReservation?
    
    var transaction: CSTransaction?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var fuelDistanceLabel: UILabel!
    
    @IBOutlet weak var fuelTankSizeLabel: UILabel!
    
    @IBOutlet weak var dailyPriceLabel: UILabel!
    
    @IBOutlet weak var carImageView: UIImageView!
    
    @IBOutlet weak var startDateButton: UIButton!
    
    @IBOutlet weak var endDateButton: UIButton!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBOutlet weak var paymentRefView: UIView!
    
    @IBOutlet weak var paymentRefLabel: UILabel!
    
    @IBOutlet weak var thankyouLabel: UILabel!
    
    @IBOutlet weak var confirmButton: RoundedButton!
    
    var startDate: Date?
    var endDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(named: "theme-color-light") ?? .white
        
        if let _carDetail = carDetail {
            self.titleLabel.text = _carDetail.makeAndModel + "\n\(_carDetail.year ?? "")"
            self.dailyPriceLabel.text =  "\(_carDetail.rentalPrice)"
            self.fuelDistanceLabel.text = "> \(900)km"
            self.fuelTankSizeLabel.text = "> \(50)L"
            let imageURL: URL? = URL(string: _carDetail.imagePath)
            
            self.carImageView.layoutIfNeeded()
            self.carImageView.layer.cornerRadius = 20
            self.carImageView.layer.masksToBounds = true
            
            let processor = DownsamplingImageProcessor(size: carImageView.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 20)
            let defaultImage = UIImage(named: "car-placeholder")
            
            self.totalAmountLabel.text = "0"
            
            self.carImageView.kf.setImage(with: imageURL,
                                          placeholder: defaultImage,
                                          options: [
                                            .processor(processor),
                                            .scaleFactor(UIScreen.main.scale),
                                            .transition(.fade(1)),
                                            .cacheOriginalImage
                                          ])
            
        }
        self.confirmButton.isEnabled = false
    }
    
    @IBAction func reserveButtonAction(_ sender: UIButton) {
        if transaction == nil {
            self.startDateButton.isUserInteractionEnabled = false
            self.endDateButton.isUserInteractionEnabled = false
            createReservation()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    @IBAction func startDateButtonAction(_ sender: UIButton) {
        let datePicker = DatePicker()
        datePicker.setup(beginWith: Date(),
                         selected: { [weak self] (selected, date) in
            self?.updateStart(date: date)
        })
        datePicker.show(in: self, on: sender)
    }
    
    @IBAction func endDateButtonAction(_ sender: UIButton) {
        let datePicker = DatePicker()
        datePicker.setup(beginWith: self.startDate,
                         selected: { [weak self] (selected, date) in
            self?.updateEnd(date: date)
        })
        datePicker.show(in: self, on: sender)
    }
    
    func updateStart(date: Date?) {
        if let date = date {
            if let endDate = endDate,
               date.compare(endDate) == .orderedDescending {
                self.startDate = endDate
                self.endDate = date
            } else {
                self.startDate = date
            }
            self.updateUIsForDates()
        }
    }
    
    func updateEnd(date: Date?) {
        if let date = date {
            if let startDate = startDate,
               date.compare(startDate) == .orderedAscending {
                self.endDate = startDate
                self.startDate = date
            } else {
                self.endDate = date
            }
            self.updateUIsForDates()
        }
    }
    
    func updateUIsForDates() {
        if let startDate = startDate {
            self.startDateButton.setTitle(DateFormatter.standard.string(from: startDate), for: .normal)
        }
        if let endDate = endDate {
            self.endDateButton.setTitle(DateFormatter.standard.string(from: endDate), for: .normal)
        }
        
        if let startDate = startDate,
           let endDate = endDate,
           let days = startDate.days(between: endDate),
           let unitPrice = carDetail?.rentalPrice
        {
            self.confirmButton.isEnabled = true
            self.totalAmountLabel.text = "\(Decimal(days) * unitPrice)"
        } else {
            self.confirmButton.isEnabled = false
        }
    }
    
    func onCarUpdated() {
        self.dismiss(animated: true)
    }
    
    func onPaymentTransactionCreated() {
        self.confirmButton.setTitle("Done", for: .normal)
        if transaction != nil, let reservation = self.reservation {
            self.paymentRefView.isHidden = false
            self.paymentRefLabel.text = reservation.paypalOrderID
            self.thankyouLabel.text = "\nYour payment has been made\nThank you for using CarShare"
        }
    }

    
    func preparePayment(with reservation: CSReservation) {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        
        let paymentMethodPage: PaymentMethodViewController = storyboard.instantiateViewController(identifier: "PaymentMethodViewController")
        paymentMethodPage.carReservation = reservation
        
        let navigationViewController = BaseNavigationViewController(rootViewController: paymentMethodPage)
        
        let paymentCompletionHandler: PaymentCompletetion = { [weak self] (status, userInfo) in
            self?.createTransaction()
        }
        paymentMethodPage.paymentCompletionHandler = paymentCompletionHandler
        navigationViewController.isModalInPresentation = true
        self.present(navigationViewController, animated: true)
    }
}
