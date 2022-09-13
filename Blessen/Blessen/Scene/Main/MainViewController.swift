import UIKit
import SnapKit

class MainViewController: BaseViewController{
    
    var mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        navigationItem.title = "학생정보"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        mainView.backgroundColor = Constants.BaseColor.background
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        self.mainView.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        
        setupSearchController()
    }
    
    override func configure(){
    }
    
    override func setConstraints() {
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as! MainTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.backgroundColor = .systemGray6
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}
