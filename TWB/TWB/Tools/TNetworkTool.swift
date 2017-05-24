//
//  TNetworkTool.swift
//  TWB
//
//  Created by Tommaso on 2017/5/11.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit

import AFNetworking

enum TRequestType {
    case Get
    case Post
}

class TNetworkTool: AFHTTPSessionManager {
    
    static let shareInstance : TNetworkTool = {
        let toolInstance = TNetworkTool()
        toolInstance.responseSerializer.acceptableContentTypes?.insert("text/html")
        toolInstance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return toolInstance
    }()
    
    // 将成功和失败的回调写在一个逃逸闭包中
    func request(requestType : TRequestType, url : String, parameters : [String : Any], resultBlock : @escaping([String : Any]?, Error?) -> ()) {
        
        // 成功闭包
        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
            resultBlock(responseObj as? [String : Any], nil)
        }
        
        // 失败的闭包
        let failureBlock = { (task: URLSessionDataTask?, error: Error) in
            resultBlock(nil, error)
        }
        
        // Get 请求
        if requestType == .Get {
            get(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
        
        // Post 请求
        if requestType == .Post {
            post(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
    }
    
    // 将成功和失败的回调分别写在两个逃逸闭包中
    func request(requestType : TRequestType, url : String, parameters : [String : Any], succeed : @escaping([String : Any]?) -> (), failure : @escaping(Error?) -> ()) {
        
        // 成功闭包
        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
            succeed(responseObj as? [String : Any])
        }
        
        // 失败的闭包
        let failureBlock = { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        
        // Get 请求
        if requestType == .Get {
            get(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
        
        // Post 请求
        if requestType == .Post {
            post(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
    }
}

extension TNetworkTool {
    func loadAccessToken(code : String,finished : @escaping([String : Any]?,Error?) -> ()){
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id" : app_key,"client_secret":app_secret,"grant_type":"authorization_code","code":code,"redirect_uri" : redirect_uri]
        request(requestType: .Post, url: urlString, parameters: parameters) { (response, err) in
            
                finished(response, err)
            
        }
        
    }
}


extension TNetworkTool {
    func loadUserInfo(access_token : String,uid : String,finished : @escaping([String : Any]?,Error?) -> ()){
        let urlString = "https://api.weibo.com/2/users/show.json"
        let parmeters = ["access_token":access_token,"uid" : uid]
        
        request(requestType: .Get, url: urlString, parameters: parmeters) { (response, err) in
            finished(response,err) 
        }
    }
}
 //MARK:-请求首页数据
extension TNetworkTool {
    func loadStatuses(since_id : Int,max_id : Int,finished:@escaping([[String : Any]]?,Error?) -> ()){
        //1、获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        //        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json?access_token=2.00B7bb_Cbnvd4B6c2e0881c4ZqnvxD"
        //2、获取请求的参数
        let accessToken = UserAccountViewModel.shareIntance.account?.access_token
        let parameters = ["access_token" : accessToken,"since_id" : "\(since_id)","max_id" : "\(max_id)"];
        //3、发送网络请求
        request(requestType: .Get, url: urlString, parameters: parameters) { (response, error) in
            //1获取字典的数据
            guard response != nil else {
                finished(nil, error)
                return
            }
            //2、将数组数据回调给外界控制器
            finished(response?["statuses"] as? [[String : Any]], error)
            
        }
    }
}








