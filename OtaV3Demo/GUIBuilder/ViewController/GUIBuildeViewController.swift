//
//  GUIBuildeViewController.swift
//  SFIntegration
//
//  Created by Sean on 2026/2/25.
//

import UIKit
import SifliGUIBuilderSDK
import TZImagePickerController
import SifliOtaSDK
import BRPickerView
import SFSSZipArchivePlugin
import SnapKit


fileprivate let ConsoleCellKey = "ConsoleCellKey"
fileprivate let MyWatchfaceEditItemTableViewCellKey = "MyWatchfaceEditItemTableViewCell"
fileprivate let WatchPathTemp = "dyn/dynamic_app/tool_wf/{app_id}/{uid}.bin";

fileprivate let MESSAGE_SWITCH_THEME = 10
fileprivate let MESSAGE_DELETE_RES_PATCH = 11
fileprivate let MESSAGE_DELETE_APP = 12

class GUIBuildeViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,MyWatchfaceEditItemTableViewCellDelegate,TZImagePickerControllerDelegate,SGResourceZIPMakerDelegate,SFOtaV3ManagerDelegate,SGPushMessageManagerDelegate {
   
    private lazy var backBtn = UIButton.init(type:.system)
    private lazy var titleTxtLabel = UILabel.init()
    private lazy var deviceIdBtn = UIButton.init(type:.system)
    private lazy var deviceLabel = UILabel.init()
    private lazy var selectFileBtn = UIButton.init(type:.custom)
    private lazy var fileNameLabel = UILabel.init()
    
    private lazy var actionLabel = UILabel.init()
    private lazy var loadBtn = UIButton.init(type:.custom)
    private lazy var previewBtn = UIButton.init(type:.custom)
    private lazy var languageBtn = UIButton.init(type:.custom)
    private lazy var themeBtn = UIButton.init(type:.custom)
    private lazy var previewImage = UIImageView.init()
    
    private lazy var progressStageLabel = UILabel.init()
    private lazy var progressBar = UIProgressView.init()

    private lazy var delAppBtn = UIButton.init(type:.custom)
    private lazy var clearLogBtn = UIButton.init(type:.custom)
    
    private let fileTableView = UITableView.init()
    private let logTableView = UITableView.init()
    private var processContents = Array<String>.init()
    private var timeFormatter = DateFormatter.init()
    private var imageFileInfoArray = Array<MyWatchfaceEditItem>.init()
    private var currentEditItem:MyWatchfaceEditItem?
    private var currentDelItem:MyWatchfaceEditItem?
    private var currentMessage:Int?
    private var languageItems:Array<LanguageItem> = Array.init()
    private var themeIds:Array<String> = Array.init()
    
    private var zipUrl:URL?
    
    private var devIdentifier:String?
    private let workspaceManager:SGWorkSpaceManager = SGWorkSpaceManager.init()
    private let resourceZIPMaker:SGResourceZIPMaker = SGResourceZIPMaker.sharedInstance()
    private let otaV3Manager:SFOtaV3Manager = SFOtaV3Manager.shared()
    private let pushMessageManager:SGPushMessageManager = SGPushMessageManager.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeFormatter.dateFormat = "HH:mm:ss SSS"
        SFZipHelper.shared().zipDelegate = SFSSZipArchiver.shared()
        self.resourceZIPMaker.delegate = self;
        self.otaV3Manager.delegate = self;
        self.pushMessageManager.delegate = self;
    }
    
    override func setupView() {
        self.view.backgroundColor = .white
        self.backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.backBtn.setTitle("Back", for: .normal)
        self.backBtn.titleLabel?.textColor = SFColor.mainBlueColor
        self.backBtn.backgroundColor = .clear
        self.backBtn.addTarget(self, action: #selector(onBackTouch(sender:)), for: .touchUpInside)
        self.backBtn.titleLabel?.textAlignment = .left
        self.view.addSubview(self.backBtn)
        
        self.titleTxtLabel.text = "GUI Builder SDK"
        self.titleTxtLabel.font = UIFont.systemFont(ofSize: 17)
        self.titleTxtLabel.textColor = SFColor.color333333
        self.view.addSubview(self.titleTxtLabel)
        
        self.deviceIdBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.deviceIdBtn.setTitle("Device", for: .normal)
        self.deviceIdBtn.titleLabel?.textColor = SFColor.mainBlueColor
        self.deviceIdBtn.backgroundColor = .clear
        self.deviceIdBtn.addTarget(self, action: #selector(clickChooseDevButton(sender:)), for: .touchUpInside)
        self.deviceIdBtn.titleLabel?.textAlignment = .left
        self.view.addSubview(self.deviceIdBtn)
        
        self.deviceLabel.text = "目标设备";
        self.deviceLabel.textColor = SFColor.color333333
        self.deviceLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(self.deviceLabel)
        
        self.selectFileBtn.backgroundColor = SFColor.mainBlueColor
        self.selectFileBtn.setTitle("选择文件(.sif)", for: .normal)
        self.selectFileBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.selectFileBtn.layer.masksToBounds = true;
        self.selectFileBtn.layer.cornerRadius = 20;
        self.selectFileBtn.addTarget(self, action: #selector(onSelectFileBtnTouch(sender:)), for: .touchUpInside)
        self.view .addSubview(self.selectFileBtn);
        
        self.fileNameLabel.text = "---";
        self.fileNameLabel.textColor = SFColor.color333333
        self.fileNameLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(self.fileNameLabel)
        
        self.actionLabel.text = "操作";
        self.actionLabel.textColor = SFColor.color333333
        self.actionLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(self.actionLabel)
        
        self.loadBtn.backgroundColor = SFColor.mainBlueColor
        self.loadBtn.setTitle("Load", for: .normal)
        self.loadBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.loadBtn.layer.masksToBounds = true;
        self.loadBtn.layer.cornerRadius = 20;
        self.loadBtn.addTarget(self, action: #selector(onLoadBtnTouch(sender:)), for: .touchUpInside)
        self.view .addSubview(self.loadBtn);
        
        self.previewBtn.backgroundColor = SFColor.mainBlueColor
        self.previewBtn.setTitle("Preview", for: .normal)
        self.previewBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.previewBtn.layer.masksToBounds = true;
        self.previewBtn.layer.cornerRadius = 20;
        self.previewBtn.addTarget(self, action: #selector(onPreviewBtnTouch(sender:)), for: .touchUpInside)
        self.view .addSubview(self.previewBtn);
        
        self.languageBtn.backgroundColor = SFColor.mainBlueColor
        self.languageBtn.setTitle("Language", for: .normal)
        self.languageBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.languageBtn.layer.masksToBounds = true;
        self.languageBtn.layer.cornerRadius = 20;
        self.languageBtn.addTarget(self, action: #selector(onLanguageBtnTouch(sender:)), for: .touchUpInside)
        self.view .addSubview(self.languageBtn);
        
        self.themeBtn.backgroundColor = SFColor.mainBlueColor
        self.themeBtn.setTitle("Theme", for: .normal)
        self.themeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.themeBtn.layer.masksToBounds = true;
        self.themeBtn.layer.cornerRadius = 20;
        self.themeBtn.addTarget(self, action: #selector(onThemeBtnTouch(sender:)), for: .touchUpInside)
        self.view .addSubview(self.themeBtn);
        
        self.previewImage.backgroundColor = SFColor.colorf5f5f5;
        self.previewImage.contentMode = .scaleAspectFit;
        self.view.addSubview(self.previewImage)
        
        self.logTableView.separatorStyle = .none
        self.logTableView.dataSource = self
        self.logTableView.delegate = self
        self.logTableView.backgroundColor = UIColor.black
        self.logTableView.register(ConsoleCell.self, forCellReuseIdentifier: ConsoleCellKey)
        self.view.addSubview(self.logTableView)
        
        self.fileTableView.backgroundColor = SFColor.colorf5f5f5
        self.fileTableView.separatorStyle = .none
        self.fileTableView.dataSource = self
        self.fileTableView.delegate = self
        self.fileTableView.layer.borderColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0).cgColor
        self.fileTableView.layer.borderWidth = 1.0
        self.fileTableView.register(UINib(nibName: "MyWatchfaceEditItemTableViewCell", bundle: nil), forCellReuseIdentifier: MyWatchfaceEditItemTableViewCellKey)
        self.view.addSubview(self.fileTableView)
        
        self.progressStageLabel.text = "Stage"
        self.progressStageLabel.font = UIFont.systemFont(ofSize: 10.0)
        self.progressStageLabel.textAlignment = .right
        self.progressStageLabel.textColor = .black
        self.view.addSubview(progressStageLabel)
        self.progressBar.progress = 0
        self.view.addSubview(progressBar)
        
        self.delAppBtn.backgroundColor = SFColor.mainBlueColor
        self.delAppBtn.setTitle("Delete App", for: .normal)
        self.delAppBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.delAppBtn.layer.masksToBounds = true;
        self.delAppBtn.layer.cornerRadius = 20;
        self.delAppBtn.addTarget(self, action: #selector(onDelAppBtnTouch(sender:)), for: .touchUpInside)
        self.view.addSubview(self.delAppBtn);
        
        self.clearLogBtn.backgroundColor = SFColor.mainBlueColor
        self.clearLogBtn.setTitle("Clear Log", for: .normal)
        self.clearLogBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.clearLogBtn.layer.masksToBounds = true;
        self.clearLogBtn.layer.cornerRadius = 20;
        self.clearLogBtn.addTarget(self, action: #selector(onClearLogBtnTouch(sender:)), for: .touchUpInside)
        self.view.addSubview(self.clearLogBtn);
    }
    
    override func makeConstraint(){
        let statusTop = UIDevice.vg_statusBarHeight();
        self.backBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(statusTop)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
       
        self.titleTxtLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(20)
        }
        self.deviceIdBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(self.backBtn.snp.bottom).offset(10)
        }
        self.deviceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.deviceIdBtn)
            make.left.equalTo(self.deviceIdBtn.snp.right).offset(10)
        }
        //选择文件
        self.selectFileBtn.snp.makeConstraints { make in
            make.left.equalTo(20);
            make.top.equalTo(self.deviceIdBtn.snp.bottom).offset(10)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        self.fileNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.selectFileBtn)
            make.left.equalTo(self.selectFileBtn.snp.right).offset(10)
        }
        
        self.actionLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(self.selectFileBtn.snp.bottom).offset(20)
        }
        
        self.loadBtn.snp.makeConstraints { make in
            make.left.equalTo(self.actionLabel.snp.right).offset(10)
            make.centerY.equalTo(self.actionLabel)
            make.height.equalTo(40);
            make.width.equalTo(100);
        }
        
        self.previewBtn.snp.makeConstraints { make in
            make.left.equalTo(self.loadBtn.snp.right).offset(10)
            make.centerY.equalTo(self.loadBtn)
            make.height.equalTo(40);
            make.width.equalTo(100);
        }
        
        self.languageBtn.snp.makeConstraints { make in
            make.left.equalTo(self.loadBtn)
            make.top.equalTo(self.loadBtn.snp.bottom).offset(10)
            make.height.equalTo(40);
            make.width.equalTo(100);
        }
        
        self.themeBtn.snp.makeConstraints { make in
            make.left.equalTo(self.languageBtn.snp.right).offset(10)
            make.top.equalTo(self.languageBtn)
            make.height.equalTo(40);
            make.width.equalTo(100);
        }
        
        self.previewImage.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.languageBtn.snp.bottom).offset(10)
        }
        
        self.fileTableView.snp.makeConstraints { make in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.top.equalTo(self.previewImage.snp.bottom).offset(5)
            make.height.equalTo(100)
        }
        
        self.logTableView.snp.makeConstraints { make in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.top.equalTo(self.fileTableView.snp.bottom).offset(0)
            make.height.equalTo(100)
        }
        
        self.progressStageLabel.snp.makeConstraints { make in
            make.left.equalTo(self.view)
            make.top.equalTo(self.logTableView.snp.bottom).offset(5)
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        
        self.progressBar.snp.makeConstraints { make in
            make.left.equalTo(self.progressStageLabel.snp.right).offset(5)
            make.centerY.equalTo(self.progressStageLabel)
            make.height.equalTo(16)
            make.right.equalTo(self.view.snp.right).offset(-10)
        }
        
        self.delAppBtn.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(self.progressStageLabel.snp.bottom).offset(5)
            make.height.equalTo(40);
            make.width.equalTo(100);
        }
        
        self.clearLogBtn.snp.makeConstraints { make in
            make.left.equalTo(self.delAppBtn.snp.right).offset(10)
            make.top.equalTo(self.delAppBtn)
            make.height.equalTo(40);
            make.width.equalTo(100);
        }

    }
    
    @objc private func onBackTouch(sender:Any){
        SFLog.i("")
   
        self.navigationController?.popViewController(animated: true)
     }
    
    @IBAction func clickChooseDevButton(sender: Any) {
        SFLog.i("")
        let searchVC = GeneralOTASearchVC.init()
        searchVC.completion = {[weak self]identifierString in
            self?.deviceLabel.text = identifierString
            self?.devIdentifier = identifierString
            SFLog.i("selected device:\(identifierString)")
        }
        self.navigationController?.pushViewController(searchVC, animated: true)
        
    }
    
    @IBAction func onSelectFileBtnTouch(sender: Any) {
        SFLog.i("")
//        let fileVC = DialPlateFilesVC.init(nibName: "DialPlateFilesVC", bundle: Bundle.main)
//        fileVC.completion = {[weak self] fileURL in
//            guard let s = self else{
//                return
//            }
//        
//            guard let url = fileURL else{
//                return
//            }
//            s.zipUrl = url
//            s.fileNameLabel.text = url.lastPathComponent
//        }
//        self.navigationController?.pushViewController(fileVC, animated: true)
        let vc = OTAFileListVC.init(nibName: "OTAFileListVC", bundle: Bundle.main)
        vc.completion = {(fileUrl) in
            guard let url = fileUrl else {
                return
            }
            self.zipUrl = url
            self.fileNameLabel.text = url.lastPathComponent
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onLoadBtnTouch(sender: Any) {
        SFLog.i("")
        if(self.zipUrl == nil){
            return;
        }
        let result = self.workspaceManager.openProject(self.zipUrl!.path)
        if(!result.success){
            let msg:String = "load project fail.\(result.error)"
            SFLog.e(msg)
            self.addNewLog(content: msg)
        }else{
            SFLog.i("load project success")
            self.loadThemeIds()
            self.addNewLog(content: "load success")
            self.reloadEditItems()
            self.loadLanguageItems();
            self.onPreviewBtnTouch(sender: self.previewBtn)
            self.updateLanguageAndThemeBtn()
        }
        
    }
    
    @IBAction func onPreviewBtnTouch(sender: Any) {
        SFLog.i("")
        let result:UIImage? = self.workspaceManager.drawPreviewImage()
        self.previewImage.image = result;
    }
    
    @IBAction func onLanguageBtnTouch(sender: Any) {
        SFLog.i("")
        var lanNames = Array<String>.init()
        for item in self.languageItems {
            lanNames.append(item.name)
        }
        // 创建单列文本选择器
        let textPickerView = BRTextPickerView(pickerMode:.componentSingle)
        textPickerView.title = "多语言"
        // 设置数据源
        textPickerView.dataSourceArr = lanNames
        textPickerView.selectIndex = 0 // 假设 mySelectIndex 是当前类的属性

        // 注意捕获 [weak self] 避免循环引用
        textPickerView.singleResultBlock = { [weak self] model, index in
            guard let self = self else { return }
            self.applyLanguageItem(position: index)
           
        }

        textPickerView.show()
    }
    
    @IBAction func onThemeBtnTouch(sender: Any) {
        SFLog.i("")
        // 创建单列文本选择器
        let textPickerView = BRTextPickerView(pickerMode:.componentSingle)
        textPickerView.title = "页面/样式"
        // 设置数据源
        textPickerView.dataSourceArr = self.themeIds
        textPickerView.selectIndex = 0 // 假设 mySelectIndex 是当前类的属性

        // 注意捕获 [weak self] 避免循环引用
        textPickerView.singleResultBlock = { [weak self] model, index in
            guard let self = self else { return }
            self.applyCurrentTheme(position: index)
           
        }

        textPickerView.show()
    }
    
    @IBAction func onDelAppBtnTouch(sender: Any) {
        SFLog.i("")
        if(!self.workspaceManager.hasLoadProject()){
            SVProgressHUD.showInfo(withStatus: "please open project file first")
            return;
        }
        if(self.devIdentifier == nil){
            SVProgressHUD.showInfo(withStatus: "please select device first")
            return;
        }
        SVProgressHUD.show(withStatus: "删除表盘...")
        let appId = self.workspaceManager.getProjectId();
        self.pushMessageManager.sendDeleteAppCmd(withIdentifier: self.devIdentifier!, appId: appId!)
       
    }
    
    @IBAction func onClearLogBtnTouch(sender: Any) {
        SFLog.i("")
        self.processContents.removeAll()
        self.logTableView.reloadData()
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
            return 50
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === self.logTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: ConsoleCellKey) as? ConsoleCell
            cell?.message = processContents[indexPath.row]//results?[UInt(indexPath.row)].consoleDes()
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: MyWatchfaceEditItemTableViewCellKey) as? MyWatchfaceEditItemTableViewCell
            let model:MyWatchfaceEditItem = imageFileInfoArray[indexPath.row]
            cell?.updateUI(model: model)
            cell?.delegate = self;
            return cell!
        }
    }
    
    //MyWatchfaceEditItemTableViewCellDelegate
    func MyWatchfaceEditItemTableViewCellOnEdit(cell:MyWatchfaceEditItemTableViewCell,model:MyWatchfaceEditItem){
        if let editImage = model.editItem.originImage {
            self.currentEditItem = model;
            self .presentCropViewController(image: editImage);
        }
       
    }
    
    func MyWatchfaceEditItemTableViewCellOnSend(cell:MyWatchfaceEditItemTableViewCell,model:MyWatchfaceEditItem){
        SFLog.i("MyWatchfaceEditItemTableViewCellOnSend")
        self.currentEditItem = model;
        let appId = self.workspaceManager.getProjectId();
        if(appId == nil){
            return;
        }
        let context = SGAppResUserContext.init(appId: appId!, watchPathTemp: WatchPathTemp, workSpaceManager: self.workspaceManager);
        context.setEZIPParameterWithColor("rgb565", noAlpha: 0, noRotation: 1, boardType: 1)
        if(!model.editItem.hasPatch()){
            SVProgressHUD.showInfo(withStatus: "请先修改表盘")
            return;
        }
        SVProgressHUD.show(withStatus: "制作资源补丁...");
        self.resourceZIPMaker.startMakePatchZip(with: context, editItem: model.editItem);
    }
    
    func MyWatchfaceEditItemTableViewCellOnDel(cell:MyWatchfaceEditItemTableViewCell,model:MyWatchfaceEditItem){
        self.currentDelItem = model;
        self.currentMessage = MESSAGE_DELETE_RES_PATCH;
        if(self.devIdentifier == nil){
            SVProgressHUD.showInfo(withStatus: "请先选择设备");
            return;
        }
        SVProgressHUD.show(withStatus: "删除资源补丁...");
        if let appId = self.workspaceManager.getProjectId(){
            self.pushMessageManager .sendDeletePatchCmd(withIdentifier: self.devIdentifier!, appId: appId, patchFileName: model.getPatchFileName());
        }
    
    }
    
    private func onPushDeleteResPatchSuccess(){
        SFLog.i("onPushDeleteResPatchSuccess")
        if(self.currentDelItem == nil){
            return;
        }
        
        self.workspaceManager.deletePatch(withOriginImageName: self.currentDelItem!.editItem.originImageName)
        self.currentDelItem?.editItem.deletePatch()
        self.currentDelItem?.hasSend = false;
        self.fileTableView.reloadData()
        self.onPreviewBtnTouch(sender: self.previewBtn)
    }
    
    private func loadLanguageItems(){
        self.languageItems.removeAll();
        let itemsResult = self.workspaceManager.getLanguageItems();
        for item in itemsResult {
            self.languageItems.append(item)
        }
    }
    
    private func loadThemeIds(){
        self.themeIds.removeAll()
        let list = self.workspaceManager.themeIdList()
        for item in list {
            self.themeIds.append(item)
        }
    }
    
    private func reloadEditItems(){
        SFLog.i("reloadEditItems");
        self.imageFileInfoArray.removeAll();
        
        let itemListResult = self.workspaceManager.getEditItems();
        if(itemListResult.success){
            for editItem:SGWatchfaceEditItem in itemListResult.editItems! {
                if let imageEditItem = editItem as? SGImageEditItem {
                    let myItem:MyWatchfaceEditItem = MyWatchfaceEditItem.init(imageEditItem: imageEditItem);
                    self.imageFileInfoArray.append(myItem);
                }
            }
        }else{
            
        }
        self.fileTableView.reloadData()
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
    
    func presentCropViewController(image:UIImage) {
//        let cropViewController = CropViewController(image: image)
//        cropViewController.delegate = self
//        
//        self.present(cropViewController, animated: true, completion: nil)
        SFLog.i("presentCropViewController w=\(image.size.width),h=\(image.size.height)")
        let picker:TZImagePickerController = TZImagePickerController.init(maxImagesCount: 1, delegate: self);
        picker.maxImagesCount = 1;
        picker.allowCrop = true;
        let scale = UIScreen.main.scale;
        let cropX = UIScreen.main.bounds.size.width/2 - (image.size.width/scale)/2;
        let cropY = UIScreen.main.bounds.size.height/2 - (image.size.width/scale)/2;
     
        
        picker.cropRect = CGRect(x: cropX, y: cropY, width: image.size.width/scale, height: image.size.height/scale)
        picker.modalPresentationStyle = .fullScreen;
        self.present(picker, animated: true);
    }
    
    private func startSend(patchZipPath:String?){
        SFLog.i("startSend path=\(String(describing: patchZipPath))");
        if(patchZipPath == nil){
            return;
        }
        if(patchZipPath!.isEmpty){
            return
        }
        if(self.devIdentifier == nil){
            SVProgressHUD.showInfo(withStatus: "请先选择设备");
            return;
        }
        
        let align = true;
        let resourceFileInfo = SFOtaV3ResourceFileInfo.init(fileType: .zipResource, filePath: patchZipPath!, withByteAlign: align);
        self.otaV3Manager.startOtaRes(withIdentifier: self.devIdentifier!, otaV3Type:.sifliAppRes, resourceFile: resourceFileInfo, tryResume: false);
    }
    
    private func updateLanguageAndThemeBtn(){
        let themeid = self.workspaceManager.getCurrentThemeId()
        self.themeBtn.setTitle(themeid, for: .normal)
        
        let currentLanItem = self.workspaceManager.getCurrentLanguageItem()
        let lanTitle = currentLanItem == nil ? "" : currentLanItem!.name
        self.languageBtn.setTitle(lanTitle, for: .normal)
    }
    
    private func applyCurrentTheme(position:Int){
        if(position < 0 || position > self.themeIds.count - 1){
            return;
        }
        let appId = self.workspaceManager.getProjectId();
        if(appId == nil){
            return;
        }
        
        SFLog.i("applyCurrentTheme")
        let themeId = self.themeIds[position]
        self.workspaceManager.switchTheme(themeId)
        self.reloadEditItems()
        self.onPreviewBtnTouch(sender: self.previewBtn)
        
        if(self.devIdentifier == nil){
            return;
        }
        SVProgressHUD.show(withStatus: "切换页面/样式...")
        
        self.pushMessageManager.sendSwitchThemeCmd(withIdentifier: self.devIdentifier!, appId: appId!, themeId: themeId)
        self.updateLanguageAndThemeBtn()
        
    }
    
    private func applyLanguageItem(position:Int){
        if(position < 0 || position > self.languageItems.count - 1){
            return;
        }
        SFLog.i("applyLanguageItem")
        let lanItem = self.languageItems[position]
        self.workspaceManager.switchLanguageItem(byId: lanItem.itemId())
        self.onPreviewBtnTouch(sender: self.previewBtn)
        self.reloadEditItems()
        self.updateLanguageAndThemeBtn()
        
    }
    
    //CropViewControllerDelegate
//    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        
//    }
    
  
    //TZImagePickerControllerDelegate
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        SFLog.i("picked photo=\(photos.count)")
        if(photos.count > 0){
            let firstImage = photos.first;
            SFLog.i("picked firstImage w=\(firstImage!.size.width) h=\(firstImage!.size.width)")
            if(self.currentEditItem != nil){
                self.currentEditItem!.editItem.updatePatchImage(firstImage!)
                self.currentEditItem!.hasSend = false;
                self.fileTableView.reloadData()
                self.workspaceManager.makeImagePatch(self.currentEditItem!.editItem)
                self.onPreviewBtnTouch(sender: self.previewBtn)
            }
           
        }
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        SFLog.i("picked photo=\(photos.count)")
    }
    
    //SGResourceZIPMakerDelegate
    func sgResourceZIPMaker(_ maker: SGResourceZIPMaker, onComplete success: Bool, patchZipPath path: String?, error: SFCoreError?) {
        let msg = "zip maker:onComplete success=\(success),error=\(String(describing: error)),patchZipPath=\(String(describing: path))"
        SFLog.i(msg)
        self.addNewLog(content: msg)
        if(success){
            SVProgressHUD.show(withStatus: "发送资源补丁...")
            self.startSend(patchZipPath: path)
        }else{
            SVProgressHUD.dismiss()
        }
    }
    
    func sgResourceZIPMaker(_ maker: SGResourceZIPMaker, onProgressWithCurrent current: Int, total: Int) {
        
    }
    
    //SFOtaV3ManagerDelegate
    func otaV3Manager(_ manager: SFOtaV3Manager, progress completedBytes: UInt, total totalBytes: UInt) {
        progressBar.progress = Float(completedBytes) / Float(totalBytes);
   
    }
    
    func otaV3Manager(_ manager: SFOtaV3Manager, success: Bool, errror error: SFOtaV3Error?) {
       
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
        if(success && self.currentEditItem != nil){
            if(self.currentEditItem!.editItem.hasPatch()){
                SFLog.i("update item to hasSend id=\(self.currentEditItem!.editItem.controlId)")
                self.currentEditItem!.hasSend = true;
            }
        }
        SVProgressHUD.dismiss()
        self.fileTableView.reloadData()
    }
    
    func otaV3Manager(_ manager: SFOtaV3Manager, updateManagerState state: SFBleShellStatus) {
        SFLog.i("OTAManager updateManagerState:\(state)")
        self.addNewLog(content: "updateManagerState:\(state)")
    }
    func otaV3Manager(_ manager: SFOtaV3Manager, updateBleState state: SFBleCoreManagerState) {
        SFLog.i("OTAManager蓝牙状态更新:\(state)")
        self.addNewLog(content: "蓝牙状态更新:\(state)")
    }
    
    //SGPushMessageManagerDelegate
    func pushMessageManager(_ manager: SGPushMessageManager, updateBleState state: SFBleCoreManagerState) {
        SFLog.i("pushMessageManager updateBleState:\(state)")
    }
    
    func pushMessageManager(_ manager: SGPushMessageManager, success: Bool, errror error: SFCoreError?) {
        let msg = "pushMessageManager success:\(success),error:\(String(describing: error))"
        SFLog.i(msg)
        self .addNewLog(content: msg)
        if(success ){
            if(self.currentMessage == MESSAGE_DELETE_RES_PATCH){
                self.onPushDeleteResPatchSuccess();
            }
        }
        SVProgressHUD.dismiss();
      
    }
    
    func pushMessageManager(_ manager: SGPushMessageManager, updateManagerState state: SFBleShellStatus) {
        let msg = "pushMessageManager updateManagerState:\(state)"
        SFLog.i(msg)
        self.addNewLog(content: msg)
    }
}
