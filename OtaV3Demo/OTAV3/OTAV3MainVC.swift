import UIKit
import SifliOtaSDK
import SifliOCore
import CoreBluetooth

fileprivate let ConsoleCellKey = "ConsoleCellKey"
fileprivate let OtaV3ImageFileInfoCellKey = "OtaV3ImageFileInfoCellKey"

fileprivate let maxLogCount = 100

enum OTAV3Status{
    case none
    case starting
    case nandRes
    case nandHCPU
    case nor
}

class OTAV3MainVC: UIViewController,SFOtaV3ManagerDelegate,UITableViewDelegate,UITableViewDataSource,OtaV3ImageFileInfoCellDelegate,SFOLogManagerDelegate {
  
    @IBOutlet weak var targetDevLabel: UILabel!
    
    @IBOutlet weak var resZipTextView: UITextView!
    
    @IBOutlet weak var ctrlFileTextView: UITextView!
    
    let progressStageLabel = UILabel.init()
    let progressBar = QProgressBar.init()
    
    @IBOutlet weak var contentView: UIView!
    private let logTableView = UITableView.init()
    
    @IBOutlet weak var fileTableView: UITableView!
    
    @IBOutlet weak var otaTypeTextField: UITextField!
    
    @IBOutlet weak var withByteAlignSwitch: UISwitch!
    
    @IBOutlet weak var speedLabel: UILabel!
    private var processContents = Array<String>.init()
    private var timeFormatter = DateFormatter.init()
    
    let manager = SFOtaV3Manager.shared()
    
    private var targetDevIdentifier:String?
    private var resourceFileZipUrl:URL?
    private var ctrlFileUrl:URL?
    private var imageFileInfoArray = Array<OtaV3ImageFileItem>.init()
    
    private var otaStatus:OTAV3Status = .none
    private let speedView = SpeedView.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SFLog.i("viewDidLoad")
        timeFormatter.dateFormat = "HH:mm:ss SSS"
        
        manager.delegate = self
        //关闭OTASDK的日志输出，让它委托给这里处理，并且转发到bugly.
        SFOLogManager.shared().logEnable = false
        SFOLogManager.shared().delegate = self
        
        logTableView.separatorStyle = .none
        logTableView.dataSource = self
        logTableView.delegate = self
        logTableView.backgroundColor = UIColor.init(red: 56.0/255.0, green: 56.0/255.0, blue: 56.0/255.0, alpha: 1)
        self.contentView.addSubview(logTableView)
        
        fileTableView.separatorStyle = .none
        fileTableView.dataSource = self
        fileTableView.delegate = self
        fileTableView.layer.borderColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0).cgColor
        fileTableView.layer.borderWidth = 1.0
        
        self.progressStageLabel.text = "Stage"
        self.progressStageLabel.font = UIFont.systemFont(ofSize: 10.0)
        self.progressStageLabel.textAlignment = .right
        self.progressStageLabel.textColor = .black
        self.view.addSubview(progressStageLabel)
        
        self.view.addSubview(progressBar)
        self.otaTypeTextField.keyboardType = .numberPad;
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logTableView.frame = contentView.bounds
        
        progressBar.frame = CGRect.init(x: 0, y: 0, width: 260, height: 10)
        progressBar.center = CGPoint.init(x: self.view.frame.width/2.0+30, y: (fileTableView.frame.maxY+contentView.frame.origin.y)/2.0)
        
        let labelW:CGFloat = 100
        let labelH:CGFloat = 30
        progressStageLabel.frame = CGRect.init(x: progressBar.frame.minX-labelW, y: fileTableView.frame.maxY, width: labelW, height: labelH)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SFLog.i("viewWillDisappear")
        self.view.endEditing(true)
    }

    @IBAction func clickBackButton(_ sender: Any) {
        SFLog.i("clickBackButton")
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
            SFLog.i("selected device:\(identifierString)")
        }
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    
    @IBAction func clickSelectResZipButton(_ sender: Any) {
        SFLog.i("")
        let vc = OTAFileListVC.init(nibName: "OTAFileListVC", bundle: Bundle.main)
        vc.completion = {(fileUrl) in
            guard let url = fileUrl else {
                return
            }
            self.resourceFileZipUrl = url
            self.resZipTextView.text = url.lastPathComponent
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func clickSelectCtrlFileButton(_ sender: Any) {
        SFLog.i("")
        let vc = OTAFileListVC.init(nibName: "OTAFileListVC", bundle: Bundle.main)
        vc.completion = {(fileUrl) in
            guard let url = fileUrl else {
                return
            }
            self.ctrlFileUrl = url
            self.ctrlFileTextView.text = url.lastPathComponent
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func clickAddImageFileButton(_ sender: Any) {
        SFLog.i("")
        let vc = OTAFileListVC.init(nibName: "OTAFileListVC", bundle: Bundle.main)
        vc.completion = {[weak self](fileUrl) in
            guard let url = fileUrl else {
                return
            }
            let fileItem = OtaV3ImageFileItem.init(fileUrl: url, imageId: nil)
            self?.imageFileInfoArray.append(fileItem)
            self?.fileTableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func clickStartNormalButton(_ sender: Any) {
        SFLog.i("")
        guard let otaTypeStr = self.otaTypeTextField.text else{
            SVProgressHUD.showInfo(withStatus: "请输入otatype")
            return
        }
        guard let otaType = UInt.init(otaTypeStr) else{
            SVProgressHUD.showInfo(withStatus: "请输入otatype")
            return
        }
        if(otaType < 10 || otaType > 11){
            self.startOtaResource(tryResume: false)
        }else{
            self.startOTAFirmeware(tryResume: false)
        }
       
    }
    @IBAction func clickStartResumeButton(_ sender: Any) {
        SFLog.i("")
        guard let otaTypeStr = self.otaTypeTextField.text else{
            SVProgressHUD.showInfo(withStatus: "请输入otatype")
            return
        }
        guard let otaType = UInt.init(otaTypeStr) else{
            SVProgressHUD.showInfo(withStatus: "请输入otatype")
            return
        }
        if(otaType < 10 || otaType > 11){
            self.startOtaResource(tryResume: true)
        }else{
            self.startOTAFirmeware(tryResume: true)
        }
    }
    @IBAction func clickStopButton(_ sender: Any) {
        SFLog.i("")
        manager.userCancel()
    }
    @IBAction func onOtaTypeTouched(_ sender: Any) {
        
    }
    
    private func startOTAFirmeware(tryResume:Bool) {
        if manager.isBusy() {
            SVProgressHUD.showInfo(withStatus: "Manager正忙")
            return
        }
        guard let identifier = self.targetDevIdentifier else {
            SVProgressHUD.showInfo(withStatus: "未选择目标外设!")
            return
        }
        var infosAry = Array<SFOtaV3BinFileInfo>.init()
        if let _ = self.ctrlFileUrl {
            
            // 选择了ctrl文件意味着一定需要Image文件
            if imageFileInfoArray.count == 0 {
                SVProgressHUD.showInfo(withStatus: "未选择Image文件!")
                return
            }
            speedView.clear()
            let ctrlFile:SFOtaV3BinFileInfo = SFOtaV3BinFileInfo.init(widthFileType: SFOtaV3DfuFileType.ctrlFile, filePath: self.ctrlFileUrl!.path, imageId: SFOtaV3ImageID.hcpu);
            infosAry.append(ctrlFile);
            
            for imgInfo in self.imageFileInfoArray {
                // 所选文件均是HCPU，可暂不做ImageID校验
                guard let imageID = imgInfo.imageId else {
                    SVProgressHUD.showInfo(withStatus: "未指定Image文件类型!")
                    return
                }
                let isHexOffsetValid = self.isValidHexOffset(hexoffset: imgInfo.hexOffset)
                if(!isHexOffsetValid){
                    SVProgressHUD.showInfo(withStatus: "偏移地址格式不正确:\(imgInfo.fileUrl.lastPathComponent)")
                    return
                }
                //                let info = SFNandImageFileInfo.init(path: imgInfo.0, imageID: imageID)
                let imageFilePath = imgInfo.fileUrl.path;
                let info = SFOtaV3BinFileInfo.init(widthFileType: SFOtaV3DfuFileType.binFile, filePath: imageFilePath, imageId: imageID);
                info.hexOffset = imgInfo.hexOffset;
                infosAry.append(info)
            }
        }
        
        var resInfo:SFOtaV3ResourceFileInfo? = nil;
        if(self.resourceFileZipUrl != nil){
            resInfo = SFOtaV3ResourceFileInfo.init(fileType: SFOtaV3DfuFileType.zipResource, filePath: self.resourceFileZipUrl!.path, withByteAlign: false);
        }
        
        self.otaStatus = .starting
        self.addNewLog(content: "准备开始OTA v3 firmeware...")
        self.manager .startOtaFirmware(withIdentifier: identifier, resourceFile: resInfo, imageFIles: infosAry, tryResume: tryResume);
    }
    
    func startOtaResource(tryResume:Bool){
        if manager.isBusy() {
            SVProgressHUD.showInfo(withStatus: "Manager正忙")
            return
        }
        guard let identifier = self.targetDevIdentifier else {
            SVProgressHUD.showInfo(withStatus: "未选择目标外设!")
            return
        }
        guard let otaTypeStr = self.otaTypeTextField.text else{
            SVProgressHUD.showInfo(withStatus: "请输入otatype")
            return
        }
        guard let otaType = UInt.init(otaTypeStr) else{
            SVProgressHUD.showInfo(withStatus: "请输入otatype")
            return
        }
        guard let otaV3Type = SFOtaV3Type.init(rawValue: otaType) else{
            SVProgressHUD.showInfo(withStatus: "请输入正确的otatype")
            return
        }
        if(self.resourceFileZipUrl == nil){
            SVProgressHUD.showInfo(withStatus: "请选择资源文件!")
            return
        }
        speedView.clear()
        self.otaStatus = .starting
        self.addNewLog(content: "准备开始OTA v3 resource...")
        let withByteAlign:Bool = self.withByteAlignSwitch.isOn;
        let resInfo:SFOtaV3ResourceFileInfo = SFOtaV3ResourceFileInfo.init(fileType: SFOtaV3DfuFileType.zipResource, filePath: self.resourceFileZipUrl!.path, withByteAlign: withByteAlign);
        self.manager.startOtaRes(withIdentifier: identifier, otaV3Type: otaV3Type, resourceFile: resInfo, tryResume: tryResume)
    }
    
    func otaV3Manager(_ manager: SFOtaV3Manager, progress completedBytes: UInt, total totalBytes: UInt) {
        var newStatus:OTAV3Status = self.otaStatus
        var stageName = ""
        if self.otaStatus != newStatus {
            
            self.otaStatus = newStatus
            
            //状态有更新，UI中需要进行展示
            var log:String?
            switch newStatus {
            case .nandRes:
                log = "开始发送Nand Resource..."
            case .nandHCPU:
                log = "开始发送Nand HCPU..."
            case .nor:
                log = "开始发送Nor..."
            default: break
            }
            if let l = log {
                self.addNewLog(content: l)
                SFLog.i(l)
            }
        }
        self.progressStageLabel.text = stageName
        progressBar.progress = CGFloat(completedBytes) / CGFloat(totalBytes);
        self.speedView.viewSpeedByCompleteBytes(Int64(completedBytes))
        self.speedLabel.text = self.speedView.getSpeedText(currentBytes: Int64(completedBytes), totalBytes: Int64(totalBytes))
    }
    
    func otaV3Manager(_ manager: SFOtaV3Manager, success: Bool, errror error: SFOtaV3Error?) {
        self.otaStatus = .none
        
        var log = ""
        if let err = error {
            log = "OTA V3 失败:\(err.description)"
            SFLog.e(log)
//            SFBugly.reportError(errorCode: .OTANandSendFail, errorMsg: log)
        }else{
            log = "OTA V3 成功!"
        }
        SFLog.i(log)
        self.addNewLog(content: log)
    }
    
    func otaV3Manager(_ manager: SFOtaV3Manager, updateManagerState state: SFBleShellStatus) {
        SFLog.i("OTAManager updateManagerState:\(state)")
        self.addNewLog(content: "updateManagerState:\(state)")
    }
    func otaV3Manager(_ manager: SFOtaV3Manager, updateBleState state: SFBleCoreManagerState) {
        SFLog.i("OTAManager蓝牙状态更新:\(state)")
        self.addNewLog(content: "蓝牙状态更新:\(state)")
    }
    //SFOTALogManagerDelegate
    func logManager(_ manager: SFOLogManager, level: SFOLogLevel, log: String) {
        SFLog.msg(log,level: .info)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.logTableView {
            return Int(processContents.count)//Int(results?.count ?? 0)
        }else{
            return imageFileInfoArray.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView === self.logTableView {
            let text = processContents[indexPath.row]//results?[UInt(indexPath.row)].consoleDes()
            let height = ConsoleCell.CellHeight(cellWidth: tableView.frame.size.width, message: text)
            return height
        }else{
            return 40
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === self.logTableView {
            var cell = tableView.dequeueReusableCell(withIdentifier: ConsoleCellKey) as? ConsoleCell
            if cell == nil {
                cell = ConsoleCell.init(reuseIdentifier: ConsoleCellKey)
            }
            cell?.message = processContents[indexPath.row]//results?[UInt(indexPath.row)].consoleDes()
            return cell!
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: OtaV3ImageFileInfoCellKey) as? OtaV3ImageFileInfoCell
            if cell == nil {
                cell = OtaV3ImageFileInfoCell.init(reuseIdentifier: OtaV3ImageFileInfoCellKey)
                cell?.delegate = self
            }
            cell?.infos = imageFileInfoArray[indexPath.row]
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView === fileTableView {
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView === fileTableView {
            let action = UITableViewRowAction.init(style: .destructive, title: "删除") {[weak self] action, indexPath in
                self?.imageFileInfoArray.remove(at: indexPath.row)
                self?.fileTableView.reloadData()
            }
            return [action]
        }
        return nil
    }
    
    func otaV3ImageFileInfoCell(cell: OtaV3ImageFileInfoCell, selected imageID: SFOtaV3ImageID) {
        let indexPath = fileTableView.indexPath(for: cell)!
        imageFileInfoArray[indexPath.row].imageId = imageID
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
    }
    
    
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
    
    private func isValidHexOffset(hexoffset:String?) -> Bool{
        if(hexoffset == nil){
            return true
        }
        if(hexoffset!.count  > 8){
            return false;
        }
        
       return SFStringUtil.isValidHexString(hexoffset!)
        
    }

}
