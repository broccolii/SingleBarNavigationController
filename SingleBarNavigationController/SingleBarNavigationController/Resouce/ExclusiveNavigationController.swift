//
//  ExclusiveNavigationController.swift
//  SingleBarNavigationController
//
//  Created by Broccoli on 2016/10/27.
//  Copyright © 2016年 broccoliii. All rights reserved.
//

import Foundation
import UIKit

fileprivate func SafeWrapViewController(_ viewController: UIViewController,
                                        navigationBarClass: AnyClass? = nil,
                                        useSystemBackBarButtonItem: Bool = false,
                                        backBarButtonItem: UIBarButtonItem? = nil,
                                        backTitle: String? = nil) -> UIViewController {
    if !(viewController is WrapperViewController) {
        return WrapperViewController(viewController,
                                     navigationBarClass: navigationBarClass,
                                     backBarButtonItem: backBarButtonItem,
                                     useSystemBackBarButtonItem: useSystemBackBarButtonItem,
                                     backTitle: backTitle)
    }
    return viewController
}

fileprivate func SafeUnwrapViewController(_ viewController: UIViewController) -> UIViewController {
    if (viewController is WrapperViewController) {
        return (viewController as! WrapperViewController).contentViewController
    }
    return viewController
}


open class ExclusiveNavigationController: UINavigationController, UINavigationControllerDelegate {
    fileprivate weak var exclusiveDelegate: UINavigationControllerDelegate?
    fileprivate var animationBlock: ((Bool) -> Void)?
    
    @IBInspectable var isUseSystemBackBarButtonItem = false
    @IBInspectable var isTransferNavigationBarAttributes = true
    
    var exclusiveTopViewController: UIViewController {
        return SafeUnwrapViewController(super.topViewController!)
    }
    
    var exclusiveVisibleViewController: UIViewController {
        return SafeUnwrapViewController(super.visibleViewController!)
    }
    
    var exclusiveViewControllers: [UIViewController] {
        return super.viewControllers.map{ (viewController) -> UIViewController in
            return SafeUnwrapViewController(viewController)
        }
    }
    
    func onBack(_ sender: Any) {
        _ = popViewController(animated: true)
    }
    
    
    // MARK: - Overrides
    override open func awakeFromNib() {
        viewControllers = super.viewControllers
    }
    
    required public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: SafeWrapViewController(rootViewController, navigationBarClass: rootViewController.navigationBarClass))
    }
    
    convenience init(rootViewControllerNoWrapping rootViewController: UIViewController) {
        self.init()
        super.pushViewController(rootViewController, animated: false)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        super.delegate = self
        super.setNavigationBarHidden(true, animated: false)
    }
    
    @available(iOS, introduced: 6.0, deprecated: 9.0)
    func forUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> UIViewController? {
        var viewController = super.forUnwindSegueAction(action, from: fromViewController, withSender: sender)
        
        if viewController == nil {
            if let index = viewControllers.index(of: fromViewController) {
                for i in 0..<index {
                    if let _ = viewControllers[i].forUnwindSegueAction(action, from: fromViewController, withSender: sender) {
                        viewController = viewControllers[i].forUnwindSegueAction(action, from: fromViewController, withSender: sender)
                        break
                    }
                }
            }
        }
        return viewController
    }
    
    override open func setNavigationBarHidden(_ hidden:  Bool, animated:  Bool) {}
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            let currentLast = SafeUnwrapViewController(viewControllers.last!)
            super.pushViewController(SafeWrapViewController(viewController,
                                                            navigationBarClass: viewController.navigationBarClass,
                                                            useSystemBackBarButtonItem: isUseSystemBackBarButtonItem,
                                                            backBarButtonItem: currentLast.navigationItem.backBarButtonItem,
                                                            backTitle: currentLast.title),
                                     animated: animated)
        } else {
            super.pushViewController(SafeWrapViewController(viewController, navigationBarClass: viewController.navigationBarClass), animated: animated)
        }
    }
    
    override open func popViewController(animated: Bool) -> UIViewController {
        return SafeUnwrapViewController(super.popViewController(animated: animated)!)
    }
    
    override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if let viewControllers = super.popToRootViewController(animated: animated) {
            return viewControllers.map{ (viewController) -> UIViewController in
                SafeUnwrapViewController(viewController)
            }
        } else {
            return nil
        }
    }
    
    override open func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        var controllerToPop: UIViewController? = nil
        for item in super.viewControllers {
            if SafeUnwrapViewController(item) == viewController {
                controllerToPop = item
                break
            }
        }
        
        if controllerToPop != nil {
            if let viewControllers = super.popToRootViewController(animated: animated) {
                return viewControllers.map{ (viewController) -> UIViewController in
                    return SafeUnwrapViewController(viewController)
                }
            }
            return nil
        }
        return nil
    }
    
    override open func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        var wrapViewControllers = [UIViewController]()
        for (index, viewController) in viewControllers.enumerated() {
            if isUseSystemBackBarButtonItem && index > 0 {
                wrapViewControllers.append(SafeWrapViewController(viewController,
                                                  navigationBarClass: viewController.navigationBarClass,
                                                  useSystemBackBarButtonItem: isUseSystemBackBarButtonItem,
                                                  backBarButtonItem: viewControllers[index - 1].navigationItem.backBarButtonItem,
                                                  backTitle: viewControllers[index - 1].title))
            } else {
                wrapViewControllers.append(SafeWrapViewController(viewController, navigationBarClass: viewController.navigationBarClass))
            }
        }
        super.setViewControllers(wrapViewControllers, animated: animated)
    }
    
    override open var delegate: UINavigationControllerDelegate? {
        set {
            exclusiveDelegate = newValue
        }
        get {
            return super.delegate
        }
    }
    
    override open var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.preferredInterfaceOrientationForPresentation ?? .unknown
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Header views are animated along with the rest of the view hierarchy")
    override open func rotatingHeaderView() -> UIView? {
        return topViewController?.rotatingHeaderView()
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Footer views are animated along with the rest of the view hierarchy")
    override open func rotatingFooterView() -> UIView? {
        return topViewController?.rotatingFooterView()
    }
    
    override open func responds(to aSelector: Selector) -> Bool {
        if super.responds(to: aSelector) {
            return true
        }
        
        return exclusiveDelegate?.responds(to: aSelector) ?? false
    }
    
    override open func forwardingTarget(for aSelector: Selector) -> Any? {
        return exclusiveDelegate
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        var viewController = viewController
        let isRootVC = viewController == navigationController.viewControllers.first!
        if !isRootVC {
            viewController = SafeUnwrapViewController(viewController)
            if !isUseSystemBackBarButtonItem && viewController.navigationItem.leftBarButtonItem == nil {
                viewController.navigationItem.leftBarButtonItem = viewController.customBackItem(withTarget: self, action: #selector(onBack))
            }
        }
        if let _ = exclusiveDelegate,
            exclusiveDelegate!.responds(to: #selector(UINavigationControllerDelegate.navigationController(_:willShow:animated:))){
            exclusiveDelegate!.navigationController!(navigationController, willShow: viewController, animated: animated)
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let isRootVC = viewController == navigationController.viewControllers.first!
        let unwrappedViewController = SafeUnwrapViewController(viewController)
        if unwrappedViewController.disableInteractivePopGesture {
            interactivePopGestureRecognizer?.delegate = nil
            interactivePopGestureRecognizer?.isEnabled = false
        } else {
            interactivePopGestureRecognizer?.delaysTouchesBegan = true
            interactivePopGestureRecognizer?.delegate = self
            interactivePopGestureRecognizer?.isEnabled = !isRootVC
        }
        ExclusiveNavigationController.attemptRotationToDeviceOrientation()
        if (animationBlock != nil) {
            animationBlock!(true)
            animationBlock = nil
        }
        
        if let _ = exclusiveDelegate,
            exclusiveDelegate!.responds(to: #selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:))){
            exclusiveDelegate?.navigationController!(navigationController, didShow: unwrappedViewController, animated: animated)
        }
    }
    
    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        if let _ = exclusiveDelegate,
            exclusiveDelegate!.responds(to: #selector(UINavigationControllerDelegate.navigationControllerSupportedInterfaceOrientations(_:))){
            return exclusiveDelegate!.navigationControllerSupportedInterfaceOrientations!(navigationController)
        }
        return .all
    }
    
    public func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        if let _ = exclusiveDelegate,
            exclusiveDelegate!.responds(to: #selector(UINavigationControllerDelegate.navigationControllerPreferredInterfaceOrientationForPresentation(_:))){
            return exclusiveDelegate!.navigationControllerPreferredInterfaceOrientationForPresentation!(navigationController)
        }
        return .portrait
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let _ = exclusiveDelegate,
            exclusiveDelegate!.responds(to: #selector(UINavigationControllerDelegate.navigationController(_:interactionControllerFor:))){
            return exclusiveDelegate!.navigationController!(navigationController, interactionControllerFor: animationController)!
        }
        return nil
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let _ = exclusiveDelegate,
            exclusiveDelegate!.responds(to: #selector(UINavigationControllerDelegate.navigationController(_:animationControllerFor:from:to:))){
            return exclusiveDelegate!.navigationController!(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
        }
        return nil
    }
}

public extension ExclusiveNavigationController {
    // MARK: -  Methods
    func remove(_ controller: UIViewController) {
        remove(controller, animated: false)
    }
    
    func remove(_ controller: UIViewController, animated flag: Bool) {
        var controllers = viewControllers
        var controllerToRemove: UIViewController? = nil
        
        controllers.forEach { (viewController) in
            if SafeUnwrapViewController(viewController) == controller {
                controllerToRemove = viewController
            }
        }
        if controllerToRemove != nil {
            controllers.remove(at: controllers.index(of: controllerToRemove!)!)
            super.setViewControllers(controllers, animated: flag)
        }
    }
    
    func push(_ viewController: UIViewController, animated: Bool, complete block: @escaping (Bool) -> Void) {
        if (animationBlock != nil) {
            animationBlock!(false)
        }
        animationBlock = block
        pushViewController(viewController, animated: animated)
    }
    
    func popToViewController(viewController: UIViewController, animated: Bool, complete block: @escaping (Bool) -> Void) -> [UIViewController]? {
        if (animationBlock != nil) {
            animationBlock!(false)
        }
        animationBlock = block
        let array = popToViewController(viewController, animated: animated)
        if let _ = array,
            array!.count > 0 {
            if (animationBlock != nil) {
                animationBlock = nil
            }
        }
        return array
    }
    
    func popToRootViewController(animated: Bool, complete block: @escaping (Bool) -> Void) -> [UIViewController]? {
        if (animationBlock != nil) {
            animationBlock!(false)
        }
        animationBlock = block
        let array = popToRootViewController(animated: animated)
        if let _ = array,
            array!.count > 0 {
            if (animationBlock != nil) {
                animationBlock = nil
            }
        }
        return array
    }
}

extension ExclusiveNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (gestureRecognizer == interactivePopGestureRecognizer)
    }
}

