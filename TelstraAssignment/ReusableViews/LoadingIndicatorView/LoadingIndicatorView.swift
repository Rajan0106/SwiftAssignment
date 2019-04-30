//
//  LoadingIndicatorView.swift
//  TelstraAssignment
//
//  Created by m-666346 on 30/04/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation
import UIKit
///LoadingIndicatorview shows activity indicator and loading text
///If loading text not provided, it will show default text.
///If required only activity indicator could be shown label can be hidden.
class LoadingIndicatorView: UIView {
    //default text to be shown while making request
    var loadingLabelText = "Loading..."
    //Creates loading label
    lazy private var loadingLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: Constants.FontSizes.systemFont13)
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        lbl.textColor     = .black
        return lbl
    }()
    
    // Createing activity indicator, which is shown while image is getting downloaded.
    lazy private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .white
        activityIndicatorView.color = .purple
        return activityIndicatorView
    }()
    
    //creates vertical stack view
    lazy private var verticalStackView: UIStackView = {
        let vsv = UIStackView(arrangedSubviews: [activityIndicator, loadingLabel])
        vsv.distribution  = .fillEqually
        vsv.axis          = .vertical
        vsv.alignment     = .center
        addSubview(vsv)
        return vsv
    }()
    
    //Setting up default view
    private func setupView() {
        self.loadingLabel.text = loadingLabelText
        layer.cornerRadius = 5
        backgroundColor = .lightGray
        backgroundColor = UIColor.black.withAlphaComponent(0.25)
    }
    
    //Sets all the constraint of cell UI component
    private func setupLayoutConstraints() {
        // Vertical Stack view constraint
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    //overriding designated initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setting up layoutconstraints
        setupLayoutConstraints()
        setupView()
    }
    
    //convenience initializer
    convenience init (title: String) {
        //default height for view
        let frame = CGRect(x: 0, y: 0, width: 120, height: 80)
        self.init(frame: frame)
        loadingLabelText = title
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setting up layoutconstraints
        setupLayoutConstraints()
    }
    
    ///shows activity indicator
    ///@param withLabel : either show activity indicator with loading text or not.
    func showLoadingView(withLabel: Bool) {
        isHidden = false
        loadingLabel.isHidden = !withLabel
        activityIndicator.startAnimating()
    }
    
    ///stop activity indicator view and removes from superview.
    func hideLoadingView() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}
