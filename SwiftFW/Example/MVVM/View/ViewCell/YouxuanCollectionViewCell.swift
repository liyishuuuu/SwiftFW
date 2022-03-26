//
//  YouxuanCollectionViewCell.swift
//  SwiftFW
//
//  Created by liyishu on 2022/2/24.
//

import UIKit
import Kingfisher

class YouxuanCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lableLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    internal func setupCell(datasource: [YouxuanModel], indexPath: IndexPath) {
        lableLabel.text = datasource[indexPath.row].lable
        titleLabel.text = datasource[indexPath.row].title
        let url = URL(string: "https://p0.meituan.net/biztone/a1c02f765512ddfe23aaf18f8a45132577021.jpg@214w_120h_1e_1c")!
        imageView.kf.setImage(with: .network(url))
    }
}
