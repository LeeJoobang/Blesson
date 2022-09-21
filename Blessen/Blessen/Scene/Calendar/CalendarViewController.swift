import UIKit
import SnapKit
import RealmSwift
import FSCalendar

class CalendarViewController: BaseViewController{
    
    var calendarView = CalendarView()

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
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.reuseIdentifier, for: indexPath) as! CalendarTableViewCell
            let detailList = ["전체금액", "이름", "횟수", "금액"]
            cell.nameLabel.text = detailList[indexPath.row]
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
