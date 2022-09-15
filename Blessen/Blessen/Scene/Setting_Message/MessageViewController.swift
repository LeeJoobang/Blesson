import UIKit
import SnapKit

class MessageViewController: BaseViewController{
    
    var messageView = MessageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = messageView
        messageView.backgroundColor = Constants.BaseColor.background
        messageView.tableView.delegate = self
        messageView.tableView.dataSource = self
        
        self.messageView.tableView.register(MessageViewTableCell.self, forCellReuseIdentifier: MessageViewTableCell.reuseIdentifier)
        
    }
    
    override func configure(){
        navigationItem.title = "메세지 설정"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        let backButton = UIBarButtonItem()
        backButton.title = "message"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .black
    
        let saveButton = UIBarButtonItem(title: "작성", style: .plain, target: self, action: #selector(writeButtonClicked))
        saveButton.tintColor = .black
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    override func setConstraints() {
    }
    
    @objc func writeButtonClicked(){
        let vc = WriteViewController()
        transition(vc, transitionStyle: .presentFullNavigation)
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageViewTableCell.reuseIdentifier, for: indexPath) as! MessageViewTableCell
        let image = "checkmark.square"
        cell.checkBoxButton.setImage(UIImage(systemName: image), for: .normal)
        cell.messageLabel.text = "TestTestTestTestTestTestTestTestTestTestTestTest"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
