//
//  DataSource.swift
//  Network_Example
//
//  Created by Alan on 2017/12/20.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import Network

struct IssueDataSource: Requestable {
    
    var URI: String {
        return "http://jira.mooyoo.com.cn/rest/api/latest/issue/MJB-4742"
    }
    
    var method: HttpMethod {
        return .get
    }
    
    var headers: [String : String] {
        return ["Authorization":"Basic YWxhbmRlbmc6ZzRPa1lCTWQ0WHVGN0E="]
    }
    
    var parameters: [String : Any] {
        return ["fields": "*navigable"]
    }
    
    var cache: Bool {
        return false
    }
}

struct IssuesDataSource: Requestable {
    var URI: String {
        return "http://jira.mooyoo.com.cn/rest/api/2/search"
    }
    
    var method: HttpMethod {
        return .post
    }
    
    var headers: [String : String] {
        return ["Authorization":"Basic YWxhbmRlbmc6ZzRPa1lCTWQ0WHVGN0E="]
    }
    
    var parameters: [String : Any] {
        let jql = "project in (MJB,BOSS) AND issuetype = 子任务 AND affectedVersion = 5.7"
        return ["jql": jql, "maxResults": "5"]
    }
    
    var cache: Bool {
        return false
    }
    
    
}