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
        mainView.tableView.reloadData()
        studentTasks = studentRepository.fetch()
        lessonTasks = lessonRepository.fetch()
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

// MARK: TableView 정보
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as! MainTableViewCell
        // count label의 기본값은 0으로 처리한다.
        cell.nameLabel.text = studentTasks[indexPath.row].name
        cell.countLabel.text = "\(0)\\\(lessonTasks[indexPath.row].lessonCount)"
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
        composViewController.body = """
        테스트를 진행해보고 있습니다. 정말 잘 표시가 되는지 궁금합니다.
        테스트를 진행해보고 있습니다. 정말 잘 표시가 되는지 궁금합니다.
        테스트를 진행해보고 있습니다. 정말 잘 표시가 되는지 궁금합니다.
        테스트를 진행해보고 있습니다. 정말 잘 표시가 되는지 궁금합니다.
        테스트를 진행해보고 있습니다. 정말 잘 표시가 되는지 궁금합니다.
        테스트를 진행해보고 있습니다. 정말 잘 표시가 되는지 궁금합니다.
        테스트를 진행해보고 있습니다. 정말 잘 표시가 되는지 궁금합니다.
        """
        transition(composViewController, transitionStyle: .present)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.studentTask = studentTasks[indexPath.row]
        vc.lesssonTask = lessonTasks[indexPath.row]
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
        }
        self.mainView.tableView.reloadData()
    }
}

// MARK: searchbar 등록
extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.backgroundColor = .systemGray6
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
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

