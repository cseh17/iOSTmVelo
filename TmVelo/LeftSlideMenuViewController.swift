//
//  LeftSlideMenuViewController.swift
//  TmVelo
//
//  Created by Cseh Krisztian on 06.08.19.
//  Copyright © 2019 Cseh Krisztian. All rights reserved.
//

import UIKit
import Firebase

class LeftSlideMenuViewController: UIViewController {
    
    let cellIdentifier = "ReusableSettingCell"

    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var applicationNameLabel: UITextField!
    @IBOutlet weak var applicationVersionLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the application name & version
        applicationNameLabel.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "error"
        applicationVersionLabel.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "000"
        
        if settingsTableView != nil {
            settingsTableView.delegate = self
            settingsTableView.dataSource = self
        
            // Set TableView to unscrollable
            settingsTableView.isScrollEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settingsTableView.reloadData()
    }
    
    func showAboutDialog() {
        let aboutDialog = UIAlertController(title: "TmVelo", message: "TmVelo nu este o aplicație oficială a VeloTm. Astfel nu există nici o colaborare directă între prestatorul de servicii, STPT, și creatorul acestei aplicații. Prin urmare, nici aplicația cât nici autorul acestei aplicații nu sunt respunzători pentru corectitudinea datelor afișate. Toate datele afișate în această aplicație provin de pe www.velotm.ro. Pentru posibile greșeli, adresați-vă direct prestatorului de servicii: STPT. \nIcons by Florian Bacca \n Menu icon made by Freepik from www.flaticon.com \nWiFi Icon made by Pixel perfect from www.flaticon.com \nInfo Icon made by Chris Veigt from www.flaticon.com", preferredStyle: .alert)
        aboutDialog.addAction(UIAlertAction(title: "Am înțeles", style: .default, handler: nil))
        self.present(aboutDialog, animated: true, completion: nil)
    }
}

func isLastCellVisible(at indexPath: IndexPath, tableView: UITableView) -> Bool{
    guard let lastIndexPath = tableView.indexPathsForVisibleRows?.last else {
        return false
    }
    return lastIndexPath == indexPath
}

extension LeftSlideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.4, delayFactor: 0.05)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
        tableView.backgroundColor = .clear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SideMenuTableViewCell else {
            fatalError("The dequeued cell is not an instance of SideMenuSettingsTableView.")
        }
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        if indexPath.row == 2 {
            cell.setSeparator(isLast: true)
        } else {
            cell.setSeparator(isLast: false)
        }
        switch indexPath.row {
        case 0:
            cell.sideMenuSettingsCellTitle.text = "VeloTm"
            cell.sideMenuSettingsCellIcon.image = #imageLiteral(resourceName: "TelverdeIcon")
        case 1:
            cell.sideMenuSettingsCellTitle.text = "Timpi de sosire"
            cell.sideMenuSettingsCellIcon.image = #imageLiteral(resourceName: "PPTIcon")
        case 2:
            cell.sideMenuSettingsCellTitle.text = "Despre"
            cell.sideMenuSettingsCellIcon.image = #imageLiteral(resourceName: "InfoIcon")
        default:
            cell.sideMenuSettingsCellTitle.text = ""
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            Analytics.logEvent("call_velo_tm_clicked", parameters: nil)
            
            // If the first menu option was selected, promt an alert to the user and allow him to initialize a call to the support service. After selecting this menu option, the side menu should be closed.
            if let telNumber = URL(string: "tel://" + "0800410415"), UIApplication.shared.canOpenURL(telNumber) {
                UIApplication.shared.open(telNumber)
                
                // Acces master class methods in order to close the menu after initializing call.
                sideMenuRootVC.hideMenuViewController()
            }
            settingsTableView.deselectRow(at: indexPath, animated: true)
        case 1:
            Analytics.logEvent("public_transport_tm_app_viewed", parameters: nil)
            
            // If the second menu option was selected, try to open the "Public Transport TM" app. First check if the app is installed. If the user has the app instaled, open app. If the app is not instaled, then open AppStore on the apps page.
            if let appLocalUrl = URL(string: "publictransporttimisoara://"), UIApplication.shared.canOpenURL(appLocalUrl){
                UIApplication.shared.open(appLocalUrl)
            } else {
                
                // TODO: implement URLScheme in Public Transport Timisoara app, in order to be able to open it from this app
                if let appUrl = URL(string: "https://apps.apple.com/ro/app/public-transport-timisoara/id1198165425?mt=8"), UIApplication.shared.canOpenURL(appUrl) {
                    UIApplication.shared.open(appUrl)
                }
                
                // Acces master class methods in order to close the menu after initializing call.
                sideMenuRootVC.hideMenuViewController()
            }
            settingsTableView.deselectRow(at: indexPath, animated: true)
        case 2:
            self.showAboutDialog()
            settingsTableView.deselectRow(at: indexPath, animated: true)
        default:
            settingsTableView.deselectRow(at: indexPath, animated: true)
            break
        }
        
    }
}

