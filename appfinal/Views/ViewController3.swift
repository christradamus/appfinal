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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func closeSessionbutton(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "home") as! ViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
    

}
