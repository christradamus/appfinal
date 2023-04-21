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
                if let name = document.data()?["userName"] as? String { // Obtener el valor del campo "name"
                    self.nameLabelUser.text = name // Asignar el valor a la propiedad text de la etiqueta
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
                //self.nameUserLabel.text = Global.sharedInstance.userNameRegister
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
