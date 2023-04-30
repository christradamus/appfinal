//
//  AddNewUserViewController.swift
//  appfinal
//
//  Created by christian perez  on 28-04-23.
//

import Foundation
import UIKit
import FirebaseFirestore

class AddNewUserViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var rut: UITextField!
    @IBOutlet weak var nac: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var cuenta: UITextField!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func validarString(_ string: String) -> Bool {
        let expresionRegular = "^[a-zA-Z]+$"
        if let validador = try? NSRegularExpression(pattern: expresionRegular) {
            let coincidencias = validador.matches(in: string, range: NSRange(string.startIndex..., in: string))
            return coincidencias.count > 0
        }
        return false
    }
    
    func validarFechaNacimiento(_ fecha: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        if let date = dateFormatter.date(from: fecha) {
            if dateFormatter.string(from: date) == fecha {
                return true
            }
        }
        return false
    }
    
    func validarRUT(_ rut: String) -> Bool {
        var rutSinDV = rut
        var digitoVerificador = ""
        if let indiceDV = rut.index(of: "-") {
            rutSinDV = String(rut[..<indiceDV])
            digitoVerificador = String(rut[indiceDV...])
        } else {
            return false
        }
        rutSinDV = rutSinDV.replacingOccurrences(of: ".", with: "")
        guard let numero = Int(rutSinDV) else {
            return false
        }
        var multiplicador = 2
        var suma = 0
        for digito in rutSinDV.reversed() {
            let valor = Int(String(digito)) ?? 0
            suma += valor * multiplicador
            multiplicador += 1
            if multiplicador > 7 {
                multiplicador = 2
            }
        }
        let resto = suma % 11
        let resultado = 11 - resto
        if resultado == 10 {
            return digitoVerificador.uppercased() == "K"
        } else if resultado == 11 {
            return digitoVerificador == "0"
        } else {
            return digitoVerificador == String(resultado)
        }
    }
    
    func validarCorreoElectronico(_ correo: String) -> Bool {
        let patronCorreo = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let regex = try! NSRegularExpression(pattern: patronCorreo)
        let rango = NSRange(location: 0, length: correo.utf16.count)
        return regex.firstMatch(in: correo, range: rango) != nil
    }

    
    @IBAction func newUser(_ sender: Any) {
        if let name = name.text , let rut = rut.text , let nac = nac.text ,let email = mail.text , let cuenta = cuenta.text {
            if name == "" || rut == "" || nac == "" || email == "" || cuenta == "" {
                let alertController = UIAlertController(title: "Error", message:
                                                            "Favor completar todos los campos",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            if validarString(name) {
                let alertController = UIAlertController(title: "Error", message:
                                                            "Ingrese un Nombre válido",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            if !validarFechaNacimiento(nac) {
                let alertController = UIAlertController(title: "Error", message:
                                                            "Ingrese una fecha de nacimiento en formato DD/MM/AA",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            if validarRUT(rut) {
                let alertController = UIAlertController(title: "Error", message:
                                                            "Ingrese su RUT sin puntos y Guión",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            if !validarCorreoElectronico(email) {
                let alertController = UIAlertController(title: "Error", message:
                                                            "Ingrese un mail válido",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.db.collection("clientes").document(rut).setData([
                "cuenta": self.cuenta.text!,
                "email": self.mail.text!,
                "fechaNac": self.nac.text!,
                "nombre": self.name.text!,
                "rut": self.rut.text!])
            let alertController = UIAlertController(title: "Usuario creado", message:
                                                        "Los datos han sido guardados exitosamente", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in self.backToMenu()}))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func backHomeBtn(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "collection") as! CollectionViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    func backToMenu(){
        let home = self.storyboard?.instantiateViewController(withIdentifier: "collection") as! CollectionViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
}
