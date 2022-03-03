//
//  Extension.swift
//  GoodCam
//
//  Created by liyishu on 2021/12/21.
//

import UIKit
import CommonCrypto

/**
 * 去除集合中指定的重复的对象
 * 内部元素是可哈希的
 * 内部使用了 Set 进行 contains 查找，比数组的 contains (_:) 方法时间复杂度要低。
 */
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

/**
 * 去除集合中指定的重复的对象
 * 内部元素是不可哈希的
 * 如果数组内部的元素是解析的 model，而且没有遵守 Hashable
 */
extension Sequence {
    func uniqued(comparator: (Element, Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for element in self {
            if result.contains(where: { comparator(element, $0)}) {
                continue
            }
            result.append(element)
        }
        return result
    }
}

/**
 * 自定义下标来安全访问数组
 * 自定义的[safe: 2]和原生的 [2]非常的接近
 * 自定义的提供了数据越界保护机制
 *
 * 使用：
 * let values = ["A", "B", "C"]
 * values.getValue(at: 2)        // "C"
 * values.getValue(at: 3)        // nil
 */
extension Array {
    subscript (safe index: Int) -> Element? {
        guard index >= 0 && index < self.count else {
            return nil
        }
        return self[index]
    }
}

/**
 * 将以上方法应用于集合
 * 自定义下标来安全访问集合
 */
extension Collection {
    public subscript (safe index: Self.Index) -> Iterator.Element? {
        (startIndex ..< endIndex).contains(index) ? self[index] : nil
    }
}

/**
 * 判断集合非空
 *
 * var str = "aaaaa"
 * let flag = str.isNotEmpty
 */
extension Collection {
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}
