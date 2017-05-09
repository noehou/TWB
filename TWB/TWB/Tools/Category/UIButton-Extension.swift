//
//  UIButton-Extension.swift
//  TWB
//
//  Created by Tommaso on 2017/5/9.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit

extension UIButton {
//    //swift中类方法是以class开头的方法，类似OC中的+开头的方法
//    class func createButton(imageName : String,bgImageName : String) -> UIButton {
//        //1、创建btn
//        let btn = UIButton();
//        
//        //2、设置btn的属性
//        
//        btn.setImage(UIImage(named:imageName), for: .normal)
//        btn.setImage(UIImage(named:imageName + "_highlighted"), for: .highlighted)
//        btn.setBackgroundImage(UIImage(named: bgImageName), for: .normal)
//        btn.setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
//        btn.sizeToFit()
//        return btn
//    }
    
    
    convenience init(imageName : String,bgImageName : String){
        self.init()
        setImage(UIImage(named:imageName), for: .normal)
        setImage(UIImage(named:imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
}
