//
//  StatusMenuController.swift
//  B2KMac
//
//  Created by 蒋一博 on 2019/3/5.
//  Copyright © 2019 dawninest. All rights reserved.
//

import Cocoa



class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    //@IBOutlet weak var dataView: DataView!
    
    var bangumiList: BangumiList!
    
    var dataMenuItem: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    let bangumiAPI = BangumiAPI()
    
    override func awakeFromNib() {
        let icon = NSImage.init(named: "icon")
        icon?.isTemplate = true
        statusItem.button!.image = icon
        
        //statusItem.button?.title = "B2K"
        
        statusItem.menu = statusMenu
        bangumiList = BangumiList.init()
        dataMenuItem = statusMenu.item(withTitle: "main")
        dataMenuItem.view = bangumiList
        
        initData()
    }
    
    func initData() {
        bangumiAPI.fetchData { bangumiData in
            self.bangumiList.initData(bangumiData)
        }
    }
    
    
    
}
