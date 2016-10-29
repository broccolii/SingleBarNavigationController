//
//  UIViewControllerExtension.swift
//  SingleBarNavigationController
//
//  Created by Broccoli on 2016/10/27.
//  Copyright © 2016年 broccoliii. All rights reserved.
//

import Foundation
import UIKit

fileprivate var kInteractivePopGestureKey = "kInteractivePopGestureKey"

extension UIViewController {
    
     var rt_navigationController: RootNavigationController? {
//        var rootNavigationController: RootNavigationController?
        if !(self is RootNavigationController) {
            return self.navigationController as? RootNavigationController
        }
        return self as? RootNavigationController
    }
    
    var disableInteractivePopGesture: Bool {
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
    
    var navigationBarClass: AnyClass? {
        return nil
    }
    
    func customBackItem(withTarget target: Any, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .plain, target: target, action: action)
    }
}

 extension UIViewController {
    var rt_hasSetInteractivePop: Bool {
        return (getAssociatedObject(&kInteractivePopGestureKey) as? Bool ?? false)
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
