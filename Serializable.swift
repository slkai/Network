//
//  Serializable.swift
//  Network
//
//  Created by Alan on 2018/7/31.
//

import ObjectMapper

// MARK: Serializable
public protocol Serializable {
    init?(json: Any)
}

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

extension Int: Serializable {
    
    public init?(json: Any) {
        
        if let value = json as? NSNumber {
            self = value.intValue
        } else if let object = json as? String, let value = Int(object) {
            self = value
        } else {
            return nil
        }
    }
}

extension Double: Serializable {
    
    public init?(json: Any) {
        
        if let value = json as? NSNumber {
            self = value.doubleValue
        } else if let object = json as? String, let value = Double(object) {
            self = value
        } else {
            return nil
        }
    }
}

extension String: Serializable {
    
    public init?(json: Any) {
        
        if let object = json as? String {
            self = object
        } else {
            return nil
        }
    }
}

extension Bool: Serializable {
    public init?(json: Any) {
        if let object = json as? Bool {
            self = object
        } else {
            return nil
        }
    }
}

extension Dictionary: Serializable {
    
    public init?(json: Any) {
        
        guard let json = json as? Dictionary<Key, Value> else {
            return nil
        }
        
        self = json
    }
}
