//
//  CelulaFinanceiroDetalheTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 06/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import UIKit
class CelulaFinanceiroDetalheTableViewCell : UITableViewCell {
    @IBOutlet weak var mes: UILabel!
    @IBOutlet weak var pedido: UILabel!
    @IBOutlet weak var valor: UILabel!
    
    override func awakeFromNib() {
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
