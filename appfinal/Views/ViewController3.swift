//
//  ViewController3.swift
//  appfinal
//
//  Created by Valeria Muñoz toro on 08-07-22.
//

import UIKit
import FirebaseRemoteConfig

class ViewController3: UIViewController {

    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var titleUser: UILabel!
    private var showTitleUser: String = ""
    private var showWelcomeUser: String = ""
    @IBOutlet weak var imageData: UIImageView!
    let smu = UIImage(named: "logo-smu-5e55381e3427f")
    let bancoChile = UIImage(named: "descarga")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendImageview()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 60
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = settings
        remoteConfig.fetchAndActivate { [self] (status,error) in
            if status != .error {
                self.showTitleUser = remoteConfig.configValue(forKey: "generic_name").stringValue!
                self.showWelcomeUser = remoteConfig.configValue(forKey: "welcome_string").stringValue!
                self.hiLabel.text = showWelcomeUser
                self.titleUser.text = showTitleUser
            }
        }
    }
    
    func sendImageview(){
        if Global.sharedInstance.user.contains ("smu") {
            imageData.image = smu
        }
        if Global.sharedInstance.user.contains ("banco") {
            imageData.image = bancoChile
        }
    }
    
    @IBAction func closeSessionbutton(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "home") as! ViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
    

}
