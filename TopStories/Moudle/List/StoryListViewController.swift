//
//  StoryListViewController.swift
//  TopStories
//
//  Created by Mozhgan on 8/30/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
fileprivate extension Layout {
    static let lineWidth : CGFloat = 4.0
}
fileprivate extension Layout {
    static let emptyStateSize = CGSize(width: 200, height: 100)
}

final class StoryListViewController: UIViewController {
    
    deinit {
        print("deinit :: \(self)")
    }
    
    // MARK: - Private properties -
    let cellReuseIdentifier = "\(StoryTableViewCell.self)"
    
    private lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.attributedTitle = .init(string: Strings.StoryListView.refreshingString)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = nil
        tableView.separatorInset = .zero
        tableView.register(StoryTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var emptyView : UILabel = {
        let emptyView = UILabel(frame: .zero)
        emptyView.text = Strings.CommonStrings.emptyState
        emptyView.font = UIFont.systemFont(ofSize: emptyView.font.pointSize, weight: .heavy)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.isHidden = true
        return emptyView
    }()
    
    // MARK: - Public properties -

    var presenter: StoryListPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.presenter.viewDidAppear()
    }
    
    override func loadView() {
        super.loadView()
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .systemBackground
        } else {
            self.view.backgroundColor = .white
        }
    }
    // MARK: - Setup View -
    private func setupViews() {
        self.title = Strings.StoryListView.pageTitle
        self.view.addSubview(tableView)
        self.view.addSubview(emptyView)
        self.tableView.addSubview(refreshControl)
        self.setConstraints()
    }
    private func setConstraints() {
        setupEmptyState()
        setupTableView()
    }
    
    private func setupEmptyState() {
        let horizontalConstraint = NSLayoutConstraint(item: emptyView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: emptyView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: emptyView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Layout.emptyStateSize.width)
        let heightConstraint = NSLayoutConstraint(item: emptyView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Layout.emptyStateSize.height)
       view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    private func setupTableView() {
        let margins = view.layoutMarginsGuide
        let leadingConstraint = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: margins, attribute: .leading, multiplier: 1, constant: .zero)
        let topConstraint = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: margins, attribute: .top, multiplier: 1, constant: .zero)
        let trailingConstraint = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: margins, attribute: .trailing, multiplier: 1, constant: .zero)
        let bottomConstraint = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: margins, attribute: .bottom, multiplier: 1, constant: .zero)
       view.addConstraints([leadingConstraint, topConstraint, trailingConstraint, bottomConstraint])
    }
    @objc func refresh(_ sender: AnyObject) {
        self.presenter.pullToRefresh()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadVisibleCellsIfNeeded()
    }
    private func reloadVisibleCellsIfNeeded() {
        guard self.tableView.window != nil,
              let indexPathsForVisibleRows = self.tableView.indexPathsForVisibleRows ,
              indexPathsForVisibleRows.count > 0 else {
            self.tableView.reloadData()
            return
        }
        self.tableView.reloadRows(at: indexPathsForVisibleRows, with: .none)
    }
}

// MARK: - Extensions - StoryListViewInterface
extension StoryListViewController: StoryListViewInterface {
    
    func startLoading() {
        self.refreshControl.beginRefreshing()
    }
    
    func stopLoading() {
        self.refreshControl.endRefreshing()
    }
    
    func show(viewState: ViewState) {
        switch viewState {
        case .loaded:
            tableView.isHidden = false
            emptyView.isHidden = true
            self.tableView.reloadData()
        case .emptyState:
            tableView.isHidden = true
            emptyView.isHidden = false
        }
    }
    
   
}

// MARK: - Extensions - UITableViewDataSource
extension StoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfRows
    }
    
    //swiftlint:disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! StoryTableViewCell
        cell.configuration = .init(viewModel: self.presenter.rowFor(idx: indexPath.row))
        return cell
    }
    //swiftlint:enable force_cast
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.presenter.numberOfsection
    }
}
// MARK: - Extensions - UITableViewDelegate
extension StoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.didSelect(idx: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       UITableView.automaticDimension
    }
}
