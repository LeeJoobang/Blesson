import UIKit
import SnapKit
import RealmSwift

class MessageViewController: BaseViewController{
    
    var messageView = MessageView()
    let localRealm = try! Realm()
    let repository = MessageRepository()
    var checkList = [Bool]()
    
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
        tasks = repository.fetch()
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
        switch tasks.count {
        case 0...4:
            let vc = WriteViewController()
            transition(vc, transitionStyle: .push)
        case 5:
            showAlertMessage(title: "5개의 메세지까지 저장됩니다.", button: "확인")
        default:
            fatalError()
        }
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
    
    // MARK: row 삭제
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.repository.deleteData(data: self.tasks[indexPath.row])
        }
        self.messageView.tableView.reloadData()
    }

    @objc func checkboxButtonClicked(_ sender: UIButton){
        let task = tasks[sender.tag]
        
        for item in tasks{
            // 여기서 버튼의 값은 item.check이다.
            // 만약 item.check의 값을 우선적으로 1개다 그럼 그것을 바꾸고, 0개면 거기에 값을 바꿔주고, true의 값이 2개가 되려고 하면 안된다는 메세지를 띄우는 식으로 작성을 해보자.
            // 메모앱 - 상단 핀고정 갯수 필터를 걸어서 배열로 받아오는 것
            
            print(item.check)
        }

        repository.updateCheck(item: task)
        messageView.tableView.reloadData()
    }
}
