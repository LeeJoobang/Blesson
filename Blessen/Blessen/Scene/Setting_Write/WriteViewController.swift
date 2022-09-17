import UIKit
import SnapKit

class WriteViewController: BaseViewController{
    
    var writeView = WriteView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = writeView
        addleftBarButtonItem()
        addrightBarButtonItem()
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
        print("저장")
    }
}

