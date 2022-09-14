import UIKit
import SnapKit

class RegisterImageCell: BaseTableViewCell {
    
    let idImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Test.png")!
        image.sizeToFit()
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
        self.contentView.addSubview(idImageView)
    }
    
    override func setConstraints() {
        
        idImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(20)
            make.height.equalTo(contentView.snp.height)
            make.trailing.equalTo(-20)
        }
        
    }
}
