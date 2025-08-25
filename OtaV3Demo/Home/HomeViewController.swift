//
//  HomeViewController.swift
//  OtaV3Demo
//
//  Created by Sean on 2025/8/25.
//

import UIKit

class HomeViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction  func onOtaNorOfflineBtnTouch(_ sender: Any) {
        let vc = NorOfflineOTAMainVC.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction override func onOtaV3BtnTouch(_ sender: Any) {
        let vc = OTAV3MainVC.init(nibName: "OTAV3MainVC", bundle: Bundle.main)
        self.navigationController?.pushViewController(vc, animated: true)
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
