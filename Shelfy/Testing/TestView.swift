//
//  TestView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit

class TestView: UIViewController, UIScrollViewDelegate {
    
        let scrollView = UIScrollView()
        let pageControl = UIPageControl()
        let numberOfPages = 5 // Replace with the actual number of pages
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            scrollView.frame = view.bounds
            scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(numberOfPages), height: view.bounds.height)
            scrollView.isPagingEnabled = true
            scrollView.delegate = self
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            
            for pageIndex in 0..<numberOfPages {
                let pageView = UIView(frame: CGRect(x: CGFloat(pageIndex) * scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
                pageView.backgroundColor = UIColor(red: CGFloat(pageIndex) * 0.2, green: 0.5, blue: 0.7, alpha: 1.0)
                scrollView.addSubview(pageView)
            }
            
            view.addSubview(scrollView)
            
            pageControl.numberOfPages = numberOfPages
            pageControl.currentPage = 0
            pageControl.frame = CGRect(x: 0, y: view.bounds.height - 50, width: view.bounds.width, height: 50)
            view.addSubview(pageControl)
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = currentPage
        }
    }

