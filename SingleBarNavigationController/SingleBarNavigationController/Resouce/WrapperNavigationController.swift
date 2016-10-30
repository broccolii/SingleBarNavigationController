//
//  WrapperNavigationController.swift
//  SingleBarNavigationController
//
//  Created by Broccoli on 2016/10/27.
//  Copyright © 2016年 broccoliii. All rights reserved.
//

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
        pushViewController(rootViewController, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.isEnabled = false
        if let mainNavigationController = exclusiveNavigationController,
            mainNavigationController.isTransferNavigationBarAttributes {
            navigationBar.isTranslucent                =  navigationController!.navigationBar.isTranslucent
            navigationBar.tintColor                    =  navigationController!.navigationBar.tintColor
            navigationBar.barTintColor                 =  navigationController?.navigationBar.barTintColor
            navigationBar.barStyle                     =  navigationController!.navigationBar.barStyle
            navigationBar.backgroundColor              =  navigationController!.navigationBar.backgroundColor
            navigationBar.titleTextAttributes          =  navigationController!.navigationBar.titleTextAttributes
            navigationBar.shadowImage                  =  navigationController!.navigationBar.shadowImage
            navigationBar.backIndicatorImage           =  navigationController!.navigationBar.backIndicatorImage
            navigationBar.backIndicatorTransitionMaskImage =  navigationController!.navigationBar.backIndicatorTransitionMaskImage
            
            navigationBar.setBackgroundImage( navigationController?.navigationBar.backgroundImage(for: .default), for: .default)
            navigationBar.setTitleVerticalPositionAdjustment( navigationController!.navigationBar.titleVerticalPositionAdjustment(for: .default), for: .default)
        }
        view.layoutIfNeeded()
    }
    
    override var tabBarController: UITabBarController? {
        let superTabBarController = super.tabBarController
        let navigationController =  exclusiveNavigationController
        if (superTabBarController != nil) {
            if let tabBarController = navigationController?.tabBarController,
                tabBarController != superTabBarController {
                return superTabBarController
            } else {
                let BoolValue = navigationController!.exclusiveViewControllers.any({ (viewController) -> Bool in
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
    override func forUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any?) -> UIViewController? {
        if navigationController != nil {
            return navigationController!.forUnwindSegueAction(action, from:  parent!, withSender: sender)!
        }
        return super.forUnwindSegueAction(action, from: fromViewController, withSender: sender)
    }
    
    @available(iOS 9.0, *)
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        if navigationController != nil {
            return navigationController!.allowedChildViewControllersForUnwinding(from: source)
        }
        return super.allowedChildViewControllersForUnwinding(from: source)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if navigationController != nil {
            navigationController!.pushViewController(viewController, animated: animated)
        } else {
            super.pushViewController(viewController, animated: animated)
        }
    }
    
    override func forwardingTarget(for aSelector: Selector) -> Any? {
        if navigationController!.responds(to: aSelector) {
            return navigationController!
        }
        return nil
    }
    
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if navigationController != nil {
            return navigationController!.popViewController(animated: animated)
        }
        return super.popViewController(animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if navigationController != nil {
            return  navigationController!.popToRootViewController(animated: animated)
        }
        return super.popToRootViewController(animated: animated)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if navigationController != nil {
            return  navigationController!.popToViewController(viewController, animated: animated)
        }
        return super.popToViewController(viewController, animated: animated)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if navigationController != nil {
            navigationController!.setViewControllers(viewControllers, animated: animated)
        } else {
            super.setViewControllers(viewControllers, animated: animated)
        }
    }
    
    override var delegate: UINavigationControllerDelegate? {
        set {
            if navigationController != nil {
                navigationController!.delegate = newValue
            } else {
                super.delegate = newValue
            }
        }
        
        get {
            return super.delegate
        }
    }
    
    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(hidden, animated: animated)
        
        guard let visible = visibleViewController,
            visible.disableInteractivePopGesture else {
            return
        }
        visibleViewController?.disableInteractivePopGesture = hidden
    }
}
