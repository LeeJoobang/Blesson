import Foundation
import UIKit

class BaseTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.tabBar.tintColor = Constants.BaseColor.background
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.selectedImageTintColor = .black
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        
        let mainVC = UINavigationController(rootViewController: MainViewController())
        mainVC.tabBarItem.selectedImage = UIImage(systemName: "person.crop.rectangle.fill")
        mainVC.tabBarItem.title = "Stundent"
        mainVC.tabBarItem.image = UIImage(systemName: "person.crop.rectangle")
        
        let calendarVC = UINavigationController(rootViewController: CalendarViewController())
        calendarVC.tabBarItem.selectedImage = UIImage(systemName: "calendar.circle.fill")
        calendarVC.tabBarItem.title = "Calendar"
        calendarVC.tabBarItem.image = UIImage(systemName: "calendar.circle")
        
        let settingVC = UINavigationController(rootViewController: SettingViewController())
        settingVC.tabBarItem.selectedImage = UIImage(systemName: "gearshape.fill")
        settingVC.tabBarItem.title = "Setting"
        settingVC.tabBarItem.image = UIImage(systemName: "gearshape")
        
        viewControllers = [mainVC, calendarVC, settingVC]
    }

}
