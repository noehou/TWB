//
//  HomeViewCell.swift
//  TWB
//
//  Created by Tommaso on 2017/5/17.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit
import SDWebImage
private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 10

class HomeViewCell: UITableViewCell {
    
     //MARK:- 控件属性
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var verifiedView: UIImageView!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picView: PicCollectionView!
    @IBOutlet weak var retweetedContentLabel: UILabel!
    @IBOutlet weak var retweetedBgView: UIView!
    @IBOutlet weak var bottomToolView: UIView!
    
     //MARK:- 约束的属性
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var retweetedContentLabelTopCons: NSLayoutConstraint!
    
    
     //MARK:- 自定义属性
    var viewModel : StatusViewModel? {
        didSet {
            //1、nil值校验
            guard let viewModel = viewModel else {
                return
            }
            
            iconView.sd_setImage(with: viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            verifiedView.image = viewModel.verifiedImage
            screenNameLabel.text = viewModel.status?.user?.screen_name
            vipView.image = viewModel.vipImage
            timeLabel.text = viewModel.createAtText
            //7、设置微博正文
            contentLabel.text = viewModel.status?.text
            //8、设置来源
            if let sourceText = viewModel.sourceText {
              sourceLabel.text = "来自 " + sourceText
            } else {
                sourceLabel.text = nil
            }
            //8、设置昵称的文字颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
           
            let picViewSize = calculatePicViewSize(count: viewModel.picURLs.count)
            picViewWCons.constant = picViewSize.height
            picViewHCons.constant = picViewSize.height
            picView.picURLs = viewModel.picURLs
            
            //11、设置转发微博的正文
            if viewModel.status?.retweeted_status != nil {
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name,let retweetedText = viewModel.status?.retweeted_status?.text {
                    retweetedContentLabel.text = "@" + "\(screenName):" + retweetedText
                    retweetedContentLabelTopCons.constant = 15
                }
             retweetedBgView.isHidden = false
            } else {
                retweetedContentLabel.text = nil
                retweetedBgView.isHidden = true
                retweetedContentLabelTopCons.constant = 0
            }
            
            //12:计算cell高度
            if viewModel.cellHeight == 0 {
                //12.1.强制布局
                layoutIfNeeded()
                //12.2获取底部工具栏的最大Y值
                viewModel.cellHeight =  bottomToolView.frame.maxY
            }
        }
    }
     //MARK:-系统会调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.main.bounds.width - 2 * edgeMargin
 
    }

}


 //MARK:- 计算方法

extension HomeViewCell {
    func calculatePicViewSize(count : Int) -> CGSize {
        //1、没有配图
        if count == 0 {
            picViewBottomCons.constant = 0
            return CGSize.zero
        }
        
        picViewBottomCons.constant = 10
        //取出picView对应的layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //单张配图
        if count == 1 {
            //1、取出图片
            let urlString = viewModel?.picURLs.last?.absoluteString
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: urlString)
            //2、设置一张图片的layout的itemSize
            layout.itemSize = CGSize(width: (image?.size.width)! * 2, height: (image?.size.height)! * 2)
            return CGSize(width: (image?.size.width)! * 2, height: (image?.size.height)! * 2)
        }
        //4、计算出来itemViewWH一个item的宽高
        let itemViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        //5、设置其他张图片的layout的itemSize
        layout.itemSize = CGSize(width: itemViewWH, height: itemViewWH)
        
        
        //6、四张配图
        if count == 4 {
            let picViewWH = itemViewWH * 2 + itemMargin
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        //7、其他张配图
        //7.1 计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        
        //7.2 计算picView的高度
        let picViewH = rows * itemViewWH + (rows - 1) * itemMargin
        
        //7.3计算picView的宽度
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
    }
}
