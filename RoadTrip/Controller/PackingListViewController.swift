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

    // MARK: - Actions
    
    @IBAction private func resetBarButtonItemTapped(_ sender: UIBarButtonItem) {
        coreDataManager?.deleteAllItems()
        itemTableView.reloadData()
        debugCoreDataItem(nameDebug: "All items deleted", coreDataManager: coreDataManager)
    }

    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
        let nib = UINib(nibName: Constants.PackingListTableViewCell, bundle: nil)
        itemTableView.register(nib, forCellReuseIdentifier: Constants.PackingListCell)
        itemTableView.reloadData()
    }
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
}

// MARK: - UITableViewDataSource

extension PackingListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        return categoriesList.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager?.item.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(withIdentifier: Constants.PackingListCell,
                                                           for: indexPath) as? PackingListTableViewCell else {
            return UITableViewCell()
        }

        let item = coreDataManager?.item[indexPath.row]
//        let item = coreDataManager?.item[indexPath.section]
        itemCell.itemEntity = item

        return itemCell
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//
//        let label = UILabel()
//        view.addSubview(label)
//        label.bindEdgesToSuperview()
//        label.backgroundColor = #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1)
//        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
//        label.textColor = #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 1)
//
//        if section < categoriesList.count {
//            switch section {
//            case 0:
//                label.text =  "Tasks before you go"
//            case 1:
//                label.text =  "Documents"
//            case 2:
//                label.text =  "Clothes"
//            case 3:
//                label.text =  "Accessories"
//            case 4:
//                label.text =  "Cosmetics"
//            case 5:
//                label.text =  "Health"
//            case 6:
//                label.text =  "Food & Drinks"
//            case 7:
//                label.text =  "Gadgets"
//            case 8:
//                label.text =  "Games & Recreation"
//            case 9:
//                label.text =  "Books"
//            case 10:
//                label.text =  "Other"
//            default:
//                label.text =  ""
//            }
//        }
//        return view
//    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0: return "Tasks before you go"
//        case 1: return "Documents"
//        case 2: return "Clothes"
//        case 3: return "Accessories"
//        case 4: return "Cosmetics"
//        case 5: return "Health"
//        case 6: return "Food & Drinks"
//        case 7: return "Gadgets"
//        case 8: return "Games & Recreation"
//        case 9: return "Books"
//        case 10: return "Other"
//        default: return ""
//        }
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
    
    // TEST
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard let header = view as? UITableViewHeaderFooterView else { return }
//        header.textLabel?.textAlignment = .center
//
//        switch section {
//        case 1:  //only section No.1
//            header.textLabel?.textColor = .black
//        case 3:  //only section No.3
//            header.textLabel?.textColor = .red
//        default: //
//            header.textLabel?.textColor = .yellow
//        }
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
