//
//  ViewController.swift
//  TestNewsApp
//
//  Created by пользователь on 4/3/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UIElem declaration
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Variables declaration
    let searchController = UISearchController(searchResultsController: nil)
    let refreshControl = UIRefreshControl()
    
    private var allNewsList: [Articles] = []
    private var sortedList: [Articles] = []
    private var newsApiManager = NewsNetworkManager.shared
    private var hasMoreNews: Bool = true
    private var isNewsLoading: Bool = false
    private var daysCounter = 0
    private var isSearching = false
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        guard let requiredDay = getNumbersdayAgo(countDay: daysCounter)  else { return }
        tableView.register(UINib(nibName: String( describing: NewsTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String( describing:NewsTableViewCell.self))
        configureSearchController() 
        getNewsFor(date: requiredDay)
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(updateNewsList), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - Methods
    @objc func updateNewsList(refreshControl: UIRefreshControl) {
        sortedList.removeAll()
        allNewsList.removeAll()
        daysCounter = 0
        hasMoreNews = true
        refreshControl.beginRefreshing()
        guard let requiredDay = getNumbersdayAgo(countDay: daysCounter)  else {
            refreshControl.endRefreshing()
            return
        }
        getNewsFor(date: requiredDay)
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barStyle = .default
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        tableView.backgroundView = UIView()
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func needLoadMoreNews(for indexPath: IndexPath) -> Bool {
        if sortedList.count - indexPath.row < 10,
           hasMoreNews, !isSearching,
           !isNewsLoading {
            return true
        } else { return false }
    }
    
    private func getNewsFor(date: Date) {
        isNewsLoading = true
        self.daysCounter += 1
        newsApiManager.getNews(date: date ) { [weak self] (newsList) in
            guard let self = self else { return }
            self.allNewsList += newsList.articles.sorted(by: {$0.newsDate! > $1.newsDate!})
            self.hasMoreNews = self.allNewsList.isEmpty || self.daysCounter == 6 ? false : true
            self.sortedList = self.allNewsList
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
                self.isNewsLoading = false
            }
        } failure: { [weak self ](error) in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            print("OOOppps: \(error.localizedDescription)" + "")
        }
    }
    
    private func getNumbersdayAgo(countDay: Int) -> Date? {
        if let requiredDay = Calendar(identifier: .gregorian).date(byAdding: .day, value: -countDay, to: Date()) {
            return requiredDay
        }
        return nil
    }
}

// MARK: - Extensions
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if needLoadMoreNews(for: indexPath), let requiredDay = getNumbersdayAgo(countDay: daysCounter) {
            getNewsFor(date: requiredDay)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsTableViewCell.self), for: indexPath) as! NewsTableViewCell
        cell.configure(news: sortedList[indexPath.row], serialNumber: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text ?? ""
        searchForText(searchString)
    }
    
    private func searchForText(_ text: String) {
        
        if !isNewsLoading {
            
            isSearching = true
            if text.isEmpty {
                isSearching = false
                sortedList = allNewsList
            } else {
                sortedList = allNewsList
                sortedList = allNewsList.filter{ $0.title!.hasPrefix(text)}
                sortedList = sortedList.sorted(by: {$0.title! == text || $1.title! == text})
            }
            tableView.reloadData()
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let set = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
        return text.rangeOfCharacter(from: set) == nil
    }
}

extension ViewController: NewsTableViewCellDelegate {
    func readMoreButtonPressed(serialNumber: Int) {
        let item = sortedList[serialNumber]
        if let stringUrl = item.url {
            let webViewViewController = WebViewController(urlString: stringUrl)
            navigationController?.pushViewController(webViewViewController, animated: true)
        }
    }
}
