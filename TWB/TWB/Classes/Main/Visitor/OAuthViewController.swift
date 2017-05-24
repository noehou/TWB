//
//  OAuthViewController.swift
//  TWB
//
//  Created by Tommaso on 2017/5/11.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit
import SVProgressHUD
class OAuthViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        loadPage()
    }
}

 //MARK:- 设置UI界面相关

extension OAuthViewController {
    func setupNavigationBar(){
        //1、设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeItemClick))
        
        //2、设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(fillItemClick))
        //3、设置标题
        title = "登陆页面"
        
    }
    
    
    func loadPage(){
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = NSURLRequest(url: url)
        
        webView.loadRequest(request as URLRequest)
    }
}


 //MARK:- 事件监听函数
extension OAuthViewController {
    func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    
    func  fillItemClick() {
        let jsCode = "document.getElementById('userId').value='750871487@qq.com';document.getElementById('passwd').value='750871hou';"
        
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}

 //MARK:- wenViewdelegate
extension OAuthViewController  : UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let url = request.url else {
            return true
        }
        
        let urlString = url.absoluteString
        
        guard urlString.contains("code=") else {
            return true
        }
        
        let code = urlString.components(separatedBy: "code=").last!
        
        loadAccessToken(code: code)
        return false
    }
}


 //MARK:- 请求数据
extension OAuthViewController {
    
    func loadAccessToken(code : String){
        TNetworkTool.shareInstance.loadAccessToken(code: code) { (response, err) in
            if err != nil {
                print(err!)
                return
            }
            
            guard let accountDict = response else {
                print("没有授权后的数据")
                return
            }
            
            let account = UserAccount(dict: accountDict)
            
            //请求用户信息
            self.loadUserInfo(account: account)
        }
    }
    
    func loadUserInfo(account : UserAccount){
        guard let accessToken = account.access_token else {
            return
        }
        
        guard let uid = account.uid else {
            return
        }
        
        TNetworkTool.shareInstance.loadUserInfo(access_token: accessToken, uid: uid) { (response, err) in
            if err != nil {
                print(err)
                return
            }
            
            guard let userInfoDict = response else {
                return
            }
            
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
            
            //4、将account对象保存
            //4.1获取沙盒路径
            
            var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            accountPath = (accountPath! as NSString).strings(byAppendingPaths: ["accout.plist"]).first
          
            //4.2 保存对象
            NSKeyedArchiver.archiveRootObject(account, toFile: accountPath!)
            //5、将account对象设置到单例对象中
            UserAccountViewModel.shareIntance.account = account
            //6、退出当前控制器
            self.dismiss(animated: false, completion: {
              UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
            })
        
        }
    }
}
