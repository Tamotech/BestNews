//
//  TopicBannerCell.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/26.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit


typealias SelectOneChannelCallback = (SpecialChannel)->()

/// 专题列表
class TopicBannerCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectOneChannel: SelectOneChannelCallback?
    
    
    var specialList: [SpecialChannel] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let nib = UINib(nibName: "TopicImageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 160, height: 92)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
    }
    
    func updateCell(data: [SpecialChannel]) {
        self.specialList = data
        collectionView.reloadData()
    }
    

    //MARK: - collectionview
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return specialList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TopicImageCell

        let data = specialList[indexPath.row]
        cell.updateCell(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = specialList[indexPath.row]
        if selectOneChannel != nil {
            selectOneChannel!(data)
        }
    }
    
}
