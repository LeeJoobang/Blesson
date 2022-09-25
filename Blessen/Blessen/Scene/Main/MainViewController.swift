import UIKit
import SwiftUI
import MessageUI

import SnapKit
import RealmSwift

class MainViewController: BaseViewController{
    
    var mainView = MainView()
    let localRealm = try! Realm()
    let studentRepository = StudentRepository()
    let lessonRepository = LessonRepository()
    let progressRepository = ProgressRepository()
    
    var filterStudent = [Student]()
    var filterLesson = [Lesson]()
    var filterProgress = [Progress]()

    var studentTasks: Results<Student>! {
        didSet {
            self.mainView.tableView.reloadData()
        }
    }
    
    var lessonTasks: Results<Lesson>! {
        didSet {
            self.mainView.tableView.reloadData()
        }
    }
    
    var progressTasks: Results<Progress>! {
        didSet {
            self.mainView.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        navigationItem.title = "학생정보"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        mainView.backgroundColor = Constants.BaseColor.background
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        self.mainView.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        setupSearchController()
        setupToolbar()
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        studentTasks = localRealm.objects(Student.self)
        lessonTasks = localRealm.objects(Lesson.self)
        progressTasks = localRealm.objects(Progress.self)
        mainView.tableView.reloadData()
        studentTasks = studentRepository.fetch()
        lessonTasks = lessonRepository.fetch()
        progressTasks = progressRepository.fetch()
    }

    override func configure(){
    }
    
    override func setConstraints() {
    }
    
    // MARK: +버튼 toolbar 사용
    func setupToolbar(){
        let toolbar = UIToolbar()
        view.addSubview(toolbar)
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 0).isActive = true
        toolbar.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 0).isActive = true
        toolbar.trailingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.trailingAnchor, multiplier: 0).isActive = true
        
        let toolbarItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(registerButtonClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItem.tintColor = .black
        toolbar.barTintColor = UIColor.white
        toolbar.setItems([flexibleSpace, toolbarItem], animated: true)
    }
    
    // MARK: +버튼 클릭시 RegisterViewController 이동
    @objc func registerButtonClicked(){
        let vc = RegisterViewController()
        transition(vc, transitionStyle: .present)
    }
}

// MARK: TableView 정보(별도 섹션 구분하지 않고 사용하고 있음)
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    // MARK: filter data 있을 경우에 대한 로직 반영
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering == true ? filterStudent.count : studentTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as! MainTableViewCell

        // MARK: filter data 있을 경우 표시되는 데이터 바뀜
        var data = [String]() // 진행되는 정보표시를 담는 공간
        filterProgress = isFiltering == true ? progressTasks.filter { $0.foreignID == filterStudent[indexPath.row].objectID } : progressTasks.filter { $0.foreignID == studentTasks[indexPath.row].objectID}
        filterLesson = isFiltering == true ? lessonTasks.filter { $0.foreignID == filterStudent[indexPath.row].objectID } : lessonTasks.filter { $0.foreignID == studentTasks[indexPath.row].objectID}
        data.append(String(describing: filterProgress[0].progressCount))
        data.append(filterLesson[0].lessonCount)

        cell.nameLabel.text = isFiltering == true ? filterStudent[indexPath.row].name : studentTasks[indexPath.row].name
        cell.countLabel.text = "\(data[0])/\(data[1])"
        cell.messageButton.tag = indexPath.row
        cell.messageButton.setImage(UIImage(systemName: "message"), for: .normal)
        cell.messageButton.addTarget(self, action: #selector(messageButtonClicked), for: .touchUpInside)
        return cell
    }
    
    // MARK: 버튼 클릭 후 message 기본값 화면 띄우기
    @objc func messageButtonClicked(_ button: UIButton){
        guard MFMessageComposeViewController.canSendText() else {
            print("SMS services are not available.")
            return
        }
        let composViewController = MFMessageComposeViewController()
        composViewController.messageComposeDelegate = self
        composViewController.recipients = [studentTasks[button.tag].phoneNumber]
        composViewController.body = ""
        transition(composViewController, transitionStyle: .present)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.studentTask = isFiltering == true ? filterStudent[indexPath.row] : studentTasks[indexPath.row]
        
        
        // progressTasks의 foreignID와 studentTasks[indexPath.row].objectID와 중복된 것을 찾는다.
//        let notfilteringProgress = progressTasks.filter { $0.foreignID == self.studentTasks[indexPath.row].objectID}
//        print("======notfilteringProgress: \(notfilteringProgress)")
//        print("======================================================")
//        print("select indexPath.row: \(indexPath.row)")
//        print("self.studentTasks[indexPath.row].objectID:   \(self.studentTasks[indexPath.row].objectID)")
//        let sameObjectIDProgress = progressTasks.filter { $0.foreignID == self.studentTasks[indexPath.row].objectID }
//        print("sameObjectIDProgress: \(sameObjectIDProgress)")
//
//        let anotherProgress = realm.objects(progressTasks.filter {$0.foreignID == self.studentTasks[indexPath.row].objectID})
//        print("anotherProgress: \(anotherProgress)")

    
        // MARK: filter data 전달
        if isFiltering == true {
            // 만약 필터링된 데이터가 true라면
            for task in filterLesson {
                if filterStudent[indexPath.row].objectID == task.foreignID{
                    vc.lesssonTask = task
                }
            }
            for task in filterProgress {
                if filterStudent[indexPath.row].objectID == task.foreignID{
                    vc.progressTask = task
                }
            }
        } else {
            for task in lessonTasks {
                if studentTasks[indexPath.row].objectID == task.foreignID{
                    vc.lesssonTask = task
                }
            }
            for task in progressTasks {
                if studentTasks[indexPath.row].objectID == task.foreignID{
                    vc.progressTask = task
                }
            }
        }
        transition(vc, transitionStyle: .push)
    }
    
    // MARK: delete 하기
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.studentRepository.deleteData(data: self.studentTasks[indexPath.row])
            self.lessonRepository.deleteData(data: self.lessonTasks[indexPath.row])
            self.progressRepository.deleteData(data: self.progressTasks[indexPath.row])
        }
        self.mainView.tableView.reloadData()
    }
}

// MARK: searchbar 등록
extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate{
    // MARK: searchController 설정
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.backgroundColor = .systemGray6
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: search filter 내용 담음
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterStudent = self.studentTasks.filter { $0.name.lowercased().contains(text)}
        self.mainView.tableView.reloadData()
    }
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
}

// MARK: 버튼 클릭 후 message 기본값 화면 띄우기
extension MainViewController: MFMessageComposeViewControllerDelegate{
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

