//
//  SettingsViewController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 05-06-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SettingsViewController: SPViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var backBtn         : SPNavButtonView!
    var settingsTable   : UITableView!
    var defaults        : DefaultsController!
    
    var settingsItems   : [SettingsItem] = []
    
    override func viewDidLoad() {
        self.view.backgroundColor = ThemeController.sharedInstance.currentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.XDARK)
        
        // Back button
        backBtn = SPNavButtonView(frame: CGRectMake(
            0,
            0,
            D.NAVBAR.BTN_WIDTH,
            D.NAVBAR.HEIGHT
            ), image: UIImage(named: "BackButtonIcon")!, text: STR.navbar_back_btn, iconLeft: true)
        backBtn.addTapGesture { (UITapGestureRecognizer) in
            self.navigationController?.popViewControllerAnimated(true)
        }
        self.view.addSubview(backBtn)
        
        // Table view
        
        settingsTable = UITableView(frame: CGRect(
            x: D.SPACING.LARGE,
            y: backBtn.frame.height + D.SPACING.LARGE,
            width: D.SCREEN_WIDTH - (D.SPACING.LARGE * 2),
            height: self.view.frame.height
            ), style: .Plain)
        settingsTable.registerClass(SettingsTableCell.self, forCellReuseIdentifier: "SettingsTableCell")
        settingsTable.backgroundColor = UIColor.clearColor()
        settingsTable.delegate = self
        settingsTable.dataSource = self
        settingsTable.separatorColor = ThemeController.sharedInstance.currentTheme().TEXT.colorWithAlphaComponent(S.OPACITY.DARK)
        settingsTable.separatorStyle = .SingleLine
        view.addSubview(settingsTable!)
        
        defaults = DefaultsController.sharedInstance
        
        addSettings()
        
    }
    
    func addSettings(){
        settingsItems.append(SettingsItem(
            title: STR.settings_safety_title,
            subtitle: STR.settings_safety_subtitle,
            switchHidden: false,
            switchValue: defaults.isInSafetyMode(),
            tapEvent: #selector(self.toggleSafetySetting)
            ))
        settingsItems.append(SettingsItem(
            title: STR.settings_shutdown_title,
            subtitle: STR.settings_shutdown_subtitle,
            switchHidden: false,
            switchValue: defaults.isAutomaticShutdownOn(),
            tapEvent: #selector(self.toggleAutomaticShutdown)
            ))
        settingsItems.append(SettingsItem(
            title: STR.settings_favorites_title,
            subtitle: nil,
            switchHidden: true,
            switchValue: false,
            tapEvent: nil
            ))
        
        settingsTable.reloadData()
        settingsTable.resizeToFitHeight()
        
    }
    
    func toggleSafetySetting(){
        defaults.toggleSafetyMode()
    }
    
    func toggleAutomaticShutdown(){
        defaults.toggleAutomaticShutdown()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return settingsItems.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return D.SETTINGS.ROW_HEIGHT
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Fetch settingsitem corresponding to indexpath
        let settingsItem = settingsItems[indexPath.row]
        if settingsItem.tapEvent != nil{
            performSelector(settingsItem.tapEvent!)
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SettingsTableCell
        cell.switchView.on = !cell.switchView.on
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cellIdentifier = "SettingsTableCell"
        let cell : SettingsTableCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SettingsTableCell
        
        
        // Fetch settingsitem corresponding to indexpath
        let settingsItem = settingsItems[indexPath.row]
        
        cell.titleLabel.text = settingsItem.title
        cell.titleLabel.frame = CGRect(
            x: cell.titleLabel.frame.x,
            y: cell.titleLabel.frame.y,
            w: tableView.frame.width - (D.SPACING.REGULAR * 2) - D.SETTINGS.SWITCH_HEIGHT,
            h: cell.titleLabel.frame.height
        )
        cell.titleLabel.fitHeight()
        
        cell.subtitleLabel.text = settingsItem.subtitle != nil ? settingsItem.subtitle : ""
        cell.subtitleLabel.frame = CGRect(
            x: cell.subtitleLabel.frame.x,
            y: cell.subtitleLabel.frame.y,
            w: tableView.frame.width - (D.SPACING.REGULAR * 2) - D.SETTINGS.SWITCH_HEIGHT,
            h: cell.subtitleLabel.frame.height
        )
        cell.subtitleLabel.fitHeight()
        
        cell.switchView.frame = CGRect(
            x: tableView.frame.width - D.SPACING.REGULAR - D.SETTINGS.SWITCH_HEIGHT,
            y: cell.switchView.frame.y,
            w: cell.switchView.frame.width,
            h: cell.switchView.frame.height
        )
        if settingsItem.switchHidden! {cell.switchView.hidden = true}
        if settingsItem.switchValue != nil {cell.switchView.on = settingsItem.switchValue!}
        
        if settingsItem.tapEvent != nil {
            cell.switchView.addTarget(self, action: settingsItem.tapEvent!, forControlEvents: .ValueChanged)
        }
        
        return cell
    }
    
}
