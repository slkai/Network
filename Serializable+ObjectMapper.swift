//
//  Serializable+ObjectMapper.swift
//  Alamofire
//
//  Created by Alan on 2018/8/2.
//

import ObjectMapper

extension Serializable where Self: Mappable {
    public init?(json: Any) {
        
        guard let json = json as? [String: Any] else {
            return nil
        }
        
        typealias T = Self
        if let object = Mapper<T>().map(JSON: json) {
            self = object
        } else {
            return nil
        }
    }
}
