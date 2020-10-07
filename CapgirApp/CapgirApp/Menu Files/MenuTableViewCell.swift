//
//  MenuTableViewCell.swift
//  CapgirApp
//
//  Created by Laura Homet Garcia on 29/08/2020.
//  Copyright © 2020 LauraHomet. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureMenu(menu:MenuOption){
        menuLabel.text = menu.text
        menuImage.image = UIImage(named: menu.imageName)
    }

}
