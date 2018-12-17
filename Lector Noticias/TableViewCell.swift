//
//  TableViewCell.swift
//  Lector Noticias
//
//  Created by Dev1 on 14/12/2018.
//  Copyright © 2018 Dev1. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

   @IBOutlet weak var tituloRSS: UILabel!
   @IBOutlet weak var textoRSS: UILabel!
   @IBOutlet weak var autorRSS: UILabel!
   @IBOutlet weak var fechaRSS: UILabel!
   @IBOutlet weak var imagenRSS: UIImageView?
   
   
   override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
