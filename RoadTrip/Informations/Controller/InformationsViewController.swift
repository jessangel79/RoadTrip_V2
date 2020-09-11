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
    private let manthana = "https://www.iconfinder.com/Manthana"
    private let iconfinder = "https://www.iconfinder.com/"
    private let angelAppDev = "http://www.angelappdev.io"
    private var urlString = String()
    
    // MARK: - Actions
    
    @IBAction private func manthanaButtonTapped(_ sender: UIButton) {
        openWebView(manthana)
    }
    
    @IBAction private func iconfinderButtonTapped(_ sender: UIButton) {
        openWebView(iconfinder)
    }
    
    @IBAction private func angelAppDevButtonTapped(_ sender: UIButton) {
        openWebView(angelAppDev)
    }
    
    @IBAction private func badgeProButtonTapped(_ sender: UIButton) {
        openWebView(badgeLinkedIn)
    }
    
    @IBAction private func badgeDevButtonTapped(_ sender: UIButton) {
        openWebView(badgeDevTo)
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
    
    // MARK: - Methods
    
    private func openWebView(_ urlString: String) {
        self.urlString = urlString
        performSegue(withIdentifier: segueToWebsiteInfo, sender: self)
    }
}

// MARK: - Navigation

extension InformationsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToWebsiteInfo {
            guard let websiteInfoVC = segue.destination as? WebViewInformationsViewController else { return }
            websiteInfoVC.urlString = self.urlString
        }
    }
}
