//
//  MainViewController.swift
//  TWB
//
//  Created by Tommaso on 2017/5/9.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    //MARK:-懒加载属性
    lazy var composeBtn:UIButton = UIButton(imageName: "tabbar_compose_icon_add",bgImageName:"tabbar_compose_button")
    
     //MARK:-系统回调函数

    override func viewDidLoad() {
        super.viewDidLoad()
        setupComposeBtn()
    }

}

 //MARK:- 设置UI界面
extension MainViewController{
    ///设置发布按钮
  func setupComposeBtn(){
        //1、将composeBtn添加到tabbar中
        tabBar.addSubview(composeBtn)
        //3、设置位置
        composeBtn.center =  CGPoint.init(x:tabBar.center.x,y:tabBar.bounds.size.height * 0.5)
    }
    /*
    ///调整tabbar中的item
    func setupTabbarItems(){
        //1、遍历所有的item
        for i in 0..<tabBar.items!.count {
            //2、获取item
            let item = tabBar.items![i]
            
            //3、如果下标值为2，则该item不可以和用户交互
            if i == 2 {
                item.isEnabled = false
                continue
            }
            //4、设置其他item的选中时候的图片
            //item.selectedImage = UIImage(named: imageNames[i] + "_highlighted")
        }
    }
 */
}
