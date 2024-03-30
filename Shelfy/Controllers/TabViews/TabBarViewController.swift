//
//  TabBarViewController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 22.03.2024.
//

import UIKit

public class TabBarViewController: UITabBarController {
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViewControllers()
        
    }
    
    func setupViewControllers() {
        
        view.backgroundColor = UIColor(resource: .background)
        
        let vc1 = HomeController()
        let vc2 = ShelfyController()
        let vc3 = SearchController()
        let vc4 = MoreController()
        
        vc1.tabBarItem.image = UIImage(systemName: "house.fill")
        vc2.tabBarItem.image = UIImage(systemName: "books.vertical.fill")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "ellipsis")
        
        vc1.tabBarItem.title = "Home"
        vc2.tabBarItem.title = "My Books"
        vc3.tabBarItem.title = "Search"
        vc4.tabBarItem.title = "More"
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)

        tabBar.tintColor = UIColor(resource: .brandDarkPurple)
        tabBar.unselectedItemTintColor = UIColor.gray
        tabBar.backgroundColor = UIColor(resource: .background)
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
    }
    
    
}
