//
//  InfoScreenViewController.swift
//  OracleHackathonEveris
//
//  Created by Paul Alava Doncel on 12/5/17.
//  Copyright © 2017 everis. All rights reserved.
//

import UIKit

class InfoScreenViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var gifImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gif = UIImage(gifName: "Gif")
        gifImage.setGifImage(gif)
        self.title = "Resumen"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
