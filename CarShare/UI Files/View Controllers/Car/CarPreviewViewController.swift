//
//  CarPreviewViewController.swift
//  CarShare
//
//  Created by nicholas on 3/29/23.
//

import UIKit
import Kingfisher

protocol CarPreviewProtocol: NSObjectProtocol {
    func prepareReservation(for car: CSCarDetail)
}

class CarPreviewViewController: BaseViewController {
    var carDetail: CSCarDetail?
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var fuelDistanceLabel: UILabel!
    
    @IBOutlet weak var fuelTankSizeLabel: UILabel!
    
    @IBOutlet weak var dailyPriceLabel: UILabel!
    
    @IBOutlet weak var carImageView: UIImageView!
    
    @IBOutlet weak var reserveButton: RoundedButton!
    
    weak var delegate: CarPreviewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .clear
        
        if let _carDetail = carDetail {
            self.titleLabel.text = _carDetail.makeAndModel
            self.dailyPriceLabel.text =  "\(_carDetail.rentalPrice)"
            self.fuelDistanceLabel.text = "> \(900)km"
            self.fuelTankSizeLabel.text = "> \(50)L"
            let imageURL: URL? = URL(string: carDetail?.imagePath ?? "")
            
            self.carImageView.layoutIfNeeded()
            self.carImageView.layer.cornerRadius = 20
            self.carImageView.layer.masksToBounds = true
            
            let processor = DownsamplingImageProcessor(size: carImageView.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 20)
            let defaultImage = UIImage(named: "car-placeholder")
            
            
            self.carImageView.kf.setImage(with: imageURL,
                                          placeholder: defaultImage,
                                          options: [
                                            .processor(processor),
                                            .scaleFactor(UIScreen.main.scale),
                                            .transition(.fade(1)),
                                            .cacheOriginalImage
                                          ])
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.transition(with: self.view,
                          duration: 0.3) { [weak self] in
            self?.view.backgroundColor = .black.withAlphaComponent(0.4)
            self?.containerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        }
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .transitionCrossDissolve) { [weak self] in
            self?.view.backgroundColor = .black.withAlphaComponent(0.4)
            
        }
    }
    
    @IBAction func reserveButtonAction(_ sender: Any) {
        if let car = carDetail {
            delegate?.prepareReservation(for: car)
        }
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
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
