//
//  Factories.swift
//  Shelfy
//
//  Created by Marian Nasturica on 06.08.2023.
//

import UIKit


func makeLabel(withText text: String) -> UILabel {
    let label = UILabel()
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.text = text
    return label
}

func makeView(color: UIColor = .red) -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = color

    return view
}


func makeScrollView(withX x: CGFloat, withY y: CGFloat, withWidth width: CGFloat, withHeight height: CGFloat) -> UIScrollView {
    let scrollView = UIScrollView(frame: CGRect(x: x, y: y, width: width, height: height))
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.contentSize = CGSize(width: width, height: height)
    scrollView.isPagingEnabled = true
    
    return scrollView
}

public func makeSpacerView(height: CGFloat? = nil) -> UIView {
    let spacerView = UIView(frame: .zero)

    if let height = height {
        spacerView.heightAnchor.constraint(equalToConstant: height).setActiveBreakable()
    }
    spacerView.translatesAutoresizingMaskIntoConstraints = false

    return spacerView
}

public extension NSLayoutConstraint {
    @objc func setActiveBreakable(priority: UILayoutPriority = UILayoutPriority(900)) {
        self.priority = priority
        isActive = true
    }
}

func makeImgView(withImage img: String) -> UIImageView {
    let image = UIImageView()
    
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleToFill
    image.image = UIImage(named: img)
    return image
}

func makeCollectionView() -> UICollectionView {
    let layout = CustomFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .clear
    collectionView.showsVerticalScrollIndicator = false
    return collectionView
}

func makeButton(withTitle title: String) -> UIButton {
    let button = UIButton(type: .system)
    let buttonHeight: CGFloat = 40
    
    button.translatesAutoresizingMaskIntoConstraints = false
//    button.setTitle(title, for: .normal)
    button.contentHorizontalAlignment = .center
    
    let attributedText = NSMutableAttributedString(string: title, attributes: [
        NSAttributedString.Key.font: UIFont(name: "MicroPremium-Regular", size: 14),
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.kern: 0.5
        ])

    button.setAttributedTitle(attributedText, for: .normal) // Note how not button.setTitle()

    if #available(iOS 15.0, *) {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        config.baseBackgroundColor = UIColor(named: "Color1")
        button.configuration = config
    } else {
        // Fallback on earlier versions
    }
    
    return button
}

//func makeStackView(withAxis axis: NSLayoutConstraint.Axis, withSpacing spacing: CGFloat, withAlignment alignment: UIStackView.Alignment, withDistribution distribute: UIStackView.Distribution) -> UIStackView {
//    let stackView = UIStackView()
//
//    stackView.axis = axis
//    stackView.spacing = spacing
//    stackView.alignment = alignment
//    stackView.distribution = distribute
//
//    return stackView
//}

func makeStackView(withOrientation axis: NSLayoutConstraint.Axis) -> UIStackView {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = axis
    stackView.distribution = .fillProportionally
    stackView.alignment = .fill
    stackView.spacing = 3.0

    return stackView
}