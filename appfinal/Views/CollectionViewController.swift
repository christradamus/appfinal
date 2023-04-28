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
    var arrayDataUser = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Global.sharedInstance.globalArray = arrayDataUser
        tableView.delegate = self
        tableView.dataSource = self
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 5
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(["generic_name": NSString("Tu Empresa")])
        remoteConfig.fetchAndActivate { [self] (status,error) in
            if status != .error {
                self.showTitle = remoteConfig.configValue(forKey: "generic_name").stringValue!
                self.titleLbl.text = showTitle
            }
        }
        let data = db.collection("users").document(Global.sharedInstance.user)
        data.getDocument { (document, error) in
            if let document = document, document.exists {
                if let name = document.data()?["userName"] as? String {
                    self.userNameLabel.text = name
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
    }
}

extension CollectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = adminArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hola")
    }
}

