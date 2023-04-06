//
//  ViewController.swift
//  appfinal
//
//  Created by Valeria Muñoz toro on 04-07-22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createAccount(_ sender: Any) {
        let homeVc =
        self.storyboard?.instantiateViewController(withIdentifier: "segundointerfaz")
        as! secondViewcontrollerViewController
        self.navigationController?.pushViewController(homeVc, animated: true)
    }
    
    @IBOutlet weak var userLogin: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    func goVCtest(){
        let home = self.storyboard?.instantiateViewController(withIdentifier: "capa3") as! ViewController3
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    @IBAction func buttonHome(_ sender: Any) {
        Auth.auth().signIn(withEmail: userLogin.text!, password: userPassword.text!) { (user, error) in
            self.goVCtest()
            
            /* if let email = userLogin.text , let password = userPassword.text {
             Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
             guard let strongSelf = self else { return }
             }
             }*/
        }
    }
}
