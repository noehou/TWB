//
//  HomeViewController.swift
//  TWB
//
//  Created by Tommaso on 2017/5/9.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
     //MARK:- 属性
    var isPresented : Bool = false
 //MARK:-懒加载
    lazy var titleBtn : TitleButton = TitleButton()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        //1、没有登录时设置的内容
         visitorView.addRotationAnim()
        if !isLogin {
            return
        }
        //2、设置导航栏的内容
        setupNavigationBar()
    }
}

 //MARK:-  设置UI界面
extension HomeViewController {
    func setupNavigationBar() {
        //1、设置左侧的Item
//        let leftBtn = UIButton()
//        leftBtn.setImage(UIImage(named:"navigationbar_friendattention"), for: .normal)
//        leftBtn.setImage(UIImage(named:"navigationbar_friendattention_highlighted"), for: .highlighted)
//        leftBtn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        //2、设置右侧的item
//        let rightBtn = UIButton()
//        rightBtn.setImage(UIImage(named:"navigationbar_pop"), for: .normal)
//        rightBtn.setImage(UIImage(named:"navigationbar_pop_highlighted"), for: .highlighted)
//        rightBtn.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        //3、设置titleView
        titleBtn.setTitle("侯侯Tony", for: .normal)
        titleBtn.addTarget(self, action:#selector(titleBtnClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
}

 //MARK:- 事件监听的函数
extension HomeViewController {
    func titleBtnClick(titleBtn : TitleButton){
        //1、改变按钮的状态
        titleBtn.isSelected = !titleBtn.isSelected
        
        //2、创建弹出的控制器
        let popoverVc = PopoverViewController()
        //3、设置控制器的modal样式
        
        popoverVc.modalPresentationStyle = .custom
        //4、设置转场的代理
        popoverVc.transitioningDelegate = self
        //、弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
}

 //MARK:- 自定义转场代理的方法

extension HomeViewController : UIViewControllerTransitioningDelegate {
    //目的：改变弹出view的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return TPresentationController(presentedViewController: presented, presenting: presenting)
    }
    //目的：自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

 //MARK:- 弹出和消失动画代理方法
extension HomeViewController : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ?  animationForPresentedView(using: transitionContext) : animationForDismissedView(using: transitionContext)
    }
    
    private func animationForPresentedView(using transitionContext: UIViewControllerContextTransitioning){
        //1、获取弹出的view
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        //2、将弹出的view添加到containerView中
        transitionContext.containerView.addSubview(presentedView!)
        
        //3、执行动画
        presentedView?.transform = CGAffineTransform(scaleX: 1.0,y: 0.0)
        presentedView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView?.transform = CGAffineTransform.identity
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    private func animationForDismissedView(using transitionContext: UIViewControllerContextTransitioning){
        //1、获取消失的view
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        //2、执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            dismissView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.00001)
        }) { (_) in
            dismissView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
