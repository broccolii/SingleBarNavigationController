//
//  RootNavigationController.swift
//  SingleBarNavigationController
//
//  Created by Broccoli on 2016/10/27.
//  Copyright © 2016年 broccoliii. All rights reserved.
//

import Foundation
import UIKit

func SafeWrapViewController(controller: UIViewController,
                            navigationBarClass: AnyClass? = nil,
                            withPlaceholder: Bool = false,
                            backItem: UIBarButtonItem? = nil,
                            backTitle: String? = nil) -> UIViewController {
    if !(controller is WrapperViewController) {
        return WrapperViewController(controller: controller, navigationBarClass: navigationBarClass, withPlaceholderController: withPlaceholder, back: backItem, backTitle: backTitle)
    }
    return controller
}

func SafeUnwrapViewController(controller: UIViewController) -> UIViewController {
    
    if (controller is WrapperViewController) {
        return (controller as! WrapperViewController).contentViewController
    }
    return controller
}


 class RootNavigationController: UINavigationController, UINavigationControllerDelegate {
    fileprivate weak var rt_delegate: UINavigationControllerDelegate?
    fileprivate var animationBlock: ((Bool) -> Void)?

    // TOOD: 加 is
   @IBInspectable var useSystemBackBarButtonItem = false
   @IBInspectable var transferNavigationBarAttributes = false
    
    var rt_topViewController: UIViewController {
        return SafeUnwrapViewController(controller: super.topViewController!)
    }
    
    var rt_visibleViewController: UIViewController {
        return SafeUnwrapViewController(controller: super.visibleViewController!)
    }
    
    var rt_viewControllers: [UIViewController] {
        return super.viewControllers.map({ (viewController) -> UIViewController in
            return SafeUnwrapViewController(controller: viewController)
        })
    }

    func onBack(_ sender: Any) {
        _ = self.popViewController(animated: true)
    }
    
    func _commonInit() {
    
    }
    
    
    // MARK: - Overrides
    override  func awakeFromNib() {
        self.viewControllers = super.viewControllers
    }
    
    required  init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: SafeWrapViewController(controller: rootViewController, navigationBarClass: rootViewController.navigationBarClass))
    }
    
    convenience init(rootViewControllerNoWrapping rootViewController: UIViewController) {
        self.init()
        
        super.pushViewController(rootViewController, animated: false)
    }
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        super.delegate = self
        
        super.setNavigationBarHidden(true, animated: false)
//        super.navigationBar.isHidden = true
//        super.isNavigationBarHidden = true
//        self.isNavigationBarHidden = true
        
    }

    @available(iOS, introduced: 6.0, deprecated: 9.0)
    func forUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> UIViewController? {
        var viewController = super.forUnwindSegueAction(action, from: fromViewController, withSender: sender)
        
        if viewController == nil {
            if let index = self.viewControllers.index(of: fromViewController) {
                for i in 0..<index {
                    if let _ = self.viewControllers[i].forUnwindSegueAction(action, from: fromViewController, withSender: sender) {
                        viewController = self.viewControllers[i].forUnwindSegueAction(action, from: fromViewController, withSender: sender)
                        break
                    }
                }
            }
        }
        return viewController
    }
    
    override  func setNavigationBarHidden(_ hidden:  Bool, animated:  Bool) {
        // Override to protect
    }

    override  func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            let currentLast = SafeUnwrapViewController(controller: self.viewControllers.last!)
            super.pushViewController(SafeWrapViewController(controller: viewController,
                                                            navigationBarClass: viewController.navigationBarClass,
                                                            withPlaceholder: self.useSystemBackBarButtonItem,
                                                            backItem: currentLast.navigationItem.backBarButtonItem,
                                                            backTitle: currentLast.title),
                                     animated: animated)
        } else {
            super.pushViewController(SafeWrapViewController(controller: viewController, navigationBarClass: viewController.navigationBarClass), animated: animated)
        }
    }

    override  func popViewController(animated: Bool) -> UIViewController {
        return SafeUnwrapViewController(controller: super.popViewController(animated: animated)!)
    }
    
    override  func popToRootViewController(animated: Bool) -> [UIViewController]? {
        return super.popToRootViewController(animated: animated)!.map{ (viewController) -> UIViewController in
          SafeUnwrapViewController(controller: viewController)
        }
    }

    override  func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        var controllerToPop: UIViewController? = nil
        for item in super.viewControllers {
            if SafeUnwrapViewController(controller: item) == viewController {
                controllerToPop = item
                break
            }
        }
        
        if controllerToPop != nil {
            return super.popToViewController(controllerToPop!, animated: animated)!.map({ (viewController) -> UIViewController in
                return SafeUnwrapViewController(controller: viewController)
            })
        }
        return nil
    }
    
    override  func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        var vcs = [UIViewController]()
        for (index, viewController) in viewControllers.enumerated() {
            if self.useSystemBackBarButtonItem && index > 0 {
                vcs.append(SafeWrapViewController(controller: viewController, navigationBarClass: viewController.navigationBarClass, withPlaceholder: self.useSystemBackBarButtonItem, backItem: viewControllers[index - 1].navigationItem.backBarButtonItem, backTitle: viewControllers[index - 1].title))
            } else {
                vcs.append(SafeWrapViewController(controller: viewController, navigationBarClass: viewController.navigationBarClass))
            }
        }
        super.setViewControllers(vcs, animated: animated)
    }
    
//    override  var delegate: UINavigationControllerDelegate? {
//        set {
//            self.rt_delegate = delegate
//        }
//        
//        get {
//            return self.rt_delegate
//        }
//    }
    
    override  var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? false
    }

    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? .portrait
    }

    override  var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
         return self.topViewController?.preferredInterfaceOrientationForPresentation ?? .unknown
    }

    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Header views are animated along with the rest of the view hierarchy")
    override  func rotatingHeaderView() -> UIView? {
        return self.topViewController?.rotatingHeaderView()
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Footer views are animated along with the rest of the view hierarchy")
    override  func rotatingFooterView() -> UIView? {
        return self.topViewController?.rotatingFooterView()
    }
    
    override  func responds(to aSelector: Selector) -> Bool {
        if super.responds(to: aSelector) {
            return true
        }
        // TODO
        
        return self.rt_delegate?.responds(to: aSelector) ?? false
    }

    override  func forwardingTarget(for aSelector: Selector) -> Any? {
        return self.rt_delegate
    }
    
     func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        var viewController = viewController
        let isRootVC = viewController == navigationController.viewControllers.first!
        if !isRootVC {
            viewController = SafeUnwrapViewController(controller: viewController)
            if !self.useSystemBackBarButtonItem && viewController.navigationItem.leftBarButtonItem == nil {
                viewController.navigationItem.leftBarButtonItem = viewController.customBackItem(withTarget: self, action: #selector(self.onBack))
            }
        }
        
        self.rt_delegate?.navigationController!(navigationController, willShow: viewController, animated: animated)
    }
    
     func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        var viewController = viewController
        let isRootVC = viewController == navigationController.viewControllers.first!
        viewController = SafeUnwrapViewController(controller: viewController)
        if viewController.disableInteractivePopGesture {
            self.interactivePopGestureRecognizer?.delegate = nil
            self.interactivePopGestureRecognizer?.isEnabled = false
        } else {
            self.interactivePopGestureRecognizer?.delaysTouchesBegan = true
            self.interactivePopGestureRecognizer?.delegate = self
            self.interactivePopGestureRecognizer?.isEnabled = !isRootVC
        }
        RootNavigationController.attemptRotationToDeviceOrientation()
        if (self.animationBlock != nil) {
            self.animationBlock!(true)
            self.animationBlock = nil
        }
        self.rt_delegate?.navigationController!(navigationController, didShow: viewController, animated: animated)
    }
    
     func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        if self.rt_delegate != nil {
            return self.rt_delegate!.navigationControllerSupportedInterfaceOrientations!(navigationController)
        }
        return .all
    }
    
     func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        if self.rt_delegate != nil {
            return self.rt_delegate!.navigationControllerPreferredInterfaceOrientationForPresentation!(navigationController)
        }
        return .portrait
    }
    
     func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if self.rt_delegate != nil {
            return self.rt_delegate!.navigationController!(navigationController, interactionControllerFor: animationController)!
        }
        return nil
    }
    
     func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if self.rt_delegate != nil {
            return self.rt_delegate!.navigationController!(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
        }
        return nil
    }
}

extension RootNavigationController {
    // MARK: -  Methods
    func remove(_ controller: UIViewController) {
        self.remove(controller, animated: false)
    }
    
    func remove(_ controller: UIViewController, animated flag: Bool) {
        var controllers = self.viewControllers
        var controllerToRemove: UIViewController? = nil

        controllers.forEach { (viewController) in
            if SafeUnwrapViewController(controller: viewController) == controller {
                controllerToRemove = viewController
            }
        }
        if controllerToRemove != nil {
            controllers.remove(at: controllers.index(of: controllerToRemove!)!)
            super.setViewControllers(controllers, animated: flag)
        }
    }

    func push(_ viewController: UIViewController, animated: Bool, complete block: @escaping (Bool) -> Void) {
        if (self.animationBlock != nil) {
            self.animationBlock!(false)
        }
        self.animationBlock = block
        self.pushViewController(viewController, animated: animated)
    }

    func popToViewController(viewController: UIViewController, animated: Bool, complete block: @escaping (Bool) -> Void) -> [UIViewController]? {
        if (self.animationBlock != nil) {
            self.animationBlock!(false)
        }
        self.animationBlock = block
        let array = self.popToViewController(viewController, animated: animated)
        if let _ = array,
            array!.count > 0 {
            if (self.animationBlock != nil) {
                self.animationBlock = nil
            }
        }
        return array
    }

    func popToRootViewController(animated: Bool, complete block: @escaping (Bool) -> Void) -> [UIViewController]? {
        if (self.animationBlock != nil) {
            self.animationBlock!(false)
        }
        self.animationBlock = block
        let array = self.popToRootViewController(animated: animated)
        if let _ = array,
            array!.count > 0 {
            if (self.animationBlock != nil) {
                self.animationBlock = nil
            }
        }
        return array
    }
}

extension RootNavigationController: UIGestureRecognizerDelegate {
    
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (gestureRecognizer == self.interactivePopGestureRecognizer)
    }
}
