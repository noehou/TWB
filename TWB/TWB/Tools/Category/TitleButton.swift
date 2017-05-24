//
//  TitleButton.swift
//  TWB
//
//  Created by Tommaso on 2017/5/10.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
     //MARK:-重写init函数
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        setImage(UIImage(named:"navigationbar_arrow_down"), for: .normal)
        setImage(UIImage(named:"navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //oc 写法
//        var rect = titleLabel!.frame
//        rect.origin.x = 0
//        titleLabel!.frame = rect
        //swift写法
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.size.width)! + 5
        
    }
}
