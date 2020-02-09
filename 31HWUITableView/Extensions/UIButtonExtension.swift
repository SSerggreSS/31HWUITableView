//
//  UIButtonExtension.swift
//  31HWUITableView
//
//  Created by Сергей on 09.02.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func setup(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, title: String, color: UIColor, cornerRadius: CGFloat) {
        
        frame = CGRect(x: x, y: y, width: width, height: height)
        setTitle(title, for: .normal)
        backgroundColor = color
        layer.cornerRadius = cornerRadius
        
    }
    
}
