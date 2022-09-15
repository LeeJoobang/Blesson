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
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    override func configure(){
    }
    
    override func setConstraints() {
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewTableCell.reuseIdentifier, for: indexPath) as! SettingViewTableCell
        let settingList = ["BackUp", "Restore", "Message"]
        let settingImageList = ["bell", "arrowshape.turn.up.backward", "message"]
        cell.setData(data: settingList[indexPath.row], image: settingImageList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row{
        case 0...1:
            print("backup & restore")
        case 2:
            let vc = MessageViewController()
            transition(vc, transitionStyle: .push)
        default:
            fatalError()
        }
    }

}
