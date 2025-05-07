import UIKit

class QProgressBar: UIView {
    
    public var progress:CGFloat = 0.0{
        didSet{
            currentRatio = progress
        }
    }
    
    private let backgroundBar = UIView.init()
    private let fillBar = UIView.init()
    private let ratioLabel = UILabel.init()
    
    private var linker:CADisplayLink!
    
    private var currentRatio:CGFloat = 0.0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        linker = CADisplayLink.init(target: self, selector: #selector(refreshCurrentRatio))
        linker.add(to: RunLoop.main, forMode: .default)
        
        ratioLabel.font = UIFont.systemFont(ofSize: 12)
        ratioLabel.textAlignment = .right
        ratioLabel.textColor = .black
        self.addSubview(ratioLabel)
        
        backgroundBar.backgroundColor = .lightGray
        self.addSubview(backgroundBar)
        
        fillBar.backgroundColor = .systemBlue
        backgroundBar.addSubview(fillBar)
        
        relayout()
        refreshCurrentRatio()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect{
        didSet{
            relayout()
        }
    }
    
    
    @objc private func refreshCurrentRatio(){
        let rect =  CGRect.init(x: 0, y: 0, width: backgroundBar.frame.width*currentRatio, height: backgroundBar.frame.height)
        if rect.width.isNaN {
            return
        }
        fillBar.frame = rect
        ratioLabel.text = String.init(format: "%.2f%%", currentRatio*100)
    }
    
    
    private func relayout(){
        let labelW:CGFloat = 60
        ratioLabel.frame = CGRect.init(x: self.frame.width-labelW, y: 50, width: labelW, height: 20)
        ratioLabel.center = CGPoint.init(x: ratioLabel.center.x, y: self.frame.height/2.0)
        
        backgroundBar.frame = CGRect.init(x: 0, y: 0, width: self.frame.width-labelW, height: self.frame.height)
        backgroundBar.center = CGPoint.init(x: backgroundBar.center.x, y: self.frame.height/2.0)
        backgroundBar.layer.cornerRadius = backgroundBar.frame.height/2.0
        backgroundBar.layer.masksToBounds = true
        
        let rect = CGRect.init(x: 0, y: 0, width: backgroundBar.frame.width*currentRatio, height: backgroundBar.frame.height)
        if rect.width.isNaN {
            return
        }
        fillBar.frame = rect
        fillBar.layer.cornerRadius = fillBar.frame.height/2.0
        fillBar.layer.masksToBounds = true
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
