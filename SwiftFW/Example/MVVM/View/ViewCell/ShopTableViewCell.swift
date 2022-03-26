//
//  ShopTableViewCell.swift
//  SwiftFW
//
//  Created by liyishu on 2022/2/24.
//

import UIKit

class ShopTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var capitaLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var saleNumLabel: UILabel!
    @IBOutlet weak var shopLabel: UILabel!
    
    internal func setupCell(datasource: [ShopModel], indexPath: IndexPath) {
        durationLabel.text = String(datasource[indexPath.row-4].duration ?? emptyString) + "分钟"
        capitaLabel.text = "￥"+String(datasource[indexPath.row-4].capita ?? emptyString)+"起送"
        typesLabel.text = datasource[indexPath.row-4].types
        saleNumLabel.text = "销量："+"200"
        shopLabel.text = datasource[indexPath.row-4].shop
        let url = URL(string: "https://i3.meishichina.com/attachment/recipe/2022/02/25/2022022516457544686111958079.jpg?x-oss-process=style/c320")!
//        let url = URL(string: datasource[indexPath.row-4].logo ?? emptyString)!
        logoImageView.kf.setImage(with: .network(url))
    }

}
