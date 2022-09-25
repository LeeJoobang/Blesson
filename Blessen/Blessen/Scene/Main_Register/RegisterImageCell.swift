import UIKit
import SnapKit

class RegisterImageCell: BaseTableViewCell {
    
    let idImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemGray6
        image.layer.cornerRadius = 50 / 2
        image.layer.masksToBounds = true
        image.contentMode = .center
        return image
    }()
    
    let imageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.masksToBounds = true
        button.tintColor = .black
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 50/2
        button.contentMode = .center
        return button
    }()
    
    // MARK: 이미지 라운드 적용
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        idImageView.layer.cornerRadius = idImageView.frame.width / 2
        imageButton.layer.cornerRadius = imageButton.frame.width / 2
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        self.contentView.addSubview(idImageView)
        self.contentView.addSubview(imageButton)

    }
    
    override func setConstraints() {
        idImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(self.contentView).multipliedBy(0.2)
            make.height.equalTo(idImageView.snp.width)
        }
        
        imageButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.idImageView.snp.trailing).offset(-10)
            make.centerY.equalTo(self.idImageView.snp.bottom).offset(-10)
            make.width.equalTo(self.contentView).multipliedBy(0.07)
            make.height.equalTo(imageButton.snp.width)
        }
    }
}
