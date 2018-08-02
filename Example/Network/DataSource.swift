//
//  DataSource.swift
//  Network_Example
//
//  Created by Alan on 2017/12/20.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import Network
import ObjectMapper


extension Issue: Serializable {}

struct IssueDataSource: Requestable, ModelResponsable {
    
    typealias T = Issue
    
    var keyPath: String? {
        return nil
    }
    
    var URI: String {
        return "http://jira.mooyoo.com.cn/rest/api/latest/issue/MJB-4742"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String] {
        return ["Authorization":"Basic YWxhbmRlbmc6ZzRPa1lCTWQ0WHVGN0E="]
    }
    
    var parameters: [String : Any] {
        return ["fields": "*navigable"]
    }
}

struct IssuesDataSource: Requestable, ModelResponsable {
    
    typealias T = Issue
    
    var keyPath: String? {
        return "issues"
    }
    
    var URI: String {
        return "http://jira.mooyoo.com.cn/rest/api/2/search"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var headers: [String : String] {
        return ["Authorization":"Basic YWxhbmRlbmc6ZzRPa1lCTWQ0WHVGN0E="]
    }
    
    var parameters: [String : Any] {
        let jql = "project in (MJB,BOSS) AND issuetype = 子任务 AND affectedVersion = 5.7"
        return ["jql": jql, "maxResults": "5"]
    }
}
