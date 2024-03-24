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
//        tabBarController?.tabBar.unselectedItemTintColor = UIColor(resource: .disabled)
////        tabBarController?.tabBar.selectedImageTintColor = UIColor(resource: .brandPurple)
//        tabBarController?.tabBar.tintColor = UIColor(resource: .brandPurple)
        
        
        let firstVC = HomeController()
        firstVC.hidesBottomBarWhenPushed = false
        firstVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        firstVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0);

        let secondVC = MyBooksController()
        secondVC.tabBarItem = UITabBarItem(title: "My Books", image: UIImage(systemName: "books.vertical.fill"), tag: 0)
        secondVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0);
        
        
        let thirdVC = SearchView()
        thirdVC.hidesBottomBarWhenPushed = false
        thirdVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "sparkle.magnifyingglass"), tag: 0)
        thirdVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0);
        
        
        let forthVC = MoreController()
        forthVC.tabBarItem = UITabBarItem(title: "More", image: UIImage(systemName: "ellipsis"), tag: 0)
        forthVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0);
        
        
        viewControllers = [firstVC, secondVC, thirdVC, forthVC]
        
    }
    
    
}
