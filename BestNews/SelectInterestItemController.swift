//
//  SelectInterestItemController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/24.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

/// 首页 订阅列表
class SelectInterestItemController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var items: [NewsChannel] = []
    
    ///入口   0 登录  1 首页订阅专题
    var entry: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        
        self.loadNewsChannel()
    }

    
    //MARK: - collectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
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
        
        //批量订阅
        
        var ids: [String] = []
        for data in items {
            if data.selected {
                ids.append(data.id)
            }
        }
        if ids.count == 0 {
            navigationController?.dismiss(animated: true, completion: nil)
            return
        }
        
        let channelids = ids.joined(separator: ",")
        APIRequest.multiSubscriptChannelAPI(channelIds: channelids) {[weak self] (success) in
            if success {
                
                if self?.entry == 0 {
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                }
                else if self?.entry == 1 {
                self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    

}

///load data
extension SelectInterestItemController {
    func loadNewsChannel() {
        APIRequest.getAllChannelAPI { [weak self](data) in
            self?.items = data as! [NewsChannel]
            self?.collectionView.reloadData()
        }
    }
}
