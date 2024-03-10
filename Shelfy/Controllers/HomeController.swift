//
//  ViewController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 04.06.2023.
//

import UIKit

class HomeController: UIViewController {
    
    var progressBar = makeProgressBar()
    var container = makeView()
    var monthLbl = makeLabel(withText: "")
    var progressLbl = makeLabel(withText: "")
    var readingGoalLbl = makeLabel(withText: "Reading Goal")
    var currentMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: Date())
    }
    
    lazy var imageView = UIImageView()
    var imagePlaceholder = UIView()
    var bookTitlePlaceholder = UILabel()
    lazy var randomBook = ""
    lazy var coverID = ""
    var hotContainer = UIView()
    lazy var bookTitle = UILabel()
    lazy var header = UILabel()
    lazy var bookAuthor = UILabel()
    var randomGenre = K.topGenres.randomElement()
    lazy var errorLbl = UILabel()
    let stackView = UIStackView()
    
    let pagesRead = 150
    let totalPages = 300
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        while randomGenre == nil {
            randomGenre = K.topGenres.randomElement()
        }
        
        pickRandomBook(fromGenre: "\(randomGenre!)") { title, coverID, authorName in
            if let title = title, let coverID = coverID {
                self.randomBook = title
                self.coverID = coverID
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.stopLoading()
                    self.bookTitle.text = title
                    self.bookAuthor.text = "By \(authorName!)"
                    let coverURLString = "https://covers.openlibrary.org/b/id/\(coverID)-M.jpg"
                    self.downloadImageAndSetView(urlString: coverURLString)
                    UIView.animate(withDuration: 1.5, delay: 0.5, options: [.curveEaseIn], animations: {
                        self.imageView.alpha = 1.0
                        self.bookTitle.alpha = 1.0
                        self.header.alpha = 1.0
                        self.bookAuthor.alpha = 1.0
                    }, completion: nil)
                    self.stopLoading()
                }
            } else {
                print("Failed to fetch a random book")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.stopLoading()
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn], animations: {
                        self.errorLbl.alpha = 1.0
                        self.header.alpha = 0.0
                    }, completion: nil)
                    if self.bookTitle.text == nil && self.bookAuthor.text == nil || ((self.bookAuthor.text?.isEmpty) != nil) {
                        self.errorLbl.text = K.errorLbl
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        while randomGenre == nil {
            randomGenre = K.topGenres.randomElement()
        }
        
        startLoading()
        errorLbl.alpha = 0.0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        DispatchQueue.main.async {
            
            self.imageView.alpha = 0.0
            self.bookTitle.alpha = 0.0
            self.bookAuthor.alpha = 0.0
            self.errorLbl.alpha = 0.0
            
        }
    }
    
    func setupView() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        imageView.alpha = 0.0
        bookTitle.alpha = 0.0
        bookAuthor.alpha = 0.0
        errorLbl.alpha = 0.0
        
        header.text = "Hot in \(randomGenre!)"
        
        bookTitlePlaceholder.text = K.placeholder
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        bookTitlePlaceholder.textAlignment = .center
        bookTitlePlaceholder.numberOfLines = 2
        
        hotContainer.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        bookTitle.translatesAutoresizingMaskIntoConstraints = false
        imagePlaceholder.translatesAutoresizingMaskIntoConstraints = false
        bookTitlePlaceholder.translatesAutoresizingMaskIntoConstraints = false
        header.translatesAutoresizingMaskIntoConstraints = false
        bookAuthor.translatesAutoresizingMaskIntoConstraints = false
        errorLbl.translatesAutoresizingMaskIntoConstraints = false
        bookTitle.numberOfLines = 0
        bookTitle.lineBreakMode = .byWordWrapping
        bookTitle.textAlignment = .center
        bookAuthor.numberOfLines = 0
        bookAuthor.lineBreakMode = .byWordWrapping
        bookAuthor.textAlignment = .center
        bookTitlePlaceholder.linesCornerRadius = 5
        
        errorLbl.numberOfLines = 0
        errorLbl.lineBreakMode = .byWordWrapping
        errorLbl.textAlignment = .center
        
        
        hotContainer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        setGradientBackground(view: hotContainer, colorTop: UIColor(resource: .brandPurple), colorBottom: UIColor(resource: .brandDarkPurple))
        
        imagePlaceholder.skeletonCornerRadius = 10
        
        hotContainer.layer.cornerRadius = 12
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        hotContainer.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        bookTitle.font = SetFont.setFontStyle(.medium, 14)
        bookAuthor.font = SetFont.setFontStyle(.medium, 14)
        header.font = SetFont.setFontStyle(.medium, 16)
        errorLbl.font = SetFont.setFontStyle(.medium, 16)
        
        stackView.alignment = .center
        
        view.addSubview(hotContainer)
        hotContainer.addSubview(imageView)
        hotContainer.addSubview(imagePlaceholder)
        hotContainer.addSubview(bookTitle)
        hotContainer.addSubview(header)
        hotContainer.addSubview(bookAuthor)
        hotContainer.addSubview(errorLbl)
        hotContainer.addSubview(stackView)
        stackView.addArrangedSubview(bookTitlePlaceholder)
        
        let imageWidthPercentage: CGFloat = 0.32
        let imageHeightPercentage: CGFloat = 0.42
        let placeholderPercentage: CGFloat = 0.32
        
        let imageWidthConstant = UIScreen.main.bounds.width * imageWidthPercentage
        let imageHeightConstant = UIScreen.main.bounds.height * imageHeightPercentage
        
        let placeholderWidthConstant = hotContainer.bounds.width * imageWidthPercentage
        let placeholderHeightConstant = hotContainer.bounds.height * placeholderPercentage
        
        let placehoderHeight = imagePlaceholder.heightAnchor.constraint(equalToConstant: placeholderHeightConstant / 1.25)
        placehoderHeight.isActive = true
        placehoderHeight.priority = UILayoutPriority(rawValue: 995)
        
        container.backgroundColor = UIColor(resource: .brandMint)
        container.layer.cornerRadius = 12
        monthLbl.text = currentMonth
        monthLbl.font = SetFont.setFontStyle(.medium, 18)
        readingGoalLbl.font = SetFont.setFontStyle(.medium, 24)
        
        var progressValue = calculateProgress(pagesRead: pagesRead, totalPages: totalPages)
        var progressLblValue = calculateProgress(pagesRead: pagesRead, totalPages: totalPages) * 100
        print("Progress: \(progressValue)")
        progressBar.progress = progressValue
        progressBar.setProgress(calculateProgress(pagesRead: pagesRead, totalPages: totalPages), animated: true)
        
        progressLbl.text = String(format: "%.0f%%", progressLblValue)
        progressBar.tintColor = UIColor(resource: .brandPurple)
        progressBar.trackTintColor = UIColor(resource: .brandDarkPurple)
        progressBar.progressViewStyle = .bar
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        
        bookTitlePlaceholder.isSkeletonable = true
        imagePlaceholder.isSkeletonable = true
        
        view.addSubview(container)
        view.addSubview(readingGoalLbl)
        container.addSubview(monthLbl)
        container.addSubview(progressBar)
        container.addSubview(progressLbl)
        
        NSLayoutConstraint.activate([
            readingGoalLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            readingGoalLbl.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -12),
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            container.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -30),
            container.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.2),
            monthLbl.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            monthLbl.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            progressBar.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            progressBar.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -30),
            progressLbl.bottomAnchor.constraint(equalTo: progressBar.topAnchor, constant: -12),
            progressLbl.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            
            hotContainer.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 30),
            hotContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hotContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            hotContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            imageView.leadingAnchor.constraint(equalTo: hotContainer.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: bookTitle.leadingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: hotContainer.bottomAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: imageWidthConstant),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: imageHeightConstant),
            
            imagePlaceholder.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            imagePlaceholder.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -8),
            imagePlaceholder.widthAnchor.constraint(lessThanOrEqualToConstant: placeholderWidthConstant),
            imagePlaceholder.topAnchor.constraint(equalTo: header.bottomAnchor),
            
            bookTitle.centerYAnchor.constraint(equalTo: hotContainer.centerYAnchor),
            bookTitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            bookTitle.trailingAnchor.constraint(equalTo: hotContainer.trailingAnchor, constant: -16),
            
            bookAuthor.topAnchor.constraint(equalTo: bookTitle.bottomAnchor, constant: 8),
            bookAuthor.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            bookAuthor.trailingAnchor.constraint(equalTo: hotContainer.trailingAnchor, constant: -16),
            
            stackView.widthAnchor.constraint(equalTo: hotContainer.widthAnchor, multiplier: 0.55),
            stackView.topAnchor.constraint(equalTo: hotContainer.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: hotContainer.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: hotContainer.trailingAnchor, constant: -16),
            
            bookTitlePlaceholder.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            bookTitlePlaceholder.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -0.25),
            bookTitlePlaceholder.heightAnchor.constraint(lessThanOrEqualToConstant: 20),
            
            header.centerXAnchor.constraint(equalTo: hotContainer.centerXAnchor),
            header.topAnchor.constraint(equalTo: hotContainer.topAnchor, constant: 8),
            header.bottomAnchor.constraint(lessThanOrEqualTo: imageView.topAnchor, constant: -16),
            header.heightAnchor.constraint(equalToConstant: 20),
            
            errorLbl.centerXAnchor.constraint(equalTo: hotContainer.centerXAnchor),
            errorLbl.leadingAnchor.constraint(equalTo: hotContainer.leadingAnchor, constant: 16),
            errorLbl.trailingAnchor.constraint(equalTo: hotContainer.trailingAnchor, constant: -16),
            errorLbl.topAnchor.constraint(equalTo: hotContainer.topAnchor, constant: 16),
            errorLbl.bottomAnchor.constraint(equalTo: hotContainer.bottomAnchor, constant: -16),
        ])
        
        startLoading()
        
    }
    
    func calculateProgress(pagesRead: Int, totalPages: Int) -> Float {
        guard totalPages > 0 else {
            return 0.0 // If total pages is zero or negative, return 0 progress
        }
        
        // Calculate the progress percentage
        let progress = Float(pagesRead) / Float(totalPages)
        return progress // Ensure progress does not exceed 100%
    }
    
    func startLoading() {
        
        bookTitlePlaceholder.showAnimatedSkeleton()
        bookTitlePlaceholder.skeletonTextNumberOfLines = 2
        imagePlaceholder.showAnimatedSkeleton()
        imagePlaceholder.isHiddenWhenSkeletonIsActive = true
        bookTitlePlaceholder.isHiddenWhenSkeletonIsActive = true
        bookTitlePlaceholder.isHidden = false
        imagePlaceholder.isHidden = false
        self.header.alpha = 1.0
        
        
    }
    
    func stopLoading() {
        bookTitlePlaceholder.hideSkeleton(transition: .crossDissolve(0.25))
        imagePlaceholder.hideSkeleton(transition: .crossDissolve(0.25))
        bookTitlePlaceholder.isHidden = true
        imagePlaceholder.isHidden = true
        hotContainer.layer.cornerRadius = 12
        hotContainer.clipsToBounds = true
        
    }
    
    func downloadImageAndSetView(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    func setGradientBackground(view: UIView, colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.startPoint = CGPoint(x:  0.0, y:  0.5)
        gradientLayer.endPoint = CGPoint(x:  2.0, y:  0.5)
        gradientLayer.locations = [0,  1]
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at:  0)
    }
    
}

extension UIButton {
    func applyGradient(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x:  0.0, y:  0.5)
        gradientLayer.endPoint = CGPoint(x:  1.0, y:  0.5)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at:  0)
    }
}


