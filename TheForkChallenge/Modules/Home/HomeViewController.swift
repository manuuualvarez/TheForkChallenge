//
//  HomeViewController.swift
//  TheForkChallenge
//
//  Created by Manuel Alvarez on 1/25/22.
//

import UIKit


private let reuseIdentifier = "RestaurantCell"

class HomeViewController: BaseViewController {
    
//    MARK: - UI Components
    private let tableView = UITableView()
    
    var viewModel: HomeViewModel!
    override var baseViewModel: BaseViewModel {
        return viewModel
    }
    
//    MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpTableView()
        bind()
        view.backgroundColor = .white
        self.restorationIdentifier = "HomeViewController"
    }
    
//  MARK: - Observers
    private func bind(){
        viewModel.tableRestaurantDataSort.observe(on: self) { [weak self] _ in
            self?.tableView.reloadData()
            self?.tableView.refreshControl?.endRefreshing()
        }
        
        viewModel.oderListTitle.observe(on: self) { [weak self] (title) in
            self?.navigationItem.leftBarButtonItem?.title = title
        }
    }
    
//    MARK: - Methods
    private func setUpNavigationBar(){
        self.navigationController?.navigationBar.topItem?.title = "Restaurants"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(showSort))
    }
        
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(RestauranstTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        
        let height = view.frame.height
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
    
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        let attrStr = NSAttributedString(string:"Refreshing...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        refreshControl.attributedTitle = attrStr
        refreshControl.addTarget(self, action: #selector(self.userDidRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    private func showSortActionSheet() {
        let action = UIAlertController(title: "Sort Options", message: "Select sort method", preferredStyle: .actionSheet)
        let sortByNameAsc = UIAlertAction(title: "Sort by name Asc", style: .default) {[weak self] _ in
            self?.viewModel.sorButtonDidTapped(type: .byNameAsc)
        }
        action.addAction(sortByNameAsc)
        
        let sortByNameDesc = UIAlertAction(title: "Sort by name Desc", style: .default) { [weak self] _ in
            self?.viewModel.sorButtonDidTapped(type: .byNameDesc)
        }
        action.addAction(sortByNameDesc)
        
        let sortByRatingFork = UIAlertAction(title: "Sort The Fork Rating", style: .default) {[weak self] _ in
            self?.viewModel.sorButtonDidTapped(type: .byForkRating)
        }
        action.addAction(sortByRatingFork)
        
        let sortByRatingTrip = UIAlertAction(title: "Sort The Trip Advisor Rating", style: .default) {[weak self] _ in
            self?.viewModel.sorButtonDidTapped(type: .byTripAdvisorRating)
        }
        action.addAction(sortByRatingTrip)
        
        self.present(action, animated: true, completion: nil)
        
        
    }
    
//    MARK: - Obj C
    @objc private func userDidRefresh() {
        viewModel.pullToRefres()
    }
    
    @objc private func showSort() {
        self.showSortActionSheet()
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableRestaurantDataSort.value.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.tableRestaurantDataSort.value[indexPath.row]
        let restoCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RestauranstTableViewCell
        restoCell.delegate = self
        restoCell.setUpCell(restaurant: data)
        return restoCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
//  MARK: - Image Tap Delegate
extension HomeViewController: LikedImageTapDelegate {
    func likekImageDidTap(name: String, status: Bool) {
        viewModel.likeImageDidTap(name: name, status: status)
    }
    
}



