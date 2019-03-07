//
//  BangumiCell.swift
//  B2KMac
//
//  Created by 蒋一博 on 2019/3/6.
//  Copyright © 2019 dawninest. All rights reserved.
//

import Cocoa

typealias tapBlock = (Int) -> Void

class BangumiCell: NSView {
    
    var imageView = NSImageView()
    var titleLabel = NSTextField()
    var desLabel = NSTextField()
    var timeLabel = NSTextField()
    var seasonId = 0
    
    
    var tapCallBack: tapBlock?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        self.layer?.backgroundColor = NSColor.clear.cgColor
        
        imageView.frame = NSRect.init(x: 10, y: 10, width: 60, height: 60)
        imageView.wantsLayer = true;
        imageView.layer?.cornerRadius = 6;
        self.addSubview(imageView);
        
        
        titleLabel.frame = NSRect.init(x: 75, y: 50, width: 215, height: 20)
        titleLabel.isEditable = false
        titleLabel.isBordered = false
        titleLabel.backgroundColor = NSColor.clear
        titleLabel.maximumNumberOfLines = 1
        titleLabel.alignment = .left
        titleLabel.font = NSFont.systemFont(ofSize: 14)
        self.addSubview(titleLabel)
        
        timeLabel.frame = NSRect.init(x: 75, y: 30, width: 215, height: 15)
        timeLabel.isEditable = false
        timeLabel.isBordered = false
        timeLabel.backgroundColor = NSColor.clear
        timeLabel.maximumNumberOfLines = 1
        timeLabel.alignment = .left
        timeLabel.textColor = NSColor(calibratedRed:0.89, green:0.40, blue:0.55, alpha:1.00)
        timeLabel.font = NSFont.systemFont(ofSize: 14)
        self.addSubview(timeLabel)
        
        desLabel.frame = NSRect.init(x: 75, y: 10, width: 215, height: 15)
        desLabel.isEditable = false
        desLabel.isBordered = false
        desLabel.backgroundColor = NSColor.clear
        desLabel.maximumNumberOfLines = 1
        desLabel.alignment = .left
        desLabel.font = NSFont.systemFont(ofSize: 14)
        self.addSubview(desLabel)
        
        
    }
    
    override func mouseDown(with event: NSEvent) {
        tapCallBack!(self.seasonId)
    }
    
}

extension BangumiCell {
    func tapFunc(callBack: @escaping tapBlock) {
        tapCallBack = callBack
    }
}

