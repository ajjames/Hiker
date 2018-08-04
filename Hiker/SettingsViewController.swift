//
//  SettingsViewController.swift
//  Hiker
//
//  Created by Andrew James on 8/2/18.
//  Copyright © 2018 aj. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var recordCountLabel: UILabel!
    lazy var locationEngine: LocationEngine = .shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listenForNewData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func listenForNewData() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc private func updateUI() {
        DispatchQueue.main.async { [unowned self] in
            let countOfRecords = self.locationEngine.storedLocations().count
            self.recordCountLabel.text = "\(countOfRecords)"
        }
    }
    
    @IBAction func didTouchClearDataButton(_ sender: Any) {
        locationEngine.clearAllLocations()
        updateUI()
    }
}
