import UIKit
import SifliOTAManagerSDK
import CoreBluetooth

fileprivate let ConsoleCellKey = "ConsoleCellKey"
fileprivate let NorImageFileInfoCellKey = "NorImageFileInfoCellKey"


enum OTANorTriggerMode{
    case normal
    case force
    case resume
}


class NorOfflineOTAMainVC: UIViewController,SFOTAManagerDelegate,UITableViewDelegate,UITableViewDataSource,SFOTALogManagerDelegate  {

    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var targetDevLabel: UILabel!
    
    @IBOutlet weak var ctrlFileLabel: UILabel!
    
//    @IBOutlet weak var fileTableView: UITableView!
    
    @IBOutlet weak var logTableView: UITableView!
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var startForceButton: UIButton!
//    private let version:NorVersion
    
    let progressStageLabel = UILabel.init()
    let progressBar = QProgressBar.init()
    
    private var processContents = Array<String>.init()
    private var timeFormatter = DateFormatter.init()
    
    let manager = SFOTAManager.share
    
    private var targetDevIdentifier:String?
    private var ctrlFileUrl:URL?
    private var imageFileInfoArray = Array<(URL,NorImageID?)>.init()
    private let speedView = SpeedView.init()
    
    init() {
 
        super.init(nibName: "NorOfflineOTAMainVC", bundle: Bundle.main)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SFLog.i("")
//        self.topTitleLabel.text = "OTA Nor \(self.version.rawValue)"
        
//        self.startForceButton.isHidden = self.version == .v2
        
        timeFormatter.dateFormat = "HH:mm:ss SSS"
        
        manager.delegate = self
        //关闭OTASDK的日志输出，让它委托给这里处理，并且转发到bugly.
        SFOTALogManager.share.logEnable = false
        SFOTALogManager.share.delegate = self;
        
        logTableView.separatorStyle = .none
        logTableView.dataSource = self
        logTableView.delegate = self
        logTableView.backgroundColor = UIColor.init(red: 56.0/255.0, green: 56.0/255.0, blue: 56.0/255.0, alpha: 1)
        
//        fileTableView.separatorStyle = .none
//        fileTableView.dataSource = self
//        fileTableView.delegate = self
//        fileTableView.layer.borderColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0).cgColor
//        fileTableView.layer.borderWidth = 1.0
        
        self.progressStageLabel.text = "Nor"
        self.progressStageLabel.font = UIFont.systemFont(ofSize: 10.0)
        self.progressStageLabel.textAlignment = .right
        self.progressStageLabel.textColor = .black
        self.view.addSubview(progressStageLabel)
        
        self.view.addSubview(progressBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressBar.frame = CGRect.init(x: 0, y: 0, width: 260, height: 10)
        progressBar.center = CGPoint.init(x: self.view.frame.width/2.0+30, y: logTableView.frame.origin.y - 30)
        
        let labelW:CGFloat = 100
        let labelH:CGFloat = 30
        progressStageLabel.frame = CGRect.init(x: progressBar.frame.minX-labelW, y: logTableView.frame.origin.y - 30, width: labelW, height: labelH)
    }

    @IBAction func clickBackButton(_ sender: Any) {
        SFLog.i("")
        showAlert(title: "⚠️警告⚠️", message: "退出该页面会导致蓝牙断开，确定退出?") {[weak self] in
            self?.manager.stop()
            self?.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func clickSelectTargetDeviceButton(_ sender: Any) {
        SFLog.i("")
        let searchVC = GeneralOTASearchVC.init()
        searchVC.completion = {[weak self]identifierString in
            self?.targetDevLabel.text = identifierString
            self?.targetDevIdentifier = identifierString
        }
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    @IBAction func clickSelectCtrlFileButton(_ sender: Any) {
        SFLog.i("")
        let vc = OTAFileListVC.init(nibName: "OTAFileListVC", bundle: Bundle.main)
        vc.completion = {(fileUrl) in
            guard let url = fileUrl else {
                return
            }
            self.ctrlFileUrl = url
            self.ctrlFileLabel.text = url.lastPathComponent
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    @IBAction func clickAddImageFileButton(_ sender: Any) {
//        SFLog.i("")
//        let vc = OTAFileListVC.init(nibName: "OTAFileListVC", bundle: Bundle.main)
//        vc.completion = {[weak self](fileUrl) in
//            guard let url = fileUrl else {
//                return
//            }
//            self?.imageFileInfoArray.append((url,nil))
//            self?.fileTableView.reloadData()
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    @IBAction func clickStartButton(_ sender: Any) {
        SFLog.i("")
        self.startOTA(mode: .normal)
    }

    
    @IBAction func clickStopButton(_ sender: Any) {
        manager.stop()
    }
    
    private func startOTA(mode:OTANorTriggerMode) {
        SFLog.i("")
        if manager.isBusy {
            SVProgressHUD.showInfo(withStatus: "Manager正忙")
            return
        }
        guard let identifier = self.targetDevIdentifier else {
            SVProgressHUD.showInfo(withStatus: "未选择目标外设!")
            return
        }
        guard let ctrlUrl = self.ctrlFileUrl else {
            SVProgressHUD.showInfo(withStatus: "未选择ctrl文件!")
            return
        }
        
        speedView.clear()
        
        self.addNewLog(content: "准备开始Nor Offline...")
        self.manager.startOTANorOffline(targetDeviceIdentifier: identifier, offlineFilePath: ctrlUrl)
    }
    
    func otaManager(manager: SFOTAManager, updateBleState state: BleCoreManagerState) {
        SFLog.i("OTAManager蓝牙状态更新:\(state)")
        self.addNewLog(content: "蓝牙状态更新:\(state)")
    }
    func otaManager(manager: SFOTAManager, stage: SFOTAProgressStage, totalBytes: Int, completedBytes: Int) {
        let progress = CGFloat(completedBytes) / CGFloat(totalBytes)
        if progressBar.progress == 0 && progress > 0 {
            self.addNewLog(content: "开始OTA升级...")
        }
        progressBar.progress = progress
        self.speedView.viewSpeedByCompleteBytes(Int64(completedBytes))
        self.speedLabel.text = self.speedView.getSpeedText(currentBytes: Int64(completedBytes), totalBytes: Int64(totalBytes))
    }
    func otaManager(manager: SFOTAManager, complete error: SFOTAError?) {
        var log = ""
        if let err = error {
            log = "Nor offline 失败:\(err.errorDes)"
            SFLog.e(log)
//            SFBugly.reportError(errorCode: .OTANorSendFail, errorMsg: log)
        }else{
            log = "Nor offline 成功!"
        }
        SFLog.i(log)
        self.addNewLog(content: log)
    }
    
    //SFOTALogManagerDelegate
    func otaLogManager(manager: SifliOTAManagerSDK.SFOTALogManager, onLog log: SFOTALogModel!, logLevel level: SifliOTAManagerSDK.OTALogLevel) {
        SFLog.msg(log.message,level: .info)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
            return Int(processContents.count)//Int(results?.count ?? 0)
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
            let text = processContents[indexPath.row]
            let height = ConsoleCell.CellHeight(cellWidth: tableView.frame.size.width, message: text)
            return height
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            var cell = tableView.dequeueReusableCell(withIdentifier: ConsoleCellKey) as? ConsoleCell
            if cell == nil {
                cell = ConsoleCell.init(reuseIdentifier: ConsoleCellKey)
            }
            cell?.message = processContents[indexPath.row]
            return cell!
      
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    
        return false
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     
        return nil
    }
    
//    func norImageFileInfoCell(cell: NorImageFileInfoCell, selected imageID: NorImageID) {
//        let indexPath = fileTableView.indexPath(for: cell)!
//        imageFileInfoArray[indexPath.row].1 = imageID
//    }
    
    private func addNewLog(content:String) {
        let log = createLogContent(content: content)
        self.processContents.append(log)
        self.logTableView.reloadData()
        self.scrollToLatestLog()
    }
    
    private func scrollToLatestLog(){
        if self.processContents.count > 0{
            let indexP = IndexPath.init(row: self.processContents.count-1, section: 0)
            self.logTableView.scrollToRow(at: indexP, at: .bottom, animated: false)
        }
    }
    
    private func createLogContent(content:String) -> String{
        let timeContent = timeFormatter.string(from: Date.init()) + "ms"
        return "[\(timeContent)] \(content)"
    }
}
