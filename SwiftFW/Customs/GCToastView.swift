//
//  ToastView.swift
//  SwiftFW
//
//  Created by liyishu on 2021/11/11.
//

import UIKit
import SnapKit

/**
 * 弹窗工具（Toast）
 */
class GCToastView : NSObject {

    /** Toast默认停留时间 */
    var duration: CGFloat = 2.0
    /** Toast背景颜色 */
    var toastBackgroundColor = UIColor.RGBA(0, 0, 0, 0.3)
    /** Toast内容 */
    var contentView: UIButton

    // MARK: - 初始化方法
    
    init(text: String) {
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0,
                                              width: screenWidth*0.9,
                                              height: 55))
        textLabel.backgroundColor = UIColor.clear
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.text = text
        textLabel.numberOfLines = 0
        contentView = UIButton(frame: CGRect(x: 0, y: 0,
                                             width: textLabel.frame.size.width,
                                             height: textLabel.frame.size.height))
        contentView.layer.cornerRadius = 4.0
        contentView.backgroundColor = toastBackgroundColor
        contentView.addSubview(textLabel)
        contentView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        contentView.backgroundColor = UIColor.RGBA(0, 0, 0, 0.5)
        super.init()

        /// 添加事件
        contentView.addTarget(self, action: #selector(toastTaped), for: .touchDown)

        /// 添加通知获取手机旋转状态
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toastTaped),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: UIDevice.current)
    }

    // MARK: -下方显示

    /// 显示toast带文字
    /// - Parameters:
    ///   - text: toast文字
    ///   - bottomOffset: 下方偏移量
    ///   - duration: 显示时间
    class func showBottomWithText(text: String, bottomOffset: CGFloat = 40, duration: CGFloat = 1.5) {
        let toast = GCToastView(text: text)
        toast.setDuration(duration: duration)
        toast.showFromBottomOffset(bottom: bottomOffset)
    }

    // MARK: -上方显示

    /// 显示toast带文字
    /// - Parameters:
    ///   - text: toast文字
    ///   - bottomOffset: 上方偏移量
    ///   - duration: 显示时间
    class func showTopWithText(text: String, topOffset: CGFloat = DeviceHelper.getStatusBarHeight(), duration: CGFloat = 3) {
        let toast = GCToastView(text: text)
        toast.setDuration(duration: duration)
        toast.showFromTopOffset(top: topOffset)
    }

    // MARK: -上方显示

    /// 显示上方固定位置toast带文字
    /// - Parameters:
    ///   - text: toast文字
    ///   - bottomOffset: 上方偏移量
    ///   - duration: 显示时间
    class func showFixedTopWithText(text: String, duration: CGFloat = 3) {
        let toast = GCToastView(text: text)
        toast.setDuration(duration: duration)
        toast.showFromFixedTopOffset(top: DeviceHelper.getStatusBarHeight())
    }
    
    @objc func toastTaped() {
        self.hideAnimation()
    }

    private func deviceOrientationDidChanged(notify: Notification) {
        self.hideAnimation()
    }

    @objc func dismissToast() {
        contentView.removeFromSuperview()
    }

    private func setDuration(duration: CGFloat) {
        self.duration = duration
    }

    /// 显示动画
    private func showAnimation() {
        UIView.animate(withDuration: 1, delay: 0.1, options: UIView.AnimationOptions.curveEaseIn) {
            ()-> Void in
        } completion: { [self] Bool in
            self.contentView.alpha = 1.0
        }
    }

    /// 隐藏动画
    @objc func hideAnimation() {
        UIView.animate(withDuration: 1, delay: 0.1,
                       options: UIView.AnimationOptions.curveEaseOut) {()-> Void in
        } completion: { [self] Bool in
            self.contentView.alpha = 0
        }
    }

    private func showFromBottomOffset(bottom: CGFloat) {
        let window: UIWindow = UIApplication.shared.connectedScenes
                                .filter({$0.activationState == .foregroundActive})
                                .map({$0 as? UIWindowScene})
                                .compactMap({$0})
                                .first?.windows
                                .filter({$0.isKeyWindow}).last! ?? UIWindow()
        contentView.center = CGPoint(x: window.center.x,
                                     y: window.frame.size.height - (bottom + contentView.frame.size.height / 2))
        window.addSubview(contentView)
        self.showAnimation()
        self.perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration))
    }

    private func showFromTopOffset(top: CGFloat) {
        let window: UIWindow = UIApplication.shared.connectedScenes
                                .filter({$0.activationState == .foregroundActive})
                                .map({$0 as? UIWindowScene})
                                .compactMap({$0})
                                .first?.windows
                                .filter({$0.isKeyWindow}).last! ?? UIWindow()
        contentView.center = CGPoint(x: window.center.x,
                                     y: top + contentView.frame.size.height / 2)
        window.addSubview(contentView)
        self.showAnimation()
        self.perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration))
    }
    
    private func showFromFixedTopOffset(top: CGFloat) {
        let window: UIWindow = UIApplication.shared.connectedScenes
                                .filter({$0.activationState == .foregroundActive})
                                .map({$0 as? UIWindowScene})
                                .compactMap({$0})
                                .first?.windows
                                .filter({$0.isKeyWindow}).last! ?? UIWindow()
        contentView.frame = CGRect(x: screenWidth*0.05, y: top, width: screenWidth*0.9, height: 55)
        window.addSubview(contentView)
        self.showAnimation()
        self.perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration))
    }
}
