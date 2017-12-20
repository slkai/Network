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
        
        Network(delegate: self).responseJSON(endPoint: IssueDataSource(), success: { (json) in
            print(Thread.current)
            print(json)
        }) { (error) in
            print(error)
        }
    }
    
    // 返回模型
    @IBAction func clickModel(_ sender: UIButton) {
        Network(delegate: self).responseObject(endPoint: IssueDataSource(), keyPath: nil, success: { (issue: Issue) in
            print(Thread.current)
            print(issue)
        }) { (error) in
            print(error)
        }
    }
    
    // 返回模型数组
    @IBAction func clickModels(_ sender: UIButton) {
        Network(delegate: self).responseArray(endPoint: IssuesDataSource(), keyPath: "issues", success: { (issues: [Issue]) in
            print(Thread.current)
            print(issues)
        }) { (error) in
            print(error)
        }
    }
}




extension ViewController: NetworkDelegate {
    
    
}


