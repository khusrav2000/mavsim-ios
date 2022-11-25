//
//  TabBarController.swift
//  Mavsim
//
//  Created by mac on 23/11/22.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = Colors.yellow
        tabBar.barTintColor = Colors.yellow
    }
}
