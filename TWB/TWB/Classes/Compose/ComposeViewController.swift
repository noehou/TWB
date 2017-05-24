//
//  ComposeViewController.swift
//  TWB
//
//  Created by Tommaso on 2017/5/22.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var picPickerViewHighCons: NSLayoutConstraint!
 //MARK:- 懒加载属性
    lazy var titleView : ComposeTitleView = ComposeTitleView()
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航栏
        setupNavigationBar()
         NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillChange(note:)), name:NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    @IBAction func picPickerBtnClick(_ sender: UIButton) {
        //推出键盘
        textView.resignFirstResponder()
        //执行动画
        picPickerViewHighCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }
        
    }
}

 //MARK:- 设置UI界面

extension ComposeViewController {
    func setupNavigationBar() {
        //1、设置左右的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        //2、设置标题
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
}


 //MARK:- 事件监听函数
extension ComposeViewController {
    func closeItemClick(){
        dismiss(animated: true, completion: nil)
    }
    
    func sendItemClick(){
        print("sendItemClick")
    }
    
    func KeyboardWillChange(note : Notification){
        //1、获取动画执行的时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        //2、获取键盘最终Y值
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        
        //3、计算工具栏距离底部的间距
        let margin = UIScreen.main.bounds.height - y
        
        //4、执行动画
        toolBarBottomCons.constant = margin
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
    }
    
}


 //MARK:- UITextView的代理方法
extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
