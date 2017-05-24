//
//  PicCollectionView.swift
//  TWB
//
//  Created by Tommaso on 2017/5/18.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit


class PicCollectionView: UICollectionView {

 //MARK:- 定义属性
    var picURLs : [URL] = [URL]() {
        didSet {
            self.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
    }
}

extension PicCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1、获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! PicCollectionViewCell
        
        //2、给cell设置数据
        cell.picURL = picURLs[indexPath.item]
        return cell
    }
}


class PicCollectionViewCell: UICollectionViewCell {
    
     //MARK:- 定义模型属性
    var picURL : URL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            
            iconView.sd_setImage(with: picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
     //MARK:-  控件属性
    @IBOutlet weak var iconView: UIImageView!
    
    
}
