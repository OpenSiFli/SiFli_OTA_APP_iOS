//
//  AppDelegate.swift
//  OtaV3Demo
//
//  Created by Sean on 2025/1/13.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let firstVC = HomeViewController.init(nibName: "HomeViewController", bundle: Bundle.main)
        let navVC = UINavigationController.init(rootViewController: firstVC)
        navVC.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NSLog("文件地址:\(url)")
                
        do{
            let file = try Data.init(contentsOf: url)
            let fileName = url.lastPathComponent
            
            let dialplateAction = UIAlertAction.init(title: "表盘文件", style: .default) { action in
                let dialPlateFolderPath = FolderHelper.DialPlateFolderPath()
                self.trySaveFile(targetFolderPath: dialPlateFolderPath, defaultFileName: fileName, file: file)
            }
            
            let otaAction = UIAlertAction.init(title: "OTA文件", style: .default) { action in
                let otaFolderPath = FolderHelper.DFUFolderPath()
                self.trySaveFile(targetFolderPath: otaFolderPath, defaultFileName: fileName, file: file)
            }
            
            let cancel = UIAlertAction.init(title: "取消", style: .destructive)
            
            let sheet = UIAlertController.init(title: nil, message: "请根据文件类型选择保存路径", preferredStyle: .alert)
            sheet.addAction(dialplateAction)
            sheet.addAction(otaAction)
            sheet.addAction(cancel)
            
            self.window?.rootViewController?.present(sheet, animated: true)

        }catch{
            NSLog("加载文件失败:\(error.localizedDescription)")
            SVProgressHUD.showError(withStatus: "加载文件失败")
        }
        
        return true
    }
    

    private func trySaveFile(targetFolderPath:String, defaultFileName:String, file:Data) {
        showFileAlert(title: "保存文件", message: "保存之前可以在此将文件重命名", fileName: defaultFileName) { newFileName in
            if newFileName.count < 1{
                SVProgressHUD.showError(withStatus: "文件名不能为空")
                return
            }
            let newPath = targetFolderPath + "/" + newFileName
            do{
                let newURL = URL.init(fileURLWithPath: newPath)
                try file.write(to: newURL)
                SVProgressHUD.showSuccess(withStatus: nil)
            }catch{
                NSLog("保存文件失败:\(error.localizedDescription)")
                SVProgressHUD.showError(withStatus: "保存文件失败")
            }
        }
    }
    
    private func showFileAlert(title:String?,message:String?,fileName:String,confirm:((_ fileName:String) -> Void)? = nil){

        let controller = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        controller.addTextField { textField in
            textField.text = fileName
        }
        let okAction = UIAlertAction.init(title: "确定", style: .default) { action in
            let content = controller.textFields?[0].text
            confirm?(content ?? "")
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { action in
            
        }
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        self.window?.rootViewController?.present(controller, animated: false, completion: {
            
        })
    }


}

