//
//  ViewController3.swift
//  appfinal
//
//  Created by Valeria Muñoz toro on 08-07-22.
//

import UIKit

class ViewController3: UIViewController {
    
    
    @IBAction func linkButton(_ sender: Any) {
        
        if let url = URL(string: "https://www.webpay.cl") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        let homeVc3 =
        self.storyboard?.instantiateViewController(withIdentifier: "segundointerfaz")
        as! secondViewcontrollerViewController
        self.navigationController?.pushViewController(homeVc3, animated: true)
    }
    
    
    @IBOutlet weak var total2: UILabel!
    
    @IBOutlet weak var cantidadFinalLbl: UILabel!
    
    var final = ""
    var cantidadFinal = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        total2.text = final
        cantidadFinalLbl.text = cantidadFinal
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
