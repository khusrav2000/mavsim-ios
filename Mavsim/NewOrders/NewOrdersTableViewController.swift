//
//  NewOrdersTableViewController.swift
//  Mavsim
//
//  Created by istiqlolsoft on 02/12/22.
//

import Foundation
import UIKit

class NewOrdersTableViewController: UITableViewController {
    
    var newOrders: [Order] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        tableView.refreshControl!.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl!.beginRefreshing()
        loadNewOrders()
    }
                                 
    @objc func refresh(_ sender: AnyObject) {
        loadNewOrders()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newOrders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewOrdersCell", for: indexPath) as! NewOrdersCell
        
        cell.setValues(order: newOrders[indexPath.row])
        
        return cell
    }
    
    func loadNewOrders() {
        let data = KeychainHelper.standart.read(service: "access-token", account: "mavsim")
        
        if data == nil {
            return
        }
        
        let token = String(data: data!, encoding: .utf8)!
        NetworkingClient.standart.getNewOrders(token: token) { (orders, error) in
            if let error = error {
                print(error)
                // self.showRightToast()
            } else if let orders = orders {
                self.newOrders = orders
                self.tableView.reloadData()
                self.tableView.refreshControl!.endRefreshing()
            }
            
        }
    }
}