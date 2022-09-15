import UIKit

class WriteView: BaseView{
    
    let writeTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = UIColor.black
        view.font = .systemFont(ofSize: 16)
        view.textColor = .white
        view.text = """
        동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이
                동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이
                동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이
                동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이
                동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이
                동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이
                동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이
        동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이
                동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이
                동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이
                동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이
                동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이
                동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이
                동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이동해물과 백두산이
        """
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        adjustUITextViewHeight(textView: writeTextView)
        [writeTextView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        writeTextView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension UIView: UITextFieldDelegate {
     func adjustUITextViewHeight(textView: UITextView){
         textView.translatesAutoresizingMaskIntoConstraints = true
         textView.isScrollEnabled = true
         textView.sizeToFit()
    }
}
