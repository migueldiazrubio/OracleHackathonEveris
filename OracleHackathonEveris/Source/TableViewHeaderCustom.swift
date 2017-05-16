//
//  TableViewHeaderCustom.swift
//  OracleHackathonEveris
//
//  Created by Paul Alava Doncel on 16/5/17.
//  Copyright © 2017 everis. All rights reserved.
//

import UIKit

class TableViewHeaderCustom: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class func instanceFromNib() -> TableViewHeaderCustom {
        return UINib(nibName: "TableViewHeaderCustom", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TableViewHeaderCustom
    }

}
