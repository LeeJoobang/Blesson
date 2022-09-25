import UIKit
import Photos
import PhotosUI

import SnapKit
import RealmSwift
import SwiftUI

class RegisterViewController: BaseViewController{
    
    var registerView = RegisterView()
    
    let registetList = ["이름", "주소", "연락처", "레슨시작일", "레슨횟수", "레슨비"]
    let placeholderList = ["이름을 입력하세요.", "주소를 입력하세요.", "'-'를 제외하고 입력하세요.", "레슨시작일을 입력하세요.", "ex) 10 or 20", "ex)500000"]
    var registData = Array(repeating: "", count: 6)
    let localRealm = try! Realm()
    var studentTasks: Results<Student>!
    var lessonTasks: Results<Lesson>!
    var progressTasks: Results<Progress>!
    
    // MARK: image picker 추가
    let picker = UIImagePickerController()
    private var imageData = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = registerView
        picker.delegate = self
        registerView.saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingViewController?.viewWillDisappear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(true)
    }
    
    override func configure(){
        registerView.backgroundColor = Constants.BaseColor.background
        registerView.tableView.delegate = self
        registerView.tableView.dataSource = self
        self.registerView.tableView.register(RegisterImageCell.self, forCellReuseIdentifier: RegisterImageCell.reuseIdentifier)
        self.registerView.tableView.register(RegisterTableViewCell.self, forCellReuseIdentifier: RegisterTableViewCell.reuseIdentifier)
    }
    
    @objc func saveButtonClicked(_ sender: Any){
        let filterData = registData.filter { $0 == "" }
        if filterData.count == 0 {
            // MARK: realm data 생성(student, lesson, progress)            
            let studentTask = Student(name: registData[0], address: registData[1], phoneNumber: registData[2])
            do {
                try localRealm.write{
                    localRealm.add(studentTask)
                    print("Realm Succeed")
                }
            } catch let error {
                print(error)
            }
            
            let lessonTask = Lesson(foreignID: studentTask.objectID, lessonFee: registData[5], startDate: registData[3], lessonCount: registData[4])
            do {
                try localRealm.write{
                    localRealm.add(lessonTask)
                    print("Realm Succeed")
                }
            } catch let error {
                print(error)
            }
            
            let progressTask = Progress(foreignID: studentTask.objectID, checkDate: calculateToday(), progressCount: 0)
            do {
                try localRealm.write{
                    localRealm.add(progressTask)
                    print("Realm Succeed")
                }
            } catch let error {
                print(error)
            }
            dismiss(animated: true)
        } else {
            showAlertMessage(title: "알림", message: "학생 정보를 입력해주세요.", ok: "확인", cancel: "취소")
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
}

// MARK: 학생 저장 테이블뷰 - 2개 section 구성
extension RegisterViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 6
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: RegisterImageCell.reuseIdentifier, for: indexPath) as! RegisterImageCell
            cell.imageButton.addTarget(self, action: #selector(imageButtonClicked), for: .touchUpInside)
            cell.idImageView.image = imageData
            cell.idImageView.contentMode = .scaleToFill
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: RegisterTableViewCell.reuseIdentifier, for: indexPath) as! RegisterTableViewCell
            cell.itemTextField.delegate = self
            cell.itemLabel.text = registetList[indexPath.row]
            cell.itemTextField.attributedPlaceholder = NSAttributedString(string: placeholderList[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
            cell.itemTextField.tag = indexPath.row
            
            return cell
        default:
            fatalError()
        }
    }
    
    // MARK: image button clicked - album, camera 기능 적용 + alert: action Sheet
    @objc func imageButtonClicked(){
        print("image button clicked")
        
        let alert = UIAlertController(title: "알림", message: "사진을 추가해주시겠습니까?", preferredStyle: .actionSheet)

        let library = UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        
        let camera = UIAlertAction(title: "카메라", style: .default) { (action) in self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: phpickercontroller를 통해서 image 1개 선택
    func openLibrary(){
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func openCamera(){
        if (UIImagePickerController .isSourceTypeAvailable(.camera)) {
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }else {
            print("Camera not available")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 60
        }
    }
}

extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            showAlertMessage(title: "알림", message: "데이터를 입력해주세요.", ok: "확인", cancel: "취소")
        } else {
            guard let text = textField.text else { return }
            registData[textField.tag] = ""
            registData[textField.tag].append(text)
            textField.resignFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}

// MARK: image phpicker를 사용해 image 선택하고, imageData에 담은 후 cell 생성시 데이터를  담는다.
extension RegisterViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let group = DispatchGroup()
        results.forEach { result in
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                defer{
                    group.leave()
                }
                guard let image = reading as? UIImage, error == nil else { return }
                self?.imageData = image
            }
        }
        group.notify(queue: .main) {
            print(self.imageData)
            self.registerView.tableView.reloadData()

        }
    }
    
}

// MARK: 앨범 - 이미지 선택 후 디스플레이, 이미지 사이즈가 크기 변동이 필요함.

extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            print(image)
            imageData = image
        }
        self.registerView.tableView.reloadData()
        dismiss(animated: true, completion: nil)

    }
}
