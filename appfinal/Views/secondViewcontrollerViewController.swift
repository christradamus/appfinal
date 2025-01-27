//
//  secondViewcontrollerViewController.swift
//  appfinal
//
//  Created by Valeria Muñoz toro on 04-07-22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class secondViewcontrollerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeUserText.text = options[row]
    }
    
    @IBOutlet weak var typeUserText: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    let db = Firestore.firestore()
    var nameUser : String = ""
    let options = ["Administrador", "Usuario"]
    
    @objc func doneButtonTapped() {
        typeUserText.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        typeUserText.center = view.center
        typeUserText.borderStyle = .none
        typeUserText.backgroundColor = .clear
        typeUserText.tintColor = .clear
        typeUserText.autocorrectionType = .no
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        typeUserText.inputView = pickerView
    }
    
    func backToHome(){
        let home = self.storyboard?.instantiateViewController(withIdentifier: "home") as! ViewController
        self.navigationController?.pushViewController(home, animated: true)
        Global.sharedInstance.agregarInteraccion(usuario: "No ingresado", mensaje: "Volver al inicio", fecha: Global.sharedInstance.getDate(), tipoLog: "Info", modulo: "Crear cuenta")
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
    
    func validarString(_ string: String) -> Bool {
        let expresionRegular = "^[a-zA-Z]+$"
        if let validador = try? NSRegularExpression(pattern: expresionRegular) {
            let coincidencias = validador.matches(in: string, range: NSRange(string.startIndex..., in: string))
            return coincidencias.count > 0
        }
        return false
    }
    
    @IBAction func registerActionButton(_ sender: Any) {
        if let email = emailTextField.text , let password = passwordTextField.text ,let userName = userNameField.text,
        let userType = typeUserText.text {
            if userType == "" || email == "" || password == "" || userName == "" {
                let alertController = UIAlertController(title: "Error", message:
                                                            "Favor completar todos los campos",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                self.present(alertController, animated: true, completion: nil)
                Global.sharedInstance.agregarInteraccion(usuario: "No ingresado", mensaje: "Problemas con registro", fecha: Global.sharedInstance.getDate(), tipoLog: "Warning", modulo: "Crear cuenta")
                return
            }
            if !validarString(userName) {
                let alertController = UIAlertController(title: "Error", message:
                                                            "Ingrese un Nombre válido",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                self.present(alertController, animated: true, completion: nil)
                Global.sharedInstance.agregarInteraccion(usuario: "No ingresado", mensaje: "Problemas con registro", fecha: Global.sharedInstance.getDate(), tipoLog: "Warning", modulo: "Crear cuenta")
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) {
                (result, error) in
                if let result = result , error == nil {
                    let transformedPassword = self.transformPassword(self.passwordTextField.text!)
                    self.db.collection("users").document(email).setData([
                        "email": self.emailTextField.text!,
                        "password": transformedPassword,
                        "isActive": true,
                        "userName": self.userNameField.text!,
                        "userType": self.typeUserText.text!])
                    Global.sharedInstance.user = email
                    Global.sharedInstance.userPassword = password
                    Global.sharedInstance.userNameRegister = userName
                    Global.sharedInstance.userType = userType
                    let alertController = UIAlertController(title: "Usuario creado", message:
                                                                "Tus datos han sido guardados exitosamente", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in self.backToHome()}))
                    self.present(alertController, animated: true, completion: nil)
                    Global.sharedInstance.agregarInteraccion(usuario: Global.sharedInstance.user , mensaje: "Registro Ok", fecha: Global.sharedInstance.getDate(), tipoLog: "Info", modulo: "Crear cuenta")
                } else {
                    let alertController = UIAlertController(title: "Error", message:
                                                                "Se ha producido un error con el registro",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                    Global.sharedInstance.agregarInteraccion(usuario: "No ingresado", mensaje: "Problemas con registro", fecha: Global.sharedInstance.getDate(), tipoLog: "Warning", modulo: "Crear cuenta")
                }
            }
        }
    }
}
        
