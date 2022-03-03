//
//  TestMVPPresenter.swift
//  SwiftFW
//
//  Created by liyishu on 2022/3/3.
//

import UIKit

class TestMVPPresenter: NSObject {
    // 代理
    private var testMVPProtocol: TestMVPProtocol?

    // MARK: - attach/detach methods

    func testMVP() {
        testMVPProtocol?.testMVPCallback()
    }
    
    // 绑定V和P
    func attachView(viewDelegate: TestMVPProtocol) {
        self.testMVPProtocol = viewDelegate
    }

    // 解除绑定
    func detachView()  {
        self.testMVPProtocol = nil
    }
}
