import UIKit
import SnapKit

class MessageViewTableCell: BaseTableViewCell {
    let totalView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.BaseColor.background
        return view
    }()
    
    let checkBoxButton: UIButton = {
        let check = UIButton()
        check.backgroundColor = Constants.BaseColor.background
        check.tintColor = Constants.BaseColor.text
        return check
    }()

    let messageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Constants.BaseColor.background
        label.textAlignment = .left
        label.font = UIFont(name: "Halvetica", size: 15)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    let rightImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = Constants.BaseColor.text
        image.image = UIImage(systemName: "chevron.right")
        image.contentMode = .center
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [checkBoxButton, messageLabel, rightImage].forEach {
            self.totalView.addSubview($0)
        }
        self.contentView.addSubview(totalView)
    }
    
    override func setConstraints() {
        totalView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(20)
            make.height.equalTo(contentView.snp.height)
            make.trailing.equalTo(-20)
        }
        
        checkBoxButton.snp.makeConstraints { make in
            make.top.equalTo(self.totalView.snp.top)
            make.bottom.equalTo(self.totalView.snp.bottom)
            make.leading.equalTo(0)
            make.width.equalTo(self.checkBoxButton.snp.height)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(self.totalView.snp.top)
            make.bottom.equalTo(self.totalView.snp.bottom)
            make.leading.equalTo(checkBoxButton.snp.trailing).offset(0)
            make.trailing.equalTo(rightImage.snp.leading).offset(0)
        }
        
        rightImage.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.top)
            make.bottom.equalTo(messageLabel.snp.bottom)
            make.trailing.equalTo(totalView.snp.trailing)
            make.width.equalTo(rightImage.snp.height)
        }
    }
}
