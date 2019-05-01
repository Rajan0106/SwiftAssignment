//
//  CustomCell.swift
//  TelstraAssignment
//
//  Created by m-666346 on 30/04/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation
import UIKit

/// CustomCell shows data provide by Model class AboutComponent
class CustomCell: UITableViewCell {
    static let CellIdentifier: String = "CustomCellIdentifier"
    //Sets constraint of Image view dynamically according to size of image
    internal var aspectConstraint: NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                aboutImageView.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                aboutImageView.addConstraint(aspectConstraint!)
            }
        }
    }
    // MARK: - Life cycle methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //initial view state
        setupViewInitialState()
        //set up layoutconstraints
        setupLayoutConstraints()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        //Resetting previous values
        aboutImageView.image     = nil
        descriptionLabel.text    = nil
        titleNameLabel.text      = nil
        aspectConstraint         = nil
        aboutImageView.isHidden  = true
        showActivityIndicatorView(false)
    }
    //updates the UI components according model changes
    var cellViewModel: CustomCellViewModel? {
        didSet {
            titleNameLabel.text = cellViewModel?.about.title
            descriptionLabel.text = cellViewModel?.about.description
            if let urlString = cellViewModel?.about.imageHRef {
                if let image = ImageProvider.defaultProvider.getImageForURLString(urlString) {
                    showActivityIndicatorView(false)
                    showAboutImage(image)
                    cellViewModel?.imagedownloadState = .finished
                } else {
                    //unwrapping forcefully, image is included in project.
                    showAboutImage(UIImage(named: Constants.Images.thumbnailPlaceholder)!)
                    showActivityIndicatorView(true)
                    cellViewModel?.imagedownloadState = .started
                }
            } else {
                //unwrapping forcefully, image is included in project.
                showAboutImage(UIImage(named: Constants.Images.thumbnailPlaceholder)!)
                showActivityIndicatorView(false)
                cellViewModel?.imagedownloadState = .notStarted
                print("Image Ref Not found for title -> \(cellViewModel?.about.title ?? "Title not available")")
            }
        }
    }
    /// It sets about image count
    func showAboutImage(_ image: UIImage) {
        aboutImageView.isHidden = false
        let aspect = image.size.width / image.size.height
        aspectConstraint = NSLayoutConstraint(item: aboutImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: aboutImageView, attribute: NSLayoutConstraint.Attribute.height, multiplier: aspect, constant: 0.0)
        aboutImageView.image = image
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        aboutImageView.addSubview(aboutImageLoadingIndicatorView)
        //initial view state
        setupViewInitialState()
        //Set up layout constraints
        setupLayoutConstraints()
    }
    // MARK: - Helper Methods
    //It hides/unhide activity according to parameter
    func showActivityIndicatorView(_ show: Bool) {
        if show {
            aboutImageLoadingIndicatorView.showLoadingView(withLabel: false)
        } else {
            aboutImageLoadingIndicatorView.hideLoadingView()
        }
    }
    // MARK: - Private Methods
    private func setupViewInitialState() {
        self.selectionStyle = .none
    }
    //Sets all the constraint of cell UI component
    private func setupLayoutConstraints() {
        //loading Indicator view constraint
        aboutImageLoadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            aboutImageLoadingIndicatorView.heightAnchor.constraint(equalToConstant: 36),
            aboutImageLoadingIndicatorView.widthAnchor.constraint(equalToConstant: 36),
            aboutImageLoadingIndicatorView.centerXAnchor.constraint(equalTo: aboutImageView.centerXAnchor),
            aboutImageLoadingIndicatorView.centerYAnchor.constraint(equalTo: aboutImageView.centerYAnchor)
            ])
        //setting Description label content hugging
        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        // Horizontal Stack view constraint
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
            ])
    }
    // MARK: - Properties Initializer
    //Creates title label
    lazy private var titleNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: Constants.FontSizes.systemFont19)
        lbl.textColor       = .black
        lbl.numberOfLines   = 0
        lbl.textAlignment   = .left
        return lbl
    }()
    //Creates description label
    lazy private var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: Constants.FontSizes.systemFont17)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.textColor     = .black
        return lbl
    }()
    //Creates about Image view
    lazy private var aboutImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode     = .scaleAspectFit
        imgView.clipsToBounds   = true
        imgView.backgroundColor = .green
        imgView.isHidden        = true
        return imgView
    }()
    // Createing activity indicator, which is shown while image is getting downloaded.
    lazy private var aboutImageLoadingIndicatorView: LoadingIndicatorView = {
        let loadingIndicatorView = LoadingIndicatorView()
        loadingIndicatorView.backgroundColor = .clear
        return loadingIndicatorView
    }()
    //creates vertical stack view
    lazy private var verticalStackView: UIStackView = {
        let vsv = UIStackView(arrangedSubviews: [titleNameLabel, descriptionLabel])
        vsv.distribution  = .fill
        vsv.axis          = .vertical
        vsv.alignment     = .leading
        vsv.spacing       = 8
        return vsv
    }()
    //Creates horizontal stack view
    lazy private var horizontalStackView: UIStackView = {
        let hsv = UIStackView(arrangedSubviews: [aboutImageView, verticalStackView])
        hsv.distribution    = .fill
        hsv.axis            = .vertical
        hsv.spacing         = 8
        hsv.alignment       = .leading
        addSubview(hsv)
        return hsv
    }()
}
