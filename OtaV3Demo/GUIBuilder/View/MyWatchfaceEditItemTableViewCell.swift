//
//  MyWatchfaceEditItemTableViewCell.swift
//  SFIntegration
//
//  Created by Sean on 2026/2/26.
//

import UIKit

protocol MyWatchfaceEditItemTableViewCellDelegate:NSObjectProtocol {
    func MyWatchfaceEditItemTableViewCellOnEdit(cell:MyWatchfaceEditItemTableViewCell,model:MyWatchfaceEditItem);
    func MyWatchfaceEditItemTableViewCellOnSend(cell:MyWatchfaceEditItemTableViewCell,model:MyWatchfaceEditItem);
    func MyWatchfaceEditItemTableViewCellOnDel(cell:MyWatchfaceEditItemTableViewCell,model:MyWatchfaceEditItem);
}

class MyWatchfaceEditItemTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var originImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    private var model:MyWatchfaceEditItem?
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var delBtn: UIButton!
    weak var delegate:MyWatchfaceEditItemTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.sendBtn.contentEdgeInsets = UIEdgeInsets.zero;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onEditBtnTouch(_ sender: Any) {
        self.delegate?.MyWatchfaceEditItemTableViewCellOnEdit(cell: self, model: self.model!)
    }
    
    @IBAction func onSendBtnTouch(_ sender: Any) {
        self.delegate?.MyWatchfaceEditItemTableViewCellOnSend(cell: self, model: self.model!)
    }
    
    @IBAction func onDelBtnTouch(_ sender: Any) {
        self.delegate?.MyWatchfaceEditItemTableViewCellOnDel(cell: self, model: self.model!)
    }
    
    public func updateUI(model:MyWatchfaceEditItem){
        self.model = model;
        self.nameLabel.text = model.editItem.controlId;
        self.originImage.image = model.editItem.originImage;
        self.userImage.image = model.editItem.patchImage;
    }
    
}
