//
//  CycleViewController.swift
//  SwiftFW
//
//  Created by 赵耿怀 on 2022/2/21.
//

import UIKit

//enum CellType: Int {
//    case pic        // 照片
//    case camera     // 相机
//    case sight      // 小视频
//    case video      // 视频聊天
//    case wallet     // 红包
//    case pay        // 转账
//    case location   // 位置
//    case myfav      // 收藏
//    case friendCard // 个人名片
//    case voiceInput // 语音输入
//    case coupons    // 卡券
//}

enum CellType: Int {
    case pic        // 照片
    case camera     // 相机
    case sight      // 小视频
    case video      // 视频聊天
    case wallet     // 红包
    case pay        // 转账
    case location   // 位置
    case myfav      // 收藏
    case friendCard // 个人名片
    case voiceInput // 语音输入
    case coupons    // 卡券
}

internal var backgroundColor = UIColor.RGB(244, 244, 244)

fileprivate let kMoreCellNumberOfOneRow = 5
fileprivate let kMoreCellRow = 2
fileprivate let kMoreCellNumberOfOnePage = kMoreCellRow * kMoreCellNumberOfOneRow
fileprivate let kMoreCellID = "moreCellID"

protocol SwiperViewDelegate : NSObjectProtocol {
    func chatMoreView(moreView: SwiperView, didSeletedType type: CellType)
}

class SwiperView: UIView {
    
    // MARK:- 代理
    weak var delegate: SwiperViewDelegate?
    
    // MARK:- 懒加载
    lazy var moreView: UICollectionView = { [unowned self] in
        let collectionV = UICollectionView(frame: CGRect.zero, collectionViewLayout: SwiperHorizontalLayout(column: kMoreCellNumberOfOneRow, row: kMoreCellRow))
        collectionV.backgroundColor = backgroundColor
        collectionV.dataSource = self
        collectionV.delegate = self
        return collectionV
    }()
    
    lazy var pageControl: UIPageControl = { [unowned self] in
        let pageC = UIPageControl()
        pageC.numberOfPages = self.moreDataSouce.count / kMoreCellNumberOfOnePage + (self.moreDataSouce.count % kMoreCellNumberOfOnePage == 0 ? 0 : 1)
        pageC.currentPage = 0
        pageC.pageIndicatorTintColor = UIColor.lightGray
        pageC.currentPageIndicatorTintColor = UIColor.gray
        pageC.isEnabled = false
        return pageC
    }()
    
//    lazy var moreDataSouce: [(name: String, icon: UIImage?, type: CellType)] = {
//        return [
//            ("照片", UIImage(named: "sharemore_pic"), CellType.pic),
//            ("相机", UIImage(named: "sharemore_video"), CellType.camera),
//            ("小视频", UIImage(named: "sharemore_sight"), CellType.sight),
//            ("视频聊天", UIImage(named: "sharemore_videovoip"), CellType.video),
//            ("红包", UIImage(named: "redbag"), CellType.wallet),
//            ("转账", UIImage(named: "sharemorePay"), CellType.pay),
//            ("位置", UIImage(named: "sharemore_location"), CellType.location),
//            ("收藏", UIImage(named: "sharemore_myfav"), CellType.myfav),
//            ("个人名片", UIImage(named: "sharemore_friendcard"), CellType.friendCard),
//            ("语音输入", UIImage(named: "sharemore_voiceinput"), CellType.voiceInput),
//            ("卡券", UIImage(named: "sharemore_wallet"), CellType.coupons)
//        ]
//    }()
    
    lazy var moreDataSouce: [(name: String, icon: UIImage?, type: CellType)] = {
        return [
            ("美食", UIImage(named: "meishi"), CellType.pic),
            ("超市便利", UIImage(named: "chaoshi"), CellType.camera),
            ("蔬菜水果", UIImage(named: "shuiguo"), CellType.sight),
            ("美团专送", UIImage(named: "meituan"), CellType.video),
            ("跑腿代购", UIImage(named: "paotui"), CellType.wallet),
            ("夜宵", UIImage(named: "yexiao"), CellType.pay),
            ("津贴联盟", UIImage(named: "jintie"), CellType.location),
            ("甜品饮品", UIImage(named: "pinping"), CellType.myfav),
            ("龙虾烧烤", UIImage(named: "shaokao"), CellType.friendCard),
            ("甜蜜蛋糕", UIImage(named: "dangao"), CellType.voiceInput),
            ("汉堡披萨", UIImage(named: "hanbao"), CellType.coupons)
        ]
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(moreView)
        self.addSubview(pageControl)
        
        moreView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.height.equalTo(200)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(35)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
        }
        self.backgroundColor = backgroundColor
        moreView.contentSize = CGSize(width: screenWidth * 2, height: 400.0)
        // 注册itemID
        moreView.register(SwiperCell.self, forCellWithReuseIdentifier: kMoreCellID)
    }
}

extension SwiperView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moreDataSouce.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let moreModel = moreDataSouce[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMoreCellID, for: indexPath) as? SwiperCell
        cell?.model = moreModel
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let moreModel = moreDataSouce[indexPath.item]
        delegate?.chatMoreView(moreView: self, didSeletedType: moreModel.type)
    }
}

extension SwiperView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let page = contentOffset / scrollView.frame.size.width + (Int(contentOffset) % Int(scrollView.frame.size.width) == 0 ? 0 : 1)
        pageControl.currentPage = Int(page)
    }
}
