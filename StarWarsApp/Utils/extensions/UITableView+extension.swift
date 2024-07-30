//
//  tableViewExtension.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import Foundation
import UIKit
extension UITableView{
    func registerNib<Cell:UITableViewCell>(cell:Cell.Type){
        let nibName=String(describing: Cell.self)
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    func dequeueNibCell<Cell:UITableViewCell>(cellClass:Cell.Type)->Cell{
        let identifier=String(describing: Cell.self)
        let cell = self.dequeueReusableCell(withIdentifier: identifier) as! Cell
        return cell
    }
}
