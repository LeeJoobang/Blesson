import UIKit

class BaseViewController: UIViewController { // final 키워드를 붙일 수 없다. 더이상 상속이 안되기 대문이다.

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }
    
    func configure() {}
    
    func setConstraints() {}
    
    func showAlertMessage(title: String, button: String = "확인") { // 매개변수 기본값
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
        
    }

}

