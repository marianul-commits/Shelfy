//
//  TestView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit

class TestView: UIViewController, UITextFieldDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        

        
    }
    
    func setupView() {
//        let newLbl = makeLabel(withText: "Testy McTestFace")
//        let newLbl2 = makeLabel(withText: "testora")
//        let newLbl3 = makeLabel(withText: "testiliciouse")
//        let newLbl4 = makeLabel(withText: "tester123")
        let colorView = makeView()
        let secondView = makeAnotherView()
        let testLbl = makeLabel(withText: "TEST")
        let testLbl2 = makeLabel(withText: "TEST2")
        let scrollView = makeScrollView()
        let longLbl = makeLabel(withText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin nec tempor odio, id sagittis nibh. Curabitur iaculis risus enim, non eleifend orci porta in. Suspendisse ac tortor vehicula, tempor dui a, finibus ligula. Sed et diam consequat, euismod eros tempus, pharetra nisl. Etiam porttitor sollicitudin massa volutpat faucibus. Aliquam nec nulla porta, molestie tellus nec, varius urna. Phasellus maximus sapien ut dolor eleifend, eget sollicitudin nisl iaculis. Aenean lobortis bibendum eleifend. Vestibulum sagittis pulvinar mauris sit amet mollis. Vestibulum tincidunt sapien tortor, in mollis felis dignissim ac. In quis orci quam. Duis at purus mi. Nunc maximus lacinia est, non gravida mi dignissim quis. Maecenas porttitor urna lacus, vel sollicitudin dolor dapibus sed. Etiam at tincidunt tellus. Maecenas at vehicula nibh. Donec tempor purus a ipsum malesuada eleifend. Etiam dapibus sem quis facilisis consequat. Vestibulum sollicitudin ut nisl a bibendum. Duis consequat sagittis consectetur. Aliquam bibendum molestie convallis. Pellentesque vestibulum, risus in dapibus tristique, lorem sem consequat purus, efficitur sodales nunc quam sed ante. Etiam cursus turpis eget orci auctor fringilla. Sed varius id orci ut pretium. Donec euismod, massa ac scelerisque venenatis, lectus nunc volutpat arcu, a luctus justo elit non metus. Phasellus et dui vitae orci molestie convallis. Pellentesque lacus mauris, lobortis eu tincidunt vitae, varius et sem. Nulla bibendum, tellus vitae interdum consequat, sapien augue porttitor nibh, a luctus arcu dolor eget magna. Nam egestas ullamcorper ante, non bibendum libero condimentum ac. Ut laoreet enim eu blandit scelerisque. Mauris vel leo tincidunt, pharetra nunc sit amet, feugiat ex. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam id laoreet neque. Quisque vulputate egestas turpis. Integer feugiat malesuada turpis sed vehicula. Aliquam diam libero, dictum a ex eu, luctus suscipit massa. Nulla vulputate eget sem sit amet ultrices. Duis in sem a quam laoreet ornare.")
        
        
        view.addSubview(colorView)
        colorView.addSubview(testLbl)
        colorView.addSubview(secondView)
        secondView.addSubview(testLbl2)
        secondView.addSubview(scrollView)
        scrollView.addSubview(longLbl)
        
        scrollView.backgroundColor = .orange
        scrollView.contentOffset = CGPoint(x: 0, y: 190)
        longLbl.lineBreakMode = .byWordWrapping
        longLbl.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
//        longLbl.numberOfLines = 0

        
        //top left
//        newLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
//        newLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        NSLayoutConstraint.activate([
            
            testLbl.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 20),
            testLbl.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            secondView.topAnchor.constraint(equalTo: testLbl.bottomAnchor, constant: 20),
            secondView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 10),
            secondView.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -10),
            secondView.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -10),
            testLbl2.topAnchor.constraint(equalTo: secondView.topAnchor, constant: 20),
            testLbl2.centerXAnchor.constraint(equalTo: secondView.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: testLbl2.bottomAnchor, constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: secondView.bottomAnchor, constant: -20),
            scrollView.centerXAnchor.constraint(equalTo: secondView.centerXAnchor),
            scrollView.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -10),
            longLbl.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: 20),
            longLbl.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -20),
            longLbl.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
            longLbl.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            //top right
//            newLbl2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            newLbl2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            //bottom left
//            newLbl3.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
//            newLbl3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            //bottom right
//            newLbl4.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
//            newLbl4.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            //view
            colorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            colorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            //size explicitly
            //        colorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            //        colorView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            //size dinamically
            colorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            colorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            colorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            colorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
            
            
        ])
    }
    
    func makeLabel(withText text: String) -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = text
        
        return label
    }
    
    func makeView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Color4")
        
        return view
    }
    
    func makeAnotherView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Color2")
        
        return view
    }
    
    func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
    
    
    
}

