//
//  InformationsViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/09/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

final class InformationsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let segueToWebsiteInfo = Constants.SegueToWebsiteInfo
    private let badgeLinkedIn = "https://www.linkedin.com/mwlite/in/ang%C3%A9lique-babin-158aa874"
    private let badgeDevTo = "https://dev.to/angelappdev"
    private var badge = String()
    
    // MARK: - Actions
    
    @IBAction private func manthanaButtonTapped(_ sender: UIButton) {
        openSafari("https://www.iconfinder.com/Manthana")
    }
    
    @IBAction private func iconfinderButtonTapped(_ sender: UIButton) {
        openSafari("https://www.iconfinder.com/")
    }
    
    @IBAction private func angelAppDevButtonTapped(_ sender: UIButton) {
        openSafari("http://www.angelappdev.io")
    }
    
    @IBAction private func badgeProButtonTapped(_ sender: UIButton) {
        badge = badgeLinkedIn
        performSegue(withIdentifier: segueToWebsiteInfo, sender: self)
    }
    
    @IBAction private func badgeDevButtonTapped(_ sender: UIButton) {
        badge = badgeDevTo
        performSegue(withIdentifier: segueToWebsiteInfo, sender: self)
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isToolbarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
    }
}

// MARK: - Navigation

extension InformationsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToWebsiteInfo {
            guard let websiteInfoVC = segue.destination as? WebViewInformationsViewController else { return }
            websiteInfoVC.badge = self.badge
        }
    }
}
