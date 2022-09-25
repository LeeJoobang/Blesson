import UIKit
import SnapKit
import RealmSwift
import FSCalendar

class CalendarViewController: BaseViewController{
    
    var calendarView = CalendarView()
    var pickDate = String()
    
    let localRealm = try! Realm()
    let studentRepository = StudentRepository()
    let lessonRepository = LessonRepository()
    let progressRepository = ProgressRepository()
    
    var filterStudent = [Student]()
    var filterLesson = [Lesson]()
    var filterProgress = [Progress]()

    var studentTasks: Results<Student>! {
        didSet {
            self.calendarView.tableView.reloadData()
        }
    }
    
    var lessonTasks: Results<Lesson>! {
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
            return 4
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
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.reuseIdentifier, for: indexPath) as! CalendarTableViewCell
            let detailList = ["전체금액", "이름", "레슨횟수", "수입"]
            cell.nameLabel.text = detailList[indexPath.row]

            // pickdate == checkDate 있으면, checkDate의 foreignID을 가지고, 이름, 레슨횟수, 수입을 뽑아야 한다.
            //
            
            
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
        print(pickDate)
        
        
        
        
    }
    
    // 선택된 날짜를 기준으로 테이블 정보 표시
    
    
}
