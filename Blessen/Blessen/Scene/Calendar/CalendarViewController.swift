import UIKit
import SnapKit

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
    }
    
    override func setConstraints() {
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.reuseIdentifier, for: indexPath) as! CalendarTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
