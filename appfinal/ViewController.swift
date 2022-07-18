//
//  ViewController.swift
//  appfinal
//
//  Created by Valeria Muñoz toro on 04-07-22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func IngresarButton(_ sender: Any) {

    if txtUserName.text == "" {
        let mensajeAlert = UIAlertController(title: "Sin Informacion", message: "Campos Vacios", preferredStyle: .alert )
        mensajeAlert.addAction(UIAlertAction(title: "Reintentar", style: .destructive, handler: nil))
        self.present(mensajeAlert,animated: true,completion: nil)
        
    }
        else if txtUserName.text == "aperez" && txtPassword.text == "1234" {
            
            let homeVc =
            self.storyboard?.instantiateViewController(withIdentifier: "segundointerfaz")
            as! secondViewcontrollerViewController
            self.navigationController?.pushViewController(homeVc, animated: true)
            
            
        }
        else if txtUserName.text != "aperez" || txtPassword.text != "1234" {
            let mensajeAlert = UIAlertController(title: "Error de Ingreso", message: "Usuario o Clave No válidos", preferredStyle: .alert )
            mensajeAlert.addAction(UIAlertAction(title: "Reintentar", style: .destructive, handler: nil))
            self.present(mensajeAlert,animated: true,completion: nil)
        }
            
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
}

