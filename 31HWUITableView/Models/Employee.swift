//
//  Employee.swift
//  31HWUITableView
//
//  Created by Сергей on 05.02.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation
import UIKit

class Employee {
    
    //MARK: Properties
    var name: String
    var surname: String
    var salary: CGFloat
    var email: String
    
    //MARK: Prinate Properties
    private let colorBronze = UIColor(red: 0.8039, green: 0.498, blue: 0.1961, alpha: 1)
    private let colorSilver = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
    private let colorGold   = UIColor(red: 0.700, green: 0.238, blue: 0.101, alpha: 1)
    
    //MARK: Static Properties
    static let firstNames = ["Tran",    "Lenore",    "Bud",     "Fredda",   "Katrice",
                            "Clyde",   "Hildegard", "Vernell", "Nellie",   "Rupert",
                            "Billie",  "Tamica",    "Crystle", "Kandi",    "Caridad",
                            "Vanetta", "Taylor",    "Pinkie",  "Ben",      "Rosanna",
                            "Eufemia", "Britteny",  "Ramon",   "Jacque",   "Telma",
                            "Colton",  "Monte",     "Pam",     "Tracy",    "Tresa",
                            "Willard", "Mireille",  "Roma",    "Elise",    "Trang",
                            "Ty",      "Pierre",    "Floyd",   "Savanna",  "Arvilla",
                            "Whitney", "Denver",    "Norbert", "Meghan",   "Tandra",
                            "Jenise",  "Brent",     "Elenor",  "Sha",      "Jessie"]

    
    static let lastNames = ["Farrah",       "Heal",         "Heal",      "Sechrest",  "Roots",
                            "Homan",        "Starns",       "Oldham",    "Yocum",     "Mancia",
                            "Prill",        "Lush",         "Piedra",    "Lenz",      "Warnock",
                            "Vanderlinden", "Simms",        "Gilroy",    "Brann",     "Bodden",
                            "Lenz",         "Gildersleeve", "Wimbish",   "Bello",     "Beachy",
                            "Jurado",       "William",      "Beaupre",   "Dyal",      "Doiron",
                            "Plourde",      "Bator",        "Krause",    "Odriscoll", "Corby",
                            "Waltman",      "Michaud",      "Kobayashi", "Sherrick",  "Woolfolk",
                            "Holladay",     "Hornback",     "Moler",     "Bowles",    "Libbey",
                            "Spano",        "Folso" ,       "Wimbish",   "Plourde",   "Beachy"]
    
    static let namesCount = 50
    
    static let maxSalary = 8000
    static let minSalary = 500
    
    var socialGoupType: SocialGroupType {
        var resultGroup: SocialGroupType?
        
        switch salary {
        case 0.0...999.9:
            resultGroup = .poor
        case 1000...2999.9:
            resultGroup = .average
        case 3000...:
            resultGroup = .rich
        default:
            break
        }
        return resultGroup ?? .rich
    }
    
    var color: UIColor {
        var resultColor = UIColor()
        
        switch socialGoupType {
        case .poor:
            resultColor = colorBronze
        case .average:
            resultColor = colorSilver
        case .rich:
            resultColor = colorGold
        }
        return resultColor
    }
    
    init() {
        name = ""
        surname = ""
        salary = 0.0
        email = ""
    }
    
    init(name: String, surname: String, salary: CGFloat, email: String) {
        
        self.name = name
        self.surname = surname
        self.salary = salary
        self.email = email
    
    }
    //create random Employees sorted by salary
    
    static func randomEmployee() -> Employee {
        
        let employee = Employee()
        employee.name = firstNames[Int.random(in: 0..<Employee.namesCount)]
        employee.surname = lastNames[Int.random(in: 0..<Employee.namesCount)]
        employee.salary = CGFloat(Int(arc4random()) % maxSalary + minSalary)
        employee.email = "\(employee.surname)\(employee.name)" + "@dog.booth"
        
        return employee
    }
    
    static func randomEmployees(sortedBy type: SortType) -> [Employee] {
        var employees = [Employee]()
        
        for _ in 0..<Employee.namesCount {
            
            let employee = Employee()
            employee.name = Employee.firstNames[Int(arc4random()) % Employee.namesCount]
            employee.surname = Employee.lastNames[Int(arc4random()) % Employee.namesCount]
            employee.salary = CGFloat(Int(arc4random()) % maxSalary + minSalary)
            employee.email = "\(employee.surname)\(employee.name)" + "@dog.booth"
            employees.append(employee)
            
        }
        
        employees.sort { (firstEmployee, secondEmployee) -> Bool in
            return type == .increase ? firstEmployee.salary < secondEmployee.salary :
                                       firstEmployee.salary > secondEmployee.salary
        }

        return employees
    }
    
    
    
    func description() {
        
        print("name: \(name), surname: \(surname), salary: \(salary), email: \(email)")
        
    }

}
