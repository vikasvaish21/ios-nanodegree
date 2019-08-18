//
//  TabBarViewController.swift
//  MarvelComics
//
//  Created by vikas on 13/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import UIKit
class TabBarViewController:UITabBarController{
    var previousController:UIViewController?
        
        override func viewDidLoad(){
            super.viewDidLoad()
            self.delegate = self
        }
    }
    
    extension TabBarViewController:UITabBarControllerDelegate{
        func tabBarController(_ tabBarController: UITabBarController,shouldSelect viewController: UIViewController) -> Bool{
            if previousController == viewController || previousController == nil{
                let navigation = viewController as! UINavigationController
                if navigation.viewControllers.count < 2{
                    guard let heroesVC = navigation.topViewController as? HeroesViewController else{
                        return true
                    }
                    heroesVC.scrollToTop()
                }
            }
            self.previousController = viewController;
            return true
        }
    }
