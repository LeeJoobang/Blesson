import UIKit
import SnapKit
import RealmSwift

class DetailViewController: BaseViewController{
    
    var detailView = DetailView()
    let detailList = ["이름", "주소", "연락처", "레슨시작일", "누적금액", "누적횟수", "레슨비"]
    let localRealm = try! Realm()
    let studentRepository = StudentRepository()
    let lessonRepository = LessonRepository()
    var lesssonTask: Lesson!
    var studentTask: Student!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = detailView
        print(lesssonTask)
        print(studentTask)

    }
    
    override func configure(){
        detailView.backgroundColor = Constants.BaseColor.background
        detailView.tableView.delegate = self
        detailView.tableView.dataSource = self
        
        self.detailView.tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.reuseIdentifier)
        self.detailView.tableView.register(DetailImageCell.self, forCellReuseIdentifier: DetailImageCell.reuseIdentifier)
        self.detailView.tableView.register(DetailProgressCell.self, forCellReuseIdentifier: DetailProgressCell.reuseIdentifier)
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
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailImageCell.reuseIdentifier, for: indexPath) as! DetailImageCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier, for: indexPath) as! DetailTableViewCell
            cell.itemLabel.text = detailList[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.itemTextField.text = studentTask.name
            case 1:
                cell.itemTextField.text = studentTask.address
            case 2:
                cell.itemTextField.text = studentTask.phoneNumber
            case 3:
                cell.itemTextField.text = lesssonTask.startDate
            case 4:
                cell.itemTextField.text = "누적금액"
            case 5:
                cell.itemTextField.text = "누적횟수"
            case 6:
                cell.itemTextField.text = lesssonTask.lessonFee
            default:
                fatalError()
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailProgressCell.reuseIdentifier, for: indexPath) as! DetailProgressCell
            return cell
        default:
            fatalError()
        }
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

