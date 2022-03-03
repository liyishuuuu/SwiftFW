//
//  BaseViewController.swift
//  HDCam
//
//  Created by 赵耿怀 on 2021/12/29.
//

import UIKit

/**
 * BaseViewController
 */
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    // MARK: - internal methods

    // 设置导航栏左侧按钮
    internal func setupLeftButton(image: UIImage?, title: String? = nil, titleColor: UIColor? = UIColor.darkGray) {
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        leftButton.setImage(image, for: .normal)
        if title != nil {
            leftButton.setTitle(title, for: .normal)
            leftButton.setTitleColor(titleColor, for: .normal)
            leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        }
        leftButton.addTarget(self, action: #selector(leftButtonAction(sender:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }

    // 设置导航栏右侧按钮
    internal func setupRightButton(image1: UIImage?, title1: String? = nil, width1: CGFloat = 50, button1XPosition: CGFloat = 70,
                                   image2: UIImage? = nil, title2: String? = nil, width2: CGFloat = 50, button2XPosition: CGFloat = 20,
                                   titleColor: UIColor? = UIColor.darkGray, withBadge: Bool = false, badgeNum: String = emptyString) {
        let rightButton = UIButton(frame: CGRect(x: button1XPosition, y: 0, width: width1, height: 44))
        rightButton.setImage(image1, for: .normal)
        if title1 != nil {
            rightButton.setTitle(title1, for: .normal)
            rightButton.setTitleColor(titleColor, for: .normal)
            rightButton.contentHorizontalAlignment = .right
            rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        }
        rightButton.addTarget(self, action: #selector(rightButtonAction(sender:)), for: .touchUpInside)
        let rightButton2 = UIButton(frame: CGRect(x: button2XPosition, y: 0, width: width2, height: 44))
        rightButton2.setImage(image2, for: .normal)
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: width1+width2+button2XPosition, height: 44))
        if title2 != nil || image2 != nil {
            rightButton2.setTitle(title2, for: .normal)
            rightButton2.setTitleColor(titleColor, for: .normal)
            rightButton2.contentHorizontalAlignment = .right
            rightButton2.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            rightButton2.addTarget(self, action: #selector(rightButtonAction2(sender:)), for: .touchUpInside)
            buttonView.addSubview(rightButton2)
        }
        if withBadge {
            if badgeNum != emptyString {
                /// 使用小红点
                let bdgeImage = UIImageView.init(image: UIImage.getNumberBadge(with: badgeNum));
                bdgeImage.frame = CGRect(x: 56, y: 3, width: bdgeImage.frame.width, height: bdgeImage.frame.height);
                buttonView.addSubview(bdgeImage)
                bdgeImage.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                    bdgeImage.transform = CGAffineTransform.identity
                })
            }
        }

        buttonView.addSubview(rightButton)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonView)
    }

    /// 设置导航栏
    /// - Parameter titleKey: 导航栏标题key
    internal func setupNav(titleKey: String,
                           backgroundColor: UIColor = UIColor.RGB(244, 244, 244),
                           textColor: UIColor = UIColor.darkGray) {
        self.setupLeftButton(image: UIImage(named: "left_back_long"), title: nil, titleColor: UIColor.darkGray)
        let titleString = ""
        self.navigationItem.title = titleString
        let appearance = UINavigationBar.appearance()
        if #available(iOS 15.0, *) {
            let newAppearance = UINavigationBarAppearance()
            newAppearance.configureWithOpaqueBackground()
            newAppearance.backgroundColor = backgroundColor
            newAppearance.shadowImage = UIImage()
            newAppearance.shadowColor = nil
            newAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor,
                                                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18,
                                                                                                weight: .medium)]
            appearance.standardAppearance = newAppearance
            appearance.scrollEdgeAppearance = appearance.standardAppearance
        } else {
            self.navigationController?.navigationBar.barTintColor = backgroundColor
        }
    }
    
    /// 设置导航栏
    /// - Parameter titleKey: 导航栏标题key
    internal func setupNav(title: String, bgColor: UIColor = UIColor.RGB(244, 244, 244)) {
        let backString = "返回"
        self.setupLeftButton(image: UIImage(named: "left_back"), title: backString, titleColor: UIColor.darkGray)
        self.navigationItem.title = title
        let appearance = UINavigationBar.appearance()
        if #available(iOS 15.0, *) {
            let newAppearance = UINavigationBarAppearance()
            newAppearance.configureWithOpaqueBackground()
            newAppearance.backgroundColor = bgColor
            newAppearance.shadowImage = UIImage()
            newAppearance.shadowColor = nil
            newAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                                                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18,
                                                                                                weight: .medium)]
            appearance.standardAppearance = newAppearance
            appearance.scrollEdgeAppearance = appearance.standardAppearance
        } else {
            self.navigationController?.navigationBar.barTintColor = UIColor.RGB(244, 244, 244)
        }
    }
    
    /**
     * 指定画面迁移（push）
     * parameter viewController: 迁移的画面
     */
    internal func pushViewController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    /**
     * 指定画面迁移（presenter）
     * parameter viewController: 迁移的画面
     */
    internal func presentViewController(viewController: UIViewController) {
        self.present(viewController, animated: true)
        viewController.modalPresentationStyle = .fullScreen
    }

    /**
     * 画面返回（pop）
     */
    internal func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }

    /**
     * 指定画面返回（pop）
     *      * parameter viewController: 返回的画面
     */
    internal func popToViewContrller(viewController: UIViewController) {
        self.navigationController?.popToViewController(viewController, animated: true)
    }

    // 左侧按钮事件
    internal func leftButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }

    // 右侧按钮1事件
    internal func rightButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 右侧按钮2事件
    internal func rightButtonAction2() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - @objc private methods

    /**
     * 左侧按钮按下处理
     * parameter sender: 按钮
     */
    @objc private func leftButtonAction(sender: UIButton) {
        self.leftButtonAction()
    }

    /**
     * 右侧按钮1按下处理
     * parameter sender: 按钮
     */
    @objc private func rightButtonAction(sender: UIButton) {
        self.rightButtonAction()
    }
    /**
     * 右侧按钮2按下处理
     * parameter sender: 按钮
     */
    @objc private func rightButtonAction2(sender: UIButton) {
        self.rightButtonAction2()
    }

    // MARK: - private methods

    /// 设置左边返回按钮图片 文字
    private func initView() {
        let titleString = "返回"
        self.setupLeftButton(image: UIImage(named: "lefterback"), title: titleString)
    }

    // 手势
    internal func addGesture() {

        // 空白处单击手势
        let tapSingle = UITapGestureRecognizer()
        tapSingle.addTarget(self, action: #selector(tapGes))
        self.view.addGestureRecognizer(tapSingle)
    }
    
    /// 收键盘
    @objc private func tapGes() {
        self.view.endEditing(true)
    }
}
