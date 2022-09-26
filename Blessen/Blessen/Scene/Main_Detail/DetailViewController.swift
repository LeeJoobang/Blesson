import UIKit
import MessageUI

import SnapKit
import RealmSwift

class DetailViewController: BaseViewController{
    
    var detailView = DetailView()
    let detailList = ["이름", "주소", "연락처", "레슨시작일", "누적금액", "누적횟수", "레슨비"]
    let localRealm = try! Realm()
    let studentRepository = StudentRepository()
    let lessonRepository = LessonRepository()
    var studentTask: Student!
    var lesssonTask: Lesson!
    var progressTask: Progress!
    var messageTasks: Results<MessageList>!

    lazy var originData = [studentTask.name, studentTask.address, studentTask.phoneNumber, lesssonTask.startDate,"누적금액", "누적횟수", lesssonTask.lessonFee, String(describing: studentTask.objectID)]
    lazy var modifyData = [studentTask.name, studentTask.address, studentTask.phoneNumber, lesssonTask.startDate,"누적금액", "누적횟수", lesssonTask.lessonFee, String(describing: studentTask.objectID)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = detailView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailView.tableView.reloadData()
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
        // MARK: 추가된 이미지(카메라, 앨범) loadImageFromDocument
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailImageCell.reuseIdentifier, for: indexPath) as! DetailImageCell
            cell.idImageView.image = loadImageFromDocument(filename: "\(studentTask.objectID).jpg")
            cell.idImageView.contentMode = .scaleToFill
            return cell
        //학생 디테일 정보
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
                cell.itemTextField.text = String((lesssonTask.totalCount / (Int(lesssonTask.lessonCount) ?? 0)) * (Int(lesssonTask.lessonFee) ?? 0))
                cell.itemTextField.tag = 4
            case 5:
                cell.itemTextField.text = String(lesssonTask.totalCount)
                cell.itemTextField.tag = 5
            case 6:
                cell.itemTextField.text = lesssonTask.lessonFee
                cell.itemTextField.tag = 6
            default:
                fatalError()
            }
            return cell
        //progressbar
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailProgressCell.reuseIdentifier, for: indexPath) as! DetailProgressCell
            cell.messageButton.setImage(UIImage(systemName: "message"), for: .normal)
            cell.messageButton.addTarget(self, action: #selector(messageButtonClicked), for: .touchUpInside)
            cell.plusButton.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
            cell.minusButton.addTarget(self, action: #selector(minusButtonClicked), for: .touchUpInside)
            let lessonCount = (lesssonTask.lessonCount as NSString).floatValue // progress gage 분모에 해당함
            let progressCount = Float(progressTask.progressCount)
            let calculateGage = progressCount / lessonCount
            cell.progressView.setProgress(calculateGage, animated: true)
            return cell
        default:
            fatalError()
        }
    }
    // MARK: +버튼 클릭 - progress +1 증가, realm(progress) data update
    @objc func plusButtonClicked(){
        let alert = UIAlertController(title: "알림", message: "레슨 횟수를 추가하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { [self] _ in
            // MARK: Realm => Progress - + 수정
            let progressTasks = self.localRealm.objects(Progress.self)

            for task in progressTasks {
                if self.studentTask.objectID == task.foreignID {
                    try! self.localRealm.write {
                        let lessonCount = (self.lesssonTask.lessonCount as NSString).floatValue // progress gage 분모에 해당함
                        let progressCount = Float(task.progressCount)
                        let calculateGage = progressCount / lessonCount
                        // MARK: 1.0 이상 올라가지 않도록 함.
                        switch calculateGage{
                        case 0...0.99:
                            task.progressCount += 1
                            lesssonTask.totalCount += 1// 누적횟수 증가로직(레슨진행 progressbar의 값과 무관)
                            task.checkDate.append(self.calculateToday())
                            self.detailView.tableView.reloadData()
                            print("progressCount, check date update")
                            // MARK: progressbar - 다찼을 경우, 초기화 진행
                        case 1.0...:
                            let alert = UIAlertController(title: "알림", message: "레슨 진행이 완료되었습니다. 초기화를 하시겠습니까?", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                                try! self.localRealm.write {
                                    task.progressCount = 0
                                }
                                self.detailView.tableView.reloadData()
                            }
                            let cancel = UIAlertAction(title: "취소", style: .cancel)
                            alert.addAction(ok)
                            alert.addAction(cancel)
                            present(alert, animated: true, completion: nil)
                        default:
                            fatalError()
                        }
                        self.detailView.tableView.reloadData()
                    }
                    self.detailView.tableView.reloadData()
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: -버튼 클릭 - progress -1 증가, realm(progress) data update
    @objc func minusButtonClicked(){
        let alert = UIAlertController(title: "알림", message: "레슨 횟수를 차감하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            // MARK: Realm => Progress - + 수정
            let progressTasks = self.localRealm.objects(Progress.self)
            for task in progressTasks {
                if self.studentTask.objectID == task.foreignID{
                    try! self.localRealm.write {
                        let lessonCount = (self.lesssonTask.lessonCount as NSString).floatValue // progress gage 분모에 해당함
                        let progressCount = Float(task.progressCount)
                        let calculateGage = progressCount / lessonCount
                        // MARK: 음수에서 작동하지 않도록 함.
                        switch calculateGage{
                        case 0.001...1.0:
                            task.progressCount -= 1
                            self.lesssonTask.totalCount -= 1 // 누적횟수 차감로직(레슨진행 progressbar의 값과 무관)
                            task.checkDate.removeLast()
                            print("progressCount, check date update")
                        case ...0:
                            self.showAlertMessage(title: "알림", message: "더이상 차감할 수 없습니다.")
                        default:
                            fatalError()
                        }
                    }
                    self.detailView.tableView.reloadData()
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // 오늘 날짜 생성함수
    func calculateToday() -> String{
        let nowDate = Date()
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
//        date.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"
        date.dateFormat = "yyyy-MM-dd"

        let today = date.string(from: nowDate)
        return today
    }
    
    // MARK: 버튼 클릭 후 message(학생 정보) 메세지 띄우기
    @objc func messageButtonClicked(_ button: UIButton){
        guard MFMessageComposeViewController.canSendText() else {
            print("SMS services are not available.")
            return
        }
        
        let composViewController = MFMessageComposeViewController()
        composViewController.messageComposeDelegate = self
        composViewController.recipients = [studentTask.phoneNumber]

        // MARK: message - check data default 메세지 반영
        let messageTasks = self.localRealm.objects(MessageList.self)
        for task in messageTasks {
            if task.check == true {
                let filterBody = task.content
                composViewController.body = filterBody
                break
            } else {
                composViewController.body = ""
            }
        }
        transition(composViewController, transitionStyle: .present)
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
            let alert = UIAlertController(title: "알림", message: "학생정보를 변경하시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                // MARK: Realm => Student - 수정
                let studentTasks = self.localRealm.objects(Student.self)
                for task in studentTasks {
                    if String(describing: task.objectID) == self.modifyData[7]{
                        try! self.localRealm.write {
                            task.name = self.modifyData[0]
                            task.address = self.modifyData[1]
                            task.phoneNumber = self.modifyData[2]
                        }
                    }
                }
                // MARK: Realm => Lesson - 수정
                let lessonTasks = self.localRealm.objects(Lesson.self)
                for task in lessonTasks {
                    if String(describing: task.foreignID) == self.modifyData[7]{
                        try! self.localRealm.write {
                            task.startDate = self.modifyData[3]
                            task.lessonFee = self.modifyData[6]
                        }
                    }
                }
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: 버튼 클릭 후 message 기본값 화면 띄우기
extension DetailViewController: MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        switch result {
        case .cancelled:
            print("cancelled")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("sent message:", controller.body ?? "안녕하세요?")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("failed")
            dismiss(animated: true, completion: nil)
        default:
            print("Error")
            dismiss(animated: true, completion: nil)
        }
    }
}
