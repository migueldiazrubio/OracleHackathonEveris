//
//  TableSelectViewController.swift
//  OracleHackathonEveris
//
//  Created by Paul Alava Doncel on 12/5/17.
//  Copyright © 2017 everis. All rights reserved.
//

import UIKit

class TableSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var officeDirecctions : [Poi] = []
    var officeList : [Poi] = []
    
    fileprivate var headerView : TableViewHeaderCustom!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Encargos"
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "BasicCell")
        tableView.register(UINib(nibName :"TableViewHeaderCustom", bundle: nil), forCellReuseIdentifier: "TableViewHeaderCustom")
    
        //officeList = NEOLMockRequestManager.mockLocateOfficesRequest() as! [Poi]
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView = TableViewHeaderCustom.instanceFromNib()
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 101))
        self.tableView.tableHeaderView?.addSubview(headerView)
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell") as? CustomTableViewCell
        cell?.checkImage.isHidden = true
        cell?.labelAddress.text = officeList[indexPath.row].address
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return officeList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        if cell.checkImage.isHidden == true {
            cell.checkImage.isHidden = false
            officeDirecctions.append(officeList[indexPath.row])
        }else{
            cell.checkImage.isHidden = true
            if officeDirecctions.contains(officeList[indexPath.row]){
                officeDirecctions.remove(at: officeDirecctions.index(of: officeList[indexPath.row])!)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        if cell.checkImage.isHidden == true {
            cell.checkImage.isHidden = false
            officeDirecctions.append(officeList[indexPath.row])
        }else{
            cell.checkImage.isHidden = true
            if officeDirecctions.contains(officeList[indexPath.row]){
                officeDirecctions.remove(at: officeDirecctions.index(of: officeList[indexPath.row])!)
            }
        }
    }
    
    @IBAction func selectedButtonPressed(_ sender: Any) {
        if officeDirecctions.count > 0 {
            self.performSegue(withIdentifier: "showMapSegue", sender: self)
        }else{
            let alerts = UIAlertView(title: "Error", message: "Debes seleccionar alguna dirección", delegate: self, cancelButtonTitle: "Aceptar")
            alerts.show()
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let Vc = segue.destination as! NEOLLocateOfficesViewController
        Vc.offices = self.officeDirecctions

    }
 

}
