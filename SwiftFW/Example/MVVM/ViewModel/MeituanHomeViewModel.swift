//
//  MeituanHomeViewModel.swift
//  HDCam
//
//  Created by 赵耿怀 on 2022/2/24.
//

import UIKit
import RxCocoa

class MeituanHomeViewModel: BaseViewModel {
    
    let dataSource = PublishRelay<[YouxuanModel]>()
    
    let shopDataSource = PublishRelay<[ShopModel]>()
    
    func youxuanLoad() {
        GetYouxuanService.shared.getYouxuan { (modelList) in
            self.dataSource.accept(modelList)
        } failure: { errString in
            print(errString)
        }
    }
    
    func shopLoad() {
        GetShopService.shared.getShop { (modelList) in
            self.shopDataSource.accept(modelList)
        } failure: { errString in
            print(errString)
        }
    }
}
