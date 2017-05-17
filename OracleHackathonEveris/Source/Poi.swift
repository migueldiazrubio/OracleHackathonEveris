//
//  Poi.swift
//  MCSSample
//
//  Created by MIGUEL DIAZ RUBIO on 16/5/17.
//  Copyright © 2017 everis. All rights reserved.
//

import Foundation

class Poi : NSObject {
    
    let id : Int?
    let latitude: Double?
    let longitude: Double?
    let status: String?
    let requestTimestamp: String?
    let deliveryTimestamp: String?
    let address: String?
    let deliveredBy: String?
    
    init(id: Int?, latitude: Double?, longitude: Double?, status: String?, requestTimestamp: String?, deliveryTimestamp: String?, address: String?, deliveredBy: String?) {
        
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.status = status
        self.requestTimestamp = requestTimestamp
        self.deliveryTimestamp = deliveryTimestamp
        self.address = address
        self.deliveredBy = deliveredBy
        
    }
    
}
