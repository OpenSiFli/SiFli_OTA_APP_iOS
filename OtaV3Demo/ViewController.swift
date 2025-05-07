//
//  ViewController.swift
//  OtaV3Demo
//
//  Created by Sean on 2025/1/13.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onOtaV3BtnTouch(_ sender: Any) {
        let vc = OTAV3MainVC.init(nibName: "OTAV3MainVC", bundle: Bundle.main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

