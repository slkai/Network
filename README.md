# Network

[![CI Status](http://img.shields.io/travis/MooYoo/Network.svg?style=flat)](https://travis-ci.org/MooYoo/Network)
[![Version](https://img.shields.io/cocoapods/v/Network.svg?style=flat)](http://cocoapods.org/pods/Network)
[![License](https://img.shields.io/cocoapods/l/Network.svg?style=flat)](http://cocoapods.org/pods/Network)
[![Platform](https://img.shields.io/cocoapods/p/Network.svg?style=flat)](http://cocoapods.org/pods/Network)

## Todo List
☑️ 缓存机制
☑️ 网络请求切片代理方法
☑️ 封装高层级的Service，简化调用
按不同的数据处理方式分类：
1.无需关心返回值
2.只需要返回JSON数据
3.需要返回object
4.需要返回object array
5.可加载更多array


1.Keypath放在Requestable还是Responsable ？
2.返回对象类型放在Requestable还是Responsable ？
引出问题：如何界定请求和数据处理？
对于无需关心返回值的请求，keypath是可选的；而关心返回值得请求keypath则是必须的。

应该是都放在Responsable
当返回数据时，Requestable的职责应该已经结束
后续data如何处理，转成JSON如何处理，转成Model如何处理（keyPath + 模型类型），应该由Responsable协议决定。




## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Network is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Network'
```

## Author

MooYoo, alandeng@meijiabang.cn

## License

Network is available under the MIT license. See the LICENSE file for more info.
