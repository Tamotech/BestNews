//  YLCycleView.swift
//  YLCycleView
//  Created by Raindew on 2016/11/1.
//  Copyright © 2016年 Raindew. All rights reserved.
//

import UIKit
import Kingfisher
private let kCellId = "kCellId"

//每个图片点击响应的代理
protocol YLCycleViewDelegate : class {
    func clickedCycleView(_ cycleView : YLCycleView, selectedIndex index: Int)
}

class YLCycleView: UIView {

//MARK: -- 自定义属性
    var titles: [String]?
    var images: [String]!
    var banner: [HomeArticle] = []
    fileprivate var cycleTimer : Timer?
    weak var delegate : YLCycleViewDelegate?

//MARK: -- 懒加载
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in

        //创建collectionView
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self!.bounds, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(YLCycleCell.self, forCellWithReuseIdentifier: kCellId)
        return collectionView
    }()
    lazy var pageControl : UIPageControl = {[weak self] in

        let pageControl = UIPageControl(frame: CGRect(x: self!.bounds.size.width-100, y: self!.bounds.height - 14, width: 100, height: 14))
        pageControl.pageIndicatorTintColor = UIColor(hexString: "#ffffff", alpha: 0.5)

        pageControl.currentPageIndicatorTintColor = .white
        //让pageCotrol居中显示
        pageControl.numberOfPages = self!.images?.count ?? 0
        let pointSize = pageControl.size(forNumberOfPages: self!.images?.count ?? 0)
//        pageControl.bounds = CGRect(x: -(pageControl.bounds.width - pointSize.width) / 2 + 10, y: pageControl.bounds.height - 20, width: pageControl.bounds.width / 2, height: 20)
        return pageControl
    }()
    override func layoutSubviews() {
        //设置layout(获取的尺寸准确，所以在这里设置)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        //设置该空间不随着父控件的拉伸而拉伸
        autoresizingMask = UIViewAutoresizing()
    }
//MARK: -- 刷新数据
    func reloadData() {
        
        APIRequest.getBannerListAPI { [weak self](list) in
            let banner = list as! [HomeArticle]
            self?.banner = banner
            var t: [String] = []
            var i: [String] = []
            for article in banner {
                t.append(article.title)
                i.append(article.titleimgpath)
            }
            self?.titles = t
            self?.images = i
            self?.setupUI()
            self?.pageControl.numberOfPages = self?.images?.count ?? 0
            
        }
        
        
    }
//MARK: -- 构造函数
    init(frame: CGRect, images: [String], titles : [String] = []) {

        self.images = images
        self.titles = titles
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        removeCycleTimer()
        print("YLCycleView销毁了")
    }
}

//MARK: -- 设置UI界面
extension YLCycleView {

    fileprivate func setupUI() {

        if collectionView.superview == nil {
            addSubview(collectionView)
        }
        //添加定时器。先移除再添加
        collectionView.reloadData()
        removeCycleTimer()
        if (images?.count)! > 1 {//如果只有1个图片就不再滚动
            self.collectionView.isScrollEnabled = true
            addCycleTimer()
            if pageControl.superview == nil {
                addSubview(pageControl)
            }
        }else {
            self.collectionView.isScrollEnabled = false
        }
        //滚动到该位置（让用户最开始就可以向左滚动）
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)

        //点击事件
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector (tapGes(tap:)))
        self.addGestureRecognizer(tap)
    }
}

//MARK: -- UICollectionViewDataSource
extension YLCycleView : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (images?.count ?? 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! YLCycleCell
        
        if titles != nil {
            if (titles?.count)! > 0 {
                cell.bottomView.isHidden = false
                cell.titleLabel.text = titles?[indexPath.row % titles!.count]
            }else {
                cell.titleLabel.text = ""
                cell.bottomView.isHidden = true
            }
        } else {
            cell.titleLabel.text = ""
            cell.bottomView.isHidden = true
        }
       
        var header : String?
        if images![indexPath.row % images!.count].count >= 4 {
            header = (images![indexPath.row % images!.count] as NSString).substring(to: 4)
        }
        if header == "http" {
//            let url = NSURL(string: images![indexPath.row % images!.count])
//            let data = NSData(contentsOf: url! as URL)
//            cell.iconImageView.image = UIImage(data: data as! Data)
            let url = URL(string: images![indexPath.row % images!.count])
            cell.iconImageView.kf.setImage(with: url)
        }else {
            cell.iconImageView.image = UIImage(named: images![indexPath.row % images!.count])
        }
        if banner.count > indexPath.row {
            let article = banner[indexPath.row]
            cell.adLabel.isHidden = article.type != "adv"
        }
        return cell
    }

}


//MARK: -- UICollectionViewDelegate
extension YLCycleView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard images != nil else { return }
        guard images.count != 0 else { return }
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (images?.count ?? 0)
    }

    //当用户拖拽时，移除定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    //停止拖拽，加入定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
}

//MARK: -- 时间控制器
extension YLCycleView {
    
    func addCycleTimer() {
        
        weak var weakSelf = self//解决循环引用
        if #available(iOS 10.0, *) {
            cycleTimer = Timer(timeInterval: 3.0, repeats: true, block: {(timer) in
                weakSelf!.scrollToNextPage()
            })
        } else {
            cycleTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNextPage), userInfo: nil, repeats: true)
        }
        RunLoop.main.add(cycleTimer!, forMode: .commonModes)
    }
    func removeCycleTimer() {
        
        ///移除定时器的时候  防止滑动到一半的情况
        var x = collectionView.contentOffset.x
        if Int(x) % Int(collectionView.bounds.size.width) > 20   {
            x = x - CGFloat(Int(x) % Int(collectionView.bounds.size.width))
            collectionView.setContentOffset(CGPoint.init(x: x, y: 0), animated: true)
        }
        cycleTimer?.invalidate()//移除
        cycleTimer = nil
    }
    @objc fileprivate func scrollToNextPage() {
        var currentOffsetX = collectionView.contentOffset.x
        if Int(currentOffsetX) % Int(screenWidth) > 2 {
            currentOffsetX = currentOffsetX - CGFloat(Int(currentOffsetX) % Int(screenWidth))
        }
        let offsetX = Int(currentOffsetX + collectionView.bounds.width) %  Int(collectionView.bounds.width * CGFloat(self.titles?.count ?? 1))
        //滚动到该位置
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

//MARK: -- YLCycleViewDelegate
extension YLCycleView {

    @objc fileprivate func tapGes(tap: UITapGestureRecognizer) {
        guard (tap.view as? YLCycleView) != nil else { return }
        guard images != nil else { return }
        guard images.count != 0 else { return }
        if (delegate != nil) {
            delegate?.clickedCycleView(self, selectedIndex: pageControl.currentPage)
        }
        print("点击了第: \(pageControl.currentPage)页")
    }
    
    
    /// 重置scrollView的offset
    public func resetContentOffset() {
        collectionView.contentOffset = CGPoint.zero
    }
}
