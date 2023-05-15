//
//  ViewController.swift
//  appfinal
//
//  Created by Valeria Muñoz toro on 04-07-22.
//

import UIKit
import FirebaseAuth
import FirebaseRemoteConfig
import FirebaseFirestore
import FirebaseCore
import FirebaseAnalytics

class ViewController: UIViewController {
    
    private let auth = FirebaseAuth.Auth.auth()
    let db = Firestore.firestore()
    private var failedAttempts = 0
    private var showTitle: String = ""
    private var showWelcome: String = ""
    private var fechaOk: String = ""
    var arrayUser = [String]()
    var arrayAdmin = [String]()
    let ERROR_USER_DISABLED_MESSAGE = "Su cuenta está bloqueada, contacte a un administrador"
    let ERROR_WRONG_PASSWORD_MESSAGE = "Usuario y/o Clave No válidos"
    let ERROR_TOO_MANY_REQUESTS_MESSAGE = "Su cuenta está bloqueada, contacte a un administrador"
    let ERROR_INVALID_EMAIL_MESSAGE = "Usuario y/o Clave No válidos"
    var arrayButtons = [String]()
    
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
        Global.sharedInstance.agregarInteraccion(usuario: "No ingresado", mensaje: "Inicio app", fecha: Global.sharedInstance.getDate(), tipoLog: "Info", modulo: "Pantalla inicio")
    }
    
    
    @IBAction func buttonHome(_ sender: Any) {
        Auth.auth().signIn(withEmail: userLogin.text!, password: userPassword.text!) { [self] authResult, error in
            if userLogin.text! == "" || userPassword.text! == "" {
                let alertController = UIAlertController(title: "Error", message: "Favor ingresar email y clave", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                self.present(alertController, animated: true, completion: nil)
                Global.sharedInstance.agregarInteraccion(usuario: "No ingresado", mensaje: "Error login", fecha: Global.sharedInstance.getDate(), tipoLog: "Error", modulo: "Pantalla inicio")
                return
            }
            let databaseInformation = db.collection("users").document(self.userLogin.text!)
            Global.sharedInstance.user = userLogin.text!
            Global.sharedInstance.userPassword = userPassword.text!
            if let error = error as NSError?, let userInfo = error.userInfo as NSDictionary?, let errorName = userInfo[AuthErrorUserInfoNameKey] as? String {
                var errorMessage: String
                switch errorName {
                case "ERROR_USER_DISABLED":
                    errorMessage = self.ERROR_USER_DISABLED_MESSAGE
                case "ERROR_WRONG_PASSWORD", "ERROR_INVALID_EMAIL":
                    errorMessage = self.ERROR_WRONG_PASSWORD_MESSAGE
                    failedAttempts += 1
                    if failedAttempts >= 3 {
                        errorMessage = self.ERROR_USER_DISABLED_MESSAGE
                        databaseInformation.updateData(["isActive": false
                                                       ])
                    }
                case "ERROR_TOO_MANY_REQUESTS":
                    errorMessage = self.ERROR_TOO_MANY_REQUESTS_MESSAGE
                case "ERROR_USER_NOT_FOUND":
                    errorMessage = self.ERROR_INVALID_EMAIL_MESSAGE
                default:
                    return
                }
                let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                self.present(alertController, animated: true, completion: nil)
                Global.sharedInstance.agregarInteraccion(usuario: "No ingresado", mensaje: errorMessage, fecha: Global.sharedInstance.getDate(), tipoLog: "Error", modulo: "Pantalla inicio")
            } else {
                let data = db.collection("users").document(Global.sharedInstance.user)
                data.getDocument { (document, error) in
                    if let document = document, document.exists {
                        if let userType = document.data()?["userType"] as? String {
                            Global.sharedInstance.userType = userType
                        }
                        if Global.sharedInstance.userType == "Administrador" {
                            Global.sharedInstance.arrayFinal = self.arrayAdmin
                        }
                        else {
                            Global.sharedInstance.arrayFinal = self.arrayUser
                        }
                        Global.sharedInstance.agregarInteraccion(usuario: Global.sharedInstance.user, mensaje: "Login Ok", fecha: Global.sharedInstance.getDate(), tipoLog: "Info", modulo: "Pantalla inicio")
                        self.goToTheMainHome()
                    }
                }
            }
        }
    }

    @IBAction func createAccount(_ sender: Any) {
        let homeVc =
        self.storyboard?.instantiateViewController(withIdentifier: "segundointerfaz")
        as! secondViewcontrollerViewController
        self.navigationController?.pushViewController(homeVc, animated: true)
        Global.sharedInstance.agregarInteraccion(usuario: "No ingresado", mensaje: "Ir a crear cuenta", fecha: Global.sharedInstance.getDate(), tipoLog: "Info", modulo: "Crear cuenta")
    }
    
    func goToTheMainHome(){
        let home = self.storyboard?.instantiateViewController(withIdentifier: "collection") as! CollectionViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    @IBAction func goToPasswordVC(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "password") as! PasswordViewController
        self.navigationController?.pushViewController(home, animated: true)
        Global.sharedInstance.agregarInteraccion(usuario: "No ingresado", mensaje: "Ir a recuperar clave", fecha: Global.sharedInstance.getDate(), tipoLog: "Info", modulo: "Reseteo password")
    }
}
