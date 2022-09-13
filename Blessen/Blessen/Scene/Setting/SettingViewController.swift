import UIKit
import SnapKit

class SettingViewController: BaseViewController{
    
    var settingView = SettingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = settingView
        settingView.backgroundColor = Constants.BaseColor.background
        settingView.tableView.delegate = self
        settingView.tableView.dataSource = self
        
        self.settingView.tableView.register(SettingViewTableCell.self, forCellReuseIdentifier: SettingViewTableCell.reuseIdentifier)
        
        navigationItem.title = "설정"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        
    }
    
    override func configure(){
    }
    
    override func setConstraints() {
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewTableCell.reuseIdentifier, for: indexPath) as! SettingViewTableCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
