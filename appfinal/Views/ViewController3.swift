//
//  ViewController3.swift
//  appfinal
//
//  Created by Valeria Muñoz toro on 08-07-22.
//

import UIKit
import FirebaseRemoteConfig
import FirebaseFirestore

class ViewController3: UIViewController {
    
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    @IBOutlet weak var option5: UIButton!
    
    @IBOutlet weak var typeUserLabel: UILabel!
    @IBOutlet weak var nameLabelUser: UILabel!
    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var titleUser: UILabel!
    private var showName: String = ""
    private var showTitleUser: String = ""
    private var showWelcomeUser: String = ""
    @IBOutlet weak var imageData: UIImageView!
    let db = Firestore.firestore()
    let smu = UIImage(named: "logo-smu-5e55381e3427f")
    let bancoChile = UIImage(named: "descarga")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendImageview()
        let data = db.collection("users").document(Global.sharedInstance.user)
        data.getDocument { (document, error) in
            if let document = document, document.exists {
                if let name = document.data()?["userName"] as? String {
                    self.nameLabelUser.text = name
                }
                if let userType = document.data()?["userType"] as? String {
                    self.typeUserLabel.text = userType
                } else {
                    print("No se pudo obtener el nombre del usuario")
                }
            } else {
                print("El documento no existe")
            }
        }
        let holaa = Global.sharedInstance.user
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
            option1.backgroundColor = UIColor.red
            option2.backgroundColor = UIColor.red
            option3.backgroundColor = UIColor.red
            option4.backgroundColor = UIColor.red
            option5.backgroundColor = UIColor.red
        }
        if Global.sharedInstance.user.contains ("banco") {
            imageData.image = bancoChile
            option1.backgroundColor = UIColor.blue
            option2.backgroundColor = UIColor.blue
            option3.backgroundColor = UIColor.blue
            option4.backgroundColor = UIColor.blue
            option5.backgroundColor = UIColor.blue
        }
    }
    
    @IBAction func closeSessionbutton(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "home") as! ViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
    

}
