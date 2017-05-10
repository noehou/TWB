//
//  BaseViewController.swift
//  TWB
//
//  Created by Tommaso on 2017/5/9.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
 //MARK:- 懒加载属性
    lazy var visitorView : VisitorView = VisitorView.visitorView()
     //MARK:-定义变量
    var isLogin : Bool = true
     //MARK:- 系统会调函数
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
         isLogin ? super.loadView() :setupNavigationItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

 //MARK:-设置UI界面

extension BaseViewController {
    ///设置访客视图
    func setupVisitorView(){
        view = visitorView
        visitorView.registerBtn.addTarget(self, action: #selector(registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
    }
    
    ///设置导航栏左右的Item
    func setupNavigationItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(loginBtnClick))
    }
}

//MARK:- 事件监听

extension BaseViewController {
    func registerBtnClick() {
        print("registerBtnClick")
    }
    func loginBtnClick() {
        print("loginBtnClick")
    }
}
