//
//  secondViewcontrollerViewController.swift
//  appfinal
//
//  Created by Valeria Muñoz toro on 04-07-22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CryptoKit

class secondViewcontrollerViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    let db = Firestore.firestore()
    
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
        let characterMap: [Character: Character] = [
            "a": "1", "b": "2", "c": "3", "d": "4", "e": "5", "f": "6", "g": "7", "h": "8", "i": "9", "j": "0",
            "k": "!", "l": "@", "m": "#", "n": "$", "o": "%", "p": "^", "q": "&", "r": "*", "s": "(", "t": ")",
            "u": "-", "v": "+", "w": "=", "x": "{", "y": "}", "z": "[", "A": "]", "B": ":", "C": ";", "D": "<",
            "E": ">", "F": "?", "G": "/", "H": "|", "I": "\\", "J": "\"", "K": ".", "L": ",", "M": "`", "N": "~",
            "O": "a", "P": "b", "Q": "c", "R": "d", "S": "e", "T": "f", "U": "g", "V": "h", "W": "i", "X": "j",
            "Y": "k", "Z": "l", "0": "m", "1": "n", "2": "o", "3": "p", "4": "q", "5": "r", "6": "s", "7": "t",
            "8": "u", "9": "v", "@": "w", "#": "x", "$": "y", "%": "z", "^": "A", "&": "B", "*": "C", "(": "D",
            ")": "E", "-": "F", "+": "G", "=": "H", "{": "I", "}": "J", "[": "K", "]": "L", ":": "M", ";": "N",
            "<": "O", ">": "P", "?": "Q", "/": "R", "|": "S", "\\": "T", "\"": "U", ".": "V", ",": "W", "`": "X",
            "~": "Y", " ": "Z"
        ]
        let transformedPassword = String(password.map { characterMap[$0] ?? $0 })
        return transformedPassword
    }
    
    /*func transformPassword(_ password: String) -> String {
        let charactersToReplace = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let replacementCharacters = "1234567890!@#$%^&*()-_=+[{]}\\|;:'\",<.>/?`~"
        var transformedPassword = password
        
        for i in 0..<charactersToReplace.count {
            let index = charactersToReplace.index(charactersToReplace.startIndex, offsetBy: i)
            let character = charactersToReplace[index]
            let replacementIndex = replacementCharacters.index(replacementCharacters.startIndex, offsetBy: i)
            let replacementCharacter = replacementCharacters[replacementIndex]
            
            transformedPassword = transformedPassword.replacingOccurrences(of: String(character), with: String(replacementCharacter))
        }
        return transformedPassword
    }*/
    
    @IBAction func registerActionButton(_ sender: Any) {
        if let email = emailTextField.text , let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) {
                (result, error) in
                if let result = result , error == nil {
                    let transformedPassword = self.transformPassword(self.passwordTextField.text!)
                    self.db.collection("users").document(email).setData([
                        "email": self.emailTextField.text!,
                        "password": transformedPassword,
                        "isActive": true])
                    Global.sharedInstance.user = email
                    Global.sharedInstance.userPassword = password
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
        
