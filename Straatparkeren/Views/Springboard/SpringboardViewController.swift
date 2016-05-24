//
//  SpringboardViewController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 09/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SpringboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var vc : MapsOverviewController?
    
    var collectionView : UICollectionView?
    var appCollection : NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
        self.edgesForExtendedLayout = .None
                
        vc = MapsOverviewController()
        createCollectionView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    func createCollectionView() {
        
        appCollection = NSMutableArray()
        appCollection?.addObject(SpringboardApp(title: "Phone", icon: "PhoneIcon", url: "tel:"))
        appCollection?.addObject(SpringboardApp(title: "Messages", icon: "MessagesIcon", url: "sms://"))
        appCollection?.addObject(SpringboardApp(title: "Maps", icon: "MapsIcon", url: "maps://"))
        appCollection?.addObject(SpringboardApp(title: "Settings", icon: "SettingsIcon", url: UIApplicationOpenSettingsURLString))
        appCollection?.addObject(SpringboardApp(title: "Mail", icon: "MailIcon", url: "mail://"))
        appCollection?.addObject(SpringboardApp(title: "Music", icon: "MusicIcon", url: "music://"))
        appCollection?.addObject(SpringboardApp(title: "Straatparkeren", icon: "StraatparkerenIcon", url: "straatparkeren"))
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let iconSize : CGFloat = D.SCREEN_WIDTH / 8
        let iconSpacing : CGFloat = (D.SCREEN_WIDTH - (iconSize * 4) - (D.SPRINGBOARD.ICON_MARGIN * 2)) / 4
        
        flowLayout.itemSize = CGSizeMake(iconSize, iconSize)
        flowLayout.minimumInteritemSpacing = iconSpacing
        flowLayout.minimumLineSpacing = iconSpacing
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.frame = CGRectMake(D.SPRINGBOARD.ICON_MARGIN, D.SPRINGBOARD.ICON_MARGIN, D.SCREEN_WIDTH - (D.SPRINGBOARD.ICON_MARGIN * 2), D.SCREEN_HEIGHT - (D.SPRINGBOARD.ICON_MARGIN * 2))
        collectionView!.registerClass(SpringboardAppCell.self, forCellWithReuseIdentifier: "cellID")
        self.view.addSubview(collectionView!)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return (appCollection?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell : SpringboardAppCell = collectionView.dequeueReusableCellWithReuseIdentifier("cellID", forIndexPath: indexPath) as! SpringboardAppCell;
        let cellModel : SpringboardApp = (appCollection?.objectAtIndex(indexPath.row))! as! SpringboardApp
        cell.setIcon(cellModel.icon!)
        cell.setTitle(cellModel.title!)
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cellModel : SpringboardApp = (appCollection?.objectAtIndex(indexPath.row))! as! SpringboardApp
        
        let url = NSURL(string: cellModel.url!)
        
        if(cellModel.url! == "straatparkeren"){
            UIView.animateWithDuration(0.75, animations: { () -> Void in
                UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
                self.navigationController?.pushViewController(self.vc!, animated: false)
                UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: self.navigationController!.view!, cache: false)
            })
        }
        else if(UIApplication.sharedApplication().canOpenURL(url!)){
            UIApplication.sharedApplication().openURL(url!)
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


}
