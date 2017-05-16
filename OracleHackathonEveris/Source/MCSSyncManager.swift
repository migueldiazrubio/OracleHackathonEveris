//
//  MCSSyncManager.swift
//  SalesPlus
//
/* Copyright (c) 2016, Oracle and/or its affiliates. All rights reserved. */

/******************************************************************************
 *
 * You may not use the identified files except in compliance with the Apache
 * License, Version 2.0 (the "License.")
 *
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 *****************************************************************************/

import Foundation

class MCSSyncManager : NSObject {
    
    fileprivate let apiKey = "MY_APP_KEY";

    static let sharedInstance = MCSSyncManager();
    override init() {
        super.init()
    }
    
    // mbeName must match in the OMC.plist file, to get correct "synchronization" configurations.
    fileprivate let mbeName = "mcs_examples_sync_salesplus/1.0";
    
    fileprivate var mbe: OMCMobileBackend!;
    fileprivate var auth: OMCAuthorization!;
    fileprivate var sync:OMCSynchronization!;
    fileprivate var _workOffline:Bool!;
    fileprivate var loggedIn:Bool! = false;
    
    var arrAssets:NSArray!;
    
    func myBackend() -> OMCMobileBackend? {
        
        if ( mbe != nil ) {
            return mbe;
        }
        
        let mbeManager: OMCMobileBackendManager = OMCMobileBackendManager.shared();
        
        var authProps:[String:AnyObject] = [ : ];
        var props:[String:AnyObject] = [ : ];
        
        let userSettings:MCSUserSettings? = MCSUserSettings.init();
        userSettings!.refreshSettings();
        
        authProps["authenticationType"] = "OAuth" as AnyObject?
        authProps["tokenEndpoint"] = userSettings!.token! as AnyObject?
        authProps["clientID"] = userSettings!.clientId! as AnyObject?
        authProps["clientSecret"] = userSettings!.clientSecret! as AnyObject?
        props["baseURL"] = userSettings!.baseUrl! as AnyObject?
        props["appKey"] = apiKey as AnyObject?;
        props["authorization"] = authProps as AnyObject?
        props["logLevel"] = "Debug" as AnyObject?
        
        /* -- Use for basic auth
         authProps["mobileBackendID"] = userSettings!.mbeId! as AnyObject?
         authProps["anonymousKey"] = userSettings!.anonymousKey! as AnyObject?;
         */
        
        mbeManager.addMobileBackend(forName: mbeName, properties: props);
        
        if (  mbeManager.mobileBackend(forName: mbeName) != nil ) {
            
            mbe =  mbeManager.mobileBackend(forName: mbeName);
            
            if ( mbe != nil ) {
                
                print("Mobile backend configured for Base URL %@", props["baseURL"] ?? "");
                return mbe;
            }
        }
        
        NSLog("Mobile backend configuration failed");
        return nil;
    }
    
    func AuthenticateMCS(_ username:String, password:String, anonymously:Bool) -> NSError! {

        self.arrAssets = nil;
        mbe = nil;
        mbe = myBackend();
        
        if ( mbe == nil ) {
            return nil;
        }
        
        auth = mbe.authorization;
        var error:NSError! = nil;
        
        // Using oAuth
        auth.authenticationType = OMCAuthenticationType.oAuth;
        
        if ( anonymously == true ) {
            error = auth.authenticateAnonymous() as NSError?;
        }
        else{
            error = auth.authenticate(username, password: password) as NSError?
        }
        
        if (error == nil) {
            
            NSLog("Login Success");
            self.loggedIn = true;
            
            return nil;
        }
        
        print ("Error: \(error!.localizedDescription)")
        
        return error!;
    }
    
//    func mcsSynchronization() -> OMCSynchronization? {
//        
//        if auth.authorized {
//            
//            if sync == nil {
//                sync = mbe.synchronization();
//                
//                let userSettings:MCSUserSettings? = MCSUserSettings.init();
//                userSettings!.refreshSettings();
//                if ( userSettings!.purge == true ) {
//                    sync.purge();
//                }
//
//                sync.initialize(withMobileObjectEntities: [MyLead.self])
//            }
//            
//            return sync;
//        }
//        
//        return nil;
//    }
//    
//    func listenOfflineSync(_ myVC:UIViewController) -> Void {
//        
//        let sync:OMCSynchronization = self.mcsSynchronization()!;
//        
//        sync.offlineResourceSynchronized { (uri, synchronizedResource) in
//            
//            if ( synchronizedResource == nil ){
//                
//                print("Offline deleted resource:", uri ?? "", " synchronized sucessfuly.");
//            }
//            else{
//                
//                let aLead:MyLead = synchronizedResource as! MyLead;
//                
//                print(aLead.hasConflicts);
//                
//                if ( aLead.hasConflicts == true ){
//                    self.handleConflictManually(myVC, aLead: aLead);
//                }
//            }
//        };
//    }
//
//    func listenCacheChanges(_ myVC:UIViewController) -> Void {
//        
//        let sync:OMCSynchronization = self.mcsSynchronization()!;
//        
//        sync.cachedResourceChanged{ (uri, synchronizedResource) in
//
//      //      if((uri?.contains("/reminders"))! && myVC.isKind(of: RemindersVC.self)){
//      //          let remindersVC:RemindersVC = (myVC as? RemindersVC)!;
//                remindersVC.aCollection = synchronizedResource as! OMCMobileObjectCollection;
//                remindersVC.arrReminders = remindersVC.aCollection.getMobileObjects();
//                remindersVC.reloadTable();
//            }
//        };
//    }
//
//    func handleConflictManually(_ myVC:UIViewController, aLead:NSObject) -> Void {
//        
//        var msgTitle:String? = "Sync Conflict-"
//        msgTitle = msgTitle?.appendingFormat("%@", aLead.name!);
//        var msg:String = "Data on the server has been updated since your last sync.\nLocal: "
//        let persistentCopy:NSDictionary? = aLead.jsonObjectPersistentState() as? NSDictionary;
//        let pDetails = persistentCopy?.object(forKey: "details") as? String;
//        msg = msg.appendingFormat("%@ \nServer: %@\n\nWould you like to update anyway (overwriting data on the server) or discard your changes?", aLead.details!, pDetails!);
//        
//        DispatchQueue.main.async{
//            
//            let alert = UIAlertController(title: msgTitle, message:msg, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
//                
//                print("Force Update")
//                self.forceUpdate(aLead);
//                
//            }));
//                
//            alert.addAction(UIAlertAction(title: "Discard", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
//                
//                print("Discard Mine")
//                aLead.reload(true, reloadFromService: true, onSuccess: { (mobileResource) in
//                    
//                })
//            }));
//            
//            myVC.present(alert, animated: true, completion: nil)
//        }
//    }
//    
//    func forceUpdate(_ aLead:MyLead) {
//        
//        // Change to client wins from preserve conflict todo force update
//        let policy:OMCSyncPolicy = aLead.getCurrentSyncPolicy();
//        policy.conflictResolution_Policy = CONFLICT_RESOLUTION_POLICY_CLIENT_WINS;
//        aLead.setSyncPolicy(policy);
//        
//        aLead.saveResource(onSuccess: { (mobileObject) in
//            
//            print("Force update success!")
//            
//            // Change the conflict resolution policy back to preserve conflict.
//            // This change takes affect on the next call to SaveResource for this object.
//            let updatedLead = mobileObject as! MyLead;
//            self.perform(#selector(MCSSyncManager.backToPreserveConflict), with: updatedLead, afterDelay: 0.01);
//            
//        }) { (error) in
//            print("Force update failed!")
//        };
//    }
//    
//    func backToPreserveConflict(_ aLead:MyLead) {
//        
//        let policy:OMCSyncPolicy = aLead.getCurrentSyncPolicy();
//        policy.conflictResolution_Policy = CONFLICT_RESOLUTION_POLICY_PRESERVE_CONFLICT;
//        aLead.setSyncPolicy(policy);
//        aLead.saveResource(onSuccess: nil, onError: nil);
//    }
//
//    func workOffline() -> Bool? {
//        return self._workOffline;
//    }
//    
//    func setWorkOffline(_ flag:Bool) -> Void {
//        self._workOffline = flag;
//    }
//    
    func isLoggedIn() -> Bool! {
        return self.loggedIn;
    }
//    
//    func setLoggedOut() {
//        self.loggedIn = false;
//    }
}
