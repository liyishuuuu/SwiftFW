//
//  Image+Extension.swift
//  SwiftFW
//
//  Created by liyishu on 2022/1/21.
//

import UIKit

extension UIImage{
    
    /// 获取带数字的badge图片
    static func getNumberBadge(with numStr: String) -> UIImage? {
        let radius = 9.0
        let margin = 9.0
        /// 当显示的数字的宽度需要的范围大于 直径 + margin后, 中间的矩形的宽度
        var rectWidth = 0.0
        let stringSize = numStr.sizeWith(UIFont.systemFont(ofSize: 12), CGSize(width: 300, height: radius*2))
        if (stringSize.width + margin) > radius*2 {
            /// 宽度加1后, 显示显示效果更平滑
            rectWidth = stringSize.width + margin - radius*2 + 1
        }
        let totalWidth = radius * 2 + rectWidth
        /// 文字position 的Y, 为了垂直居中显示数字
        let numStrDrawPointY = (radius*2 - stringSize.height) / 2
        /// 最终大小
        let finalSize = CGSize.init(width: totalWidth, height: radius*2)

        UIGraphicsBeginImageContextWithOptions(finalSize, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()

        /// 先画左边的半圆
        let path = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius), radius: CGFloat(radius), startAngle: Double.pi/2, endAngle: Double.pi*1.5, clockwise: true)
        /// 画线到右边半圆的起始位置
        path.addLine(to: CGPoint(x: radius + rectWidth, y: 0))
        /// 画右边半圆
        path.addArc(withCenter: CGPoint(x: radius + rectWidth, y: radius), radius: CGFloat(radius), startAngle: Double.pi*1.5, endAngle: Double.pi/2, clockwise: true);
        /// 画线到左边半圆的下面
        path.addLine(to: CGPoint(x: radius, y: radius*2))
        path.close()
        /// 添加指定的path
        context?.addPath(path.cgPath)

        /// 背景色为纯色
        context?.setFillColor(UIColor.red.cgColor)
        context?.drawPath(using: .fill)

        /// 将要显示的文字画到content上
        (numStr as NSString).draw(at: CGPoint(x: 5, y: numStrDrawPointY), withAttributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
        ])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /**
     根据传入的宽度生成一张图片
     按照图片的宽高比来压缩以前的图片
     :param: width 制定宽度
     */
    func imageWithScale(width: CGFloat) -> UIImage {
        // 1.根据宽度计算高度
        let height = width *  size.height / size.width
        // 2.按照宽高比绘制一张新的图片
        let currentSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(currentSize)
        draw(in: CGRect(origin: CGPoint.zero, size: currentSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

