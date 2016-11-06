//
//  FullscreenPopGestureExtension.swift
//  SingleBarNavigationControllerDemo
//
//  Created by Broccoli on 2016/10/31.
//  Copyright © 2016年 broccoliii. All rights reserved.
//

import UIKit

//class FullscreenPopGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
//    
//    weak var navigationController: UINavigationController?
//    
//    private func gestureRecognizerShouldBegin(_ gestureRecognizer: UIPanGestureRecognizer) -> Bool {
//        // Ignore when no view controller is pushed into the navigation stack.
//        if self.navigationController!.viewControllers.count <= 1 {
//            return false
//        }
//        // Ignore when the active view controller doesn't allow interactive pop.
//        var topViewController = self.navigationController!.viewControllers.last!
//        if topViewController.fd_interactivePopDisabled {
//            return false
//        }
//        // Ignore when the beginning location is beyond max allowed initial distance to left edge.
//        var beginningLocation = gestureRecognizer.location(in: gestureRecognizer.view)
//        var maxAllowedInitialDistance: CGFloat = topViewController.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge
//        if maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance {
//            return false
//        }
//        // Ignore pan gesture when the navigation controller is currently in transition.
//        if (self.navigationController!.value(forKey: "_isTransitioning") as! String).boolValue {
//            return false
//        }
//        // Prevent calling the handler when the gesture begins in an opposite direction.
//        var translation = gestureRecognizer.translation(in: gestureRecognizer.view)
//        if translation.x <= 0 {
//            return false
//        }
//        return true
//    }
//}
