import Foundation


typealias TextInputCompletion = (_ text:String) -> Void

typealias MultiTextInputCompletion = (_ textArray:[String]) -> Void

extension UIViewController {
    
    
    func showAlert(title:String?, message:String, confirmAction:@escaping ()->Void) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction.init(title: NSLocalizedString("确定", comment: ""), style: .default) { (action) in
            confirmAction()
        }
        let cancel = UIAlertAction.init(title: NSLocalizedString("取消", comment: ""), style: .cancel) {(action) in
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /// 单行输入框
    func showTextInput(title:String?,message:String?,completion:@escaping TextInputCompletion){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        let confirm = UIAlertAction.init(title: NSLocalizedString("确定", comment: ""), style: .default) { (action) in
            completion(alert.textFields?.first?.text ?? "")
        }
        let cancel = UIAlertAction.init(title: NSLocalizedString("取消", comment: ""), style: .cancel) {(action) in
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
    
    /// 单行输入框
    func showTextInputOTA(title:String?,message:String?, text:String? = nil,completion:@escaping TextInputCompletion){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = text
        }
        let confirm = UIAlertAction.init(title: NSLocalizedString("确定", comment: ""), style: .default) { (action) in
            completion(alert.textFields?.first?.text ?? "")
        }
        let cancel = UIAlertAction.init(title: NSLocalizedString("取消", comment: ""), style: .cancel) {(action) in
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
    
//    func showMultiTextInput(title:String?,message:String?,lines:Int,placeHolders:[String]?,completion:@escaping MultiTextInputCompletion){
//        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
//        for i in 0..<lines {
//            var placeHolder:String?
//            if let ps = placeHolders,i < ps.count {
//                placeHolder = ps[i]
//            }
//            alert.addTextField { (field) in
//                field.placeholder = placeHolder
//            }
//        }
//        let confirm = UIAlertAction.init(title: NSLocalizedString("确定", comment: ""), style: .default) { (action) in
//            var textArray = Array<String>.init()
//            if let fields = alert.textFields {
//                for i in 0 ..< fields.count {
//                    textArray.append(fields[i].text ?? "")
//                }
//            }
//            completion(textArray)
//        }
//        let cancel = UIAlertAction.init(title: NSLocalizedString("取消", comment: ""), style: .cancel) {(action) in
//        }
//        alert.addAction(cancel)
//        alert.addAction(confirm)
//        self.present(alert, animated: true, completion: nil)
//    }
    
    func showMultiTextInput(title:String?,message:String?,lines:Int,placeHolders:[String]?,contents:[String]? = nil,completion:@escaping MultiTextInputCompletion){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        for i in 0..<lines {
            
            var placeHolder:String?
            if let ps = placeHolders,i < ps.count {
                placeHolder = ps[i]
            }
            
            var content : String?
            if let cs = contents,i < cs.count {
                content = cs[i]
            }
            
            alert.addTextField { (field) in
                field.placeholder = placeHolder
                field.text = content
            }
        }
        let confirm = UIAlertAction.init(title: NSLocalizedString("确定", comment: ""), style: .default) { (action) in
            var textArray = Array<String>.init()
            if let fields = alert.textFields {
                for i in 0 ..< fields.count {
                    textArray.append(fields[i].text ?? "")
                }
            }
            completion(textArray)
        }
        let cancel = UIAlertAction.init(title: NSLocalizedString("取消", comment: ""), style: .cancel) {(action) in
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showPeriodInput(title:String? = "填写起止时间",message:String? = nil, completion: ((_ result:(UInt32, UInt32)?) -> Void)?) {
        let ph = [
            "开始时间: yyyy-MM-dd HH:mm:ss",
            "结束时间: yyyy-MM-dd HH:mm:ss"
        ]
        self.showMultiTextInput(title: "时间段", message: nil, lines: ph.count, placeHolders: ph) {[weak self] textArray in
            guard let start = self?.parseDateString(dateString: textArray[0])else{
                SVProgressHUD.showError(withStatus: "'起始时间'格式错误")
                completion?(nil)
                return
            }
            guard let end = self?.parseDateString(dateString: textArray[1])else{
                SVProgressHUD.showError(withStatus: "'结束时间'格式错误")
                completion?(nil)
                return
            }
            completion?((start,end))
        }

    }
    
    
    fileprivate func parseDateString(dateString:String) -> UInt32?{
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateString) else{
            return nil
        }
        
        return UInt32(date.timeIntervalSince1970)
    }
    
    @objc func share(path:String){
        DispatchQueue.main.async {
            let activityController = UIActivityViewController(activityItems: [URL(fileURLWithPath: path)], applicationActivities: nil)
            activityController.modalPresentationStyle = .fullScreen
            activityController.completionWithItemsHandler = {
                (type, flag, array, error) -> Void in
                if flag == true {
                    //                    分享成功
                } else {
                    //                    分享失败
                }
            }
            self.present(activityController, animated: true, completion: nil)
        }
    }
    
}
