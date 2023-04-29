//
//  BankAccountViewController.swift
//  appfinal
//
//  Created by christian perez  on 28-04-23.
//

import Foundation
import UIKit

class BankAccountViewController: UIViewController{
    
    @IBAction func bankButton(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "collection") as! CollectionViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
