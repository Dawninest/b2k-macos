//
//  BangumiList.swift
//  B2KMac
//
//  Created by 蒋一博 on 2019/3/6.
//  Copyright © 2019 dawninest. All rights reserved.
//

import Cocoa

class BangumiList: NSView {
    
    let width: CGFloat = 300
    let top_H: CGFloat = 30
    let bottom_H: CGFloat = 30
    let block_H: CGFloat = 10
    let cell_H: CGFloat = 70
    
    var topBar = NSView()
    var segmentControl = NSSegmentedControl()
    
    var dailyList = NSView()
    
    var bottomBar = NSView()
    var weekBar = NSTextField()
    
    var bangumiData = Array<Dictionary<String,Any>>()
    
    var cellArr = Array<Any>()
    
    let bangumiAPI = BangumiAPI()
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        self.initListUI()
        print("draw list")
    }


    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    func initListUI() {
        self.frame = NSRect.init(x: 0, y: 0, width: width, height: width)
        self.wantsLayer = true
        self.layer?.setNeedsDisplay()
        
        dailyList.frame = NSRect.init(x: 0, y: bottom_H + top_H, width: width, height: width)
        self.addSubview(dailyList)
        
        self.initTopBar()
        self.initBottomBar()
    }
}

extension BangumiList {
    // UISegmentedControl
    func initTopBar () {
        
        topBar.frame = NSRect.init(x: 0, y: bottom_H , width: width, height: top_H)
        
        topBar.wantsLayer = true
        topBar.layer?.setNeedsDisplay()
        topBar.layer?.backgroundColor = NSColor.clear.cgColor
        
        segmentControl.selectedSegmentBezelColor = NSColor(calibratedRed:0.89, green:0.40, blue:0.55, alpha:1.00)
        segmentControl.frame = NSRect(x: 5, y: 0, width: 290, height: 30)
        segmentControl.segmentStyle = .roundRect
        segmentControl.segmentCount = 7  // 显示几个 segment
        /** 设置segment 每个 segment 的文字 */
        
        
        segmentControl.setWidth(40, forSegment: 0)
        segmentControl.setWidth(40, forSegment: 1)
        segmentControl.setWidth(40, forSegment: 2)
        segmentControl.setWidth(40, forSegment: 3)
        segmentControl.setWidth(40, forSegment: 4)
        segmentControl.setWidth(40, forSegment: 5)
        segmentControl.setWidth(40, forSegment: 6)
       
        //添加监控事件
        segmentControl.target = self
        segmentControl.action = #selector(self.segmentControlChanged(segmentControl:))
        topBar.addSubview(segmentControl)
        
        self.addSubview(topBar)
    }
    
    @objc func segmentControlChanged(segmentControl: NSSegmentedControl) {
        
        let chooseDayChangeTo = segmentControl.selectedSegment;
        self.chooseDaily(dayNum: chooseDayChangeTo)
        
    }
}

extension BangumiList {
    func initBottomBar () {
        
        bottomBar.frame = NSRect.init(x: 0, y: 0, width: width, height: bottom_H)
        
        let updateBtn = NSButton.init(frame: NSRect.init(x: 10, y: 5, width: 20, height: 20))
        updateBtn.image = NSImage.init(named: "update")
        updateBtn.imageScaling = .scaleProportionallyUpOrDown
        updateBtn.isBordered = false
        updateBtn.target = self
        updateBtn.action = #selector(self.updateData)
        bottomBar.addSubview(updateBtn)
        
        weekBar.frame = NSRect.init(x: 40, y: 0, width: 220, height: 23)
        weekBar.isEditable = false
        weekBar.isBordered = false
        weekBar.backgroundColor = NSColor.clear
        weekBar.maximumNumberOfLines = 1
        weekBar.alignment = .center
        weekBar.textColor = NSColor(calibratedRed:0.89, green:0.40, blue:0.55, alpha:1.00)
        weekBar.font = NSFont.systemFont(ofSize: 16)
        bottomBar.addSubview(weekBar)
        
        
        let exitBtn = NSButton.init(frame: NSRect.init(x: 270, y: 5, width: 20, height: 20))
        exitBtn.image = NSImage.init(named: "exit")
        exitBtn.imageScaling = .scaleProportionallyUpOrDown
        exitBtn.isBordered = false
        exitBtn.target = self
        exitBtn.action = #selector(self.exitApp)
        bottomBar.addSubview(exitBtn)
        
        self.addSubview(bottomBar)
    }
    
    @objc func exitApp () {
        // 退出
        NSApplication.shared.terminate(self)
    }
    
    @objc func updateData () {
        // 重载数据
        bangumiAPI.fetchData { bangumiData in
            self.initData(bangumiData)
        }
    }
}



extension BangumiList {
    func initData(_ data: Array<Dictionary<String,Any>>) {
        DispatchQueue.main.sync {
            self.bangumiData = data;
            // 先用拿到的第一天数据
            self.chooseDaily(dayNum: 3)
            self.initTop(data)
        }
    }
    
    func chooseDaily (dayNum: Int) {
        
        let data = self.bangumiData
        let dailyData: Dictionary<String,Any> = data[dayNum]
        let seasons: Array<Dictionary<String,Any>> = dailyData["seasons"] as! Array<Dictionary<String,Any>>
        let weekStr: String = dailyData["weekStr"] as! String
        self.weekBar.stringValue = weekStr
        self.clearOldCell()
        self.updateList(seasons)
        self.updateBottomAndChoose(seasons,dayNum)
    }
    
    func clearOldCell () {
        var newCellArr = self.cellArr
        for value in newCellArr {
            let cell: BangumiCell = value as! BangumiCell
            cell.removeFromSuperview()
        }
        newCellArr.removeAll()
        self.cellArr = newCellArr
    }

    
    func updateList(_ seasons: Array<Dictionary<String,Any>>) {
        var newCellArr = Array<Any>()
        for (index,value) in seasons.enumerated() {
            let bangumiData = value
            let title: String = bangumiData["title"] as! String
            let des: String = bangumiData["pub_index"] as! String
            let time: String = bangumiData["pub_time"] as! String
            let cover: String = bangumiData["square_cover"] as! String
            let seasonId: Int = bangumiData["season_id"] as! Int
            
            let bangumiCell = BangumiCell()
            bangumiCell.frame = CGRect.init(x: 0, y: CGFloat(seasons.count - index - 1) * cell_H, width: width, height: cell_H)
            bangumiCell.titleLabel.stringValue = title
            bangumiCell.desLabel.stringValue = des
            bangumiCell.timeLabel.stringValue = time
            bangumiCell.imageView.image = NSImage.init(contentsOf: NSURL.init(string: cover)! as URL)
            bangumiCell.seasonId = seasonId
            bangumiCell.tapFunc(callBack: { (seasonId) in
                let linkUrl = "https://www.bilibili.com/bangumi/play/ss\(seasonId)"
                NSWorkspace.shared.open(NSURL.init(string: linkUrl)! as URL);
            })
            newCellArr.append(bangumiCell)
            self.dailyList.addSubview(bangumiCell)
        }
        self.cellArr = newCellArr;
    }
    
    func updateBottomAndChoose (_ seasons: Array<Dictionary<String,Any>>, _ chooseDay: Int) {
        NSAnimationContext.runAnimationGroup { (context) in
            context.duration = 0.1
            self.animator().setFrameSize(NSSize.init(width: width, height: bottom_H + block_H + top_H + CGFloat(seasons.count) * cell_H))
            dailyList.animator().setFrameSize(NSSize.init(width: width, height: CGFloat(seasons.count) * cell_H))
        }
        segmentControl.selectedSegment = chooseDay
    }
    
    func initTop (_ data: Array<Dictionary<String,Any>>) {
        for (index,value) in data.enumerated() {
            let dailyData: Dictionary<String,Any> = value
            let dateStr: String = dailyData["dateStr"] as! String
            segmentControl.setLabel(dateStr, forSegment: index)
        }
    }
}
