import UIKit
import SnapKit

class DetailProgressCell: BaseTableViewCell {
    
    let totalView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.BaseColor.background
        return view
    }()
    
    let itemLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Constants.BaseColor.background
        label.textAlignment = .left
        label.font = UIFont(name: "Halvetica", size: 15)
        label.text = "레슨 진행"
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .bar)
        view.setProgress(0.3, animated: true)
        view.trackTintColor = UIColor.systemGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray6.cgColor
        view.tintColor = UIColor.blue
        return view
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.orange
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 50 / 2
        button.layer.masksToBounds = true
        button.tintColor = .systemGray6
        return button
    }()
    
    let minusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.orange
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .systemGray6
        button.layer.cornerRadius = 50 / 2
        button.layer.masksToBounds = true
        return button
    }()
    
    let messageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 50 / 2
        button.layer.masksToBounds = true
        button.backgroundColor = .systemGray6
        button.tintColor = .systemGreen
        return button
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        minusButton.layer.cornerRadius = minusButton.frame.width / 2
        messageButton.layer.cornerRadius = minusButton.frame.width / 2
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    override func configure() {
        [itemLabel, progressView, plusButton, minusButton, messageButton].forEach {
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
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(self.itemLabel.snp.bottom).offset(8)
            make.bottom.equalTo(self.totalView.snp.bottom).offset(-8)
            make.leading.equalTo(self.totalView.snp.leading)
            make.width.equalTo(self.totalView.snp.width).multipliedBy(0.6)
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.equalTo(self.itemLabel.snp.bottom).offset(8)
            make.bottom.equalTo(self.totalView.snp.bottom).offset(-8)
            make.leading.equalTo(self.progressView.snp.trailing).offset(10)
            make.width.equalTo(self.totalView.snp.width).multipliedBy(0.1)
        }
        
        minusButton.snp.makeConstraints { make in
            make.top.equalTo(self.itemLabel.snp.bottom).offset(8)
            make.bottom.equalTo(self.totalView.snp.bottom).offset(-8)
            make.leading.equalTo(self.plusButton.snp.trailing).offset(4)
            make.width.equalTo(self.totalView.snp.width).multipliedBy(0.1)
        }
        
        messageButton.snp.makeConstraints { make in
            make.top.equalTo(self.itemLabel.snp.bottom).offset(8)
            make.bottom.equalTo(self.totalView.snp.bottom).offset(-8)
            make.leading.equalTo(self.minusButton.snp.trailing).offset(8)
            make.trailing.equalTo(self.totalView.snp.trailing)
//            make.width.equalTo(self.totalView.snp.width).multipliedBy(0.2)
        }
    }
}
