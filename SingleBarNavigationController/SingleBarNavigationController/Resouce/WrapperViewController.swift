//
//  WrapperViewController.swift
//  SingleBarNavigationController
//
//  Created by Broccoli on 2016/10/27.
//  Copyright © 2016年 broccoliii. All rights reserved.
//

import Foundation
import UIKit

open class WrapperViewController: UIViewController {
    public private(set) var contentViewController: UIViewController!
    public private(set) var wrapperNavigationController: UINavigationController!
    
    // MARK: - Initialize
    internal class func containerController(with viewController: UIViewController,
                                            navigationBarClass: AnyClass? = nil,
                                            withPlaceholderController yesOrNo: Bool = false,
                                            back backItem: UIBarButtonItem? = nil,
                                            backTitle: String? = nil) -> Self {
        return self.init(viewController,
                         navigationBarClass: navigationBarClass,
                         backBarButtonItem: backItem,
                         useSystemBackBarButtonItem: yesOrNo,
                         backTitle: backTitle)
    }
    
    required public init() {
        super.init(nibName:nil, bundle:nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required convenience public init(_ viewController: UIViewController,
                                     navigationBarClass: AnyClass? = nil,
                                     backBarButtonItem item: UIBarButtonItem? = nil,
                                     useSystemBackBarButtonItem yesOrNo: Bool = false,
                                     backTitle: String? = nil) {
        self.init()
        contentViewController = viewController
        wrapperNavigationController = WrapperNavigationController(navigationBarClass: navigationBarClass, toolbarClass: nil)
//        wrapperNavigationController.navigationBar.barTintColor = UIColor.colorFromRGB(MainColor)
//        wrapperNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        if yesOrNo {
            let placeholderViewController = UIViewController()
            placeholderViewController.title = backTitle
            placeholderViewController.navigationItem.backBarButtonItem = item
            wrapperNavigationController.viewControllers = [placeholderViewController, viewController]
        }  else {
            wrapperNavigationController.viewControllers = [viewController]
        }
        addChildViewController(wrapperNavigationController)
        wrapperNavigationController.didMove(toParentViewController: self)
    }
    
    // MARK: - Overrides
    override open func viewDidLoad() {
        super.viewDidLoad()
        wrapperNavigationController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(wrapperNavigationController.view)
        view.backgroundColor = UIColor.white
        wrapperNavigationController.view.frame = view.bounds
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return contentViewController.preferredStatusBarStyle
    }
    
    override open var prefersStatusBarHidden: Bool {
        return contentViewController.prefersStatusBarHidden
    }
    
    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return contentViewController.preferredStatusBarUpdateAnimation
    }
    
    override open var shouldAutorotate: Bool {
        return contentViewController.shouldAutorotate
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return contentViewController.supportedInterfaceOrientations
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return contentViewController.preferredInterfaceOrientationForPresentation
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Header views are animated along with the rest of the view hierarchy")
    override open func rotatingHeaderView() -> UIView? {
        return contentViewController.rotatingHeaderView()
    }
    
    @available(iOS, introduced: 2.0, deprecated: 8.0, message: "Footer views are animated along with the rest of the view hierarchy")
    override open func rotatingFooterView() -> UIView? {
        return contentViewController.rotatingFooterView()
    }
    
    @available(iOS, introduced: 6.0, deprecated: 9.0)
    func forUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> UIViewController {
        return contentViewController.forUnwindSegueAction(action, from: fromViewController, withSender: sender)!
    }
    
    override open var hidesBottomBarWhenPushed: Bool {
        get {
            return contentViewController.hidesBottomBarWhenPushed
        }
        set {
            self.hidesBottomBarWhenPushed = newValue
        }
    }
    
    override open var title: String? {
        get {
            return contentViewController.title
        }
        set {
            self.title = newValue
        }
    }
    
    override open var tabBarItem: UITabBarItem? {
        get {
            return contentViewController.tabBarItem
        }
        set {
            self.tabBarItem = newValue
        }
    }
}
