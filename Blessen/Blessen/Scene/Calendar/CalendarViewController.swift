import UIKit
import SnapKit
import RealmSwift
import FSCalendar

class CalendarViewController: BaseViewController{
    
    var calendarView = CalendarView()
    var pickDate = String()
    var filterStudent = [String]()
    let localRealm = try! Realm()
    var studentTasks: Results<Student>! {
        didSet {
            self.calendarView.tableView.reloadData()
        }
    }
    var progressTasks: Results<Progress>! {
        didSet {
            self.calendarView.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = calendarView
        calendarView.backgroundColor = Constants.BaseColor.background
        calendarView.tableView.delegate = self
        calendarView.tableView.dataSource = self
        self.calendarView.tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.reuseIdentifier)
        
        navigationItem.title = "캘린더"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.calendarView.tableView.reloadData()
    }
    
    override func configure(){
        self.calendarView.tableView.register(CalenderViewCell.self, forCellReuseIdentifier: CalenderViewCell.reuseIdentifier)
        self.calendarView.tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.reuseIdentifier)
    }
    
    override func setConstraints() {
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CalenderViewCell.reuseIdentifier, for: indexPath) as! CalenderViewCell
            cell.calendar.delegate = self
            cell.calendar.dataSource = self
            cell.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
            return cell
        // MARK: 선택한 날짜 - 이름표시
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.reuseIdentifier, for: indexPath) as! CalendarTableViewCell
            let detailList = ["이름"]
            cell.nameLabel.text = detailList[indexPath.row]
            cell.contentLabel.text = filterStudent.joined(separator: ", ")
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 300
        case 1:
            return 50
        default:
            fatalError()
        }
    }
    
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        pickDate = dateFormatter.string(from: date)
        
        // MARK: 선택한 날짜 정보 filterStudent - 이름정보 담음
        let progressTasks = self.localRealm.objects(Progress.self)
        let studentTasks = self.localRealm.objects(Student.self)
        for progresstask in progressTasks{
            // task.check - list item 하나씩 추출
            for item in progresstask.checkDate {
                if item == pickDate {
                    print("check date: \(item) 일치함")
                    for studentTask in studentTasks{
                        if studentTask.objectID == progresstask.foreignID{
                            filterStudent.append(studentTask.name)
                            let set = Set(filterStudent)
                            filterStudent = Array(set).sorted()
                        }
                    }
                } else {
                    print("check date: \(item) 일치하지 않음.")
                    filterStudent.removeAll()
                }
            }
        }
        self.calendarView.tableView.reloadData()
    }
}
