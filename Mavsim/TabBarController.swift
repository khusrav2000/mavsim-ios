//
//  TabBarController.swift
//  Mavsim
//
//  Created by mac on 23/11/22.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = Colors.yellow
        // tabBar.tintColor = Colors.yellow
        tabBar.barTintColor = Colors.yellow
        selectedIndex = 1
        tabBar.unselectedItemTintColor = .white
        //tabBar.barTintColor = Colors.yellow
    }
}
