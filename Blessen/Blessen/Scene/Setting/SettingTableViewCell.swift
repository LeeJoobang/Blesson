import UIKit
import SnapKit

class SettingViewTableCell: BaseTableViewCell {
    let totalView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.BaseColor.background
        return view
    }()
    
    let leftImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.tintColor = Constants.BaseColor.text
        image.contentMode = .center
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        
        label.textAlignment = .center
        label.font = UIFont(name: "Halvetica", size: 15)
        
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    let rightImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
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
        [leftImage, nameLabel, rightImage].forEach {
            self.totalView.addSubview($0)
        }
        self.contentView.addSubview(totalView)
    }
    
    func setData(data: String, image: String){
        nameLabel.text = data
        leftImage.image = UIImage(systemName: image)
    }
    
    override func setConstraints() {
        totalView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(20)
            make.height.equalTo(contentView.snp.height)
            make.trailing.equalTo(-40)
        }
        
        leftImage.snp.makeConstraints { make in
            make.top.equalTo(self.totalView.snp.top)
            make.bottom.equalTo(self.totalView.snp.bottom)
            make.leading.equalTo(0)
            make.width.equalTo(self.leftImage.snp.height)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.totalView.snp.top)
            make.bottom.equalTo(self.totalView.snp.bottom)
            make.leading.equalTo(leftImage.snp.trailing).offset(10)
        }
        
        rightImage.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.top)
            make.bottom.equalTo(nameLabel.snp.bottom)
            make.trailing.equalTo(totalView.snp.trailing).offset(20)
            make.width.equalTo(rightImage.snp.height)
        }
    }
}
