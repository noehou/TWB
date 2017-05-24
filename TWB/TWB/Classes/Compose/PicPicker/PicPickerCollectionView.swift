//
//  PicPickerCollectionView.swift
//  TWB
//
//  Created by Tommaso on 2017/5/24.
//  Copyright © 2017年 Tommaso. All rights reserved.
//

import UIKit
private let picPickerCell = "picPickerCell"
private let edgeMargin : CGFloat = 15
class PicPickerCollectionView: UICollectionView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置collectionView的layout
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * edgeMargin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = edgeMargin
        layout.minimumLineSpacing = edgeMargin
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: picPickerCell)
        dataSource = self
        
        contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: 0, right: edgeMargin)
    }
}

extension PicPickerCollectionView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1、创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath)
        //2、给cell设置数据
        cell.backgroundColor = UIColor.red
        return cell
    }
}
