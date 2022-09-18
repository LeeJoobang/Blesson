import UIKit
import SnapKit
import RealmSwift

class WriteViewController: BaseViewController{
    
    var writeView = WriteView()

    private let localRealm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = writeView
        addleftBarButtonItem()
        addrightBarButtonItem()
        print("Realm is located at:", localRealm.configuration.fileURL!)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            print("저장")
        }
    }
        
    override func configure(){
        writeView.backgroundColor = Constants.BaseColor.background
        navigationItem.title = "Message"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        writeView.writeTextView.becomeFirstResponder()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: 완료버튼 - endediting, save text
    func addrightBarButtonItem(){
        let saveButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveButtonClicked))
        saveButton.tintColor = Constants.BaseColor.text
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    // MARK: 뒤로가기 - save text, dismiss
    func addleftBarButtonItem(){
        let backButton = UIBarButtonItem()
        backButton.tintColor = Constants.BaseColor.text
        backButton.title = "메세지 설정"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    @objc func saveButtonClicked(){
        view.endEditing(true)
        guard let writeText = writeView.writeTextView.text else { return }
        let tasks = localRealm.objects(MessageList.self)
        let task = MessageList(content: writeText)
        do {
            try localRealm.write{
                localRealm.add(task)
                print("Realm Succeed")
            }
        } catch let error {
            print(error)
        }
    }
}

