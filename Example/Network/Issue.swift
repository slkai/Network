//
//  Issue.swift
//  Network
//
//  Created by Alan on 2017/12/20.
//  Copyright © 2017年 Alan. All rights reserved.
//

import ObjectMapper

class Issue: Mappable {
    
    var id: String = ""
    var key: String = ""
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        id <- map["id"]
        key <- map["key"]
    }
}
