//
//  CustomViewController.swift
//  31HWUITableView
//
//  Created by Сергей on 05.02.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import UIKit

final class CustomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   //MARK: Private Property
    
   private var tableView: UITableView!
   private var editButton: UIBarButtonItem!
   private var addButton: UIBarButtonItem!
   private var sortBySurnameButton = UIButton()
   private let sortBySalaryButton = UIButton()
   private var userDefault = UserDefaults()
   private var groups = [SocialGroup]()
   private var employees = [Employee]()
   private let lowSalary: CGFloat = 1000.0
   private let upperSalary: CGFloat = 3000.0
   private let countOfAdditionalRows = 1
   private let indexRowForAddButton = 0
 
   private let colorBronze = UIColor(red: 0.8039, green: 0.498, blue: 0.1961, alpha: 1)
   private let colorSilver = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
   private let colorGold   = UIColor(red: 0.700, green: 0.238, blue: 0.101, alpha: 1)

    //MARK: Life Cyrcle
    
    override func loadView() {
        super.loadView()
        
        initializationTableView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createRightAndLeftBarButtonsItems()
        employees = Employee.randomEmployees(sortedBy: .increase)
        initializationSocialGroups()
        initializationSortBySurnameButton()
        initializationSortBySalaryButton()
        
        self.tableView.reloadData()
    }
    
    //MARK: UITableViewDelegate
     
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {

        return indexPath.row > indexRowForAddButton
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            if !groups[indexPath.section].employees.isEmpty {
                groups[indexPath.section].employees.remove(at: indexPath.row - countOfAdditionalRows)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                groups.remove(at: indexPath.section)
                let deleteSectionIndexSet = IndexSet(arrayLiteral: indexPath.section)
                tableView.deleteSections(deleteSectionIndexSet, with: .fade)
            }
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == indexRowForAddButton {
            let group = groups[indexPath.section]
            group.employees.insert(Employee.randomEmployee(), at: 0)
            
            tableView.insertRows(at: [IndexPath(row: countOfAdditionalRows, section: indexPath.section)], with: .left)

        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {

        return proposedDestinationIndexPath.row == indexRowForAddButton ? sourceIndexPath : proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        
        
        return indexPath.row == indexRowForAddButton && !groups[indexPath.section].employees.isEmpty ? .none : .delete
    }
    
    //MARK: UITableViewDataSource
    //кол-во секций
    func numberOfSections(in tableView: UITableView) -> Int {
    
        return groups.count
    }
    //название секции
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return groups[section].name
    }
    //кол-во рядов в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groups[section].employees.count + countOfAdditionalRows
    }
    //настроить ячейку по по индексу ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        if indexPath.row == indexRowForAddButton {
            
        let identNewEmployee = "indentifierAddEmployee"
        var cell = tableView.dequeueReusableCell(withIdentifier: identNewEmployee)
        cell = cell ?? UITableViewCell(style: .default, reuseIdentifier: identNewEmployee)
        cell?.textLabel?.text = "Add New Employee"
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.textColor = .blue
            
        return cell ?? UITableViewCell()
        } else {
        
        let indentifierEmployeeCell = "indentifierEmployeeCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: indentifierEmployeeCell)
        cell = cell ?? UITableViewCell(style: .subtitle, reuseIdentifier: indentifierEmployeeCell)
    
        let group = groups[indexPath.section]
        let employee = group.employees[indexPath.row - countOfAdditionalRows]
        let textForLabelCell = "\(employee.surname) \(employee.name), em-l: \(employee.email)"
        let textForDetailLabel = "\(employee.salary) 💵"
        cell?.textLabel?.text = textForLabelCell
        cell?.detailTextLabel?.text = textForDetailLabel
        cell?.textLabel?.textColor = employee.color
        cell?.detailTextLabel?.textColor = employee.color
        cell?.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
        cell?.detailTextLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)

        return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let group = groups[sourceIndexPath.section]
        let removedEmployee = group.employees.remove(at: sourceIndexPath.row - countOfAdditionalRows)
        groups[destinationIndexPath.section].employees.insert(removedEmployee,
                                                              at: destinationIndexPath.row - countOfAdditionalRows)

    }
    
    //MARK: Selectors
    
    @objc private func actionEdit(sender: UIBarButtonItem) {
        
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        var item = UIBarButtonItem.SystemItem.edit
        if tableView.isEditing {
            item = .done
        }
        
        editButton = UIBarButtonItem(barButtonSystemItem: item, target: self, action: #selector(actionEdit(sender:)))
        navigationItem.setRightBarButton(editButton, animated: true)
        
    }
    
    @objc private func addSectionAction() {
        
        if !tableView.isEditing {

            let newGroup = SocialGroup(name: "New Group - \(groups.count + 1)",
                                       employees: [Employee]())
            let newSectionIndex = 0
            self.groups.insert(newGroup, at: newSectionIndex)
            
            let insertIndex = NSIndexSet(index: newSectionIndex) as IndexSet
            tableView.insertSections(insertIndex, with: .left)
            
        }
    }
    
    @objc private func sortEmployeeBySurname() {
        
        for i in 0..<groups.count {
            groups[i].employees.sort { (emp1, emp2) -> Bool in
                return emp1.surname < emp2.surname
            }
        }
        
        tableView.reloadData()
    }
    
    @objc private func sortEmployeeBySalary() {
    
    for i in 0..<groups.count {
        groups[i].employees.sort { (emp1, emp2) -> Bool in
            return emp1.salary < emp2.salary
            }
        }
        
        tableView.reloadData()
    }

    //MARK: Initialization properties

    private func initializationTableView() {
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0,
                                                  width: view.bounds.width,
                                                  height: view.bounds.height),
                                    style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
        self.tableView = tableView
        
    }
    
    private func initializationSocialGroups() {
        
        for groupName in SocialGroup.namesGroups {
            
            let socialGroup = SocialGroup(name: groupName)
            
            for employee in employees {
                
                switch employee.salary {
                case 0..<lowSalary where groupName == "Poor":
                    socialGroup.employees.append(employee)
                case lowSalary..<upperSalary where groupName == "Average":
                    socialGroup.employees.append(employee)
                case upperSalary... where groupName == "Rich":
                    socialGroup.employees.append(employee)
                default:
                    break
                }
            }
            
            groups.append(socialGroup)
        }
    }
    
    private func initializationSortBySurnameButton() {
        
        let widthButton = view.bounds.width / 2 - 30
        
        sortBySurnameButton.setup(x: view.bounds.midX + 10, y: view.bounds.maxY - 70 ,
                                  width: widthButton, height: 50,
                                  title: "Sort By Surname", color: .green, cornerRadius: 20)
        sortBySurnameButton.setTitleColor(.blue, for: .highlighted)
        sortBySurnameButton.addTarget(self, action: #selector(sortEmployeeBySurname), for: .touchUpInside)
        view.addSubview(sortBySurnameButton)
        
    }
    
    private func initializationSortBySalaryButton() {
        
        let widthButton = view.bounds.width / 2 - 30
        
        sortBySalaryButton.setup(x: view.bounds.midX - widthButton - 10, y: view.bounds.maxY - 70,
                                  width: widthButton, height: 50,
                                  title: "Sort By Salary", color: .orange, cornerRadius: 20)
        sortBySalaryButton.setTitleColor(.blue, for: .highlighted)
        sortBySalaryButton.addTarget(self, action: #selector(sortEmployeeBySalary), for: .touchDown)
        view.addSubview(sortBySalaryButton)
    }

    //MARK: BarButtonItems
    private func createRightAndLeftBarButtonsItems() {
           
           editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(actionEdit))
           addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSectionAction))
           navigationItem.rightBarButtonItem = editButton
           navigationItem.leftBarButtonItem = addButton
           navigationItem.title = "Social Group"
           
       }
    
}

