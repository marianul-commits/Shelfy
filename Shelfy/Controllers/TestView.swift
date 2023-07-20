//
//  TestView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit

class TestView: UIViewController {

    @IBOutlet weak var placeholderField: UITextField!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()

        imgForTextField()

        }

    func imgForTextField() {
        let color = UIColor(named: "Accent")
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.tintColor = color
        let image = UIImage(systemName: "envelope.fill")
        image?.withTintColor(color!)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        view.addSubview(imageView)
        view.backgroundColor = .clear
        placeholderField.leftViewMode = UITextField.ViewMode.always
        placeholderField.leftView = view
    }
    
}
