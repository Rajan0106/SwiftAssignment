//
//  HomeViewController.swift
//  TelstraAssignment
//
//  Created by m-666346 on 30/04/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import UIKit

/// HomeViewController class handles all  user intraction and rendering of user data.
/// It also observes network status changes and render UI accordingly.
class HomeViewController: UIViewController {
    private var listTableView = UITableView()
    private var loadingView = LoadingIndicatorView(title: Constants.AppStrings.loadingText)
    //It contains data which needs to shown on UI. Also, It initialize network request to download the data from server.
    var homeViewModel = HomeViewModel()
    lazy private var noDataAvailableLabel: UILabel = {
        let paddingX = Constants.ViewCustomSizes.NoDataAvableViewPaddingForBothSide
        let height = Constants.ViewCustomSizes.NoDataAvableLableHeight
        var labelFrame  = CGRect(x: 0, y: 0, width: self.view.frame.size.width - paddingX, height: height)
        let lbl         = UILabel(frame: labelFrame)
        lbl.font        = UIFont.systemFont(ofSize: Constants.FontSizes.systemFont18)
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        lbl.textColor     = .darkGray
        lbl.text          = Constants.AppStrings.noDataAvailableMessage
        return lbl
    }()
    //It is shown when we don't get data from server.
    lazy private var noDataAvailableView: UIView = {
        let width = self.view.frame.size.width
        let paddingX = Constants.ViewCustomSizes.NoDataAvableViewPaddingForBothSide
        let height = Constants.ViewCustomSizes.NoDataAvableViewHeight
        let frame = CGRect(x: 0, y: 0, width: width - paddingX, height: height)
        let view  = UIView(frame: frame)
        view.backgroundColor = .red
        view.isHidden        = true
        view.addSubview(noDataAvailableLabel)
        return view
    }()
    lazy private var refreshControl: UIRefreshControl = {
        let refreshcCtrl = UIRefreshControl()
        refreshcCtrl.tintColor = .black
        refreshcCtrl.attributedTitle = NSAttributedString(string: Constants.AppStrings.pullToRefresh)
        refreshcCtrl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        return refreshcCtrl
    }()
    // MARK: - View life cycle methods
    override func loadView() {
        super.loadView()
        //Add subview to self view
        addSubviewsToSelfView()
        //Setting up layout constraint
        setupLayoutConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        homeViewModel.delegate = self
        // Device Offline check
        showOfflineAlertIfRequired()
        ReachabilityManager.sharedInstance.networkManagerDelegate = self
        //initializing view model data source
        initializeDataSource()
        //Adding self to listen notifications
        addObserverToSelfForNotification()
        view.bringSubviewToFront(loadingView)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Thumbnail image download and update on UI
    // Handles notifications
    @objc func didRecieveNotification(_ notification: Notification) {
        if notification.name == ImageProvider.DidFinishImageDownload {
            let userInfo    = notification.userInfo
            let urlString   = userInfo?[ImageProvider.keyDownloadedImageForString] as? String
            let downloadedImage = userInfo?[ImageProvider.keyDownloadedImage] as? UIImage
            if  let unwrappedImage = downloadedImage,
                let unwrappedUrlString = urlString {
                self.didFinishDownloadingImage(unwrappedImage, forUrlString: unwrappedUrlString)
            } else {
                if  let unwrappedUrlString = urlString {
                    self.didFailedImageDownloading(forUrlString: unwrappedUrlString)
                }
            }
        }
    }
    private func didFailedImageDownloading(forUrlString urlString: String) {
        for cell in self.listTableView.visibleCells {
            if  let customCell = cell as? CustomCell,
                let imageUrlString = customCell.cellViewModel?.about.imageHRef,
                urlString ==  imageUrlString {
                customCell.showActivityIndicatorView(false)
                customCell.cellViewModel?.imagedownloadState = .failed
                break
            }
        }
    }
    //Sets about images when downloaded from server
    private func didFinishDownloadingImage(_ image: UIImage, forUrlString urlString: String) {
        for cell in self.listTableView.visibleCells {
            if  let customCell = cell as? CustomCell,
                let imageUrlString = customCell.cellViewModel?.about.imageHRef,
                urlString ==  imageUrlString {
                if let indexPath = listTableView.indexPath(for: customCell) {
                    listTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                    customCell.cellViewModel?.imagedownloadState = .finished
                }
                break
            }
        }
    }
    // MARK: - Private methods
    private func addObserverToSelfForNotification() {
        self.regiesterForNotificationName(ImageProvider.DidFinishImageDownload)
    }
    private func regiesterForNotificationName(_ notificationName: Notification.Name) {
        let selector = #selector(didRecieveNotification(_:))
        NotificationCenter.default.addObserver(self, selector: selector, name: notificationName, object: nil )
    }
    private func setupLayoutConstraints() {
        //No Data Available View Constraint
        noDataAvailableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noDataAvailableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataAvailableView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        //No Data Available lable Constraint
        noDataAvailableLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noDataAvailableLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataAvailableLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        //Table view constraint
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listTableView.topAnchor.constraint(equalTo: view.topAnchor),
            listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        //Loading Activity Indicator view constraint
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.widthAnchor.constraint(equalToConstant: 90),
            loadingView.heightAnchor.constraint(equalToConstant: 64),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
    private func initializeDataSource() {
        showLoadingIndicatorView(true)
        homeViewModel.fetchAboutCountryDetailFromService()
    }
    private func  showLoadingIndicatorView(_ show: Bool) {
        if show == true {
            loadingView.showLoadingView(withLabel: true)
        } else {
            loadingView.hideLoadingView()
        }
    }
    private func addSubviewsToSelfView() {
        //adding  views to viewcontroller's view
        self.view.addSubview(listTableView)
        self.view.addSubview(loadingView)
        self.view.addSubview(noDataAvailableView)
        self.listTableView.addSubview(refreshControl)
    }
    private func setupTableView() {
        listTableView.backgroundColor    = .white
        listTableView.cellLayoutMarginsFollowReadableWidth = false
        listTableView.tableFooterView    = UIView(frame: .zero)
        listTableView.dataSource         = homeViewModel
        listTableView.rowHeight          = UITableView.automaticDimension
        listTableView.estimatedRowHeight = 150
        listTableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.CellIdentifier)
    }
    private func showOfflineAlertIfRequired() {
        ReachabilityManager.isUnreachable {[weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.deviceOfflineMessage()
        }
    }
    private func deviceOfflineMessage() {
        let alertVC = UIAlertController.showAlertWith(title: Constants.AppStrings.offlineTitle, message: Constants.AppStrings.offlineMessage)
        self.present(alertVC, animated: true, completion: nil)
    }
    // MARK: - utilities methods
    //Stop on successful return from function call
    func stopRefresher() {
        refreshControl.endRefreshing()
    }
    ///Called when "Refresh Control" is called
    @objc func refresh(sender: AnyObject) {
        homeViewModel.fetchAboutCountryDetailFromService()
    }
    ///Call this method to show no data available view.
    func showNoDataAvailableScreen(_ show: Bool) {
        self.noDataAvailableView.isHidden = !show
    }
}

// MARK: - HomeViewModel delegate Methods
extension HomeViewController: HomeViewModelDelegate {
    ///This gets called on successfull network request
    /// - parameter country : The country detail got from server
    func fetched(country: AboutCountry) {
        //updating view model data source
        self.homeViewModel.aboutCountry = country
        //Removing info from infolist which all properties have nil value
        self.homeViewModel.removeInfoFromListIfAllPropertiesAreNil()
        //Update title
        self.title = country.title
        // Hide activity indicator view
        //loadingActivityIndicatorView.isHidden = true
        loadingView.hideLoadingView()
        // Stop refresh controller
        stopRefresher()
        if homeViewModel.aboutCountry?.infoList?.isEmpty == false {
            // show table view
            listTableView.isHidden = false
            listTableView.reloadData()
            showNoDataAvailableScreen(false)
        } else {
            listTableView.isHidden = true
            showNoDataAvailableScreen(true)
        }
    }
    ///This gets called if there is failure in network request
    /// - parameter error : The network error object
    func fetchCountryDetailFailedWith(error: HTTPErrorCode) {
        //showing  alert
        let title = Constants.AppStrings.titleError
        let alertVC = UIAlertController.showAlertWith(title: title, message: error.localizedDescription)
        present(alertVC, animated: true, completion: nil)
        // hidding loading indicator view
        loadingView.hideLoadingView()
        // hide table view
        listTableView.isHidden = true
        //show no data available screen
        showNoDataAvailableScreen(true)
        // Stop refresh controller
        stopRefresher()
        //Update title, it will make sure that no previous title is being shown.
        self.title = Constants.AppStrings.emptyString
        //updating view model data source, previous value will be retained.
        self.homeViewModel.aboutCountry = nil
    }
}

extension HomeViewController: ReachabilityManagerProtocol {
    func didChangeNetworkStatus(_ notification: Notification) {
        ReachabilityManager.isUnreachable { [weak self] _  in
            guard let strongSelf = self else { return }
            strongSelf.deviceOfflineMessage()
        }
        ReachabilityManager.isReachable { _ in
            //update datasource from server if not fetched yet.
            if self.homeViewModel.aboutCountry == nil {
                self.showNoDataAvailableScreen(false)
                self.initializeDataSource()
            } else {
                //reloading table view will initialize download of images if not downloaded yet
                self.listTableView.reloadData()
            }
        }
    }
}
