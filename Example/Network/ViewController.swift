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
        
        let network = Network()
        network.delegate = self
        network.responseJSON(endPoint: IssueDataSource(), success: { (json) in
            print(json)
        }) { (error) in
            print(error)
        }
    }
    
    // 返回模型
    @IBAction func clickModel(_ sender: UIButton) {
        let network = Network()
        network.delegate = self
        network.responseObject(endPoint: IssueDataSource(), keyPath: nil, success: { (issue: Issue) in
            print(issue)
        }) { (error) in
            print(error)
        }
    }
    
    // 返回模型数组
    @IBAction func clickModels(_ sender: UIButton) {
        let network = Network()
        network.delegate = self
        network.responseArray(endPoint: IssuesDataSource(), keyPath: "issues", success: { (issues: [Issue]) in
            print(issues)
        }) { (error) in
            print(error)
        }
    }
}




extension ViewController: NetworkDelegate {
    func requestWillConvertObject(json: [String : Any]) -> [String : Any] {
        return json
    }

    func requestWillBegin(request: DataRequest) -> DataRequest {
        return request
    }

    func requestWillSerialize(data: Data) -> Data {
        return data
    }

    func requestWillConvertObject(json: [String : Any]) {

    }

    func dealWithModelsIfNeed() {

    }
}


