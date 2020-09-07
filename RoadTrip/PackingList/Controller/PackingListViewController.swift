//
//  PackingListViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 11/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

final class PackingListViewController: DetailsMyTripViewController {

    // MARK: - Actions
    
    @IBAction override func resetBarButtonItemTapped(_ sender: UIBarButtonItem) {
        if !(coreDataManager?.items.isEmpty ?? false) {
            showAlertResetAll()
        }
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        tabType = Constants.Item
        super.viewDidLoad()
    }

    // MARK: - Methods
    
    override func setNib() {
        let nib = UINib(nibName: Constants.PackingListTableViewCell, bundle: nil)
        myTripTableView.register(nib, forCellReuseIdentifier: Constants.PackingListCell)
    }
    
    override func resetAll() {
        coreDataManager?.deleteAllItems()
        myTripTableView.reloadData()
        debugCoreDataItem(nameDebug: "All \(tabType) deleted", coreDataManager: coreDataManager)
    }
}

// MARK: - UITableViewDataSource

extension PackingListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(withIdentifier: Constants.PackingListCell,
                                                           for: indexPath) as? PackingListTableViewCell else {
            return UITableViewCell()
        }
        let item = coreDataManager?.items[indexPath.row]
        itemCell.itemEntity = item
        return itemCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}

// MARK: - UITableViewDelegate

extension PackingListViewController {
    
    /// delete a row in tableView
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let item = coreDataManager?.items[indexPath.row] else { return }
            coreDataManager?.deleteItem(itemName: item.itemName ?? "")
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        myTripTableView.reloadData()
        debugCoreDataItem(nameDebug: "The \(tabType) is deleted", coreDataManager: coreDataManager)
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return coreDataManager?.items.isEmpty ?? true ? 300 : 0
    }
}
