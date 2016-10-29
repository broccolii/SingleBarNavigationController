//
//  WrapperNavigationController.swift
//  SingleBarNavigationController
//
//  Created by Broccoli on 2016/10/27.
//  Copyright © 2016年 broccoliii. All rights reserved.
//

import Foundation
import UIKit

internal class WrapperNavigationController: UINavigationController {
    
    required override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: rootViewController.navigationBarClass, toolbarClass: nil)
        self.pushViewController(rootViewController, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.isEnabled = false
        if let mainNavigationController = self.rt_navigationController,
            mainNavigationController.transferNavigationBarAttributes {
            self.navigationBar.isTranslucent                = self.navigationController!.navigationBar.isTranslucent
            self.navigationBar.tintColor                    = self.navigationController!.navigationBar.tintColor
            self.navigationBar.barTintColor                 = self.navigationController?.navigationBar.barTintColor
            self.navigationBar.barStyle                     = self.navigationController!.navigationBar.barStyle
            self.navigationBar.backgroundColor              = self.navigationController!.navigationBar.backgroundColor
            self.navigationBar.titleTextAttributes          = self.navigationController!.navigationBar.titleTextAttributes
            self.navigationBar.shadowImage                  = self.navigationController!.navigationBar.shadowImage
            self.navigationBar.backIndicatorImage           = self.navigationController!.navigationBar.backIndicatorImage
            self.navigationBar.backIndicatorTransitionMaskImage = self.navigationController!.navigationBar.backIndicatorTransitionMaskImage
            
            self.navigationBar.setBackgroundImage(self.navigationController?.navigationBar.backgroundImage(for: .default), for: .default)
            self.navigationBar.setTitleVerticalPositionAdjustment(self.navigationController!.navigationBar.titleVerticalPositionAdjustment(for: .default), for: .default)
        }
        self.view.layoutIfNeeded()
    }
    
   override var tabBarController: UITabBarController? {
        let superTabBarController = super.tabBarController
        let navigationController = self.rt_navigationController
        if (superTabBarController != nil) {
            if let tabBarController = navigationController?.tabBarController,
                tabBarController != superTabBarController {
                return superTabBarController
            } else {
                let BoolValue = navigationController!.rt_viewControllers.any({ (viewController) -> Bool in
                    return viewController.hidesBottomBarWhenPushed
                })
                if !superTabBarController!.tabBar.isTranslucent || BoolValue {
                    return nil
                } else {
                    return superTabBarController
                }
            }
        }
        return nil
    }
   
    @available(iOS, introduced: 6.0, deprecated: 9.0)
    func forUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> UIViewController? {
        if self.navigationController != nil {
            return self.navigationController!.forUnwindSegueAction(action, from: self.parent!, withSender: sender)!
        }
        return super.forUnwindSegueAction(action, from: fromViewController, withSender: sender)
    }
    
    @available(iOS 9.0, *)
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        if self.navigationController != nil {
            return self.navigationController!.allowedChildViewControllersForUnwinding(from: source)
        }
        return super.allowedChildViewControllersForUnwinding(from: source)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.navigationController != nil {
            self.navigationController!.pushViewController(viewController, animated: animated)
        } else {
            super.pushViewController(viewController, animated: animated)
        }
    }
    
    override func forwardingTarget(for aSelector: Selector) -> Any? {
        if self.navigationController!.responds(to: aSelector) {
            return self.navigationController!
        }
        return nil
    }
    
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if self.navigationController != nil {
            return self.navigationController!.popViewController(animated: animated)
        }
        return super.popViewController(animated: animated)
    }
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if self.navigationController != nil {
            return self.navigationController!.popToRootViewController(animated: animated)
        }
        return super.popToRootViewController(animated: animated)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if self.navigationController != nil {
            return self.navigationController!.popToViewController(viewController, animated: animated)
        }
        return super.popToViewController(viewController, animated: animated)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if self.navigationController != nil {
            self.navigationController!.setViewControllers(viewControllers, animated: animated)
        }
        else {
            super.setViewControllers(viewControllers, animated: animated)
        }
    }

    override var delegate: UINavigationControllerDelegate? {
        set {
            if self.navigationController != nil {
                self.navigationController!.delegate = newValue
            } else {
                super.delegate = newValue
            }
        }
        
        get {
            if self.navigationController != nil {
                return self.navigationController!.delegate
            } else {
               return super.delegate
            }
        }
    }
    
    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(hidden, animated: animated)
        if let visible = self.visibleViewController,
            visible.rt_hasSetInteractivePop {
            
        } else {
            self.visibleViewController?.disableInteractivePopGesture = hidden
        }
    }
}
