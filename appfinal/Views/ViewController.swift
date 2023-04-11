//
//  ViewController.swift
//  appfinal
//
//  Created by Valeria Muñoz toro on 04-07-22.
//

import UIKit
import FirebaseAuth
import FirebaseRemoteConfig

class ViewController: UIViewController {
    
    private let auth = FirebaseAuth.Auth.auth()
    private var failedAttempts = 0
    private var showTitle: String = ""
    private var showWelcome: String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLogin: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 5
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(["welcome_string" : NSString("Bienvenido"),
                                  "generic_name": NSString("Tu Empresa")])
        remoteConfig.fetchAndActivate { [self] (status,error) in
            if status != .error {
                self.showTitle = remoteConfig.configValue(forKey: "generic_name").stringValue!
                self.showWelcome = remoteConfig.configValue(forKey: "welcome_string").stringValue!
                self.titleLabel.text = showTitle
            }
        }
    }
    
    @IBAction func buttonHome(_ sender: Any) {
        Auth.auth().signIn(withEmail: userLogin.text!, password: userPassword.text!) { authResult, error in
            if error != nil {
                if let error = error as NSError?, let userInfo = error.userInfo as NSDictionary?,
                   let errorName = userInfo[AuthErrorUserInfoNameKey] as? String, errorName == "ERROR_USER_DISABLED" {
                    let alertController = UIAlertController(title: "Cuenta Bloqueada", message:
                                                                "Su cuenta está bloqueada, contacte a un administrador",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
                if let error = error as NSError?, let userInfo = error.userInfo as NSDictionary?,
                   let errorName = userInfo[AuthErrorUserInfoNameKey] as? String, errorName == "ERROR_WRONG_PASSWORD" {
                    let alertController = UIAlertController(title: "Error", message:
                                                                "Usuario y/o Clave No válidos",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
                if let error = error as NSError?, let userInfo = error.userInfo as NSDictionary?,
                   let errorName = userInfo[AuthErrorUserInfoNameKey] as? String, errorName == "ERROR_TOO_MANY_REQUESTS" {
                    let alertController = UIAlertController(title: "Cuenta Bloqueada", message:
                                                                "Su cuenta está bloqueada, contacte a un administrador",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
                if let error = error as NSError?, let userInfo = error.userInfo as NSDictionary?,
                   let errorName = userInfo[AuthErrorUserInfoNameKey] as? String, errorName == "ERROR_INVALID_EMAIL" {
                    let alertController = UIAlertController(title: "Error", message:
                                                                "Usuario y/o Clave No válidos",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    self.goToTheMainHome()
                }
            }
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        let homeVc =
        self.storyboard?.instantiateViewController(withIdentifier: "segundointerfaz")
        as! secondViewcontrollerViewController
        self.navigationController?.pushViewController(homeVc, animated: true)
    }
    
    func goToTheMainHome(){
        let home = self.storyboard?.instantiateViewController(withIdentifier: "capa3") as! ViewController3
        self.navigationController?.pushViewController(home, animated: true)
    }
}
