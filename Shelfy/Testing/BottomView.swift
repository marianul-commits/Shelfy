//
//  MainView2.swift
//  Shelfy
//
//  Created by Marian Nasturica on 12.08.2023.
//

import UIKit

class BottomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = UIColor(named: "Background")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 400)
    }
    
}
