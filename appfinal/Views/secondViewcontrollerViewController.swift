//
//  secondViewcontrollerViewController.swift
//  appfinal
//
//  Created by Valeria Muñoz toro on 04-07-22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class secondViewcontrollerViewController: UIViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    let db = Firestore.firestore()
    var nameUser : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func backToHome(){
        let home = self.storyboard?.instantiateViewController(withIdentifier: "home") as! ViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    @IBAction func backHome(_ sender: Any) {
        backToHome()
    }
    
    
    
    func transformPassword(_ password: String) -> String {
        let charactersToReplace = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let replacementCharacters = "1234567890!@#$%^&*()-_=+[{]}\\|;:'\",<.>/?`~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var transformedPassword = password
        
        for i in 0..<charactersToReplace.count {
            let index = charactersToReplace.index(charactersToReplace.startIndex, offsetBy: i)
            let character = charactersToReplace[index]
            let randomIndex = Int.random(in: 0..<replacementCharacters.count)
            let replacementIndex = replacementCharacters.index(replacementCharacters.startIndex, offsetBy: randomIndex)
            let replacementCharacter = replacementCharacters[replacementIndex]
            
            transformedPassword = transformedPassword.replacingOccurrences(of: String(character), with: String(replacementCharacter))
        }
        return transformedPassword
    }
    
    @IBAction func registerActionButton(_ sender: Any) {
        if let email = emailTextField.text , let password = passwordTextField.text ,let userName = userNameField.text{
            Auth.auth().createUser(withEmail: email, password: password) {
                (result, error) in
                if let result = result , error == nil {
                    let transformedPassword = self.transformPassword(self.passwordTextField.text!)
                    self.db.collection("users").document(email).setData([
                        "email": self.emailTextField.text!,
                        "password": transformedPassword,
                        "isActive": true,
                        "userName": self.userNameField.text!])
                    Global.sharedInstance.user = email
                    Global.sharedInstance.userPassword = password
                    Global.sharedInstance.userNameRegister = userName
                    let alertController = UIAlertController(title: "Usuario creado", message:
                                                                "Tus datos han sido guardados exitosamente", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in self.backToHome()}))
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message:
                                                                "Se ha producido un error con el registo",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
        
