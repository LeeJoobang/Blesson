import UIKit
import Photos
import PhotosUI

import SnapKit
import RealmSwift
import SwiftUI
import IQKeyboardManagerSwift
import CropViewController
import AVFoundation



class RegisterViewController: BaseViewController{
    
    var registerView = RegisterView()
    let registetList = ["이름", "주소", "연락처", "레슨시작일", "레슨횟수", "레슨비"]
    let placeholderList = ["이름을 입력하세요.", "주소를 입력하세요.", "'-'를 제외하고 입력하세요.", "레슨시작일을 입력하세요.", "ex) 10 or 20", "ex)500000"]
    var registData = Array(repeating: "", count: 6)
    let localRealm = try! Realm()
    var studentTasks: Results<Student>!
    var lessonTasks: Results<Lesson>!
    var progressTasks: Results<Progress>!
    // MARK: date picker
    let datePicker = UIDatePicker()
    
    // MARK: image picker 추가
    let picker = UIImagePickerController()
    private var imageData: UIImage?
    var cropView = UIView()
    
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
        let filterData = registData.filter { $0.isEmpty }
        for item in filterData{
            print("registData: \(item)")
        }
        if filterData.isEmpty {
            // MARK: realm data 생성(student, lesson, progress)
            let studentTask = Student(name: registData[0], address: registData[1], phoneNumber: registData[2], image: nil)
            do {
                try localRealm.write{
                    localRealm.add(studentTask)
                    print("Realm Succeed")
                }
            } catch let error {
                print(error)
            }
            
            if let image = imageData {
                savaImageToDocument(filename: "\(studentTask.objectID).jpg", image: image)
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
            
            let progressTask = Progress(foreignID: studentTask.objectID, progressCount: 0)
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
            cell.imageButton.addTarget(self, action: #selector(imageButtonClicked(_:)), for: .touchUpInside)
            cell.idImageView.image = imageData
            cell.idImageView.contentMode = .scaleToFill
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: RegisterTableViewCell.reuseIdentifier, for: indexPath) as! RegisterTableViewCell
            cell.itemTextField.delegate = self
            cell.itemLabel.text = registetList[indexPath.row]
            cell.itemTextField.attributedPlaceholder = NSAttributedString(string: placeholderList[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
            cell.itemTextField.tag = indexPath.row
            switch indexPath.row{
            case 0, 1: // 이름, 주소 - 일반
                cell.itemTextField.keyboardType = .default
            case 3: // 레슨시작일 - 데이트피커
                cell.itemTextField.inputView = datePicker
                datePicker.datePickerMode = .date
                datePicker.locale = Locale(identifier: "ko_KR")
                datePicker.timeZone = .autoupdatingCurrent
                datePicker.preferredDatePickerStyle = .inline
                datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
                cell.itemTextField.text = registData[indexPath.row]
            case 2, 4, 5: // 레슨횟수, 레슨비 - ',' 적용, 숫자패드
                cell.itemTextField.keyboardType = .numberPad
                cell.itemTextField.inputView = nil
                
            default:
                fatalError()
            }
            return cell
        default:
            fatalError()
        }
    }
    
    @objc func imageButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let albumAction = UIAlertAction(title: "사진앨범", style: .default) { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in
            self.showImagePicker(sourceType: .camera)
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
    
    // MARK: 로우 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 이미지 섹션 높이 -> UIScreen 1/4 크기 확장
        if indexPath.section == 0 {
            let screenHeight = UIScreen.main.bounds.height
            let screenWidth = UIScreen.main.bounds.width
            let cellHeight = screenHeight / 4
            return cellHeight
        } else {
            return 80
        }
    }
}

extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.registerView.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.addTarget(self, action: #selector(saveTextFieldValue), for: .editingChanged)
        if textField.tag == 3{
            let date = DateFormatter()
            date.locale = Locale(identifier: "ko_kr")
            date.dateFormat = "yyyy-MM-dd"
            let selectDay = date.string(from: Date())
            self.registData[3].removeAll()
            self.registData[3].append(contentsOf: selectDay)
            guard let cell = registerView.tableView.cellForRow(at: [1, 3]) as? RegisterTableViewCell else {return false}
            if cell.itemTextField.text == nil || cell.itemTextField.text!.isEmpty {
                cell.itemTextField.text = selectDay
            }
        }
        return true
    }
    
    // MARK: 실시간 저장
    @objc func saveTextFieldValue(textField: UITextField){
        switch textField.tag {
        case 0, 1, 2, 4, 5:
            guard let text = textField.text else { return }
            registData[textField.tag] = text
            // MARK: comma 처리
            let count = Int(registData[4]) // 레슨횟수
            let fee = Int(registData[5]) // 레슨금액
            let numberFormaater = NumberFormatter()
            numberFormaater.numberStyle = .decimal
            if let decimalCount = count, let decimalFee = fee {
                guard let numberCount = numberFormaater.string(from: NSNumber(value: decimalCount)) else { return }
                guard let numberFee = numberFormaater.string(from: NSNumber(value: decimalFee)) else { return }
                registData[4] = numberCount
                registData[5] = numberFee
            }
        case 3:
            guard let text = textField.text else { return }
            if text.isEmpty {
                let date = DateFormatter()
                date.locale = Locale(identifier: "ko_kr")
                date.dateFormat = "yyyy-MM-dd"
                let selectDay = date.string(from: Date())
                self.registData[3].removeAll()
                self.registData[3].append(contentsOf: selectDay)
                textField.text = selectDay
            } else {
                datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
            }
        default:
            fatalError()
        }
    }
    
    // MARK: datepicker 데이트 표시 - reloadRows 활용
    @objc func handleDatePicker(_ sender: UIDatePicker, forEvent event: UIEvent){
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.dateFormat = "yyyy-MM-dd"
        let selectDay = date.string(from: sender.date)
        self.registData[3].removeAll()
        self.registData[3].append(contentsOf: selectDay)
        registerView.tableView.reloadRows(at: [IndexPath(row: 3, section: 1)], with: .fade)
    }
}

extension RegisterViewController: CropViewControllerDelegate{
    // 이미지를 크롭한 후 호출됩니다.
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        imageData = image
        registerView.tableView.reloadData()
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
// MARK: 앨범 - 이미지 선택 후 디스플레이
extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func showImagePicker(sourceType: UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
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


extension UIImage {
    var circularImage: UIImage? {
        let squareImage = fixOrientation().cropToSquare()
        let imageSize = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        return renderer.image { _ in
            UIBezierPath(roundedRect: CGRect(origin: .zero, size: imageSize), cornerRadius: imageSize.width / 2).addClip()
            squareImage.draw(in: CGRect(origin: CGPoint(x: (imageSize.width - squareImage.size.width) / 2, y: (imageSize.height - squareImage.size.height) / 2), size: squareImage.size))
        }
    }
    
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage ?? self
    }
    
    func cropToSquare() -> UIImage {
        let originalWidth  = self.size.width
        let originalHeight = self.size.height
        let cropSquare = min(self.size.width, self.size.height)
        let offsetX = (originalWidth - cropSquare) / 2.0
        let offsetY = (originalHeight - cropSquare) / 2.0
        
        let rect = CGRect(x: offsetX, y: offsetY, width: cropSquare, height: cropSquare)
        let imageRef = self.cgImage!.cropping(to: rect)
        let cropped = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return cropped
    }
}
