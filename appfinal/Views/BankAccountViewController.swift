//
//  BankAccountViewController.swift
//  appfinal
//
//  Created by christian perez  on 28-04-23.
//

import Foundation
import UIKit
import FirebaseRemoteConfig

class BankAccountViewController: UIViewController{
    
    private var totalMoneyLbl: Int = 0
    private var accountNumberString: String = ""
    let numberFormatter = NumberFormatter()
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var acountNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.locale = Locale(identifier: "es_CL")
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "CLP"
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 5
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = settings
        remoteConfig.fetchAndActivate { [self] (status,error) in
            if status != .error {
                self.totalMoneyLbl = remoteConfig.configValue(forKey: "totalMoney").numberValue.intValue
                self.accountNumberString = remoteConfig.configValue(forKey: "numeroCuenta").stringValue!
                let valorPeso = numberFormatter.string(from: NSNumber(value: totalMoneyLbl)) ?? ""
                self.totalMoney.text = valorPeso
                self.acountNumber.text = accountNumberString
                self.userName.text = Global.sharedInstance.name
            }
        }
    }
    
    @IBAction func bankButton(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "collection") as! CollectionViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    @IBAction func goToTheWebButton(_ sender: Any) {
        if let url = URL(string: "https://login.portal.bancochile.cl/bancochile-web/persona/login/index.html#/login") {
            UIApplication.shared.open(url)
        }
    }
    
    
}
