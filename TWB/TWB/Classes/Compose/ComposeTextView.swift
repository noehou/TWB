//
//  ComposeTextView.swift
//  TWB
//
//  Created by Tommaso on 2017/5/23.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit
import SnapKit
class ComposeTextView: UITextView {
     //MARK:- 懒加载属性
    lazy var placeHolderLabel :UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }

}

// //MARK:- 设置UI界面
extension ComposeTextView {
    func setupUI(){
        //1、添加子控件
        addSubview(placeHolderLabel)
        //2、设置frame
        placeHolderLabel.snp_makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        
        //3、设置placeholderlabel属性
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = font
        
        //4、设置placeholderlabel的文字
        placeHolderLabel.text = "分享新鲜事..."
        //5、设置内容的内边距
        textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}
