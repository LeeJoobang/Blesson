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

    // MARK: 메세지 저장 갯수 제한 5개
    @objc func writeButtonClicked(){
        switch tasks.count {
        case 0...4:
            let vc = WriteViewController()
            transition(vc, transitionStyle: .push)
        case 5:
            showAlertMessage(title: "알림", message: "5개의 메세지까지 저장됩니다.", ok: "확인", cancel: "취소")
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
    
    // MARK: 작성된 메세지 수정
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WriteViewController()
        transition(vc, transitionStyle: .push)
        vc.writeView.writeTextView.text = tasks[indexPath.row].content
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
        let buttonClicked = tasks[sender.tag]
        var buttonChecked = [Bool]()
        for task in tasks{
            if task.check == true {
                buttonChecked.append(task.check)
            }
        }
        switch buttonChecked.count {
        case 0:
            repository.updateCheck(item: buttonClicked)
        case 1:
            repository.falseCheck(item: buttonClicked)
        default:
            fatalError()
        }
        messageView.tableView.reloadData()
    }
}
