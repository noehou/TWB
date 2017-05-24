//
//  PopoverAnimator.swift
//  TWB
//
//  Created by Tommaso on 2017/5/11.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    var isPresented : Bool = false
    var presentedFrame : CGRect = CGRect.zero
    
    var callBack : ((Bool) -> ())?
    
     //MARK:- 自定义构造函数
    init(callBack : @escaping (Bool) -> ()) {
        self.callBack = callBack
    }
}

//MARK:- 自定义转场代理的方法

extension PopoverAnimator : UIViewControllerTransitioningDelegate {
    //目的：改变弹出view的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = TPresentationController(presentedViewController: presented, presenting: presenting)
        presentation.presentedFrame = presentedFrame
        return presentation
    }
    //目的：自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callBack!(isPresented)
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
         callBack!(isPresented)
        return self
    }
}

//MARK:- 弹出和消失动画代理方法
extension PopoverAnimator : UIViewControllerAnimatedTransitioning {
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
