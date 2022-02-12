//
//  UserTableViewCell.swift
//  UserDataApp
//
//  Created by Datt Patel on 12/02/22.
//

import UIKit
import SnapKit
import UserDataAppBase

class UserTableViewCell: UITableViewCell {

    static let cellId = "UserTableViewCell"
    let userImageView = UIImageView()
    let userNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func commonInit() {
        accessoryType = .disclosureIndicator
        
        userImageView.contentMode = .scaleAspectFill
        userImageView.isCircle = true
        contentView.addSubview(userImageView)
        
        userNameLabel.font = Font.poppinsTextMedium.withSize(20)
        contentView.addSubview(userNameLabel)
        
        userImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(self.contentView).offset(16)
            make.height.width.equalTo(50)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(16)
            make.trailing.equalTo(self.contentView).offset(16)
            make.centerY.equalTo(self.contentView)
        }
        
    }
    
   

}
