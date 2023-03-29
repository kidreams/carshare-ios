//
//  BaseNavigationViewController.swift
//  CarShare
//
//  Created by nicholas on 3/24/23.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("Initializing \(self)")
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    deinit {
        print("Deinitializing \(self)")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
