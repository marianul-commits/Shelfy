//
//  ExpandingButton.swift
//  Shelfy
//
//  Created by Marian Nasturica on 26.02.2024.
//

import Foundation

//        let buttonPanel = ButtonPanelView()
//
//        NSLayoutConstraint.activate([
//            buttonPanel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            buttonPanel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//        ])


//fileprivate let buttonSize: CGFloat = 56
//fileprivate let shadowOpacity: Float = 0.7
//
//class ButtonPanelView: UIView {
//
//  lazy var menuButton: UIButton = {
//    let button = UIButton(frame: .zero)
//    button.setTitle("➕", for: .normal)
//    button.backgroundColor = .clear
//    button.layer.cornerRadius = buttonSize / 2
//    button.addTarget(
//      self, action: #selector(handleTogglePanelButtonTapped(_:)), for: .touchUpInside)
//    return button
//  }()
//
//lazy var dogButton: UIButton = {
//   let button = UIButton(frame: .zero)
//   button.setTitle("🐶", for: .normal)
//   button.layer.cornerRadius = buttonSize / 2
//   button.isHidden = true
//    button.addTarget(self, action: #selector(printDoggo(_:)), for: .touchUpInside)
//   return button
// }()
//
// lazy var catButton: UIButton = {
//   let button = UIButton(frame: .zero)
//   button.setTitle("🐱", for: .normal)
//   button.layer.cornerRadius = buttonSize / 2
//     button.addTarget(self, action: #selector(printGatto(_:)), for: .touchUpInside)
//   button.isHidden = true
//   return button
// }()
//
// lazy var expandedStackView: UIStackView = {
//   let stackView = UIStackView()
//   stackView.axis = .vertical
//   stackView.isHidden = true
//   stackView.addArrangedSubview(dogButton)
//   stackView.addArrangedSubview(catButton)
//   return stackView
// }()
//
// lazy var containerStackView: UIStackView = {
//   let stackView = UIStackView()
//   stackView.axis = .vertical
//   stackView.addArrangedSubview(expandedStackView)
//   stackView.addArrangedSubview(menuButton)
//   return stackView
// }()
//
// override init(frame: CGRect) {
//   super.init(frame: frame)
//   backgroundColor = UIColor(named: "Color1")
//
//   layer.cornerRadius = buttonSize / 2
//   layer.shadowColor = UIColor.lightGray.cgColor
//   layer.shadowOpacity = shadowOpacity
//
//   layer.shadowOffset = .zero
//
//   addSubview(containerStackView)
//   setConstraints()
// }
//required init?(coder: NSCoder) {
//  fatalError("init(coder:) has not been implemented")
//}
//
//private func setConstraints() {
//  // Main button
//  menuButton.translatesAutoresizingMaskIntoConstraints = false
//  menuButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
//  menuButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
//
//  // Dog button
//  dogButton.translatesAutoresizingMaskIntoConstraints = false
//  dogButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
//  dogButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
//
//  // Cat button
//  catButton.translatesAutoresizingMaskIntoConstraints = false
//  catButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
//  catButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
//
//  // Container stack view
//  containerStackView.translatesAutoresizingMaskIntoConstraints = false
//  containerStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//  containerStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//
//  translatesAutoresizingMaskIntoConstraints = false
//  self.widthAnchor.constraint(equalTo: containerStackView.widthAnchor).isActive = true
//  self.heightAnchor.constraint(equalTo: containerStackView.heightAnchor).isActive = true
//}
//}
//
//// MARK: - Gestures
//
//extension ButtonPanelView {
//  @objc private func handleTogglePanelButtonTapped(_ sender: UIButton) {
//    let willExpand = expandedStackView.isHidden
//    let menuButtonNewTitle = willExpand ? "❌" : "➕"
//    UIView.animate(
//      withDuration: 0.3, delay: 0, options: .curveEaseIn,
//      animations: {
//        self.expandedStackView.subviews.forEach { $0.isHidden = !$0.isHidden }
//        self.expandedStackView.isHidden = !self.expandedStackView.isHidden
//        if willExpand {
//          self.menuButton.setTitle(menuButtonNewTitle, for: .normal)
//        }
//    }, completion: { _ in
//      // When collapsing, wait for animation to finish before changing from "x" to "+"
//      if !willExpand {
//        self.menuButton.setTitle(menuButtonNewTitle, for: .normal)
//      }
//    })
//  }
//    @objc private func printDoggo(_ sender: UIButton){
//        print("Doggo")
//    }
//    @objc private func printGatto(_ sender: UIButton){
//        print("Gatto")
//    }
//
//
//}



// MARK: - Gradients

//func setGradientBackground(view: UIView, colorTop: UIColor, colorBottom: UIColor) {
//    let gradientLayer = CAGradientLayer()
//    gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
//    gradientLayer.startPoint = CGPoint(x:  0.0, y:  0.5)
//    gradientLayer.endPoint = CGPoint(x:  2.0, y:  0.5)
//    gradientLayer.locations = [0,  1]
//    gradientLayer.frame = view.bounds
//
//    view.layer.insertSublayer(gradientLayer, at:  0)
//}
//
//}
//
//extension UIButton {
//func applyGradient(colors: [UIColor]) {
//    let gradientLayer = CAGradientLayer()
//    gradientLayer.colors = colors.map { $0.cgColor }
//    gradientLayer.startPoint = CGPoint(x:  0.0, y:  0.5)
//    gradientLayer.endPoint = CGPoint(x:  1.0, y:  0.5)
//    gradientLayer.frame = self.bounds
//    self.layer.insertSublayer(gradientLayer, at:  0)
//}
//}

