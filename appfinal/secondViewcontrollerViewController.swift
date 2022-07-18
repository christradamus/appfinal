//
//  secondViewcontrollerViewController.swift
//  appfinal
//
//  Created by Valeria Muñoz toro on 04-07-22.
//

import UIKit

class secondViewcontrollerViewController: UIViewController {
    
    @IBOutlet weak var cantidadTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func calcularTotalButton(_ sender: Any) {
        
        let cantidad = Int(cantidadTextField.text!) ?? 0
        
        
        if cantidadTextField.text == "" {
            let mensajeAlert = UIAlertController(title: "Sin Informacion", message: "Campos Vacios", preferredStyle: .alert )
            mensajeAlert.addAction(UIAlertAction(title: "Atras", style: .destructive, handler: nil))
            
            self.present(mensajeAlert,animated: true,completion: nil)
            
        }
        if cantidad >= 1 {
            let valorCasa = 129990
            
            let cantidadExtra = cantidad
            let cantidadExtraString = String(cantidadExtra)
            
            let totalCompra = valorCasa * cantidad
            let totalCompraString = String(totalCompra)
            
            let vista3 = storyboard?.instantiateViewController(identifier: "capa3") as? ViewController3
            vista3?.final = totalCompraString
            vista3?.cantidadFinal = cantidadExtraString
            
            self.navigationController?.pushViewController(vista3!, animated: true)
            
            }
        
            else  {
                let mensajeAlert = UIAlertController(title: "Datos Incorrectos", message: "Ingrese un Numero Valido", preferredStyle: .alert )
                mensajeAlert.addAction(UIAlertAction(title: "Atras", style: .destructive, handler: nil))

                self.present(mensajeAlert,animated: true,completion: nil)
        }
        
        }
        }
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    
