//
//  UserAccountTool.swift
//  TWB
//
//  Created by Tommaso on 2017/5/12.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit

class UserAccountViewModel {
     //MARK:- 将类设计成单例
    static let shareIntance : UserAccountViewModel = UserAccountViewModel()
     //MARK:- 定义属性
    var account : UserAccount?
     //MARK:- 计算属性
    var accountPath : String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        
        return (accountPath! as NSString).strings(byAppendingPaths: ["accout.plist"]).first!
    }
    
    var isLogin : Bool {
        if account == nil {
            return false
        }
        
        guard let expiresDate = account?.expires_date else {
            return false
        }
        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
    }
    
    
    
    //MARK:- 重写init（）函数
    init() {
        //1、从沙盒中读取归档的信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
    
}
