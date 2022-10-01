import UIKit
import SnapKit

class MainTableViewCell: BaseTableViewCell {
    let totalView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.BaseColor.secondBackground
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Constants.BaseColor.labelBackground
        label.tintColor = Constants.BaseColor.text
        label.textAlignment = .center
        label.text = "이주영"

        label.font = UIFont(name: "Halvetica", size: 15)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Constants.BaseColor.labelBackground
        label.tintColor = Constants.BaseColor.text
        label.textAlignment = .right
        label.font = UIFont(name: "Halvetica", size: 15)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    let messageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.BaseColor.labelBackground
        button.tintColor = Constants.BaseColor.messageTint
        button.sizeToFit()
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [nameLabel, countLabel, messageButton].forEach {
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
        }
        
        messageButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.top)
            make.bottom.equalTo(nameLabel.snp.bottom)
            make.trailing.equalTo(totalView.snp.trailing).offset(0)
            make.width.equalTo(messageButton.snp.height)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.top)
            make.bottom.equalTo(nameLabel.snp.bottom)
            make.trailing.equalTo(messageButton.snp.leading).offset(-40)
            make.width.equalTo(countLabel.snp.height).multipliedBy(1.2)
        }


    }
}
