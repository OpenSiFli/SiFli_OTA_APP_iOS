import UIKit

class OTAFileListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var completion:((_ fileURL:URL?) -> Void)?
    
    private let CellKey = "OTAFileListCellKey"


    @IBOutlet weak var customView: UIView!
    
    private let tableView = UITableView.init()
    
    private var fileURLArray = Array<URL>.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.alwaysBounceVertical = true
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "OTAFileListCell", bundle: Bundle.main), forCellReuseIdentifier: CellKey)
        tableView.delegate = self
        tableView.dataSource = self
        self.customView.addSubview(tableView)
        
        refreshDataSource()
        tableView.reloadData()
    }
    
    private func refreshDataSource(){
        let folder = FolderHelper.DFUFolderPath()
        let manager = FileManager.default
        fileURLArray.removeAll()
        do{
            let items = try manager.contentsOfDirectory(atPath: folder)
            for i in items {
                var url = URL.init(fileURLWithPath:folder)
                url.appendPathComponent(i)
                fileURLArray.append(url)
            }
            fileURLArray.sort { last, next in
                return last.lastPathComponent < next.lastPathComponent
            }
        }catch{
            print("获取文件夹下文件失败:\(error)")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.frame = self.customView.bounds
    }

    @IBAction func clickBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileURLArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellKey) as? OTAFileListCell
        cell?.set(name: fileURLArray[indexPath.row].lastPathComponent)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showAlert(title: "提示", message: "是否选取文件'\(self.fileURLArray[indexPath.row].lastPathComponent)'?") {
            self.completion?(self.fileURLArray[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: .destructive, title: "删除") { act, indexPath in
            self.showAlert(title: "提示", message: "是否要删除文件'\(self.fileURLArray[indexPath.row].lastPathComponent)'") {
                // 执行删除操作
                let manager = FileManager.default
                do{
                    try manager.removeItem(at: self.fileURLArray[indexPath.row])
                    SVProgressHUD.showSuccess(withStatus: nil)
                }catch{
                    print("删除文件失败:\(error)")
                    SVProgressHUD.showError(withStatus: "删除失败")
                }
                self.refreshDataSource()
                self.tableView.reloadData()
            }
        }
        return [deleteAction]
    }
    
    private func showAlert(title:String?,message:String?,confirm: @escaping (()->Void)){
        let ok = UIAlertAction.init(title: "确定", style: .default) { action in
            confirm()
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        let controller = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        controller.addAction(ok)
        controller.addAction(cancel)
        self.present(controller, animated: true, completion: nil)
    }
}
