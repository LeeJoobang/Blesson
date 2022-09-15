import UIKit
import SnapKit

class RegisterImageCell: BaseTableViewCell {
    
    let idImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Test.png")!
        image.backgroundColor = .red
        image.layer.cornerRadius = 50 / 2
        image.layer.masksToBounds = true
        image.sizeToFit()
        return image
    }()
    
    // MARK: 이미지 라운드 적용
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        idImageView.layer.cornerRadius = idImageView.frame.width / 2
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
    }
    
    override func setConstraints() {
        
        idImageView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).multipliedBy(10)
            make.width.equalTo(self.contentView).multipliedBy(0.2)
            make.height.equalTo(idImageView.snp.width)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }
        
    }
}
