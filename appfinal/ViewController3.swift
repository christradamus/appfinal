//
//  ViewController3.swift
//  appfinal
//
//  Created by Valeria Muñoz toro on 08-07-22.
//

import UIKit

class ViewController3: UIViewController {

    @IBAction func closeSessionbutton(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "home") as! ViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
