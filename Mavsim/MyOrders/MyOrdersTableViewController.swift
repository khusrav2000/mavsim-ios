//
//  NewOrdersTableViewController.swift
//  Mavsim
//
//  Created by istiqlolsoft on 02/12/22.
//

import Foundation
import UIKit

class MyOrdersTableViewController: UITableViewController {
    
    var myOrders: [Order] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.refreshControl!.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl!.beginRefreshing()
        loadMyOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.refreshControl!.beginRefreshing()
        loadMyOrders()
    }
                                 
    @objc func refresh(_ sender: AnyObject) {
        loadMyOrders()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myOrders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrdersCell", for: indexPath) as! MyOrderCell
        
        cell.backgroundColor = UIColor.clear
        cell.setValues(order: myOrders[indexPath.row])
        
        cell.bodyViewAction = { [unowned self] in
            self.bodyViewTrapped(row: indexPath.row)
        }
        
        cell.statusButtonAction = { [unowned self] in
            self.statusButtonTrapped(row: indexPath.row)
            
        }
        
        cell.deleteButtomAction = { [unowned self] in
            self.deleteButtonTrapped(row: indexPath.row)
        }
        
        
        return cell
    }
    
    func bodyViewTrapped(row: Int) {
        self.performSegue(withIdentifier: "showMyOrderInfoSegue", sender: row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMyOrderInfoSegue" {
            let destinationVC = segue.destination as? OrderInformation
            destinationVC?.order = myOrders[sender as? Int ?? 0 ]
        } else if segue.identifier == "showOrderStatusSeque" {
            let destinationVC = segue.destination as? OrderStatus
            destinationVC?.appId = myOrders[sender as? Int ?? 0 ].AppId
        }
    }
    
    func statusButtonTrapped(row: Int) {
        self.performSegue(withIdentifier: "showOrderStatusSeque", sender: row)
    }
    
    func deleteButtonTrapped(row: Int) {
        print("button = ", row)
        let vc = storyboard?.instantiateViewController(withIdentifier: "ModalPopUp") as! ModalPopUpViewController
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.text = "Вы дествительно хотите удалить этот заказ"
        vc.yesAction = { [unowned self] in
            self.deleteMyOrder(row: row)
        }
        present(vc, animated: true, completion: nil)
        // let alert: UIAlertAction = UIAlertAction(title: "asdasd", style: .default)
        // present(alert, animated: true)
    }
    
    func deleteMyOrder(row: Int) {
        self.tableView.refreshControl!.beginRefreshing()
        let data = KeychainHelper.standart.read(service: "access-token", account: "mavsim")
        
        if data == nil {
            return
        }
        let token = String(data: data!, encoding: .utf8)!
        
        NetworkingClient.standart.delOrderDelete(token: token, id: myOrders[row].id) { (success, error) in
            if success ?? false {
                self.loadMyOrders()
            } else {
                // error
            }
        }
        
    }
    
    func OrderInfo() {
        
    }
    
    func loadMyOrders() {
        let data = KeychainHelper.standart.read(service: "access-token", account: "mavsim")
        
        if data == nil {
            return
        }
        
        let token = String(data: data!, encoding: .utf8)!
        NetworkingClient.standart.getMyOrders(token: token) { (orders, error) in
            if let error = error {
                print(error)
                // self.showRightToast()
            } else if let orders = orders {
                self.myOrders = orders
                self.tableView.refreshControl!.endRefreshing()
                self.tableView.reloadData()
            }
            
        }
    }
}
