//
//  Styleguide.swift
//  Pigeon
//
//  Created by Wanting Huang on 3/14/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

class HeaderTitle: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.font = UIFont(name: "Helvetica.ttf", size: 13)
    }
    
    override func prepareForInterfaceBuilder() {
        commonInit()
    }
}

