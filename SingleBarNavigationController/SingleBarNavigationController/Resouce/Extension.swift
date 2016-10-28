//
//  Extension.swift
//  SingleBarNavigationController
//
//  Created by Broccoli on 2016/10/27.
//  Copyright © 2016年 broccoliii. All rights reserved.
//

import Foundation

extension Array {
    func any(_ condition: (Element) -> Bool) -> Bool {
        for element in self {
            if condition(element) {
                return true
            }
        }
        
        return false
    }
}
