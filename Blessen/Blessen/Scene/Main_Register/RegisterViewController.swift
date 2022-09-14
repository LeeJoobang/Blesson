import UIKit
import SnapKit

class RegisterViewController: BaseViewController{
    
    var registerView = RegisterView()

    let registetList = ["","이름", "주소", "연락처", "레슨시작일", "레슨횟수", "레슨비"]
    let placeholderList = ["","이름을 입력하세요.", "주소를 입력하세요.", "'-'를 제외하고 입력하세요.", "레슨시작일을 입력하세요.", "ex) 10 or 20", "ex)500000"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = registerView
        registerView.saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
    }
    
    override func configure(){
        registerView.backgroundColor = Constants.BaseColor.background
        registerView.tableView.delegate = self
        registerView.tableView.dataSource = self
        self.registerView.tableView.register(RegisterImageCell.self, forCellReuseIdentifier: RegisterImageCell.reuseIdentifier)
        self.registerView.tableView.register(RegisterTableViewCell.self, forCellReuseIdentifier: RegisterTableViewCell.reuseIdentifier)
    }
    
    override func setConstraints() {
    }
    
    @objc func saveButtonClicked(){
        dismiss(animated: true)
        print("저장")
    }
}

extension RegisterViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: RegisterImageCell.reuseIdentifier, for: indexPath) as! RegisterImageCell
            return cell
        case 1...6:
            let cell = tableView.dequeueReusableCell(withIdentifier: RegisterTableViewCell.reuseIdentifier, for: indexPath) as! RegisterTableViewCell
            cell.itemLabel.text = registetList[indexPath.row]
            cell.itemTextField.attributedPlaceholder = NSAttributedString(string: placeholderList[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        } else {
            return 60
        }
    }
    
}
