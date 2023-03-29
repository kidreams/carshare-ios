//
//  OrderListTableViewCell.swift
//  CarShare
//
//  Created by nicholas on 3/26/23.
//

import UIKit
import Kingfisher
let OrderListCellIdentifier: String = "kOrderListCellIdentifier"
class OrderListTableViewCell: UITableViewCell {
    var orderDdetail: CSOrderDetail?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var startDateLabel: UILabel!
    
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBOutlet weak var carImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(with order: CSOrderDetail) {
        self.orderDdetail = order
        self.titleLabel.text = order.title
        startDateLabel.text =  DateFormatter.standard.string(from: order.rentalStartDate)
        endDateLabel.text =  DateFormatter.standard.string(from: order.rentalEndDate)
        totalAmountLabel.text = "$\(order.totalRentalFee)"
        let processor = DownsamplingImageProcessor(size: carImageView.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 20)
        let defaultImage = UIImage(named: "car-placeholder")
        // TODO: Car object is required
//        fatalError("Missing car image")
//        // TODO: unable to create payment
//        fatalError("Missing payment")
//        // TODO: Profile page is required
//        fatalError("Missing Profile")
//        let imageURL: URL? = URL(string: order.imagePath ?? "")
//        self.carImageView.kf.setImage(with: imageURL,
//                                      placeholder: defaultImage,
//                                      options: [
//                                        .processor(processor),
//                                        .scaleFactor(UIScreen.main.scale),
//                                        .transition(.fade(1)),
//                                        .cacheOriginalImage
//                                      ])
    }
    
}
