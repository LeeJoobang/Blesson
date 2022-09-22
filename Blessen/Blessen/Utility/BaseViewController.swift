import UIKit

class BaseViewController: UIViewController { // final 키워드를 붙일 수 없다. 더이상 상속이 안되기 대문이다.

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }
    
    func configure() {}
    
    func setConstraints() {}
    
    func showAlertMessage(title: String, message: String, ok: String = "확인", cancel: String = "취소") { // 매개변수 기본값
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: ok, style: .default) 
        let cancel = UIAlertAction(title: cancel, style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }

}

