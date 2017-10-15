//
//  TopicBannerCell.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/26.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class TopicBannerCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
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

    //MARK: - collectionview
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TopicImageCell
//        cell.coverImageView.image = #imageLiteral(resourceName: "cover3m2_1")
        
        let imgs = [#imageLiteral(resourceName: "topic1m2_1"), #imageLiteral(resourceName: "topic2m2_1"), #imageLiteral(resourceName: "imgM2-5-2")]
        cell.coverImageView.image = imgs[indexPath.row%3]
        return cell
    }
    
}
