//
//  RootNavigationController.swift
//  SingleBarNavigationController
//
//  Created by Broccoli on 2016/10/27.
//  Copyright © 2016年 broccoliii. All rights reserved.
//

import Foundation

func SafeWrapViewController(controller: UIViewController,
                            navigationBarClass: AnyClass? = nil,
                            withPlaceholder: Bool = false,
                            backItem: UIBarButtonItem? = nil,
                            backTitle: String? = nil) -> UIViewController {
    if !(controller is WrapperController) {
        return WrapperController(controller: controller, navigationBarClass: navigationBarClass, withPlaceholderController: withPlaceholder, back: backItem, backTitle: backTitle)
    }
    return controller
}

func SafeUnwrapViewController(controller: UIViewController) -> UIViewController {
    
    if (controller is WrapperController) {
        return (controller as! WrapperController).contentViewController
    }
    return controller
}

public class RootNavigationController: UINavigationController {
    // MARK: - Methods
    weak var rt_delegate: UINavigationControllerDelegate?
    var animationBlock: ((Bool) -> Void)?

    // TOOD: 加 is
   @IBInspectable var useSystemBackBarButtonItem = false
   @IBInspectable var transferNavigationBarAttributes = false
    var rt_visibleViewController: UIViewController {
        return SafeUnwrapViewController(controller: super.visibleViewController!)
    }
    
    var rt_viewControllers: [UIViewController] {
        return super.viewControllers.map({ (viewController) -> UIViewController in
            return SafeUnwrapViewController(controller: viewController)
        })
    }

    var rt_topViewController: UIViewController {
        return SafeUnwrapViewController(controller: super.topViewController!)
    }

    func onBack(_ sender: Any) {
        _ = self.popViewController(animated: true)
    }
    
    func _commonInit() {
    }
    
    // The output below is limited by 4 KB.
    // Upgrade your plan to remove this limitation.
    
    // MARK: - Overrides
    
    override open func awakeFromNib() {
        self.viewControllers = super.viewControllers
    }
    
    required public init() {
       super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self._commonInit()
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        
        self._commonInit()
        
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: SafeWrapViewController(controller: rootViewController, navigationBarClass: rootViewController.navigationBarClass))
        self._commonInit()
    }
    
    convenience init(rootViewControllerNoWrapping rootViewController: UIViewController) {
        self.init()
        
        super.pushViewController(rootViewController, animated: false)
        self._commonInit()
        
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        super.delegate = self
        super.setNavigationBarHidden(true, animated: false)
    }

    override open func setNavigationBarHidden(_ hidden:  Bool, animated:  Bool) {
        // Override to protect
    }

    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
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

    override open func popViewController(animated: Bool) -> UIViewController {
        return SafeUnwrapViewController(controller: super.popViewController(animated: animated)!)
    }
    
    override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
        return super.popToRootViewController(animated: animated)!.map{ (viewController) -> UIViewController in
          SafeUnwrapViewController(controller: viewController)
        }
    }

    override open func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController] {
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
        return []
    }
    
    override open func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
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
    
    override open var delegate: UINavigationControllerDelegate? {
        didSet {
            self.rt_delegate = delegate
        }
    }
//
//    func shouldAutorotate(to toInterfaceOrientation: UIInterfaceOrientation) -> Bool {
//        return self.topViewController!.shouldAutorotate(to: toInterfaceOrientation)
//    }
    
    override open var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? false
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? .portrait
    }

    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
         return self.topViewController?.preferredInterfaceOrientationForPresentation ?? .unknown
    }

    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Header views are animated along with the rest of the view hierarchy")
    override open func rotatingHeaderView() -> UIView? {
        return self.topViewController!.rotatingHeaderView()!
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Footer views are animated along with the rest of the view hierarchy")
    override open func rotatingFooterView() -> UIView? {
        return self.topViewController!.rotatingFooterView()!
    }
    
    override open func responds(to aSelector: Selector) -> Bool {
        if super.responds(to: aSelector) {
            return true
        }
        // TODO
        
        return self.rt_delegate?.responds(to: aSelector) ?? false
    }

    override open func forwardingTarget(for aSelector: Selector) -> Any {
        return self.rt_delegate
    }
}

extension RootNavigationController {
    // MARK: - Public Methods
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

    func pop(to viewController: UIViewController, animated: Bool, complete block: @escaping (Bool) -> Void) -> [Any] {
        if (self.animationBlock != nil) {
            self.animationBlock!(false)
        }
        self.animationBlock = block
        let array = self.popToViewController(viewController, animated: animated)
        if array.count > 0 {
            if (self.animationBlock != nil) {
                self.animationBlock = nil
            }
        }
        return array
    }

    func popToRootViewController(animated: Bool, complete block: @escaping (Bool) -> Void) -> [Any] {
        if (self.animationBlock != nil) {
            self.animationBlock!(false)
        }
        self.animationBlock = block
        let array = self.popToRootViewController(animated: animated)!
        if array.count > 0 {
            if (self.animationBlock != nil) {
                self.animationBlock = nil
            }
        }
        return array
    }
}

extension RootNavigationController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        var viewController = viewController
        let isRootVC = viewController == navigationController.viewControllers.first!
        if !isRootVC {
            viewController = SafeUnwrapViewController(controller: viewController)
            if !self.useSystemBackBarButtonItem && viewController.navigationItem.leftBarButtonItem != nil {
                viewController.navigationItem.leftBarButtonItem! = viewController.customBackItem(withTarget: self, action: #selector(self.onBack))
            }
        }
        if self.rt_delegate != nil {
            self.rt_delegate!.navigationController!(navigationController, willShow: viewController, animated: animated)
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        var viewController = viewController
        let isRootVC = viewController == navigationController.viewControllers.first!
        viewController = SafeUnwrapViewController(controller: viewController)
        if viewController.disableInteractivePopGesture {
            self.interactivePopGestureRecognizer?.delegate = nil
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
        else {
            self.interactivePopGestureRecognizer?.delaysTouchesBegan = true
            self.interactivePopGestureRecognizer?.delegate = self
            self.interactivePopGestureRecognizer?.isEnabled = !isRootVC
        }
        RootNavigationController.attemptRotationToDeviceOrientation()
        if (self.animationBlock != nil) {
            self.animationBlock!(true)
            self.animationBlock = nil
        }
        if self.rt_delegate != nil {
            self.rt_delegate!.navigationController!(navigationController, didShow: viewController, animated: animated)
        }
    }
    
    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        if self.rt_delegate != nil {
            return self.rt_delegate!.navigationControllerSupportedInterfaceOrientations!(navigationController)
        }
        return .all
    }
    
    public func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        if self.rt_delegate != nil {
            return self.rt_delegate!.navigationControllerPreferredInterfaceOrientationForPresentation!(navigationController)
        }
        return .portrait
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if self.rt_delegate != nil {
            return self.rt_delegate!.navigationController!(navigationController, interactionControllerFor: animationController)!
        }
        return nil
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if self.rt_delegate != nil {
            return self.rt_delegate!.navigationController!(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
        }
        return nil
    }
}

extension RootNavigationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (gestureRecognizer == self.interactivePopGestureRecognizer)
    }
}
