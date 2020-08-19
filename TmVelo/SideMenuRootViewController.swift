//
//  RootViewController.swift
//  TmVelo
//
//  Created by Cseh Krisztian on 29.07.19.
//  Copyright © 2019 Cseh Krisztian. All rights reserved.
//


import UIKit
import AKSideMenu

var sideMenuRootVC: SideMenuRootViewController!

public class SideMenuRootViewController: AKSideMenu, AKSideMenuDelegate {
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.menuPreferredStatusBarStyle = .lightContent
        self.contentViewShadowColor = .black
        self.contentViewShadowOffset = CGSize(width: 0, height: 0)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        self.backgroundImage = #imageLiteral(resourceName: "TmVeloBackground")
    
        self.delegate = self
        
        if let storyboard = self.storyboard {
            self.contentViewController = storyboard.instantiateViewController(withIdentifier: "contentViewController")
            self.leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "leftMenuViewController")
        }
        
        // Set actual VC to self after initialization in order to be able to call panGestureRecognizer functions from super class. This functions are needed in order to be able to trigger the menu closure on desired action. 
        sideMenuRootVC = self
    }
    
    // MARK: - <AKSideMenuDelegate>
    
    public func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
        print("willShowMenuViewController")
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
        print("didShowMenuViewController")
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
        print("willHideMenuViewController")
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
        print("didHideMenuViewController")
    }
    public func sideMenu(_ sideMenu: AKSideMenu, didRecognizePanGesture recognizer: UIPanGestureRecognizer) {
        print("didRecognizedPanGesture")
    }
}
