import UIKit

class BaseViewController: UIViewController { // final 키워드를 붙일 수 없다. 더이상 상속이 안되기 대문이다.

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }
    
    func configure() {}
    
    func setConstraints() {}

}

