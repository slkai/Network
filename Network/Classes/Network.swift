//
//  Network.swift
//  Network
//
//  Created by Alan on 2017/12/20.
//  Copyright © 2017年 Alan. All rights reserved.
//

import Foundation
import Alamofire

// FIXME: 外部import A, A import B, 如何让外部调用 B的API?
public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias DataRequest = Alamofire.DataRequest


// MARK: Requestable
public protocol Requestable {
    var URI: String {get}
    var method: HTTPMethod {get}
    var headers: [String:String] {get}
    var parameters: [String:Any] {get}
    var encoding: ParametersEncoding {get}
}

public extension Requestable {
    var method: HTTPMethod {return .get}
    var headers: [String:String] {return [:]}
    var parameters: [String:Any] {return [:]}
    var encoding: ParametersEncoding {
        // GET方式使用URLEncode, 其他方法使用JSONEncode
        return method == .get ? .url : .json
    }
}

public enum ParametersEncoding {
    case url
    case json
    
    var encoder: ParameterEncoding {
        switch self {
        case .url: return URLEncoding.default
        case .json: return JSONEncoding.default
        }
    }
}

// MARK: Responsable
public protocol Responsable {
    var keyPath: String? {get}
}

extension Responsable {
    public var keyPath: String? {return nil}
}

public protocol ModelResponsable: Responsable {
    associatedtype T: Serializable
}


// MARK: NetworkDelegate
public protocol NetworkDelegate: class {
    // TODO: 加一个修改endPoint的方法？
    func requestWillSetHeaders(headers: [String: String]?) -> [String: String]?
    func requestWillSetParameters(parameters:[String: Any]) -> [String: Any]
    func requestWillBegin(request: DataRequest) -> DataRequest                 // 即将开始发送请求
    func requestWillPhrase(json: [String: Any]) -> [String: Any]               // 即将转成模型
    func requestWillReturnModel<T:Serializable>(data: T) -> T                     // 对模型进行处理再返回
    func requestWillReturnArray<T:Serializable>(data: [T]) -> [T]                 // 对模型数组进行处理再返回
}

public extension NetworkDelegate {
    func requestWillSetHeaders(headers: [String: String]?) -> [String: String]? {return headers}
    func requestWillSetParameters(parameters:[String: Any]) -> [String: Any] {return parameters}
    func requestWillBegin(request: DataRequest) -> DataRequest {return request}
    func requestWillPhrase(json: [String: Any]) -> [String: Any] {return json}
    func requestWillReturnModel<T:Serializable>(data: T) -> T {return data}
    func requestWillReturnArray<T:Serializable>(data: [T]) -> [T] {return data}
}


// MARK: Network
public class Network: NetworkDelegate {

    static let queue = DispatchQueue(label: "Network Handler Queue")
    static let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()
    
    public weak var delegate: NetworkDelegate?
    
    public init(delegate: NetworkDelegate? = nil) {
        if delegate == nil {
            self.delegate = self
        } else {
            self.delegate = delegate
        }        
    }
    
    public func responseJSON(requestable: Requestable, success: ((_ JSON: [String: Any]) -> Void)?, failure: ((_ error: Error) -> Void)?) {
        
        let request = Network.sessionManager.request(requestable.URI, method: requestable.method, parameters: requestable.parameters, encoding: requestable.encoding.encoder, headers: requestable.headers)
        let newRequest = delegate?.requestWillBegin(request: request) ?? request
        
        newRequest.responseJSON(queue: Network.queue, options: .allowFragments) { (response) in
            
            // 返回JSON失败
            guard response.error == nil else {failure?(response.error!); return}
            
            // 返回的不是json
            guard let json = response.value as? [String: Any] else {failure?(NetworkError.serializeFail(desc: nil)); return}
            
            OperationQueue.main.addOperation {
                success?(json)
            }
        }
    }
    
    
    public func responseObject<R: ModelResponsable>(requestable: Requestable,
                                                     responsable: R,
                                                     success: ((_ obj: R.T) -> Void)?,
                                                     failure: ((_ error: Error) ->Void)?) {

        responseJSON(requestable: requestable, success: { json in
            
            var JSON: Any = json
            
            if let keypath = responsable.keyPath, !keypath.isEmpty {
                guard let jsonObject = json[keypath] as? [String: Any] else {
                    failure?(NetworkError.phraseFail(desc: "KeyPath error!"))
                    return
                }
                JSON = jsonObject
            }

            guard let object = R.T(json: JSON) else {
                failure?(NetworkError.phraseFail(desc: "Phrase Error!"))
                return
            }
            
            OperationQueue.main.addOperation {
                success?(object)
            }
            
        }, failure: failure)
    }
    
    
    public func responseArray<R: ModelResponsable>(requestable: Requestable,
                                                   responsable: R,
                                                   success: ((_ objs: [R.T]) -> Void)?,
                                                   failure: ((_ error: Error) ->Void)?) {
        
        responseJSON(requestable: requestable, success: { json in
            
            var JSON: Any = json
            
            if let keypath = responsable.keyPath, !keypath.isEmpty {
                guard let jsonObject = json[keypath] else {
                    failure?(NetworkError.phraseFail(desc: "KeyPath error!"))
                    return
                }
                JSON = jsonObject
            }
            
            guard let jsons = JSON as? Array<[String: Any]> else {
                failure?(NetworkError.phraseFail(desc: "Not an array!"))
                return
            }
            
            let objects = jsons.compactMap({R.T(json: $0)})
            
            OperationQueue.main.addOperation {
                success?(objects)
            }
            
        }, failure: failure)
    }
}
