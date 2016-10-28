//
//  WrapperNavigationController.swift
//  SingleBarNavigationController
//
//  Created by Broccoli on 2016/10/27.
//  Copyright © 2016年 broccoliii. All rights reserved.
//

import Foundation

class WrapperNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: rootViewController.navigationBarClass, toolbarClass: nil)
        self.pushViewController(rootViewController, animated: false)
        
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.isEnabled = false
        if self.rt_navigationController!.transferNavigationBarAttributes {
            self.navigationBar.isTranslucent = self.navigationController!.navigationBar.isTranslucent
            self.navigationBar.tintColor = self.navigationController!.navigationBar.tintColor
            self.navigationBar.barTintColor = self.navigationController?.navigationBar.barTintColor
            self.navigationBar.barStyle = self.navigationController!.navigationBar.barStyle
            self.navigationBar.backgroundColor = self.navigationController!.navigationBar.backgroundColor
            self.navigationBar.setBackgroundImage(self.navigationController?.navigationBar.backgroundImage(for: .default), for: .default)
            self.navigationBar.setTitleVerticalPositionAdjustment(self.navigationController!.navigationBar.titleVerticalPositionAdjustment(for: .default), for: .default)
            self.navigationBar.titleTextAttributes = self.navigationController!.navigationBar.titleTextAttributes
            self.navigationBar.shadowImage = self.navigationController!.navigationBar.shadowImage
            self.navigationBar.backIndicatorImage = self.navigationController!.navigationBar.backIndicatorImage
            self.navigationBar.backIndicatorTransitionMaskImage = self.navigationController!.navigationBar.backIndicatorTransitionMaskImage
        }
        self.view.layoutIfNeeded()
    }
    
   override var tabBarController: UITabBarController? {
        let tabController = super.tabBarController
        let navigationController = self.rt_navigationController
        if (tabController != nil) {
            if navigationController?.tabBarController! != tabController {
                return tabController!
            }
            else {
                let BoolValue = navigationController!.rt_viewControllers.any({ (viewController) -> Bool in
                    return viewController.hidesBottomBarWhenPushed
                })
                if !tabController!.tabBar.isTranslucent || BoolValue {
                    return nil
                } else {
                    return tabController
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
//        return init(for: action, from: fromViewController, withSender: sender)
        return nil
    }
    
//    @available(iOS 9.0, *)
//    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
//        if self.navigationController != nil {
//            if #available(iOS 9.0, *) {
//                return self.navigationController!.allowedChildViewControllersForUnwinding(from: source)
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//        if #available(iOS 9.0, *) {
//            return super.allowedChildViewControllersForUnwinding(from: source)
//        } else {
//            // Fallback on earlier versions
//        }
//    }
    
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
    
    
    override func popViewController(animated: Bool) -> UIViewController {
        if self.navigationController != nil {
            return self.navigationController!.popViewController(animated: animated)!
        }
        return super.popViewController(animated: animated)!
    }
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if self.navigationController != nil {
            return self.navigationController!.popToRootViewController(animated: animated)!
        }
        return super.popToRootViewController(animated: animated)!
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if self.navigationController != nil {
            return self.navigationController!.popToViewController(viewController, animated: animated)!
        }
        return super.popToViewController(viewController, animated: animated)!
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
            }
            else {
                super.delegate = newValue
            }
        }
        
        get {
            if self.navigationController != nil {
                return self.navigationController!.delegate
            }
            else {
               return super.delegate
            }
        }
    }
    
    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(hidden, animated: animated)
        if !(self.visibleViewController!.rt_hasSetInteractivePop) {
            self.visibleViewController!.disableInteractivePopGesture = hidden
        }
    }
    
    override var isNavigationBarHidden: Bool {
        set {
            super.setNavigationBarHidden(newValue, animated: false)
            if !self.visibleViewController!.rt_hasSetInteractivePop {
                self.visibleViewController!.disableInteractivePopGesture = newValue
            }
        }
        
        get {
            if self.navigationController != nil {
                return self.navigationController!.isNavigationBarHidden
            } else {
                return super.isNavigationBarHidden
            }
        }
    }
}
