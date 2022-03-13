//
//  YouxuanTableViewCell.swift
//  SwiftFW
//
//  Created by 赵耿怀 on 2022/2/24.
//

import UIKit

class YouxuanTableViewCell: UITableViewCell {

    var datasource: [YouxuanModel] = []
    
    @IBOutlet weak var youxuanCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        youxuanCollectionView.delegate = self
        youxuanCollectionView.dataSource = self
    }
    
    internal func setupCell(datasource: [YouxuanModel]) {
        self.datasource = datasource
        youxuanCollectionView.reloadData()
    }
}

extension YouxuanTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - cell 个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "youxuanCollectionViewCell", for: indexPath)
        as! YouxuanCollectionViewCell
        cell.setupCell(datasource: datasource, indexPath: indexPath)
        return cell
    }
}
