//
//  NetworkError.swift
//  Network
//
//  Created by Alan on 2017/12/20.
//  Copyright © 2017年 Alan. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case encodeFail(desc: String?)
    case requestFail(desc: String?)     
    case serializeFail(desc: String?)   // 序列化错误：从data到dictionary转化失败
    case phraseFail(desc: String?)      // 解析错误：从dictionary去keypath，从dictionary到模型转化失败
}
