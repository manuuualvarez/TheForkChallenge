//
//  NewsTableViewCell.swift
//  TheForkChallenge
//
//  Created by Manuel Alvarez on 1/25/22.
//

import UIKit
import Kingfisher


protocol LikedImageTapDelegate: AnyObject {
    func likekImageDidTap(name: String, status: Bool)
}

class RestauranstTableViewCell: UITableViewCell {
    
    var delegate: LikedImageTapDelegate?

//    MARK: - UI
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private lazy var theForkContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "tf-logo"), label: theForkratingLabel)
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()
    
    private let theForkratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
        
    private lazy var tripAdvisorContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ta-logo"), label: tripAdvisorRatingLabel)
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()
    
    private let tripAdvisorRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let imageBackgorund: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let likedImage: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        return image
    }()
    
    var restaurant: Restorant?

//MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(imageBackgorund)
        imageBackgorund.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 2, paddingRight: 0)
        imageBackgorund.clipsToBounds = true
        imageBackgorund.layer.cornerRadius = 15
    
        let stack = UIStackView(arrangedSubviews: [mainLabel, subtitleLabel, theForkContainerView, tripAdvisorContainerView])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.backgroundColor = UIColor(red: 16/255, green: 16/255, blue: 16/255, alpha: 0.8)
        stack.clipsToBounds = true
        stack.layer.cornerRadius = 5
        addSubview(stack)

        stack.anchor(top: self.topAnchor, bottom: self.bottomAnchor, paddingTop: 15, paddingBottom: 15)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        mainLabel.anchor(left: stack.leftAnchor, right: stack.rightAnchor, paddingLeft: 8, paddingRight: 8)
        subtitleLabel.anchor(left: stack.leftAnchor,  paddingLeft: 8)
        theForkContainerView.anchor(top: stack.bottomAnchor , left: stack.leftAnchor, right: stack.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 15, height: 60)
        tripAdvisorContainerView.anchor(top: theForkContainerView.bottomAnchor , left: stack.leftAnchor, paddingTop: 8, paddingLeft: 8, height: 60)
        
        contentView.addSubview(likedImage)
        likedImage.anchor(right: self.rightAnchor, paddingRight: 20, width: 50, height: 50)
        likedImage.centerY(inView: stack)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeImagedDidTapped))
        likedImage.addGestureRecognizer(tap)
        
    }
    
    func setUpCell(restaurant: Restorant) {
        self.restaurant = restaurant
        mainLabel.text = restaurant.name
        setupAddress()
        setupRating()
        setupBackgroundImage()
        updateLikedImage()
    }
    
    private func setupAddress() {
        if let street = restaurant?.address?.street, let locality = restaurant?.address?.locality {
            subtitleLabel.text = "\(street), \(locality)"
        } else {
            subtitleLabel.text = "Address undefine"
        }
    }
    
    private func setupRating() {
        if let tripAdvisorRating = restaurant?.aggregateRatings?.tripadvisor?.ratingValue,
           let count = restaurant?.aggregateRatings?.tripadvisor?.reviewCount {
            self.tripAdvisorRatingLabel.text = "Trip Advisor Rating: \(tripAdvisorRating), of: \(count)"
        }
        
        if let theForkRating = restaurant?.aggregateRatings?.thefork?.ratingValue,
           let count = restaurant?.aggregateRatings?.thefork?.reviewCount {
            self.theForkratingLabel.text = "The Fork Rating: \(theForkRating), of: \(count)"
        }
    }
    
    private func setupBackgroundImage() {
        if let image = restaurant?.mainPhoto?.source, let url = URL(string: image) {
            imageBackgorund.kf.setImage(with: url)
        } else {
            imageBackgorund.image = #imageLiteral(resourceName: "emptyImage")
        }
    }
    
    func updateLikedImage() {
        guard let restaurant = restaurant else {
            return
        }

        if restaurant.favorite == true {
            likedImage.image = #imageLiteral(resourceName: "filled-heart")
        } else {
            likedImage.image = #imageLiteral(resourceName: "solid-heart")
        }
    }
    
    
    @objc func likeImagedDidTapped() {
        guard let status = restaurant?.favorite, let name = restaurant?.name  else {
            return
        }
        delegate?.likekImageDidTap(name: name, status: status)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
