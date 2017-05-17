//
//  MCSService.swift
//  MCSSample
//
//  Created by MIGUEL DIAZ RUBIO on 16/5/17.
//  Copyright © 2017 everis. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class MCSService {
    
    init() { }
    
    static let shared = MCSService()
    
    let headers: HTTPHeaders = [
        "Authorization": "Basic R1NFMDAwMTAxNjFfTUNTX01PQklMRV9BTk9OWU1PVVNfQVBQSUQ6Sm1xZnRfbnV5djV3NmM=",
        "oracle-mobile-backend-id": "0bb883d4-91b0-4347-9f3f-771568aea5d6"
    ]
    
    func findAll(completion: @escaping (_ result: [Poi]?)->Void) {
        
        Alamofire.request("https://mcs-gse00010161.mobileenv.us2.oraclecloud.com:443/mobile/custom/apiDefinitivaEveris/allPoints", headers: headers).responseJSON { response in
            
            if((response.result.value) != nil) {
                
                var points = [Poi]()
                
                let data = JSON(response.result.value!)["pointofinterest"].arrayValue
                
                for point in data {
                    let poi = Poi(identificator: point["id"].intValue, latitude: point["latitude"].string, longitude: point["longitude"].string, status: point["status"].string, requestTimestamp: point["requestTimestamp"].string, deliveryTimestamp: point["deliveryTimestamp"].string, address: point["address"].string, deliveredBy: point["deliveredBy"].string)
                    points.append(poi)
                }
                
                completion(points)
            }
        }
        
    }
    
    func modifyPoi(poi: Poi, completion: @escaping (_ success: Bool)->Void) {
        
        let params : Parameters = [
            "Id": poi.identificator ?? "",
            "Latitude": poi.latitude ?? "",
            "Longitude": poi.longitude ?? "",
            "Status": poi.status ?? "",
            "RequestTimestamp": poi.requestTimestamp ?? "",
            "DeliveryTimestamp": poi.deliveryTimestamp ?? "",
            "Address": poi.address ?? "",
            "DeliveredBy": poi.deliveredBy ?? ""
        ]
        
        Alamofire.request("", method: .put, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            if let _ = response.result.error {
                completion(false)
            } else {
                completion(true)
            }
            
        }
        
    }
    
    func insertPoi(poi: Poi, completion: @escaping (_ success: Bool)->Void) {
        
        let params : Parameters = [
            "Id": poi.identificator ?? "",
            "Latitude": poi.latitude ?? "",
            "Longitude": poi.longitude ?? "",
            "Status": poi.status ?? "",
            "RequestTimestamp": poi.requestTimestamp ?? "",
            "DeliveryTimestamp": poi.deliveryTimestamp ?? "",
            "Address": poi.address ?? "",
            "DeliveredBy": poi.deliveredBy ?? ""
        ]
        
        Alamofire.request("", method: .put, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            if let _ = response.result.error {
                completion(false)
            } else {
                completion(true)
            }
            
        }
        
    }
    
}
