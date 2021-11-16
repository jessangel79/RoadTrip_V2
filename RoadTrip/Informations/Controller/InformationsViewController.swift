//
//  InformationsViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 10/09/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit

import GoogleMobileAds

final class InformationsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let segueToWebsiteInfo = Constants.SegueToWebsiteInfo
    private let badgeLinkedIn = "https://www.linkedin.com/mwlite/in/ang%C3%A9lique-babin-158aa874"
    private let badgeDevTo = "https://dev.to/angelappdev"
    private let iconfinder = "https://www.iconfinder.com/"
    private let angelAppDev = "http://www.angelappdev.io"
    private let mergersort = "https://github.com/mergesort/TableFlip"
    private let openStreetMap = "https://www.openstreetmap.org/copyright"
    private var urlString = String()
    
    private let adMobService = AdMobService()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var bannerView: GADBannerView!
    
    // MARK: - Actions
    
    @IBAction private func iconfinderButtonTapped(_ sender: UIButton) {
        openWebView(iconfinder)
    }
    
    @IBAction private func mergesortButtonTapped(_ sender: UIButton) {
        openWebView(mergersort)
    }
    
    @IBAction private func openStreetMapButtonTapped(_ sender: UIButton) {
        openWebView(openStreetMap)
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
    
    @IBAction func closeModalBarButtonItemTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
        
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isToolbarHidden = true
        adMobService.setAdMob(bannerView, self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
