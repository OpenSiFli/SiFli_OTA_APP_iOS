import UIKit
import CoreBluetooth

//fileprivate extension CBPeripheral{
//    private struct AssociationKeys {
//        static var RSSIKey:String = "RSSIKey"
//    }
//    public func getRssi() -> NSNumber?{
//        return objc_getAssociatedObject(self, &AssociationKeys.RSSIKey) as? NSNumber
//    }
//    
//    func setRssi(rssi:NSNumber?){
//        objc_setAssociatedObject(self, &AssociationKeys.RSSIKey, rssi, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//    }
//}

class GeneralOTASearchVC: BaseSearchVC,UITableViewDataSource,UITableViewDelegate,CBCentralManagerDelegate  {

    var completion:((_ identifier:String)->Void)?
    
    private let CellKey = "DeviceListCellKey"
    
    private let bleCentral = CBCentralManager.init()
    private var deviceArray = Array<CBPeripheral>.init()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "DeviceListCell", bundle: Bundle.main), forCellReuseIdentifier:CellKey)
        bleCentral.delegate = self

    
    }
    
    override func clickRestart() {
        self.bleCentral.stopScan()
        let connectedDevs = self.bleCentral.retrieveConnectedPeripherals(withServices: [CBUUID(string: "00000000-0000-0000-6473-5F696C666973")])
        self.deviceArray.removeAll()
        self.deviceArray.append(contentsOf: connectedDevs)
        self.tableView.reloadData()
        
        self.bleCentral.scanForPeripherals(withServices: nil)
    }
    
    override func clickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func clickSort() {
        self.deviceArray.sort { pre, last in
            let preValue = abs(pre.getRssi()?.int32Value ?? 0)
            let lastValue = abs(last.getRssi()?.int32Value ?? 0)
            return preValue < lastValue
        }
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellKey) as? DeviceListCell
        let device = deviceArray[indexPath.row]
        cell?.set(name: device.name, identifierString: device.identifier.uuidString, rssi: device.getRssi())
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeripheral = deviceArray[indexPath.row]
        let devId = selectedPeripheral.identifier.uuidString
        let pastboard = UIPasteboard.general
        pastboard.string = devId
//        SVProgressHUD.showInfo(withStatus: "已复制设备identifier")
        let ok = UIAlertAction.init(title: "确定", style: .default) { action in
            self.completion?(selectedPeripheral.identifier.uuidString)
            self.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let name = selectedPeripheral.name ?? ""
        let message = "选择名为'\(name)'的设备进行升级?"
        let controller = UIAlertController.init(title: "提示", message: message, preferredStyle: .alert)
        controller.addAction(ok)
        controller.addAction(cancel)
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        NSLog("蓝牙状态改变:\(central.state)")
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if deviceArray.contains(peripheral) == false {
            peripheral.setRssi(rssi: RSSI)
            deviceArray.append(peripheral)
        }
        tableView.reloadData()
    }

}
