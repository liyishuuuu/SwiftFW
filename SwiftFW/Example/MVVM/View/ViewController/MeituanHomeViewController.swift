//
//  MeituanHomeViewController.swift
//  SwiftFW
//
//  Created by 赵耿怀 on 2022/2/24.
//

import UIKit

class MeituanHomeViewController: BaseRxViewController<MeituanHomeViewModel> {

    @IBOutlet weak var mtHomeTableView: UITableView!
    
    var datasource: [YouxuanModel] = []
    var shopDatasource: [ShopModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mtHomeTableView.delegate = self
        mtHomeTableView.dataSource = self
        setupNav(title: "美团")
        setupLeftButton(image: UIImage(named: "left_back_long"))
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.youxuanLoad()
        viewModel.outputs.dataSource.subscribe(onNext: { [weak self] data in
            self?.datasource = data
            self?.mtHomeTableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.shopLoad()
        viewModel.outputs.shopDataSource.subscribe(onNext: { [weak self] shopData in
            self?.shopDatasource = shopData
            self?.mtHomeTableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension MeituanHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 120
        case 1:
            return 200
        case 2:
            return 200
        case 3:
            return 100
        default:
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (shopDatasource.count+4)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell") as! SearchTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "swiperTableViewCell") as! SwiperTableViewCell
            cell.setupCell()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "youxuanTableViewCell") as! YouxuanTableViewCell
            cell.setupCell(datasource: datasource)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "shopTitleTableViewCell") as! ShopTitleTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "shopTableViewCell",
                                                     for: indexPath) as! ShopTableViewCell
            cell.setupCell(datasource: shopDatasource, indexPath: indexPath)
            return cell
        }
    }
}

