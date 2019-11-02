//
//  CardView.swift
//  TinderViewCard
//
//  Created by Zhaoming Qin on 11/1/19.
//  Copyright © 2019 Zhaoming. All rights reserved.
//

import UIKit

class CardView: UIView {

    @IBOutlet weak var jobDescriptionTextView: UITextView!
    @IBOutlet var view: UIView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        self.addSubview(self.view)
    }
    
}
