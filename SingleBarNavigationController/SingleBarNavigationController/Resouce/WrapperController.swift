//
//  WrapperController.swift
//  SingleBarNavigationController
//
//  Created by Broccoli on 2016/10/27.
//  Copyright © 2016年 broccoliii. All rights reserved.
//

import Foundation

class WrapperController: UIViewController {
    private(set) var contentViewController: UIViewController!
    private(set) var wrapperNavigationController: UINavigationController!
    
    //    class func containerController(with controller: UIViewController,
    //                                   navigationBarClass: AnyClass? = nil,
    //                                   withPlaceholderController yesOrNo: Bool = false,
    //                                   back backItem: UIBarButtonItem? = nil,
    //                                   backTitle: String? = nil) -> Self {
    //        return self.init(controller: controller, navigationBarClass: navigationBarClass, withPlaceholderController: yesOrNo, back: backItem, backTitle: backTitle)
    //    }
    //
    //    convenience init(controller: UIViewController,
    //                     navigationBarClass: AnyClass? = nil,
    //                     withPlaceholderController yesOrNo: Bool = false,
    //                     back backItem: UIBarButtonItem? = nil,
    //                     backTitle: String? = nil) {
    //        super.init()
    //        self.contentViewController = controller
    //        self.wrapperNavigationController = wrapperNavigationController(navigationBarClass: navigationBarClass, toolbarClass: nil)
    //        if yesOrNo {
    //            var vc = UIViewController()
    //            vc.title! = backTitle!
    //            vc.navigationItem.backBarButton! = backItem
    //            self.wrapperNavigationController.viewControllers = [vc, controller]
    //        }
    //        else {
    //            self.wrapperNavigationController.viewControllers = [controller]
    //        }
    //        self.addChildViewController(self.wrapperNavigationController)
    //        self.wrapperNavigationController.didMove(toParentViewController: self)
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wrapperNavigationController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.addSubview(self.wrapperNavigationController.view)
        self.wrapperNavigationController.view.frame = self.view.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.contentViewController.preferredStatusBarStyle
        
    }
    override var prefersStatusBarHidden: Bool {
        return self.contentViewController.prefersStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.contentViewController.preferredStatusBarUpdateAnimation
    }
    
    override var shouldAutorotate: Bool {
        return self.contentViewController.shouldAutorotate
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.contentViewController.supportedInterfaceOrientations
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.contentViewController.preferredInterfaceOrientationForPresentation
    }
    
    override func rotatingHeaderView() -> UIView? {
        return self.contentViewController.rotatingHeaderView()!
    }
    
    override func rotatingFooterView() -> UIView? {
        return self.contentViewController.rotatingFooterView()!
    }
    
    func forUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> UIViewController {
        return self.contentViewController.forUnwindSegueAction(action, from: fromViewController, withSender: sender)!
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            return self.contentViewController.hidesBottomBarWhenPushed
        }
        set {
            self.contentViewController.hidesBottomBarWhenPushed = newValue
        }
    }
    
    override var title: String? {
        get {
            return self.contentViewController.title
        }
        set {
            self.contentViewController.title = newValue
        }
    }
    
    override var tabBarItem: UITabBarItem? {
        get {
            return self.contentViewController.tabBarItem
        }
        set {
            self.contentViewController.tabBarItem = newValue
        }
    }
}
