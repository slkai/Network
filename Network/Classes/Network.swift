//
//  Network.swift
//  Network
//
//  Created by Alan on 2017/12/20.
//  Copyright © 2017年 Alan. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper.Swift

// FIXME: 外部import A, A import B, 如何让外部调用 B的API?
public typealias HttpMethod = Alamofire.HTTPMethod
public typealias Phrasable = ObjectMapper.Mappable
public typealias DataRequest = Alamofire.DataRequest
public typealias Map = ObjectMapper.Map

// MARK: Requestable
public protocol Requestable {
    var URI: String {get}
    var method: HttpMethod {get}
    var headers: [String:String] {get}
    var parameters: [String:Any] {get}
    var encoding: ParametersEncoding {get}
    var cache: Bool {get}
}

public extension Requestable {
    
    var method: HttpMethod {
        return .get
    }
    
    var headers: [String:String] {
        return [:]
    }
    
    var parameters: [String:Any] {
        return [:]
    }
    
    // GET方式使用URLEncode, 其他方法使用JSONEncode
    var encoding: ParametersEncoding {
        return method == .get ? .url : .json
    }
    
    var cache: Bool {
        return false
    }
}

public enum ParametersEncoding {
    case url
    case json
    
    var encoder: ParameterEncoding {
        switch self {
        case .url:
            return URLEncoding.default
        case .json:
            return JSONEncoding.default
        }
    }
}


// MARK: NetworkDelegate
public protocol NetworkDelegate: class {
    
    func requestWillSetHeaders(headers: [String: String]?) -> [String: String]?
    func requestWillSetParameters(parameters:[String: Any]) -> [String: Any]
    func requestWillBegin(request: DataRequest) -> DataRequest                 // 即将开始发送请求
    func requestWillPhrase(json: [String: Any]) -> [String: Any]               // 即将转成模型
    func requestWillReturnModel<T:Phrasable>(data: T) -> T                     // 对模型进行处理再返回
    func requestWillReturnArray<T:Phrasable>(data: [T]) -> [T]                 // 对模型数组进行处理再返回
}

public extension NetworkDelegate {
    func requestWillSetHeaders(headers: [String: String]?) -> [String: String]? {return headers}
    func requestWillSetParameters(parameters:[String: Any]) -> [String: Any] {return parameters}
    func requestWillBegin(request: DataRequest) -> DataRequest {return request}
    func requestWillPhrase(json: [String: Any]) -> [String: Any] {return json}
    func requestWillReturnModel<T:Phrasable>(data: T) -> T {return data}
    func requestWillReturnArray<T:Phrasable>(data: [T]) -> [T] {return data}
}


// MARK: Network
public class Network {

    static let queue = DispatchQueue(label: "Network Handler Queue")
    static let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()
    
    public weak var delegate: NetworkDelegate?
    
    public init(delegate: NetworkDelegate? = nil) {
        self.delegate = delegate
    }
    
    public func responseJSON(endPoint: Requestable, success: ((_ JSON: [String: Any]) -> Void)?, failure: ((_ error: Error) -> Void)?) {
        
        let request = Network.sessionManager.request(endPoint.URI, method: endPoint.method, parameters: endPoint.parameters, encoding: endPoint.encoding.encoder, headers: endPoint.headers)
        let newRequest = delegate?.requestWillBegin(request: request) ?? request
        
        newRequest.responseJSON(queue: Network.queue, options: .allowFragments) { (response) in
            
            // 返回JSON失败
            guard response.error == nil else {
                failure?(response.error!)
                return
            }
            
            // 返回的不是json
            guard let json = response.value as? [String: Any] else {
                failure?(NetworkError.serializeFail(desc: nil))
                return
            }
            
            success?(json)
        }
    }
    
    public func responseObject<T: Phrasable>(endPoint: Requestable, keyPath: String?, success: ((_ obj: T) -> Void)?, failure: ((_ error: Error) -> Void)?) {
        
        responseJSON(endPoint: endPoint, success: { (json) in
            
            var JSON: Any = json
            if let keyPath = keyPath, keyPath.isEmpty == false {
                guard let jsonObject = json[keyPath] else {
                    failure?(NetworkError.phraseFail(desc: "Keypath error!"))
                    return
                }
                JSON = jsonObject
            }
            
            guard let object = Mapper<T>(context: nil, shouldIncludeNilValues: false).map(JSONObject: JSON) else {
                failure?(NetworkError.phraseFail(desc: "Phrase Error!"))
                return
            }
            
            success?(object)
            
        }, failure: failure)
    }
    
    public func responseArray<T: Phrasable>(endPoint: Requestable, keyPath: String?, success: ((_ objs: [T]) -> Void)?, failure: ((_ error: Error) -> Void)?) {
        
        responseJSON(endPoint: endPoint, success: { (json) in
            
            var JSON: Any = json
            if let keyPath = keyPath, keyPath.isEmpty == false {
                guard let jsonObject = json[keyPath] else {
                    failure?(NetworkError.phraseFail(desc: "Keypath error!"))
                    return
                }
                JSON = jsonObject
            }
            
            guard let objects = Mapper<T>(context: nil, shouldIncludeNilValues: false).mapArray(JSONObject: JSON) else {
                failure?(NetworkError.phraseFail(desc: "Phrase Error!"))
                return
            }
            success?(objects)
            
        }, failure: failure)
    }
}
