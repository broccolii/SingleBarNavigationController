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
        var wrapperViewController: UIViewController? = self
        while (wrapperViewController as? ExclusiveNavigationController) == nil && wrapperViewController != nil {
            wrapperViewController =  wrapperViewController?.navigationController
        }
        return wrapperViewController as? ExclusiveNavigationController
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
        let arrowImage = createBackBarButtonArrowImage((self.navigationController?.navigationBar.tintColor)!, in: CGSize(width: 13, height: 21))
        button.setImage(arrowImage, for: .normal)
        button.contentMode = UIViewContentMode.scaleAspectFit
        button.sizeToFit()
        button.addTarget(target, action: action, for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: button)
        return backBarButtonItem
    }
    
    private func createBackBarButtonArrowImage(_ color: UIColor = UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 0.5), in size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        
        let point1 = CGPoint(x: size.width - 2, y: 2)
        let point2 = CGPoint(x: 2, y: size.height / 2)
        let point3 = CGPoint(x: size.width - 2, y: size.height - 2)
        
        context.beginPath()
        color.set()
        context.setLineWidth(3.0)
        context.move(to: point1)
        context.addLine(to: point2)
        context.addLine(to: point3)
        context.setStrokeColor(UIColor.white.cgColor)
        context.strokePath()
        let arrowImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return arrowImage
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
