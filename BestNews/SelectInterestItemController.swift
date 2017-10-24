//
//  SelectInterestItemController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/24.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class SelectInterestItemController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var items: [InterestColumn] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let names = ["宏观", "国际", "金融", "产经", "理财", "地产", "公司", "互联网", "科学", "保险", "历史", "新三板", "股票", "银行", "创投", "基金", "黄金", "外汇"]
        for i in 0..<18 {
            let data = InterestColumn()
            data.selected = (i%2 == 0)
            data.name = names[i]
            items.append(data)
        }
        
        self.shouldClearNavBar = false
        self.showCustomTitle(title: "选择你感兴趣的内容")
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let len = (screenWidth-15*4)/3
        layout.itemSize = CGSize(width: len, height: len)
        
        let nib = UINib(nibName: "InterestColumnCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
    }

    
    //MARK: - collectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! InterestColumnCell
        
        let data = items[indexPath.row]
        cell.updateCell(data: data)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = items[indexPath.row]
        data.selected = !data.selected
        let cell = collectionView.cellForItem(at: indexPath) as! InterestColumnCell
        cell.updateCell(data: data)
        
    }
    
    //MARK: - actions
    @IBAction func handleTapStartRead(_ sender: UITapGestureRecognizer) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    

}
