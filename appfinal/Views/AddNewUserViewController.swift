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
        Global.sharedInstance.agregarInteraccion(usuario: Global.sharedInstance.user, mensaje: "Ingreso ok al menú de agregar nuevo usuario", fecha: Global.sharedInstance.getDate(), tipoLog: "Info", modulo: "Agregar nuevo usuario")
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
    
    func validarRut(_ rut: String) -> Bool {
        let rutRegex = #"^\d{1,2}\.\d{3}\.\d{3}-[\dKk]{1}$"#
        let rutPredicate = NSPredicate(format: "SELF MATCHES %@", rutRegex)
        return rutPredicate.evaluate(with: rut)
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
                Global.sharedInstance.agregarInteraccion(usuario: Global.sharedInstance.user, mensaje: "Error con registro", fecha: Global.sharedInstance.getDate(), tipoLog: "Error", modulo: "Agregar nuevo usuario")
                return
            }
            if validarString(name) {
                let alertController = UIAlertController(title: "Error", message:
                                                            "Ingrese un Nombre válido",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                self.present(alertController, animated: true, completion: nil)
                Global.sharedInstance.agregarInteraccion(usuario: Global.sharedInstance.user, mensaje: "Error con registro", fecha: Global.sharedInstance.getDate(), tipoLog: "Error", modulo: "Agregar nuevo usuario")
                return
            }
            if !validarFechaNacimiento(nac) {
                let alertController = UIAlertController(title: "Error", message:
                                                            "Ingrese una fecha de nacimiento en formato DD/MM/AA",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                self.present(alertController, animated: true, completion: nil)
                Global.sharedInstance.agregarInteraccion(usuario: Global.sharedInstance.user, mensaje: "Error con registro", fecha: Global.sharedInstance.getDate(), tipoLog: "Error", modulo: "Agregar nuevo usuario")
                return
            }
            if !validarRut(rut) {
                let alertController = UIAlertController(title: "Error", message:
                                                            "Ingrese su RUT con puntos y Guión",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                self.present(alertController, animated: true, completion: nil)
                Global.sharedInstance.agregarInteraccion(usuario: Global.sharedInstance.user, mensaje: "Error con registro", fecha: Global.sharedInstance.getDate(), tipoLog: "Error", modulo: "Agregar nuevo usuario")
                return
            }
            if !validarCorreoElectronico(email) {
                let alertController = UIAlertController(title: "Error", message:
                                                            "Ingrese un mail válido",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Volver", style: .default))
                self.present(alertController, animated: true, completion: nil)
                Global.sharedInstance.agregarInteraccion(usuario: Global.sharedInstance.user, mensaje: "Error con registro", fecha: Global.sharedInstance.getDate(), tipoLog: "Error", modulo: "Agregar nuevo usuario")
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
            Global.sharedInstance.agregarInteraccion(usuario: Global.sharedInstance.user, mensaje: "Registro ok de nuevo usuario", fecha: Global.sharedInstance.getDate(), tipoLog: "Info", modulo: "Agregar nuevo usuario")
        }
    }
    
    @IBAction func backHomeBtn(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "collection") as! CollectionViewController
        self.navigationController?.pushViewController(home, animated: true)
        Global.sharedInstance.agregarInteraccion(usuario: Global.sharedInstance.user, mensaje: "Volver al menú principal", fecha: Global.sharedInstance.getDate(), tipoLog: "Info", modulo: "Agregar nuevo usuario")
    }
    
    func backToMenu(){
        let home = self.storyboard?.instantiateViewController(withIdentifier: "collection") as! CollectionViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
}
