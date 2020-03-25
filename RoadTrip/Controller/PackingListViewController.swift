//
//  PackingListViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 11/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

final class PackingListViewController: UIViewController {
        
    // MARK: - Outlets
    
    @IBOutlet weak var itemTableView: UITableView! {
        didSet { itemTableView.tableFooterView = UIView() }
    }
    
    // MARK: - Properties
    
    private var coreDataManager: CoreDataManager?
    private var tasksBeforeYouGo = [ItemEntity]()
    private var documents = [ItemEntity]()
    private var clothes = [ItemEntity]()
    private var accessories = [ItemEntity]()
    private var cosmetics = [ItemEntity]()
    private var health = [ItemEntity]()
    private var foodAndDrinks = [ItemEntity]()
    private var gadgets = [ItemEntity]()
    private var gamesAndRecreation = [ItemEntity]()
    private var books = [ItemEntity]()
    private var other = [ItemEntity]()
//    private var cellSelected: ItemEntity?
//    private let segueToAddItem = Constants.SegueToAddItem

    // MARK: - Actions
    
    @IBAction private func resetBarButtonItemTapped(_ sender: UIBarButtonItem) {
        coreDataManager?.deleteAllItems()
        itemTableView.reloadData()
        debugCoreDataItem(nameDebug: "All items deleted", coreDataManager: coreDataManager)
    }

    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cleanArrays()
        array()
        itemTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        array()
        coreDataFunction()
        let nib = UINib(nibName: Constants.PackingListTableViewCell, bundle: nil)
        itemTableView.register(nib, forCellReuseIdentifier: Constants.PackingListCell)
        itemTableView.reloadData()
        
        let headerNib = UINib(nibName: Constants.CustomTableViewHeaderCell, bundle: nil)
        itemTableView.register(headerNib, forCellReuseIdentifier: Constants.HeaderCell)
        itemTableView.reloadData()
    }
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    private func array() {
        let items = coreDataManager?.item ?? [ItemEntity]()
        for (index, item) in items.enumerated() {
            print("Found \(item) at position \(index)")
            if item.category == "Tasks before you go" {
                tasksBeforeYouGo.append(item)
            } else if item.category == "Documents" {
                documents.append(item)
            } else if item.category == "Clothes" {
                clothes.append(item)
            } else if item.category == "Accessories" {
                accessories.append(item)
            } else if item.category == "Cosmetics" {
                cosmetics.append(item)
            } else if item.category == "Health" {
                health.append(item)
            } else if item.category == "Food & Drinks" {
                foodAndDrinks.append(item)
            } else if item.category == "Gadgets" {
                gadgets.append(item)
            } else if item.category == "Games & Recreation" {
                gamesAndRecreation.append(item)
            } else if item.category == "Books" {
                books.append(item)
            } else if item.category == "Other" {
                other.append(item)
            }
        }
    }
    
    private func cleanArrays() {
        tasksBeforeYouGo = [ItemEntity]()
        documents = [ItemEntity]()
        clothes = [ItemEntity]()
        accessories = [ItemEntity]()
        cosmetics = [ItemEntity]()
        health = [ItemEntity]()
        foodAndDrinks = [ItemEntity]()
        gadgets = [ItemEntity]()
        gamesAndRecreation = [ItemEntity]()
        books = [ItemEntity]()
        other = [ItemEntity]()
    }
    
}

// MARK: - UITableViewDataSource

extension PackingListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoriesList.count
//        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        switch section {
        case 0:
            rowCount = tasksBeforeYouGo.count
//            rowCount = coreDataManager?.item.count ?? 0
        case 1:
            rowCount = documents.count
//            rowCount = coreDataManager?.item.count ?? 0
        case 2:
            rowCount = clothes.count
//            rowCount = coreDataManager?.item.count ?? 0
        case 3:
            rowCount = accessories.count
//            rowCount = coreDataManager?.item.count ?? 0
        case 4:
            rowCount = cosmetics.count
//            rowCount = coreDataManager?.item.count ?? 0
        case 5:
            rowCount = health.count
//            rowCount = coreDataManager?.item.count ?? 0
        case 6:
            rowCount = foodAndDrinks.count
//            rowCount = coreDataManager?.item.count ?? 0
        case 7:
            rowCount = gadgets.count
//            rowCount = coreDataManager?.item.count ?? 0
        case 8:
            rowCount = gamesAndRecreation.count
//            rowCount = coreDataManager?.item.count ?? 0
        case 9:
            rowCount = books.count
//            rowCount = coreDataManager?.item.count ?? 0
        case 10:
            rowCount = other.count
//            rowCount = coreDataManager?.item.count ?? 0
        default:
            rowCount = 0
        }
        return rowCount
//        return coreDataManager?.item.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(withIdentifier: Constants.PackingListCell,
                                                           for: indexPath) as? PackingListTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.section < categoriesList.count {
            let item = coreDataManager?.item[indexPath.row]
            itemCell.itemEntity = item
        }
        
        switch indexPath.section {
        case 0:
            let item = tasksBeforeYouGo[indexPath.row]
            itemCell.itemEntity = item
//            cell.textLabel?.text = meat[indexPath.row]
        case 1:
            let item = documents[indexPath.row]
            itemCell.itemEntity = item
//            cell.textLabel?.text = fruit[indexPath.row]
        case 2:
            let item = clothes[indexPath.row]
            itemCell.itemEntity = item
//            cell.textLabel?.text = vegetable[indexPath.row]
        case 3:
            let item = accessories[indexPath.row]
            itemCell.itemEntity = item
        case 4:
            let item = cosmetics[indexPath.row]
            itemCell.itemEntity = item
        case 5:
            let item = health[indexPath.row]
            itemCell.itemEntity = item
        case 6:
            let item = foodAndDrinks[indexPath.row]
            itemCell.itemEntity = item
        case 7:
            let item = gadgets[indexPath.row]
            itemCell.itemEntity = item
        case 8:
            let item = gamesAndRecreation[indexPath.row]
            itemCell.itemEntity = item
        case 9:
            let item = books[indexPath.row]
            itemCell.itemEntity = item
        case 10:
            let item = other[indexPath.row]
            itemCell.itemEntity = item
        default:
            itemCell.textLabel?.text = "Other"
        }
        
        // before section
//        let item = coreDataManager?.item[indexPath.row]
//        itemCell.itemEntity = item

        return itemCell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.cellSelected = coreDataManager?.item[indexPath.row]
//
////        celluleActive = true
////        celluleIndex = indexPath.row
////        performSegue(withIdentifier: self.segueToAddItem, sender: self)
//    }

}

// MARK: - UITableViewDelegate

extension PackingListViewController: UITableViewDelegate {
    
    /// delete a row in tableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = coreDataManager?.item[indexPath.row]
            coreDataManager?.deleteItem(itemName: item?.itemName ?? "")
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        itemTableView.reloadData()
        debugCoreDataItem(nameDebug: "The item is deleted", coreDataManager: coreDataManager)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let  headerCell = tableView.dequeueReusableCell(withIdentifier: Constants.HeaderCell) as? CustomTableViewHeaderCell else {
            return UITableViewCell()
        }
        headerCell.backgroundColor = UIColor.gray
        
        if section < categoriesList.count {
            headerCell.headerLabel.text = categoriesList[section]
        }
        
//        switch section {
//        case 0:
//            headerCell.headerLabel.text = categoriesList[section]
//        case 1:
//            headerCell.headerLabel.text = "Fruit"
//        case 2:
//            headerCell.headerLabel.text = "Vegetable"
//        default:
//            headerCell.headerLabel.text = "Other"
//        }
        
        return headerCell
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        let label = UILabel()
//        view.addSubview(label)
//        label.bindEdgesToSuperview()
//        label.backgroundColor = #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1)
//        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
//        label.textColor = #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 1)
//
//        if section < categoriesList.count {
//            label.text = categoriesList[section]
//        }
//        return view
//    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Click on ➕ to add an item"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return coreDataManager?.item.isEmpty ?? true ? 50 : 0
    }
}

// MARK: - Navigation

//extension PackingListViewController {
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == segueToAddItem {
//            guard let addItemVC = segue.destination as? AddItemViewController else { return }
//            addItemVC.cellule = self.cellSelected
////            if celluleActive {
////                addDetailsMyTripVC.celluleActive = true
////                addDetailsMyTripVC.celluleIndex = celluleIndex
////            } else {
////                addDetailsMyTripVC.celluleActive = false
////            }
////            print("prepare segue celluleActive : \(celluleActive)")
////            print("prepare segue celluleIndex : \(celluleIndex)")
//
//        }
//    }
//}
