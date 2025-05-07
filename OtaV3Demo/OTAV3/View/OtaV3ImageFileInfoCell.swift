import UIKit
import SifliOtaSDK
protocol OtaV3ImageFileInfoCellDelegate:NSObjectProtocol {
    func otaV3ImageFileInfoCell(cell:OtaV3ImageFileInfoCell,selected imageID:SFOtaV3ImageID)
}

class OtaV3ImageFileInfoCell: UITableViewCell, LMJDropdownMenuDataSource,LMJDropdownMenuDelegate,UITextFieldDelegate {

    
   
    weak var delegate:OtaV3ImageFileInfoCellDelegate?
    let mainLabel = UILabel.init()
    let offsetTextField = UITextField.init()
    let menu = LMJDropdownMenu.init()
    
    private let options:[(SFOtaV3ImageID,String)] = [(.hcpu,"HCPU0"),(.lcpu, "LCPU1"),(.lcpuPatch, "LCPU_PATCH2"),(.norResOrNandPic,"norResOrNandPic3"),(.norFontOrNandFont,"norFontOrNandFont4"),(.norRootOrNandLang,"norRootOrNandLang5"),(.norOtaManagerOrNandRing,"norOtaManagerOrNandRing6"),(.norTinyFontOrNandRoot,"norTinyFontOrNandRoot7"),(.nandMusic,"nandMusic8"),(.nandDyn,"nandDyn9"),(.nandNym,"nandNym10")]
    
    var infos:OtaV3ImageFileItem?{
        didSet{
            self.mainLabel.text = infos?.fileUrl.lastPathComponent
            self.offsetTextField.text = infos?.hexOffset
            var menuContent = "选择文件类型"
            if let id = infos?.imageId{
                for opt in options {
                    if opt.0 == id {
                        menuContent = opt.1
                        break
                    }
                }
            }
            menu.title = menuContent
        }
    }
    
    init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1)
        
        mainLabel.textColor = .black
        mainLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(mainLabel)
        
        offsetTextField.textColor = .black;
        offsetTextField.font = UIFont.systemFont(ofSize: 12);
        offsetTextField.placeholder = "偏移";

//        offsetTextField.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        offsetTextField.delegate = self;
        self.contentView.addSubview(offsetTextField)
        
        menu.dataSource = self
        menu.delegate = self
        menu.layer.borderColor  = UIColor.white.cgColor;
        menu.layer.borderWidth  = 1;
        menu.layer.cornerRadius = 3;
        menu.title = "选择文件类型";
        menu.titleFont = UIFont.systemFont(ofSize: 10)
        menu.optionFont = UIFont.systemFont(ofSize: 10)
        menu.titleColor = .white
        menu.titleBgColor = .systemBlue
        menu.titleAlignment  = .left;
        
        menu.optionTextColor = .white
        menu.optionBgColor = .systemBlue
        menu.optionTextAlignment  = .center;
        self.contentView.addSubview(menu)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        relayout()
    }
    
    private func relayout(){
        mainLabel.sizeToFit()
        mainLabel.frame = CGRect.init(x: 10, y: 0, width: mainLabel.frame.size.width, height: mainLabel.frame.size.height)
//        mainLabel.center = CGPoint.init(x: mainLabel.center.x, y: self.contentView.frame.size.height/2.0)
        
        let top = mainLabel.frame.minY + mainLabel.frame.size.height;
        offsetTextField.sizeToFit()
        offsetTextField.frame = CGRect.init(x: 10, y:top, width: 80, height: 25)
        
        let menuSize = CGSize.init(width: 160, height: 30)
        menu.frame = CGRect.init(x: self.contentView.frame.width-10-menuSize.width, y: 0, width: menuSize.width, height: menuSize.height)
        menu.center = CGPoint.init(x: menu.center.x, y: self.contentView.frame.height/2.0)

    }
    
    func numberOfOptions(in menu: LMJDropdownMenu) -> UInt {
        return UInt(options.count)
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, heightForOptionAt index: UInt) -> CGFloat {
        return menu.frame.size.height
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, titleForOptionAt index: UInt) -> String {
        return options[Int(index)].1
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, didSelectOptionAt index: UInt, optionTitle title: String) {
        delegate?.otaV3ImageFileInfoCell(cell: self, selected: options[Int(index)].0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        self.infos?.hexOffset = textField.text;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= 8 // maxLength 是你设定的最大长度
    }
}
