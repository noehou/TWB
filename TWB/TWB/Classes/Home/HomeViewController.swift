//
//  HomeViewController.swift
//  TWB
//
//  Created by Tommaso on 2017/5/9.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {
     //MARK:- 属性

 //MARK:-懒加载
    lazy var titleBtn : TitleButton = TitleButton()
    lazy var popoverAnimator : PopoverAnimator = PopoverAnimator { [weak self](presented) in
        self?.titleBtn.isSelected = presented
    }
    
    lazy var viewModels : [StatusViewModel] = [StatusViewModel]()
    lazy var tipLabel : UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        //1、没有登录时设置的内容
         visitorView.addRotationAnim()
        if !isLogin {
            return
        }
        //2、设置导航栏的内容
        setupNavigationBar()
        
//        //3、请求数据
//        loadStatuses()
        
        //4、设置估算高度
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        //5、布局header
        setupHeaderView()
        setupFooterView()
        
        //6、设置提示的label
        setupTipLabel()
        
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
    
    func setupHeaderView(){
        //1、创建headerView
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewStatuses))
        
        //2、设置header的属性
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中", for: .refreshing)
        
        //3、设置tableView的header
        tableView.mj_header = header
        
        //4、进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    
    func setupFooterView(){
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreStatuses))
    }
    
    func setupTipLabel(){
        //1、将tipLabel添加到父控件中
        navigationController?.navigationBar.subviews.first?.insertSubview(tipLabel, at: 0)
        //2、设置tipLabel的frame
        
        tipLabel.frame = CGRect(x: 0, y: 34, width: UIScreen.main.bounds.width, height: 30)
        
        //3、设置tipLabel的属性
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
    }
}

 //MARK:- 事件监听的函数
extension HomeViewController {
    func titleBtnClick(titleBtn : TitleButton){
        //1、改变按钮的状态
//        titleBtn.isSelected = !titleBtn.isSelected
        
        //2、创建弹出的控制器
        let popoverVc = PopoverViewController()
        //3、设置控制器的modal样式
        
        popoverVc.modalPresentationStyle = .custom
        //4、设置转场的代理
        popoverAnimator.presentedFrame = CGRect(x: 120, y: 55, width: 180, height: 250)
        popoverVc.transitioningDelegate = popoverAnimator
        //、弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
}

 //MARK:- 请求数据
extension HomeViewController {
    func loadNewStatuses(){
            loadStatuses(isNewData: true)
    }
    
    func loadMoreStatuses(){
        loadStatuses(isNewData: false)
    }
    
    
    
    func loadStatuses(isNewData : Bool){
        //1、获取since_id
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = viewModels.first?.status?.mid ?? 0
        } else {
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        TNetworkTool.shareInstance.loadStatuses(since_id: since_id, max_id: max_id) { (response, err) in
            
            
            //1、错误校验
            if err != nil {
                print(err ?? "error")
                return
            }
            //2、获取可选类型中的数据
            guard let resultArr = response else {
                return
            }
            //3、遍历微博对应的字典
            var tempViewModel = [StatusViewModel]()

            for statusDict in resultArr {
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tempViewModel.append(viewModel)
            }
            
            //4、将数据放入到成员变量的数组中
            if isNewData {
                self.viewModels = tempViewModel + self.viewModels
            } else {
                self.viewModels += tempViewModel
            }
            
            
            //5、缓存图片
            self.cacheImages(viewModels: tempViewModel)
            
        }
    }
    
    func cacheImages(viewModels : [StatusViewModel]){
        //0创建group
        let group = DispatchGroup()
        
        //1、缓存图片
        for viewModel in viewModels {
            for picURL in viewModel.picURLs {
                group.enter()
                SDWebImageManager.shared().loadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _, _, _) in
                    print("下载了一张图")
                    group.leave()
                })
            }
        }
        
        //刷新表格
        group.notify(queue:DispatchQueue.main){
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            //显示提示的label
            self.showTipLabel(count: viewModels.count)
        }
       
    }

    //显示提示的label
    func showTipLabel(count : Int){
        //1、设置tipLabel的属性
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "\(count) 条微博"
        
        UIView.animate(withDuration: 1.0, animations: { 
            self.tipLabel.frame.origin.y = 64
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: { 
                self.tipLabel.frame.origin.y = 30
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
        }
    }
}

extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellID") as! HomeViewCell
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //1、获取模型对象
        let viewModel = viewModels[indexPath.row]
        return viewModel.cellHeight
    }
}

