import UIKit
import SnapKit

class WriteViewController: BaseViewController{
    
    var writeView = WriteView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = writeView
        addleftBarButtonItems()
        addrightBarButtonItem()
    }
        
    override func configure(){
        writeView.backgroundColor = Constants.BaseColor.background
        navigationItem.title = "message"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        writeView.writeTextView.becomeFirstResponder()
    }
    
    // MARK: 완료버튼 - endediting, save text
    func addrightBarButtonItem(){
        let saveButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveButtonClicked))
        saveButton.tintColor = Constants.BaseColor.text
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    // MARK: 뒤로가기 - save text, dismiss
    func addleftBarButtonItems(){
        let backImageButton = UIButton.init(type: .custom)
        backImageButton.tintColor = Constants.BaseColor.text
        backImageButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backImageButton.addTarget(self, action: #selector(backImageButtonClicked), for: .touchUpInside)
        
        let backButton = UIButton.init(type: .custom)
        backButton.setTitleColor(Constants.BaseColor.text, for: .normal)
        backButton.setTitle("메모", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        
        let stackview = UIStackView.init(arrangedSubviews: [backImageButton, backButton])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 4
        
        let leftBarButton = UIBarButtonItem(customView: stackview)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func saveButtonClicked(){
        view.endEditing(true)
        print("저장")
    }
    
    @objc func backButtonClicked(){
        print("뒤로")
        dismiss(animated: true)
    }
    
    @objc func backImageButtonClicked(){
        print("뒤로")
        dismiss(animated: true)
    }
}

