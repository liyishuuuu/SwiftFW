//
//  SwiperTableViewCell.swift
//  SwiftFW
//
//  Created by liyishu on 2022/2/24.
//

import UIKit

class SwiperTableViewCell: UITableViewCell {

    // MARK: 更多面板
    lazy var moreView: SwiperView = { [unowned self] in
        let moreV = SwiperView()
        moreV.backgroundColor = UIColor.white
        moreV.delegate = self
        return moreV
    }()
    
    internal func setupCell() {
        self.addSubview(moreView)
        moreView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(216.0)
            make.top.equalTo(self.snp.top)
        }
    }
}

extension SwiperTableViewCell: SwiperViewDelegate {
    func chatMoreView(moreView: SwiperView, didSeletedType type: CellType) {
        
    }
}
