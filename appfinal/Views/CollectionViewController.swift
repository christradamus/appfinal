//
//  TableViewController.swift
//  appfinal
//
//  Created by christian perez  on 21-04-23.
//

import Foundation
import UIKit
import FirebaseRemoteConfig
import FirebaseFirestore

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    let adminArray = ["prueba 10","prueba 20","prueba 30","prueba 40","prueba 50"]
    let userArray = ["prueba 1","prueba 2","prueba 3","prueba 4","prueba 5"]
    let db = Firestore.firestore()
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    var checkUserType: String = ""
    private var showTitle: String = ""
    private var boton1User: String = ""
    private var boton2User: String = ""
    private var boton3User: String = ""
    private var boton4User: String = ""
    private var boton5User: String = ""
    private var boton1Admin: String = ""
    private var boton2Admin: String = ""
    private var boton3Admin: String = ""
    private var boton4Admin: String = ""
    private var boton5Admin: String = ""
    var arrayDataUser = [String]()
    var arrayUser = [String]()
    var arrayAdmin = [String]()
    
    override func viewDidLoad() {
        Global.sharedInstance.agregarInteraccion(usuario: Global.sharedInstance.user, mensaje: "Ingreso Ok al menú", fecha: Global.sharedInstance.getDate(), tipoLog: "Info", modulo: "Menú principal")
        super.viewDidLoad()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 5
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(["generic_name": NSString("Tu Empresa")])
        remoteConfig.fetchAndActivate { [self] (status,error) in
            if status != .error {
                self.showTitle = remoteConfig.configValue(forKey: "generic_name").stringValue!
                self.boton1Admin = remoteConfig.configValue(forKey: "boton1Admin").stringValue!
                self.boton2Admin = remoteConfig.configValue(forKey: "boton2Admin").stringValue!
                self.boton3Admin = remoteConfig.configValue(forKey: "boton3Admin").stringValue!
                self.boton4Admin = remoteConfig.configValue(forKey: "boton4Admin").stringValue!
                self.boton5Admin = remoteConfig.configValue(forKey: "boton5Admin").stringValue!
                self.boton1User = remoteConfig.configValue(forKey: "boton1User").stringValue!
                self.boton2User = remoteConfig.configValue(forKey: "boton2User").stringValue!
                self.boton3User = remoteConfig.configValue(forKey: "boton3User").stringValue!
                self.boton4User = remoteConfig.configValue(forKey: "boton4User").stringValue!
                self.boton5User = remoteConfig.configValue(forKey: "boton5User").stringValue!
                self.arrayUser = [boton1User,boton2User,boton3User,boton4User,boton5User]
                self.arrayAdmin = [boton1Admin,boton2Admin,boton3Admin,boton4Admin,boton5Admin]
                self.titleLbl.text = showTitle
                tableView.delegate = self
                tableView.dataSource = self
            }
        }
        let data = db.collection("users").document(Global.sharedInstance.user)
        data.getDocument { (document, error) in
            if let document = document, document.exists {
                if let name = document.data()?["userName"] as? String {
                    self.userNameLabel.text = name
                    Global.sharedInstance.name = name
                }
                if let userType = document.data()?["userType"] as? String {
                    self.userTypeLabel.text = userType
                    self.checkUserType = userType
                } else {
                    print("No se pudo obtener el nombre del usuario")
                }
            }
        }
    }
    @IBAction func backHomeButton(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "home") as! ViewController
        self.navigationController?.pushViewController(home, animated: true)
        Global.sharedInstance.agregarInteraccion(usuario: Global.sharedInstance.user, mensaje: "Volver al inicio", fecha: Global.sharedInstance.getDate(), tipoLog: "Info", modulo: "Menú principal")
    }
}

extension CollectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if Global.sharedInstance.userType == "Administrador" {
            print(arrayAdmin)
            cell.textLabel?.text = arrayAdmin[indexPath.row]
        } else {
            cell.textLabel?.text = arrayUser[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Global.sharedInstance.userType == "Administrador" {
            let homeVc =
            self.storyboard?.instantiateViewController(withIdentifier: "addnewuser")
            as! AddNewUserViewController
            self.navigationController?.pushViewController(homeVc, animated: true)
            Global.sharedInstance.agregarInteraccion(usuario: Global.sharedInstance.user, mensaje: "Agregar nuevo usuario", fecha: Global.sharedInstance.getDate(), tipoLog: "Info", modulo: "Menú principal")
        } else {
            let homeVc =
            self.storyboard?.instantiateViewController(withIdentifier: "bank")
            as! BankAccountViewController
            self.navigationController?.pushViewController(homeVc, animated: true)
            Global.sharedInstance.agregarInteraccion(usuario: Global.sharedInstance.user, mensaje: "Ver cuenta bancaria", fecha: Global.sharedInstance.getDate(), tipoLog: "Info", modulo: "Menú principal")
        }
    }
}

