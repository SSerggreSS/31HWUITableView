//
//  SocialGroup.swift
//  31HWUITableView
//
//  Created by Сергей on 05.02.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation

class SocialGroup {
    
    var name: String
    var employees: [Employee]
    
    static var namesGroups = ["Poor", "Average", "Rich"]
   
    init(name: String, employees: [Employee]) {
        self.name = name
        self.employees = employees
    }
    
    convenience init(name: String) {
        self.init(name: name, employees: [Employee]())
       
    }
    
}
