import UIKit
import SnapKit
import FSCalendar

class CalenderViewCell: BaseTableViewCell {
    
    let calendar: FSCalendar = {
        let view = FSCalendar()
        view.backgroundColor = .white
        view.scrollEnabled = true
        view.scrollDirection = .vertical
        view.locale = Locale(identifier: "ko_KR")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        self.contentView.addSubview(calendar)
    }
    
    override func setConstraints() {
        calendar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
}
