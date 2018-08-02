//
//  Serializable.swift
//  Network
//
//  Created by Alan on 2018/7/31.
//


public protocol Serializable {
    init?(json: Any)
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
