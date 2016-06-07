//
//  SettingsViewController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 05-06-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SettingsViewController: SPViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var backBtn                     : SPNavButtonView!
    var upBtn                       : UIButton!
    var downBtn                     : UIButton!
    var settingsTable               : UITableView!
    var defaults                    : DefaultsController = DefaultsController.sharedInstance
    var interfaceCntrl              : InterfaceModeController = InterfaceModeController.sharedInstance
    
    var settingsItems               : [SettingsItem] = []
    var currentSegmentedValues      : [Double] = []
    
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
            width: D.SCREEN_WIDTH - D.BTN.HEIGHT.REGULAR - (D.SPACING.LARGE * 4),
            height: self.view.frame.height - backBtn.frame.height - D.SPACING.LARGE
            ), style: .Plain)
        settingsTable.registerClass(SettingsTableCell.self, forCellReuseIdentifier: "SettingsTableCell")
        settingsTable.backgroundColor = UIColor.clearColor()
        settingsTable.delegate = self
        settingsTable.dataSource = self
        settingsTable.separatorColor = ThemeController.sharedInstance.currentTheme().TEXT.colorWithAlphaComponent(S.OPACITY.DARK)
        settingsTable.separatorStyle = .SingleLine
        view.addSubview(settingsTable!)
        
        upBtn = UIButton(frame: CGRect(
            x: settingsTable.frame.x + settingsTable.frame.width + D.SPACING.LARGE,
            y: settingsTable.frame.y + (settingsTable.frame.height / 4) - (D.BTN.HEIGHT.REGULAR / 2),
            w: D.BTN.HEIGHT.REGULAR,
            h: D.BTN.HEIGHT.REGULAR
            ))
        upBtn.setImage(UIImage(named: "UpButton")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        upBtn.imageView?.tintColor = ThemeController.sharedInstance.currentTheme().TEXT
        upBtn.addTapGesture { (UITapGestureRecognizer) in
            var offset = CGPoint(
                x: self.settingsTable.contentOffset.x,
                y: self.settingsTable.contentOffset.y - D.SETTINGS.SCROLL_OFFSET
            )
            
            if self.settingsTable.indexPathForRowAtPoint(offset)?.row == nil{
                offset = CGPointZero
            }
            
            print("index: \(self.settingsTable.indexPathForRowAtPoint(offset)?.row) max: \(0))")
            print(self.settingsTable.indexPathForRowAtPoint(offset)?.row <= 0)
            
            self.settingsTable.setContentOffset(offset, animated: true)
        }
        self.view.addSubview(upBtn)
        
        downBtn = UIButton(frame: CGRect(
            x: settingsTable.frame.x + settingsTable.frame.width + D.SPACING.LARGE,
            y: settingsTable.frame.y + (settingsTable.frame.height * 0.75) - (D.BTN.HEIGHT.REGULAR / 2),
            w: D.BTN.HEIGHT.REGULAR,
            h: D.BTN.HEIGHT.REGULAR
            ))
        downBtn.setImage(UIImage(named: "DownButton")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        downBtn.imageView?.tintColor = ThemeController.sharedInstance.currentTheme().TEXT
        downBtn.addTapGesture { (UITapGestureRecognizer) in
            
            var offset = CGPoint(
                x: self.settingsTable.contentOffset.x,
                y: self.settingsTable.contentOffset.y + D.SETTINGS.SCROLL_OFFSET
            )
            
            print("index: \(self.settingsTable.indexPathForRowAtPoint(offset)?.row) max: \(self.settingsTable.numberOfRowsInSection(0))")
            
            if self.settingsTable.indexPathForRowAtPoint(offset)?.row >= self.settingsTable.numberOfRowsInSection(0) - 3{
                offset = self.settingsTable.contentOffset
            }
            
            self.settingsTable.setContentOffset(offset, animated: true)
        }
        self.view.addSubview(downBtn)
        
        addSettings()
        
    }
    
    func addSettings(){
        settingsItems = [
            SettingsItem(
                title: STR.settings_location_title,
                subtitle: STR.settings_location_subtitle,
                switchHidden: true,
                switchValue: defaults.isInSafetyMode(),
                tapEvent: #selector(self.setLocationNotifications),
                segmentedValues : ["1","3", "5"],
                segmentedLabel: STR.settings_location_segmented_label
            ),
            SettingsItem(
                title: STR.settings_destination_title,
                subtitle: STR.settings_destination_subtitle,
                switchHidden: false,
                switchValue: defaults.isDestinationNotificationsOn(),
                tapEvent: #selector(self.toggleDestinationNotification)
            ),
            SettingsItem(
                title: STR.settings_safety_title,
                subtitle: STR.settings_safety_subtitle,
                switchHidden: false,
                switchValue: defaults.isInSafetyMode(),
                tapEvent: #selector(self.toggleSafetySetting)
            ),
            SettingsItem(
                title: STR.settings_shutdown_title,
                subtitle: STR.settings_shutdown_subtitle,
                switchHidden: false,
                switchValue: defaults.isAutomaticShutdownOn(),
                tapEvent: #selector(self.toggleAutomaticShutdown)
            ),
            SettingsItem(
                title: STR.settings_favorites_title,
                subtitle: nil,
                switchHidden: true,
                switchValue: false,
                tapEvent: #selector(self.deleteFavorites)
            )
        ]
        
        settingsTable.reloadData()
        settingsTable.resizeToFitHeight()
        
    }
    
    func setLocationNotifications(){
        defaults.setLocationNotificationDistances(self.currentSegmentedValues)
    }
    
    func toggleDestinationNotification(){
        defaults.toggleDestinationNotification()
    }
    
    func toggleSafetySetting(){
        defaults.toggleSafetyMode()
        if defaults.isInSafetyMode() {
            interfaceCntrl.start()
        } else{
            interfaceCntrl.stop()
            interfaceCntrl.setMode(.MAXIMAL)
        }
    }
    
    func toggleAutomaticShutdown(){
        defaults.toggleAutomaticShutdown()
    }
    
    
    func deleteFavorites(){
        defaults.deleteFavorites()
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
        let segmentedWidth = settingsItem.segmentedValues != nil ? (D.SETTINGS.SEGMENTED_HEIGHT * 3) : 0
        
        
        cell.titleLabel.text = settingsItem.title
        cell.titleLabel.frame = CGRect(
            x: cell.titleLabel.frame.x,
            y: cell.titleLabel.frame.y,
            w: tableView.frame.width - (D.SPACING.REGULAR * 2) - D.SETTINGS.SWITCH_HEIGHT - segmentedWidth,
            h: cell.titleLabel.frame.height
        )
        cell.titleLabel.fitSize()
        
        cell.subtitleLabel.text = settingsItem.subtitle != nil ? settingsItem.subtitle : ""
        
        
        cell.subtitleLabel.frame = CGRect(
            x: cell.subtitleLabel.frame.x,
            y: cell.subtitleLabel.frame.y,
            w: tableView.frame.width - (D.SPACING.REGULAR * 2) - D.SETTINGS.SWITCH_HEIGHT - segmentedWidth,
            h: cell.subtitleLabel.frame.height
        )
        cell.subtitleLabel.fitHeight()
        
        cell.switchView.frame = CGRect(
            x: tableView.frame.width - D.SPACING.REGULAR - D.SETTINGS.SWITCH_HEIGHT,
            y: cell.switchView.frame.y,
            w: cell.switchView.frame.width,
            h: cell.switchView.frame.height
        )
        
        cell.segmentedView.frame = CGRect(
            x: tableView.frame.width - D.SPACING.REGULAR - (D.SETTINGS.SEGMENTED_HEIGHT * 3),
            y: ((cell.frame.height - (D.SETTINGS.SEGMENTED_HEIGHT * 2)) / 2) + D.SPACING.REGULAR,
            w: (D.SETTINGS.SEGMENTED_HEIGHT * 3),
            h: cell.frame.height
        )
        
        if settingsItem.segmentedValues != nil && settingsItem.segmentedLabel != ""{
            cell.segmentedView.setValues(settingsItem.segmentedValues!, rightText: settingsItem.segmentedLabel!, tapHandler: {
                self.currentSegmentedValues = cell.segmentedView.getSelectedValues()
                self.performSelector(settingsItem.tapEvent!)
            })
        }
        
        if settingsItem.switchHidden! || settingsItem.segmentedValues != nil {cell.switchView.hidden = true}
        if settingsItem.switchValue != nil {cell.switchView.on = settingsItem.switchValue!}
        
        if settingsItem.tapEvent != nil {
            cell.switchView.addTarget(self, action: settingsItem.tapEvent!, forControlEvents: .ValueChanged)
            
        }
        
        return cell
    }
    
}
