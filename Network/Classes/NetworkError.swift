//
//  NetworkError.swift
//  Network
//
//  Created by Alan on 2017/12/20.
//  Copyright © 2017年 Alan. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case requestFail(desc: String?)
    case serializeFail(desc: String?)
    case phraseFail(desc: String?)
}
