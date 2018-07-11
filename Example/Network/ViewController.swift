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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let data1 = GenericClsClass()
        let comsumer1 = Comsumer7(data: data1)
        
        let data2 = GenericProClass<NormalProtocolStruct>()
        let comsumer2 = Comsumer8(data: data2)
        
        let data3 = GenericClsProtocolStruct()
        let comsumer3 = Comsumer9(data: data3)
        
        let data4 = GenericProProtocolStruct()
        let comsumer4 = Comsumer10(data: data4)
        
    }
}

struct GenericClsProtocolStruct: GenericClsProtocol {
    typealias T = NormalClass
}

struct GenericProProtocolStruct: GenericProProtocol {
    typealias T = NormalProtocolStruct
}

struct NormalProtocolStruct: NormalProtocol {
    
}


extension ViewController: NetworkDelegate {
    
}

protocol Shootable {
    
}

protocol Targetable {
    associatedtype S = Shootable
    
    
}

struct AnyTargetable<Element>: Targetable {
    typealias S = Element
    init<T: Targetable>(data: T) where T.S == Element {
        
    }
}

class Target<Element> {
    
    var data: AnyTargetable<Element>
    var element: Element
    
    init<T: Targetable>(t: T) where T.S == Element {
        self.data = AnyTargetable(data: t)
    }
}

struct Tree: Shootable {}

struct TreeTarget: Targetable {
    typealias S = Tree
}



