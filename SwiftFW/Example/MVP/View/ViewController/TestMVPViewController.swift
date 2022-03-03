//
//  TestMVPViewController.swift
//  SwiftFW
//
//  Created by liyishu on 2022/3/3.
//

import UIKit

class TestMVPViewController: UIViewController {
    
    /** 定义一个presenter，实例化 */
    private let presenter = TestMVPPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加v和p层的绑定
        self.presenter.attachView(viewDelegate: self)
        
        // 调用p层方法
        self.presenter.testMVP()
    }
}

extension TestMVPViewController: TestMVPProtocol {
    func testMVPCallback() {
        
    }
}
