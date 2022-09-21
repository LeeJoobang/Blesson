import UIKit
import SnapKit

class CalendarTableViewCell: BaseTableViewCell {
    let totalView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.tintColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "Halvetica", size: 15)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.tintColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "Halvetica", size: 15)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [nameLabel, countLabel].forEach {
            self.totalView.addSubview($0)
        }
        
        self.contentView.addSubview(totalView)
    }
    
    override func setConstraints() {
        totalView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(0)
            make.height.equalTo(contentView.snp.height)
            make.trailing.equalTo(0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.totalView.snp.top)
            make.bottom.equalTo(self.totalView.snp.bottom)
            make.leading.equalTo(20)
            make.width.equalTo(70)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.top)
            make.bottom.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(self.nameLabel.snp.trailing).offset(20)
            make.trailing.equalTo(self.totalView.snp.trailing).offset(20)
        }
    }
}
