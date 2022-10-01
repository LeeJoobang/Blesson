import UIKit
import SnapKit

// MARK: underline을 갖는 텍스트 뷰, 사용하지 않음.
class UnderLineTextField: UITextField {

    private lazy var underLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(underLineView)
        
        underLineView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
