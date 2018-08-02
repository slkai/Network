//
//  ViewController.swift
//  Network
//
//  Created by Alan on 2017/12/19.
//  Copyright © 2017年 Alan. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController {
    
    // 返回JSON
    @IBAction func clickJSON(_ sender: UIButton) {
        Network().responseJSON(requestable: IssueDataSource(), success: { (json) in
            print(Thread.current)
            print(json)
        }) { (error) in
            print(error)
        }
    }
    
    // 返回模型
    @IBAction func clickModel(_ sender: UIButton) {
        
        let dataSource = IssueDataSource()
        Network().responseObject(requestable: dataSource, responsable: dataSource, success: { data in
            print(data.key)
        }) { (error) in
            
        }
    }
    
    // 返回模型数组
    @IBAction func clickModels(_ sender: UIButton) {
        let dataSource = IssuesDataSource()
        Network().responseArray(requestable: dataSource, responsable: dataSource, success: { issues in
            print(issues.count)
        }) { (error) in
            print(error)
        }
        
        
//        Network().responseArray(endPoint: IssuesDataSource(), keyPath: "issues", success: { (issues: [Issue]) in
//            print(Thread.current)
//            print(issues)
//        }) { (error) in
//            print(error)
//        }
    }
}


// MARK: Network
class NetworkDemo {
    // 1.基本请求
    
    // 2.更改header(全局+单个请求)
    
    // 3.更改params(全局+单个请求)
    
    // 4.更改请求(全局+单个：修改URL)
    
    // 5.编码
    
    // 6.data序列化json
    
    // 7.json转模型
    
    // 8.json转模型数组
    
    // 9.失败重发机制
}


// MARK: Alamofire
class AlamofireDemo {
    
}

// MARK: System
class SystemDemo: NSObject {
    func sendRequest() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        
        let url = URL(string: "http://111.230.185.56:8000/update")!
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
//        request.addValue("Basic YWxhbmRlbmc6ZzRPa1lCTWQ0WHVGN0E=", forHTTPHeaderField: "Authorization")
        
        let urlTask = session.dataTask(with: url)
        let requestTask = session.dataTask(with: request)
        
        urlTask.resume()
        requestTask.resume()
        
    }
}

extension SystemDemo: URLSessionDelegate {
    
}

extension SystemDemo: URLSessionDataDelegate {
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("请求失败：\(error)")
        } else {
            print("请求完成：\(task.taskIdentifier)")
        }
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print(session)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("didReceive data: \(data)")
        let cache = URLCache.shared.cachedResponse(for: dataTask.currentRequest!)
        print(cache)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("didReceive response: \(response)")
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        print("cache")
    }
}



