//
//  UserAccount.swift
//  TWB
//
//  Created by Tommaso on 2017/5/11.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit

class UserAccount: NSObject,NSCoding{
    var access_token : String?
    var expires_in : TimeInterval = 0.0{
        didSet {
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    var uid : String?
    var expires_date : NSDate?
    
    var screen_name : String?
    var avatar_large :String? 
    
    init(dict : [String : Any]){
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
     //MARK:- 重写description属性
    override var description: String{
        return dictionaryWithValues(forKeys: ["access_token","expires_date","screen_name","avatar_large"]).description
    }
    
     //MARK:- 归档解档
    //解档的方法
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? NSDate
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
    
    //归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
}
