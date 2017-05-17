//
//  InfoScreenViewController.swift
//  OracleHackathonEveris
//
//  Created by Paul Alava Doncel on 12/5/17.
//  Copyright © 2017 everis. All rights reserved.
//

import UIKit

class InfoScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonEnded: UIButton!
    @IBOutlet weak var gifImage: UIImageView!
    var date = Date()
    
    var officeDoneList : [Poi] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Resumen"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "BasicCell")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonEndedPresse(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell") as? CustomTableViewCell
        cell?.checkImage.isHidden = true
        cell?.labelAddress.text = officeDoneList[indexPath.row].address
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: Int(arc4random_uniform(15)), to: self.date)
        self.date = date!
        let timestamp = DateFormatter.localizedString(from: date!, dateStyle: .none, timeStyle: .short)
        
        cell?.labelTime.text = timestamp
        cell?.labelTime.isHidden = false
        if indexPath.row == 0{
            cell?.labelTime.isHidden = true
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return officeDoneList.count
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
