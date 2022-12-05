//
//  ProfileViewController.swift
//  Mavsim
//
//  Created by mac on 25/11/22.
//

import Foundation
import UIKit

class ProfileController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var headerView: UIStackView!
    
    @IBOutlet weak var profileLogo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var login: UILabel!
    
    
    @IBOutlet weak var carNumber: UIView!
    @IBOutlet weak var carTypeView: UIView!
    @IBOutlet weak var trailerNumber: UIView!
    @IBOutlet weak var parentName: UIView!
    @IBOutlet weak var logout: UIView!
    
    @IBOutlet weak var carNumberText: UILabel!
    @IBOutlet weak var carTypeText: UILabel!
    @IBOutlet weak var carTrailerNumberText: UILabel!
    @IBOutlet weak var parentNameText: UILabel!
    
    
    @IBOutlet weak var carNumberIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.backgroundColor = Colors.yellow
        view.backgroundColor = Colors.yellow
        
        carNumber.tintColor = Colors.blue
        profileLogo.tintColor = Colors.black_300
        
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 10
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        setBorderDesign(tpView: carNumber)
        setBorderDesign(tpView: carTypeView)
        setBorderDesign(tpView: trailerNumber)
        setBorderDesign(tpView: parentName)
        setBorderDesign(tpView: logout)
        setValues()
    }
    
    func setBorderDesign(tpView: UIView) {
        tpView.backgroundColor = Colors.yellow_300
        tpView.layer.cornerRadius = 5
        tpView.layer.borderColor = Colors.yellow.cgColor
        tpView.layer.borderWidth = 1
    }
    
    func setValues() {
        name.text = TemporaryData.user?.FullName ?? ""
        login.text = TemporaryData.user?.Username ?? ""
        
        carNumberText.text = TemporaryData.user?.TransportNo ?? ""
        carTypeText.text = TemporaryData.user?.TransportType ?? ""
        carTrailerNumberText.text = TemporaryData.user?.TrailerNo ?? ""
        parentNameText.text = TemporaryData.user?.ParentName ?? ""
    }

}
