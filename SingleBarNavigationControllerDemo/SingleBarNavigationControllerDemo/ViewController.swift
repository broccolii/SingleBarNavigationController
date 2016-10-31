//
//  ViewController.swift
//  SingleBarNavigationControllerDemo
//
//  Created by Broccoli on 2016/10/28.
//  Copyright © 2016年 broccoliii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
    }

}



    
