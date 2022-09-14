import UIKit
import SnapKit

class RegisterTableViewCell: BaseTableViewCell {
    let totalView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.BaseColor.background
        return view
    }()
    
    let itemLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Constants.BaseColor.background
//        label.backgroundColor = .red
        label.textAlignment = .left
        label.font = UIFont(name: "Halvetica", size: 15)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    let itemTextField: UnderLineTextField = {
        let text = UnderLineTextField()
        text.backgroundColor = Constants.BaseColor.background
        text.textAlignment = .left
        text.textColor = .black
        return text
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 셀간 간격
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }
    
    override func configure() {
        [itemLabel, itemTextField].forEach {
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
        
        itemLabel.snp.makeConstraints { make in
            make.top.equalTo(self.totalView.snp.top)
            make.height.equalTo(self.totalView.snp.height).multipliedBy(0.4)
            make.leading.equalTo(self.totalView.snp.leading)
            make.width.equalTo(self.totalView.snp.width)
        }
        
        itemTextField.snp.makeConstraints { make in
            make.top.equalTo(itemLabel.snp.bottom)
            make.height.equalTo(self.totalView.snp.height).multipliedBy(0.6)
            make.leading.equalTo(self.totalView.snp.leading)
            make.width.equalTo(self.totalView.snp.width)
        }
    }
}
