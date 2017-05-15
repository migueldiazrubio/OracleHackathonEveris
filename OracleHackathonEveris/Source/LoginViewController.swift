//
//  LoginViewController.swift
//  OracleHackathonEveris
//
//  Created by Paul Alava Doncel on 12/5/17.
//  Copyright © 2017 everis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passTextfield: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    var mask:UIView?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
     @IBAction func buttonLoginPressed(_ sender: Any) {
         authenticate(anonymously: false);
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        // Skip login screen, if already logged in.
        if ( MCSSyncManager.sharedInstance.isLoggedIn() == true ) {
            gotoLeadTypes(animated:false)
        }
        else{
            unmaskView();
            self.view.setNeedsDisplay();
        }
        
        self.navigationController?.isNavigationBarHidden = true;
    }

    @IBAction func btnAnonymouslyTapped(_ sender: AnyObject) {
        
        authenticate(anonymously: true);
    }
    
    func authenticate(anonymously:Bool) {
        
        let _userSettings: MCSUserSettings? = MCSUserSettings.init();
        _userSettings?.refreshSettings();
        
        let error:NSError! = MCSSyncManager.sharedInstance.AuthenticateMCS(userTextField.text!, password: userTextField.text!, anonymously: anonymously );
        if( error != nil ){
            
            NSLog("Authentication failed!");
            let alert = UIAlertController(title: "Login Failed", message:error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            gotoLeadTypes(animated:true)
        }
    }
    
    func gotoLeadTypes(animated:Bool)  {
        
//        let leadTypesObj = LeadsTypeVC(nibName: "LeadsTypeVC", bundle: nil)
//        self.navigationController?.pushViewController(leadTypesObj, animated: animated)
        maskView();
    }
    
    func maskView(){
        
        if mask != nil {
            mask?.removeFromSuperview();
        }
        
        mask = UIView.init(frame: self.view.bounds);
        mask?.isHidden = false;
        mask?.tag = -100;
        mask?.backgroundColor = UIColor.white;
        self.view.addSubview(mask!);
        self.view.bringSubview(toFront: mask!);
    }
    
    func unmaskView(){
        
        if ( mask != nil
            && self.view.subviews.contains(mask!) ) {
            mask?.isHidden = true;
            self.view.willRemoveSubview(mask!)
        }
    }

}

