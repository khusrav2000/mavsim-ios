//
//  NewOrdersTableViewController.swift
//  Mavsim
//
//  Created by istiqlolsoft on 02/12/22.
//

import Foundation
import UIKit

class CompletedOrdersTableViewController: UITableViewController {
    
    var completedOrders: [Order] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.refreshControl!.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl!.beginRefreshing()
        loadCompletedOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.refreshControl!.beginRefreshing()
        loadCompletedOrders()
    }
                                 
    @objc func refresh(_ sender: AnyObject) {
        loadCompletedOrders()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedOrders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedOrdersCell", for: indexPath) as! CompletedOrdersCell
        
        cell.backgroundColor = UIColor.clear
        cell.setValues(order: completedOrders[indexPath.row])
        
        cell.bodyViewAction = { [unowned self] in
            self.bodyViewTrapped(row: indexPath.row)
        }
        
        
        return cell
    }
    
    func bodyViewTrapped(row: Int) {
        self.performSegue(withIdentifier: "showCompletedOrderInfoSegue", sender: row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCompletedOrderInfoSegue" {
            let destinationVC = segue.destination as? OrderInformation
            destinationVC?.order = completedOrders[sender as? Int ?? 0 ]
        }
    }
    
    
    func OrderInfo() {
        
    }
    
    func loadCompletedOrders() {
        let data = KeychainHelper.standart.read(service: "access-token", account: "mavsim")
        
        if data == nil {
            return
        }
        
        let token = String(data: data!, encoding: .utf8)!
        NetworkingClient.standart.getComplatedOrders(token: token) { (orders, error) in
            if let error = error {
                print(error)
                // self.showRightToast()
            } else if let orders = orders {
                self.completedOrders = orders
                self.tableView.refreshControl!.endRefreshing()
                self.tableView.reloadData()
            }
            
        }
    }
}
