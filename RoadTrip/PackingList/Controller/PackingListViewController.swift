//
//  PackingListViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 11/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

final class PackingListViewController: DetailsMyTripViewController {
    
    // MARK: - Properties
    
    private var travellersNames = ["Uncategorized"]
    private var itemTraveller = [ItemTraveller]()
    private var trips: [DetailsTripEntity]?
    private let segueToAddItem = Constants.SegueToAddItem
    private var cellSelected: ItemEntity?
    var celluleItemActive = false
    var celluleItemIndex = 0
    var celluleItemSection = 0

    // MARK: - Actions
    
    @IBAction override func resetBarButtonItemTapped(_ sender: UIBarButtonItem) {
        if !(coreDataManager?.items.isEmpty ?? false) {
            showAlertResetAll()
        }
    }
    
    @IBAction func addItemBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: self.segueToAddItem, sender: self)
    }
    
    @IBAction private func unwindToViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.reinitTravellerNames()
                self.getTravellersNames()
                self.itemTraveller.removeAll()
                self.getItemTraveller()
                self.myTripTableView.reloadData()
            }
        }
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        tabType = Constants.Item
        super.viewDidLoad()
        getTravellersNames()
        getItemTraveller()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        celluleItemActive = false
        reinitTravellerNames()
        getTravellersNames()
    }

    // MARK: - Methods
    
    override func setNib() {
        let nib = UINib(nibName: Constants.PackingListTableViewCell, bundle: nil)
        myTripTableView.register(nib, forCellReuseIdentifier: Constants.PackingListCell)
    }
    
    override func resetAll() {
        coreDataManager?.deleteAllItems()
        reinitTravellerNames()
        itemTraveller.removeAll()
        getTravellersNames()
        getItemTraveller()
        animationTableView(tableView: myTripTableView)
        myTripTableView.reloadData()
    }
    
    private func reinitTravellerNames() {
        travellersNames.removeAll()
        travellersNames.append("Uncategorized")
    }
    
    private func getTravellersNames() {
        trips = coreDataManager?.detailsTrips
        guard let trips = trips else { return }
        if !trips.isEmpty {
            for trip in trips {
                travellersNames.append(contentsOf: trip.travellers?.components(separatedBy: "-") ?? ["Uncategorized"])
            }
            travellersNames = travellersNames.removingDuplicates
            travellersNames = travellersNames.sorted()
        }
    }
    
    private func getItemTraveller() {
        let items = coreDataManager?.items
        guard let items = items else { return }
        if !travellersNames.isEmpty {
            for index in 0...travellersNames.count-1 {
                itemTraveller.append(ItemTraveller(travellerName: travellersNames[index], items: getItemsList(items: items, index: index)))
            }
        }
    }
    
    private func getItemsList(items: [ItemEntity], index: Int) -> [ItemEntity] {
        var itemsList = [ItemEntity]()
        for item in items where item.traveller == travellersNames[index] {
            itemsList.append(item)
        }
        print(itemsList)
        return itemsList
    }
}

// MARK: - UITableViewDataSource

extension PackingListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return itemTraveller.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemTraveller[section].items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(withIdentifier: Constants.PackingListCell,
                                                           for: indexPath) as? PackingListTableViewCell else {
            return UITableViewCell()
        }
        let item = itemTraveller[indexPath.section].items?[indexPath.row]
        itemCell.itemEntity = item
        return itemCell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cellSelected = itemTraveller[indexPath.section].items?[indexPath.row]
        celluleItemActive = true
        celluleItemIndex = indexPath.row
        celluleItemSection = indexPath.section
        performSegue(withIdentifier: self.segueToAddItem, sender: self)
    }
    
    /// delete a row in tableView
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let item = itemTraveller[indexPath.section].items?[indexPath.row] else { return }
            coreDataManager?.deleteItem(itemName: item.itemName ?? "", traveller: item.traveller ?? "")
            itemTraveller[indexPath.section].items?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
        animationCell(tableView)
    }
}

// MARK: - UITableViewDelegate

extension PackingListViewController {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        view.backgroundColor = #colorLiteral(red: 0.2532418037, green: 0.05658567593, blue: 0.2074308577, alpha: 1)
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 30))
        lbl.font = UIFont(name: "Futura Medium", size: 18)
        lbl.textColor = .white
        lbl.text = itemTraveller[section].travellerName
        view.addSubview(lbl)
        return view
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let items = coreDataManager?.items else { return 0 }
        return (itemTraveller.count == 1 && items.isEmpty) ? 300 : 0
    }
}

// MARK: - Navigation

extension PackingListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToAddItem {
            guard let addItemVC = segue.destination as? AddItemViewController else { return }
            addItemVC.travellersNames = travellersNames
            addItemVC.celluleItem = self.cellSelected
            if celluleItemActive {
                addItemVC.celluleItemActive = true
                addItemVC.celluleItemIndex = celluleItemIndex
                addItemVC.celluleItemSection = celluleItemSection
            } else {
                addItemVC.celluleItemActive = false
            }
        }
    }
}
