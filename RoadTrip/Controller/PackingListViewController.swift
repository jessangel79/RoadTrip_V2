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
    
//    private let segueToAddItem = Constants.SegueToAddItem
    
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
//    private var allArrays = [[ItemEntity]]()

    // MARK: - Actions
    
    @IBAction private func resetBarButtonItemTapped(_ sender: UIBarButtonItem) {
        if !(coreDataManager?.item.isEmpty ?? false) {
            showAlertResetAll()
        }
    }

    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        cleanArrays()
//        array()
        print("viewWillAppear :")
//        debugArray()
        itemTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
        let nib = UINib(nibName: Constants.PackingListTableViewCell, bundle: nil)
        itemTableView.register(nib, forCellReuseIdentifier: Constants.PackingListCell)
//        let headerNib = UINib(nibName: Constants.CustomTableViewHeaderCell, bundle: nil)
//        itemTableView.register(headerNib, forCellReuseIdentifier: Constants.HeaderCell)
        itemTableView.reloadData()
    }
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    fileprivate func debugArray() {
        print("arrays => tasksBeforeYouGo: \(tasksBeforeYouGo) documents: \(documents) clothes: \(clothes) accessories :\(accessories)")
        print("cosmetics: \(cosmetics) health: \(health) foodAndDrinks: \(foodAndDrinks) gadgets: \(gadgets)")
        print("gamesAndRecreation: \(gamesAndRecreation) books: \(books) other: \(other)")
        print("\n")
//        print("allArrays: \(allArrays)")
//        print("\n")
    }
    
    private func array() {
        let items = coreDataManager?.item ?? [ItemEntity]()
        for item in items {
            switch item.category {
            case categoriesList[0]:
                tasksBeforeYouGo.append(item)
//                allArrays.append(tasksBeforeYouGo)
            case categoriesList[1]:
                documents.append(item)
//                allArrays.append(documents)
            case categoriesList[2] :
                clothes.append(item)
//                allArrays.append(clothes)
            case categoriesList[3]:
                accessories.append(item)
//                allArrays.append(accessories)
            case categoriesList[4]:
                cosmetics.append(item)
//                allArrays.append(cosmetics)
            case categoriesList[5]:
                health.append(item)
//                allArrays.append(health)
            case categoriesList[6]:
                foodAndDrinks.append(item)
//                allArrays.append(foodAndDrinks)
            case categoriesList[7]:
                gadgets.append(item)
//                allArrays.append(gadgets)
            case categoriesList[8]:
                gamesAndRecreation.append(item)
//                allArrays.append(gamesAndRecreation)
            case categoriesList[9]:
                books.append(item)
//                allArrays.append(books)
            case categoriesList[10]:
                other.append(item)
//                allArrays.append(other)
            default:
                break
            }
        }
//        print("func array() :")
//        debugArray()
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
//        allArrays = [[ItemEntity]]()
    }
    
    private func cleanArray(item: ItemEntity) {
//        let items = coreDataManager?.item ?? [ItemEntity]()
//        for item in items {
            switch item.category {
            case categoriesList[0]:
//                tasksBeforeYouGo = tasksBeforeYouGo.removing(item)
                tasksBeforeYouGo.remove(item)
            case categoriesList[1]:
//                documents = documents.removing(item)
                documents.remove(item)
            case categoriesList[2] :
//                clothes = clothes.removing(item)
                clothes.remove(item)
            case categoriesList[3]:
//                accessories = accessories.removing(item)
                accessories.remove(item)
            case categoriesList[4]:
//                cosmetics = cosmetics.removing(item)
                cosmetics.remove(item)
            case categoriesList[5]:
//                health = health.removing(item)
                health.remove(item)
            case categoriesList[6]:
//                foodAndDrinks = foodAndDrinks.removing(item)
                foodAndDrinks.remove(item)
            case categoriesList[7]:
//                gadgets = gadgets.removing(item)
                gadgets.remove(item)
            case categoriesList[8]:
//                gamesAndRecreation = gamesAndRecreation.removing(item)
                gamesAndRecreation.remove(item)
            case categoriesList[9]:
//                books = books.removing(item)
                books.remove(item)
            case categoriesList[10]:
//                other = other.removing(item)
                other.remove(item)
            default:
                break
            }
        print("func array => Item : \(item) is deleted")
//        }
    }
        
    private func resetAll() {
        coreDataManager?.deleteAllItems()
        cleanArrays()
        itemTableView.reloadData()
        debugCoreDataItem(nameDebug: "All items deleted", coreDataManager: coreDataManager)
    }
    
    private func showAlertResetAll() {
        let destructiveAction = UIAlertAction(title: "Reset all", style: .destructive, handler: { action in
            self.resetAll()
        })
        showResetAlert(destructiveAction: destructiveAction)
    }
}

// MARK: - UITableViewDataSource

extension PackingListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        return categoriesList.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var rowCount = 0
//        switch section {
//        case 0:
//            rowCount = tasksBeforeYouGo.count
//        case 1:
//            rowCount = documents.count
//        case 2:
//            rowCount = clothes.count
//        case 3:
//            rowCount = accessories.count
//        case 4:
//            rowCount = cosmetics.count
//        case 5:
//            rowCount = health.count
//        case 6:
//            rowCount = foodAndDrinks.count
//        case 7:
//            rowCount = gadgets.count
//        case 8:
//            rowCount = gamesAndRecreation.count
//        case 9:
//            rowCount = books.count
//        case 10:
//            rowCount = other.count
//        default:
//            rowCount = 0
//        }
//        return rowCount
        
        return coreDataManager?.item.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(withIdentifier: Constants.PackingListCell,
                                                           for: indexPath) as? PackingListTableViewCell else {
            return UITableViewCell()
        }
        
//        switch indexPath.section {
//        case 0:
//            let item = tasksBeforeYouGo[indexPath.row]
//            itemCell.itemEntity = item
//        case 1:
//            let item = documents[indexPath.row]
//            itemCell.itemEntity = item
//        case 2:
//            let item = clothes[indexPath.row]
//            itemCell.itemEntity = item
//        case 3:
//            let item = accessories[indexPath.row]
//            itemCell.itemEntity = item
//        case 4:
//            let item = cosmetics[indexPath.row]
//            itemCell.itemEntity = item
//        case 5:
//            let item = health[indexPath.row]
//            itemCell.itemEntity = item
//        case 6:
//            let item = foodAndDrinks[indexPath.row]
//            itemCell.itemEntity = item
//        case 7:
//            let item = gadgets[indexPath.row]
//            itemCell.itemEntity = item
//        case 8:
//            let item = gamesAndRecreation[indexPath.row]
//            itemCell.itemEntity = item
//        case 9:
//            let item = books[indexPath.row]
//            itemCell.itemEntity = item
//        case 10:
//            let item = other[indexPath.row]
//            itemCell.itemEntity = item
//        default:
//            itemCell.textLabel?.text = ""
//        }
        
        // before section
        let item = coreDataManager?.item[indexPath.row]
        itemCell.itemEntity = item

        return itemCell
    }
}

// MARK: - UITableViewDelegate

extension PackingListViewController: UITableViewDelegate {
    
    /// delete a row in tableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let item = coreDataManager?.item[indexPath.row] else { return }
            
//            cleanArray(item: item)
//            cleanArray(item: item ?? ItemEntity())

            coreDataManager?.deleteItem(itemName: item.itemName ?? "")
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        itemTableView.reloadData()
        debugCoreDataItem(nameDebug: "The item is deleted", coreDataManager: coreDataManager)
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let  headerCell = tableView.dequeueReusableCell(withIdentifier: Constants.HeaderCell) as? CustomTableViewHeaderCell else {
//            return UITableViewCell()
//        }
//        if coreDataManager?.item.isEmpty ?? false {
//            headerCell.isHidden = true
//        }
//        if section < categoriesList.count {
//            headerCell.headerLabel.text = categoriesList[section]
//        }
//
////        switch section {
////        case 0:
////            headerCell.headerLabel.text = categoriesList[0]
////        case 1:
////            headerCell.headerLabel.text = categoriesList[1]
////        case 2:
////            headerCell.headerLabel.text = categoriesList[2]
////        case 3:
////            headerCell.headerLabel.text = categoriesList[3]
////        case 4:
////            headerCell.headerLabel.text = categoriesList[4]
////        case 5:
////            headerCell.headerLabel.text = categoriesList[5]
////        case 6:
////            headerCell.headerLabel.text = categoriesList[6]
////        case 7:
////            headerCell.headerLabel.text = categoriesList[7]
////        case 8:
////            headerCell.headerLabel.text = categoriesList[8]
////        case 9:
////            headerCell.headerLabel.text = categoriesList[9]
////        case 10:
////            headerCell.headerLabel.text = categoriesList[10]
////        default:
////            headerCell.headerLabel.text = ""
////        }
//        return headerCell
//    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let label = UILabel()
            label.text = "Click on ➕ to add an item"
            label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            label.textAlignment = .center
            label.textColor = #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1)
            return label
        default:
            return UILabel()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return coreDataManager?.item.isEmpty ?? true ? 300 : 0
    }
}

// MARK: - Navigation

//extension PackingListViewController {
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == segueToAddItem {
//            guard let addItemVC = segue.destination as? AddItemViewController else { return }
//            addItemVC.cellule = self.cellSelected
//            if celluleActive {
//                addItemVC.celluleActive = true
//                addItemVC.celluleIndex = celluleIndex
//            } else {
//                addItemVC.celluleActive = false
//            }
//            print("prepare segue celluleActive : \(celluleActive)")
//            print("prepare segue celluleIndex : \(celluleIndex)")
//
//        }
//    }
//}
