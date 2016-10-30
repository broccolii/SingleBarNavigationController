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
        return UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .plain, target: target, action: action)
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
