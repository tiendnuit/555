//
//  UIToastCenter.swift
//  ecoinsystem
//
//  Created by Delphinus on 6/1/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//
import UIKit

@objc open class UIToastCenter: NSObject {

    fileprivate var _queue: OperationQueue!

    fileprivate struct Singletone {
        static let defaultCenter = UIToastCenter()
    }
    
    open class func defaultCenter() -> UIToastCenter {
        return Singletone.defaultCenter
    }
    
    override init() {
        super.init()
        self._queue = OperationQueue()
        self._queue.maxConcurrentOperationCount = 1
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIToastCenter.deviceOrientationDidChange(_:)),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil
        )
    }
    
    open func addToast(_ toast: UIToast) {
        self._queue.addOperation(toast)
    }
    
    func deviceOrientationDidChange(_ sender: AnyObject?) {
        if self._queue.operations.count > 0 {
            let lastToast: UIToast = _queue.operations[0] as! UIToast
            lastToast.view.updateView()
        }
    }
}
