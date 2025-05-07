import UIKit

class BaseSearchVC: UIViewController {
    
    
    private let topView:UIView = UIView.init()
    
    let backButton = UIButton.init()
    
    let sortButton:UIButton = UIButton.init()
    
    let restartButton:UIButton = UIButton.init()
    
    let stopButton = UIButton.init()
    
    let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.topView.backgroundColor = .lightGray
        self.view.addSubview(topView);
        
        
        setupTopButton(button: backButton, title: "back")
        backButton.addTarget(self, action: #selector(clickBackBtn(button:)), for: .touchUpInside)
        self.topView.addSubview(backButton)
                
        setupTopButton(button: self.sortButton, title: "sort")
        sortButton.addTarget(self, action: #selector(clickSortBtn(button:)), for: .touchUpInside)
        self.topView.addSubview(self.sortButton)
        
        setupTopButton(button: self.restartButton, title: "restart")
        restartButton.addTarget(self, action: #selector(clickRestartBtn(button:)), for: .touchUpInside)
        self.topView.addSubview(self.restartButton)
        
        setupTopButton(button: self.stopButton, title: "stop")
        stopButton.addTarget(self, action: #selector(clickStopBtn(button:)), for: .touchUpInside)
        self.topView.addSubview(self.stopButton)
        
        self.tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = true
        self.view.addSubview(tableView)
        
        let topViewW = self.view.frame.width
        let topViewH:CGFloat = 100
        let btnW:CGFloat = 60
        let btnH:CGFloat = 44
        let btnY = topViewH - btnH
        let btnMargin:CGFloat = 50
        self.topView.frame = CGRect.init(x: 0, y: 0, width: topViewW, height: topViewH)
        self.backButton.frame = CGRect.init(x: 0, y: btnY, width: 50, height: btnH)
        
        self.stopButton.frame = CGRect.init(x: topViewW - btnW, y: btnY, width: btnW, height: btnH)
        self.restartButton.frame = CGRect.init(x: stopButton.frame.midX-btnMargin-btnW, y: btnY, width: btnW, height: btnH)
        self.sortButton.frame = CGRect.init(x: restartButton.frame.midX-btnMargin-btnW, y: btnY, width: btnW, height: btnH)
        
        
        self.tableView.frame = CGRect.init(x: 0, y: topViewH, width: topViewW, height: self.view.frame.height-topViewH)
        
    }
    
    private func setupTopButton(button:UIButton,title:String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 15)
    }
    
    
    @objc private func clickBackBtn(button:UIButton) {
        self.clickBack()
    }
    
    
    @objc private func clickSortBtn(button:UIButton) {
        self.clickSort()
    }
    
    @objc private func clickRestartBtn(button:UIButton) {
        self.clickRestart()
    }
    
    @objc private func clickStopBtn(button:UIButton) {
        self.clickStop()
    }
    
    
    func clickBack(){
        
    }
    func clickSort(){
        
    }
    
    func clickRestart(){
        
    }
    
    func clickStop(){
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
