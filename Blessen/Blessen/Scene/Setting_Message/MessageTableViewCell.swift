import UIKit
import SnapKit

class MessageViewTableCell: BaseTableViewCell {
    let totalView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.BaseColor.background
        view.backgroundColor = .orange
        return view
    }()
    
    let checkBoxButton: UIButton = {
        let check = UIButton()
        check.backgroundColor = .systemGray3
        check.tintColor = .black
        return check
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Constants.BaseColor.background
        label.textAlignment = .center
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
        [checkBoxButton, nameLabel, rightImage].forEach {
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
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.totalView.snp.top)
            make.bottom.equalTo(self.totalView.snp.bottom)
            make.leading.equalTo(checkBoxButton.snp.trailing).offset(10)
        }
        
        rightImage.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.top)
            make.bottom.equalTo(nameLabel.snp.bottom)
            make.trailing.equalTo(totalView.snp.trailing).offset(20)
            make.width.equalTo(rightImage.snp.height)
        }
    }
}
