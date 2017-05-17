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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if officeDoneList[indexPath.row].address != "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell") as? CustomTableViewCell
            cell?.checkImage.isHidden = true
            cell?.labelAddress.text = officeDoneList[indexPath.row].address
            let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
            cell?.labelTime.text = timestamp
            cell?.labelTime.isHidden = false
            return cell!
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return officeDoneList.count - 1
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
