//
//  JRNetworkTest.swift
//  Network_Example
//
//  Created by Alan on 2017/12/22.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import Network

//protocol DataSource {
//    associatedtype T: Phrasable
//    var keyPath: String {get}
//}
//
//class AnyDataSource<O: Phrasable>: DataSource {
//    typealias T = O
//    let keyPath: String
//
//    init<D: DataSource>(dataSource: D) where D.T == O {
//        keyPath = dataSource.keyPath
//    }
//}
//
//// 需要数据类型T: Phrasable -> 初始化方法传入DataSource协议的实例，DataSource协议绑定了Phrasable -> 使用DataSource协议中的Phrasable类型作为data的类型
//class AnyDataSourceService<T: Phrasable> {
//
//    private let dataSource: AnyDataSource<T>
//
//    var data: T?
//
//    init<D: DataSource>(dataSource: D) where D.T == T {
//        self.dataSource = AnyDataSource(dataSource: dataSource)
//    }
//}
//
//class AnyDataSourceService2<T: Phrasable> {
//
//    private let dataSource: DataSource
//
//    init(dataSource: DataSource) {
//        self.dataSource = dataSource
//    }
//
//}
//
//
//struct XXXDataSource: DataSource {
//    typealias T = Issue
//    var keyPath: String {
//        return "data"
//    }
//}

/*
 希望DataSource协议是泛型协议，可以直接给service使用。
 */


//struct GenericStruct<T: Codable> {
//
//}
//
//struct GenericStruct<T: UIView> {
//
//}
//
//struct GenericStruct<T: Mirror> {
//
//}


/*
 泛型：A<B>
 基础类型： A
 抽象类型： B
 
 A<B>
 A = Class, B = Class       类泛型类型(CC)
 A = Class, B = Protocol    协议泛型类型(CP)
 A = Protocol, B = Class    类泛型协议(PC)
 A = Protocol, B = Protocol 协议泛型协议(PP)
 
 普通类型：NormalClass
 普通协议：NormalProtocol
 
 */

class NormalClass {}
protocol NormalProtocol {}

class GenericClsClass<T: NormalClass> {}
class GenericProClass<T: NormalProtocol> {}

protocol GenericClsProtocol {associatedtype T = NormalClass}
protocol GenericProProtocol {associatedtype T = NormalProtocol}

/*
 消费
 1.属性
 2.方法参数
 3.方法返回值
 */

class Comsumer1 {
    var property: NormalClass?
    func comsume(params: NormalClass) -> NormalClass {return params}
}

class Comsumer2 {
    var property: NormalProtocol?
    func comsume(params: NormalProtocol) -> NormalProtocol {return params}
}

//class Comsumer3 {
//    var property: GenericClsClass?
//    func comsume(params: GenericClsClass) -> GenericClsClass {return params}
//}
//
//class Comsumer4 {
//    var property: GenericProClass?
//    func comsume(params: GenericProClass) -> GenericProClass {return params}
//}
//
//class Comsumer5 {
//    var property: GenericClsProtocol?
//    func comsume(params: GenericClsProtocol) -> GenericClsProtocol {return params}
//}
//
//class Comsumer6 {
//    var property: GenericProProtocol?
//    func comsume(params: GenericProProtocol) -> GenericProProtocol {return params}
//}

// 如何消费泛型类型？
class ComsumerRight3<T, G: GenericClsClass<T>> {
    var property1: T?
    var property2: G?
    func comsume1(params: T) -> T {return params}
    func comsume2(params: G) -> G {return params}
}

class ComsumerRight4<T, G: GenericProClass<T>> {
    var property1: T?
    var property2: G?
    func comsume1(params: T) -> T {return params}
    func comsume2(params: G) -> G {return params}
}

// 如何消费泛型协议？
class ComsumerRight5<G: GenericClsProtocol> {
    var property1: G?
    var property2: G.T?
    func comsume1(params: G) -> G {return params}
    func comsume2(params: G.T) -> G.T {return params}
}

class ComsumerRight6<G: GenericProProtocol> {
    var property1: G?
    var property2: G.T?
    func comsume(params: G) -> G {return params}
    func comsume(params: G.T) -> G.T {return params}
}

// 问题：只能够在创建Comsumer时明确指定类型吗？能不能初始化时根据参数来类型推断？

class Comsumer7<T, G: GenericClsClass<T>> {
    var property1: T?
    var property2: G?
    func comsume1(params: T) -> T {return params}
    func comsume2(params: G) -> G {return params}
    
    // Error 编译时：Reference to generic type 'GenericClsClass' requires arguments in <...>
//    init(data: GenericClsClass) {}
    
    init(data: G) {}

    // Error 编译时：Constructing an object of class type 'T' with a metatype value must use a 'required' initializer
    //        self.property1 = T()
    //        self.property2 = G()
    
}

class Comsumer8<T, G: GenericProClass<T>> {
    var property1: T?
    var property2: G?
    func comsume1(params: T) -> T {return params}
    func comsume2(params: G) -> G {return params}
    
    init(data: G) {}
}

class Comsumer9<G: GenericClsProtocol> {
    var property1: G?
    var property2: G.T?
    func comsume1(params: G) -> G {return params}
    func comsume2(params: G.T) -> G.T {return params}
    
    init(data: G) {}
}

class Comsumer10<G: GenericProProtocol> {
    var property1: G?
    var property2: G.T?
    func comsume(params: G) -> G {return params}
    func comsume(params: G.T) -> G.T {return params}
    
    init(data: G) {}
    
    // Error1: 编译时出现Protocol 'GenericProProtocol' can only be used as a generic constraint because it has Self or associated type requirements
    //    init(data: GenericProProtocol) {
    //
    //    }
    
    // Error2: 调用时出现Generic parameter 'G' could not be inferred
    //    init<D: GenericProProtocol>(data: D) {
    //
    //    }
    
    // Error3: 编译时出现Same-type requirement makes generic parameters 'D' and 'G' equivalent
    //    init<D: GenericProProtocol>(data: D) where D == G {
    //
    //    }
}


// 只想消费A<B>中的B

// 消费CC的B(not work)
class Comsumer11<T: NormalClass> {
    
    var property: T?
    
    /*
     无法约束泛型的类型，但是可以约束泛型协议的类型
     https://stackoverflow.com/questions/40941566/why-can-i-make-same-type-requirement-in-swift-with-generics-is-there-any-way
     */
    
    // Same-type requirement makes generic parameters 'P' and 'T'
//    init<P,D: GenericClsClass<P>>(data: D) where P == T {
//
//    }
    
}

// 消费CP的B
class Comsumer12<T: NormalProtocol> {
   // 同上
}


// 消费PC的B
class Comsumer13<T: NormalClass> {
    
//    var property: T
    
    // 需要Require init
    // Constructing an object of class type 'T' with a metatype value must use a 'required' initializer
//    init<D: GenericClsProtocol>(data: D) where D.T == T {
//        self.property = T()
//    }
}

// 消费PP的B

class Comsumer15<P: NormalProtocol> {
    var property: P?
    init<D: GenericProProtocol>(data: D) where D.T == P {
        
    }
}

class Comsumer14<P: NormalProtocol> {
    
    private var normalProClass: AnyNormalProtocolClass<P>
//    var property: P
    
    init<D: GenericProProtocol>(data: D) where D.T == P {
        self.normalProClass = AnyNormalProtocolClass()
//        self.property =   由于P是协议，不是具体的类型，需要其他方法来初始化。
    }
}

class AnyNormalProtocolClass<T: NormalProtocol>: GenericProProtocol {
    
}


//class AnyDataSourceService<T: Phrasable> {
//
//    private let dataSource: AnyDataSource<T>
//
//    var data: T?
//
//    init<D: DataSource>(dataSource: D) where D.T == T {
//        self.dataSource = AnyDataSource(dataSource: dataSource)
//    }




