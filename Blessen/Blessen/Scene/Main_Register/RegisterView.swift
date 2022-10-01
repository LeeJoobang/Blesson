import UIKit

class RegisterView: BaseView{
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = Constants.BaseColor.background
        return view
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(Constants.BaseColor.text, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [tableView, saveButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.saveButton.snp.bottom)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(0)
            make.height.width.equalTo(50)
        }
    }
}
