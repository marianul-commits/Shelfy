//
//  Factories.swift
//  Shelfy
//
//  Created by Marian Nasturica on 06.08.2023.
//

import UIKit

func makeTextField(withPlaceholder placeholder: String) -> UITextField {
    let textField = UITextField()
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = placeholder
    textField.borderStyle = .roundedRect
    textField.font = SetFont.setFontStyle(.regular, 14)
    textField.autocapitalizationType = .none
    return textField
}


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
    button.sizeToFit()
    button.contentHorizontalAlignment = .center
    
    let attributedText = NSMutableAttributedString(string: title, attributes: [
        NSAttributedString.Key.font: SetFont.setFontStyle(.regular, 14),
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.kern: 0.5
        ])

    button.setAttributedTitle(attributedText, for: .normal)

    if #available(iOS 15.0, *) {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .dynamic
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        config.baseBackgroundColor = UIColor(named: "Color1")
        button.configuration = config
    } else {
        // Fallback on earlier versions
    }
    
    return button
}

func makeButtonColor(withTitle title: String, withColor colour: String) -> UIButton {
    let button = UIButton(type: .system)
    let buttonHeight: CGFloat = 40
    let colour = UIColor(named: colour)
    
    button.translatesAutoresizingMaskIntoConstraints = false
//    button.setTitle(title, for: .normal)
    button.contentHorizontalAlignment = .center
    
    let attributedText = NSMutableAttributedString(string: title, attributes: [
        NSAttributedString.Key.font: SetFont.setFontStyle(.regular, 14),
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.kern: 0.5
        ])

    button.setAttributedTitle(attributedText, for: .normal)

    if #available(iOS 15.0, *) {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .dynamic
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        config.baseBackgroundColor = colour
        button.configuration = config
    } else {
        // Fallback on earlier versions
    }
    
    return button
}

func makeButton2(withTitle title: String) -> UIButton {
    let button = UIButton(type: .system)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(title, for: .normal)
    button.contentHorizontalAlignment = .center
    
    if #available(iOS 15.0, *) {
        var config = UIButton.Configuration.borderless()
        config.cornerStyle = .dynamic
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        config.baseBackgroundColor = .clear
        button.configuration = config
    } else {
        // Fallback on earlier versions
    }
    
    return button
}

func makeImgButton(withImg img: String) -> UIButton {
    let btn = UIButton()
    let image = UIImage(systemName: img)?.withRenderingMode(.alwaysTemplate)
    
    btn.setImage(image, for: .normal)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.tintColor = UIColor(named: "Accent")
    btn.imageView?.contentMode = .scaleAspectFit
    
    return btn
}

func makeStackView(withOrientation axis: NSLayoutConstraint.Axis, withSpacing spacing: Float) -> UIStackView {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = axis
    stackView.distribution = .fillProportionally
    stackView.alignment = .fill

    return stackView
}

func makeProgressBar() -> UIProgressView {
    
    let progressBar = UIProgressView()
    progressBar.translatesAutoresizingMaskIntoConstraints = false
    progressBar.progressViewStyle = .bar
    
    return progressBar
}

