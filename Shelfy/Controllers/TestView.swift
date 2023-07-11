//
//  TestView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit

class TestView: UIViewController {
    
    
    @IBOutlet weak var uiViewOutlet: UIView!
        
        @IBOutlet weak var segmentControlOutlet: UISegmentedControl!
        
        override func viewDidLoad() {
            super.viewDidLoad()

            
            let font = UIFont(name: "MicroPremium-Regular", size: 16)
            segmentControlOutlet.setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .selected)
            let font2 = UIFont(name: "MicroPremium-Light", size: 16)
            segmentControlOutlet.setTitleTextAttributes([NSAttributedString.Key.font: font2!], for: .normal)
            segmentControlOutlet.setTitleTextAttributes([.foregroundColor: UIColor(named: "Accent5")], for: .normal)
            segmentControlOutlet.setTitleTextAttributes([.foregroundColor: UIColor(named: "Accent6")], for: .selected)
//            segmentControlOutlet.setTitleTextAttributes([.foregroundColor: UIColor(named: "Accent6")!], for: .normal)
//            segmentControlOutlet.setTitleTextAttributes([.foregroundColor: UIColor(named: "Accent6")!], for: .selected)
        }

    
    
    
}
