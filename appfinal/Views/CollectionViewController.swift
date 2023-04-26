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

class CollectionViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var titleLbl: UILabel!
    let db = Firestore.firestore()
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userTypeLabel: UILabel!
    var tableViewData = [[String: Any]]()
    var stringsArray = [String]()
    var checkUserType: String = ""
    private var showTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        activityIndicator.frame.origin.y -= 90
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
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
                if self.checkUserType == "Administrador" && self.checkUserType != ""  {
                    let tableviewCollectionRef = self.db.collection("tableview")
                    tableviewCollectionRef.getDocuments() { (querySnapshot, error) in
                        if let error = error {
                            print("Error al obtener documentos: \(error)")
                        } else {
                            for document in querySnapshot!.documents {
                                let btn1 = document.data()["boton1"] as? String ?? ""
                                let btn2 = document.data()["boton2"] as? String ?? ""
                                let btn3 = document.data()["boton3"] as? String ?? ""
                                let btn4 = document.data()["boton4"] as? String ?? ""
                                let btn5 = document.data()["boton5"] as? String ?? ""
                                let data = ["boton1": btn1, "boton2": btn2, "boton3": btn3, "boton4": btn4, "boton5": btn5] as [String : Any]
                                self.stringsArray = [btn1,btn2,btn3,btn4,btn5]
                                self.tableViewData.append(data)
                            }
                        }
                    }
                } else if self.checkUserType == "Usuario" {
                    let tableviewCollectionRef2 = self.db.collection("tableview2")
                    tableviewCollectionRef2.getDocuments() { (querySnapshot, error) in
                        if let error = error {
                            print("Error al obtener documentos: \(error)")
                        } else {
                            for document in querySnapshot!.documents {
                                let boton1 = document.data()["boton1"] as? String ?? ""
                                let boton2 = document.data()["boton2"] as? String ?? ""
                                let boton3 = document.data()["boton3"] as? String ?? ""
                                let boton4 = document.data()["boton4"] as? String ?? ""
                                let boton5 = document.data()["boton5"] as? String ?? ""
                                let data2 = ["boton1": boton1, "boton2": boton2, "boton3": boton3, "boton4": boton4, "boton5": boton5] as [String : Any]
                                self.stringsArray = [boton1,boton2,boton3,boton4,boton5]
                                self.tableViewData.append(data2)
                            }
                        }
                    }
                }
                DispatchQueue.global(qos: .userInitiated).async {
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stringsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let nombre = stringsArray[indexPath.row]
        let attributedText = NSMutableAttributedString(string: nombre)
        attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(location: 0, length: nombre.count))
        cell.textLabel?.attributedText = attributedText
        cell.textLabel?.text = nombre
        cell.textLabel?.textColor = UIColor.black
        cell.backgroundColor = UIColor.systemYellow
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hola")
    }
    
    @IBAction func backHomeButton(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "home") as! ViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
}

    

