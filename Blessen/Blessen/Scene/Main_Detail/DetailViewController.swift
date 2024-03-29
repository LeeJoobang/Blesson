import UIKit
import CropViewController
import PhotosUI
import AVFoundation

import MessageUI

import SnapKit
import RealmSwift

class DetailViewController: BaseViewController, CropViewControllerDelegate{
    
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
        modifyButton.tintColor = Constants.BaseColor.text
        navigationItem.rightBarButtonItems = [modifyButton]
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
            cell.imageButton.addTarget(self, action: #selector(imageButtonClicked(_:)), for: .touchUpInside)

            cell.idImageView.contentMode = .scaleAspectFit

            return cell
        //학생 디테일 정보
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier, for: indexPath) as! DetailTableViewCell
            
            cell.itemLabel.text = detailList[indexPath.row]
            cell.itemTextField.delegate = self
            switch indexPath.row {
            case 0: // 이름
                cell.itemTextField.text = studentTask.name
                cell.itemTextField.tag = 0
            case 1: // 주소
                cell.itemTextField.text = studentTask.address
                cell.itemTextField.tag = 1
            case 2: // 연락처
                cell.itemTextField.text = studentTask.phoneNumber
                cell.itemTextField.keyboardType = .numberPad
                cell.itemTextField.inputView = nil
                cell.itemTextField.tag = 2
            case 3: // 레슨시작일
                cell.itemTextField.text = lesssonTask.startDate
                cell.itemTextField.tag = 3
            case 4: // 누적금액, 콤마 표시
                let numberFormaater = NumberFormatter()
                numberFormaater.numberStyle = .decimal
                let calculateFee = (lesssonTask.totalCount / (Int(lesssonTask.lessonCount) ?? 0)) * (Int(lesssonTask.lessonFee.components(separatedBy: ",").joined()) ?? 0)
                let result = numberFormaater.string(from: NSNumber(value: calculateFee))
                cell.itemTextField.text = result
                cell.itemTextField.keyboardType = .numberPad
                cell.itemTextField.tag = 4
            case 5: // 누적횟수
                cell.itemTextField.text = String(lesssonTask.totalCount)
                cell.itemTextField.keyboardType = .numberPad
                cell.itemTextField.tag = 5
            case 6: // 레슨비
                cell.itemTextField.text = lesssonTask.lessonFee
                cell.itemTextField.keyboardType = .numberPad
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
    
            let lessonCount = (self.lesssonTask.lessonCount as NSString).floatValue // progress gage 분모에 해당함
            let progressCount = Float(self.progressTask.progressCount)
            let calculateGage = progressCount / lessonCount
            cell.progressView.setProgress(calculateGage, animated: true)
            return cell
        default:
            fatalError()
        }
    }
//카메라 버튼 이미지 수정
    @objc func imageButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let albumAction = UIAlertAction(title: "사진앨범", style: .default) { _ in
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == PHAuthorizationStatus.authorized {
                        // 권한 허용됨
                        self.showImagePicker(sourceType: .photoLibrary)
                    } else {
                        // 권한요청 거부 + 재알림창
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "앨범 권한이 거부되었습니다.", message: "앨범에 액세스하려면 권한을 허용해야합니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                            alert.addAction(UIAlertAction(title: "설정", style: .default, handler: { action in
                                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                })
            } else if status == .denied { // status denied
                // 권한요청 거부 + 재알림창
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "앨범 권한이 거부되었습니다.", message: "앨범에 액세스하려면 권한을 허용해야합니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "설정", style: .default, handler: { action in
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            } else if status == .authorized { // 설정에서 사진 허용한 경우
                self.showImagePicker(sourceType: .photoLibrary)
            }
        }
        
        let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == PHAuthorizationStatus.authorized {
                        // 권한 허용됨
                        self.showImagePicker(sourceType: .camera)
                    } else {
                        // 권한요청 거부 + 재알림창
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "카메라 권한이 거부되었습니다.", message: "카메라 액세스하려면 권한을 허용해야합니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                            alert.addAction(UIAlertAction(title: "설정", style: .default, handler: { action in
                                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
            } else if status == .denied { // status denied
                // 권한요청 거부 + 재알림창
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "카메라 권한이 거부되었습니다.", message: "카메라 액세스하려면 권한을 허용해야합니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "설정", style: .default, handler: { action in
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            } else if status == .authorized { // 설정에서 사진 허용한 경우
                self.showImagePicker(sourceType: .camera)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(albumAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: +버튼 클릭 - progress +1 증가, realm(progress) data update
    @objc func plusButtonClicked(){
         let progressTasks = self.localRealm.objects(Progress.self)
         for task in progressTasks {
             if self.studentTask.objectID == task.foreignID {
                 try! self.localRealm.write {
                     let lessonCount = (self.lesssonTask.lessonCount as NSString).floatValue // progress gage 분모에 해당함
                     let progressCount = Float(task.progressCount)
                     let calculateGage = progressCount / lessonCount
                     print("calculateGage: \(calculateGage)")
                     // MARK: 1.0 이상 올라가지 않도록 함.
                     switch calculateGage{
                     case 0...0.99:
                         task.progressCount += 1
                         self.lesssonTask.totalCount += 1// 누적횟수 증가로직(레슨진행 progressbar의 값과 무관)
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
    
    // MARK: -버튼 클릭 - progress -1 증가, realm(progress) data update
    @objc func minusButtonClicked(){

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
    
    // 오늘 날짜 생성함수
    func calculateToday() -> String{
        let nowDate = Date()
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
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
            let screenHeight = UIScreen.main.bounds.height
            let screenWidth = UIScreen.main.bounds.width
            let cellHeight = screenHeight / 4
            return cellHeight
        case 1:
            return 65
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


extension DetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func showImagePicker(sourceType: UIImagePickerController.SourceType){
        
        DispatchQueue.main.async {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    // 앨범에서 이미지를 선택했을 때 호출됩니다.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let cropViewController = CropViewController(croppingStyle: .circular, image: image)
            cropViewController.delegate = self
            picker.pushViewController(cropViewController, animated: true)
        }
    }
    
    // 이미지 선택을 취소했을 때 호출됩니다.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func fetchImage(for asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        
        let imageSize = CGSize(width: 200, height: 200)
        let imageManager = PHImageManager.default()
        imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: options) { (image, info) in
            guard let image = image else {
                completion(nil)
                return
            }
            completion(image)
        }
    }
    
}
