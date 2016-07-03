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
    var infoView                    : SPOverlayView!
    var infoBtn                     : UIView!
    var defaults                    : DefaultsController = DefaultsController.sharedInstance
    var interfaceCntrl              : InterfaceModeController = InterfaceModeController.sharedInstance
    
    var settingsItems               : [SettingsItem] = []
    var currentSegmentedValues      : [String] = []
    
    override func viewDidLoad() {
        self.view.colorType = .BACKGROUND
        super.viewDidLoad()
        self.setCustomToolbarHidden(true)
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
        backBtn.colorType = nil
        backBtn.btnIcon?.colorType = .BUTTON
        backBtn.btnText?.colorType = .BUTTON
        self.view.addSubview(backBtn)
        
        let infoImg = UIImage(named: "InfoIcon")!.imageWithRenderingMode(.AlwaysTemplate)
        self.infoBtn = UIImageView(
            x: D.SCREEN_WIDTH - D.BTN.HEIGHT.REGULAR - D.SPACING.XLARGE,
            y: D.SPACING.XLARGE,
            w: D.BTN.HEIGHT.REGULAR,
            h: D.BTN.HEIGHT.REGULAR,
            image: infoImg)
        self.infoBtn.colorType = .BUTTON
        self.view.addSubview(self.infoBtn)
        self.infoBtn.addTapGesture { (UITapGestureRecognizer) in
            self.infoView.show()
        }
        
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
        settingsTable.separatorColor = DefaultsController.sharedInstance.getCurrentTheme().TEXT.colorWithAlphaComponent(S.OPACITY.DARK)
        settingsTable.separatorStyle = .SingleLine
    
        view.addSubview(settingsTable!)
        
        self.setInfoView()
        
        upBtn = UIButton(frame: CGRect(
            x: settingsTable.frame.x + settingsTable.frame.width + D.SPACING.XLARGE,
            y: settingsTable.frame.y + (settingsTable.frame.height / 4) - (D.BTN.HEIGHT.REGULAR / 2),
            w: D.BTN.HEIGHT.REGULAR,
            h: D.BTN.HEIGHT.REGULAR
            ))
        upBtn.setImage(UIImage(named: "UpButton")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        upBtn.imageView!.colorType = .BUTTON
        upBtn.addTapGesture { (UITapGestureRecognizer) in
            var offset = CGPoint(
                x: self.settingsTable.contentOffset.x,
                y: self.settingsTable.contentOffset.y - D.SETTINGS.SCROLL_OFFSET
            )
            
            if self.settingsTable.indexPathForRowAtPoint(offset)?.row == nil{
                offset = CGPointZero
            }
            
            self.settingsTable.setContentOffset(offset, animated: true)
        }
        self.view.addSubview(upBtn)
        
        downBtn = UIButton(frame: CGRect(
            x: settingsTable.frame.x + settingsTable.frame.width + D.SPACING.XLARGE,
            y: settingsTable.frame.y + (settingsTable.frame.height * 0.75) - (D.BTN.HEIGHT.REGULAR / 2),
            w: D.BTN.HEIGHT.REGULAR,
            h: D.BTN.HEIGHT.REGULAR
            ))
        downBtn.setImage(UIImage(named: "DownButton")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        downBtn.imageView!.colorType = .BUTTON
        downBtn.addTapGesture { (UITapGestureRecognizer) in
            
            var offset = CGPoint(
                x: self.settingsTable.contentOffset.x,
                y: self.settingsTable.contentOffset.y + D.SETTINGS.SCROLL_OFFSET
            )
            
            if self.settingsTable.indexPathForRowAtPoint(offset)?.row >= self.settingsTable.numberOfRowsInSection(0) - 3{
                offset = self.settingsTable.contentOffset
            }
            
            self.settingsTable.setContentOffset(offset, animated: true)
        }
        self.view.addSubview(downBtn)
        
        self.view.resetColor(false)
        
        addSettings()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        let nextVCName = self.navigationController?.topViewController?.className
        if nextVCName == SpringboardViewController.className{
            UIView.animateWithDuration(0.75, animations: { () -> Void in
                UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
                UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: self.navigationController!.view, cache: false)
            })
        }
        
    }
    
    // Provide settings for tableview
    func addSettings(){
        let distances = defaults.getLocationNotificationDistances()
        let setDistances = ["0.5", "1", "3"]
        var setValues = [false, false, false]
        for (i, distance) in setDistances.enumerate(){
            if  distances.contains(Double(distance)!){
                setValues[i] = true
            }
        }
        
        let durations = defaults.getETANotificationDurations()
        let setDurations = ["1", "5", "10"]
        var setDurValues = [false, false, false]
        for (i, duration) in setDurations.enumerate(){
            if  durations.contains(Int(duration)!){
                setDurValues[i] = true
            }
        }
        
        settingsItems = [
            SettingsItem(
                title: STR.settings_location_title,
                subtitle: STR.settings_location_subtitle,
                switchHidden: true,
                switchValue: false,
                tapEvent: #selector(self.setLocationNotifications),
                segmentedKeys: setDistances,
                segmentedValues: setValues,
                segmentedLabel: STR.settings_location_segmented_label
            ),
            SettingsItem(
                title: STR.settings_eta_title,
                subtitle: STR.settings_eta_subtitle,
                switchHidden: true,
                switchValue: false,
                tapEvent: #selector(self.setETANotifications),
                segmentedKeys: setDurations,
                segmentedValues: setDurValues,
                segmentedLabel: STR.settings_eta_segmented_label
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
    
    func getSelectedValues(keys : [String], values : [String]) -> [Bool]{
        var selectedValues : [Bool] = []
        
        for key in keys{
            if  values.contains(key){
                selectedValues.append(true)
            }else{
                selectedValues.append(false)
            }
        }
        return selectedValues
    }
    
    override func setDayMode(){
        self.view.resetColor()
        settingsTable.separatorColor = DefaultsController.sharedInstance.getCurrentTheme().TEXT.colorWithAlphaComponent(S.OPACITY.DARK)
    }
    
    override func setNightMode(){
        self.view.resetColor()
        settingsTable.separatorColor = DefaultsController.sharedInstance.getCurrentTheme().TEXT.colorWithAlphaComponent(S.OPACITY.DARK)
    }
    
    override func setMinimalMode(){
    }
    
    override func setMediumMode(){
    }
    
    override func setMaximalMode(){
    }
    
    func setInfoView(){
        self.infoView = SPOverlayView(frame: CGRect(
            x: D.SCREEN_WIDTH * 0.125,
            y: D.SCREEN_HEIGHT * 0.15,
            w: D.SCREEN_WIDTH * 0.75,
            h: D.SCREEN_HEIGHT * 0.7
            ), text: STR.explanation_text, btnText: STR.explanation_btn)
        self.infoView!.layer.cornerRadius = D.RADIUS.REGULAR
        self.infoView!.hidden = true
        self.infoView.iconView.colorType = nil
        self.infoView.iconView.tintColor = C.TEXT
        self.infoView.textLabel.colorType = nil
        self.infoView.textLabel.textColor = C.TEXT
        removeGestureRecognizers(self.infoView.dismissBtn)
        self.infoView.dismissBtn.addTapGesture { (UITapGestureRecognizer) in
            self.infoView.hide({_ in})
        }
        self.infoView.colorType = .HIGH_CONTRAST
        self.infoView.opacity = S.OPACITY.XXDARK
        self.infoView.hidden = true
        self.view.addSubview(self.infoView!)
    }
    
    /** Selector functions */
    func setLocationNotifications(){
        let values = self.currentSegmentedValues.map({Double($0)!})
        defaults.setLocationNotificationDistances(values)
    }

    func setETANotifications(){
        let values = self.currentSegmentedValues.map({Int($0)!})
        defaults.setETANotificationDurations(values)
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
        settingsItem.switchValue = cell.switchView.on
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cellIdentifier = "SettingsTableCell"
        let cell : SettingsTableCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SettingsTableCell
        
        
        // Fetch settingsitem corresponding to indexpath
        let settingsItem = settingsItems[indexPath.row]
        
        
        cell.titleLabel.text = settingsItem.title
        cell.subtitleLabel.text = settingsItem.subtitle != nil ? settingsItem.subtitle : ""
        
        // Initiate custom segmented view
        if settingsItem.segmentedKeys != nil && settingsItem.segmentedLabel != ""{
            cell.segmentedView.setValues(settingsItem.segmentedKeys!, values: settingsItem.segmentedValues!, rightText: settingsItem.segmentedLabel!, tapHandler: {
                settingsItem.segmentedValues = self.getSelectedValues(settingsItem.segmentedKeys!, values: cell.segmentedView.getSelectedValues())
                self.currentSegmentedValues = cell.segmentedView.getSelectedValues()
                self.performSelector(settingsItem.tapEvent!)
                self.currentSegmentedValues = []
                }
            )
            cell.segmentedView.hidden = false
        }
        
        // Reset view frames
        cell.resetViews()
        
        if settingsItem.switchHidden! || settingsItem.segmentedValues != nil {
            cell.switchView.hidden = true
        }else{
            cell.switchView.hidden = false
        }
        if settingsItem.switchValue != nil {cell.switchView.on = settingsItem.switchValue!}
        
        if settingsItem.tapEvent != nil {
            cell.switchView.addTarget(self, action: settingsItem.tapEvent!, forControlEvents: .ValueChanged)
            
        }
        
        return cell
    }
    
}
