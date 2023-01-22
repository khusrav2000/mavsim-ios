//
//  OrderStatusImageCell.swift
//  Mavsim
//
//  Created by istiqlolsoft on 07/12/22.
//

import Foundation
import UIKit

class OrderStatusImageCell: UITableViewCell {
    
    
    @IBOutlet weak var imageSel: UIImageView!
    
    @IBOutlet weak var deleteButitnImage: UIButton!
    
    
    var deleteButtonAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /*self.deleteButitnImage.addTarget(self, action: #selector(deleteButtonTrapped(_:)), for: .touchUpInside)*/
    }
    
    @IBAction func deleteButtonTrapped(_ sender: UIButton) {
        deleteButtonAction?()
    }
    
    func setValues(image: UIImage) {
       
        imageSel.image = image
    }
    
}
