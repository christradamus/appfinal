//
//  ViewController.swift
//  appfinal
//
//  Created by Valeria Muñoz toro on 04-07-22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    let auth = FirebaseAuth.Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var userLogin: UITextField!
    @IBOutlet weak var userPassword: UITextField!
        
    @IBAction func buttonHome(_ sender: Any) {
        Auth.auth().signIn(withEmail: userLogin.text!, password: userPassword.text!) { authResult, error in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message:
                                                            "Correo inválido o Cuenta no creada",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.goVCtest()
            }
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        let homeVc =
        self.storyboard?.instantiateViewController(withIdentifier: "segundointerfaz")
        as! secondViewcontrollerViewController
        self.navigationController?.pushViewController(homeVc, animated: true)
    }
    
    func goVCtest(){
        let home = self.storyboard?.instantiateViewController(withIdentifier: "capa3") as! ViewController3
        self.navigationController?.pushViewController(home, animated: true)
    }
}
