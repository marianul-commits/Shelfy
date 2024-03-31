//
//  TestView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit
import CoreData
import NotificationBannerSwift
import SkeletonView
import Cosmos

class TestView: UIViewController {
    
    var progressView = UIProgressView()
    
    var btn = UIButton()
    
    var pagesRead = 0
    
    let progressBar = LevelManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = UIColor(resource: .brandDarkPurple)
        progressView.trackTintColor = UIColor(resource: .brandPurple)
        progressView.progressViewStyle = .bar
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        progressView.progress = Float(progressBar.currentValue)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Increment", for: .normal)
        btn.backgroundColor = .systemPink
        btn.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        progressBar.updateProgress(pagesRead: pagesRead)
        
        view.addSubview(progressView)
        view.addSubview(btn)
        
        NSLayoutConstraint.activate([
        
        
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2),
            btn.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            btn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
        
        ])
        
    }
    
    
    @objc func incrementButtonTapped(_ sender: UIButton) {
        pagesRead += 1000 // Increment the value by 10
        DispatchQueue.main.async{ [self] in
            progressBar.updateProgress(pagesRead: pagesRead)
            progressView.progress = progressBar.currentValue
        }
        print("pagesRead: ", pagesRead)
    }
    
}



