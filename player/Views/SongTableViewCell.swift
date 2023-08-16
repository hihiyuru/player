//
//  SongTableViewCell.swift
//  player
//
//  Created by 徐于茹 on 2023/8/9.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var collectButton: UIButton!
    @IBOutlet weak var listeningAcountLabel: UILabel!
    @IBOutlet weak var epNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
