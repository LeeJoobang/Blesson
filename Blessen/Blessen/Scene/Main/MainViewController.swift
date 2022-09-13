import UIKit
import SnapKit

class MainViewController: BaseViewController{
    
    var mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        mainView.backgroundColor = Constants.BaseColor.background
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        self.mainView.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
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
