import UIKit

let Edge_Horizon:CGFloat = 3

let Edge_Vertical:CGFloat = 5

class ConsoleCell: UITableViewCell {
    
    let label:UILabel = UILabel.init()
    
    var message:String?{
        didSet{
            label.text = message
            _relayout()
        }
    }
    
    
    
    init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        initialUI()
    }
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialUI()
    }
    
    
    static func CellHeight (cellWidth:CGFloat,message:String?) -> CGFloat {
        let tempLabel = UILabel.init()
        ConsoleCell._setup(l: tempLabel)
        tempLabel.text = message
        let fitSize = tempLabel.sizeThatFits(CGSize.init(width: (cellWidth - Edge_Vertical*2), height: CGFloat(MAXFLOAT)))
        return (fitSize.height + Edge_Vertical * 2)
    }
    
    private func initialUI(){
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        ConsoleCell._setup(l: label)
        self.contentView.addSubview(label)
    }
    

    private static func _setup(l:UILabel){
        l.font = UIFont.systemFont(ofSize: 10)
        l.textColor = UIColor.white
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
    }

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _relayout()
    }
    
    
    private func _relayout(){
        let w = self.contentView.frame.size.width - Edge_Horizon*2
        let h = self.contentView.frame.size.height - Edge_Vertical * 2
        label.bounds = CGRect.init(x: 0, y: 0, width: w, height: h)
        label.center = CGPoint.init(x: self.contentView.frame.size.width/2.0, y: self.contentView.frame.size.height/2.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
