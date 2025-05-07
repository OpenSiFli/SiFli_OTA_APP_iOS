import UIKit
import CoreBluetooth

class DeviceListCell: UITableViewCell {

    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var identifierLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
    }
    
    func set(name:String?,identifierString:String?, rssi:NSNumber? = nil) {
        self.nameLabel.text = name
        self.identifierLabel.text = identifierString
        if let r = rssi {
            self.rssiLabel.text = "\(r.intValue)";
        }else{
            self.rssiLabel.text = "null"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
