//
//  WelcomeViewController.swift
//  TWB
//
//  Created by Tommaso on 2017/5/15.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var iconView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileURLString = UserAccountViewModel.shareIntance.account?.avatar_large
        let url = URL(string: profileURLString ?? "")
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
        
        //1、改变约束的值
        iconViewBottomCons.constant = UIScreen.main.bounds.height - 250
        
        //2、执行动画
        //Damping : 阻力系数，阻力系数越大，弹出的效果越不明显 0-1
        // initialSpringVelocity : 初始化速度
        
        UIView.animate(withDuration: 5.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }

    }

}
