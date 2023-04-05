//
//  CSUserTableViewCell.swift
//  CarShare
//
//  Created by nicholas on 3/29/23.
//

import UIKit

let UserProfileCellIdentifier = "kUserProfileCellIdentifier"

class CSUserTableViewCell: UITableViewCell {
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var contentField: UITextField!
    
    unowned var user: CSUser?
    
    var profileCellType: ProfileCellItem = .unknown
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentField.isEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(for profileType: ProfileCellItem) {
        switch profileType {
            
        case .userName:
            descLabel.text     = "User name"
            contentField.text  = user?.userName ?? "-"
            
        case .email:
            descLabel.text     = "Email"
            contentField.text  = user?.email ?? "-"
            
            
        case .contactNumber:
            descLabel.text     = "Contact Number"
            contentField.text  = user?.phoneNumber ?? "-"
            
        default: break
        }

    }

}
