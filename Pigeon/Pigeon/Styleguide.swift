//
//  Styleguide.swift
//  Pigeon
//
//  Created by Wanting Huang on 3/14/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

//Font
class HeaderTitle: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.font = UIFont(name: "Monstserrat.ttf", size: 12)
    }
    
    override func prepareForInterfaceBuilder() {
        commonInit()
    }
}

//Dash border
class DashedBorderView: UIView {
    
    var border: CAShapeLayer!
    let tealColor: UIColor = UIColor(red: 111/256, green: 188/256, blue: 196/256, alpha: 1) //#6FBCC4, 111 188 196
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        border = CAShapeLayer()
        
        border.strokeColor =  tealColor.CGColor
        border.fillColor = UIColor.clearColor().CGColor
        border.lineDashPattern = [4, 4]
        self.layer.addSublayer(border)
        
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:0).CGPath
        border.frame = self.bounds
    }
    
    override func prepareForInterfaceBuilder() {
        self.layoutSubviews()
    }
}


