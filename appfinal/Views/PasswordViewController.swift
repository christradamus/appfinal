//
//  PasswordViewController.swift
//  appfinal
//
//  Created by christian perez  on 11-04-23.
//

import UIKit
import FirebaseAuth
import FirebaseRemoteConfig

class PasswordViewController: UIViewController {
    
    @IBOutlet weak var emailRecover: UITextField!
    
    @IBAction func recoverButton(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailRecover.text!) { error in
            if error == nil {
                let alertController = UIAlertController(title: "Recuperación de clave", message:
                                                            "Hemos enviado un mail con instrucciones para recuperar tu contraseña", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in self.backToHome()}))
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message:
                                                            "Correo no Válido, Vuelva a ingresar su mail",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backToTheHome(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "home") as! ViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    func backToHome(){
        let home = self.storyboard?.instantiateViewController(withIdentifier: "home") as! ViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
    
}
