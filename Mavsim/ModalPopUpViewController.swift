//
//  ModalPopUpViewController.swift
//  Mavsim
//
//  Created by istiqlolsoft on 07/12/22.
//

import Foundation
import UIKit

class ModalPopUpViewController: UIViewController {
    
    var text: String = "Вы действительно принимаете этот заказ"
    
    @IBOutlet weak var modalView: UIView!
    
    @IBOutlet weak var alertText: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    var yesAction: (() -> ())?
    
    @IBOutlet weak var noButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalView.layer.cornerRadius = 10
        yesButton.layer.cornerRadius = 5
        noButton.layer.cornerRadius = 5
        view.backgroundColor = .black.withAlphaComponent(0.4)
        alertText.text = text
    }
    
    
    @IBAction func yesTrapped(_ sender: Any) {
        yesAction?()
        self.dismiss(animated: true)
    }
    
    
    @IBAction func noTrapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
