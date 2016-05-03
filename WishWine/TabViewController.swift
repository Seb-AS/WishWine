//
//  TabViewController.swift
//  WishWine
//
//  Created by Sebas on 5/2/16.
//  Copyright © 2016 Sebas. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
    
    private var previousItem: UITabBarItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        if item == previousItem {
            return
        }
        
        var splitViewController:UISplitViewController? = nil
        
        if(item.tag == 0) {
            
            for viewController in self.viewControllers! {
                if viewController.title == "Master" {
                    splitViewController = viewController as? UISplitViewController
                }
            }
        }
        else if(item.tag == 1) {
            for viewController in self.viewControllers! {
                if viewController.title == "Wish" {
                    splitViewController = viewController as? UISplitViewController
                }
            }
        }
        if let navController = splitViewController?.viewControllers[0] as? UINavigationController {
            navController.topViewController!.navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem()
            navController.popToRootViewControllerAnimated(true)
        }
        
        previousItem = item
    }
}