//
//  ToolButton.swift
//  B2KMac
//
//  Created by 蒋一博 on 2019/3/7.
//  Copyright © 2019 dawninest. All rights reserved.
//

import Cocoa

typealias btnTapBlock = () -> Void

class ToolButton: NSView {
    
    var btnImge = NSImageView()
    
    var btnType = 0
    
    var tapCallBack: btnTapBlock?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        btnImge.frame = NSRect.init(x: 5, y: 5, width: 20, height: 20)
       
        self.addSubview(btnImge);
    }
    
    override func mouseDown(with event: NSEvent) {
        tapCallBack!()
    }
    
}

extension ToolButton {
    func buttonTap(callBack: @escaping btnTapBlock) {
        tapCallBack = callBack
    }
}
