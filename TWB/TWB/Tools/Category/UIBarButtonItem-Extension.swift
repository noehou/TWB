//
//  UIBarButtonItem-Extension.swift
//  TWB
//
//  Created by Tommaso on 2017/5/10.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName: String) {
        self.init()
        
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), for: .normal)
        btn.setImage(UIImage(named:imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        self.customView = btn
    }
}
