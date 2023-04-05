//
//  CSTabBarViewController.swift
//  CarShare
//
//  Created by nicholas on 3/23/23.
//

import UIKit

class CSTabBarViewController: UITabBarController {
    let interactionFeedback = UIImpactFeedbackGenerator(style: .soft)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.selectedIndex = 1
        self.delegate = self
        if let selectedColor = UIColor(named: "") {
            
        }
        
        if let deSelectedColor = UIColor(named: "") {
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("CSTabBarViewController: \(String(describing: self.selectedViewController))")
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


extension CSTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        interactionFeedback.prepare()
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        interactionFeedback.impactOccurred()
    }
}
