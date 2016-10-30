//
//  Extension.swift
//  SingleBarNavigationController
//
//  Created by Broccoli on 2016/10/27.
//  Copyright © 2016年 broccoliii. All rights reserved.
//

import UIKit

extension Array {
    func any(_ condition: (Element) -> Bool) -> Bool {
        for element in self {
            if condition(element) {
                return true
            }
        }
        
        return false
    }
}

fileprivate var kInteractivePopGestureKey = "kInteractivePopGestureKey"

extension UIViewController {
    public var exclusiveNavigationController: ExclusiveNavigationController? {
        if !(self is ExclusiveNavigationController) {
            return self.navigationController as? ExclusiveNavigationController
        }
        return self as? ExclusiveNavigationController
    }
    
    @IBInspectable public var disableInteractivePopGesture: Bool {
        get {
            guard let disableInteractivePopGesture = getAssociatedObject(&kInteractivePopGestureKey) else {
                return false
            }
            return disableInteractivePopGesture as! Bool
        }
        
        set {
            setAssociatedObject(newValue as AnyObject?, associativeKey: &kInteractivePopGestureKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var navigationBarClass: AnyClass? {
        return nil
    }
    
    open func customBackItem(withTarget target: Any, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        let arrowImage = createBackBarButtonArrowsImage((self.navigationController?.navigationBar.tintColor)!, in: CGSize(width: 13, height: 21))
        button.setImage(arrowImage, for: .normal)
        button.contentMode = UIViewContentMode.scaleAspectFit
        button.sizeToFit()
        button.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    private func createBackBarButtonArrowsImage(_ color: UIColor = UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 0.5), in size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()!
        
        let x1: CGFloat = size.width - 2
        let y1: CGFloat = 2
        
        let x2: CGFloat = 2
        let y2: CGFloat = size.height / 2
        
        let x3: CGFloat = size.width - 2
        let y3: CGFloat = size.height - 2
        
        
        context.beginPath()
        color.set()
        context.setLineWidth(3.0)
        context.move(to: CGPoint(x: x1, y: y1))
        context.addLine(to: CGPoint(x: x2, y: y2))
        context.addLine(to: CGPoint(x: x3, y: y3))
        context.strokePath()
        let theImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return theImage
    }
}

extension NSObject {
    func setAssociatedObject(_ value: AnyObject?, associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy) {
        if let valueAsAnyObject = value {
            objc_setAssociatedObject(self, associativeKey, valueAsAnyObject, policy)
        }
    }
    
    func getAssociatedObject(_ associativeKey: UnsafeRawPointer) -> Any? {
        guard let valueAsType = objc_getAssociatedObject(self, associativeKey) else {
            return nil
        }
        return valueAsType
    }
}
