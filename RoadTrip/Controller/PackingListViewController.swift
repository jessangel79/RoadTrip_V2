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
    
    @IBOutlet private weak var itemTableView: UITableView! {
        didSet { itemTableView.tableFooterView = UIView() }
    }
    
    // MARK: - Properties
    
    private var coreDataManager: CoreDataManager?

    // MARK: - Actions
    
    @IBAction private func resetBarButtonItemTapped(_ sender: UIBarButtonItem) {
        if !(coreDataManager?.item.isEmpty ?? false) {
            showAlertResetAll()
        }
    }

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataFunction()
        let nib = UINib(nibName: Constants.PackingListTableViewCell, bundle: nil)
        itemTableView.register(nib, forCellReuseIdentifier: Constants.PackingListCell)
        itemTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemTableView.reloadData()
    }
    
    private func coreDataFunction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
        
    private func resetAll() {
        coreDataManager?.deleteAllItems()
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
            coreDataManager?.deleteItem(itemName: item.itemName ?? "")
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        itemTableView.reloadData()
        debugCoreDataItem(nameDebug: "The item is deleted", coreDataManager: coreDataManager)
    }
        
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
