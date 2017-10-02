//
//  SubscriptionListControllerViewController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class SubscriptionListControllerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var myScriptionBtn: UIButton!
    
    @IBOutlet weak var scriptionListBtn: UIButton!
    
    @IBOutlet weak var columeCollectionView: UICollectionView!
    
    @IBOutlet weak var columeTableView: UITableView!
    
    @IBOutlet weak var subscriptMoreView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        
        let nib1 = UINib(nibName: "SinglePhotoNewsCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "SinglePhotoNewsCell")
        tableView.rowHeight = 135;
        let nib2 = UINib(nibName: "SubscriptListCell", bundle: nil)
        columeTableView.register(nib2, forCellReuseIdentifier: "ColumeCell")
        let nib3 = UINib(nibName: "ColumesCollectionViewCell", bundle: nil)
        columeTableView.rowHeight = 96;
        columeCollectionView.register(nib3, forCellWithReuseIdentifier: "Cell")
        let layout = columeCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        columeCollectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let w = (screenWidth-15*2-8*2)/3.0
        let h:CGFloat = 108
        layout.itemSize = CGSize(width: w, height: h)
        
        selectItem(index: 0)
    }
    

    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return 10
        }
        else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SinglePhotoNewsCell", for: indexPath)
        
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColumeCell", for: indexPath)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    //MARK: - collectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    
    //MARK: - actions
    @IBAction func handleTapMyScriptBtn(_ sender: UIButton) {
        selectItem(index: 0)
    }
    
    @IBAction func handleTapScriptionListBtn(_ sender: UIButton) {
        selectItem(index: 1)
    }
    
    /// 我的订阅 | 订阅更多
    func selectItem(index: Int) {
        if index == 0 {
            myScriptionBtn.isSelected = true
            scriptionListBtn.isSelected = false
            tableView.isHidden = false
            subscriptMoreView.isHidden = true
        }
        else {
            myScriptionBtn.isSelected = false
            scriptionListBtn.isSelected = true
            tableView.isHidden = true
            subscriptMoreView.isHidden = false

        }
    }

}
