import UIKit
import SnapKit
import RealmSwift

class MessageViewController: BaseViewController{
    
    var messageView = MessageView()
    let localRealm = try! Realm()
    let repository = BlessenRepository()
    
    var tasks: Results<MessageList>! {
        didSet {
            self.messageView.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = messageView
        messageView.backgroundColor = Constants.BaseColor.background
        messageView.tableView.delegate = self
        messageView.tableView.dataSource = self
        
        self.messageView.tableView.register(MessageViewTableCell.self, forCellReuseIdentifier: MessageViewTableCell.reuseIdentifier)
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        tasks = localRealm.objects(MessageList.self)
        messageView.tableView.reloadData()
        //        tasks = repository.fetch()
    }
    
    override func configure(){
        navigationItem.title = "메세지 설정"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        let backButton = UIBarButtonItem()
        backButton.title = "Message"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .black
        
        let saveButton = UIBarButtonItem(title: "작성", style: .plain, target: self, action: #selector(writeButtonClicked))
        saveButton.tintColor = .black
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    @objc func writeButtonClicked(){
        let vc = WriteViewController()
        transition(vc, transitionStyle: .push)
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageViewTableCell.reuseIdentifier, for: indexPath) as! MessageViewTableCell
        let image = tasks[indexPath.row].check ? "checkmark.square" : "square"
        
        cell.messageLabel.text = tasks[indexPath.row].content
        cell.checkBoxButton.setImage(UIImage(systemName: image), for: .normal)
        cell.checkBoxButton.addTarget(self, action: #selector(checkboxButtonClicked), for: .touchUpInside)
        cell.checkBoxButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc func checkboxButtonClicked(_ sender: UIButton){
        let task = tasks[sender.tag]
        try! localRealm.write {
            task.check.toggle()
        }
        messageView.tableView.reloadData()
    }
}
