import UIKit
import SnapKit

class SettingViewTableCell: BaseTableViewCell {
    let totalView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
        
    let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .orange
        label.tintColor = .white
        label.textAlignment = .center

        label.font = UIFont(name: "Halvetica", size: 15)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    let detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.backgroundColor = .orange
        button.tintColor = .systemBlue
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
        [nameLabel, detailButton].forEach {
            self.totalView.addSubview($0)
        }
        self.contentView.addSubview(totalView)
    }
    
    func setData(data: String){
        nameLabel.text = data
    }
    
    override func setConstraints() {
        totalView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(20)
            make.height.equalTo(contentView.snp.height)
            make.trailing.equalTo(-40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.totalView.snp.top)
            make.bottom.equalTo(self.totalView.snp.bottom)
            make.leading.equalTo(0)
        }
        
        detailButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.top)
            make.bottom.equalTo(nameLabel.snp.bottom)
            make.trailing.equalTo(totalView.snp.trailing).offset(20)
            make.width.equalTo(detailButton.snp.height)
        }
        
    }
}
