import UIKit
import SnapKit
import RealmSwift

class DetailViewController: BaseViewController{
    
    var detailView = DetailView()
    let detailList = ["이름", "주소", "연락처", "레슨시작일", "누적금액", "누적횟수", "레슨비"]
    let localRealm = try! Realm()
    let studentRepository = StudentRepository()
    let lessonRepository = LessonRepository()
    var lesssonTask: Lesson!
    var studentTask: Student!
    
    lazy var originData = [studentTask.name, studentTask.address, studentTask.phoneNumber, lesssonTask.startDate,"누적금액", "누적횟수", lesssonTask.lessonFee, String(describing: studentTask.objectID)]
    lazy var modifyData = [studentTask.name, studentTask.address, studentTask.phoneNumber, lesssonTask.startDate,"누적금액", "누적횟수", lesssonTask.lessonFee, String(describing: studentTask.objectID)]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = detailView
    }
    
    override func configure(){
        detailView.backgroundColor = Constants.BaseColor.background
        detailView.tableView.delegate = self
        detailView.tableView.dataSource = self
        
        self.detailView.tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.reuseIdentifier)
        self.detailView.tableView.register(DetailImageCell.self, forCellReuseIdentifier: DetailImageCell.reuseIdentifier)
        self.detailView.tableView.register(DetailProgressCell.self, forCellReuseIdentifier: DetailProgressCell.reuseIdentifier)
        
        let modifyButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(modifyButtonClicked))
        modifyButton.tintColor = .black
        navigationItem.rightBarButtonItems = [modifyButton]
    }
    
    override func setConstraints() {
    }
    
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return detailList.count
        case 2:
            return 1
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailImageCell.reuseIdentifier, for: indexPath) as! DetailImageCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier, for: indexPath) as! DetailTableViewCell
            
            cell.itemLabel.text = detailList[indexPath.row]
            cell.itemTextField.delegate = self
            switch indexPath.row {
            case 0:
                cell.itemTextField.text = studentTask.name
                cell.itemTextField.tag = 0
            case 1:
                cell.itemTextField.text = studentTask.address
                cell.itemTextField.tag = 1
            case 2:
                cell.itemTextField.text = studentTask.phoneNumber
                cell.itemTextField.tag = 2
            case 3:
                cell.itemTextField.text = lesssonTask.startDate
                cell.itemTextField.tag = 3
            case 4:
                cell.itemTextField.text = "누적금액"
                cell.itemTextField.tag = 4
            case 5:
                cell.itemTextField.text = "누적횟수"
                cell.itemTextField.tag = 5
            case 6:
                cell.itemTextField.text = lesssonTask.lessonFee
                cell.itemTextField.tag = 6
            default:
                fatalError()
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailProgressCell.reuseIdentifier, for: indexPath) as! DetailProgressCell
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 60
        case 2:
            return 80
        default:
            fatalError()
        }
    }
}

extension DetailViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if originData[textField.tag] != text{
            modifyData[textField.tag] = text
        }
    }
    
    // MARK: 수정버튼 클릭 후 realm 데이터 업데이트(Student, Lesson)
    @objc func modifyButtonClicked(){
        if originData != modifyData {
            showAlertMessage(title: "알림", message: "정보가 변경되었습니다. 수정하시겠습니까?", ok: "확인", cancel: "취소")
            // MARK: Realm => Student - 수정
            let studentTasks = localRealm.objects(Student.self)
            for task in studentTasks {
                if String(describing: task.objectID) == modifyData[7]{
                    try! localRealm.write {
                        task.name = modifyData[0]
                        task.address = modifyData[1]
                        task.phoneNumber = modifyData[2]
                    }
                }
            }
            // MARK: Realm => Lesson - 수정
            let lessonTasks = localRealm.objects(Lesson.self)
            for task in lessonTasks {
                if String(describing: task.foreignID) == modifyData[7]{
                    try! localRealm.write {
                        task.startDate = modifyData[3]
                        task.lessonFee = modifyData[6]
                    }
                }
            }
        }
    }
}

